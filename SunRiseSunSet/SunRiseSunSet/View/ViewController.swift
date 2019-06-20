//
//  ViewController.swift
//  SunRiseSunSet
//
//  Created by liza_kaganskaya on 6/18/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GooglePlaces

class ViewController: UIViewController,UISearchBarDelegate,CLLocationManagerDelegate,MainView  {
    


    @IBOutlet weak var sunRiseTime: UILabel!
    @IBOutlet weak var sunSetTime: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBAction func touchLocationIcon(_ sender: Any) {
        
        setupLocation(location: locationManager.location!)
    }
    
    @IBAction func search(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
       
            autocompleteController.delegate = self
        
        present(autocompleteController, animated: true, completion: nil)
    }
   
    let presenter = Presenter()
    var place: GMSPlace!
    var results: [String] = []
    var locationManager = CLLocationManager()
    var loaded:Bool = false
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
//the default location for simulators was settled to Sydney,Australia
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
           
            
        }else{
         
            let alert = UIAlertController(title: "Alert", message: "Turn on Location service to use this app", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
           
            DispatchQueue.main.async {
               self.present(alert, animated: true, completion: nil)
            }
        }

        self.presenter.view = self

    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let authState = CLLocationManager.authorizationStatus()

        if(authState == .authorizedAlways || authState == .authorizedWhenInUse){
           
        if !self.loaded {
            
            self.loaded = true
            setupLocation(location: locationManager.location!)
        
        }
        
        }
    }
    
    
    func setupLocation(location:CLLocation){
        
        self.activity.isHidden = false
        self.activity.startAnimating()
        
        self.presenter.getSunInfo(long:(location.coordinate.longitude.description), latt: (location.coordinate.latitude.description))
        self.presenter.getPlace()
        
    }
    
    
    func getPlace(place: GMSPlace) {
        self.place = place
        self.placeLabel.text = place.name
    }

    
    func showSunInfo(results: [String]) {
      
        self.results = results
        
        self.sunRiseTime.text = results[0].UtcToLocalTime()
        self.sunSetTime.text =  results[1].UtcToLocalTime()
        
        self.activity.stopAnimating()
        self.activity.isHidden = true

    }
  
    
}


extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        dismiss(animated: true, completion: nil)
        
        self.placeLabel.text = place.name
        
        self.presenter.getSunInfo(long: place.coordinate.longitude.description, latt: place.coordinate.latitude.description)

    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

}
