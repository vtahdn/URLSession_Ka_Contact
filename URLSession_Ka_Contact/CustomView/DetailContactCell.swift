//
//  DetailContactCell.swift
//  URLSession_Ka_Contact
//
//  Created by Viet Asc on 12/31/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

class DetailContactCell: UITableViewCell {
    
    @IBOutlet weak var personalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var addressImageWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var leadingBetweenPhoneImageViewAndAddressLabel: NSLayoutConstraint!
    @IBOutlet weak var leadingBetweenAddressImageViewAndAddressLabelContraint: NSLayoutConstraint!
    
    lazy var contentNoAddress = {
        
        self.addressImageWidthContraint.constant = 0
        self.leadingBetweenPhoneImageViewAndAddressLabel.constant = 0
        self.leadingBetweenAddressImageViewAndAddressLabelContraint.constant = 0
        
    }
    
    lazy var contentHavingAddress = {
        
        self.addressImageWidthContraint.constant = 18.0
        self.leadingBetweenPhoneImageViewAndAddressLabel.constant = 4
        self.leadingBetweenAddressImageViewAndAddressLabelContraint.constant = 4
        
    }
    
    lazy var updateUI = { (_ person: Person) in
        
        self.nameLabel.text = person.name
        if let address = person.city {
            if address != "" {
                self.addressLabel.text = address
                self.contentHavingAddress()
            } else {
                self.addressLabel.text = ""
                self.contentNoAddress()
            }
        }
        if let phone = person.phone {
            self.phoneLabel.text = String(phone)
        } else {
            self.phoneImageView.isHidden = true
        }
        if let image = person.image {
            self.personalImageView.image = UIImage(named: image)
            self.personalImageView.contentMode = .scaleToFill
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        personalImageView.layer.cornerRadius = personalImageView.bounds.size.width / 2
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }


}
