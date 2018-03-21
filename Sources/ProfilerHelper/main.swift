//
//  main.swift
//  aaa
//
//  Created by Igor Makarov on 20/03/2018.
//

import Foundation
import SwiftPostal

let printEveryIteration = 10000

func test(houseNumber: Int) -> TimeInterval {
    var expander = Expander()
    if houseNumber % 2 == 0 {
        expander.languages = [ "en" ]
    } else {
        expander.languages = [ "fr" ]
    }
    let date1 = Date()
    let expansions = expander.expand(address: "\(houseNumber) S Rural")
    // uncomment to see everything slow down by over 2000X:
    // SwiftPostal.cleanup()

    let date2 = Date()
    if houseNumber % printEveryIteration == 0 || houseNumber % printEveryIteration == 1 {
        print("Expansions (\(expander.languages.joined(separator: ","))): \(expansions)")
    }
    return date2.timeIntervalSince(date1)
}

func main() {
    var houseNumber = 1
    var time: TimeInterval = 0
    while true {
        let timed = test(houseNumber: houseNumber)
        time += timed
        let average = time / Double(houseNumber)
        if houseNumber % printEveryIteration == 0 || houseNumber % printEveryIteration == 1 {
            print("Average: \(average * 1000)ms, samples: \(houseNumber)")
        }
        houseNumber += 1
    }
}

main()
