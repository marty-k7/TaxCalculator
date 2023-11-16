import Combine
import TaxCalculator
import XCTest
@testable import ScroogeMcDuck

private extension TaxCalculator {
    static let mocked = Self(taxes: [.init(id: "01", percentage: 10), .init(id: "02", percentage: 20)])
}

class SodraServiceMock: SodraService {
    enum Status {
        case receivedOutput(Double)
        case receivedCompletion
    }

    var onStatusChange: ((Status) -> Void)?

    func sendTaxInfoToSodra(_ amount: Double) -> AnyPublisher<Void, Never> {
        return Just(amount).handleEvents(
            receiveOutput: { [weak self] amount in self?.onStatusChange?(.receivedOutput(amount)) },
            receiveCompletion: { [weak self] _ in self?.onStatusChange?(.receivedCompletion) }
        )
        .map { _ in }
        .eraseToAnyPublisher()
    }
}

class SalaryCalculatorViewModelTests: XCTestCase {
    var viewModel: SalaryCalculatorViewModel!
    var sodraService: SodraServiceMock!

    override func setUp() {
        sodraService = SodraServiceMock()
        viewModel = SalaryCalculatorViewModel(calculator: .mocked, sodraService: sodraService)
    }

    override func tearDown() {
        viewModel = nil
        sodraService = nil
    }

    func test_updateTakeHomeSalaryLabel_success() {
        // When
        viewModel.didUpdateTakeHomeSalary("1000")

        // Then
        XCTAssertEqual(viewModel.takeHomeSalary, "700.0")
    }

    func test_updateTakeHomeSalaryLabel_emptyString() {
        // When
        viewModel.didUpdateTakeHomeSalary("")

        // Then
        XCTAssertTrue(viewModel.takeHomeSalary.isEmpty)
    }

    func test_updateTakeHomeSalaryLabel_nilString() {
        // When
        viewModel.didUpdateTakeHomeSalary(nil)

        // Then
        XCTAssertTrue(viewModel.takeHomeSalary.isEmpty)
    }

    func test_updateTakeHomeSalaryLabel_letters() {
        // When
        viewModel.didUpdateTakeHomeSalary("hello")

        // Then
        XCTAssertTrue(viewModel.takeHomeSalary.isEmpty)
    }

    func test_additionalPensionSelected() {
        // When
        viewModel.additionalPensionSelected(2, currentNumber: "1000")

        // Then
        XCTAssertEqual(viewModel.takeHomeSalary, "670.0")
    }

    func test_additionalPensionSelected_and_unselected() {
        // When
        viewModel.additionalPensionSelected(2, currentNumber: "1000")

        // Then
        XCTAssertEqual(viewModel.takeHomeSalary, "670.0")

        // When
        viewModel.additionalPensionSelected(0, currentNumber: "1000")

        // Then
        XCTAssertEqual(viewModel.takeHomeSalary, "700.0")
    }

    // NOTE: I'm using waiter here, while it's working and get the job done, it has some downsides.
    // Including potential waiting time, considerations for CI pipelines,
    // and dependence on the execution queue. Alternative approaches like custom schedulers or using 3d party libraries
    // might be considered for more control and reliability in certain scenarios.
    func test_listenToSalaryChanges() {
        // Given
        let expectation = XCTestExpectation(description: "Salary change processed")

        // When
        viewModel.didUpdateTakeHomeSalary("1000")

        // Then
        sodraService.onStatusChange = { status in
            switch status {
            case let .receivedOutput(amount):
                XCTAssertEqual(amount, Double(self.viewModel.takeHomeSalary)!)
            case .receivedCompletion:
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
