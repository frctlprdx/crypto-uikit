import Foundation
import Combine

@MainActor
class CoinViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service = APIService()
    
    func fetchCoins() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedCoins = try await service.loadCoins()
            self.coins = fetchedCoins
        } catch {
            self.errorMessage = "Gagal memuat data: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
