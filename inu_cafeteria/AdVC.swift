//
//  AdVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 21..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit
import FSPagerView
import Device

class AdVC: UIViewController {
    
    var items:[String] = []
    var firstIndex:Int?
    @IBOutlet weak var pageControl: FSPageControl!
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: cellId)
            self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
            let width = Device.getWidth(width: 293.5)
            let height = Device.getHeight(height: 450.5)
            self.pagerView.itemSize = CGSize(width: width, height: height)
            self.pagerView.isInfinite = true
            self.pagerView.interitemSpacing = Device.getWidth(width: 17)
        }
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private let cellId = "Cell"
    
    @IBAction func linkClicked(_ sender: Any) {
        guard let url = URL(string: "http://naver.com") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI(){
        pageControl.numberOfPages = items.count
        pageControl.currentPage = 0
        pageControl.setFillColor(UIColor.cftBrightSkyBlue, for: .selected)
        pageControl.setFillColor(UIColor(rgb: 201), for: .normal)
        
        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 7, height: 7)), for: .normal)
        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 7, height: 7)), for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = firstIndex {
            print(index)
            pagerView.scrollToItem(at: index, animated: true)
            pageControl.currentPage = index
            firstIndex = nil
        }
    }
}

extension AdVC: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return items.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: cellId, at: index)
        
        switch index {
        case 0:
            cell.backgroundColor = .red
        case 1:
            cell.backgroundColor = .blue
        case 2:
            cell.backgroundColor = .green
        case 3:
            cell.backgroundColor = .gray
        default:
            cell.backgroundColor = UIColor.purple
        }
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
    

    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
    }
    
    
    
}
