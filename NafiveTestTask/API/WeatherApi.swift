import Foundation

class WeatherApi {
    
    private enum WeatherCommand : String {
        // API 2.5
        case forecast
        case weather
        // API 3.0
        case onecall
        
        var version: String {
            switch self {
            case .forecast, .weather:
                return "2.5"
            case .onecall:
                return "3.0"
            }
        }
    }
    
    private func sendRequest(command: WeatherCommand, latitude: Double, longitude: Double, completionHandler: @escaping (Data)->()) {
        
        if var urlComponents =  URLComponents(string: "https://api.openweathermap.org/data/\(command.version)/\(command.rawValue)") {
            
            urlComponents.queryItems = [
                URLQueryItem(name: "lat", value: String(latitude)),
                URLQueryItem(name: "lon", value: String(longitude)),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "lang", value: "ua"),
                URLQueryItem(name: "appid", value: "771b6c2c53b178db61d27747e31212e8")
            ]
            
            if let url = urlComponents.url {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data else { return }
                    completionHandler(data)
                    
                }.resume()
            }
        } else {
            print("Failed to process url.")
        }
    }
    
    func currentWeather(latitude: Double, longitude: Double, completionHandler: @escaping (WeatherResponse)->()) {
        sendRequest(command: .weather, latitude: latitude, longitude: longitude) { data in
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completionHandler(weatherResponse)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func weatherForecast(latitude: Double, longitude: Double, completionHandler: @escaping (WeatherForecastResponse)->()) {
        sendRequest(command: .onecall, latitude: latitude, longitude: longitude) { data in
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherForecastResponse.self, from: data)
                completionHandler(weatherResponse)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
