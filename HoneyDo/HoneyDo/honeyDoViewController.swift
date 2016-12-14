//
//  ViewController.swift
//  HoneyDo
//
//  Created by Rigel Preston on 10/25/16.
//  Copyright © 2016 Rigel Preston. All rights reserved.
//

import UIKit

class honeyDoViewController: UITableViewController, ItemDetailViewControllerDelegate {
    var items: [HoneydolistItem]  // <- declares that items of array will hold HoneydolistItems objects but doesn't give them value
    var checklist: HoneyDoCategories!
    
    required init?(coder aDecoder: NSCoder) {
        
        items = [HoneydolistItem]() // <- instantiates (to represent 'an abstraction' by a concrete instance) the array. Has no HoneydolistItem objects yet.
        super.init(coder: aDecoder)
        loadHoneydolistItems()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
     // Both #ofrows and cellforRow take two parameters and returns a value to the caller. These are Data Sources, the link between you data and the tableview. Once it is hooked up to a data source – your view controller – the table view sends a “numberOfRowsInSection” message to find out how many rows there are. And when the table view needs to draw a particular row on the screen it sends the “cellForRowAt” message to ask the data source for a cell.
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HoneydolistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)  // this method reads "Configure the checkmark 'for' this cell 'with' this item"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveHoneydolistItems()
    }
    
    /*override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }*/
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row) // this function has the button basically built into it. No need to add the button
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveHoneydolistItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
            
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: HoneydolistItem) {
        let label = cell.viewWithTag(1776) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: HoneydolistItem) { // sets the honeydo list's item on the cell's label
        let label = cell.viewWithTag(1775) as! UILabel // Doing this makes it a tag and bypasses the need of an @IBOutlet. If you connected the label to an outlet, that outlet could only refer to the label from one of these cells, not all of them.
        label.text = item.text
    }
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: HoneydolistItem) {
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
                
            }
        }
        
        dismiss(animated: true, completion: nil)
        saveHoneydolistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: HoneydolistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
        saveHoneydolistItems()
    }

    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveHoneydolistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "HoneydolistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadHoneydolistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "HoneydolistItems") as! [HoneydolistItem]
            
            unarchiver.finishDecoding()
        }
    }
    
}

