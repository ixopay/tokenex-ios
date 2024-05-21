import Foundation

/// The token scheme to use when tokenizing data.
///
/// See [Vaulted Token Schemes](https://docs.tokenex.com/docs/token-schemes) for a description of the available
/// token schemes.
@objc
public enum TXTokenScheme: Int, CustomStringConvertible {
    case PCI = 1
    case sixANTOKENfour = 2
    case sixTOKENfour = 3
    case sixTOKENfourNonLuhn = 4
    case sixNTOKENfour = 5
    case sixASCIITOKENfour = 6
    case fourANTOKENfour = 7
    case fourTOKENfour = 8
    case fourTOKENfourNonLuhn = 9
    case fourNTOKENfour = 10
    case fourASCIITOKENfour = 11
    case ANTOKEN = 12
    case ANTOKENfour = 13
    case ANTOKENAUTO = 14
    case ASCIITOKEN = 15
    case ASCIITOKENfour = 16
    case ASCIITOKENAUTO = 17
    case GUID = 18
    case nGUID = 19
    case nTOKEN = 20
    case nTOKENfour = 21
    case nTOKENfour1to1 = 22
    case nTOKENAUTO = 23
    case SSN = 24
    case TOKEN = 25
    case TOKENfour = 26
    case TOKENfourNonLuhn = 27
    case ThreeTwo = 28  // swiftlint:disable:this identifier_name

    private static let stringMap: [Self: String] = [
        .PCI: "PCI",
        .sixANTOKENfour: "sixANTOKENfour",
        .sixTOKENfour: "sixTOKENfour",
        .sixTOKENfourNonLuhn: "sixTOKENfourNonLuhn",
        .sixNTOKENfour: "sixNTOKENfour",
        .sixASCIITOKENfour: "sixASCIITOKENfour",
        .fourANTOKENfour: "fourANTOKENfour",
        .fourTOKENfour: "fourTOKENfour",
        .fourTOKENfourNonLuhn: "fourTOKENfourNonLuhn",
        .fourNTOKENfour: "fourNTOKENfour",
        .fourASCIITOKENfour: "fourASCIITOKENfour",
        .ANTOKEN: "ANTOKEN",
        .ANTOKENfour: "ANTOKENfour",
        .ANTOKENAUTO: "ANTOKENAUTO",
        .ASCIITOKEN: "ASCIITOKEN",
        .ASCIITOKENfour: "ASCIITOKENfour",
        .ASCIITOKENAUTO: "ASCIITOKENAUTO",
        .GUID: "GUID",
        .nGUID: "nGUID",
        .nTOKEN: "nTOKEN",
        .nTOKENfour: "nTOKENfour",
        .nTOKENfour1to1: "nTOKENfour1to1",
        .nTOKENAUTO: "nTOKENAUTO",
        .SSN: "SSN",
        .TOKEN: "TOKEN",
        .TOKENfour: "TOKENfour",
        .TOKENfourNonLuhn: "TOKENfourNonLuhn",
        .ThreeTwo: "ThreeTwo",
    ]
    private static let reverseMap: [String: Self] = [
        "PCI": .PCI,
        "sixANTOKENfour": .sixANTOKENfour,
        "sixTOKENfour": .sixTOKENfour,
        "sixTOKENfourNonLuhn": .sixTOKENfourNonLuhn,
        "sixNTOKENfour": .sixNTOKENfour,
        "sixASCIITOKENfour": .sixASCIITOKENfour,
        "fourANTOKENfour": .fourANTOKENfour,
        "fourTOKENfour": .fourTOKENfour,
        "fourTOKENfourNonLuhn": .fourTOKENfourNonLuhn,
        "fourNTOKENfour": .fourNTOKENfour,
        "fourASCIITOKENfour": .fourASCIITOKENfour,
        "ANTOKEN": .ANTOKEN,
        "ANTOKENfour": .ANTOKENfour,
        "ANTOKENAUTO": .ANTOKENAUTO,
        "ASCIITOKEN": .ASCIITOKEN,
        "ASCIITOKENfour": .ASCIITOKENfour,
        "ASCIITOKENAUTO": .ASCIITOKENAUTO,
        "GUID": .GUID,
        "nGUID": .nGUID,
        "nTOKEN": .nTOKEN,
        "nTOKENfour": .nTOKENfour,
        "nTOKENfour1to1": .nTOKENfour1to1,
        "nTOKENAUTO": .nTOKENAUTO,
        "SSN": .SSN,
        "TOKEN": .TOKEN,
        "TOKENfour": .TOKENfour,
        "TOKENfourNonLuhn": .TOKENfourNonLuhn,
        "ThreeTwo": .ThreeTwo,
    ]

    public var description: String {
        Self.stringMap[self]!
    }

    public static func fromString(_ string: String) -> Self? {
        Self.reverseMap[string]
    }
}

extension TXTokenScheme: CaseIterable {
}

extension TXTokenScheme: Codable {
}

@objc
public class TXTokeneSchemeUtilities: NSObject {
    /// Returns a string representation for the provided token scheme.
    @objc(stringFromTokenScheme:)
    public static func stringFrom(_ tokenScheme: TXTokenScheme) -> String? {
        tokenScheme.description
    }

    deinit {}
}
