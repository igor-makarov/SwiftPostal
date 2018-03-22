//
//  PrintToStream.swift
//  CLI
//
//  Created by Igor Makarov on 22/03/2018.
//

import Foundation

public enum StandardStream {
    case stdin
    case stdout
    case stderr
}

var standardOutput = FileHandle.standardOutput
var standardError = FileHandle.standardError

extension FileHandle : TextOutputStream {
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.write(data)
    }
}

public func print(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    stream: StandardStream
    ) {
    switch stream {
    case .stdin:  break
    case .stdout: _print(items, separator: separator, terminator: terminator, to: &standardOutput)
    case .stderr: _print(items, separator: separator, terminator: terminator, to: &standardError)
    }
}

private func _print<Target : TextOutputStream>(
    _ items: [Any],
    separator: String = " ",
    terminator: String = "\n",
    to output: inout Target
    ) {
    var prefix = ""
    output._lock()
    defer { output._unlock() }
    for item in items {
        output.write(prefix)
        print(item, separator: "", terminator: "", to: &output)
        prefix = separator
    }
    output.write(terminator)
}

