//
//  ListViewController
//  SwiftDB
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 Antoine. All rights reserved.
//
import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let items = ["Pain", "Lait","Oeuf","Jus de fruit", "Cake","banane", "Jambon","jambon cru", "Pastèque", "Granola", "Fruit"]
    var items2 = [Item]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredItem = [Item]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createitems()
        
    }
    
    func createitems(){
        for item in items {
            let newElement = Item(name: item)
            items2.append(newElement)
            
        }
    }
    
    @IBAction func editAction(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        self.saveData(self.items2)
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "DoIt", message: "New Item", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default){(action) in
            
            let textField = alertController.textFields![0]
            
            if textField.text != ""{
                let item = Item(name: textField.text!)
                self.items2.append(item)
                self.saveData(self.items2)
                self.tableView.reloadData()
            }
        }
        alertController.addTextField{(textField) in
            textField.placeholder = "Name"
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Remove
            items2.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveData(self.items2)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = items2.remove(at: sourceIndexPath.row)
        
        items2.insert(sourceItem, at: destinationIndexPath.row)
    }
    
}



extension ListViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredItem.count
        }
        return items2.count
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredItem = items2.filter({( item : Item) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCellIdentifier")
        
        let item: Item
        if isFiltering() {
            item = filteredItem[indexPath.row]
        } else {
            item = items2[indexPath.row]
        }
        cell?.textLabel?.text = item.name
        cell?.accessoryType = item.checked ? .checkmark : .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        }else{
            cell?.accessoryType = .checkmark
        }
        
        let item = items2[indexPath.row % items2.count]
        item.checked = !item.checked
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func saveData(_ item: [Item]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(item)
        try? data?.write(to: getDocumentsDirectory())
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentsDirectory = paths[0]
        documentsDirectory.appendPathComponent("items.json", isDirectory: false)
        print(documentsDirectory)
        return documentsDirectory
    }
}
