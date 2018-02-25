//
//  Constraint.swift
//  SmartCampus
//
//  Created by SeonIl Kim on 2017. 4. 12..
//  Copyright © 2017년 INUAPPCENTER. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: viewDictionary))
    }
    
    func acwf(width: CGFloat?, height:CGFloat?, view: UIView){
        
        if width == -1 {
            self.addConstraintsWithFormat(format: "H:|[v0]|", views: view)
        } else if width != nil {
            self.addConstraintsWithFormat(format: "H:[v0(\(width!))]", views: view)
        }
        
        if height == -1 {
            self.addConstraintsWithFormat(format: "V:|[v0]|", views: view)
        } else if height != nil {
            self.addConstraintsWithFormat(format: "V:[v0(\(height!))]", views: view)
        }
    }
    
    
    func ac_center(item:UIView, toItem:UIView){
        addConstraint(NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: toItem, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: toItem, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func ac_center(item:UIView, toItem:UIView, origin:String){
        if origin == "x" {
            addConstraint(NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: toItem, attribute: .centerX, multiplier: 1, constant: 0))
        } else if origin == "y" {
            addConstraint(NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: toItem, attribute: .centerY, multiplier: 1, constant: 0))
        }
    }
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

