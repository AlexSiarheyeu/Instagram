//
//  Date+DisplayDate.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/16/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        var quotient: Int = 0
        var unit: String = ""
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        }
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
}
