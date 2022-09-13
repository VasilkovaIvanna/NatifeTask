import Foundation
import CoreLocation

protocol MapViewProtocol : AnyObject {
    func update()
}

class MapViewModel {
    
    struct MapModel {
        var currentLocation : CLLocation? 
        let locationName: String?
        let locationCoordinate: CLLocationCoordinate2D?
    }
    
    weak var delegate : MapViewProtocol?
    weak var weatherViewModel: WeatherViewModel?
    
    var model = MapModel(currentLocation: nil, locationName: nil, locationCoordinate: nil) {
        didSet {
            delegate?.update()
        }
    }
    
    var didSelectLocation: Bool {
        model.locationName != nil && model.locationCoordinate != nil
    }
    
    func nameForLocation(locationCoordinate: CLLocationCoordinate2D){
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)) { [weak self] places, error in
            if let city = places?.first?.locality {
                self?.model = .init(currentLocation: self?.model.currentLocation, locationName: city, locationCoordinate: locationCoordinate)
            }
        }
    }
    
    func showForecast(){
        if let locationCoordinate = model.locationCoordinate {
            self.weatherViewModel?.updateCurrentLocation(newLocation: locationCoordinate)
        }
    }
    
    func resetSelectedLocation(){
        model = .init(currentLocation: model.currentLocation, locationName: nil, locationCoordinate: nil)
    }
}
