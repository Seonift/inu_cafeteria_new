//
//  LoginObject.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 28..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import ObjectMapper

class InfoObject: Mappable {
    var login:LoginObject?
    var code:[CodeObject]?
    var stu_info:StuInfoObject?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.login <- map["login"]
        self.code <- map["code"]
        self.stu_info <- map["stu_info"]
    }
}

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

class CodeObject: Mappable {
    var name:String?
    var code:String?
    var img:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.name <- map["name"]
        self.code <- map["code"]
        self.img <- map["img"]
    }
}

class StuInfoObject: Mappable {
//    "stu_info": {
//    "stu_num": "201101720",
//    "name": "김선일",
//    "dep": "정보통신공학과",
//    "stat": "재학"
//    }
    
    var stu_num:String?
    var name:String?
    var dep:String?
    var stat:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.stu_num <- map["stu_num"]
        self.name <- map["name"]
        self.dep <- map["dep"]
        self.stat <- map["stat"]
    }
}
