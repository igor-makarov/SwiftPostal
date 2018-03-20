import Clibpostal
import Foundation

struct Postal {
    static let initialized: Bool = {
        return libpostal_setup() && libpostal_setup_language_classifier()
    }()
}

// No point for it really
public func cleanup() {
    libpostal_teardown()
    libpostal_teardown_language_classifier()
}


public func withArrayOfCStrings<R>(
    _ args: [String],
    _ body: (UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>) -> R
    ) -> R {
    var cStrings = args.map { strdup($0) }
    cStrings.append(nil)
    defer {
        cStrings.forEach { free($0) }
    }
    return body(&cStrings)
}
