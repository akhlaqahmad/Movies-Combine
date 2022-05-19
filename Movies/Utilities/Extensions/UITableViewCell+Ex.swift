//
//  UITableViewCell+Ex.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import UIKit

extension UITableViewCell{
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
}
