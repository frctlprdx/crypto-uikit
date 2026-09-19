import UIKit

class DetailViewController: UIViewController {
    private let coin: Coin
    private let detailView = DetailCoinView()
    
    init(coin: Coin) {
        self.coin = coin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(coin.name) (\(coin.symbol.uppercased()))"
        navigationItem.largeTitleDisplayMode = .never // Layar detail lebih bagus pakai judul kecil
        
        detailView.configure(with: coin)
    }
}
