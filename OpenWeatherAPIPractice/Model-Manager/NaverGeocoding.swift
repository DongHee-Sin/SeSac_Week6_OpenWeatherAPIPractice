//
//  NaverGeocoding.swift
//  OpenWeatherAPIPractice
//
//  Created by 신동희 on 2022/08/13.
//

import Foundation

import Alamofire
import SwiftyJSON


typealias GeocodingCompletionHandler = (String) -> Void


class GeocodingAPIManager {
    
    static let shared = GeocodingAPIManager()
    private init() {}
    
    
    func requestGeocoding(lat: Double, lon: Double, completion: @escaping GeocodingCompletionHandler) {
        let url = EndPoint.naverReverseGeocodingEndPoint
        
        let parameter: Parameters = [
            "x": "\(lon)",
            "y": "\(lat)",
            "input_coord": "WGS84"
        ]
        
        let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKeys.naverKey)"]
        
        AF.request(url, method: .get, parameters: parameter, headers: header).validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let statusCode = response.response?.statusCode ?? 500
                guard statusCode == 200 else {
                    print("StatusCode : \(statusCode)")
                    return
                }

                let location = "\(json["documents"][0]["address"]["region_1depth_name"].stringValue) \(json["documents"][0]["address"]["region_2depth_name"].stringValue)"
                print(json)
                completion(location)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
