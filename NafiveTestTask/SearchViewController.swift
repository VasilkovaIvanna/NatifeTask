import UIKit
import MapKit


class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchView: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var viewController: ViewController?
        
    var places : [String] = []
    let completer = MKLocalSearchCompleter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.searchTextField.leftView = nil
        searchView.searchTextField.backgroundColor = .white
        navigationItem.titleView = searchView
        
        navigationItem.leftBarButtonItem = setupCustomBarButton(iconName: "ic_back", selector: #selector(backButtonTapped), left: true)
        navigationItem.rightBarButtonItem = setupCustomBarButton(iconName: "ic_search", selector: #selector(searchButtonTapped), left: false)
        
        completer.delegate = self
        tableView.delegate = self
        searchView.delegate = self
    }
    
    private func setupCustomBarButton(iconName: String, selector: Selector, left: Bool) -> UIBarButtonItem {
        let menuBtn = UIButton(type: .custom)
        let backBtnImage = UIImage(named: iconName)
        let imageSize = backBtnImage?.size ?? .zero
        menuBtn.setBackgroundImage(backBtnImage, for: .normal)
        menuBtn.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)

        let view = UIView(frame: menuBtn.frame)
        menuBtn.addTarget(self, action: selector, for: .touchUpInside)
        view.bounds = view.bounds.offsetBy(dx: left ? 5 : -5, dy: 0)
        view.addSubview(menuBtn)
        return UIBarButtonItem(customView: view)
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func searchButtonTapped(_ sender: UIButton) {}
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationName = places[indexPath.row]
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = locationName
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            // open this coordinate
            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                self?.viewController?.setupLocation(locationCoordinate: coordinate)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        completer.queryFragment = searchText
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.places = completer.results.map({$0.title})
            self.tableView.reloadData()
        }
    }
}
