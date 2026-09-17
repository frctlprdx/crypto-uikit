import UIKit

class ViewController: UIViewController {
    private let mainView = CoinMarketView()
    private let vm = CoinViewModel()

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cryptocurrency"
        
        setupDelegates()
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
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CoinTableViewCell.identifier,
            for: indexPath
        ) as? CoinTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: vm.coins[indexPath.row])
        return cell
    }
}
