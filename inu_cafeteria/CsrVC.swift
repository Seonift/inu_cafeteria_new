//
//  CsrVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Toast_Swift

class CsrVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellId = "CsrCell"
    
    var items:[Int] = [1,2,3,4,5]
    
    @IBOutlet weak var tableView_topConst: NSLayoutConstraint!
    var tableView_flipped:Bool = true
    @IBAction func flipClicked(_ sender: Any) {
        guard let sender = sender as? UIButton else { return }
        tableView_flipped = !tableView_flipped
        if tableView_flipped {
            // 접기
            sender.setTitle("더보기", for: .normal)
            tableView_topConst = tableView_topConst.setMultiplier(multiplier: 222/667)
        } else {
            // 펴기
            sender.setTitle("접기", for: .normal)
            tableView_topConst = tableView_topConst.setMultiplier(multiplier: 60/667)
//            60:667
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        
        textField.font = UIFont(name: "KoPubDotumPL", size: 15)
        textField.setHint(hint: "문의하실 내용을 적어주세요.", font: UIFont.KoPubDotum(type: .L, size: 12), textcolor: UIColor(rgb: 160))
        textField.layer.cornerRadius = 19.3
        textField.textAlignment = .center
        textField.delegate = self
        
        sendBtn.addTarget(self, action: #selector(sendClicked(_:)), for: .touchUpInside)
        sendBtn.layer.borderColor = UIColor(rgb: 170).cgColor
        sendBtn.layer.borderWidth = 0.8
        sendBtn.clipsToBounds = true
        sendBtn.layer.cornerRadius = 22.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorColor = UIColor(rgb: 170)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setTitleView()
    }
    
    @objc func sendClicked(_ sender: UIButton) {
        if textField.text == nil || textField.text == "" {
            self.view.makeToast(String.noContents)
        } else {
            self.textField.endEditing(true)
            let model = CsrModel(self)
            model.errormsg(msg: gsno(textField.text))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.sendClicked(self.sendBtn)
        self.sendBtn.sendActions(for: .touchUpInside)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(r: 144, g: 186, b: 203).cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
    }
    
    //resignFirsReponder
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?) {
        print("tap")
        self.textField.resignFirstResponder()
    }
    
    //TapGesu
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.textField))! || (touch.view?.isDescendant(of: self.sendBtn))!{
            return false
        }
        return true
    }
}

extension CsrVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CsrCell
       
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        if indexPath.row == 0 {
            cell.commonInit(day: df.date(from: "2018 02 17")!)
        } else if indexPath.row == 1 {
            cell.commonInit(day: df.date(from: "2017 11 01")!)
        } else {
            cell.commonInit(day: df.date(from: "2016 01 01")!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: "header")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "답변"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117.0
    }
}

extension CsrVC:NetworkCallback {
    func networkResult(resultData: Any, code: String) {
        if code == "errormsg" {
            self.view.makeToast(String.csrSuc)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func networkFailed(code: Any) {
        
    }
    
    func networkFailed() {
        self.view.makeToast(String.noServer)
    }
}

class CsrCell: UITableViewCell {
    @IBOutlet weak var verLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func commonInit(ver: String = "", day: Date, content: String = ""){
        
        verLabel.text = "v\(ver)"
        contentLabel.text = content
        
        let today = Date()
        let dayValue = today.days(from: day)
        if dayValue <= 30 {
            dayLabel.text = "\(dayValue)일전"
        } else {
            let monthValue = today.months(from: day)
            if monthValue <= 12 {
                dayLabel.text = "\(monthValue)개월전"
            } else {
                let yearValue = today.years(from: day)
                dayLabel.text = "\(yearValue)년전"
            }
        }
    }
}
