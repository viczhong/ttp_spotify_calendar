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
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var dateArray = [Date]()
    var today: Date!
    var startDate: Date!
//    var indexPathDirectory = [Int : Date]()
//    var daysDict = [Date : [Entry]]()
//    var entries = [Entry]()

    // MARK: - Init
    init(year: Int) {
        setUpYearView(year)
    }

//    func placeEntries() {
//        daysDict.removeAll()
//
//        for entry in entries {
//            var tempEntryArray = [Entry]()
//
//            if let existingArray = daysDict[entry.date] {
//                tempEntryArray = existingArray
//                tempEntryArray.append(entry)
//                daysDict[entry.date] = tempEntryArray
//            } else {
//                daysDict[entry.date] = [entry]
//            }
//        }
//
//        self.tableView.reloadData()
//    }

    func setUpYearView(_ year: Int) {
        let startDateComponents = DateComponents(year: year, month: 1, day: 1, hour: 12)
        let endDateComponents = DateComponents(year: year, month: 12, day: 31, hour: 12)
        let offsetComponents = DateComponents(day: 1)

        let startDate = calendar.date(from: startDateComponents)!
        let endDate = calendar.date(from: endDateComponents)!

        var currentDate = startDate
        var sectionCounter = 0
        dateArray = [currentDate]
//        indexPathDirectory[sectionCounter] = currentDate

        // Build a year's worth of Dates
        while currentDate.timeIntervalSince1970 < endDate.timeIntervalSince1970 {
            currentDate = calendar.date(byAdding: offsetComponents, to: currentDate)!
            dateArray.append(currentDate)
            sectionCounter += 1
//            indexPathDirectory[sectionCounter] = currentDate
        }


    }




}
