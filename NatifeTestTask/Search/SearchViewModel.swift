import Foundation
import MapKit

protocol SearchViewProtocol : AnyObject {
    func update()
}

class SearchViewModel : NSObject {
    
    struct SearchModel {
        var places : [String] = []
        var selectedPlace: String? = nil
    }
    
    var model = SearchModel() {
        didSet {
            delegate?.update()
        }
    }
    
    let completer = MKLocalSearchCompleter()
    
    weak var delegate : SearchViewProtocol?
    weak var weatherViewModel: WeatherViewModel?
    
    override init(){
        super.init()
        completer.delegate = self
    }
    
    func search(searchText: String){
        completer.queryFragment = searchText
    }
    
    func selectItem(row: Int) {
        let locationName = model.places[row]
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = locationName
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            // open this coordinate
            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                self?.model.selectedPlace = locationName
                self?.weatherViewModel?.setupLocation(locationCoordinate: coordinate)
            }
        }
    }
}

extension SearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.model.places = completer.results.map({$0.title})
    }
}
