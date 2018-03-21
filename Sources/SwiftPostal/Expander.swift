//
//  Expand.swift
//  SwiftPostal
//
//  Created by Igor Makarov on 19/03/2018.
//

import Clibpostal
import Foundation

public class Expander {
    private var options = libpostal_get_default_options()
    
    public struct AddressComponents: OptionSet {
        public typealias RawValue = Int16
        public let rawValue: Int16
        
        public init(rawValue: Int16) {
            self.rawValue = rawValue
        }
        
        static let NONE = AddressComponents(rawValue: 0)
        static let ANY = AddressComponents(rawValue: (1 << 0))
        static let NAME = AddressComponents(rawValue: (1 << 1))
        static let HOUSE_NUMBER = AddressComponents(rawValue: (1 << 2))
        static let STREET = AddressComponents(rawValue: (1 << 3))
        static let UNIT = AddressComponents(rawValue: (1 << 4))
        static let LEVEL = AddressComponents(rawValue: (1 << 5))
        static let STAIRCASE = AddressComponents(rawValue: (1 << 6))
        static let ENTRANCE = AddressComponents(rawValue: (1 << 7))
        
        static let CATEGORY = AddressComponents(rawValue: (1 << 8))
        static let NEAR = AddressComponents(rawValue: (1 << 9))
        
        static let TOPONYM = AddressComponents(rawValue: (1 << 13))
        static let POSTAL_CODE = AddressComponents(rawValue: (1 << 14))
        static let PO_BOX = AddressComponents(rawValue: (1 << 15))
        static let ALL = AddressComponents(rawValue: ((1 << 16) - 1))

    }

    // List of language codes
    public var languages: [String] {
        get {
            guard options.num_languages > 0 else { return [] }
            return options.languages.withMemoryRebound(to: UnsafePointer<UInt8>.self, capacity: options.num_languages) {
                var result = [String]()
                for i in 0..<options.num_languages {
                    let string = String(cString: $0[i])
                    result.append(string)
                }
                return result
            }
        }
        set {
            freeLanguagesIfNeeded()
            let buffer = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: newValue.count)
            for i in 0..<newValue.count {
                let str = NSString(string: newValue[i]).utf8String
                buffer.advanced(by: i).pointee = UnsafeMutablePointer<Int8>(mutating: str)
            }
            options.languages = buffer
            options.num_languages = newValue.count
        }
    }
    
    private func freeLanguagesIfNeeded() {
        guard options.num_languages > 0 else { return }
        options.languages.deallocate()
    }
    
    deinit {
        freeLanguagesIfNeeded()
    }
   
    public var addressComponents: AddressComponents {
        get { return AddressComponents(rawValue: Int16(bitPattern: options.address_components)) }
        set { options.address_components = UInt16(bitPattern: newValue.rawValue) }
    }
    
    // String options
    public var latinASCII: Bool { get { return options.latin_ascii } set { options.latin_ascii = newValue } }
    
    public var transliterate: Bool { get { return options.transliterate } set { options.transliterate = newValue } }
    
    public var stripAccents: Bool { get { return options.strip_accents } set { options.strip_accents = newValue } }
    
    public var decompose: Bool { get { return options.decompose } set { options.decompose = newValue } }
    
    public var lowercase: Bool { get { return options.lowercase } set { options.lowercase = newValue } }
    
    public var trimString: Bool { get { return options.trim_string } set { options.trim_string = newValue } }
    
    public var dropParentheticals: Bool { get { return options.drop_parentheticals } set { options.drop_parentheticals = newValue } }
    
    public var replaceNumericHyphens: Bool { get { return options.replace_numeric_hyphens } set { options.replace_numeric_hyphens = newValue } }
    
    public var deleteNumericHyphens: Bool { get { return options.delete_numeric_hyphens } set { options.delete_numeric_hyphens = newValue } }
    
    public var splitAlphaFromNumeric: Bool { get { return options.split_alpha_from_numeric } set { options.split_alpha_from_numeric = newValue } }
    
    public var replaceWordHyphens: Bool { get { return options.replace_word_hyphens } set { options.replace_word_hyphens = newValue } }
    
    public var deleteWordhyphens: Bool { get { return options.delete_word_hyphens } set { options.delete_word_hyphens = newValue } }
    
    public var deleteFinalPeriods: Bool { get { return options.delete_final_periods } set { options.delete_final_periods = newValue } }
    
    public var deleteAcronymPeriods: Bool { get { return options.delete_acronym_periods } set { options.delete_acronym_periods = newValue } }
    
    public var dropEnglishPossessives: Bool { get { return options.drop_english_possessives } set { options.drop_english_possessives = newValue } }
    
    public var deleteApostrophes: Bool { get { return options.delete_apostrophes } set { options.delete_apostrophes = newValue } }
    
    public var expandNumex: Bool { get { return options.expand_numex } set { options.expand_numex = newValue } }
    
    public var romanNumerals: Bool { get { return options.roman_numerals } set { options.roman_numerals = newValue } }
    
    public init() {
        precondition(Postal.initialized)
    }
    
    public func expand(address: String) -> [String] {
        var num_expansions: Int = 0
        let cs = NSString(string: address).utf8String
        let ptr = UnsafeMutablePointer<Int8>(mutating: cs)
        guard let expansions = libpostal_expand_address(ptr, options, &num_expansions) else { return [] }
        guard num_expansions > 0 else { return [] }
        let result = expansions.withMemoryRebound(to: UnsafePointer<Int8>.self, capacity: num_expansions) { exp -> [String] in
            var r = [String]()
            for i in 0..<num_expansions {
                let str = String(cString: exp[i])
                r.append(str)
            }
            return r
        }
        libpostal_expansion_array_destroy(expansions, num_expansions)
        return result
    }
}


