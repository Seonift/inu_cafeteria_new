//
//  NewInfoVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 3. 1..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit
import Device

class NewInfoVC: UIViewController {
    @IBOutlet weak var verLabel: UILabel!
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = contentView.frame.size
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func setupUI(){
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.verLabel.text = "v \(version)"
        }
        
        log.debug(scrollView.bounds)
        log.debug(contentView.bounds)
        
        

//        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: Device.getHeight(height: 1012))
    }
}
