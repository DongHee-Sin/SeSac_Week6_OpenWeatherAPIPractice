//
//  OpenWeather.swift
//  OpenWeatherAPIPractice
//
//  Created by 신동희 on 2022/08/13.
//

import Foundation

import Alamofire
import SwiftyJSON


typealias OpenWeatherCompletionHandler = (Weather) -> Void



struct Weather {
    let temp: Int
    let humidity: Int
    let windSpeed: Double
    let icon: String
}



class OpenWeatherAPIManager {
    
    static let shared = OpenWeatherAPIManager()
    private init() {}
    
    
    func requestOpenWeather(lat: Double, lon: Double, completion: @escaping OpenWeatherCompletionHandler) {
        
        let url = EndPoint.openWeatherEndPoint
        
        let parameter: Parameters = [
            "lat": "\(lat)",
            "lon": "\(lon)",
            "appid": APIKeys.OpenWeatherKey
        ]
        
        AF.request(url, method: .get, parameters: parameter).validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let statusCode = response.response?.statusCode ?? 500
                guard statusCode == 200 else {
                    print("StatusCode : \(statusCode)")
                    return
                }

                let tmep = Int(json["main"]["temp"].doubleValue - 273.15)
                let humidity = json["main"]["humidity"].intValue
                let wind = json["wind"]["speed"].doubleValue
                let icon = json["weather"][0]["icon"].stringValue
                
                completion(Weather(temp: tmep, humidity: humidity, windSpeed: wind, icon: icon))
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
