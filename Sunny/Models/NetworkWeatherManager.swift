


import Foundation
import CoreLocation

//protocol NetworkWeatherManagerDelegate: class {
//    func updateInterface(_: NetworkWeatherManager, with currentWeather: CurrentWeather)
//}

class NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    //weak var delegate: NetworkWeatherManagerDelegate?
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = " "
        switch requestType {
        case .cityName(let city): urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude): urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
       
        }
        performRequest(withURLString: urlString)
    }
    
//    func fetchCurrentWeather(forCity city: String) {
//
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
//
//       performRequest(withURLString: urlString)
//       }
//
//    func fetchCurrentWeather(forLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
//        //api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
//
//        performRequest(withURLString: urlString)
//       }
    
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
       let task = session.dataTask(with: url) { (data, response, error) in
        if let data = data {
            if let currentWeather = self.parseJSON(withData: data) {
               // self.delegate?.updateInterface(self, with: currentWeather)
                self.onCompletion?(currentWeather)
            }
           }
        }
        task.resume()
       }
        
    
    
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
   
        let decoder = JSONDecoder()
        do {
         let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}

