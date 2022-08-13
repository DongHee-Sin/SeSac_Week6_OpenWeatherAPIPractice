//
//  OpenWeatherViewController.swift
//  OpenWeatherAPIPractice
//
//  Created by 신동희 on 2022/08/13.
//

import UIKit

class OpenWeatherViewController: UIViewController, CommonSetting {

    static let identifier = String(describing: OpenWeatherViewController.self)
    

    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
    }
    
    
    
    // MARK: - Methods
    func configureInitialUI() {
        
    }
}
