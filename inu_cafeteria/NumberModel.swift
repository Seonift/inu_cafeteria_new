//
//  NumberModel.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Alamofire

class NumberModel: NetworkModel {
    
    func postNum(num: String, token: String){
        
        let params:[String:Any] = [
            "code" : 123,
            "token" : token,
            "num" : num,
            "device" : "ios"
        ]
        
        Alamofire.request("\(baseURL)getNumber", method: .post, parameters: params).responseJSON { res in
            switch res.result {
            case .success:
                print(params)
                self.view.networkResult(resultData: true, code: "postnum")
            case .failure(let error):
                print(error)
                self.view.networkFailed(code: gino(res.response?.statusCode))
            }
        }
    }
}
