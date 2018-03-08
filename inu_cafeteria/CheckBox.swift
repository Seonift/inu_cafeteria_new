//
//  CheckBox.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 3. 4..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    override func awakeFromNib() {
        let selected = UIImage(named: "login_cbox")
        let unselected = UIImage(named: "login_cbox_no")
        self.setImage(selected, for: .selected)
        self.setImage(unselected, for: .normal)
    }
}
