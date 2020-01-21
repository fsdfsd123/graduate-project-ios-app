//
//  MyTableViewCell.swift
//  LUExpandableTableViewExample
//
//  Created by Laurentiu Ungur on 24/11/2016.
//  Copyright © 2016 Laurentiu Ungur. All rights reserved.
//

import UIKit

final class MyTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    let label = UILabel()
    //var cimage = UIImageView(image: UIImage(named: "twitch"))

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.addSubview(cimage)
        contentView.addSubview(label)
        self.backgroundColor = .orange
        label.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Base Class Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //cimage.frame = contentView.bounds
            //contentView.frame.maxX

        label.frame = contentView.bounds
        label.frame.origin.x += 12
    }
    
 
}
