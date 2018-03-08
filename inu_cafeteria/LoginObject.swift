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
    var token: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.barcode <- map["barcode"]
        self.token <- map["token"]
    }
}

class CafeCode: Mappable {
    
    var no: String = ""
    var name: String = ""
    var menu: Int = -1
    
    var alarm: Bool = false
    var img: String = ""
    var bgimg: String = ""
    var order: String = ""
    
    var _no: Int {
        if let int = Int(no) { return int }
        return -1
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.no <- map["no"]
        self.name <- map["name"]
        self.menu <- map["menu"]
        self.alarm <- map["alarm"]
        self.img <- map["img"]
        self.bgimg <- map["bgimg"]
        self.order <- map["order"]
    }
}

class VerObject: Mappable {
    var android: VerInfo?
    var ios: VerInfo?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.android <- map["android"]
        self.ios <- map["ios"]
    }
    
    class VerInfo: Mappable {
        var latest: String = ""
        var log: [VersionHistory] = []
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            self.latest <- map["latest"]
            self.log <- map["log"]
        }
        
    }
    
    class VersionHistory: Mappable {
        var version: String = ""
        var info: [String] = []
        var date: String = ""
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            self.version <- map["version"]
            self.info <- map["info"]
            self.date <- map["date"]
        }
    }
}

class NoticeObject: Mappable {
    var all: DetailNotice?
    var ios: DetailNotice?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.all <- map["all"]
        self.ios <- map["ios"]
    }
    
    class DetailNotice: Mappable {
        var title: String = ""
        var message: String?
        var id: String = ""
        
        func mapping(map: Map) {
            self.id <- map["id"]
            self.title <- map["title"]
            self.message <- map["message"]
        }
        
        func isVaild() -> Int? {
            // 메시지 값이 없으면 공지 없는거
            // 공지가 있으면 id값 반환
            if let msg = self.message {
                if msg == "" { return nil }
                return Int(self.id)
            }
            return nil
        }
        
        required init?(map: Map) {
            
        }
    }
}

class AdObject: Mappable {
    var no: String = ""
    var title: String = ""
    var img: String = ""
    var previewimg: String = ""
    var url: String = ""
    var contents: [ContentObj]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.no <- map["no"]
        self.title <- map["title"]
        self.img <- map["img"]
        self.previewimg <- map["previewimg"]
        self.url <- map["url"]
        self.contents <- map["contents"]
    }
    
    class ContentObj: Mappable {
        var title: String = ""
        var msg: String = ""
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            self.title <- map["title"]
            self.msg <- map["msg"]
        }
    }
}

class FoodMenu: Mappable {
    var title: String = ""
    var menu: String = ""
    var order: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.title <- map["TITLE"]
        self.menu <- map["MENU"]
        self.order <- map["order"]
    }
}

//class FoodObject: :Mappable {
//    var menu1:[Food] = [] // 학생식당
//    var foodMenuType2Result:[Food] = [] // 카페테리아
//    var menu2:[Food] = [] // 사범대식당
//    var foodMenuType4Result:[Food] = [] // 기숙사
//    var foodMenuType5Result:[Food] = [] // 교직원식당
//
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//        self.menu1 <- map["foodMenuType1Result"]
//        self.foodMenuType2Result <- map["foodMenuType2Result"]
//        self.menu2 <- map["foodMenuType3Result"]
//        self.foodMenuType4Result <- map["foodMenuType4Result"]
//        self.foodMenuType5Result <- map["foodMenuType5Result"]
//    }
//
//
//    class Food: :Mappable {
//        var type1:String = ""
//        var type2:String = ""
//        var foodmenu_type:String = ""
//        var std_date:String = ""
//        var menu:String = ""
//
//        required init?(map: Map) {
//
//        }
//
//        func mapping(map: Map) {
//            self.type1 <- map["TYPE1"]
//            self.type2 <- map["TYPE2"]
//            self.foodmenu_type <- map["FOODMENU_TYPE"]
//            self.std_date <- map["STD_DATE"]
//            self.menu <- map["MENU"]
//        }
//    }
//}

//class InfoObject: Mappable {
//    var login:LoginObject?
//    var code:[CodeObject]?
//    var stu_info:StuInfoObject?
//
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//        self.login <- map["login"]
//        self.code <- map["code"]
//        self.stu_info <- map["stu_info"]
//    }
//}

//class StuInfoObject: Mappable {
////    "stu_info": {
////    "stu_num": "201101720",
////    "name": "김선일",
////    "dep": "정보통신공학과",
////    "stat": "재학"
////    }
//
//    var stu_num:String?
//    var name:String?
//    var dep:String?
//    var stat:String?
//
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//        self.stu_num <- map["stu_num"]
//        self.name <- map["name"]
//        self.dep <- map["dep"]
//        self.stat <- map["stat"]
//    }
//}
