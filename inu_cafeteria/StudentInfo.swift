//
//  StudentInfo.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 3..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import ObjectMapper

class StudentInfo:Mappable {
    
    var sno:String?
    var name:String?
    var department:String?
    var major:String?
    var main_div:String?
    var stu_stat:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.sno <- map["STUDENT_NO"]
        self.name <- map["NAME"]
        self.department <- map["DEPARTMENT"]
        self.major <- map["MAJOR"]
        self.main_div <- map["MAIN_DIV"]
        self.stu_stat <- map["STU_STAT"]
    }
}

