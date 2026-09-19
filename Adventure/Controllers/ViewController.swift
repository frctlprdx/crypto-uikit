import UIKit

class ViewController: UIViewController {
    private let mainView = CoinMarketView()
    private let vm = CoinViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let filteredData: [String] = []

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Coin List"
        
        setupDelegates()
        coinSearchController()
        fetchData()
    }
    
    private func setupDelegates() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }

    private func fetchData() {
        mainView.activityIndicator.startAnimating()
        
        Task {
            await vm.fetchCoins()
            mainView.activityIndicator.stopAnimating()
            mainView.tableView.reloadData()
        }
    }
    
    private func coinSearchController () {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for the Coin..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.currentCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CoinTableViewCell.identifier,
            for: indexPath
        ) as? CoinTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: vm.currentCoins[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < vm.currentCoins.count else { return }
        let selectedCoin = vm.currentCoins[indexPath.row]
        let detailVC = DetailViewController(coin: selectedCoin)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        vm.filterCoins(with: searchText)
        mainView.tableView.reloadData()
    }
}
