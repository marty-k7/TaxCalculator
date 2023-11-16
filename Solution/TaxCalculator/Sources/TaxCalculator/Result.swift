import Foundation

extension TaxCalculator {
    /// Represents the result of a tax calculation.
    public struct Result {
        /// The full amount, including taxes.
        public let fullAmount: Double

        /// The amount without taxes.
        public let amountWithoutTaxes: Double

        /// The amount of taxes applied.
        public let taxesPaidAmount: Double

        /// Amounts pe tax applied
        public let amountsPerTax: [Tax.ID: Double]

        public init(fullAmount: Double, amountWithoutTaxes: Double, taxesAmount: Double, amountsPerTax: [Tax.ID: Double]) {
            self.fullAmount = fullAmount
            self.amountWithoutTaxes = amountWithoutTaxes
            self.taxesPaidAmount = taxesAmount
            self.amountsPerTax = amountsPerTax
        }
    }
}
