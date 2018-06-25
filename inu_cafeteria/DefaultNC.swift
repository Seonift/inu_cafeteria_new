//
//  DefaultNC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 18..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit

class DefaultNC: UINavigationController {
    // 기본 네비게이션 바
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(named: "nav_bg")?.resizableImage(withCapInsets: .zero, resizingMode: .stretch), for: .default)
        self.navigationBar.tintColor = .white
        self.navigationBar.topItem?.title = ""
    }
}
