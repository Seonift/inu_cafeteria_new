//
//  FlagModel.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 28..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Alamofire

class FlagModel {
    //바코드 활성화1 비활성화0
    
    func activeBarcode(_ value:Int){
        if (value == 1 && (userPreferences.integer(forKey: "barcode_flag") == 0 || userPreferences.object(forKey: "barcode_flag") == nil)) || value == 0{
            userPreferences.setValue(value, forKey: "barcode_flag")
            print("activebarcode:\(value)")
            let params:[String:Any] = [
                "flag" : value
            ]
            
            Alamofire.request("\(loginURL)activeBarcode", method: .post, parameters: params, headers: header).response { res in
                //            print(res)
                print(res.response?.statusCode)
            }
        }
    }
}
