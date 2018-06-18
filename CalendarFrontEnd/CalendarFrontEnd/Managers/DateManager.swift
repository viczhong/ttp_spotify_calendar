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

    var daysArray = [Int?]()
    var numberOfDays = 0
    var placeholderDays = 0
    var monthYearString = "January"
    var screenRotation = ScreenRotation.portrait
    var eventsArray = [Event]()
    var monthDict = [Int : [Event]]()
    var currentMonth = 0
    var currentYear = 0

    let apiClient: APIRequestManager!

    // MARK: - Init
    init(_ date: Date, _ completion: @escaping ([DateEntry]) -> Void) {
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a zzz"
        apiClient = APIRequestManager()
        setUpMonth(date, completion)
    }

    func getEvents(_ completion: @escaping ([Event]?) -> Void) {
        apiClient.performDataTask(.get, events: nil) { data in
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


        //eventsArray = createMockEvents()
        getEvents { [unowned self] events in
            DispatchQueue.main.async {
                self.eventsArray = events!
                self.filterEventsIntoMonth(month, year)
                completion(self.populateDateEntries(self.screenRotation))
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

    func calcuateMonthAndYear(_ month: Int, _ year: Int) {


        monthYearString = "\(months[month - 1]), \(year)"
    }

    func getHeaderString() -> String {
        return monthYearString
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

    func rotated(_ rotation: ScreenRotation, _ completion: @escaping () -> Void) {
        screenRotation = rotation
        completion()
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

    // MARK: - START MOCKING
    func createMockEvents() -> [Event] {
        let event1 = Event(id: "1", startTime: "12:00 PM", endTime: "1:00 PM", year: 2018, month: 6, day: 1, title: "Study Swift")
        let event2 = Event(id: "2", startTime: "1:00 PM", endTime: "5:00 PM", year: 2018, month: 6, day: 1, title: "Study Swift")
        let event3 = Event(id: "3", startTime: "12:00 AM", endTime: "12:00 PM", year: 2018, month: 6, day: 1, title: "Study Swift")
        let event4 = Event(id: "1", startTime: "1:00 PM", endTime: "5:00 PM", year: 2018, month: 6, day: 18, title: "Study Swift")
        let event5 = Event(id: "1", startTime: "5:00 PM", endTime: "5:30 PM", year: 2018, month: 5, day: 18, title: "Study Swift")

        return [event1, event2, event3, event4, event5, event1, event1]
    }
    // MARK: - END MOCKING
}
