//
//  Event.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/15/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import Foundation

struct Event: Codable {
    let id: Int
    let timeStart: String
    let timeEnd: String
    let year: Int
    let month: Int
    let day: Int
    let title: String

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case year = "year"
        case month = "month"
        case day = "day"
        case title = "title"
    }
}
