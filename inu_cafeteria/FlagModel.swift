//
//  FlagModel.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 28..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Alamofire

class FlagModel: NetworkModel {
    
    let _activeBarcode = "activeBarcode"
    
    //바코드 활성화1 비활성화0
    
    func activeBarcode(_ value: Int){
        guard let barcode = userPreferences.getBarcode() else {
            self.view?.networkFailed(errorMsg: String.no_barcode, code: _activeBarcode)
            return
        }
        let params:Parameters = [
            "barcode" : barcode,
            "activated" : value
        ]
        
        Alamofire.request("\(BASE_URL)/\(_activeBarcode)", method: .post, parameters: params, headers: header).responseJSON { res in
            guard let code = res.response?.statusCode else {
                self.view?.networkFailed(errorMsg: .noServer, code: self._activeBarcode)
                return
            }
            
            if self.isSuccess(statusCode: code), let json = res.result.value as? NSDictionary, let activeValue = json["active"] as? String, String(value) == activeValue {
                if value == 1 {
                    log.debug("barcode activated")
                } else if value == 0 {
                    log.debug("barcode deactivated")
                }
                self.view?.networkResult(resultData: true, code: self._activeBarcode)
            } else {
                self.view?.networkFailed(errorMsg: .noServer, code: self._activeBarcode)
            }
        }
    }
    
//    func activeBarcode123(_ value:Int){
//        if (value == 1 && (userPreferences.integer(forKey: "barcode_flag") == 0 || userPreferences.object(forKey: "barcode_flag") == nil)) || value == 0{
//            userPreferences.setValue(value, forKey: "barcode_flag")
//            print("activebarcode:\(value)")
//
//            guard let barcode = userPreferences.getBarcode() else { return }
//
//            let params:[String:Any] = [
//                "flag" : value,
//                "barcode" : barcode
//            ]
//
//            Alamofire.request("\(BASE_URL)activeBarcode", method: .post, parameters: params, headers: header).response { res in
//                //            print(res)
////                print("code:\(res.response?.statusCode)")
//                guard let code = res.response?.statusCode else {
//                    self.view?.networkFailed(errorMsg: "", code: "activebarcode")
//                    return
//                }
//                if code == 200 {
//                    self.view?.networkResult(resultData: value, code: "activebarcode")
//                } else {
//                    self.view?.networkFailed(errorMsg: "", code: "activebarcode")
//                }
//            }
//        }
//    }
//
//    func deactiveBarcode123(_ value: Int){
//        if (value == 1 && (userPreferences.integer(forKey: "barcode_flag") == 0 || userPreferences.object(forKey: "barcode_flag") == nil)) || value == 0{
//            userPreferences.setValue(value, forKey: "barcode_flag")
//            print("activebarcode:\(value)")
//
//            guard let barcode = userPreferences.getBarcode() else { return }
//
//            let params:[String:Any] = [
//                "flag" : value,
//                "barcode" : barcode
//            ]
//
//            Alamofire.request("\(BASE_URL)activeBarcode", method: .post, parameters: params, headers: header).response { res in
//                //            print(res)
//                if let code = res.response?.statusCode {
//                    print("code : \(code)")
//                }
//            }
//        }
//    }
}

