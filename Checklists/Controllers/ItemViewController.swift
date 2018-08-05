//
//  ItemViewController.swift
//  Checklists
//
//  Created by Prince Bharti on 05/08/18.
//  Copyright © 2018 Prince Bharti. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController,AddAndUpdateViewControllerDelegate {
    

    
    var itemArray: Results<Item>?
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
     }
    
    //MARK:- table view data source methonds
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        if let textLabel = cell.viewWithTag(101) as? UILabel {
            textLabel.text = itemArray![indexPath.row].content
        }
        
        if let checkLabel = cell.viewWithTag(100) as? UILabel {
            
            checkLabel.text = itemArray![indexPath.row].done ? "√" : ""
        }
        
        return cell
    }
    
    
    //MARK:- table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try  realm.write {
                itemArray![indexPath.row].done = !itemArray![indexPath.row].done
            }
        } catch {
            print("error found while updating \(error)")
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic )
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
//            itemArray.remove(at: indexPath.row)
            do {
                try  realm.write {
                    realm.delete((itemArray?[indexPath.row])!)
                }
                
            } catch {
                print("error found while deleting \(error)")
            }
          
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemSegue" {
            
            let viewController = segue.destination as! AddAndUpdateViewController
            viewController.mode = "add"
            viewController.delegate = self
            
        } else if segue.identifier == "editItemSegue" {
            
            let viewController = segue.destination as! AddAndUpdateViewController
            viewController.mode = "edit"
            viewController.delegate = self
            
            if let cell = sender as? UITableViewCell {
                guard let indexPath = tableView.indexPath(for: cell) else {fatalError()}
                viewController.item = itemArray?[indexPath.row]
            } else {
                fatalError()
            }
        }
        
    }
    
    
    //MARK: AddAndUpdateViewController Delegate methods
    func didFinishAdding(_ item: Item, by tableViewController: UITableViewController) {
        let rowNumberToInsert = itemArray?.count
        
//        itemArray.append(item)
        do {
            try  realm.write {
                realm.add((item))
            }
            
        } catch {
            print("error found while adding \(error)")
        }
        
        let indexPath = IndexPath(row: rowNumberToInsert!, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
        
    }
    
    func didFinishEditing(_ item: Item, by tableViewController: UITableViewController) {

        if let rowNumberEditingAt = itemArray?.index(of: item) {

            let indexPath = IndexPath(row: rowNumberEditingAt, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        } else {
            print("Not Found thats why it is happening")
            fatalError()
        }
         navigationController?.popViewController(animated: true)
    }
    
    func didCancelAddingOrEditing(by tableViewController: UITableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- data manupulation methods
    
    func loadItems(){
        itemArray = realm.objects(Item.self)
        }
    
    func loadItems(by searchQuery: String){
        itemArray = realm.objects(Item.self).filter("content CONTAINS[cd] %@", searchQuery)
        tableView.reloadData()
    }
  
}



extension ItemViewController: UISearchBarDelegate {
    
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchQuery = searchBar.text {
            loadItems(by: searchQuery)

        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let text = searchBar.text {
            
            if text.count == 0 {
               DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                    self.loadItems()
                    self.tableView.reloadData()
                }
           
            } else {
                loadItems(by: text)
            }
            
        }
        
       
    }
    
}
