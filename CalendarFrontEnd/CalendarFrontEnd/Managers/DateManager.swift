//
//  DateManager.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/16/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import Foundation

class DateManager {

    enum Rotation {
        case landscape, portrait
    }

    // MARK: Date-related properties
    let calender = Calendar.current
    let dateFormatter = DateFormatter()
    var daysArray = [Int?]()
    var numberOfDays = 0
    var placeholderDays = 0
    private var screenRotation = Rotation.portrait
    var weekDaysLong = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var weekDaysShort = ["S", "M", "T", "W", "Th", "F", "Sa"]
    var monthYearString = "January"

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
//        populateDateEntries(screenRotation)
        completion(populateDateEntries(screenRotation))

    }

    func populateDateEntries(_ rotation: Rotation) -> [DateEntry] {
        var dateArray = [DateEntry]()

        if rotation == .portrait {
            for day in 0..<daysArray.count {
                if let unwrappedDay = daysArray[day] {
                    let date = DateEntry(dateString: "\(weekDaysShort[day % 7]) - \(unwrappedDay)", placeholder: false)
                    dateArray.append(date)
                } else {
                    let date = DateEntry(dateString: weekDaysShort[day % 7], placeholder: true)
                    dateArray.append(date)
                }
            }
        } else {
            for day in 0..<daysArray.count {
                if let unwrappedDay = daysArray[day] {
                    let date = DateEntry(dateString: "\(weekDaysLong[day % 7]) - \(unwrappedDay)", placeholder: false)
                    dateArray.append(date)
                } else {
                    let date = DateEntry(dateString: weekDaysLong[day % 7], placeholder: true)
                    dateArray.append(date)
                }
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

    func calculateWeekday(_ indexPath: IndexPath) -> String {
        // TODO: Figure out Rotation

//        switch screenRotation {
//        case .portrait:

        if let date = daysArray[indexPath.row] {
            return "\(weekDaysShort[indexPath.row % 7]) - \(date)"
        } else {
            return weekDaysShort[indexPath.row % 7]
        }
//        case .landscape:
//            return weekDaysLong[indexPath.row % 7]
//        }
    }

    func rotated(_ rotation: Rotation, _ completion: @escaping () -> Void) {
        screenRotation = rotation
    }


}
