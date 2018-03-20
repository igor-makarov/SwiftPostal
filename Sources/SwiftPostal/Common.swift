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
