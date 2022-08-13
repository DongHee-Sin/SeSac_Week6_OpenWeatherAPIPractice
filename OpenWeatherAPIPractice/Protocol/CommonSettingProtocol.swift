//
//  CommonSettingProtocol.swift
//  OpenWeatherAPIPractice
//
//  Created by 신동희 on 2022/08/13.
//

import Foundation


protocol CommonSetting {
    static var identifier: String { get }
    
    func configureInitialUI()
}
