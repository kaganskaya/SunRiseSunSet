//
//  Presenter.swift
//  SunRiseSunSet
//
//  Created by liza_kaganskaya on 6/18/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation
import RxSwift

class Presenter {
    var np = NetworkProvider()
    private var disposeBag = DisposeBag()
    weak var view:MainView?
    
    
    func getSunInfo(long:String,latt:String){
        
        self.np.serachSunInfo(long: long, latt: latt)
            .subscribe(
                onNext: { n in

            self.view?.showSunInfo(results: n)


        }, onError: { err in
            print(err.localizedDescription)

        }, onCompleted: {
            //print(" onCompleted")
        }, onDisposed: {
            //print("onDisposed")
        }).disposed(by: disposeBag)
    }
}
