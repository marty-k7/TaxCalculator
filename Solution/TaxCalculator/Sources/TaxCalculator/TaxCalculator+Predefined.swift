import Foundation

public extension TaxCalculator.Tax {
    static let vsd: TaxCalculator.Tax = .init(name: "VSD", percentage: 12.52)
    static let gpm: TaxCalculator.Tax = .init(name: "GPM", percentage: 20.00)
    static let psd: TaxCalculator.Tax = .init(name: "PSD", percentage: 6.98)
}

public extension TaxCalculator {
    /// An instance of `TaxCalculator` with predefined tax rates for salary calculations in Lithuania.
    static let salaryLithuania: TaxCalculator = .init(taxes: [.gpm,.psd, .vsd])
}
