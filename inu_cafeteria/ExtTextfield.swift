//
//  ExtTextfield.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 7. 11..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit

extension UITextField {
    func setHint(hint:String, font:UIFont, textcolor:UIColor) {
        let attributes = [
            NSForegroundColorAttributeName: textcolor,
            NSFontAttributeName : font
        ]
        attributedPlaceholder = NSAttributedString(string: hint, attributes:attributes)
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50)) // Create keyboard toolbar
        doneToolbar.barStyle = .default // Set style
        
        let blankFlexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // Add blank spacing item to left of done button
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(self.doneButtonAction)) // Add done button
        
        doneToolbar.items = [blankFlexSpace, doneButton] // Create array of the items and add to toolbar
        doneToolbar.sizeToFit() // Fit to screen size
        
        self.inputAccessoryView = doneToolbar // Add toolbar to keyboard
        
    }
    
    // Function called when done button pressed
    // Put manually put under action
    func doneButtonAction() {
        self.resignFirstResponder() // Desselect
    }
    
    // MARK - End of adding done button to number pad
    
}
