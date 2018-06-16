//
//  Event.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/15/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import Foundation

class Event: Codable {
    let id: Int
    let timeStart: String
    let timeEnd: String
    let date: String
    let description: String

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case date = "date"
        case description = "description"
    }
}
