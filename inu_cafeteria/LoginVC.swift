//
//  LoginVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 18..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import KYDrawerController

class LoginVC: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var idTF: LoginTF!
    @IBOutlet weak var pwTF: LoginTF!
    
    @IBOutlet weak var autoV: UIView!
    @IBOutlet weak var autoL: UILabel!
    @IBOutlet weak var autoCbox: UIButton!
    
    
    
    override func viewDidLoad() {
        
        autoL.font = UIFont(name: "KoPubDotumPM", size: 12)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let homevc = sb.instantiateViewController(withIdentifier: "homevcnav") as? DefaultNC else { return }
        
        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 240)
        drawerController.mainViewController = homevc
        
        guard let drawer = sb.instantiateViewController(withIdentifier: "drawervc") as? DrawerVC else { return }
        drawerController.drawerViewController = drawer
        drawer.delegate = homevc.viewControllers[0] as! HomeVC
        
        self.present(drawerController, animated: true, completion: nil)
//        self.present(homevc, animated: true, completion: nil)
        
//        let result = resultData as? MyPage
//        let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let main = main_storyboard.instantiateViewController(withIdentifier: "homevc") as? NavController else {return}
//        
//        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 325.0)
//        
//        drawerController.mainViewController = main
//        guard let vc = main_storyboard.instantiateViewController(withIdentifier: "drawervc") as? DrawerVC else {return}
//        
//        drawerController.drawerViewController = vc
//        
//        let mainvc = main.viewControllers[0] as! HomeVC
//        mainvc.recents = mainmodel?.events
//        mainvc.mygroups = mainmodel?.groups
//        
//        vc.delegate = mainvc
//        vc.mypage = result
//        
//        present(drawerController, animated: true)
        
    }
}

class LoginTF:UITextField {
    
    override func awakeFromNib() {
        setBorder()
        
        self.font = UIFont(name: "KoPubDotumPM", size: 16)
        self.textColor = UIColor.white
        let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "KoPubDotumPM", size: 16)]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributes)
    }
    
    func setBorder(){
        let border = CALayer()
        let width:CGFloat = 2.0
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
