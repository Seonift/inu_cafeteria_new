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
    
    let _isNumberWait = "isnumberwait"
    let _resetNumber = "resetnumber"
    let _registerNumber = "registernumber"
    
    func isNumberWait() {
//        Indicator.startAnimating(activityData)
        
        guard let token = InstanceID.instanceID().token() else {
            self.view?.networkFailed(errorMsg: String.noToken, code: _isNumberWait)
            return
        }
        let params = [ "fcmtoken": token ]
        post(function: _isNumberWait, type: WaitNumber.self, params: params, headers: nil)   
    }
    
    func resetNumber() {
//        Indicator.startAnimating(activityData)
        
        guard let token = InstanceID.instanceID().token() else {
            self.view?.networkFailed(errorMsg: String.noToken, code: _resetNumber)
            return
        }
        let params = [ "fcmtoken": token ]
        post(function: _resetNumber, params: params)
    }
    
    func registerNumber(code: Int, nums: [Int]) {
        Indicator.startAnimating(activityData)
        
        guard let token = InstanceID.instanceID().token() else {
            self.view?.networkFailed(errorMsg: String.noToken, code: _registerNumber)
            return
        }
        let params = [
            "code": String(code),
            "token": token,
            "num1": nums[safe: 0] != nil ? String(nums[0]) : "",
            "num2": nums[safe: 1] != nil ? String(nums[1]) : "",
            "num3": nums[safe: 2] != nil ? String(nums[2]) : "",
            "device": "ios"
        ]
        post(function: _registerNumber, params: params)
    }
}
