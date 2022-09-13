import UIKit

class WeatherViewController: UIViewController, WeatherProtocol{
    
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
    
    var viewModel = WeatherViewModel()
    
    func update() {
        DispatchQueue.main.async {
            self.setupWeatherHeader()
        }
    }
    
    private weak var collectionViewController: HourlyForecastCollectionViewController?
    private weak var tableViewController: DailyTableViewController?
    
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
        viewModel.delegate = self
        setupWeatherHeader()
        topBackgroundView.layer.zPosition = -1
        overrideUserInterfaceStyle = .light
        navigationItem.backButtonDisplayMode = .minimal
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let collectionViewController = segue.destination as? HourlyForecastCollectionViewController {
            collectionViewController.viewModel = viewModel.hourlyViewModel
            self.collectionViewController = collectionViewController
        } else if let tableViewController = segue.destination as? DailyTableViewController {
            tableViewController.viewModel = viewModel.dailyViewModel
            self.tableViewController = tableViewController
        } else if let mapViewController = segue.destination as? MapViewController {
            mapViewController.viewModel = viewModel.mapViewModel
        } else if let searchViewController = segue.destination as? SearchViewController {
            searchViewController.viewModel = viewModel.searchViewModel
        }
    }
    
    func setupWeatherHeader() {
        weatherHeaderContainer.isHidden = viewModel.weatherData == nil
        placeNavigationContainer.isHidden = viewModel.weatherData == nil
        
        guard let data = viewModel.weatherData else { return }
        
        placeHeaderButton.setTitle(data.placeName, for: .normal)
        minMaxTempHeaderLabel.text = "\(data.tempMax)°/\(data.tempMin)"
        humidityHeaderLabel.text = data.humidity
        windHeaderLabel.text = data.windSpeed
        if let direction = data.windDirection {
            windDirectionImage.image = UIImage(named: direction)
        } else {
            windDirectionImage.image = nil
        }
        dateHeaderLabel.text = data.date
        weatherHeaderImage.image = UIImage(named: data.headerImageName)
    }
    
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
}


