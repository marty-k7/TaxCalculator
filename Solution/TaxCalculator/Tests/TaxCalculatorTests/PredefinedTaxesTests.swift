import XCTest
@testable import TaxCalculator

final class PredefinedTaxesTests: XCTestCase {
    func test_LithuaniaSalaryTaxes() {
        // Verify the accuracy of taxes. Since these are predefined, additional safety measures are recommended.
        XCTAssertEqual(TaxCalculator.Tax.vsd.percentage, 12.52)
        XCTAssertEqual(TaxCalculator.Tax.gpm.percentage, 20.00)
        XCTAssertEqual(TaxCalculator.Tax.psd.percentage, 6.98)

        let calculator = TaxCalculator.salaryLithuania
        XCTAssertTrue(calculator.taxes.contains(.gpm))
        XCTAssertTrue(calculator.taxes.contains(.psd))
        XCTAssertTrue(calculator.taxes.contains(.vsd))
    }
}
