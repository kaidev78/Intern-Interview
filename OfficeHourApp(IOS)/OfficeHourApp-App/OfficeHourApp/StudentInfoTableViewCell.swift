//
//  StudentInfoTableViewCell.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/25/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwne Chen
// ID: 111968628

import UIKit

class StudentInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var classlbl: UILabel!
    @IBOutlet weak var hourlbl: UILabel!
    @IBOutlet weak var readylbl: UILabel!
    @IBOutlet weak var professorlbl: UILabel!
    @IBOutlet weak var positionlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
