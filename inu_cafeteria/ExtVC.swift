//
//  ExtVC.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 7. 11..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit
import Toast_Swift
import KYDrawerController
import Alamofire

let MAIN = UIStoryboard(name: "Main", bundle: nil)
let SPLASH = UIStoryboard(name: "Splash", bundle: nil)

extension UIViewController {

//    func infoC(_ sender: Any){
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        guard let infovc = sb.instantiateViewController(withIdentifier: "infovc") as? InfoVC else {return}
//        self.present(infovc, animated: true, completion: nil)
//    }
    
    func setTitleView(){
        let logoIV = UIImageView(image: UIImage(named: "nav_logo"))
        logoIV.contentMode = .scaleAspectFit
        logoIV.frame = CGRect(x: 0, y: 0, width: 130, height: 21.5)
        self.navigationItem.titleView = logoIV
    }
    
    func setStatusBar(_ color:UIColor){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: UIApplication.shared.statusBarFrame.size.height))
        view.backgroundColor = color
        self.navigationController?.view.addSubview(view)
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
    
    func showHome(_ code: [CodeObject], _ no_student: Bool){
//        if no_student {
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            guard let homevc = sb.instantiateViewController(withIdentifier: "homevcnav") as? DefaultNC else { return }
//            
//            let hvc = homevc.viewControllers[0] as! HomeVC
//            hvc.codes = code
//            hvc.no_student = true
//            
//            self.present(homevc, animated: true, completion: nil)
//        } else {
//           
//        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let homevc = sb.instantiateViewController(withIdentifier: "homevcnav") as? DefaultNC else { return }
        
        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: CGFloat.drawer_width)
        drawerController.mainViewController = homevc
        
        let hvc = homevc.viewControllers[0] as! HomeVC
        hvc.codes = code
        
        guard let drawer = sb.instantiateViewController(withIdentifier: "drawervc") as? DrawerVC else { return }
        drawerController.drawerViewController = drawer
        
        if no_student {
            userPreferences.setValue(true, forKey: "no_student")
            drawer.nonClient()
            hvc.nonClient = true
        }
        
        self.present(drawerController, animated: true, completion: nil)
    }
    
    func setupDrawerBtn(){
        let hamburger = UIImage(named: "ic_drawer")
        let hamB = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 15))
        hamB.setImage(hamburger, for: .normal)
        hamB.contentMode = .scaleAspectFit
        hamB.addTarget(self, action: #selector(showDrawer(_:)), for: .touchUpInside)
        let lB = UIBarButtonItem(customView: hamB)
        self.navigationItem.leftBarButtonItem = lB
    }
    
    @objc func showDrawer(_ sender: UIButton){
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}
extension UIViewController {
    
    func logout_ncb(){
        DispatchQueue.main.async {
            if (self.presentingViewController?.isKind(of: FirstStartVC.self))! {
                self.dismiss(animated: true, completion: nil)
            } else {
                guard let loginvc = MAIN.instantiateViewController(withIdentifier: "firststartvc") as? FirstStartVC else {return}
                loginvc.showLogin = true
                UIApplication.shared.keyWindow?.rootViewController = loginvc
            }
        }
    }
    
//    func networkResult(resultData: Any, code: String) {
//        print(code)
//
//    }
//
//    func networkFailed(code: Any) {
//
//    }
//
//    func networkFailed() {
//        Indicator.stopAnimating()
//        Toast(text: "서버에 접속할 수 없습니다.").show()
//    }
}
