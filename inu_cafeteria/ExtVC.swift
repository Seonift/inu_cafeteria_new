//
//  ExtVC.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 7. 11..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit
import Toaster
import KYDrawerController

extension UIViewController {
    
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
    
    func showHome(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let homevc = sb.instantiateViewController(withIdentifier: "homevcnav") as? DefaultNC else { return }
        
        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: CGFloats.drawer_width())
        drawerController.mainViewController = homevc
        
        guard let drawer = sb.instantiateViewController(withIdentifier: "drawervc") as? DrawerVC else { return }
        drawerController.drawerViewController = drawer
        drawer.delegate = homevc.viewControllers[0] as! HomeVC
        
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
    
    func showDrawer(_ sender: UIButton){
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}

extension UIViewController: ViewCallback {
    func passData(resultData: Any, code: String) {
        print(code)
        
        if code == "barcode" {
            
            if let drawerController = navigationController?.parent as? KYDrawerController {
                drawerController.setDrawerState(.closed, animated: true)
            }
            
            DispatchQueue.main.async {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let barcodevc = sb.instantiateViewController(withIdentifier: "barcodevc") as? BarcodeVC else {return}
                self.navigationController?.pushViewController(barcodevc, animated: true)
            }
        }
        
        if code == "logout" {
            if let drawerController = navigationController?.parent as? KYDrawerController {
                drawerController.setDrawerState(.closed, animated: true)
            }
            
            let model = LoginModel(self)
            model.logout()
            
        }
    }
}

extension UIViewController: NetworkCallback {
    
    func logout_ncb(){
        DispatchQueue.main.async {
            if (self.presentingViewController?.isKind(of: FirstStartVC.self))! {
                self.dismiss(animated: true, completion: nil)
            } else {
                //                    print("nonono!!")
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let loginvc = sb.instantiateViewController(withIdentifier: "firststartvc") as? FirstStartVC else {return}
                
                loginvc.showLogin = true
                
                self.present(loginvc, animated: false, completion: nil)
            }
        }
    }
    
    func networkResult(resultData: Any, code: String) {
        print(code)
        
    }

    func networkFailed(code: Any) {
        
    }
    
    func networkFailed() {
        Indicator.stopAnimating()
        Toast(text: "서버에 접속할 수 없습니다.").show()
    }
}
