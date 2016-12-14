//
//  AddHoneydoItem.swift
//  HoneyDo
//
//  Created by Rigel Preston on 10/27/16.
//  Copyright © 2016 Rigel Preston. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) // this is for when pressing cancel
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: HoneydolistItem) // this is for when pressing save
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: HoneydolistItem)  // this changes the text on the existing item, and prevents a brand new to-do item with the new text getting added to the list
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: HoneydolistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit item"
            textField.text = item.text
            saveBarButton.isEnabled = true
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        saveBarButton.isEnabled = (newText.length > 0) //If newText.length is greater than 0, saveBarButton.isEnabled becomes true; otherwise it becomes false.
        return true
    }
    
    
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func save() {
        if let item = itemToEdit{
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item =  HoneydolistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
}
