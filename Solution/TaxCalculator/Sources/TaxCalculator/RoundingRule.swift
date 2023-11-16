import Foundation

extension TaxCalculator {
    /// Rounding preciscion strategy for calculation
    public enum RoundingRule {
        /// No rounding
        case none
        /// Rounds to zero
        case toZero
        /// Rounds to thents
        case cents
        /// How many decimal places to show.
        case custom(Int)

        var places: Int? {
            switch self {
            case .none: nil
            case .toZero: 0
            case .cents: 2
            case let .custom(places): places
            }
        }
    }
}

extension Double {
    /// Internal helper to round Doubles using provided `RoundingRule`
    func rounded(using rule: TaxCalculator.RoundingRule) -> Double {
        guard let decimalPlaces = rule.places else { return self }
        let divisor = pow(10.0, Double(decimalPlaces))
        return (self * divisor).rounded() / divisor
    }
}
