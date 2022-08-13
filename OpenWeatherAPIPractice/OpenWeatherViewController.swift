//
//  OpenWeatherViewController.swift
//  OpenWeatherAPIPractice
//
//  Created by 신동희 on 2022/08/13.
//

import UIKit

class OpenWeatherViewController: UIViewController, CommonSetting {

    static let identifier = String(describing: OpenWeatherViewController.self)
    
    // MARK: - Propertys & Outlet
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: PaddingLabel!
    @IBOutlet weak var humidityLabel: PaddingLabel!
    @IBOutlet weak var windLabel: PaddingLabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
    }
    
    
    
    // MARK: - Methods
    func configureInitialUI() {
        
    }
}
