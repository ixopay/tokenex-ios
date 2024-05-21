import Foundation

@objc
public class TXBINLookupResponse: NSObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case error = "Error"
        case success = "Success"
        case referenceNumber = "ReferenceNumber"
        case binData = "BinData"
    }

    @objc public private(set) var error: String?
    @objc public private(set) var success = false
    @objc public private(set) var referenceNumber: String?

    @objc public private(set) var binData: TXBINData?

    override public var debugDescription: String {
        if success {
            // swiftlint:disable:next line_length
            "<TXBINLookupResponse: binData=\(binData?.debugDescription ?? "nil") referenceNumber=\(referenceNumber ?? "nil")>"
        } else {
            "<TXBINLookupResponse: error=\(error ?? "nil") referenceNumber=\(referenceNumber ?? "nil")>"
        }
    }

    deinit {}
}

@objc
public class TXBINData: NSObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case binMin = "BinMin"
        case binMax = "BinMax"
        case binLength = "BinLength"
        case cleanBankName = "CleanBankName"
        case productName = "ProductName"
        case cardBrand = "CardBrand"
        case countryAlpha2 = "CountryAlpha2"
        case countryName = "CountryName"
        case countryNumeric = "CountryNumeric"
        case type = "Type"
        case bankName = "BankName"
        case bankURL = "BankUrl"
        case bankPhone = "BankPhone"
        case productCode = "ProductCode"
        case prepaid = "Prepaid"
        case regulated = "Regulated"
        case regulatedName = "RegulatedName"
        case reloadable = "Reloadable"
        case panOrToken = "PanOrToken"
        case accountUpdater = "AccountUpdater"
        case alm = "Alm"
        case domesticOnly = "DomesticOnly"
        case gamblingBlocked = "GamblingBlocked"
        case level2 = "Level2"
        case level3 = "Level3"
        case issuerCurrency = "IssuerCurrency"
        case cardSegmentType = "CardSegmentType"
        case comboCard = "ComboCard"
        case cardBrandIsAdditional = "CardBrandIsAdditional"
        case correlationID = "CorrelationId"
        case sharedBin = "SharedBin"
        case cost = "Cost"
        case authentication = "Authentication"
        case additionalCardBrands = "AdditionalCardBrands"
    }

    // swiftlint:disable discouraged_optional_boolean
    /// The minimum account number for this BIN's assigned account number range.
    @objc public private(set) var binMin: String?
    /// The maximum account number for this BIN's assigned account number range.
    @objc public private(set) var binMax: String?
    /// The length of the BIN (typically 4, 6, or 8).
    public private(set) var binLength: UInt?
    /// Normalized bank name that has been formatted to proper case, removes unnecessary punctuation and misspellings,
    /// and spells out uncommon banking acronyms.
    @objc public private(set) var cleanBankName: String?
    /// The name of the [card product](https://docs.tokenex.com/docs/bin-lookup-overview#card-products).
    @objc public private(set) var productName: String?
    /// The primary card network that can process this card.
    @objc public private(set) var cardBrand: String?
    /// Two letter country code representing the issuing country; Alpha 2 code meets the ISO3166 standards.
    @objc public private(set) var countryAlpha2: String?
    /// Country in which the issuing bank resides.
    @objc public private(set) var countryName: String?
    /// Numeric country code representing the issuing country; the numeric country code meets ISO 3166 standards.
    @objc public private(set) var countryNumeric: String?
    /// Type of Payment Card.
    @objc public private(set) var type: String?
    /// Name of Issuing Bank.
    @objc public private(set) var bankName: String?
    /// URL of issuing bank website.
    @objc public private(set) var bankURL: String?
    /// Phone number of issuing bank.
    @objc public private(set) var bankPhone: String?
    /// The [card product ID](https://docs.tokenex.com/docs/bin-lookup-overview#card-products) according to the
    /// card brand.
    @objc public private(set) var productCode: String?
    /// Prepaid card type indicator.
    public private(set) var prepaid: Bool?
    /// Indicator of the presence of an interchange regulation on a BIN.
    public private(set) var regulated: Bool?
    /// The name of the interchange regulation.
    @objc public private(set) var regulatedName: String?
    /// (Visa-only field) Indicator of reloadable or non-reloadable prepaid
    public private(set) var reloadable: Bool?
    /// Indicates if an account number is a network token.
    @objc public private(set) var panOrToken: String?
    /// (Visa-only field) Visa Account Updater (VAU) enabled.
    public private(set) var accountUpdater: Bool?
    /// (Visa-only field) Indicator of a BIN or Account Range participating in Account Level Management.
    public private(set) var alm: Bool?
    /// (Visa-only field) Domestic-only BIN can only be used within the country in which the card was issued.
    public private(set) var domesticOnly: Bool?
    /// (Visa-only field) Indicator that this BIN is not permitted to be used for online gambling.
    public private(set) var gamblingBlocked: Bool?
    /// (Visa-only field) Indicator of Level 2 interchange rate eligibility.
    public private(set) var level2: Bool?
    /// (Visa-only field) Indicator of Level 3 interchange rate eligibility.
    public private(set) var level3: Bool?
    /// The currency that was issued to this BIN to transact in.
    @objc public private(set) var issuerCurrency: String?
    /// Indicates if card is a consumer card or commercial card.
    @objc public private(set) var cardSegmentType: String?
    /// Indicator for a card that has combined card type capabilities.
    @objc public private(set) var comboCard: String?
    /// The card has both a primary and secondary card network associated with it.
    /// The primary card brand for the BIN will be one of the main card brands—Visa, Mastercard, Amex, and Discover;
    /// the secondary is typically a pinless debit network or a regional brand (e.g. ETPOS, Dankort, Carte Bancaire).
    public private(set) var cardBrandIsAdditional: Bool?
    /// ID that maps a BIN range to a specific network file; used for troubleshooting.
    @objc public private(set) var correlationID: String?
    /// Set to true if BIN is shared by multiple issuers.
    public private(set) var sharedBin: Bool?
    @objc public private(set) var cost: [TXBINCost] = []
    @objc public private(set) var authentication: [TXBINAuthentication] = []
    /// List of any secondary card networks which fall into the same range as the primary card network.
    /// Are indicated by ``cardBrandIsAdditional`` being `true`.
    @objc public private(set) var additionalCardBrands: [TXBINAdditionalCardBrand] = []
    // swiftlint:enable discouraged_optional_boolean

    // we cannot bridge UInt? to Objective-C so we have to resort to a NSNumber*
    @objc public var binLengthBridged: NSNumber? {  // swiftlint:disable:this legacy_objc_type
        guard let binLength else {
            return nil
        }
        return NSNumber(value: binLength)  // swiftlint:disable:this legacy_objc_type
    }

    // we cannot bridge Bool? to Objective-C so we have to resort to a NSNumber*

    // swiftlint:disable legacy_objc_type
    /// See ``prepaid``.
    @objc public var prepaidBridged: NSNumber? {
        toNSNumber(prepaid)
    }
    /// See ``regulated``.
    @objc public var regulatedBridged: NSNumber? {
        toNSNumber(regulated)
    }
    /// See ``reloadable``.
    @objc public var reloadableBridged: NSNumber? {
        toNSNumber(reloadable)
    }
    /// See ``accountUpdater``.
    @objc public var accountUpdaterBridged: NSNumber? {
        toNSNumber(accountUpdater)
    }
    /// See ``alm``.
    @objc public var almBridged: NSNumber? {
        toNSNumber(alm)
    }
    /// See ``domesticOnly``.
    @objc public var domesticOnlyBridged: NSNumber? {
        toNSNumber(domesticOnly)
    }
    /// See ``gamblingBlocked``.
    @objc public var gamblingBlockedBridged: NSNumber? {
        toNSNumber(gamblingBlocked)
    }
    /// See ``level2``.
    @objc public var level2Bridged: NSNumber? {
        toNSNumber(level2)
    }
    /// See ``level3``.
    @objc public var level3Bridged: NSNumber? {
        toNSNumber(level3)
    }
    /// See ``cardBrandIsAdditional``.
    @objc public var cardBrandIsAdditionalBridged: NSNumber? {
        toNSNumber(cardBrandIsAdditional)
    }
    /// See ``sharedBin``.
    @objc public var sharedBinBridged: NSNumber? {
        toNSNumber(sharedBin)
    }
    // swiftlint:enable legacy_objc_type

    override public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.binMin = try container.decodeIfPresent(String.self, forKey: .binMin)
        self.binMax = try container.decodeIfPresent(String.self, forKey: .binMax)
        self.binLength = try container.decodeIfPresent(UInt.self, forKey: .binLength)
        self.cleanBankName = try container.decodeIfPresent(String.self, forKey: .cleanBankName)
        self.productName = try container.decodeIfPresent(String.self, forKey: .productName)
        self.cardBrand = try container.decodeIfPresent(String.self, forKey: .cardBrand)
        self.countryAlpha2 = try container.decodeIfPresent(String.self, forKey: .countryAlpha2)
        self.countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        self.countryNumeric = try container.decodeIfPresent(String.self, forKey: .countryNumeric)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.bankName = try container.decodeIfPresent(String.self, forKey: .bankName)
        self.bankURL = try container.decodeIfPresent(String.self, forKey: .bankURL)
        self.bankPhone = try container.decodeIfPresent(String.self, forKey: .bankPhone)
        self.productCode = try container.decodeIfPresent(String.self, forKey: .productCode)
        self.prepaid = try container.decodeIfPresent(Bool.self, forKey: .prepaid)
        self.regulated = try container.decodeIfPresent(Bool.self, forKey: .regulated)
        self.regulatedName = try container.decodeIfPresent(String.self, forKey: .regulatedName)
        self.reloadable = try container.decodeIfPresent(Bool.self, forKey: .reloadable)
        self.panOrToken = try container.decodeIfPresent(String.self, forKey: .panOrToken)
        self.accountUpdater = try container.decodeIfPresent(Bool.self, forKey: .accountUpdater)
        self.alm = try container.decodeIfPresent(Bool.self, forKey: .alm)
        self.domesticOnly = try container.decodeIfPresent(Bool.self, forKey: .domesticOnly)
        self.gamblingBlocked = try container.decodeIfPresent(Bool.self, forKey: .gamblingBlocked)
        self.level2 = try container.decodeIfPresent(Bool.self, forKey: .level2)
        self.level3 = try container.decodeIfPresent(Bool.self, forKey: .level3)
        self.issuerCurrency = try container.decodeIfPresent(String.self, forKey: .issuerCurrency)
        self.cardSegmentType = try container.decodeIfPresent(String.self, forKey: .cardSegmentType)
        self.comboCard = try container.decodeIfPresent(String.self, forKey: .comboCard)
        self.cardBrandIsAdditional = try container.decodeIfPresent(Bool.self, forKey: .cardBrandIsAdditional)
        self.correlationID = try container.decodeIfPresent(String.self, forKey: .correlationID)
        self.sharedBin = try container.decodeIfPresent(Bool.self, forKey: .sharedBin)
        self.cost = try container.decodeIfPresent([TXBINCost].self, forKey: .cost) ?? []
        self.authentication = try container.decodeIfPresent([TXBINAuthentication].self, forKey: .authentication) ?? []
        self.additionalCardBrands =
            try container.decodeIfPresent([TXBINAdditionalCardBrand].self, forKey: .additionalCardBrands) ?? []
    }

    deinit {}
}

