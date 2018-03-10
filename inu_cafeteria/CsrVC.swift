//
//  CsrVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Toast_Swift
import Device

class CsrVC: UIViewController, UIGestureRecognizerDelegate {
    // 문의하기
    
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var table_heightConst: NSLayoutConstraint!
    
    private let cellId = "CsrCell"
    
    private var log: [VerObject.VersionHistory]?
    private var parentVC: UIViewController?
    private var lastKnowContentOfsset: CGFloat = 0
    lazy var model: CsrModel = {
        return CsrModel(self)
    }()
    private var headerView: CsrHeaderCell?
    private var tableView_flipped: Bool = true
    
    @IBAction func flipClicked(_ sender: Any) {
        tableView_flipped = !tableView_flipped
        if tableView_flipped {
            // 접기
            setDefaultTableViewHeight()
        } else {
            // 펴기
            table_heightConst.constant = 49 + Device.getHeight(height: 294)
//            60:667
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            guard let header = self.headerView else { return }
            if self.tableView_flipped {
                header.flipBtn.setTitle("더보기", for: .normal)
            } else {
                header.flipBtn.setTitle("접기", for: .normal)
            }
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
        tableView.rowHeight = UITableViewAutomaticDimension
        
        addToolBar(textField: textField)
        
        setDefaultTableViewHeight()
        self.view.layoutIfNeeded()
    }
    
    func setDefaultTableViewHeight() {
        // 테이블뷰 기본 크기
        let rect = tableView.rectForRow(at: IndexPath(row: 0, section: 0))
        table_heightConst.constant = 49 + rect.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTitleView()
        
        if log == nil {
            tableView.isHidden = true
        }
    }
    
    func setData(log: [VerObject.VersionHistory]? = nil, parent: UIViewController? = nil) {
        if let log = log { self.log = log }
        self.parentVC = parent
    }
    
    @objc func sendClicked(_ sender: UIButton) {
        if let text = textField.text, text != "" {
            self.textField.resignFirstResponder()
            model.errormsg(msg: text)
        } else {
            self.view.makeToast(String.noContents)
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
        if (touch.view?.isDescendant(of: self.textField))! || (touch.view?.isDescendant(of: self.sendBtn))! {
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
        if let count = log?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateCell(withIdentifier: cellId, for: indexPath, cellClass: CsrCell.self)
        if let log = log {
            cell.commonInit(item: log[indexPath.row])
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.headerView = tableView.generateCell(withIdentifier: "header", cellClass: CsrHeaderCell.self)
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "답변"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if self.lastKnowContentOfsset < scrollView.contentOffset.y {
                // moved to top
                if tableView_flipped { flipClicked(tableView) }
            } else if self.lastKnowContentOfsset > scrollView.contentOffset.y {
                // moved to bottom
            } else {
                // didn't move
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            self.lastKnowContentOfsset = scrollView.contentOffset.y
        }
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 117.0
//    }
}

extension CsrVC: NetworkCallback {
    
    func networkResult(resultData: Any, code: String) {
        if code == model._errormsg {
            if let parent = parentVC { parent.view.makeToast(String.csrSuc) }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func networkFailed(errorMsg: String, code: String) {
        if code == model._errormsg {
            self.view.makeToast("오류")
        }
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
        self.separatorInset = UIEdgeInsets.zero
    }
    
    func commonInit(item: VerObject.VersionHistory) {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        
        verLabel.text = "v\(item.version)"
        var content = ""
        for item in item.info {
            content += "\(item)\r"
        }
        content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        contentLabel.text = content
        
        let today = Date()
        if let updateDate = df.date(from: item.date) {
            let dayValue = today.days(from: updateDate)
            if dayValue <= 30 {
                dayLabel.text = "\(dayValue)일전"
            } else {
                let monthValue = today.months(from: updateDate)
                if monthValue <= 12 {
                    dayLabel.text = "\(monthValue)개월전"
                } else {
                    let yearValue = today.years(from: updateDate)
                    dayLabel.text = "\(yearValue)년전"
                }
            }
        } else {
            dayLabel.text = ""
        }
    }
}

class CsrHeaderCell: UITableViewCell {
    @IBOutlet weak var label: UIButton!
    @IBOutlet weak var flipBtn: UIButton!
    
}
