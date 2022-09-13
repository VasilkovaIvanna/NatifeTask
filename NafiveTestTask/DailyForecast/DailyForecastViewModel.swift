import Foundation

protocol DailyForecastProtocol : AnyObject {
    func update()
}

class DailyForecastViewModel {
    
    weak var delegate : DailyForecastProtocol?
    
    var dailyForecast : [DailyForecastResponse] = [] {
        didSet {
            self.delegate?.update()
        }
    }
    
    func formatData(row: Int) -> (day: String, imageName: String, temp: String) {
        
        let forecast = dailyForecast[row]
        
        let df = DateFormatter()
        df.dateFormat = "E"
        
        let day = df.string(from: Date(timeIntervalSince1970: TimeInterval(forecast.dt ?? 0))).uppercased()
        let imageName = forecast.weather.first?.imageNameByIcon ?? ""
        let temp = "\(Int(forecast.temp.max?.rounded(.up) ?? 0))°/ \(Int(forecast.temp.min?.rounded(.down) ?? 0))°"
        
        return (day, imageName, temp)
    }
}
