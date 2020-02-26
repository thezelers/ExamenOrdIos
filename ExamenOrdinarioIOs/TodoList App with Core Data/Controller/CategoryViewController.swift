//
//
//  OrdinarioExamenIos
//
//  Created by Carlos Rey González on 26/2/20.
//  Copyright © 2020 Carlos Rey González. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController { 
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
        
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            let category = categories[indexPath.row]
            categories.remove(at: indexPath.row)
            context.delete(category)
            
            do {
                try context.save()
            } catch {
                print("Error deleting category with \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)  //includes updating UI so reloading is not necessary
        }
    }

    
    
    //MARK: Data Manipulation Methods
    
    func saveCategories(){
        
        do{
            try context.save()
        }catch {
            print("Error saving category with \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    func loadCategories(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addAction(action)
        
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a New Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
        
}
    


