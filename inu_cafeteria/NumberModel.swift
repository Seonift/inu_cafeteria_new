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
    
    func getCode(){
        Alamofire.request("\(numberURL)getCode", method: .get, parameters: nil, headers: nil).responseJSON { res in
//            print(res.result.value)
            print("getcode")
            
            switch res.result {
            case .success:
                let json = res.result.value as? NSDictionary
                print(json)
                self.view.networkResult(resultData: json!, code: "getcode")
            case .failure:
                self.view.networkFailed()
            }
        }
    }
    
    func isNumberWait(){
        print("isnumberwait")
        let token = gsno(FIRInstanceID.instanceID().token())
        let params:[String:Any] = [
            "fcmtoken" : token
        ]
        print(params)
        
        Alamofire.request("\(numberURL)isNumberWait", method: .post, parameters: params, headers: header).responseJSON { res in
            let code = gino(res.response?.statusCode)
            print("code:\(code)")
            switch res.result {
            case .success:
                print("success")
                let json = res.result.value as? NSDictionary
//                print(json)
//                print(json?.count)
//                let count = json?.count
                if code == 200 {
                    self.view.networkResult(resultData: json!, code: "isnumberwait")
                } else if code == 400 {
                    self.view.networkFailed(code: "isnumberwait")
                }
            case .failure(let error):
                print("failure")
                print(error)
                self.view.networkFailed(code: "isnumberwait")
            }
//            print(res.result.value)
            
        }
    }
    
    func resetNumber(){
        print("resetNumber")
        let token = gsno(FIRInstanceID.instanceID().token())
        print("firebase token:\(token)")
        let params:[String:Any] = [
            "fcmtoken" : token
        ]
        
        Alamofire.request("\(numberURL)resetNumber", method: .post, parameters: params, headers: header).response { res in
            let code = gino(res.response?.statusCode)
            
            if code == 200 {
                self.view.networkResult(resultData: true, code: "reset_num")
            } else {
                self.view.networkFailed()
            }
        }
    }
    
    func count_number(num1:Int, num2:Int, num3:Int) -> Int {
        var count = 0
        if num1 != -1 {
            count += 1
        }
        if num2 != -1 {
            count += 1
        }
        if num3 != -1 {
            count += 1
        }
        
        return count
    }
    
    func registerNumber(code: Int, num1: Int, num2: Int?, num3: Int?){
        print("registerNumber")
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
        
//        self.view.networkResult(resultData: true, code: "register_num")
        
        Alamofire.request("\(numberURL)registerNumber", method: .post, parameters: params, headers: header).responseJSON { res in
            let code = gino(res.response?.statusCode)
            print(gino(code))
//            print(res)
            
            if code == 200 {
                self.view.networkResult(resultData: true, code: "register_num")
            } else if code == 400 {
                self.view.networkFailed(code: code)
            } else {
                self.view.networkFailed()
            }
        }
        
//        Alamofire.request(url, method: .post, parameters: params, headers: header).responseJSON { res in
////            print(res.response?.statusCode)
//            print(res)
//        }
    }
}
