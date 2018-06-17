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
    var daysArray = [Int?]()
    var numberOfDays = 0
    var placeholderDays = 0

    var monthYearString = "January"
    var screenRotation = ScreenRotation.portrait
    var eventsArray = [Event]()
    var monthDict = [Int : [Event]]()

    // MARK: - Init
    init(_ date: Date, _ completion: @escaping ([DateEntry]) -> Void) {
        setUpMonth(date, completion)
    }

    func setUpMonth(_ date: Date, _ completion: @escaping ([DateEntry]) -> Void) {
        let year = calender.component(.year, from: date)
        let month = calender.component(.month, from: date)
        let monthComponents = DateComponents(year: year, month: month, day: 1)
        let calculatedMonth = calender.date(from: monthComponents)!
        let range = calender.range(of: .day, in: .month, for: calculatedMonth)!
        let firstDayWeekday = calender.component(.weekday, from: calculatedMonth)

        placeholderDays = firstDayWeekday - 1
        numberOfDays = range.count 

        print("number of days: \(range.count), placeholders: \(placeholderDays)")
        populateNumberOfDaysInCalendar()
        calcuateMonthAndYear(month, year)
        eventsArray = createMockEvents()
        filterEventsIntoMonth(month, year)

        completion(populateDateEntries(screenRotation))
    }

    func populateDateEntries(_ rotation: ScreenRotation) -> [DateEntry] {
        let weekDaysLong = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let weekDaysShort = ["S", "M", "T", "W", "Th", "F", "Sa"]

        var dateArray = [DateEntry]()
        var actualDateCount = 1

        for day in 0..<daysArray.count {
            if let unwrappedDay = daysArray[day] {
                let date = DateEntry(dateStringShort: "\(weekDaysShort[day % 7]) - \(unwrappedDay)", dateStringLong: "\(weekDaysLong[day % 7]) - \(unwrappedDay)", placeholder: false, events: monthDict[actualDateCount])

                dateArray.append(date)
                actualDateCount += 1
            } else {
                let date = DateEntry(dateStringShort: weekDaysShort[day % 7], dateStringLong: weekDaysLong[day % 7], placeholder: true, events: nil)
                
                dateArray.append(date)
            }
        }

        return dateArray
    }

    func calcuateMonthAndYear(_ month: Int, _ year: Int) {
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

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
                monthDict[event.day] = eventsAtDay.sorted { $0.timeStart > $1.timeStart }
            } else {
                monthDict[event.day] = [event]
            }
        }
    }

    // MARK: - START MOCKING
    func createMockEvents() -> [Event] {
        let event1 = Event(id: 1, timeStart: "12:00 PM", timeEnd: "night", year: 2018, month: 6, day: 1, description: "Study Swift")
        let event2 = Event(id: 2, timeStart: "1:00 PM", timeEnd: "night", year: 2018, month: 6, day: 1, description: "Study Swift")
        let event3 = Event(id: 3, timeStart: "12:00 AM", timeEnd: "night", year: 2018, month: 6, day: 1, description: "Study Swift")
        let event4 = Event(id: 1, timeStart: "morning", timeEnd: "night", year: 2018, month: 6, day: 18, description: "Study Swift")
        let event5 = Event(id: 1, timeStart: "morning", timeEnd: "night", year: 2018, month: 5, day: 18, description: "Study Swift")

        return [event1, event2, event3, event4, event5, event1, event1]
    }
    // MARK: - END MOCKING
}
