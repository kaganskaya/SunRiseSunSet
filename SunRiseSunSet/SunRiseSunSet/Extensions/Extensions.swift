//
//  Extensions.swift
//  SunRiseSunSet
//
//  Created by liza_kaganskaya on 6/18/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    func getPlace(completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(self) { placemarks, error in
            
             if error != nil  {
                print(error!.localizedDescription)
                completion(nil)
                
            }
            
            guard let placemark = placemarks?[0] else {
                print("Error - placemark is nil")
                completion(nil)
                return
            }
           
            completion(placemark)
        }
    }
    
}



