//
//  IngredientTableViewCell.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 09.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var ingredientLabel: UILabel!
    

}
