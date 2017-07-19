//
//  NetworkCallback.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 6. 2..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

protocol NetworkCallback {
    
    func networkResult(resultData:Any, code:String)
    func networkFailed(code:Any)
    
}

protocol ViewCallback {
    func passData(resultData:Any, code:String)
}
