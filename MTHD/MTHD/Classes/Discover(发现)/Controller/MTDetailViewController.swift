//
//  MTDetailViewController.swift
//  MTHD
//
//  Created by 蒋进 on 15/12/15.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

class MTDetailViewController: UIViewController,UIWebViewDelegate, DPRequestDelegate {

        var deal: MTDeal!
    
    
    
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var desLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var leftTimeButton: UIButton!
    
    @IBOutlet var collectButton: UIButton!
    
    @IBOutlet var refundableAnyTimeButton: UIButton!
    /** 已购买数 */
    @IBOutlet weak var purchase_count: UIButton!
    
    @IBOutlet var refundableExpireButton: UIButton!
    /** 记录是否选中 */
    var selected:Bool = false
    @IBAction func back(sender: AnyObject) {
        
      dismissViewControllerAnimated(true, completion: nil)
        
    }
 

    @IBAction func buy(sender: AnyObject) {
        
//        // 1.生成订单信息
//        // 订单信息 == order == [order description]
//        let order = AlixPayOrder()
//        order.productName = deal.title
//        order.productDescription = deal.desc
//        order.partner = PartnerID
//        order.seller = SellerID
//        order.amount = deal.current_price //description
//        
//        // 2. 签名加密
//        let signer = CreateRSADataSigner(PartnerPrivKey)
//        // 签名信息 == signedString
//        let signedString = signer.signString(order.description)
//        
//        // 3. 利用订单信息，签名信息签名类型生成一个字符串
//        let orderString = NSString(format: "%@&sign=\"%@\"&sign_type=\"%@\"", order.description, signedString, "RSA")
//        
//        // 4.打开客户端,进行支付(商品名称,商品价格,商户信息)
//        AlixLibService.payOrder(orderString as String, andScheme: "tuangou", seletor: "getResult:", target: self)
        
    }
 
    @IBAction func collect(sender: AnyObject) {


        let info: NSMutableDictionary  = NSMutableDictionary()
        info[MTCollectDealKey] = self.deal;
        
        if (self.collectButton.selected) { // 取消收藏
             MTDealTool.removeCollectDeal(deal)
           MBProgressHUD.showSuccess("取消收藏成功",toView:self.view)
            self.collectButton.selected = self.selected
           
            info[MTIsCollectKey] = false
        } else { // 收藏
            MTDealTool.addCollectDeal(deal)
          
           MBProgressHUD.showSuccess("收藏成功",toView:self.view)
            self.collectButton.selected = !self.selected
            info[MTIsCollectKey] = true
        }

        print("***按钮的选中取反**\(self.collectButton.selected)----\(self.selected)")
        
        // 发出通知
        MTNotificationCenter.postNotificationName(MTCollectStateDidChangeNotification, object: nil)

    }

  
    @IBAction func share(sender: AnyObject) {
        
    }
    override func loadView() {
        super.loadView()
        NSBundle.mainBundle().loadNibNamed("MTDetailViewController", owner: self, options: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        self.view.backgroundColor = UIColor.randomColor
        // 1.加载页面
       // webView.hidden = true
        webView.loadRequest(NSURLRequest(URL: NSURL(string: deal.deal_h5_url)!))
        
        // 2.设置基本信息
        titleLabel.text = deal.title
        desLabel.text = deal.desc
        purchase_count.setTitle("已售\(deal.purchase_count)", forState: UIControlState.Normal)
        imageView.sd_setImageWithURL(NSURL(string: deal.image_url), placeholderImage: UIImage(named: "placeholder_deal"))
        
        // 3.设置剩余时间
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        var dead = fmt.dateFromString(deal.purchase_deadline)
        
        // 追加一天
        dead = dead?.dateByAddingTimeInterval(24 * 60 * 60)
        let now = NSDate()
        let unit = [NSCalendarUnit.Day , NSCalendarUnit.Hour , NSCalendarUnit.Minute] as NSCalendarUnit
        let cmps = NSCalendar.currentCalendar().components(unit, fromDate: now, toDate: dead!, options: NSCalendarOptions())
        
        
        
        if cmps.day > 365 {
            leftTimeButton.setTitle("一年之内不过期", forState: .Normal)
        } else {
            leftTimeButton.setTitle("\(cmps.day)天\(cmps.hour)小时\(cmps.minute)分钟", forState: .Normal)
        }
        // 4.发送请求获取更详细的团购数据
        let api = DPAPI()
        let params = NSMutableDictionary()
        params["deal_id"] = deal.deal_id
        api.requestWithURL("v1/deal/get_single_deal", params: params, delegate: self)
        
        // 5.设置收藏状态
        collectButton.selected = MTDealTool.isCollected(deal)
        print("*收藏状态收藏状态****\(collectButton.selected)")
//        // 6.发送最近浏览deal改变事件
//        NSNotificationCenter.defaultCenter().postNotificationName(SWRecentStateDidChangedNotification, object: nil)
//        MTDealTool.shareInstance.removeRecentDeal(deal)
//        MTDealTool.shareInstance.addRecentDeal(deal)


    }

    //MARK: - 返回控制器支持的方向只支持横评
    override func shouldAutorotate() -> Bool {
        
        return false
        
    }
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Landscape
        
    }
    

    //MARK: - DPRequestDelegate
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {

         self.deal = MTDeal.mj_objectArrayWithKeyValuesArray(result["deals"]).firstObject as! MTDeal
       
        // 设置退款信息

        self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable == 1 ? true : false
        self.refundableExpireButton.selected = self.deal.restrictions.is_refundable == 1 ? true : false
        
        
    }
    
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        MBProgressHUD.showError("网络繁忙，请稍后再试", toView: self.view)
    }
    

    
    //MARK:  - UIWebViewDelegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
       
        if webView.request?.URL?.absoluteString == deal.deal_h5_url { // 旧的HTML5页面加载完毕

        
            let range = (self.deal.deal_id as NSString).rangeOfString("-") as NSRange
            let rrr:Int = range.location + 1
            let ID = (self.deal.deal_id as NSString).substringFromIndex(rrr)
            //let ID = deal.deal_id.componentsSeparatedByString("-")[1]
            let urlStr = "http://lite.m.dianping.com/group/deal/moreinfo/" + ID
            print("***详情页的网址**\(urlStr)")
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlStr)!))
        } else { // 处理详情页
            
            // 获得网页页面
            //let html:NSString = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('html')[0].outerHTML;")!
            // 停止转动
            //print("*****\(html)")
            let js = NSMutableString()
            
            // 删除header
            js.appendString("var header = document.getElementsByTagName('header')[0];")
            js.appendString("header.parentNode.removeChild(header);")
            
            // 删除顶部的购买
            js.appendString("var box = document.getElementsByClassName('cost-box')[0];")
            js.appendString("box.parentNode.removeChild(box);")
            
            // 删除底部的购买
            js.appendString("var buyNow = document.getElementsByClassName('buy-now')[0];")
            js.appendString("buyNow.parentNode.removeChild(buyNow);")
            
            // 删除底部APP下单再减18元的购买
            js.appendString("var footerbtnfix = document.getElementsByClassName('footer-btn-fix')[0];")
            js.appendString("footerbtnfix.parentNode.removeChild(footerbtnfix);")
            // 利用webView执行JS
            webView.stringByEvaluatingJavaScriptFromString(js as String)

            self.loadingView.stopAnimating()
            // 显示webView
            webView.hidden = false
        }
        
    }


}