@objc
public class TXBINCost: NSObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case capTypeName = "CapTypeName"
        case capFixedAmount = "CapFixedAmount"
        case capAdvaloremAmount = "CapAdvaloremAmount"
        case capRegionShortname = "CapRegionShortname"
        case capTypeQualifierText = "CapTypeQualifierText"
        case capTypeQualifierLower = "CapTypeQualifierLower"
        case capTypeQualifierUpper = "CapTypeQualifierUpper"
        case capTypeQualifierCurrency = "CapTypeQualifierCurrency"
    }

    public private(set) var capTypeName: String?
    /// If a fixed or regulated interchange amount applies the amount will be shown here.
    public private(set) var capFixedAmount: Decimal?
    /// The interchange percentage assessed, shown in decimals for the capped interchange.
    public private(set) var capAdvaloremAmount: Decimal?
    public private(set) var capRegionShortname: String?
    /// The description of the interchange cap or regulation.
    @objc public private(set) var capTypeQualifierText: String?
    /// The minimum merchant processing volume amount limit for the interchange cap.
    public private(set) var capTypeQualifierLower: Int?
    /// The maximum merchant processing volume amount limit for the interchange cap.
    public private(set) var capTypeQualifierUpper: Int?
    /// The currency of the qualified fixed_amount for the regulated or capped interchange.
    @objc public private(set) var capTypeQualifierCurrency: String?

    // we cannot bridge Decimal?/Int? to Objective-C so we have to resort to a NSDecimalNumber*/NSNumber*

    // swiftlint:disable legacy_objc_type
    @objc public var capFixedAmountBridged: NSDecimalNumber? {
        toNSDecimalNumber(capFixedAmount)
    }
    @objc public var capAdvaloremAmountBridged: NSDecimalNumber? {
        toNSDecimalNumber(capAdvaloremAmount)
    }
    @objc public var capTypeQualifierLowerBridged: NSNumber? {
        toNSNumber(capTypeQualifierLower)
    }
    @objc public var capTypeQualifierUPperBridged: NSNumber? {
        toNSNumber(capTypeQualifierUpper)
    }
    // swiftlint:enable legacy_objc_type

    override public init() {}

    deinit {}
}

