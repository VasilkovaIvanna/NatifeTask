import UIKit

class DailyTableViewController: UITableViewController, DailyForecastProtocol {
    func update() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    var viewModel = DailyForecastViewModel() {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        overrideUserInterfaceStyle = .light
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyForecast.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! DailyTableViewCell
        
        cell.selectionStyle = .none
                    
        let info = viewModel.formatData(row: indexPath.row)
        
        cell.dayLabel.text = info.day
        cell.weatherIconView.image = UIImage(named: info.imageName)?.withRenderingMode(.alwaysTemplate)
        cell.tempLabel.text = info.temp

        return cell
    }
}
