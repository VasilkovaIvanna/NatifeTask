import UIKit

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.layer.shadowOpacity = selected ? 0.25 : 0
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowRadius = 15
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.backgroundBlue?.cgColor
        contentView.backgroundColor = selected ? .white : .clear
        
        dayLabel.textColor = selected ? .backgroundBlue : .black
        tempLabel.textColor = selected ? .backgroundBlue : .black
        
        weatherIconView.tintColor = selected ? .backgroundBlue : .black
    }
}
