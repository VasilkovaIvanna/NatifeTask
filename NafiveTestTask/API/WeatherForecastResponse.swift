import Foundation

struct HourlyForecastResponse : Decodable {
    let dt: Int?
    let temp: Float?
    let weather: [WeatherResponseSummary]
    
    init(hour: Int, t: Float, icon: String) {
        dt = 1646316000 + 3600 * (hour + 8)
        temp = t
        weather = [.init(id: 1, main: "", description: "", icon: icon)]
    }
}

struct DailyForecastResponse : Decodable {
    struct Temp : Decodable {
        let day: Float?
        let min: Float?
        let max: Float?
    }
    let dt: Int?
    let temp: Temp
    let weather: [WeatherResponseSummary]
}

struct WeatherForecastResponse: Decodable {
    let hourly: [HourlyForecastResponse]
    let daily: [DailyForecastResponse]
}
