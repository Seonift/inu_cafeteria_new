//
//  NetworkModel.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 6. 2..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

//let baseURL = 
//let loginURL = ""
//let numberURL = ""
//let socketURL = ""


let header:[String:String] = [
    "Content-Type" : "application/x-www-form-urlencoded"
]

let jsonheader:[String:String] = [
    "Content-Type" : "application/json"
]


class NetworkModel {
    
    //뷰컨트롤러로 데이터를 전달해줄 위임자를 나타내주는 변수
    
    //callbackDelegate
    var view : NetworkCallback?
    
    
    init(_ vc : NetworkCallback){
        self.view = vc
    }
    
    init() { }
    
    func isSuccess(statusCode code: Int) -> Bool {
        switch code {
        case 200:
            return true
        default:
            return false
        }
    }
    
    func errorMsg(code: Int) -> String {
        switch code {
        case 400:
            return .checkId
        case 401:
            return .noToken
        case 402:
            return .dbERROR
        case 403:
            fallthrough
        default:
            return "오류"
        }
    }
    
    func post<T:Mappable>(function name:String, type: T.Type, params:Parameters? = nil, headers: HTTPHeaders? = header) {
        log.info(name)
        
        Alamofire.request("\(BASE_URL)/\(name)", method: .post, parameters: params, headers: headers).responseObject { (res: DataResponse<T>) in
            self.networkResult(function: name, statusCode: res.response?.statusCode, item: res.result.value)
            }.responseArray { (res: DataResponse<[T]>) in
                self.networkResult(function: name, statusCode: res.response?.statusCode, item: res.result.value)
        }
    }
    
    func post(function name:String, params:Parameters? = nil, headers: HTTPHeaders? = header) {
        log.info(name)
        Alamofire.request("\(BASE_URL)/\(name)", method: .post, parameters: params, headers: headers).response { res in
            self.networkResult(function: name, statusCode: res.response?.statusCode, item: "")
        }
    }
    
    func get<T:Mappable>(function name:String, type: T.Type, params:Parameters? = nil) {
        log.info(name)
        
        Alamofire.request("\(BASE_URL)/\(name)").responseObject { (res: DataResponse<T>) in
            self.networkResult(function: name, statusCode: res.response?.statusCode, item: res.result.value)
            }.responseArray { (res: DataResponse<[T]>) in
                self.networkResult(function: name, statusCode: res.response?.statusCode, item: res.result.value)
        }
    }
    
    func get(function name:String, params:Parameters? = nil) {
        log.info(name)
        Alamofire.request("\(BASE_URL)/\(name)").response { res in
            self.networkResult(function: name, statusCode: res.response?.statusCode, item: "")
        }
    }
    
    func networkResult(function name:String, statusCode code: Int? = nil, item: Any? = nil) {
        log.info(name)
        guard let code = code else {
            self.view?.networkFailed(errorMsg: name, code: name)
            return
        }
        
        if !self.isSuccess(statusCode: code) {
            self.view?.networkFailed(errorMsg: self.errorMsg(code: code), code: name)
            return
        }
        guard let item = item else {
            Indicator.stopAnimating()
            return
        }
        
        if self.isSuccess(statusCode: code) {
            self.view?.networkResult(resultData: item, code: name)
        } else {
            self.view?.networkFailed(errorMsg: self.errorMsg(code: code), code: name)
        }
    }
    
    /////////
    
    let _ads = "ads.json"
    let _foodplan = "food"
    
    func ads() {
        get(function: _ads, type: AdObject.self)
    }
    
    func foodplan() {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
//        get(function: "food/\(formatter.string(from: today))", type: FoodObject.self)
//        get(function: "food/20180223", type: FoodObject.self)
        
//        Alamofire.request("\(BASE_URL)food/\(20180223)").responseObject { (res: DataResponse<FoodObject>) in
//            self.networkResult(function: self._foodplan, statusCode: res.response?.statusCode, item: res.result.value)
//        }
        
        Alamofire.request("\(BASE_URL)/food/\(formatter.string(from: today))").responseJSON { res in
            guard let code = res.response?.statusCode else {
                self.view?.networkFailed(errorMsg: String.noServer, code: self._foodplan)
                return
            }
            
            switch res.result {
            case .success(let item):
                if self.isSuccess(statusCode: code) {
                    if let array = item as? NSDictionary {
                        self.view?.networkResult(resultData: array, code: self._foodplan)
                    }
                } else {
                    self.view?.networkFailed(errorMsg: self.errorMsg(code: code), code: self._foodplan)
                }
            case .failure(let error):
                log.error(error)
                if let error = error as? String {
                    self.view?.networkFailed(errorMsg: error, code: self._foodplan)
                } else {
                    self.view?.networkFailed(errorMsg: String.noServer, code: self._foodplan)
                }
            }
        }
    }
    
//    //옵셔널 String을 해제하는데 값이 nil이면 ""을 반환
//    func gsno(_ data: String?) -> String {
//        guard let str = data else {
//            return ""
//        }
//        return str
//    }
//    
//    //옵셔널 Int를 해제하는데 값이 nil이면 0을 반환
//    func gino(_ data: Int?) -> Int {
//        guard let num = data else {
//            return 0
//        }
//        return num
//    }
    
//    func isSuccess(statuscode: Int) -> Bool{
//        // 200, 304 성공
//        // 401 404 500 오류
//        switch statuscode {
//        case 200:
//            fallthrough
//        case 304:
//            return true
//        default:
//            return false
//        }
//    }
}
