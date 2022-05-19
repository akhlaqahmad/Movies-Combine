//
//  HomeTabCVCell.swift
//
//  Created by Akhlaq Ahmad on 14/05/2022.
//

import UIKit

class HomeTabCVCell: UICollectionViewCell {

    @IBOutlet weak var tabTitleLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 20
    }
    
    override var isSelected: Bool {
        didSet {
            bgView.backgroundColor = isSelected ? .black : .clear
            tabTitleLabel.textColor = isSelected ? .white : .black
        }
    }
    
}
