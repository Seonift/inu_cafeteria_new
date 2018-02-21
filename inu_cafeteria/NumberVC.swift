//
//  NumberVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 19..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit
import Device

class NumberVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleIV: UIImageView!
    
    var numbers:[Int] = []
    var code:Int = 0
    
    var items:[Int] = [5000,5000,5000,5000,5000,5000,5000,5000,5000,5000,5000,5000]
    
    @IBOutlet weak var numLabel1: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellId = "NumCell"
    
    @IBOutlet weak var content: UIView!
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var attrs:[NSMutableAttributedString] = []
        switch numbers.count {
        case 3:
            let n3 = NSMutableAttributedString(string: " \(numbers[2])", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, .font: UIFont.KoPubDotum(type: .L, size: 42.5)])
            attrs.append(n3)
            fallthrough
        case 2:
            let n2 = NSMutableAttributedString(string: " \(numbers[1])", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, .font: UIFont.KoPubDotum(type: .L, size: 42.5)])
            attrs.append(n2)
            fallthrough
        case 1:
            let n1 = NSMutableAttributedString(string: "\(numbers[0])", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, .font: UIFont.KoPubDotum(type: .L, size: 70)])
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
        
        switch code {
        case 1:
            titleLabel.text = "학생식당"
        default:
            print()
        }
        
        let imagename = "sss"+String(code)
        guard let image = UIImage(named: imagename) else {
            titleIV.image = UIImage(named: "mynumber_bg")
            titleIV.image = nil
            titleIV.backgroundColor = UIColor(r: 54, g: 46, b:43)
            return
        }
        titleIV.image = image
    }
    
    func setupUI() {
        content.layer.cornerRadius = 14.0
        content.clipsToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 55, height: 27)
        layout.minimumInteritemSpacing = (Device.getWidth(width: 302) - (55 * 4)) / 3
        layout.minimumLineSpacing = Device.getHeight(height: 45)
        collectionView.collectionViewLayout = layout
    }
    
    func commonInit(code: Int, numbers: [Int]) {
        self.code = code
        self.numbers = numbers
    }
    
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
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NumCell
        
        cell.label.text = "\(items[indexPath.row])"
        cell.backgroundColor = .white
        return cell
        
    }
}

class NumCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}
