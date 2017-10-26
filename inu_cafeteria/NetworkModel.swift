//
//  NetworkModel.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 6. 2..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit

//let baseURL = 
let loginURL = String.loginURL()
let numberURL = String.numberURL()
let socketURL = String.socketURL()


let header:[String:String] = [
    "Content-Type" : "application/x-www-form-urlencoded"
]

let jsonheader:[String:String] = [
    "Content-Type" : "application/json"
]

class NetworkModel {
    
    //뷰컨트롤러로 데이터를 전달해줄 위임자를 나타내주는 변수
    
    //callbackDelegate
    var view : NetworkCallback
    
    
    init(_ vc : NetworkCallback){
        self.view = vc
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
