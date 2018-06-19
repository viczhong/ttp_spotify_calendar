//
//  Event.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/15/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import Foundation

struct Event: Codable {
    let id: String?
    let startTime: String
    let endTime: String
    let year: Int
    let month: Int
    let day: Int
    let title: String
    let dateTimeString: String

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case year = "year"
        case month = "month"
        case day = "day"
        case title = "title"
        case dateTimeString = "date_time"
    }

    init(
        id: String?,
        startTime: String,
        endTime: String,
        year: Int,
        month: Int,
        day: Int,
        title: String,
        dateTimeString: String
        ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.year = year
        self.month = month
        self.day = day
        self.title = title
        self.dateTimeString = dateTimeString
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        startTime = try container.decode(String.self, forKey: .startTime)
        endTime = try container.decode(String.self, forKey: .endTime)
        year = try container.decode(Int.self, forKey: .year)
        month = try container.decode(Int.self, forKey: .month)
        day = try container.decode(Int.self, forKey: .day)
        title = try container.decode(String.self, forKey: .title)
        dateTimeString = try container.decode(String.self, forKey: .dateTimeString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(year, forKey: .year)
        try container.encode(month, forKey: .month)
        try container.encode(day, forKey: .day)
        try container.encode(title, forKey: .title)
        try container.encode(dateTimeString, forKey: .dateTimeString)
    }

}
