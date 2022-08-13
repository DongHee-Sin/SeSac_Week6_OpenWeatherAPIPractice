//
//  OpenWeatherViewController.swift
//  OpenWeatherAPIPractice
//
//  Created by 신동희 on 2022/08/13.
//

import UIKit

class OpenWeatherViewController: UIViewController, CommonSetting {

    static let identifier = String(describing: OpenWeatherViewController.self)
    
    // MARK: - Outlet
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: PaddingLabel!
    @IBOutlet weak var humidityLabel: PaddingLabel!
    @IBOutlet weak var windLabel: PaddingLabel!
    @IBOutlet weak var commentLabel: PaddingLabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    
    
    // MARK: - Propertys
    let dateFormatter = DateFormatter()
    var currentDateString: String {
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
    }
    
    
    
    // MARK: - Methods
    func configureInitialUI() {
        [tempLabel, humidityLabel, windLabel, commentLabel].forEach {
            guard let label = $0 else { return }
            label.clipsToBounds = true
            setRadius(view: label)
        }
        
        setRadius(view: weatherImage)
        
        setDateFormatter()
        updateDateLabel()
    }
    
    
    func setDateFormatter() {
        dateFormatter.dateFormat = "MM월 dd일 hh시 mm분"
    }
    
    
    func updateDateLabel() {
        dateLabel.text = currentDateString
    }
    
    
    func setRadius(view: UIView) {
        view.layer.cornerRadius = 8
    }
}
