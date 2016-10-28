//
//  ViewController.swift
//  HoneyDo
//
//  Created by Rigel Preston on 10/25/16.
//  Copyright © 2016 Rigel Preston. All rights reserved.
//

import UIKit

class honeyDoViewController: UITableViewController, AddItemViewControllerDelegate {
    var items: [HoneydolistItem]  // <- declares that items of array will hold HoneydolistItems objects but doesn't give them value
    
    required init?(coder aDecoder: NSCoder) {
        
        items = [HoneydolistItem]() // <- instantiates (to represent 'an abstraction' by a concrete instance) the array. Has no HoneydolistItem objects yet.
        
        let row0item = HoneydolistItem() // <- instantiates a new HoneydolistItem object
        row0item.text = "Cut the grass" // <- gives value to the data items (.text and .checked)
        row0item.checked = false
        items.append(row0item) // <- adds the HoneydolistItem object to the array
        
        let row1item = HoneydolistItem()
        row1item.text = "Rake the yard"
        row1item.checked = true
        items.append(row1item)
        
        let row2item = HoneydolistItem()
        row2item.text = "Learn a new poem"
        row2item.checked = true
        items.append(row2item)
        
        let row3item = HoneydolistItem()
        row3item.text = "Read a story to the kids"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = HoneydolistItem()
        row4item.text = "Watch a movie"
        row4item.checked = true
        items.append(row4item)
        
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    /*override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }*/
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row) // this function has the button basically built into it. No need to add the button
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddItemViewController
            controller.delegate = self
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
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: HoneydolistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

