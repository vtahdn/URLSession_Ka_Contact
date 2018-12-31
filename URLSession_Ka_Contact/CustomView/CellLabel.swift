//
//  File.swift
//  URLSession_Ka_Contact
//
//  Created by Viet Asc on 12/31/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

class CellLabel: UILabel {
    
    lazy var configure = { (_ color: UIColor, _ fontName: String, _ fontSize: CGFloat) in

        self.textColor = color
        self.font = UIFont(name: fontName, size: fontSize)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        if tag == 101 {
            configure(UIColor.init(red: 244/255, green: 117/255, blue: 100/255, alpha: 1.0), "OpenSans-Semibold", 20)
        } else {
            configure(UIColor.gray, "OpenSans-Light", 12)
        }
        
    }
    
}
