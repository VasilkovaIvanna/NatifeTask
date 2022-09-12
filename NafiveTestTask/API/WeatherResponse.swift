import Foundation

struct WeatherResponseSummary : Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
    
    var imageNameByIcon : String? {
        guard let icon = icon else { return nil }
        switch WeatherIcon.init(rawValue: icon) {
        case .day1, .day13, .day50:
            return "ic_white_day_bright"
        case .day2, .day3, .day4:
            return "ic_white_day_cloudy"
        case .day9:
            return "ic_white_day_shower"
        case .day10:
            return "ic_white_day_rain"
        case .day11:
            return "ic_white_day_thunder"
        case .night1, .night13, .night50:
            return "ic_white_night_bright"
        case .night2, .night3, .night4:
            return "ic_white_night_cloudy"
        case .night9:
            return "ic_white_night_shower"
        case .night10:
            return "ic_white_night_rain"
        case .night11:
            return "ic_white_night_thunder"
        case .none:
            return "ic_white_day_bright"
        }
    }
}

struct WeatherResponseMain : Decodable {
    let temp: Float?
    let temp_min: Float?
    let temp_max: Float?
    let humidity: Float?
}

struct WeatherResponseWind : Decodable {
    let speed: Float?
    let deg: Float?
    let gust: Float?
    
    var direction: WindDirection? {
        guard let deg = deg else { return nil }
        switch deg {
        case ..<23, 338...:
            return .north
        case 23..<68:
            return .northEast
        case 68..<113:
            return .east
        case 113..<158:
            return .southEast
        case 158..<203:
            return .south
        case 203..<248:
            return .westSouth
        case 248..<293:
            return .west
        case 293..<338:
            return .westNorth
        default:
            return nil
        }
    }
}

struct WeatherResponse : Decodable {
    let weather: [WeatherResponseSummary]
    let main: WeatherResponseMain
    let wind: WeatherResponseWind
    let name: String?
}


enum WindDirection: String {
    case north = "icon_wind_n"
    case northEast = "icon_wind_ne"
    case east = "icon_wind_e"
    case southEast = "icon_wind_se"
    case south = "icon_wind_s"
    case westSouth = "icon_wind_ws"
    case west = "icon_wind_w"
    case westNorth = "icon_wind_wn"
}

enum WeatherIcon : String {
    case day1 = "01d"
    case day2 = "02d"
    case day3 = "03d"
    case day4 = "04d"
    case day9 = "09d"
    case day10 = "10d"
    case day11 = "11d"
    case day13 = "13d"
    case day50 = "50d"
    
    case night1 = "01n"
    case night2 = "02n"
    case night3 = "03n"
    case night4 = "04n"
    case night9 = "09n"
    case night10 = "10n"
    case night11 = "11n"
    case night13 = "13n"
    case night50 = "50n"
}
