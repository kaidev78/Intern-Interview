//
//  ProfessorClassTableViewCell.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/25/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628
import UIKit

class ProfessorClassTableViewCell: UITableViewCell {

    @IBOutlet weak var classlbl: UILabel!
    @IBOutlet weak var numberlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
