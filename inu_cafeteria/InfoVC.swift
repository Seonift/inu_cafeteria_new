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
    @IBOutlet weak var cView: UICollectionView!
    
    let parts = ["Server", "iOS", "Android", "Android", "Design"]
    let names = ["신재문", "김선일", "권순재", "이가윤", "김진웅"]
    let images = ["imgJaemoon", "imgSunil", "imgSoonjae", "imgGayoon", "imgJinwoong"]
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        cView.backgroundColor = UIColor.clear
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, DeviceUtil.getWidth(width: 40), 0, DeviceUtil.getWidth(width: 40))
        layout.itemSize = CGSize(width: 128, height: 110)
        layout.minimumLineSpacing = 30
        cView.collectionViewLayout = layout
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.verLabel.text = "버전 : \(version)"
        }
    }
}

extension InfoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCell", for: indexPath) as! InfoCell
        
        cell.iv.image = UIImage(named: images[indexPath.row])
        cell.partLabel.text = parts[indexPath.row]
        cell.nameLabel.text = names[indexPath.row]
        
//        if indexPath.row == 2 {
//            cell.width_const.constant = 75.5
//            cell.layoutIfNeeded()
//        }
        
        return cell
    }
}

class InfoCell:UICollectionViewCell {
    @IBOutlet weak var iv: UIImageView!
    
    @IBOutlet weak var width_const: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
        
        partLabel.font = UIFont(name: "KoPubDotumPL", size: 13)
        partLabel.adjustsFontSizeToFitWidth = true
        partLabel.minimumScaleFactor = 0.2
        partLabel.numberOfLines = 1
        nameLabel.font = UIFont(name: "KoPubDotumPB", size: 18)
    }
}
