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
    
//    var foodplan:[FoodObject.Food] = [] {
//        didSet {
//            foodplan = foodplan.sorted(by: { $0.type1 < $1.type1 })
//        }
//    }
    
    var foodPlan:[FoodMenu] = [] {
        didSet {
            foodPlan = foodPlan.sorted(by: { $0.order < $1.order })
        }
    }
    
    var code:Int = -1
    
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
    
    @objc func finish(){
        
        self.bottomConst.constant = -Device.getHeight(height: 384)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        contentView.dropShadow(superview: view)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        
        let item = foodPlan[indexPath.row]
        cell.commonInit(menu: item)
//        let item = foodplan[indexPath.row]
//        cell.commonInit(corner: item.type1, menu: item.menu)
        
//        switch indexPath.row {
//        case 0:
//            cell.commonInit(corner: "\(indexPath.row + 1)코너", menu: "차돌순두부찌개(조식) 피망잡채&꽃빵 건파래볶음 열무된장무침 배추김치 3,000원 636kcal\r치즈닭갈비/삼겹살김치찌개 계란말이 맛살야채볶음 열무된장무침 배추김치 4,000 732/712kcal\r훈제오리철판구이(2인)")
//        case 1:
//            cell.commonInit(corner: "\(indexPath.row + 1)코너", menu: "돈까스야끼파스타 크림스프 양배추샐러드 단무지 배추김치 3,500원 683kcal\r소불고기새싹비빔밤 미역국 배추김치 3,000원 707kcal")
//        case 2:
//            cell.commonInit(corner: "\(indexPath.row + 1)코너", menu: "")
//        case 3:
//            cell.commonInit(corner: "\(indexPath.row + 1)코너", menu: "삼겹살스테이크 도리아(불닭)\r치즈오븐스파게티(토마토)\r빠네파스타\r날치알베이컨파스타 불고기샐러드 닭가슴살샐러드\r훈제연어샐러드")
//        case 4:
//            cell.commonInit(corner: "\(indexPath.row + 1)코너", menu: "")
//        default:
//            print()
//        }
        
        return cell
    }
}

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var cornerLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    
    @IBOutlet weak var corner_topConst: NSLayoutConstraint!
    
    lazy var topConst:NSLayoutConstraint = {
        let const = NSLayoutConstraint(item: menuLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: Device.getHeight(height: 14))
        return const
    }()
    
    lazy var bottomConst:NSLayoutConstraint = {
        let const = NSLayoutConstraint(item: menuLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -Device.getHeight(height: 14))
        return const
    }()
    
    override func awakeFromNib() {
        self.contentView.addConstraint(topConst)
        self.contentView.addConstraint(bottomConst)
        self.contentView.layoutIfNeeded()
        self.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2)
        self.selectionStyle = .none
    }
    
    func commonInit(menu: FoodMenu){
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
