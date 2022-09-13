import UIKit

private let reuseIdentifier = "Cell"

class HourlyForecastCollectionViewController: UICollectionViewController, HourlyForecastProtocol {
    
    var viewModel = HourlyForecastViewModel() {
        didSet {
            viewModel.delegate = self
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    func update() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hourlyForecast.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HourlyCollectionViewCell
        
        let info = viewModel.formatData(row: indexPath.row)
        
        cell.hourlLabel.text = info.hour
        cell.weatherImage.image = UIImage(named: info.imageName)
        cell.tempLabel.text = info.temp
        
        return cell
    }
}
