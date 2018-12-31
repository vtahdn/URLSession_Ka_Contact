//
//  CustomTextField.swift
//  URLSession_Ka_Contact
//
//  Created by Viet Asc on 12/31/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

// Custom Text Field For Update and Add Views
class CustomTextField: UITextField {
    
    lazy var configurePlayholder = { (_ content: String) in
        
        self.font = UIFont(name: "OpenSans-Light", size: 18)
        let attribute = [NSAttributedString.Key.foregroundColor : UIColor.black]
        self.attributedPlaceholder = NSAttributedString(string: content, attributes: attribute)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        font = UIFont.init(name: "OpenSans-Light", size: 18)
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
        switch tag {
        case 101:
            configurePlayholder("Name")
        case 102:
            configurePlayholder("Phone Number")
        case 103:
            configurePlayholder("City")
        case 104:
            configurePlayholder("Email")
        case 105:
            configurePlayholder("Image")
        default:
            break
        }
        
    }
    
}
