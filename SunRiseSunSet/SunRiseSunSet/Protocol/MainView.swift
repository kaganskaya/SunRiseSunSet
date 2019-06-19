//
//  MainView.swift
//  SunRiseSunSet
//
//  Created by liza_kaganskaya on 6/18/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation
import GooglePlaces

protocol MainView:class {
    func showSunInfo(results:[String])
    func getPlace(place:GMSPlace)
}
