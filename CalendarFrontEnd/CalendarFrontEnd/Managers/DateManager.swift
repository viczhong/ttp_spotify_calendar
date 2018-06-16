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
    var weekDaysLong = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var weekDaysShort = ["S", "M", "T", "W", "Th", "F", "Sa"]
    var monthYearString = "January"
    var screenRotation = ScreenRotation.portrait

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
        numberOfDays = range.count + placeholderDays

        print("number of days: \(range.count), placeholders: \(placeholderDays)")
        populateNumberOfDaysInCalendar()
        calcuateMonthAndYear(month, year)
        completion(populateDateEntries(screenRotation))

    }

    func populateDateEntries(_ rotation: ScreenRotation) -> [DateEntry] {
        var dateArray = [DateEntry]()
        var weekdaysToDisplay = [String]()

        if rotation == .portrait {
            weekdaysToDisplay = weekDaysShort
        } else {
            weekdaysToDisplay = weekDaysLong
        }

        for day in 0..<daysArray.count {
            if let unwrappedDay = daysArray[day] {
                let date = DateEntry(dateString: "\(weekdaysToDisplay[day % 7]) - \(unwrappedDay)", placeholder: false, events: nil, eventString: "No events")
                dateArray.append(date)
            } else {
                let date = DateEntry(dateString: weekdaysToDisplay[day % 7], placeholder: true, events: nil, eventString: nil)
                dateArray.append(date)
            }
        }


        return dateArray
    }

    func calcuateMonthAndYear(_ month: Int, _ year: Int) {
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

        self.monthYearString = "\(months[month - 1]), \(year)"
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


}
