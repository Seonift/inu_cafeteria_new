//
//  HomeVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 18..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Toaster
import KYDrawerController

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class HomeVC: UIViewController {
    
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var leftB: UIButton!
    @IBOutlet weak var rightB: UIButton!
    
    @IBOutlet weak var topL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var numberTF: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    override func viewDidLoad() {
        
        let logoIV = UIImageView(image: UIImage(named: "nav_logo"))
        logoIV.contentMode = .scaleAspectFit
        logoIV.frame = CGRect(x: 0, y: 0, width: 130, height: 21.5)
        self.navigationItem.titleView = logoIV
        
        carouselView.type = .rotary
        carouselView.bounds = carouselView.frame.insetBy(dx: 15, dy: 10)
        carouselView.isPagingEnabled = true
        
        leftB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        rightB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        confirmBtn.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        topL.font = UIFont(name: "KoPubDotumPM", size: 12)
        titleL.font = UIFont(name: "KoPubDotumPB", size: 20)
        
        let hamburger = UIImage(named: "ic_drawer")
        let hamB = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 15))
        hamB.setImage(hamburger, for: .normal)
        hamB.contentMode = .scaleAspectFit
        hamB.addTarget(self, action: #selector(showDrawer(_:)), for: .touchUpInside)
        let lB = UIBarButtonItem(customView: hamB)
        self.navigationItem.leftBarButtonItem = lB
        
        setupTF()
    }
    
    func showDrawer(_ sender: UIButton){
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    func setupTF(){
        numberTF.font = UIFont(name: "KoPubDotumPB", size: 24)
        numberTF.textColor = UIColor(r: 98, g: 150, b: 174)
        numberTF.backgroundColor = UIColor(rgb: 236)
        numberTF.layer.cornerRadius = 10
        numberTF.clipsToBounds = true
        numberTF.textAlignment = .center
        numberTF.delegate = self
        numberTF.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        numberTF.keyboardType = .numberPad
        numberTF.addDoneButtonOnKeyboard()
        numberTF.setHint(hint: "음식번호를 입력해주세요.", font: UIFont(name: "KoPubDotumPM", size: 12)!, textcolor: UIColor.untGreyishBrown)
    }
    
    func btnClicked(_ sender: UIButton){
        var index = carouselView.currentItemIndex
        if sender == self.leftB {
            index += 1
        } else if sender == self.rightB {
            index -= 1
        }
        carouselView.scrollToItem(at: index, animated: true)
    }
    
    func confirmClicked(_ sender: UIButton){
        let number = numberTF.text
        if self.numberTF.text == nil || self.numberTF.text?.characters.count == 0 {
            Toast(text: "번호를 입력해주세요.").show()
        } else {
            let token = gsno(FIRInstanceID.instanceID().token())
            print(token)
            let model = NumberModel(self)
            model.postNum(num: number!, token: token)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        numberTF.text = ""
        numberTF.endEditing(true)
    }
}

extension HomeVC: NetworkCallback {
    func networkResult(resultData: Any, code: String) {
        if code == "postnum" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: "mynumbervc") as? MyNumberVC else { return }
            
            vc.bTitle = gsno(titleL.text)
            vc.number = gsno(numberTF.text)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}

extension HomeVC: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 10
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "home_default")
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
//            print(value)
            return value * 1.6
        }
        
        //보일 아이템 갯수
        if (option == .count) {
            return 3
        }
        
        //뒤 아이템들 투명화
        if (option == .fadeMin){
            return 0
        }
        if option == .fadeMax {
            return 0
        }
        if option == .fadeRange {
            return 2
        }
        
        return value
    }
}

extension HomeVC: ViewCallback {
    func passData(resultData: Any, code: String) {
        print(code)
        
        if code == "barcode" {
            
            if let drawerController = navigationController?.parent as? KYDrawerController {
                drawerController.setDrawerState(.closed, animated: true)
            }
            
            DispatchQueue.main.async {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let barcodevc = sb.instantiateViewController(withIdentifier: "barcodevc") as? BarcodeVC else {return}
                self.navigationController?.pushViewController(barcodevc, animated: true)
            }
            
        }
    }
}
