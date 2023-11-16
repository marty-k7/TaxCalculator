import Combine

protocol SodraService {
   func sendTaxInfoToSodra(_ amount: Double) -> AnyPublisher<Void, Never>
}

struct SodraServiceLive: SodraService {
    func sendTaxInfoToSodra(_ amount: Double) -> AnyPublisher<Void, Never> {
        return Just(print("Sending to Sodra... \(amount)")).eraseToAnyPublisher()
    }
}
