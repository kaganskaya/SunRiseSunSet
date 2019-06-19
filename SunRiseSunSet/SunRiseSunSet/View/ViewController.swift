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

class ViewController: UIViewController,UISearchBarDelegate,CLLocationManagerDelegate,MainView  {


    @IBOutlet weak var sunRiseTime: UILabel!
    @IBOutlet weak var sunSetTime: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBAction func search(_ sender: Any) {
        
        let searchField = UISearchController(searchResultsController: nil)
        
            searchField.searchBar.delegate = self
        
            searchField.searchBar.barTintColor = .black
        
        present(searchField, animated: true , completion: nil)
    }
    
    
    let presenter = Presenter()
    
    var results: [String] = []
    var locationManager = CLLocationManager()

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
           
            
        }

        self.presenter.view = self

    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let authState = CLLocationManager.authorizationStatus()
       
        if(authState == .authorizedAlways || authState == .authorizedWhenInUse){
            setupLocation(location: locationManager.location!)
            
        }
    }
    
    
    func setupLocation(location:CLLocation){
        
        self.activity.isHidden = false
        self.activity.startAnimating()
        
        self.presenter.getSunInfo(long:(location.coordinate.longitude.description), latt: (location.coordinate.latitude.description))

        location.getPlace() {placemark in
            
            guard let placemark = placemark else { return }
            
            if placemark.locality != nil && placemark.country != nil {
            
                self.placeLabel.text = placemark.locality! + ",\n" + placemark.country!
                
            }else{
                self.placeLabel.text = placemark.name

            }
            
        }
       

       
    }
    
    

    func showSunInfo(results: [String]) {
      
        self.results = results
        
        self.sunRiseTime.text = results[0].UtcToLocalTime()
        self.sunSetTime.text =  results[1].UtcToLocalTime()
        
        self.activity.stopAnimating()
        self.activity.isHidden = true

    }
  

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        
        let serachRequest = MKLocalSearch.Request()
        
            serachRequest.naturalLanguageQuery = searchBar.text
        
        let request = MKLocalSearch(request: serachRequest)
            request.start { (response,error) in
            
            
            if response == nil {
                
                print("No data found")
                
            }else{
                
                let longitude = response?.boundingRegion.center.longitude
                
                let lattitude = response?.boundingRegion.center.latitude
                
                let location = CLLocation(latitude: lattitude!, longitude: longitude!)
                
                self.setupLocation(location: location)
                      
            }
        
        }
        
    }
    
    
    
    
}
