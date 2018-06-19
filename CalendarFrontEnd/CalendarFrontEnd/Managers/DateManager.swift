//
//  DateManager.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/16/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import Foundation

class DateManager {

    // MARK: Date-related properties
    let calender = Calendar.current
    let dateFormatter = DateFormatter()
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var monthYearString = "January"

    var daysArray = [Int?]()
    var numberOfDays = 0
    var placeholderDays = 0
    var screenRotation = ScreenRotation.portrait
    var eventsArray = [Event]()
    var monthDict = [Int : [Event]]()
    var currentMonth = 0
    var currentYear = 0
    var apiClient: APIRequestManager!

    // MARK: - Initialization
    init(_ apiRequestManager: APIRequestManager) {
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a zzz"
        apiClient = apiRequestManager
    }

    // MARK: - Calendar Setup and Date Routing
    func setUpMonth(_ date: Date, _ completion: @escaping ([DateEntry]) -> Void) {
        let year = calender.component(.year, from: date)
        let month = calender.component(.month, from: date)

        currentMonth = month
        currentYear = year

        let monthComponents = DateComponents(year: year, month: month, day: 1)
        let calculatedMonth = calender.date(from: monthComponents)!
        let range = calender.range(of: .day, in: .month, for: calculatedMonth)!
        let firstDayWeekday = calender.component(.weekday, from: calculatedMonth)

        placeholderDays = firstDayWeekday - 1
        numberOfDays = range.count 

        print("number of days: \(range.count), placeholders: \(placeholderDays)")
        populateNumberOfDaysInCalendar()
        calcuateMonthAndYear(month, year)

        getEvents { [weak self] events in
            DispatchQueue.main.async {
                if let events = events {
                    self?.eventsArray = events
                    self?.filterEventsIntoMonth(month, year)
                    if let screenRotation = self?.screenRotation, let dates = self?.populateDateEntries(screenRotation) {
                        completion(dates)
                    }
                }
            }
        }

        completion(self.populateDateEntries(self.screenRotation))
    }

    func populateDateEntries(_ rotation: ScreenRotation) -> [DateEntry] {
        let weekDaysLong = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let weekDaysShort = ["S", "M", "T", "W", "Th", "F", "Sa"]

        var dateArray = [DateEntry]()
        var actualDateCount = 1

        for day in 0..<daysArray.count {
            if let unwrappedDay = daysArray[day] {
                let date = DateEntry(dateStringShort: "\(weekDaysShort[day % 7]) - \(unwrappedDay)", dateStringLong: "\(weekDaysLong[day % 7]) - \(unwrappedDay)", placeholder: false, events: monthDict[actualDateCount], month: months[currentMonth - 1], date: actualDateCount, year: currentYear)

                dateArray.append(date)
                actualDateCount += 1
            } else {
                let date = DateEntry(dateStringShort: weekDaysShort[day % 7], dateStringLong: weekDaysLong[day % 7], placeholder: true, events: nil, month: nil, date: nil, year: nil)
                
                dateArray.append(date)
            }
        }

        return dateArray
    }

    func populateNumberOfDaysInCalendar() {
        daysArray.removeAll()

        for _ in 0..<placeholderDays {
            daysArray.append(nil)
        }

        for day in 1...numberOfDays {
            daysArray.append(day)
        }
    }

    // MARK: - Date and String manipulation
    func dateToTimeStrings(_ date: Date) -> (String, String) {
        dateFormatter.dateFormat = "MMMM d, yyyy"

        let dateString1 = dateFormatter.string(from: date)

        dateFormatter.dateFormat = "h:mm a"

        let dateString2 = dateFormatter.string(from: date)

        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a zzz"
        return (dateString1, dateString2)
    }

    func dateStringToTimeStrings(_ dateString: String) -> (String, String)? {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let convertedDate = dateFormatter.date(from: dateString)!

        dateFormatter.dateFormat = "MMMM d, yyyy"

        let dateString1 = dateFormatter.string(from: convertedDate)

        dateFormatter.dateFormat = "h:mm a"

        let dateString2 = dateFormatter.string(from: convertedDate)

        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a zzz"
        return (dateString1, dateString2)
    }

