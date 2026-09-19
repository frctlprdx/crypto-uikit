import Foundation
import Combine

@MainActor
class CoinViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var filteredCoins: [Coin] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service = APIService()
    
    var isSearching: Bool = false
    var currentCoins: [Coin] {
        return isSearching ? filteredCoins : coins
    }
    
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
    
    func filterCoins(with query: String) {
        if query.isEmpty {
            isSearching = false
            filteredCoins = []
        } else {
            isSearching = true
            filteredCoins = coins.filter { coin in
                let nameMatch = coin.name.lowercased().contains(query.lowercased())
                let symbolMatch = coin.symbol.lowercased().contains(query.lowercased())
                return nameMatch || symbolMatch
            }
        }
    }
}
