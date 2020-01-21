//
//  HistoryTableViewCell.swift
//  YouTube
//
//  Created by csie on 2019/8/15.
//  Copyright © 2019 Haik Aslanyan. All rights reserved.
//

import UIKit
import Kingfisher
class HistoryTableViewCell: UITableViewCell {

    
    @IBOutlet var StartTimeLabel: UILabel!
    
    @IBOutlet var EndTimeLabel: UILabel!
    
    @IBOutlet var DurationLabel: UILabel!
    
    @IBOutlet var VideoImage: UIImageView!
    
    @IBOutlet var VideoTitile: UILabel!
    
    var HistoryVideo = FsdVideo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.StartTimeLabel.text = ""
       self.EndTimeLabel.text = ""
        self.DurationLabel.text = ""
        self.VideoTitile.text = ""

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
