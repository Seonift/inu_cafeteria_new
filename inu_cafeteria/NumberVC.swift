//
//  NumberVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 19..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit
import Device
import SocketIO
import AVFoundation

class NumberVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleIV: UIImageView!
    
    private var audioPlayer: AVAudioPlayer?
    
    private var start_index: Int = 0 // 출력 시작하는 index
    private var items: [String] = [] {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
            if items.count > 12 {
                self.start_index += 1
            }
        }
    }
    
    private var inputNumbers: [Int] = []
    private var code: Int = 0
    private var cafeTitle: String = ""
    private var bgimg: String?
    private let cellId = "NumCell"
    
    private lazy var model: NumberModel = {
        let model = NumberModel(self)
        return model
    }()
    
    @IBOutlet weak var numLabel1: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var content: UIView!
    @IBAction func backClicked(_ sender: Any) {
        let alert = CustomAlert.alert(message: String.cancel_num, positiveAction: { _ in
            // 소켓 초기화
            Indicator.startAnimating(activityData)
            self.model.resetNumber()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setSocketConnect()
        
        Indicator.startAnimating(activityData)
        model.isNumberWait()
        
        setData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(comebackForeground), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        
    }
    
    @objc func comebackForeground() {
        setSocketConnect()
        model.isNumberWait()
    }
    
    @objc func enterBackground() {
        SocketIOManager.sharedInstance.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SocketIOManager.sharedInstance.removeAll()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func setData() {
        // 번호와 타이틀 설정
        var attrs: [NSMutableAttributedString] = []
        switch inputNumbers.count {
        case 3:
            let n3 = NSMutableAttributedString(string: " \(inputNumbers[2])", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, .font: UIFont.KoPubDotum(type: .L, size: 24)])
            attrs.append(n3)
            fallthrough
        case 2:
            let n2 = NSMutableAttributedString(string: "\r\(inputNumbers[1])", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, .font: UIFont.KoPubDotum(type: .L, size: 24)])
            attrs.append(n2)
            fallthrough
        case 1:
            let n1 = NSMutableAttributedString(string: "\(inputNumbers[0])", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, .font: UIFont.KoPubDotum(type: .L, size: 55)])
            attrs.append(n1)
        default:
            print()
        }
        attrs = attrs.reversed()
        let result = NSMutableAttributedString()
        for i in 0..<attrs.count {
            result.append(attrs[i])
        }
        numLabel1.attributedText = result
        
        titleLabel.text = cafeTitle
        
        let imagename = "sss"+String(code)
        //
        if let image = UIImage(named: imagename) {
            titleIV.image = image
        } else {
            guard let bgimg = self.bgimg else {
                titleIV.image = nil
                titleIV.backgroundColor = UIColor(r: 54, g: 46, b: 43)
                return
            }
            if let url = URL(string: "\(BASE_URL + bgimg)") {
                titleIV.kf.setImage(with: url) { (_, error, _, _) in
                    if error != nil {
                        self.titleIV.image = nil
                        self.titleIV.backgroundColor = UIColor(r: 54, g: 46, b: 43)
                    }
                }
            }
        }
    }
    
    func setupUI() {
        content.layer.cornerRadius = 14.0
        content.clipsToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 55, height: 27)
        layout.minimumInteritemSpacing = (Device.getWidth(width: 302) - (55 * 4)) / 3
        layout.minimumLineSpacing = Device.getHeight(height: 45)
        collectionView.collectionViewLayout = layout
        
        collectionView.isUserInteractionEnabled = true
    }
    
    func commonInit(code: Int, title: String, numbers: [Int], bgimg: String? = nil) {
        self.code = code
        self.cafeTitle = title
        self.inputNumbers = numbers
        if let bgimg = bgimg, bgimg != "" { self.bgimg = bgimg }
    }
    
    func setSocketConnect() {
        log.debug("setSocket, code:\(self.code)")
        SocketIOManager.sharedInstance.getNumber(code: String(self.code)) { (result) -> Void in
            DispatchQueue.main.async {
                if let res = result.first as? NSDictionary, let msg = res["msg"] as? String, let msgint = Int(msg) {
                    log.info("msgint:\(msgint)")
                    self.items.append(msg)
                    if self.checkNumCorrect(msgint) == true {
                        //내 번호가 나오면 알림
                        let alert = CustomAlert.okAlert(message: "\(String.complete_num)\n번호 : \(msgint)", positiveAction: { _ in
                            self.model.isNumberWait()
                        })
                        self.present(alert, animated: true, completion: nil)
                        
                        let systemSoundID: SystemSoundID = 1005
                        let vib = SystemSoundID(kSystemSoundID_Vibrate)
                        AudioServicesPlaySystemSound(systemSoundID)
                        AudioServicesPlaySystemSound(vib)
                    }
                }
            }
        }
    }
    
    func checkNumCorrect(_ num: Int) -> Bool {
        print("checkNumCorrect:\(String(num))")
        //번호가 들어왔을때 맞는 번호인지 확인
        if inputNumbers.count > 0 {
            for item in inputNumbers where item == num {
                return true
            }
        }
        return false
    }
    
    //    func wakeUp() {
    //        //background에서 복귀
    //        print("wakeup")
    //
    //        Indicator.startAnimating(activityData)
    //        model.isNumberWait()
    //
    //        setSocketConnect()
    //    }
    
    // 아래 밖 여백 53 - 43.5 = 9.5
    
    // 셀 크기 48 x 31
    
    // 줄간격 42
    
    // 42 * 2 + 31 * 3 = 177, 위아래여백 39 * 2 = 255
}

extension NumberVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items.count < 12 {
            return items.count
        } else {
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NumCell
        let cell = collectionView.generateCell(withIdentifier: cellId, for: indexPath, cellClass: NumCell.self)
        cell.backgroundColor = .white
        
        guard let text = items[safe: self.start_index + indexPath.row] else {
            cell.label.text = ""
            return cell
        }
        cell.label.text = text
        if indexPath.row >= 9 {
            cell.label.textColor = UIColor.cftBrightSkyBlue
        } else {
            cell.label.textColor = UIColor(rgb: 125)
        }
        
        return cell
        
    }
}

extension NumberVC: NetworkCallback {
    func networkResult(resultData: Any, code: String) {
        print(code)
        Indicator.stopAnimating()
        
        if code == model._isNumberWait {
            guard let result = resultData as? WaitNumber else { return }
            
            if result.num.count != self.inputNumbers.count {
                // 갔다 온 사이에 변화가 있으면
                self.inputNumbers = result._num
                setData()
            }
        }
        
        if code == model._resetNumber {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func networkFailed(errorMsg: String, code: String) {
        Indicator.stopAnimating()
        
        if code == model._isNumberWait {
            self.navigationController?.popViewController(animated: true)
        }
        
        if code == model._resetNumber {
            self.view.makeToast(errorMsg)
        }
    }
    
    func networkFailed() {
        self.view.makeToast(String.noServer)
        Indicator.stopAnimating()
    }
}

class NumCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
