//
//  FirstStartVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 17..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit

class FirstStartVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    
    @IBOutlet weak var moveBtn: UIView!
    
    override func viewDidLoad() {
        l1.font = UIFont(name: "KoPubDotumPB", size: 28)
        l2.font = UIFont(name: "KoPubDotumPB", size: 28)
        l3.font = UIFont(name: "KoPubDotumPB", size: 20)
        
        moveBtn.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveLogin(_:)))
        tap.delegate = self
        moveBtn.addGestureRecognizer(tap)
    }
    
    func moveLogin(_ sender: UITapGestureRecognizer?) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let loginvc = sb.instantiateViewController(withIdentifier: "loginvc") as? LoginVC else {return}
        self.present(loginvc, animated: true, completion: nil)
    
    }
}
