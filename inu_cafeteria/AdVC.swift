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
import Kingfisher

class AdVC: UIViewController {
    
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var pageControl: FSPageControl!
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func linkClicked(_ sender: Any) {
        guard let url = URL(string: "http://naver.com") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    private let cellId = "Cell"
    var adItems: [AdObject] = []
    var firstIndex: Int?
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        pageControl.currentPage = 0
        pageControl.setFillColor(UIColor.cftBrightSkyBlue, for: .selected)
        pageControl.setFillColor(UIColor(rgb: 201), for: .normal)
        
        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 7, height: 7)), for: .normal)
        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 7, height: 7)), for: .selected)
        
        carouselView.type = .rotary
        carouselView.isPagingEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pageControl.numberOfPages = adItems.count
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = firstIndex {
            print(index)
            carouselView.scrollToItem(at: index, animated: true)
            pageControl.currentPage = index
            firstIndex = nil
        }
    }
}

extension AdVC: iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return adItems.count
    }
    
    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return Device.getWidth(width: 293.5)
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let width = Device.getWidth(width: 293.5)
        let height = Device.getHeight(height: 450.5)
        let item = adItems[index]
        
        let view = AdDetailView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.commonInit(item: item)
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
//        infoView.isHidden = false
        if index == carousel.currentItemIndex {
            guard let view = carousel.currentItemView as? AdDetailView else {return}
            view.isSelected = true
        }
    }
    
    func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool) {
        pageControl.currentPage = carousel.currentItemIndex
    }
    
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        guard let view = carousel.currentItemView as? AdDetailView else {return}
        view.isSelected = false
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        if option == .spacing {
//            return value * 1.5
////            value + (value * 18 / 293.5)
//        }
        if option == .count {
            return 3
        }
        
        //뒤 아이템들 투명화
        if option == .fadeMin {
            return 0
        }
        if option == .fadeMax {
            return 0
        }
        if option == .fadeRange {
            return 2
        }
        
        if option == .visibleItems {
            return 3
        }
        
        if option == .wrap {
            return 1
        }
        
        return value
    }
}

//extension AdVC: FSPagerViewDelegate, FSPagerViewDataSource {
//
//    func numberOfItems(in pagerView: FSPagerView) -> Int {
//        return adItems.count
//    }
//
//    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: cellId, at: index) as! AdCell
//        let item = adItems[index]
//
////        cell.selectionColor = UIColor.clear
//        cell.backgroundColor = .red
//        cell.imageView?.contentMode = .scaleAspectFit
//        cell.contentView.layer.shadowRadius = 0
//        cell.imageView?.kf.setImage(with: URL(string: "\(BASE_URL)/\(item.img)")!)
//        cell.imageView?.clipsToBounds = true
//
////        let view = AdDetailView()
////        cell.selectedView = view
////        cell.parents = self
////        view.item = item
//
//        return cell
//    }
//
//    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
//        self.infoView.isHidden = true
//    }
//
//    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
//        self.infoView.isHidden = true
//    }
//
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        self.infoView.isHidden = false
//    }
//
////    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
////        if let cell = self.selectedCell {
////            cell.selectedView?.isHidden = true
//////            cell.imageView?.isUserInteractionEnabled = false
////        }
////    }
//
//    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        pageControl.currentPage = targetIndex
//    }
//}
//
//class AdCell: FSPagerViewCell {
////    var parents: AdVC?
////
////    override func selectedViewToggle() {
////        super.selectedViewToggle()
////        if !(selectedView?.isHidden)! {
////            parents?.selectedCell = self
////        }
////    }
//}

//class AdCell: FSPagerViewCell {
//
////    override var selectedBackgroundView: UIView? {
////        get {
////            let view = UIView()
////            view.backgroundColor = .clear
////            return view
////        }
////        set {}
////    }
//
//    override func awakeFromNib() {
//
//    }
//
//    func commonInit(item: AdObject) {
//
//
//
////        let width = Device.getWidth(width: 293.5)
////        let height = Device.getHeight(height: 450.5)
////        let view = AdDetailView(frame: CGRect(x: 0, y: 0, width: width, height: height))
////        self.selectedBackgroundView = view
//    }
//}
