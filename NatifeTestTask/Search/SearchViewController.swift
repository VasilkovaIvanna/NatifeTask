import UIKit

class SearchViewController: UIViewController, SearchViewProtocol {
    
    func update() {
        DispatchQueue.main.async {
            if self.viewModel.model.selectedPlace != nil {
                self.navigationController?.popViewController(animated: true)
            }
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchView: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        searchView.searchTextField.leftView = nil
        searchView.searchTextField.backgroundColor = .white
        navigationItem.titleView = searchView
        
        navigationItem.leftBarButtonItem = setupCustomBarButton(iconName: "ic_back", selector: #selector(backButtonTapped), left: true)
        navigationItem.rightBarButtonItem = setupCustomBarButton(iconName: "ic_search", selector: #selector(searchButtonTapped), left: false)
        
        tableView.delegate = self
        searchView.delegate = self
        viewModel.delegate = self
    }
    
    private func setupCustomBarButton(iconName: String, selector: Selector, left: Bool) -> UIBarButtonItem {
        let menuBtn = UIButton(type: .custom)
        let backBtnImage = UIImage(named: iconName)
        menuBtn.setImage(backBtnImage, for: .normal)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
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
        return viewModel.model.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.model.places[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        viewModel.selectItem(row: indexPath.row)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText: searchText)
    }
}


