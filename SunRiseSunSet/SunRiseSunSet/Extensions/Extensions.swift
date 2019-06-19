//
//  Extensions.swift
//  SunRiseSunSet
//
//  Created by liza_kaganskaya on 6/18/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation
import CoreLocation


extension String {
    
    
    func UtcToLocalTime() -> String {
        
        let dateFormatter = DateFormatter()
        
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from: self)!
        
            dateFormatter.dateFormat = "HH:mm:ss"
        
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}



