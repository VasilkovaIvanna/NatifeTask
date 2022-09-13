import UIKit
import MapKit

class MapViewController: UIViewController, MapViewProtocol {
    
    var viewModel = MapViewModel() {
        didSet {
            viewModel.delegate = self
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    func updateCurrentLocation() {
        if let currentLocation = viewModel.model.currentLocation { mapView.centerToLocation(currentLocation)
        }
    }
    
    func update() {
        if viewModel.didSelectLocation {
            showMapAlert()
        } else {
            updateCurrentLocation()
        }
    }
    
    func showMapAlert() {
        let alert = UIAlertController(title: "Change the place to \(viewModel.model.locationName ?? "the selected location")",
                                      message: "Would you like to see the forecast for the selected location?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Show forecast", style: UIAlertAction.Style.default, handler: { _ in
            self.viewModel.showForecast()
            self.navigationController?.popViewController(animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Stay on the map", style: .cancel) {
            _ in
            self.viewModel.resetSelectedLocation()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.preferredAction = okAction
        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        viewModel.nameForLocation(locationCoordinate: locationCoordinate)
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
