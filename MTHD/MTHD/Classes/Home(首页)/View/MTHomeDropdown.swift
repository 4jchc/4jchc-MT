//
//  MTHomeDropdown.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTHomeDropdown: UIView ,UITableViewDataSource,UITableViewDelegate{


    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var subTableView: UITableView!
    
    var seledtedCategory:MTCategory?
    
    var categories: NSArray?
    
   static func dropdown()->MTHomeDropdown{
        
        return NSBundle.mainBundle().loadNibNamed("MTHomeDropdown", owner: nil, options: nil).first as! MTHomeDropdown
    }
    
    
    override func awakeFromNib() {
        
        // 不需要跟随父控件的尺寸变化而伸缩
        self.autoresizingMask = UIViewAutoresizing.None
    }
    

    //MARK:  - 数据源方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == mainTableView {
            
            return (self.categories?.count) ?? 0// 主表
            
        }else {// 从表
            if self.seledtedCategory?.subcategories == nil{
                
                return 0
            }else{
            print("*****\(self.seledtedCategory!.subcategories)")
            return (self.seledtedCategory!.subcategories?.count) ?? 0
            }}
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        // 主表
        if tableView == mainTableView {
            ///封装cell
            cell = MTHomeDropdownMainCell.cellWithTableView(tableView)
            
            // 取出数据模型
                let category:MTCategory = self.categories![indexPath.row] as! MTCategory
                // 显示文字
                cell!.textLabel?.text = category.name

                cell!.imageView?.image = UIImage(named: category.small_icon!)

            if category.subcategories != nil{
                
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else {
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }
            
            
            }   else{// 从表

            
            cell = MTHomeDropdownSubCell.cellWithTableView(tableView)
            cell?.textLabel?.text = self.seledtedCategory!.subcategories![indexPath.row] as? String
        }
        
            return cell!
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.mainTableView {
            

            // 被点击的分类
            self.seledtedCategory = self.categories![indexPath.row] as? MTCategory
            print("*****\(seledtedCategory)")
            // 刷新右边的数据
            self.subTableView.reloadData()
            }
        }
        
    }
