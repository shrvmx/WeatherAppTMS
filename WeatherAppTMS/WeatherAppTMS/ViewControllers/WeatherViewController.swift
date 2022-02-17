//
//  ViewController.swift
//  WeatherAppTMS
//
//  Created by maxim shiryaev on 3.12.21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentConditionsLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var daysSegmentedControl: UISegmentedControl!
    @IBOutlet weak var daysWeatherView: UIView!
    @IBOutlet weak var daysWeatherTableView: UITableView!
    @IBOutlet weak var daysDateLabel: UILabel!
    @IBOutlet weak var daysTemperatureLabel: UILabel!
    @IBOutlet weak var citiesTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var citiesBottomConstraina: NSLayoutConstraint!
    @IBOutlet var weatherMainView: UIView!
    @IBOutlet weak var addToFavorites: UIButton!
    
    
    public var weatherData: WeatherData?
    private var citiesData: [Cities]?
    private let locationManager = CLLocationManager()
    public var selectedDayIndex = 0
    private var forecastCollectionViewCell = ForecastCollectionViewCell()
    private var daysWeatherTableViewCell = DaysWeatherTableViewCell()
    private var favorites: FavoritesCityService = FavoritesCityService.shared
    private var cities: [Cities] = []
    private var searchResaults: [Cities] = []
    private let blackView = UIView()
    private let favoritesTableView: UITableView = {
        let favTableView = UITableView(frame: .zero)
//        favTableView.backgroundColor = .white
        return favTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationManager()
        
        citySearchBar.delegate = self
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
        daysWeatherTableView.delegate = self
        daysWeatherTableView.dataSource = self
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        self.daysWeatherTableView.tag = 0
        self.citiesTableView.tag = 1
        self.favoritesTableView.tag = 2
        
        self.forecastCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: nil),
                                             forCellWithReuseIdentifier: "ForecastCollectionViewCell")
        self.daysWeatherTableView.register(UINib(nibName: "DaysWeatherTableViewCell", bundle: nil),
                                           forCellReuseIdentifier: "DaysWeatherTableViewCell")
        self.citiesTableView.register(UINib(nibName: "CitiesTableViewCell", bundle: nil),
                                      forCellReuseIdentifier: "CitiesTableViewCell")
        self.favoritesTableView.register(FavoritesTableViewCell.self,
                                         forCellReuseIdentifier: FavoritesTableViewCell.reuseID)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        daysWeatherView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        daysWeatherView.layer.cornerRadius = 20
        daysWeatherTableView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        daysWeatherTableView.layer.cornerRadius = 20
        daysWeatherView.isHidden = true
        citiesTableView.isHidden = true
        currentWeatherView.layer.cornerRadius = 20
        currentWeatherView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        forecastCollectionView.layer.cornerRadius = 20
        forecastCollectionView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        citiesTableView.layer.cornerRadius = 20
        citiesTableView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        favoritesTableView.layer.cornerRadius = 15
        favoritesTableView.backgroundColor = UIColor(red: 0.43,
                                                      green: 0.78,
                                                      blue: 0.85,
                                                      alpha: 1.00)
    }
    
    @IBAction func closeDaysWeatherView(_ sender: Any) {
        self.forecastCollectionView.reloadData()
        self.daysWeatherView.fadeOut()
        self.currentWeatherLabel.fadeIn()
        self.currentWeatherView.fadeIn()
    }
    
    @IBAction func daysControl(_ sender: Any) {
        forecastCollectionView.reloadData()
    }
    
    @IBAction func favoritesButtunPressed(_ sender: Any) {
        configureBlackView()
        favoritesTableView.reloadData()
    }
    @IBAction func addToFavoritesButton(_ sender: Any) {
        
        if favorites.getCities().contains(cityLabel.text!) {
            favorites.removeCity(city: cityLabel.text!)
            addToFavorites.setImage(UIImage(systemName: "bookmark"), for: .normal)
        } else {
            favorites.addCity(city: cityLabel.text!)
            addToFavorites.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        print("button pressed")
    }
    
    
    // MARK: - func
    
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    private func configureBlackView() {
        
        self.blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        weatherMainView.addSubview(blackView)
        weatherMainView.addSubview(favoritesTableView)
        blackView.frame = weatherMainView.frame
        blackView.alpha = 0
        
        favoritesTableView.frame = CGRect(x: 0,
                                          y: 50,
                                          width: 0,
                                          height: weatherMainView.frame.height)
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.blackView.alpha = 1
            self.favoritesTableView.frame = CGRect(x: 0,
                                                   y: 50,
                                                   width: 200,
                                                   height: self.favoritesTableView.frame.height)
        } completion: { (finished) in }
    }
    
    @objc func handleDismiss() {
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.blackView.alpha = 0
            self.favoritesTableView.frame = CGRect(x: 0,
                                                   y: 50,
                                                   width: 0,
                                                   height: self.weatherMainView.frame.height)
        } completion: { (finished) in }
    }
    
    private func setupWeatherViewFromCity() {
        if let address = self.weatherData?.address {
            self.cityLabel.text = address
        } else {
            self.cityLabel.text = "No info"
        }

        if let conditions = self.weatherData?.currentConditions.conditions {
            self.currentConditionsLabel.text = conditions
        } else {
            self.currentConditionsLabel.text = "No info"
        }

        if let temperature = self.weatherData?.currentConditions.temp {
            self.currentTemperatureLabel.text = "\(Int(temperature))°"
        } else {
            self.currentTemperatureLabel.text = "No info"
        }

        if let humidity = self.weatherData?.currentConditions.humidity {
            self.humidityLabel.text = "\(Int(humidity))%"
        } else {
            self.humidityLabel.text = "No info"
        }

        if let windSpeed = self.weatherData?.currentConditions.windspeed {
            self.windSpeedLabel.text = "\(Int(windSpeed)) kph"
        } else {
            self.windSpeedLabel.text = "No info"
        }
    }
    
    public func setupWeatherViewFromCoordinate() {
        if let address = self.weatherData?.timezone?.replacingOccurrences(of: "/", with: " ") {
            self.cityLabel.text = address
        } else {
            self.cityLabel.text = "No info"
        }

        if let conditions = self.weatherData?.currentConditions.conditions {
            self.currentConditionsLabel.text = conditions
        } else {
            self.currentConditionsLabel.text = "No info"
        }

        if let temperature = self.weatherData?.currentConditions.temp {
            self.currentTemperatureLabel.text = "\(Int(temperature))°"
        } else {
            self.currentTemperatureLabel.text = "No info"
        }

        if let humidity = self.weatherData?.currentConditions.humidity {
            self.humidityLabel.text = "\(Int(humidity))%"
        } else {
            self.humidityLabel.text = "No info"
        }

        if let windSpeed = self.weatherData?.currentConditions.windspeed {
            self.windSpeedLabel.text = "\(Int(windSpeed)) kph"
        } else {
            self.windSpeedLabel.text = "No info"
        }
    }
}


