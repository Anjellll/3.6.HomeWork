




import UIKit

class MenuCell: UICollectionViewCell {
    
    @IBOutlet weak var imageIconView: UIImageView!
    
    @IBOutlet weak var nameProductLabel: UILabel!
    
    @IBOutlet weak var priceProductLabel: UILabel!
    
    
    
    override func layoutSubviews() {
        imageIconView.layer.cornerRadius = 150 / 3
        imageIconView.layer.shadowOpacity = 10
        imageIconView.layer.shadowRadius = 1
        
        
    }
    
}
