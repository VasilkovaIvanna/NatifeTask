import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    weak var viewController: ViewController?
    
    var currentLocation : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentLocation = currentLocation {
            mapView.centerToLocation(currentLocation)
        }
    }
    
    

    
    func showMapAlert(locationName: String, locationCoordinate: CLLocationCoordinate2D){
        let alert = UIAlertController(title: "Change the place to \(locationName)",
                                      message: "Would you like to see the forecast for the selected location?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Show forecast", style: UIAlertAction.Style.default, handler: { action in
            
            self.viewController?.updateCurrentLocation(newLocation: locationCoordinate)
            self.dismiss(animated: true)
            
        })
        let cancelAction = UIAlertAction(title: "Stay on the map", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.preferredAction = okAction
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)) { [weak self] places, error in
            if let city = places?.first?.locality {
                self?.showMapAlert(locationName: city, locationCoordinate: locationCoordinate)
            }
        }
    }
    
    
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 100000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
