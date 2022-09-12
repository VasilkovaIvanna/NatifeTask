import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var placeHeaderButton: UIButton!
    @IBOutlet weak var dateHeaderLabel: UILabel!
    @IBOutlet weak var weatherHeaderImage: UIImageView!
    @IBOutlet weak var minMaxTempHeaderLabel: UILabel!
    @IBOutlet weak var humidityHeaderLabel: UILabel!
    @IBOutlet weak var windHeaderLabel: UILabel!
    @IBOutlet weak var windDirectionImage: UIImageView!
    @IBOutlet weak var placeNavigationContainer: UIView!
    @IBOutlet weak var weatherHeaderContainer: UIView!
    
    private weak var collectionViewController: HourlyForecastCollectionViewController?
    private weak var tableViewController: DailyTableViewController?
    
    var weatherResponse: WeatherResponse? {
        didSet {
            DispatchQueue.main.async {
                self.setupWeatherHeader()
            
            }
        }
    }
    
    func setupLocation(locationCoordinate: CLLocationCoordinate2D){
        WeatherApi().currentWeather(latitude: Double(locationCoordinate.latitude), longitude: Double(locationCoordinate.longitude)) { [weak self] response in
            self?.weatherResponse = response
        }
        WeatherApi().weatherForecast(latitude: Double(locationCoordinate.latitude), longitude: Double(locationCoordinate.longitude)) { [weak self] response in
            self?.collectionViewController?.hourlyForecast = Array(response.hourly.prefix(24))
            self?.tableViewController?.dailyForecast = Array(response.daily.prefix(24))
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWeatherHeader()
        navigationItem.backButtonDisplayMode = .minimal
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        topBackgroundView.layer.zPosition = -1
        locationManager?.desiredAccuracy = kCLLocationAccuracyReduced
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let collectionViewController = segue.destination as? HourlyForecastCollectionViewController {
            self.collectionViewController = collectionViewController
        } else if let tableViewController = segue.destination as? DailyTableViewController {
            self.tableViewController = tableViewController
        } else if let mapViewController = segue.destination as? MapViewController {
            mapViewController.currentLocation = locationManager?.location
            mapViewController.viewController = self
        } else if let searchViewController = segue.destination as? SearchViewController {
            searchViewController.viewController = self
        }
    }
    
    func updateCurrentLocation(newLocation: CLLocationCoordinate2D) {
        setupLocation(locationCoordinate: newLocation)
    }
    
    func setupWeatherHeader() {
        
        weatherHeaderContainer.isHidden = weatherResponse == nil
        placeNavigationContainer.isHidden = weatherResponse == nil
        
        guard let data = weatherResponse else { return }
        
        placeHeaderButton.setTitle(data.name, for: .normal)
        
        minMaxTempHeaderLabel.text = "\(Int(data.main.temp_max?.rounded(.up) ?? 0))°/ \(Int(data.main.temp_min?.rounded(.down) ?? 0))°"
        
        humidityHeaderLabel.text = "\(Int(data.main.humidity ?? 0))%"
        
        windHeaderLabel.text = "\(Int(data.wind.speed ?? 0))m/sec"
        if let direction = data.wind.direction {
            windDirectionImage.image = UIImage(named: direction.rawValue)
        } else {
            windDirectionImage.image = nil
        }
        
        let df = DateFormatter()
        df.dateFormat = "E, d MMMM"
        dateHeaderLabel.text = df.string(from: Date()).capitalized
        weatherHeaderImage.image = UIImage(named: data.weather.first?.imageNameByIcon ?? "ic_white_day_bright")
    }
}

extension ViewController : CLLocationManagerDelegate {
    
    func showAlertLocationDenied() {
        let alert = UIAlertController(title: "Allow “NatifeTask” to use your location?",
                                      message: "Please go to settings to allow NatifeTask use your precise location.",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Go to Settings", style: UIAlertAction.Style.default, handler: { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            UIApplication.shared.open(settingsUrl)
        })
        
        alert.addAction(okAction)
        alert.preferredAction = okAction
        present(alert, animated: true, completion: nil)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            showAlertLocationDenied()
        case .notDetermined:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.requestLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            setupLocation(locationCoordinate: location)
            locationManager?.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location: \(error)")
    }
}
