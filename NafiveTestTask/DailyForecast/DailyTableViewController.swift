//
//  DailyTableViewController.swift
//  NafiveTestTask
//
//  Created by Ivy on 11.09.2022.
//

import UIKit

class DailyTableViewController: UITableViewController {
    
    var dailyForecast : [DailyForecastResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! DailyTableViewCell
        
        cell.selectionStyle = .none
        
        let forecast = dailyForecast[indexPath.row]
        
        
        let df = DateFormatter()
        df.dateFormat = "E"
        
        cell.dayLabel.text = df.string(from: Date(timeIntervalSince1970: TimeInterval(forecast.dt ?? 0))).uppercased()
        
        cell.tempLabel.text = "\(Int(forecast.temp.max?.rounded(.up) ?? 0))°/ \(Int(forecast.temp.min?.rounded(.down) ?? 0))°"
        cell.weatherIconView.image = UIImage(named: forecast.weather.first?.imageNameByIcon ?? "")?.withRenderingMode(.alwaysTemplate)

        return cell
    }
}
