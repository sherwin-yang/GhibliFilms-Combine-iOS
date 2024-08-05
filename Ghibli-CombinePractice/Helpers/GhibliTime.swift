//
//  GhibliTime.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/19/24.
//

import Foundation

struct GhibliTime {
    static func toHourMinute(_ time: Int?) -> String {
        guard let time else { return "NA"}
        return "\(time/60)h" + ", " + "\(time%60)m"
    }
}
