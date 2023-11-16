import XCTest
@testable import TaxCalculator

private extension TaxCalculator {
    static let mockSingle = Self(taxes: [.init(id: "0001", percentage: 10)])
    static let mockMultiple = Self(
        taxes: [
            .init(id: "0001", percentage: 10),
            .init(id: "0002", percentage: 20),
            .init(id: "0003", percentage: 5),
            .init(id: "0004", percentage: 5)
        ]
    )
    static let mockOneThird = Self(taxes: [.init(id: "0005", percentage: 33)])
}

final class TaxCalculatorTests: XCTestCase {

    let amount: Double = 100
    let unevenAmount: Double = 97

    func test_basics_singleTax() {
        // Given
        let calculator = TaxCalculator.mockSingle

        // When
        let calculatedAmount: Double = calculator.calculate(using: amount)

        // Then
        XCTAssertEqual(calculatedAmount, 90.00)
    }

    func test_basics_multipleTaxes() {
        // Given
        let calculator = TaxCalculator.mockMultiple

        // When
        let calculatedAmount: Double = calculator.calculate(using: amount)

        // Then
        XCTAssertEqual(calculatedAmount, 60.00)
    }

    func test_result_singleTax() {
        // Given
        let calculator = TaxCalculator.mockSingle

        // When
        let result: TaxCalculator.Result = calculator.calculate(using: amount)

        // Then
        XCTAssertEqual(result.amountWithoutTaxes, 90.00)
        XCTAssertEqual(result.taxesPaidAmount, 10.00)
        XCTAssertEqual(result.fullAmount, amount)
    }

    func test_result_multipleTaxes()  {
        // Given
        let calculator = TaxCalculator.mockMultiple

        // When
        let result: TaxCalculator.Result = calculator.calculate(using: amount)

        // Then
        XCTAssertEqual(result.amountWithoutTaxes, 60.00)
        XCTAssertEqual(result.taxesPaidAmount, 40.00)
        XCTAssertEqual(result.fullAmount, amount)
    }

    func test_result_amountPerTax_multipleTaxes() {
        // Given
        let calculator = TaxCalculator.mockMultiple

        // When
        let result: TaxCalculator.Result = calculator.calculate(using: amount)

        // Then
        XCTAssertEqual(result.amountsPerTax["0001"], 10)
        XCTAssertEqual(result.amountsPerTax["0002"], 20)
        XCTAssertEqual(result.amountsPerTax["0003"], 5)
        XCTAssertEqual(result.amountsPerTax["0004"], 5)
    }

    func test_result_additionalAdded_multipleTaxes() {
        // Given
        let calculator = TaxCalculator.mockMultiple
        let additionalTax1 = TaxCalculator.Tax(id: "0010", name: "additionalTax1", percentage: 3)
        let additionalTax2 = TaxCalculator.Tax(id: "0011", name: "additionalTax1", percentage: 2.5)

        // When
        let result: TaxCalculator.Result = calculator.calculate(using: amount, additionalTaxes: [additionalTax1, additionalTax2])

        // Then
        XCTAssertEqual(result.amountsPerTax["0010"], 3)
        XCTAssertEqual(result.amountsPerTax["0011"], 2.5)
        XCTAssertEqual(result.amountWithoutTaxes, 54.5)
    }

    func test_passingZeroPercentage() {
        // Given
        let calculator = TaxCalculator(taxes: [.init(percentage: 0)])

        // When
        let sameAmount: Double = calculator.calculate(using: amount)

        // Then
        XCTAssertEqual(amount, sameAmount)
    }

    func test_rounding_whenRuleIsNone() {
        // Given
        let calculator = TaxCalculator.mockOneThird

        // When
        let calculatedAmount: Double = calculator.calculate(using: unevenAmount, roundingRule: .none)

        // Then
        XCTAssertEqual(64.99000000000001, calculatedAmount)
    }

    func test_rounding_whenRuleIsZero() {
        // Given
        let calculator = TaxCalculator.mockOneThird

        // When
        let calculatedAmount: Double = calculator.calculate(using: unevenAmount, roundingRule: .toZero)

        // Then
        XCTAssertEqual(65, calculatedAmount)
    }

    func test_rounding_whenRuleIsCents() {
        // Given
        let calculator = TaxCalculator.mockOneThird

        // When
        let calculatedAmount: Double = calculator.calculate(using: unevenAmount, roundingRule: .cents)

        // Then
        XCTAssertEqual(64.99, calculatedAmount)
    }

    func test_rounding_whenRuleIsCustom() {
        // Given
        let calculator = TaxCalculator.mockOneThird

        // When
        let calculatedAmount: Double = calculator.calculate(using: unevenAmount, roundingRule: .custom(4))

        // Then
        XCTAssertEqual(64.9900, calculatedAmount)
    }
}
