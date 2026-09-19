import UIKit

class DetailCoinView: UIView {
    
    // UI Containers
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainStackView = UIStackView()
    
    // Core Elements
    private let coinImageView = UIImageView()
    private let priceLabel = UILabel()
    private let change24hLabel = UILabel()
    
    // Stat Boxes
    private let rankBox = StatBoxView(title: "Market Cap Rank")
    private let marketCapBox = StatBoxView(title: "Market Cap")
    private let volumeBox = StatBoxView(title: "24h Volume")
    private let high24Box = StatBoxView(title: "24h High")
    private let low24Box = StatBoxView(title: "24h Low")
    private let athBox = StatBoxView(title: "All-Time High (ATH)")
    private let atlBox = StatBoxView(title: "All-Time Low (ATL)")
    private let circulatingSupplyBox = StatBoxView(title: "Circulating Supply")
    private let maxSupplyBox = StatBoxView(title: "Max Supply")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .systemBackground
        
        // Setup ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Header Section Layout
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        coinImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        priceLabel.font = .systemFont(ofSize: 32, weight: .bold)
        change24hLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        let headerStack = UIStackView(arrangedSubviews: [coinImageView, priceLabel, change24hLabel])
        headerStack.axis = .vertical
        headerStack.alignment = .center
        headerStack.spacing = 8
        
        // Grid Section Layout (Baris 2 Kolom)
        let gridStack = UIStackView(arrangedSubviews: [
            createHorizontalRow(rankBox, marketCapBox),
            createHorizontalRow(volumeBox, high24Box),
            createHorizontalRow(low24Box, athBox),
            createHorizontalRow(atlBox, circulatingSupplyBox),
            createHorizontalRow(maxSupplyBox, StatBoxView(title: "", value: "")) // Spacer
        ])
        gridStack.axis = .vertical
        gridStack.spacing = 10
        gridStack.distribution = .fillEqually
        
        // Main Stack
        mainStackView.axis = .vertical
        mainStackView.spacing = 24
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(headerStack)
        mainStackView.addArrangedSubview(gridStack)
        
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func createHorizontalRow(_ left: UIView, _ right: UIView) -> UIStackView {
        let row = UIStackView(arrangedSubviews: [left, right])
        row.axis = .horizontal
        row.spacing = 10
        row.distribution = .fillEqually
        return row
    }

    // Fungsi Populasi Data ke UI
    func configure(with coin: Coin) {
        priceLabel.text = "$\(coin.currentPrice.formatted())"
        
        // Format Persentase 24 Jam
        let isPositive = coin.priceChangePercentage24h >= 0
        let prefix = isPositive ? "+" : ""
        change24hLabel.text = "\(prefix)\(String(format: "%.2f", coin.priceChangePercentage24h))% (24h)"
        change24hLabel.textColor = isPositive ? .systemGreen : .systemRed
        
        // Populasi Stat Box
        rankBox.setValue("#\(coin.marketCapRank)")
        marketCapBox.setValue("$\(coin.marketCap.formatted())")
        volumeBox.setValue("$\(coin.totalVolume.formatted())")
        high24Box.setValue("$\(coin.high24h.formatted())")
        low24Box.setValue("$\(coin.low24h.formatted())")
        athBox.setValue("$\(coin.ath.formatted())")
        atlBox.setValue("$\(coin.atl.formatted())")
        circulatingSupplyBox.setValue("\(coin.circulatingSupply.formatted())")
        
        if let maxSupply = coin.maxSupply {
            maxSupplyBox.setValue("\(maxSupply.formatted())")
        } else {
            maxSupplyBox.setValue("∞")
        }
        
        // Download Gambar
        Task {
            if let image = await APIService().fetchImage(from: coin.image) {
                self.coinImageView.image = image
            }
        }
    }
}
