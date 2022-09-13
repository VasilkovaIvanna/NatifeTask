import Foundation

protocol HourlyForecastProtocol : AnyObject {
    func update()
}

class HourlyForecastViewModel {
    
    weak var delegate : HourlyForecastProtocol?
    
    var hourlyForecast : [HourlyForecastResponse] = [] {
        didSet {
            self.delegate?.update()
        }
    }
    
    func formatData(row: Int) -> (hour: String, imageName: String, temp: String) {
        
        let forecast = hourlyForecast[row]
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_ua")
        df.dateFormat = "HH"
        let hour = df.string(from: Date(timeIntervalSince1970: TimeInterval(forecast.dt ?? 0)))
        let imageName = forecast.weather.first?.imageNameByIcon ?? ""
        let temp = "\(Int(forecast.temp ?? 0))°"
        
        return (hour, imageName, temp)
    }
}

