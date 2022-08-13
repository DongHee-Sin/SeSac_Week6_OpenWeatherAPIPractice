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
    let temp: Double
    let humidity: Int
    let windSpeed: Double
}



class OpenWeatherAPIManager {
    
    static let shared = OpenWeatherAPIManager()
    private init() {}
    
    
    func requestOpenWeather(lat: Double, lon: Double, completion: @escaping OpenWeatherCompletionHandler) {
        
        let url = EndPoint.openWeatherEndPoint
        
        // HTTP Body : 실질적인 데이터 > Dictionary 형태로 입력
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

                let tmep = json["main"]["temp"].doubleValue
                let humidity = json["main"]["humidity"].intValue
                let wind = json["wind"]["speed"].doubleValue
                
                completion(Weather(temp: tmep, humidity: humidity, windSpeed: wind))
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
