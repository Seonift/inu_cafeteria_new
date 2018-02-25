//
//  AdDetailView.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 24..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit

class AdDetailView: UIView {
    @IBOutlet private var contentView: UIView?
    
    private var _isSelected:Bool = false
    var isSelected:Bool {
        get {
            return _isSelected
        }
        set(v) {
            if v {
                tableView.isHidden = false
            } else {
                tableView.isHidden = true
            }
            _isSelected = v
        }
    }
    
    var item:AdObject? {
        didSet {
            print(item)
        }
    }
//    {
//        didSet {
//            if tableView != nil {
//                tableView.reloadData()
//            }
//        }
//    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellId = "AdCell"
    private let header = "header"
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
    }
    
    func setupUI(){
        Bundle.main.loadNibNamed("AdDetailView", owner: self, options: nil)
        
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        
        //        tableView.register(AdDetailCell.self, forCellReuseIdentifier: cellId)
        let nib = UINib(nibName: "AdDetailCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        let nib2 = UINib(nibName: "AdHeaderCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: header)
        
        tableView.separatorColor = .clear
        tableView.estimatedRowHeight = 29.5
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 95
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        gesture.numberOfTapsRequired = 1
        self.tableView.addGestureRecognizer(gesture)
    }
    
    @objc func tapped(){
        self.isSelected = !self.isSelected
    }
    
    func commonInit(item: AdObject){
        self.item = item
        self.imageView.kf.setImage(with: URL(string: "\(BASE_URL)/\(item.img)")!)
    }
}

extension AdDetailView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = item?.contents?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AdDetailCell
        if let contents = item?.contents, let item = contents[safe: indexPath.row] {
            cell.commonInit(item: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: header) as! AdHeaderCell
        cell.label.text = item?.title
        return cell
    }
}
