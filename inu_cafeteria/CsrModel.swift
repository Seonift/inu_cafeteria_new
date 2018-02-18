//
//  CsrModel.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Alamofire

class CsrModel: NetworkModel {
    
    func errormsg(msg: String){
        
        guard let sno = userPreferences.string(forKey: "sno") else {
            self.view?.networkFailed()
            return
        }
//        guard let name = userPreferences.string(forKey: "name") else {
//            self.view?.networkFailed()
//            return
//        }
        
        let params = [
            "sno" : sno,
//            "name" : name,
            "msg" : msg
        ]
        
        Alamofire.request("\(loginURL)errormsg", method: .post, parameters: params, headers: header).response { res in
            
            let code = res.response?.statusCode
            if code == 200 {
                self.view?.networkResult(resultData: true, code: "errormsg")
            } else {
                self.view?.networkFailed()
            }
        }
        
    }
}
