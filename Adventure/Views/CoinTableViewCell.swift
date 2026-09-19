import UIKit

class CoinTableViewCell: UITableViewCell {
    static let identifier = "CoinTableViewCell"
    private var imageTask: Task<Void, Never>?

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
    }

    func configure(with coin: Coin) {
        var content = defaultContentConfiguration()
        content.text = coin.name
        content.secondaryText = "\(coin.symbol.uppercased()) • $\(coin.currentPrice)"
        content.secondaryTextProperties.color = .secondaryLabel
        
        content.image = UIImage(systemName: "bitcoinsign.circle.fill")
        content.imageProperties.maximumSize = CGSize(width: 32, height: 32)
        content.imageProperties.cornerRadius = 16
        contentConfiguration = content
        
        imageTask = Task {
            guard let image = await APIService().fetchImage(from: coin.image) else { return }
            guard !Task.isCancelled else { return }
            
            var updatedContent = self.defaultContentConfiguration()
            updatedContent.text = coin.name
            updatedContent.secondaryText = "\(coin.symbol.uppercased()) • $\(coin.currentPrice)"
            updatedContent.secondaryTextProperties.color = .secondaryLabel
            updatedContent.image = image
            updatedContent.imageProperties.maximumSize = CGSize(width: 32, height: 32)
            updatedContent.imageProperties.cornerRadius = 16
            
            self.contentConfiguration = updatedContent
        }
    }
}
