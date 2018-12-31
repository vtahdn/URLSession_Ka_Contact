//
//  ActionViewController.swift
//  URLSession_Ka_Contact
//
//  Created by Viet Asc on 12/31/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

let baseURL = "http://localhost:2403/information/"

protocol AddNewContactDelegate {
    
    func dismissAddNewContactController(addNewVC : ActionViewController)
    
}

class ActionViewController: UIViewController {
    
    @IBOutlet weak var bannerView: UIView!
     @IBOutlet weak var nameTextField: CustomTextField!
     @IBOutlet weak var phoneTextField: CustomTextField!
     @IBOutlet weak var cityTextField: CustomTextField!
     @IBOutlet weak var emailTextField: CustomTextField!
     @IBOutlet weak var imageTextField: CustomTextField!
     @IBOutlet weak var navLabel: UILabel!
     @IBOutlet weak var addButton: UIButton!
     @IBOutlet weak var profileImageView: UIImageView!
    
    var id = ""
    
    var delegate: AddNewContactDelegate?
    
    // Action requests
    lazy var contactRequest = { (_ name: String, _ phone: Int, _ city: String?, _ email: String?, _ image: String?, _ id: String, _ method: String) in
        
        var param : [String: Any] = ["name": name, "phone": phone]
        if city != nil {
            param["city"] = city
        }
        if email != nil {
            param["email"] = email
        }
        if image != nil {
            param["image"] = image
        }
        var urlRequest = NSMutableURLRequest()
        if method == "PUT" {
            urlRequest = NSMutableURLRequest(url: URL(string: baseURL + id)!)
        }
        if method == "POST" {
            urlRequest = NSMutableURLRequest(url: URL(string: baseURL)!)
        }
        urlRequest.httpMethod = method
        let configureSession = URLSessionConfiguration.default
        configureSession.httpAdditionalHeaders = ["Content-Type":"application/json"]
        let createContactSession = URLSession(configuration: configureSession)
        let dataPassing = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
        createContactSession.uploadTask(with: urlRequest as URLRequest, from: dataPassing, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
            } else {
                if let responseHTTP = response as? HTTPURLResponse {
                    if responseHTTP.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.delegate?.dismissAddNewContactController(addNewVC: self)
                        }
                        print("Action completed.")
                    }
                }
            }
        }).resume()
        
    }
    
    lazy var mask = { (_ view: UIView, _ rectCorner: UIRectCorner, _ radius: CGSize) in
        
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.borderWidth = 1
        maskLayer.borderColor = UIColor.black.cgColor
        view.layer.mask = maskLayer
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        phoneTextField.delegate = self
        cityTextField.delegate = self
        emailTextField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mask(view, [.bottomLeft, .bottomRight, .topLeft, .topRight], CGSize(width: 20, height: 20))
        if bannerView != nil {
            mask(bannerView, [.topLeft, .topRight], CGSize(width: 20, height: 20))
        }
        
    }
    
    @IBAction func addNewContactAction(sender: UIButton) {
        
        if let name = nameTextField.text, let phone = Int(phoneTextField.text!) {
            contactRequest(name, phone, cityTextField.text, emailTextField.text, imageTextField.text, "", "POST")
            print("Added.")
        }
        
    }
    
    @IBAction func updateContactAction(sender: UIButton) {
        
        if let name = nameTextField.text, let phone = Int(phoneTextField.text!) {
            contactRequest(name, phone, cityTextField.text, emailTextField.text, imageTextField.text, id, "PUT")
            print("Edited.")
        }
        
    }
}

extension ActionViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.alpha = 1
        textField.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.75)
        textField.setValue(UIColor.clear, forKeyPath: "_placeholderLabel.textColor")
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.alpha = 0.3
        textField.setValue(UIColor.black, forKeyPath: "_placeholderLabel.textColor")
        
    }
    
}
