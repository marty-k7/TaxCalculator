import Foundation

extension TaxCalculator {
    /// Represents a identifiable tax with a specified name and percentage.
    public struct Tax: Identifiable, Equatable {

        /// The id of the tax object
        public let id: String

        /// The name of the tax (optional). Provides additional information about the type of tax.
        public let name: String?

        /// The percentage rate of the tax. Represents the proportion of the tax amount relative to the total.
        public let percentage: Double

        public init(id: String = UUID().uuidString, name: String? = nil, percentage: Double) {
            self.id = id
            self.name = name
            self.percentage = percentage
        }
    }
}
