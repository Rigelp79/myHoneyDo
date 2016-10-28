//
//  AddHoneydoItem.swift
//  HoneyDo
//
//  Created by Rigel Preston on 10/27/16.
//  Copyright © 2016 Rigel Preston. All rights reserved.
//
import Foundation
import UIKit

protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) // this is for when pressing cancel
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: HoneydolistItem) // this is for when pressing save
}

class AddItemViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!

    weak var delegate: AddItemViewControllerDelegate?
    
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
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func save() {
        let item =  HoneydolistItem()
        item.text = textField.text!
        item.checked = false
        
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
    
}
