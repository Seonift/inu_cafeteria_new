//
//  InfoVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 16..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {
    @IBOutlet weak var verLabel: UILabel!
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.verLabel.text = "버전 : \(version)"
        }
    }
}
