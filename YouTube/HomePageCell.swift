//
//  TableViewCell.swift
//  UIScrollView With UIPageControl by storyboard
//
//  Created by csie on 2019/7/2.
//  Copyright © 2019 EthanLin. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
class TrendingVCCell: UITableViewCell {
    
    @IBOutlet weak var headline: UITextField!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var myPageControll: UIPageControl!
    
    var myScrollImageview: UIImageView!
   
 
    @IBAction func pageChanged(_ sender: UIPageControl) {
        let currentPageNumber = sender.currentPage
        let width = myScrollView.frame.size.width
        let offset = CGPoint(x: width * CGFloat(currentPageNumber), y: 0)
        myScrollView.setContentOffset(offset, animated: true)
    }
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(myScrollView.contentOffset.x / myScrollView.frame.size.width)
        myPageControll.currentPage = currentPage
        
    }
    
    func didselect(_ myScrollImageview: UIImageView){
        //tempvideo =
        print(myScrollImageview)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        
    }
    @objc func imageViewClick() {
        print("111")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
