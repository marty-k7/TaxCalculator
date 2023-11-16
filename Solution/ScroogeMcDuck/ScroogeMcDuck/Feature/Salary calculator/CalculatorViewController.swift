import Combine
import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet private weak var salaryInputTextField: UITextField!
    @IBOutlet private weak var takeHomeSalaryLabel: UILabel!
    @IBOutlet private weak var additionalPensionTitleLabel: UILabel!
    @IBOutlet private weak var additionalPensionOption: UISegmentedControl!

    // NOTE: For simplicity, the view model is directly initialized here.
    // In a real-life application, it's often a better practice to use design patterns
    // such as coordinators or presenters to handle the navigation stack and
    // initialize views and view controllers. This separation of concerns
    // enhances the maintainability and testability of the code.
    let viewModel = SalaryCalculatorViewModel()

    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bindViewModel()
    }
    
    private func setupUI() {
        salaryInputTextField.placeholder = viewModel.salaryInputTextFieldPlaceholder
        additionalPensionTitleLabel.text = viewModel.additionalPensionTitle
        salaryInputTextField.keyboardType = .numberPad
        salaryInputTextField.delegate = self
        additionalPensionOption.removeAllSegments()
        viewModel.additionalPensionTaxes.enumerated().forEach { index, tax in
            additionalPensionOption.insertSegment(withTitle: tax.name, at: index, animated: true)
        }
        additionalPensionOption.selectedSegmentIndex = 0
        takeHomeSalaryLabel.textAlignment = .center
        takeHomeSalaryLabel.textColor = .systemGreen
        takeHomeSalaryLabel.font = takeHomeSalaryLabel.font.withSize(60)
    }

    private func setupActions() {
        salaryInputTextField.addTarget(self,
                                       action: #selector(salaryInputTextFieldDidChange(textField:)),
                                       for: .editingChanged)

        additionalPensionOption.addTarget(self,
                                          action: #selector(additionalPensionSelected(sender:)),
                                          for: .valueChanged)
    }

    private func bindViewModel() {
        viewModel.$takeHomeSalary
            .sink { [weak self] text in
                self?.takeHomeSalaryLabel.text = text
            }
            .store(in: &cancellables)
    }

    @objc
    private func salaryInputTextFieldDidChange(textField: UITextField) {
        viewModel.didUpdateTakeHomeSalary(textField.text)
    }

    @objc
    private func additionalPensionSelected(sender: UISegmentedControl) {
        viewModel.additionalPensionSelected(sender.selectedSegmentIndex, currentNumber: salaryInputTextField.text)
    }
}

extension CalculatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

