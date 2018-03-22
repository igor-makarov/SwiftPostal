import XCTest
@testable import SwiftPostal

func XCTAssert<T, SeqT>(sequence: SeqT, contains element: T, file: StaticString = #file, line: UInt = #line) where SeqT: Sequence, SeqT.Element == T, T: Equatable {
    for e in sequence {
        if e == element { return }
    }
    XCTFail(file: file, line: line)
}

func XCTAssert<T, SeqT>(sequence: SeqT, doesNotContain element: T, file: StaticString = #file, line: UInt = #line) where SeqT: Sequence, SeqT.Element == T, T: Equatable {
    for e in sequence {
        if e == element { XCTFail(file: file, line: line) }
    }
}

class ExpansionTests: XCTestCase {
    func testExpandUSAddress() {
        let expansions = Expander().expand(address: "781 Franklin Ave Crown Hts Brooklyn NY")
        XCTAssert(sequence: expansions, contains: "781 franklin avenue crown heights brooklyn new york")
    }
    
    func testDedupeEquivalentAddress() {
        var expander = Expander()
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

    func testPerLanguageExpansion() {
        var expander = Expander()
        expander.languages = ["en"]
        let expansionsEn = expander.expand(address: "30 s rural")
        XCTAssert(sequence: expansionsEn, contains: "30 south rural")
        XCTAssert(sequence: expansionsEn, doesNotContain: "30 sud rural")
        expander.languages = ["fr"]
        let expansionsFr = expander.expand(address: "30 s rural")
        XCTAssert(sequence: expansionsFr, contains: "30 sud rural")
        XCTAssert(sequence: expansionsFr, doesNotContain: "30 south rural")
    }
    
    func testLanguageArrayBridging() {
        var expander = Expander()
        XCTAssertEqual(expander.languages, [])
        expander.languages = ["en", "fr"]
        XCTAssertEqual(expander.languages, ["en", "fr"])
        expander.languages.append("de")
        XCTAssertEqual(expander.languages, ["en", "fr", "de"])
        expander.languages = []
        XCTAssertEqual(expander.languages, [])
    }

    static let allTests = [
        ("testExpandUSAddress", testExpandUSAddress),
        ("testDedupeEquivalentAddress", testDedupeEquivalentAddress),
        ("testNonASCIIAddress", testNonASCIIAddress),
        ("testTransliteration", testTransliteration),
        ("testLanguageArrayBridging", testLanguageArrayBridging),
        ("testPerLanguageExpansion", testPerLanguageExpansion),
    ]
}