@objc
public class TXBINAuthentication: NSObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case scaName = "SCAName"
    }

    /// Name of authentication that is required.
    @objc public private(set) var scaName: String?

    override public init() {}

    deinit {}
}

@objc
public class TXBINAdditionalCardBrand: NSObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case binMin = "BinMin"
        case binMax = "BinMax"
        case cardBrand = "CardBrand"
        case cardBrandProduct = "CardBrandProduct"
        case cardBrandBankName = "CardBrandBankName"
        case billPayEnabled = "BillPayEnabled"
        case ecomEnabled = "EcomEnabled"
    }

    /// The minimum account number for this BIN's assigned account number range.
    @objc public private(set) var binMin: String?
    /// The maximum account number for this BIN's assigned account number range.
    @objc public private(set) var binMax: String?
    /// The additional card network that can process this card.
    @objc public private(set) var cardBrand: String?
    /// The name of the additioanl card product
    @objc public private(set) var cardBrandProduct: String?
    /// Name of Issuing Bank.
    @objc public private(set) var cardBrandBankName: String?
    @objc public private(set) var billPayEnabled: String?
    @objc public private(set) var ecomEnabled: String?

    override public init() {}

    deinit {}
}

// swiftlint:disable:next legacy_objc_type discouraged_optional_boolean
private func toNSNumber(_ value: Bool?) -> NSNumber? {
    guard let value else {
        return nil
    }
    return NSNumber(value: value)  // swiftlint:disable:this legacy_objc_type
}

// swiftlint:disable:next legacy_objc_type
private func toNSNumber(_ value: Int?) -> NSNumber? {
    guard let value else {
        return nil
    }
    return NSNumber(value: value)  // swiftlint:disable:this legacy_objc_type
}

// swiftlint:disable:next legacy_objc_type
private func toNSDecimalNumber(_ value: Decimal?) -> NSDecimalNumber? {
    guard let value else {
        return nil
    }
    return NSDecimalNumber(decimal: value)  // swiftlint:disable:this legacy_objc_type
}
