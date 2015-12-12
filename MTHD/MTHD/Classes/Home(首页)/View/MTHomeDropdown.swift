//
//  MTHomeDropdown.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/10.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit



//MARK: - 自定义数据源方法
@objc protocol MTHomeDropdownDataSource : class {
    /**
     *  左边表格一共有多少行
     */
   func numberOfRowsInMainTable(homeDropdown: MTHomeDropdown) -> Int
    
    /**
     *  左边表格每一行的标题
     *  @param row          行号
     */
    func titleForRowInMainTable(homeDropdown: MTHomeDropdown, row: Int) -> String
    
    /**
     *  左边表格每一行的子数据
     *  @param row          行号
     */
    func subdataForRowInMainTable(homeDropdown: MTHomeDropdown, row: Int) -> NSArray?
    
    /**
     *  左边表格每一行的图标
     *  @param row          行号
     */
    optional func iconForRowInMainTable(homeDropdown: MTHomeDropdown, row: Int) -> String
    
    /**
     *  左边表格每一行的选中图标
     *  @param row          行号
     */
    optional func selectedIconForRowInMainTable(homeDropdown: MTHomeDropdown, row: Int) -> String

}

@objc protocol MTHomeDropdownDelegate : class {
    
    func didSelectRowInMainTable(row: Int) -> Void
    
    func didSelectRowInSubTable(subrow: Int, mainRow: Int) -> Void
}








class MTHomeDropdown: UIView ,UITableViewDataSource,UITableViewDelegate{

    // 代理
    weak var dateSource : MTHomeDropdownDataSource?
    weak var delegate : MTHomeDropdownDelegate?
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var subTableView: UITableView!
    
    
    var categories: NSArray?
    /** 左边主表选中的行号 */
    var selectedMainRow:Int?
    
   static func dropdown()->MTHomeDropdown{
        
        return NSBundle.mainBundle().loadNibNamed("MTHomeDropdown", owner: nil, options: nil).first as! MTHomeDropdown
    }
    
    override func awakeFromNib() {
        
        // 不需要跟随父控件的尺寸变化而伸缩
        self.autoresizingMask = UIViewAutoresizing.None
    }
    

    
    //MARK:  - 数据源方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRow : Int = 0

        
        if tableView == mainTableView {
            if let dateSource = self.dateSource {
                numberOfRow = dateSource.numberOfRowsInMainTable(self)
            }
        }
        else {
            if let dateSource = self.dateSource {
                print("*****\(selectedMainRow)")
                //MARK: - row不可以为空所以要有可选值0
                if let array = dateSource.subdataForRowInMainTable(self, row: self.selectedMainRow ?? 0) {
                    numberOfRow = array.count
                }
            }
        }
        return numberOfRow
    }






    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        // 主表
        if tableView == mainTableView {
            ///封装cell
            cell = MTHomeDropdownMainCell.cellWithTableView(tableView)

            // 取出数据模型
            if let dataSource = self.dateSource {

                cell!.textLabel?.text = self.dateSource?.titleForRowInMainTable(self, row: indexPath.row)
                
                if let iconUrl = dataSource.iconForRowInMainTable?(self, row: indexPath.row) {
                    cell!.imageView?.image = UIImage(named: iconUrl)
                }
                if let selectIconUrl = dataSource.selectedIconForRowInMainTable?(self, row: indexPath.row) {
                    cell!.imageView?.highlightedImage = UIImage(named: selectIconUrl)
                }
            

                
                // 取出从表数据
                let subData = dataSource.subdataForRowInMainTable(self, row: indexPath.row)
                
                // 根据从表数据加载标志
                if subData != nil {
                    cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                }
                else {
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                }
                
            }
            }   else{// 从表
            
            cell = MTHomeDropdownSubCell.cellWithTableView(tableView)
            if let dataSource = self.dateSource {
            let subData = dataSource.subdataForRowInMainTable(self, row: selectedMainRow!)
            cell!.textLabel?.text = subData?[indexPath.row] as? String
                }
            }
        return cell!
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 假如是主表的话
        if tableView == mainTableView {
            // 1.纪录下被点击的栏目
            selectedMainRow = indexPath.row
            // 2.刷新右表的数据
            subTableView.reloadData()
            // 3.将该事件通知代理
            if let delegate = self.delegate {
                delegate.didSelectRowInMainTable(indexPath.row)
            }
        }
            // 从表
        else {
        
            if let delegate = self.delegate{
            
                delegate.didSelectRowInSubTable(indexPath.row, mainRow: selectedMainRow!)
                }
            }
        }

    }
    
    