import Foundation
import CoreLocation
import MapKit

protocol WeatherProtocol : AnyObject {
    func update()
    func showAlertLocationDenied()
}

class WeatherViewModel : NSObject {
    
    var locationManager: CLLocationManager?
    weak var delegate : WeatherProtocol?
    
    var hourlyViewModel = HourlyForecastViewModel()
    var dailyViewModel = DailyForecastViewModel()
    var mapViewModel = MapViewModel()
    var searchViewModel = SearchViewModel()
    
    private var weatherResponse: WeatherResponse? {
        didSet {
            delegate?.update()
        }
    }
    
    var weatherData : WeatherData? {
        guard let weatherResponse = weatherResponse else { return nil }
        
        let df = DateFormatter()
        df.dateFormat = "E, d MMMM"
        
        return WeatherData(placeName: weatherResponse.name,
                           tempMax: "\(Int(weatherResponse.main.temp_max?.rounded(.up) ?? 0))°",
                           tempMin: "\(Int(weatherResponse.main.temp_min?.rounded(.down) ?? 0))°",
                           humidity: "\(Int(weatherResponse.main.humidity ?? 0))%",
                           windSpeed: "\(Int(weatherResponse.wind.speed ?? 0))m/sec",
                           windDirection: weatherResponse.wind.direction?.rawValue,
                           date: df.string(from: Date()).capitalized,
                           headerImageName: weatherResponse.weather.first?.imageNameByIcon ?? "ic_white_day_bright")
    }
    
    override init(){
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyReduced
        
        mapViewModel.weatherViewModel = self
        searchViewModel.weatherViewModel = self
    }
    
    struct WeatherData {
        let placeName: String?
        let tempMax: String
        let tempMin: String
        let humidity: String
        let windSpeed: String
        let windDirection : String?
        let date : String
        let headerImageName: String
        
    }
    
    func updateCurrentLocation(newLocation: CLLocationCoordinate2D) {
        setupLocation(locationCoordinate: newLocation)
    }
    
    func setupLocation(locationCoordinate: CLLocationCoordinate2D){
        WeatherApi().currentWeather(latitude: Double(locationCoordinate.latitude), longitude: Double(locationCoordinate.longitude)) { [weak self] response in
            self?.weatherResponse = response
        }
        WeatherApi().weatherForecast(latitude: Double(locationCoordinate.latitude), longitude: Double(locationCoordinate.longitude)) { [weak self] response in
            self?.hourlyViewModel.hourlyForecast = Array(response.hourly.prefix(24))
            self?.dailyViewModel.dailyForecast = Array(response.daily.prefix(24))
        }
    }
}

extension WeatherViewModel : CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            delegate?.showAlertLocationDenied()
        case .notDetermined:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.requestLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapViewModel.model.currentLocation = location
            setupLocation(locationCoordinate: location.coordinate)
            locationManager?.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location: \(error)")
    }
}
