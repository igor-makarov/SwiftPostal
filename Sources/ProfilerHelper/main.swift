//
//  main.swift
//  aaa
//
//  Created by Igor Makarov on 20/03/2018.
//

import Foundation
import SwiftPostal

extension TimeInterval {
    init(machTime: UInt64) {
        var timeBaseInfo = mach_timebase_info_data_t()
        mach_timebase_info(&timeBaseInfo)
        let nanoseconds = machTime * UInt64(timeBaseInfo.numer) / UInt64(timeBaseInfo.denom);
        self.init(Double(nanoseconds) / 1000)
    }
}

var i = 1
var time: TimeInterval = 0
while true {
    autoreleasepool {
        let expander = Expander()
        if i % 1000 > 500 {
            expander.languages = [ "en" ]
        } else {
            expander.languages = [ "fr" ]
        }
        let time1 = mach_absolute_time()
        let expansions = expander.expand(address: "V XX Settembre, \(i)")
        let time2 = mach_absolute_time()
        var average: TimeInterval = 0
        if i > 100000 {
            time += TimeInterval(machTime: time2 - time1)
            average = time / Double(i - 100000)
        }
        switch i % 1000 {
        case 500...501:
            print("Language: \(expander.languages), expansions: \(expansions), avg time: \(average)")
        default:
            break
        }
        i += 1
    }
}

