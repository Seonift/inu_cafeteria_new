//
//  CustomAlert.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 18..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit

class CustomAlert: NSObject {
    static func alert(positive: String = "확인", negative: String = "취소", title: String? = nil, message: String? = nil, positiveAction: ((UIAlertAction) -> Void)? = nil, negativeAction: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: negative, style: .cancel, handler: negativeAction)
        let ok = UIAlertAction(title: positive, style: .default, handler: positiveAction)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.view.tintColor = UIColor.cftBrightSkyBlue
        return alertController
    }
    
    static func okAlert(positive: String = "확인", title: String? = nil, message: String? = nil, positiveAction: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        // 1버튼
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: positive, style: .default, handler: positiveAction)
        alertController.addAction(ok)
        alertController.view.tintColor = UIColor.cftBrightSkyBlue
        return alertController
    }
    
    static func noticeAlert(title: String? = nil, message: String? = nil, first: String = "확인", second: String = "다시보지않기", firstAction: ((UIAlertAction) -> Void)? = nil, secondAction: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: first, style: .default, handler: firstAction)
        let ok2 = UIAlertAction(title: second, style: .default, handler: secondAction)
        alertController.addAction(ok)
        alertController.addAction(ok2)
        alertController.view.tintColor = UIColor.cftBrightSkyBlue
        
        if let title = alertController.title {
            let attributedTitle = NSMutableAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.KoPubDotum(type: .B, size: 18.0)])
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
        }

        if let msg = alertController.message {
            let attributedTitle = NSMutableAttributedString(string: msg, attributes: [NSAttributedStringKey.font: UIFont.KoPubDotum(type: .M, size: 12.0)])
            alertController.setValue(attributedTitle, forKey: "attributedMessage")
        }
        
        return alertController
    }
}
