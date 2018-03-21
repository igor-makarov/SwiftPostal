import Clibpostal
import Foundation

struct Postal {
    private static var _initialized: Bool = false
    static var initialized: Bool {
        return _initialized || {
            _initialized = libpostal_setup() && libpostal_setup_language_classifier()
            return _initialized
            }()
    }
    
    fileprivate static func teardown() {
        libpostal_teardown()
        libpostal_teardown_language_classifier()
        _initialized = false
    }
}

// No point for it really
public func cleanup() {
    Postal.teardown()
}
