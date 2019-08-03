//
//  MemeMeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Julio Cesar Whatley on 8/1/19.
//  Copyright © 2019 Capi. All rights reserved.
//

import Foundation
import UIKit

class MemeMeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
