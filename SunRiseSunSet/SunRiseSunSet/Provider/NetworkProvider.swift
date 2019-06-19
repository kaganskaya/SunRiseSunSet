//
//  NetWorkProvider.swift
//  SunRiseSunSet
//
//  Created by liza_kaganskaya on 6/18/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class NetworkProvider {
    
    func serachSunInfo(long:String,latt:String) -> Observable<[String]> {
        
        let url = "https://api.sunrise-sunset.org/json?lat=\(latt)&lng=\(long)"
        
        var results:[String] = []

        return Observable<[String]>.create { observer  in
            
            let request = Alamofire
                
                .request(url, method: .get,encoding: JSONEncoding.default)
                
                .validate()
                
                .responseJSON { response in
                    
                    do{
                    
                        if response.data != nil {
                            
                            let json = try JSON(data: response.data!)
                    
                            let sunrise = json["results"]["sunrise"].string
                            let sunset = json["results"]["sunset"].string
                            
                                results.append(sunrise!)
                                results.append(sunset!)
                           
                            if results.count != 0 {
                                observer.onNext(results)
                                observer.onCompleted()
                            }
                        }
                       
                    }catch let er as NSError{
                        
                        observer.onError(er)
                    }

            }
            
            
            return Disposables.create(with: {
                request.cancel()
            })
        }
        
    }
    
}
