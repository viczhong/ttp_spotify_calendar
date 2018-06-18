//
//  DateEntry.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/15/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import Foundation

struct DateEntry {
    let dateStringShort: String
    let dateStringLong: String
    let placeholder: Bool
    let events: [Event]?
    let month: String?
    let date: Int?
    let year: Int?

}
