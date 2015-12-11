//
//  MTHomeDropdownSubCell.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTHomeDropdownSubCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    ///初始化的时候设置背景图片
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // setup
        self.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_rightpart"))
        self.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_right_selected"))
        
    }
    

    // 公有方法
    class func cellWithTableView(tableView : UITableView) -> MTHomeDropdownSubCell {
        
        let id = "sub"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as? MTHomeDropdownSubCell
        
        if cell == nil {
            cell = MTHomeDropdownSubCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
        }
        
        return cell!
    }

}
