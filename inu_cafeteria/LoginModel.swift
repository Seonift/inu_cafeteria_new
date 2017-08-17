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
    
    func no_student() {
        print("no_student")
        
        Alamofire.request("\(loginURL)getcode").responseObject { (res:DataResponse<InfoObject>) in
            let code = res.response?.statusCode
            switch res.result {
            case .success:
                print("success")
                let result = res.result.value
                if code == 200 {
                    guard let codes = result?.code else {
                        self.view.networkFailed(code: "no_code")
                        return
                    }
                    self.view.networkResult(resultData: codes, code: "no_student")
                } else {
                    //                    if code == 400 {
                    self.view.networkFailed(code: gino(code))
                }
            case .failure(let error):
                print(error)
                //                print("code:\(code)")
                if code != nil {
                    self.view.networkFailed(code: gino(code))
                } else {
                    self.view.networkFailed()
                }
            }
        }
    }
    
    func message(){
        print("message")
        
        Alamofire.request("\(loginURL)message").responseObject { (res:DataResponse<MessageObject>) in
            switch res.result {
            case .success:
                let val = res.result.value
                
                self.view.networkResult(resultData: val, code: "message")
                
            case .failure(let error):
                print(error)
                self.view.networkFailed(code: "message")
            }
        }
    }
    
//    func stuinfo(){
//        print("stuinfo")
////        self.view.networkResult(resultData: true, code: "stuinfo")
//        
//        Alamofire.request("\(loginURL)stuinfo", method: .get, parameters: nil, headers: nil)
////            .responseJSON {
////            res in
////            print(res)
////        }
//            .responseObject { (res:DataResponse<StudentInfo>) in
//            let code = gino(res.response?.statusCode)
//            switch res.result {
//            case .success:
//                if code == 200 {
//                    let result = res.result.value
//                    print(result)
//                    self.view.networkResult(resultData: result, code: "stuinfo")
//                } else if code == 400 {
//                    self.view.networkFailed(code: "stuinfo")
//                }
//            case .failure(let error):
//                print(error)
//                self.view.networkFailed()
//            }
//        }
//    }
    
    func logout(){
        Utility.removeAllUserDefaults()
        
        let model = FlagModel()
        model.activeBarcode(0)
        
        DispatchQueue.main.async {
            Alamofire.request("\(loginURL)logout", method: .post, parameters: nil).response { res in
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
    
    func autologin(){
        print("autologin")
        let dtoken = userPreferences.string(forKey: "dtoken")!
        let sno = userPreferences.string(forKey: "sno")!
        let params:[String:Any] = [
            "dtoken" : dtoken,
            "sno" : sno
        ]
        print(params)
        
        Alamofire.request("\(loginURL)autologin", method: .post, parameters: params, headers: header).responseObject { (res: DataResponse<InfoObject>) in
            let code = res.response?.statusCode
            
            switch res.result {
            case .success:
                print("success")
                if code == 200 {
                    userPreferences.setValue(sno, forKey: "sno")
                    let result = res.result.value
                    //여기도 바코드 넣기
                    guard let codes = result?.code else {
                        self.view.networkFailed(code: "no_code")
                        return
                    }
                    guard let stu_info = result?.stu_info else {
                        self.view.networkFailed(code: "no_stuinfo")
                        return
                    }
                    userPreferences.setValue(stu_info.name, forKey: "name")
                    userPreferences.setValue(stu_info.dep, forKey: "dep")
                    self.view.networkResult(resultData: codes, code: "auto_login")
                } else if code == 400 {
                    self.view.networkFailed(code: gino(code))
                }
            case .failure(let error):
                print(error)
                self.view.networkFailed()
            }
            
        }
        
//        Alamofire.request("\(loginURL)autologin", method: .post, parameters: params, headers: header).responseObject { (res:DataResponse<LoginObject>) in
//            let code = gino(res.response?.statusCode)
//            
//            print("code:\(code)")
//            if code == 200 {
//                let result = res.result.value
//                if let barcode = result?.barcode {
//                    userPreferences.setValue(barcode, forKey: "barcode")
//                    print("barcode:\(barcode)")
//                }
//                self.view.networkResult(resultData: true, code: "auto_login")
//            } else if code == 400 {
//                self.view.networkFailed(code: code)
//            } else {
//                self.view.networkFailed()
//            }
//        }
    }
    
    func login(_ sno:String, _ pw:String, _ auto:Bool?){
        print("login")
//        userPreferences.setValue(sno, forKey: "sno")
        userPreferences.setValue(auto, forKey: "auto_login")
        
//        self.view.networkResult(resultData: true, code: "login")
        
        var autoS:String = ""
        if auto == true {
            autoS = "true"
        } else {
            autoS = "false"
        }
        
        let params:[String:Any]  = [
            "sno" : sno,
            "pw" : pw,
            "device" : "iOS",
            "auto" : autoS
        ]
        
        Alamofire.request("\(loginURL)postlogin", method: .post, parameters: params, headers: header).responseObject { (res: DataResponse<InfoObject>) in
            let code = res.response?.statusCode
            
            switch res.result {
            case .success:
                print("success")
                
                if code == 200 {
                    userPreferences.setValue(sno, forKey: "sno")
                    let result = res.result.value
                    if let dtoken = result?.login?.dtoken {
                        print("dtoken:\(dtoken)")
                        userPreferences.setValue(dtoken, forKey: "dtoken")
                    }
                    if let barcode = result?.login?.barcode {
                        print("barcode:\(barcode)")
                        userPreferences.setValue(barcode, forKey: "barcode")
                    }
                    guard let codes = result?.code else {
                        self.view.networkFailed(code: "no_code")
                        return
                    }
                    guard let stu_info = result?.stu_info else {
                        self.view.networkFailed(code: "no_stuinfo")
                        return
                    }
                    userPreferences.setValue(stu_info.name, forKey: "name")
                    userPreferences.setValue(stu_info.dep, forKey: "dep")
                    self.view.networkResult(resultData: codes, code: "login")
                } else {
//                    if code == 400 {
                    self.view.networkFailed(code: gino(code))
                }
            case .failure(let error):
                print(error)
//                print("code:\(code)")
                if code != nil {
                    self.view.networkFailed(code: gino(code))
                } else {
                    self.view.networkFailed()
                }
            }
            
        }
        
//        Alamofire.request("\(loginURL)postlogin", method: .post, parameters: params, headers: header).responseObject { (res: DataResponse<LoginObject>) in
//            
//            let code = res.response?.statusCode
//            
//            switch res.result {
//            case .success:
//                print("success")
//                
//                if code == 200 {
//                    let result = res.result.value
//                    if let dtoken = result?.dtoken {
//                        print("dtoken:\(dtoken)")
//                        userPreferences.setValue(dtoken, forKey: "dtoken")
//                    }
//                    if let barcode = result?.barcode {
//                        print("barcode:\(barcode)")
//                        userPreferences.setValue(barcode, forKey: "barcode")
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
//            
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
