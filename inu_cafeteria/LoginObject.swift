//
//  LoginObject.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 28..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import ObjectMapper

class LoginObject: Mappable {
    
    var barcode: String?
    var dtoken: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.barcode <- map["barcode"]
        self.dtoken <- map["dtoken"]
    }
}
