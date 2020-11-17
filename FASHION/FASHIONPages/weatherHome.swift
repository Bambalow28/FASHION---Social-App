//
//  weatherHome.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-09-21.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class weatherHome: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    let apiKey = "d205ef8563ed4398f5b77dec5eeb8d03"
    var lat = 11.344533
    var lon = 102.33322
    var activityIndicator: UIActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather"

        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        
        activityIndicator = UIActivityIndicatorView(frame: indicatorFrame)
        activityIndicator.backgroundColor = UIColor.clear
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        activityIndicator.startAnimating()
        
        if(CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
    }
    
    //Toolbar Controls
    @IBAction func homeBtnClicked(_ sender: Any) {
    transitionToHome()
    }
    @IBAction func closetMenuClicked(_ sender: Any) {
        transitionToClosetMenu()
    }
    @IBAction func addPostClicked(_ sender: Any) {
        transitionToPost()
    }
    @IBAction func weatherClicked(_ sender: Any) {
        transitionToWeather()
    }
    @IBAction func userProfileClicked(_ sender: Any) {
        transitionToProfile()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON { (response) in
            
            self.activityIndicator.stopAnimating()
            
            switch response.result {
                    case .success(let value):
                        let jsonResponse = JSON(value)
                        let jsonWeather = jsonResponse["weather"].array![0]
                        let jsonTemp = jsonResponse["main"]
                        let iconName = jsonWeather["icon"].stringValue
                        
                        self.cityLabel.text! = jsonResponse["name"].stringValue
                        self.weatherView.image = UIImage(named: iconName)
                        self.weatherLabel.text! = jsonWeather["main"].stringValue
                        self.tempLabel.text! = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                        
                        let date = Date()
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "EEEE"
                        self.dayLabel.text! = dateFormat.string(from: date)
                        
                    case .failure(let error):
                        print(error)
                    }
        }
        
    }
    
    func transitionToHome() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainHome") as! mainHome
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToClosetMenu() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "closetMenu") as! closetMenu
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToWeather() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "weatherHome") as! weatherHome
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToProfile() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "userProfile") as! userProfile
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToPost() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "makePosts") as! makePosts
        
        newViewController.modalPresentationStyle = .overCurrentContext
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
}
