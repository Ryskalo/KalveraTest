//
//  ResultsTableViewCell.swift
//  KalveraTest
//
//  Created by Антон Рыскалев on 11.02.16.
//  Copyright © 2016 Антон Рыскалев. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    

}
