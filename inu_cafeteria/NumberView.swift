//
//  NumberView.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 17..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit

class NumberView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    override var isHidden: Bool {
        didSet {
            if isHidden {
                if let textField = self.textField {
                    textField.text = ""
                    textField.resignFirstResponder()
                }
            } else {
                if let textField = self.textField {
                    DispatchQueue.main.async {
                        textField.becomeFirstResponder()
                    }
                }
            }
        }
    }
    
    var number:Int? {
        get {
            if let text = textField.text, text.count != 0, let num = Int(text) {
                return num
            }
            return nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Bundle.main.loadNibNamed("NumberView", owner: self, options: nil)
        addSubview(contentView)
        
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.setHint(hint: textField.placeholder!, font: UIFont.KoPubDotum(type: .L, size: 12), textcolor: UIColor(rgb: 160))
    }
    
    func commonInit(index: Int, parent: UITextFieldDelegate){
        self.textField.delegate = parent
        switch index {
        case 0:
            minusBtn.isHidden = true
        case 1:
            print()
        case 2:
            plusBtn.isHidden = true
        default:
            print()
        }
    }
    
    func clear(){
        self.textField.text = ""
        self.textField.resignFirstResponder()
    }
}
