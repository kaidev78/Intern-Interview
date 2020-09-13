//
//  ProfessorStudentAptTableViewCell.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/27/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

//Name: Kaiwen Chen
//ID: 111968628

import UIKit

class ProfessorStudentAptTableViewCell: UITableViewCell {

    @IBOutlet weak var studentnamelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
