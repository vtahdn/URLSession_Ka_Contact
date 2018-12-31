//
//  ContactListViewController.swift
//  URLSession_Ka_Contact
//
//  Created by Viet Asc on 12/31/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var informations = [Person]()
    var blurView: UIView?
    var popUpVC: ActionViewController?
    
    lazy var deleteRequest = { (_ indexPath: IndexPath) in
        
        let id = self.informations[indexPath.row].id
        let urlRequest = NSMutableURLRequest(url: URL(string: baseURL + id!)!)
        urlRequest.httpMethod = "DELETE"
        let sessionConfigure = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfigure)
        session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.informations.remove(at: indexPath.row)
                        DispatchQueue.main.async {
                            self.myTableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }
        }).resume()
        
    }
    
    lazy var getInfo = { () -> [Person] in
        
        return self.informations
        
    }
    
    lazy var informationRequest = {
        
        let urlRequest = NSURLRequest(url: URL(string: baseURL)!)
        let session = URLSession.shared
        session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
            } else {
                if let responseHTTP = response as? HTTPURLResponse {
                    if responseHTTP.statusCode == 200 {
                        guard let infomation = data else { return }
                        do {
                            let result = try JSONSerialization.jsonObject(with: infomation, options: JSONSerialization.ReadingOptions.allowFragments)
                            if let array = result as? [AnyObject] {
                                for dictionary in array {
                                    if let dictionary = dictionary as? [String: AnyObject] {
                                        self.informations.append(Person(infomation: dictionary))
                                        DispatchQueue.main.async {
                                            self.myTableView.reloadData()
                                        }
                                    }
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }).resume()
        
    }
    
    lazy var dismissContactView = { (_ addViewVC: ActionViewController) in
        
        let bounds = addViewVC.view.bounds
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            addViewVC.view.alpha = 0.5
            addViewVC.view.center = CGPoint(x: self.view.bounds.width/2, y: -bounds.height)
            self.blurView?.alpha = 0
        }, completion: { (Bool) in
            addViewVC.view.removeFromSuperview()
            addViewVC.removeFromParent()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.blurView?.removeFromSuperview()
        })
        
    }
    
    @objc func tapDismissGesture(tapGesture: UITapGestureRecognizer) {
        
        dismissContactView(popUpVC!)
        
    }
    
    lazy var createBlurView = { () -> UIView in
        
        let blurView = UIView(frame: self.view.bounds)
        blurView.backgroundColor = UIColor.black
        blurView.alpha = 0.5
        return blurView
        
    }
    
    lazy var displayContentController = { (_ content: ActionViewController) in
        
        self.popUpVC = content
        self.blurView = self.createBlurView()
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapDismissGesture(tapGesture:)))
        self.view.addSubview(self.blurView!)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.addChild(content)
        content.view.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width / 1.2, height: self.view.bounds.height / 1.3)
        content.view.alpha = 0.5
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.transitionFlipFromBottom, animations: {
            content.view.alpha = 1
            content.view.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            self.view.addSubview(content.view)
            content.didMove(toParent: self)
        }, completion: nil)
        
    }
    
    @objc func addNewContact(sender: AnyObject) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddNewContactVC") as! ActionViewController
        controller.delegate = self
        displayContentController(controller)
        
    }
    
    lazy var barButton = { () -> UIBarButtonItem in
        
        let addNewContactBarButton = UIBarButtonItem(image: UIImage(named: "Add New Bar Button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.addNewContact(sender:)))
        return addNewContactBarButton
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        navigationItem.title = "Ka ♡ List"
        navigationItem.rightBarButtonItem = barButton()
        informationRequest()

    }

}

extension ContactListViewController : AddNewContactDelegate {
    
    func dismissAddNewContactController(addNewVC: ActionViewController) {
        
        dismissContactView(addNewVC)
        informations.removeAll()
        informationRequest()
        
    }
    
}

extension ContactListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "DELETE") { (rowAction, indexPath) in
            
            self.deleteRequest(indexPath)
            print("delete")
            
        }
        
        delete.backgroundColor = .black
        
        let edit = UITableViewRowAction(style: .default, title: "EDIT") { (rowAction, indexPath) in
    
            let updateController = self.storyboard?.instantiateViewController(withIdentifier: "updateContact") as! ActionViewController
            updateController.delegate = self
            self.displayContentController(updateController)
            let person = self.informations[indexPath.row]
            updateController.id = person.id!
            updateController.nameTextField.text = person.name
            if let phone = person.phone {
                updateController.phoneTextField.text = "\(phone)"
            }
            if let city = person.city {
                updateController.cityTextField.text = "\(city)"
            }
            if let email = person.email {
                updateController.emailTextField.text = "\(email)"
            }
            if let image = person.image {
                updateController.imageTextField.text = "\(image)"
                updateController.profileImageView.image = UIImage(named: image)
            }
            print("edit")
            
        }
        
        delete.backgroundColor = .gray
        
        return [delete, edit]
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
}

extension ContactListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return informations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! DetailContactCell
        let person = informations[indexPath.row]
        cell.updateUI(person)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
}
