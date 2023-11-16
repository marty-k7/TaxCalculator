import Foundation

/// A utility for calculating taxes based on a set of defined tax rates.
///
/// I chose to use a struct here because we're not mutating the state; we're only applying some predefined rules. This gives us type safety and also allows us to create static instances of the `TaxCalculator` like this:
///
/// ```swift
/// static let Lithuania: TaxCalculator = Self(taxes: [Tax.init...])
///
/// ```
///**NB:**
///
/// The community default approach here would be to use protocols. One could create a protocol, `TaxCalculatorInterface`, add default calculate methods, create a default `TaxCalculator` class, and subclass it for different countries taxes or other cases where you need to calculate taxes. For example, when buying something with VAT applied.
///
public struct TaxCalculator {
    /// An array of `Tax` objects representing different tax rates that can be applied.
    public let taxes: [Tax]

    /// Initializes a new instance of `TaxCalculator` with the specified array of tax rates.
    ///
    /// - Parameter taxes: An array of `Tax` objects representing different tax rates.
    public init(taxes: [Tax]) {
        self.taxes = taxes
    }
}

extension TaxCalculator {
    /// Performs a tax calculation based on the provided amount.
    ///
    /// - Parameter amount: The input amount for the tax calculation.
    /// - Parameter additionalTaxes: An array of `Tax` objects representing additional taxes to be applied. Empty by default.
    /// - Parameter roundingRule: The rounding rule to be applied during the calculation. Defaults to `.cents` which is equal of 2 decimal places.
    /// - Returns: A `TaxCalculator.Result` struct containing detailed information about the calculation
    public func calculate(using amount: Double, additionalTaxes: [Tax] = [], roundingRule: RoundingRule = .cents) -> Result {
        let allTaxes = taxes + additionalTaxes
        var amountsPerTax: [Tax.ID: Double] = [:]
        let amountWithoutTaxes = allTaxes.reduce(amount) { partialResult, tax in
            let amountPaid = amount * tax.percentage / 100
            amountsPerTax[tax.id] = amountPaid.rounded(using: roundingRule)
            return partialResult - amountPaid
        }

        return Result(
            fullAmount: amount,
            amountWithoutTaxes: amountWithoutTaxes.rounded(using: roundingRule),
            taxesAmount: (amount - amountWithoutTaxes).rounded(using: roundingRule),
            amountsPerTax: amountsPerTax
        )
    }

    /// Performs a tax calculation based on the provided amount.
    ///
    /// - Parameter amount: The input amount for the tax calculation.
    /// - Parameter additionalTaxes: An array of `Tax` objects representing additional taxes to be applied. Empty by default.
    /// - Parameter roundingRule: The rounding rule to be applied during the calculation. Defaults to `.cents` which is equal of 2 decimal places.
    /// - Returns: Calculated amount without taxes
    public func calculate(using amount: Double, additionalTaxes: [Tax] = [], roundingRule: RoundingRule = .cents) -> Double {
        calculate(using: amount, additionalTaxes: additionalTaxes, roundingRule: roundingRule).amountWithoutTaxes
    }
}
