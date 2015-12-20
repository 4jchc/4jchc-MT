//
//  MTDealCell.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/13.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit
protocol MTDealCellDelegate: class {
    func dealCellCheckingStateDidChange(sender: MTDealCell) -> Void
}



class MTDealCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var delegate: MTDealCellDelegate?
    /** 蒙版点击 */
    @IBAction func coverClick(sender: UIButton) {
        
        
        // 设置模型
        self.deal!.checking = !self.deal!.checking
        // 直接修改状态
        self.checkView.hidden = !self.checkView.hidden;
        if delegate != nil{
            
            self.delegate?.dealCellCheckingStateDidChange(self)
        }
        
    }
    @IBOutlet weak var cover: UIButton!
    @IBOutlet weak var checkView: UIImageView!
    
    
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descLabel: UILabel!
    
    @IBOutlet var currentPriceLabel: UILabel!
    
    @IBOutlet weak var listPriceLabel: MTCenterLineLabel!
   
    
    @IBOutlet var purchaseCountLabel: UILabel!
    
    @IBOutlet weak var dealNewView: UIImageView!

    
    
    
    var deal:MTDeal?{
        
        didSet{
            
            // 设置图片
            self.imageView.sd_setImageWithURL(NSURL(string: deal!.s_image_url), placeholderImage: UIImage(named: "placeholder_deal"))
            // 设置标题
            // 设置描述
            self.titleLabel.text = deal!.title;
            self.descLabel.text = deal!.desc;
            // 购买数
            purchaseCountLabel.text = String("已售\(deal!.purchase_count)")
            
            // 现价
            self.currentPriceLabel.text = "¥ \(deal!.current_price)"
           
            NSString(string: self.currentPriceLabel.text!).rangeOfString(".").location
            let dotLoc = NSString(string: self.currentPriceLabel.text!).rangeOfString(".").location as Int
            if dotLoc != NSNotFound{
                
                // 超过2位小数
                
                if ((self.currentPriceLabel.text! as NSString).length - dotLoc > 3){
                    
                self.currentPriceLabel.text = (self.currentPriceLabel.text! as NSString).substringToIndex(dotLoc + 3)
                print("*****\(self.currentPriceLabel.text)")
                }
            }

            // 原价
            self.listPriceLabel.text = String("¥ \(deal!.list_price)")
            
            // 是否显示新单图片
            let fmt = NSDateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            let nowStr = fmt.stringFromDate(NSDate())
            
            // 隐藏: 发布日期 < 今天
            self.dealNewView.hidden = (NSString(string: deal!.publish_date).compare(nowStr) == NSComparisonResult.OrderedAscending)

            // 根据模型属性来控制cover的显示和隐藏
            self.cover.hidden = !deal!.editing;
            
            // 根据模型属性来控制打钩的显示和隐藏
            self.checkView.hidden = !deal!.checking
            }
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        //拉伸
        UIImage(named: "bg_dealcell")?.drawInRect(rect)
        //平铺
        //UIImage(named: "bg_dealcell")?.drawAsPatternInRect(rect)
        }
    
    }
    
    
    
    

