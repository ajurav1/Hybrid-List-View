//
//  TransactionTypeCell.swift
//  Nehao
//
//  Created by Ajay Kumar on 10/10/17.
//  Copyright © 2017 Ajay Kumar. All rights reserved.
//

import UIKit

class TransactionTypeCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var highLightedView: UIView!
    
    //MARK:- Public Method(s)
    func processHighlightedView(_ selected:Bool){
        highLightedView.isHidden = !selected
        
        if selected{
            categoryLabel.textColor = #colorLiteral(red: 0.07058823529, green: 0.07450980392, blue: 0.262745098, alpha: 1)
        }
        else {
            categoryLabel.textColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
}
