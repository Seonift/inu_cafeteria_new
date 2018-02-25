//
//  AdHeaderCell.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 24..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit
import Device

class AdHeaderCell: UITableViewCell {
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        topConst.constant = Device.getHeight(height: topConst.constant)
        
        bottomConst.constant = Device.getHeight(height: bottomConst.constant)
        
        self.selectionStyle = .none
        
        self.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
