import UIKit

private let reuseIdentifier = "Cell"

class HourlyForecastCollectionViewController: UICollectionViewController {
    
    var hourlyForecast : [HourlyForecastResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecast.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HourlyCollectionViewCell
        
        let forecast = hourlyForecast[indexPath.row]
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_ua")
        df.dateFormat = "HH"
        cell.hourlLabel.text = df.string(from: Date(timeIntervalSince1970: TimeInterval(forecast.dt ?? 0)))
        cell.weatherImage.image = UIImage(named: forecast.weather.first?.imageNameByIcon ?? "")
        cell.tempLabel.text = "\(Int(forecast.temp ?? 0))°"
    
        return cell
    }
}
