//
//  AddAndUpdateViewController.swift
//  Checklists
//
//  Created by Prince Bharti on 05/08/18.
//  Copyright © 2018 Prince Bharti. All rights reserved.
//

import UIKit
import RealmSwift


protocol AddAndUpdateViewControllerDelegate {
    func didFinishAdding(_ item: Item,by tableViewController: UITableViewController)
    func didFinishEditing(_ item: Item,by tableViewController: UITableViewController)
    func didCancelAddingOrEditing(by tableViewController: UITableViewController)
}



class AddAndUpdateViewController: UITableViewController,UITextFieldDelegate {
    
    // this variable tells the mode is adding or editing
    var mode: String?
    var delegate: AddAndUpdateViewControllerDelegate?
    var item: Item?
    let realm = try! Realm()
    
    
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
        
        if let mode = mode {
            if mode == "add" {
                navigationItem.title = "Add Item"
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else if mode == "edit" {
                navigationItem.title = "Edit Item"
                 guard let item = item else {fatalError()}
                textField.text = item.content

            }
        }
   
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    @IBAction func cancelButtonPressed() {
        delegate?.didCancelAddingOrEditing(by: self)
    }
    
    
    @IBAction func DoneButtonPressed() {
        if mode == "add" {
            let newItem = Item()
            newItem.content = textField.text!
            delegate?.didFinishAdding(newItem, by: self)
        } else if mode == "edit" {
           do {
               try realm.write{
                    item?.content = textField.text!
                }
            } catch {
               
                print("there is error while updating \(error)")
           }
           
            guard let item = item else {fatalError()}
            delegate?.didFinishEditing(item, by: self)
        }
    }
    
    //MARK:- text field delegate methods
    
  
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        
        // whenever there is change in textfield this method is called.
        
        if textField.text! == "" {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            
        }
        
        
    }
    
}