    func eventTimeStringToDate(_ dateString: String?, _ timeString: String? = nil) -> Date? {
        var date = String()
        var time = String()

        if let dateString = dateString {
            date = dateString
        }

        if let timeString = timeString {
            time = timeString
        } else {
            time = "12:00 PM"
        }

        return dateFormatter.date(from: "\(date) \(time) \(TimeZone.current.abbreviation()!)")
    }

    func calcuateMonthAndYear(_ month: Int, _ year: Int) {
        monthYearString = "\(months[month - 1]), \(year)"
    }

    func getHeaderString() -> String {
        return monthYearString
    }

    // MARK: - Event functions
    func filterEventsIntoMonth(_ month: Int, _ year: Int) {
        monthDict = [:]

        for event in eventsArray {
            guard event.month == month && event.year == year else { continue }

            if let existingArray = monthDict[event.day] {
                let eventsAtDay = existingArray + [event]
                monthDict[event.day] = eventsAtDay.sorted { $0.startTime > $1.startTime }
            } else {
                monthDict[event.day] = [event]
            }
        }
    }

    // MARK: - API functions
    func getEvents(_ completion: @escaping ([Event]?) -> Void) {
        apiClient.performDataTask(.Get, eventToPost: nil) { (data) in
            if let data = data {
                do {
                    let events = try JSONDecoder().decode([Event].self, from: data)
                    completion(events)
                }
                catch {
                    print(error)
                }
            }
        }
    }

    func getEventsAndFilterIntoDate(_ month: Int, _ day: Int, _ year: Int, completion: @escaping ([Event]) -> Void) {
        getEvents { (events) in

            DispatchQueue.main.async {
                if let events = events {
                    let filteredEvents = events.filter{ $0.month == month && $0.day == day && $0.year == year }

                    completion(filteredEvents)
                }
            }
        }
    }

    func performEventDataTask(_ title: String, startTimeDate: Date, endTimeDate: Date, date: Date, event: Event?, _ completion: @escaping () -> Void) {
        let startTime = dateToTimeStrings(startTimeDate).1
        let endTime = dateToTimeStrings(endTimeDate).1
        let dateString = dateToTimeStrings(date).0

        guard let dateForDateString = eventTimeStringToDate(dateString, startTime) else { return }

        let year = calender.component(.year, from: date)
        let month = calender.component(.month, from: date)
        let day = calender.component(.day, from: date)

        var requestType: RequestType!

        var id: String?

        if let eventID = event?.id {
            id = eventID
            requestType = .Put
        } else {
            requestType = .Post
        }

        let builtEvent = Event(id: id, startTime: startTime, endTime: endTime, year: year, month: month, day: day, title: title, dateTimeString: String(describing: dateForDateString))

        apiClient.performDataTask(requestType, eventToPost: builtEvent) { (data) in
            DispatchQueue.main.async {
                if let _ = data {
                    completion()
                }
            }
        }
    }

    func delete(_ event: Event, _ dateKnown: (month: Int, day: Int, year: Int)?, _ completion: @escaping ([Event]) -> Void) {
        apiClient.performDataTask(.Delete, eventToPost: event) { [weak self] (data) in
            DispatchQueue.main.async {
                if let _ = data {
                    if let dateKnown = dateKnown {
                        self?.getEventsAndFilterIntoDate(dateKnown.month, dateKnown.day, dateKnown.year, completion: { (events) in
                            completion(events)
                        })
                    } else {
                        self?.getEvents({ (events) in
                            if let events = events {
                                completion(events)
                            }
                        })
                    }
                }
            }
        }
    }

    // MARK: - Screen Rotation
    func rotated(_ rotation: ScreenRotation, _ completion: @escaping () -> Void) {
        screenRotation = rotation
        completion()
    }

}
