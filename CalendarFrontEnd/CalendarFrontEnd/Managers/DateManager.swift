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
    var dateArray = [Date]()
    var daysArray = [Int?]()
    var numberOfDays = 0
    var placeholderDays = 0
    private var screenRotation = Rotation.portrait
    var weekDaysLong = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var weekDaysShort = ["S", "M", "T", "W", "Th", "F", "Sa"]
    var month = "January"

    // MARK: - Init
    init(_ date: Date, _ completion: @escaping () -> Void) {
        setUpMonth(date, completion)
    }

    func setUpMonth(_ date: Date, _ completion: @escaping () -> Void) {
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
        calcuateMonth(month)
        completion()


        //        let startDateComponents = DateComponents(year: 2018, month: 1, day: 1, hour: 12)
        //        let endDateComponents = DateComponents(year: 2018, month: 12, day: 31, hour: 12)
        //        let offsetComponents = DateComponents(day: 1)
        //
        //        let startDate = calendar.date(from: startDateComponents)!
        //        let endDate = calendar.date(from: endDateComponents)!

        //        var currentDate = startDate
        //        var sectionCounter = 0
        //        dateArray = [currentDate]
        ////        indexPathDirectory[sectionCounter] = currentDate
        //
        //        // Build a year's worth of Dates
        //        while currentDate.timeIntervalSince1970 < endDate.timeIntervalSince1970 {
        //            currentDate = calendar.date(byAdding: offsetComponents, to: currentDate)!
        //            dateArray.append(currentDate)
        //            sectionCounter += 1
        ////            indexPathDirectory[sectionCounter] = currentDate
        //        }

    }

    func calcuateMonth(_ month: Int) {
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

        self.month = months[month - 1]
    }

    func getHeaderString() -> String {
        return "\(month), 2018"
    }

    func populateNumberOfDaysInCalendar() {
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
