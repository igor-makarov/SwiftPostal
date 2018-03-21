//
//  main.swift
//  aaa
//
//  Created by Igor Makarov on 20/03/2018.
//

import Foundation
import SwiftPostal

public func autoreleasepoolShim<Result>(invoking body: () throws -> Result) rethrows -> Result {
    #if os(Linux)
    return try body()
    #else
    return try autoreleasepool(invoking: body)
    #endif
}

let printEveryIteration = 1000

func test(houseNumber: Int) -> TimeInterval {
    var expander = Expander()
    if houseNumber % 1000 > 500 {
        expander.languages = [ "en" ]
    } else {
        expander.languages = [ "fr" ]
    }
    let date1 = Date()
    let expansions = expander.expand(address: "V XX Settembre, \(houseNumber)")
    // uncomment to see everything slow down by over 2000X:
    // SwiftPostal.cleanup()

    let date2 = Date()
    if houseNumber % printEveryIteration == 0 {
        print("Expansions: \(expansions)")
    }
    return date2.timeIntervalSince(date1)
}

func main() {
    var houseNumber = 1
    var time: TimeInterval = 0
    while true {
        let timed = autoreleasepoolShim {
            return test(houseNumber: houseNumber)
        }
        time += timed
        let average = time / Double(houseNumber)
        houseNumber += 1
        if houseNumber % printEveryIteration == 0 {
            print("Average: \(average * 1000)ms")
        }
    }
}

main()
