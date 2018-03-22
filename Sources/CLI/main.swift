//
//  main.swift
//  aaa
//
//  Created by Igor Makarov on 20/03/2018.
//

import Foundation
import SwiftPostal
import Commander

Group {
    $0.command("expand",
        Argument<String>("address", description: "Address to expand")
    ) { address in
        let results = Expander().expand(address: address)
        results.forEach { print($0) }
    }
}.run()


