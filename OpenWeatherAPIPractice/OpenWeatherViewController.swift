//
//  OpenWeatherViewController.swift
//  OpenWeatherAPIPractice
//
//  Created by 신동희 on 2022/08/13.
//

import UIKit

import CoreLocation
import JGProgressHUD
import Kingfisher


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
    let openWeatherAPIManager = OpenWeatherAPIManager.shared
    let geocodingAPIManager = GeocodingAPIManager.shared
    
    let locationManager = CLLocationManager()
    
    let hud = JGProgressHUD(style: .dark)

    var userLocation: (lat: Double, lon: Double)? {
        didSet { reloadData() }
    }
    
    let defaultLocation = (lat: 37.517829, lon: 126.886270)
    
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
        locationManager.delegate = self
        
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
    
    
    func reloadData() {
        hud.show(in: self.view, animated: true)
        if let userLocation = userLocation {
            openWeatherAPIManager.requestOpenWeather(lat: userLocation.lat, lon: userLocation.lon) { [weak self] weather in
                guard let self = self else { return }
                self.updateUI(with: weather)
                self.geocodingAPIManager.requestGeocoding(lat: userLocation.lat, lon: userLocation.lon) { city in
                    self.currentLocationLabel.text = city
                    self.hud.dismiss(animated: true)
                }
            }
        }else {
            openWeatherAPIManager.requestOpenWeather(lat: defaultLocation.lat, lon: defaultLocation.lon) { [weak self] weather in
                guard let self = self else { return }
                self.updateUI(with: weather)
                self.geocodingAPIManager.requestGeocoding(lat: self.defaultLocation.lat, lon: self.defaultLocation.lon) { city in
                    self.currentLocationLabel.text = city
                    self.hud.dismiss(animated: true)
                }
            }
        }
    }
    
    
    func updateUI(with weather: Weather) {
        tempLabel.text = "지금은 \(weather.temp)℃에요"
        humidityLabel.text = "\(weather.humidity)% 만큼 습해요"
        windLabel.text = "\(weather.windSpeed)m/s의 바람이 불어요"
        let url = URL(string: EndPoint.openWeatherIconEndPoint + weather.icon + "@2x.png")
        weatherImage.kf.setImage(with: url)
    }
    
    
    @IBAction func reloadButtonTapped(_ sender: UIButton) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
}




// MARK: - 위치 관련 User Defined 메서드
extension OpenWeatherViewController {
    
    func checkUserDeviceLocationServiceAuthorization() {
        
        guard CLLocationManager.locationServicesEnabled() else {
            showRequestLocationServiceAlert()
            return
        }
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("Default")
        }
    }
    
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
            self?.reloadData()
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
}




// MARK: - CLLocationManager Protocol
extension OpenWeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            userLocation = (coordinate.latitude, coordinate.longitude)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
}
