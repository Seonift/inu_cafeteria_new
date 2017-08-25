//
//  InfoVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 16..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit

class InfoVC:UIViewController {
    @IBOutlet weak var verLabel: UILabel!
//    @IBOutlet weak var cView: UICollectionView!
    
//    let parts = ["Server", "iOS", "Android", "Android", "Design"]
//    let names = ["신재문", "김선일", "권순재", "이가윤", "김진웅"]
//    let images = ["imgJaemoon", "imgSunil", "imgSoonjae", "imgGayoon", "imgJinwoong"]
    
    @IBOutlet weak var p1: UILabel!
    @IBOutlet weak var p2: UILabel!
    @IBOutlet weak var p3: UILabel!
    @IBOutlet weak var p4: UILabel!
    @IBOutlet weak var p5: UILabel!
    
    @IBOutlet weak var n1: UILabel!
    @IBOutlet weak var n2: UILabel!
    @IBOutlet weak var n3: UILabel!
    @IBOutlet weak var n4: UILabel!
    @IBOutlet weak var n5: UILabel!
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        verLabel.font = UIFont(name: "KoPubDotumPB", size: 15)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.verLabel.text = "버전 : \(version)"
        }
        
        p1.font = UIFont(name: "KoPubDotumPL", size: 13)
        p2.font = UIFont(name: "KoPubDotumPL", size: 13)
        p3.font = UIFont(name: "KoPubDotumPL", size: 13)
        p4.font = UIFont(name: "KoPubDotumPL", size: 13)
        p5.font = UIFont(name: "KoPubDotumPL", size: 13)
        
        n1.font = UIFont(name: "KoPubDotumPB", size: 18)
        n2.font = UIFont(name: "KoPubDotumPB", size: 18)
        n3.font = UIFont(name: "KoPubDotumPB", size: 18)
        n4.font = UIFont(name: "KoPubDotumPB", size: 18)
        n5.font = UIFont(name: "KoPubDotumPB", size: 18)
        
//        cView.backgroundColor = UIColor.white
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsetsMake(28, DeviceUtil.getWidth(width: 40), 0, DeviceUtil.getWidth(width: 40))
//        layout.itemSize = CGSize(width: 128, height: 110)
//        layout.minimumLineSpacing = 30
//        cView.collectionViewLayout = layout
        
        
    }
}

class InfoVC2: UIViewController {
    
    @IBOutlet weak var verLabel: UILabel!
    @IBOutlet weak var p1: UILabel!
    @IBOutlet weak var p2: UILabel!
    @IBOutlet weak var p3: UILabel!
    @IBOutlet weak var p4: UILabel!
    @IBOutlet weak var p5: UILabel!
    
    @IBOutlet weak var n1: UILabel!
    @IBOutlet weak var n2: UILabel!
    @IBOutlet weak var n5: UILabel!
    @IBOutlet weak var n4: UILabel!
    @IBOutlet weak var n3: UILabel!
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        verLabel.font = UIFont(name: "KoPubDotumPB", size: 15)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.verLabel.text = "버전 : \(version)"
        }
        
        p1.font = UIFont(name: "KoPubDotumPL", size: 13)
        p2.font = UIFont(name: "KoPubDotumPL", size: 13)
        p3.font = UIFont(name: "KoPubDotumPL", size: 13)
        p4.font = UIFont(name: "KoPubDotumPL", size: 13)
        p5.font = UIFont(name: "KoPubDotumPL", size: 13)
        
        n1.font = UIFont(name: "KoPubDotumPB", size: 18)
        n2.font = UIFont(name: "KoPubDotumPB", size: 18)
        n3.font = UIFont(name: "KoPubDotumPB", size: 18)
        n4.font = UIFont(name: "KoPubDotumPB", size: 18)
        n5.font = UIFont(name: "KoPubDotumPB", size: 18)
        
    }
}

//extension InfoVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCell", for: indexPath) as! InfoCell
//        
//        cell.iv.image = UIImage(named: images[indexPath.row])
//        cell.partLabel.text = parts[indexPath.row]
//        cell.nameLabel.text = names[indexPath.row]
//        
////        if indexPath.row == 2 {
////            cell.width_const.constant = 75.5
////            cell.layoutIfNeeded()
////        }
//        
//        return cell
//    }
//}
//
//class InfoCell:UICollectionViewCell {
//    @IBOutlet weak var iv: UIImageView!
//    
//    @IBOutlet weak var width_const: NSLayoutConstraint!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var partLabel: UILabel!
//    
//    override func awakeFromNib() {
//        backgroundColor = UIColor.white
//        
//        partLabel.textColor = UIColor.untGreyishBrown
//        nameLabel.textColor = UIColor.untGreyishBrown
//        
//        partLabel.font = UIFont(name: "KoPubDotumPL", size: 13)
//        partLabel.adjustsFontSizeToFitWidth = true
//        partLabel.minimumScaleFactor = 0.2
//        partLabel.numberOfLines = 1
//        nameLabel.font = UIFont(name: "KoPubDotumPB", size: 18)
//    }
//}
