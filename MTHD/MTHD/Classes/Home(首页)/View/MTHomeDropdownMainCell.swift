//
//  MTHomeDropdownMainCell.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTHomeDropdownMainCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    ///初始化的时候设置背景图片
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // setup
        self.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_leftpart"))
        self.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_left_selected"))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 公有方法
    class func cellWithTableView(tableView : UITableView) -> MTHomeDropdownMainCell {
        
        let id = "main"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as? MTHomeDropdownMainCell
        
        if cell == nil {
            cell = MTHomeDropdownMainCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
        }
        
        return cell!
    }
}
