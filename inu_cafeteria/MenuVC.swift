//
//  MenuVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 21..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit
import Device

class MenuVC: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView_bottomConst: NSLayoutConstraint!
    
    private var foodPlan: [FoodMenu] = [] { // 식단 메뉴
        didSet {
            foodPlan = foodPlan.sorted(by: { $0.order < $1.order })
        }
    }
    private var code: Int = -1 // 현재 식당 코드
    private let cellId = "MenuCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(finish))
        gesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gesture)
        
        bottomConst.constant = -Device.getHeight(height: 40)
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 48
        tableView.rowHeight = UITableViewAutomaticDimension
//        384:379
        
        tableView_bottomConst.constant = Device.getHeight(height: 40)
        
        self.view.layoutIfNeeded()
        
        contentView.layer.cornerRadius = Device.getWidth(width: 22)
        contentView.layer.borderColor = UIColor(rgb: 240).cgColor
        contentView.layer.borderWidth = 0.5
    }
    
    func setData(menu: [FoodMenu], code: Int) {
        self.foodPlan = menu
        self.code = code
    }
    
    @objc func finish() {
        
        self.bottomConst.constant = -Device.getHeight(height: 384)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodPlan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateCell(withIdentifier: cellId, for: indexPath, cellClass: MenuCell.self)
        cell.commonInit(menu: foodPlan[indexPath.row])
        return cell
    }
}

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var cornerLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    
    @IBOutlet weak var corner_topConst: NSLayoutConstraint!
    
    lazy var topConst: NSLayoutConstraint = {
        let const = NSLayoutConstraint(item: menuLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: Device.getHeight(height: 14))
        return const
    }()
    
    lazy var bottomConst: NSLayoutConstraint = {
        let const = NSLayoutConstraint(item: menuLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -Device.getHeight(height: 14))
        return const
    }()
    
    override func awakeFromNib() {
        self.contentView.addConstraint(topConst)
        self.contentView.addConstraint(bottomConst)
        self.contentView.layoutIfNeeded()
        self.separatorInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        self.selectionStyle = .none
    }
    
    func commonInit(menu: FoodMenu) {
        self.cornerLabel.text = menu.title
        self.menuLabel.text = menu.menu
        
        if menu.menu.isEmpty {
            //            corner_topConst.isActive = false
            let const = NSLayoutConstraint(item: cornerLabel, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
            const.priority = UILayoutPriority(rawValue: 1000)
            self.contentView.addConstraint(const)
            self.contentView.layoutIfNeeded()
        }
    }
}

extension UIView {
    // Note: the method needs the view from which the context is taken as an argument.
    func dropShadow(superview: UIView) {
        // Get context from superview
//        UIGraphicsBeginImageContext(self.bounds.size)
//        superview.drawHierarchy(in: CGRect(x: -self.frame.minX, y: -self.frame.minY, width: superview.bounds.width, height: superview.bounds.height), afterScreenUpdates: true)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        // Add a UIImageView with the image from the context as a subview
        let imageView = UIImageView(frame: self.bounds)
//        imageView.image = image
//        imageView.backgroundColor = UIColor(r: 255, g: 255, b: 100, a: 0.75)
        imageView.layer.cornerRadius = self.layer.cornerRadius
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        // Bring the background color to the front, alternatively set it as UIColor(white: 1, alpha: 0.2)
        let brighter = UIView(frame: self.bounds)
        brighter.backgroundColor = UIColor(r: 255, g: 255, b: 255, a: 0.75)
        brighter.layer.cornerRadius = self.layer.cornerRadius
        brighter.clipsToBounds = true
        self.addSubview(brighter)
        
        // Set the shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.35
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
}
