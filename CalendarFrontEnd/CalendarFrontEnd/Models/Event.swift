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

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case year = "year"
        case month = "month"
        case day = "day"
        case title = "title"
    }
}
