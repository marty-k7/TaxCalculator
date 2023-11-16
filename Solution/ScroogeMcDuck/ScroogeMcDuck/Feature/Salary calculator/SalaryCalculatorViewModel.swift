import Combine
import Foundation
import TaxCalculator

final class SalaryCalculatorViewModel {
    typealias Tax = TaxCalculator.Tax

    let salaryInputTextFieldPlaceholder = "Enter salary on paper"
    let additionalPensionTitle = "Additional pension payments?"
    let additionalPensionTaxes: [Tax] = [
        .init(name: "No", percentage: 0),
        .init(name: "2.1 %", percentage: 2.1),
        .init(name: "3 %", percentage: 3)
    ]

    @Published private(set) var takeHomeSalary = ""
    private var takeHomeSalarySubscriber: AnyCancellable?

    private var additionalPensionTax: Tax?
    private let calculator: TaxCalculator
    private let service: SodraService

    init(
        calculator: TaxCalculator = .salaryLithuania,
        sodraService: SodraService = SodraServiceLive()
    ) {
        self.calculator = calculator
        self.service = sodraService
        listenToSalaryChanges()
    }

    func didUpdateTakeHomeSalary(_ numberText: String?) {
        guard let numberText, let number = Double(numberText) else {
            // One could consider showing an error when the entered string is not number
            // For simplicity I just pass an empty string
            takeHomeSalary = ""
            return
        }

        let additionalTaxes = additionalPensionTax.map { [$0] } ?? []
        let salary: Double = calculator.calculate(using: number, additionalTaxes: additionalTaxes)
        takeHomeSalary = String(salary)
    }

    func additionalPensionSelected(_ index: Int, currentNumber: String?) {
        additionalPensionTax = index > 0 ? additionalPensionTaxes[index] : nil
        didUpdateTakeHomeSalary(currentNumber)
    }

    private func listenToSalaryChanges() {
        takeHomeSalarySubscriber = $takeHomeSalary
            .dropFirst()
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .compactMap(Double.init)
            .flatMap(service.sendTaxInfoToSodra)
            .sink { _ in }
    }
}