//MARK: - UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchTextBar: UISearchBar) {
        searchTextBar.setShowsCancelButton(true, animated: true)
 
        if let path = Bundle.main.path(forResource: "Cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let citiesData = try JSONDecoder().decode([Cities].self, from: data)
                self.cities = citiesData
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        self.citiesTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchResaults = self.cities.filter({$0.name.contains(searchText)})
        
        self.citiesTableView.isHidden = false
        self.citiesTableViewConstraint.constant = 0
        self.citiesBottomConstraina.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        citiesTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchTextBar: UISearchBar) {
        self.view.endEditing(true)
        searchTextBar.setShowsCancelButton(false, animated: true)
        citiesTableView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let city = citySearchBar.text!.replacingOccurrences(of: " ", with: "%20")
        
        cityLabel.text = citySearchBar.text
        
        addToFavorites.setImage(UIImage(systemName: "bookmark"), for: .normal)
        
        if favorites.getCities().contains(cityLabel.text!) {
            addToFavorites.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        
        favoritesTableView.reloadData()
        
        citiesTableView.isHidden = true
        
        NetworkManager.shared.getWeather(from: city) { model in
            self.weatherData = model
            DispatchQueue.main.async {
                self.setupWeatherViewFromCity()
                self.forecastCollectionView.reloadData()
            }
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        let city = citySearchBar.text!.replacingOccurrences(of: " ", with: "%20")
        
        citiesTableView.isHidden = true
        
//        addToFavorites.setImage(UIImage(systemName: "bookmark"), for: .normal)
//
//        if favorites.getCities().contains(cityLabel.text!) {
//            addToFavorites.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
//        }
        
        NetworkManager.shared.getWeather(from: city) { model in
            self.weatherData = model
            DispatchQueue.main.async {
                self.setupWeatherViewFromCity()
                self.forecastCollectionView.reloadData()
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.weatherData?.days?.count ?? 0
//        return 7
        switch daysSegmentedControl.selectedSegmentIndex {
        case 0:
            return 3
        case 1:
            return 7
        default:
            break
        }
        
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as! ForecastCollectionViewCell
        
        cell.dateLabel.text = weatherData?.days![indexPath.item].datetime
        
        if let collectionTemp = weatherData?.days![indexPath.item].temp {
            cell.forecastTemperatureLabel.text = "\(Int(collectionTemp))°"
        } else {
            print("No info")
        }
        
        if let collectionMaxTemp = weatherData?.days![indexPath.item].tempmax {
            cell.maxTemperatureLabel.text = "\(Int(collectionMaxTemp))°"
        } else {
            print("No info")
        }
        
        if let collectionMinTemp = weatherData?.days![indexPath.item].tempmin {
            cell.minTemperatureLabel.text = "\(Int(collectionMinTemp))°"
        } else {
            print("No info")
        }
        
//        cell.forecastTemperatureLabel.text = "\(Int((weatherData?.days![indexPath.row].temp)!))°"
//        cell.maxTemperatureLabel.text = "\(Int((weatherData?.days![indexPath.row].tempmax)!))°"
//        cell.minTemperatureLabel.text = "\(Int((weatherData?.days![indexPath.row].tempmin)!))°"
        
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension WeatherViewController: UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 130)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDayIndex = indexPath.item
        DispatchQueue.main.async {
//            self.forecastCollectionViewCell.cellIsSelected()
            self.currentWeatherView.fadeOut()
            self.currentWeatherLabel.fadeOut()
            self.daysWeatherView.fadeIn()
            self.daysWeatherView.isHidden = false
            self.daysWeatherTableView.reloadData()
            
            if let daysDate = self.weatherData?.days?[indexPath.item].datetime {
                self.daysDateLabel.text = daysDate
            } else {
                print("No info")
            }
            
            if let daysTemp = self.weatherData?.days?[indexPath.item].temp {
                self.daysTemperatureLabel.text = "\(Int(daysTemp))°"
            } else {
                print("No info")
            }
            
            
            
        }
        
        print(indexPath)
    }
}

//MARK: - Location
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let lastLocation = locations.last {
            let latitude = lastLocation.coordinate.latitude
            let longitude = lastLocation.coordinate.longitude
            NetworkManager.shared.getWeather(from: (latitude: latitude, longitude: longitude)) { model in
                self.weatherData = model
                DispatchQueue.main.async {
                    self.setupWeatherViewFromCoordinate()
                    self.forecastCollectionView.reloadData()
                }
            }
            print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
        }
    }
}

 //MARK: - TableView
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate  {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         return 10
        switch tableView.tag {
        case 0:
            return 10
        case 1:
            return self.searchResaults.count
        case 2:
            return favorites.getCities().count
        default:
            break
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch tableView.tag {
        
        // more forecast table view
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DaysWeatherTableViewCell", for: indexPath) as! DaysWeatherTableViewCell

            switch indexPath.row {
            case 0:
                cell.daysWeatherImageView.image = UIImage(systemName: "cloud.sun.rain.fill")
                if let conditions = weatherData?.days?[self.selectedDayIndex].conditions {
                    cell.daysWeatherLabel.text = conditions
                } else {
                    print("No data")
                }
            case 1:
                cell.daysWeatherImageView.image = UIImage(systemName: "humidity.fill")
                if let humidity = weatherData?.days?[self.selectedDayIndex].humidity {
                   cell.daysWeatherLabel.text = "\(Int(humidity))%"
                } else {
                    print("No data")
                }
            case 2:
                cell.daysWeatherImageView.image = UIImage(systemName: "wind")
                if let windSpeed = weatherData?.days?[self.selectedDayIndex].windspeed {
                    cell.daysWeatherLabel.text = "\(Int(windSpeed)) kph"
                } else {
                    print("No data")
                }
            case 3:
                cell.daysWeatherImageView.image = UIImage(systemName: "thermometer")
                if let feelsLike = weatherData?.days?[self.selectedDayIndex].feelslike {
                    cell.daysWeatherLabel.text = "feels like \(Int(feelsLike))°"
                } else {
                    print("No data")
                }
            case 4:
                cell.daysWeatherImageView.image = UIImage(systemName: "sunrise.fill")
                if let sunrise = weatherData?.days?[self.selectedDayIndex].sunrise {
                    cell.daysWeatherLabel.text = sunrise
                } else {
                    print("No data")
                }
            case 5:
                cell.daysWeatherImageView.image = UIImage(systemName: "sunset")
                if let sunset = weatherData?.days?[self.selectedDayIndex].sunset {
                    cell.daysWeatherLabel.text = sunset
                } else {
                    print("No data")
                }
            case 6:
                cell.daysWeatherImageView.image = UIImage(systemName: "icloud.and.arrow.up.fill")
                if let cloudCover = weatherData?.days?[self.selectedDayIndex].cloudcover {
                    cell.daysWeatherLabel.text = "cloud cover \(Int(cloudCover))%"
                } else {
                    print("No data")
                }
            case 7:
                cell.daysWeatherImageView.image = UIImage(systemName: "binoculars.fill")
                if let visibility = weatherData?.days?[self.selectedDayIndex].visibility {
                    cell.daysWeatherLabel.text = "\((visibility)) km"
                } else {
                    print("No data")
                }
            case 8:
                cell.daysWeatherImageView.image = UIImage(systemName: "thermometer.sun.fill")
                if let tempMax = weatherData?.days?[self.selectedDayIndex].tempmax {
                    cell.daysWeatherLabel.text = "\(Int(tempMax))°"
                } else {
                    print("No data")
                }
            case 9:
                cell.daysWeatherImageView.image = UIImage(systemName: "thermometer.snowlake")
                if let tempMin = weatherData?.days?[self.selectedDayIndex].tempmin {
                    cell.daysWeatherLabel.text = "\(Int(tempMin))°"
                } else {
                    print("No data")
                }
            default:
                break
            }
                return cell
            
        // cities search table view
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesTableViewCell", for: indexPath) as! CitiesTableViewCell
            
            cell.textLabel?.text = self.searchResaults[indexPath.row].name

            return cell
            
        // favorites table view
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.reuseID) as! FavoritesTableViewCell
            
            cell.backgroundColor = UIColor(red: 0.43,
                                            green: 0.78,
                                            blue: 0.85,
                                            alpha: 1.00)
            cell.textLabel?.text = favorites.getCities()[indexPath.row]
            
            return cell

        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "CitiesTableViewCell", for: indexPath) as! CitiesTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch tableView.tag {
        case 1:
            if let cell = citiesTableView.cellForRow(at: indexPath) {
                citySearchBar.text = cell.textLabel?.text
                citiesTableView.isHidden = true
            }
        case 2:
            if let cell = favoritesTableView.cellForRow(at: indexPath) {
                NetworkManager.shared.getWeather(from: (cell.textLabel?.text)!) { model in
                    self.weatherData = model
                    DispatchQueue.main.async {
                        self.setupWeatherViewFromCity()
                        self.forecastCollectionView.reloadData()
                        self.handleDismiss()
                        self.addToFavorites.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                        self.citySearchBar.text = nil
                    }
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        switch tableView.tag {
        case 2:
            return .delete
        default:
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch tableView.tag {
        case 2:
            if editingStyle == .delete {
                tableView.beginUpdates()
                
                favorites.cities.remove(at: indexPath.row)
                favorites.defaults.set(favorites.cities, forKey: favorites.stringKey)
                self.addToFavorites.setImage(UIImage(systemName: "bookmark"), for: .normal)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                tableView.endUpdates()
            }
        default:
            break
        }
    }
}

// MARK: - UIView extension
extension UIView {
    func fadeIn(duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0

        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0

        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
      }
    }
