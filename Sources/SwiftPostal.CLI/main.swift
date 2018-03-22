//
//  main.swift
//  CLI
//
//  Created by Igor Makarov on 20/03/2018.
//

import Foundation
import SwiftPostal
import Commander

let ALL_LANGUAGES_PLACEHOLDER = "All"

Group {
    $0.command("expand",
        Argument<String>("address", description: "Address to expand"),
        Option<String>("languages", default: ALL_LANGUAGES_PLACEHOLDER, description: "Narrow expansion down to specific languages, e.g. \"en fr\"")
    ) { (address: String, languages: String) in
        var expander = Expander()
        if languages != ALL_LANGUAGES_PLACEHOLDER {
            let languageList = languages.split(separator: " ").map { String($0) }
            if languageList.isEmpty {
                print("Invalid language list: \"\(languages)\"", stream: .stderr)
                exit(1)
            }
            expander.languages = languageList
        }
        let results = expander.expand(address: address)
        results.forEach { print($0) }
    }
}.run()



