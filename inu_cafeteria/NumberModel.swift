//
//  NumberModel.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class NumberModel: NetworkModel {
    
//    func postNum(num: String, token: String){
//        
//        let params:[String:Any] = [
//            "code" : 123,
//            "token" : token,
//            "num" : num
//        ]
//        
//        Alamofire.request("\(baseURL)registerNumber", method: .post, parameters: params).responseJSON { res in
//            switch res.result {
//            case .success:
//                print(params)
//                print(res.result.value)
//                self.view.networkResult(resultData: true, code: "postnum")
//            case .failure(let error):
//                print(error)
//                self.view.networkFailed(code: gino(res.response?.statusCode))
//            }
//        }
//    }
    
    func registerNumber(code: Int, num1: Int, num2: Int?, num3: Int?){
        let token = gsno(FIRInstanceID.instanceID().token())
        print("firebase token:\(token)")
        let params:[String:Any] = [
            "code" : code,
            "num1" : num1,
            "num2" : num2 ?? -1,
            "num3" : num3 ?? -1,
            "token" : token
        ]
        print(params)
        
        Alamofire.request("\(baseURL)registerNumber", method: .post, parameters: params, headers: header).response { res in
            let code = gino(res.response?.statusCode)
//            print(gino(code))
//            print(res)
            
            if code == 200 {
                self.view.networkResult(resultData: true, code: "register_num")
            } else if code == 400 {
                self.view.networkFailed(code: code)
            } else {
                self.view.networkFailed()
            }
        }
    }
}
