//
//  ExtVC.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 7. 11..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit
import Toaster


extension UIViewController {
    
    func setStatusBar(_ color:UIColor){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: UIApplication.shared.statusBarFrame.size.height))
        view.backgroundColor = color
        self.navigationController?.view.addSubview(view)
    }
    
//    func networkFailed() {
//        //        let alert = UIAlertController(title: "네트워크 오류", message: "인터넷 연결을 확인해주세요.", preferredStyle: .alert)
//        //        let okAction = UIAlertAction(title: "확인", style: .default)
//        //        alert.addAction(okAction)
//        //        present(alert, animated: true)
//        
//        Toast(text: "인터넷 연결을 확인해주세요.").show()
//        
//    }
//    
    func networkFailed(code: Any) {
        Toast(text: "서버에 접속할 수 없습니다.").show()
    }
    
    func setTabBarVisible(visible:Bool, animated:Bool, duration:Double?) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
//        let du:TimeInterval = (animated ? 0.3 : 0.0)
        
        var du:TimeInterval?
        
        if duration == nil {
            du = (animated ? 0.3 : 0.0)
            
        } else {
            du = (animated ? duration : 0.0)
        }
        
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: du!) {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return (self.tabBarController?.tabBar.frame.origin.y)! < self.view.frame.maxY
    }
}
