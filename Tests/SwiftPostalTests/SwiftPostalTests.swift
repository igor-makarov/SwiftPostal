import XCTest
@testable import SwiftPostal

func XCTAssert<T, SeqT>(sequence: SeqT, contains element: T, file: StaticString = #file, line: UInt = #line) where SeqT: Sequence, SeqT.Element == T, T: Equatable {
    for e in sequence {
        if e == element { return }
    }
    XCTFail(file: file, line: line)
}

class ExpansionTests: XCTestCase {
    func testExpandUSAddress() {
        let expansions = Expander().expand(address: "781 Franklin Ave Crown Hts Brooklyn NY")
        XCTAssert(sequence: expansions, contains: "781 franklin avenue crown heights brooklyn new york")
    }
    
    func testDedupeEquivalentAddress() {
        let expander = Expander()
        expander.languages = ["en"]
        XCTAssertEqual(expander.languages, ["en"])
        let expansions = Set(expander.expand(address: "30 West Twenty-sixth Street Floor Number 7"/*, {languages: ['en']}*/))
        let expansions2 = Set(expander.expand(address: "Thirty W 26th St Fl #7"/*, {languages: ['en']}*/))
        XCTAssertGreaterThan(expansions.intersection(expansions2).count, 0)
    }
    
    func testNonASCIIAddress() {
        let expansions = Expander().expand(address: "Friedrichstraße 128, Berlin, Germany")
        XCTAssert(sequence: expansions, contains: "friedrich strasse 128 berlin germany")
    }
    
    func testTransliteration() {
        let expansions = Expander().expand(address: "הרצל 8 ראשל״צ")
        XCTAssert(sequence: expansions, contains: "hrzl 8 rsl״z")
    }

    static let allTests = [
        ("testExpandUSAddress", testExpandUSAddress),
        ("testDedupeEquivalentAddress", testDedupeEquivalentAddress),
        ("testNonASCIIAddress", testNonASCIIAddress),
        ("testTransliteration", testTransliteration),
    ]
}
