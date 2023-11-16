import XCTest
@testable import TaxCalculator

final class RoundingRulesTests: XCTestCase {
    func test_Rounding() {
        XCTAssertEqual(3.333.rounded(using: .none), 3.333)
        XCTAssertEqual(3.333.rounded(using: .toZero), 3)
        XCTAssertEqual(3.5.rounded(using: .toZero), 4)
        XCTAssertEqual(3.333.rounded(using: .cents), 3.33)
        XCTAssertEqual(3.333.rounded(using: .custom(3)), 3.333)
    }
}
