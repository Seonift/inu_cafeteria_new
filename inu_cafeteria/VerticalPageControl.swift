//
//  VerticalPageControl.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 18..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit

class VerticalPageControl: UIView {
    
    lazy var i1:PageIndicator = {
        let indicator = PageIndicator(frame: CGRect(x: 0, y: 0, width: 6.5, height: 6.5))
        return indicator
    }()
    lazy var i2:PageIndicator = {
        let indicator = PageIndicator(frame: CGRect(x: 0, y: 0, width: 6.5, height: 6.5))
        return indicator
    }()
    lazy var i3:PageIndicator = {
        let indicator = PageIndicator(frame: CGRect(x: 0, y: 0, width: 6.5, height: 6.5))
        return indicator
    }()
    lazy var i4:PageIndicator = {
        let indicator = PageIndicator(frame: CGRect(x: 0, y: 0, width: 6.5, height: 6.5))
        return indicator
    }()
    lazy var i5:PageIndicator = {
        let indicator = PageIndicator(frame: CGRect(x: 0, y: 0, width: 6.5, height: 6.5))
        return indicator
    }()
    
    lazy var indicators:[PageIndicator] = {
        return [i1, i2, i3, i4, i5]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // 12.5 99 9
    // 6.5 51.5 4.5
    
    func setupUI(){
        addSubview(i1)
        addSubview(i2)
        addSubview(i3)
        addSubview(i4)
        addSubview(i5)
        
        i1.frame.origin = CGPoint(x: 0, y: 0)
        i2.frame.origin = CGPoint(x: 0, y: i1.frame.height + 4.5)
        i3.frame.origin = CGPoint(x: 0, y: i2.frame.origin.y + i2.frame.height + 4.5)
        i4.frame.origin = CGPoint(x: 0, y: i3.frame.origin.y + i3.frame.height + 4.5)
        i5.frame.origin = CGPoint(x: 0, y: i4.frame.origin.y + i4.frame.height + 4.5)
    }
    
    func selectIndicator(index: Int){
        for i in indicators {
            i.isSelected = false
        }
        if index < 5 {
            indicators[index].isSelected = true
        }
    }
}

class PageIndicator: UIView {
    
    // 6.5 51.5
    var isSelected:Bool = false {
        didSet {
            if isSelected {
                self.backgroundColor = UIColor.cftBrightSkyBlue
            } else {
                self.backgroundColor = UIColor(rgb: 201)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(rgb: 201)
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
