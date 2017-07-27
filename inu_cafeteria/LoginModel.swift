//
//  LoginModel.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 22..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class LoginModel: NetworkModel {
    
    func logout(){
        userPreferences.removeObject(forKey: "auto_login")
        userPreferences.removeObject(forKey: "dtoken")
        
        let model = FlagModel()
        model.activeBarcode(0)
        
        DispatchQueue.main.async {
            Alamofire.request("\(baseURL)logout", method: .post, parameters: nil).response { res in
                //            print(res)
                let code = gino(res.response?.statusCode)
                print(code)
                
                if code == 200 {
                    self.view.networkResult(resultData: true, code: "logout")
                } else if code == 400 {
                    self.view.networkFailed(code: code)
                } else {
                    self.view.networkFailed()
                }
            }
        }
        
    }
    
    func autologin(_ dtoken:String){
        print(dtoken)
        let params:[String:Any] = [
            "dtoken" : dtoken
        ]
        
        Alamofire.request("\(baseURL)autologin", method: .post, parameters: params, headers: header).response { res in
            let code = gino(res.response?.statusCode)
            
            print("code:\(code)")
            if code == 200 {
                self.view.networkResult(resultData: true, code: "auto_login")
            } else if code == 400 {
                self.view.networkFailed(code: code)
            } else {
                self.view.networkFailed()
            }
        }
    }
    
    func login(_ id:String, _ pw:String, _ auto:Bool?){
//        userPreferences.setValue(id, forKey: "id")
//        userPreferences.setValue(pw, forKey: "pw")
        userPreferences.setValue(auto, forKey: "auto_login")
        
//        self.view.networkResult(resultData: true, code: "login")
        
        var autoS:String = ""
        if auto == true {
            autoS = "true"
        } else {
            autoS = "false"
        }
        
        let params:[String:Any]  = [
            "sno" : id,
            "pw" : pw,
            "device" : "iOS",
            "auto" : autoS
        ]
        
        Alamofire.request("\(baseURL)postlogin", method: .post, parameters: params, headers: header).responseObject { (res: DataResponse<LoginObject>) in
            
            let code = res.response?.statusCode
            
            switch res.result {
            case .success:
                print("success")
                
                if code == 200 {
//                    if auto == true {
//                        if let result = res.result.value {
//                            let json = result as! NSDictionary
//                            print(json)
//                            let dtoken = json["dtoken"] as! String
//                            print("dtoken:\(dtoken)")
//                            //                            let barcode = json["barcode"] as! Int
//                            //                            print("barcode:\(barcode)")
//                            //                            userPreferences.setValue(barcode, forKey: "barcode")
//                            userPreferences.setValue(dtoken, forKey: "dtoken")
//                        }
//                    }
                    let result = res.result.value
                    if let dtoken = result?.dtoken {
                        print("dtoken:\(dtoken)")
                        userPreferences.setValue(dtoken, forKey: "dtoken")
                    }
                    if let barcode = result?.barcode {
                        print("barcode:\(barcode)")
                        userPreferences.setValue(barcode, forKey: "barcode")
                    }
                    self.view.networkResult(resultData: true, code: "login")
                } else if code == 400 {
                    self.view.networkFailed(code: gino(code))
                }
            case .failure(let error):
                print(error)
                self.view.networkFailed()
            }

            
        }
        
//        Alamofire.request("\(baseURL)postlogin", method: .post, parameters: params, headers: header).responseJSON { res in
//            
//            let code = res.response?.statusCode
//            
//            switch res.result {
//            case .success:
////                print(res.result.value)
//                print("success")
//                
//                if code == 200 {
//                    if auto == true {
//                        if let result = res.result.value {
//                            let json = result as! NSDictionary
//                            print(json)
//                            let dtoken = json["dtoken"] as! String
//                            print("dtoken:\(dtoken)")
////                            let barcode = json["barcode"] as! Int
////                            print("barcode:\(barcode)")
////                            userPreferences.setValue(barcode, forKey: "barcode")
//                            userPreferences.setValue(dtoken, forKey: "dtoken")
//                        }
//                    }
//                    self.view.networkResult(resultData: true, code: "login")
//                } else if code == 400 {
//                    self.view.networkFailed(code: gino(code))
//                }
//            case .failure(let error):
//                print(error)
//                self.view.networkFailed()
//            }
//
//        }
//        
//        
        
        
            
//            print(res.response?.statusCode)
//                            print(res)
//            switch res.result {
//            case .success:
//                print(res.result)
//                self.view.networkResult(resultData: true, code: "login")
//            case .failure(let error):
//                print(error)
//                self.view.networkFailed(code: gino(res.response?.statusCode))
//            }
//        }
        
//        Alamofire.SessionManager(configuration: URLSessionConfiguration.default).request("\(baseURL)postlogin", method: .post, parameters: params, headers: header).response { res in
//            
//            let code = res.response?.statusCode
//            print(code)
//            if code == 200 {
//                self.view.networkResult(resultData: true, code: "login")
//            } else if code == 400 {
//                self.view.networkFailed(code: gino(code))
//            }
////            switch res.result {
////            case .success:
////                print(res.result)
////                self.view.networkResult(resultData: true, code: "login")
////            case .failure(let error):
////                print(error)
////                self.view.networkFailed(code: gino(res.response?.statusCode))
////            }
//        }
        
        //Post
//        let url:NSURL = NSURL(string: "\(baseURL)postlogin")!
//        let session = URLSession.shared
//        
//        let request = NSMutableURLRequest(url: url as URL)
//        request.httpMethod = "POST"
//        
//        let paramString = "sno=\(id)&pw=\(pw)&device=iOS"
//        request.httpBody = paramString.data(using: String.Encoding.utf8)
//        
//        let task = session.dataTask(with: request as URLRequest) {
//            (
//            data, response, error) in
//            
//            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
//                print("error")
//                return
//            }
//            
//            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(dataString!)
//            
//            OperationQueue.main.addOperation({ () -> Void in
//                if dataString == "false" {
//                    
//                    self.view.networkFailed(code: "400")
//                    
//                } else {
//                    
//                    self.view.networkResult(resultData: true, code: "login")
//                }
//            })
//            
//        }
//        
//        task.resume()
    }
}
