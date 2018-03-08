//
//  AdDetailCell.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 24..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit

class AdDetailCell: UITableViewCell {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        firstLabel.text = ""
        secondLabel.text = ""
    }
    
    func commonInit(item: AdObject.ContentObj) {
        firstLabel.text = item.title
        secondLabel.text = item.msg
    }
    
}
