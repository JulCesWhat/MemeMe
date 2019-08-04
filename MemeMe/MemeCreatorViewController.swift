//
//  ViewController.swift
//  MemeMe
//
//  Created by Julio Cesar Whatley on 7/30/19.
//  Copyright © 2019 Capi. All rights reserved.
//
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage?
    var memedImage: UIImage?
}

class MemeCreatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let memeMeTextFieldDelegate = MemeMeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topField.delegate = memeMeTextFieldDelegate
        self.bottomField.delegate = memeMeTextFieldDelegate
        self.topField.attributedPlaceholder = NSAttributedString(string: "TOP",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.bottomField.attributedPlaceholder = NSAttributedString(string: "BOTTOM",
                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.shareButton.isEnabled = false
//        self.cancelButton.isEnabled = false
        self.setupTextFieldStyle(toTextField: self.topField)
        self.setupTextFieldStyle(toTextField: self.bottomField)
        
        self.view.addSubview(imagePickerView)
        self.view.sendSubviewToBack(imagePickerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func setupTextFieldStyle(toTextField textField: UITextField) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -2.0
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }

    @IBAction func pickAnImageFromAlbun(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamara(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = UIView.ContentMode.scaleAspectFit
            
            self.shareButton.isEnabled = true
            self.cancelButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let meme = generateMemedImage()
//        self.save(meme: meme)
//        self.save(meme: meme)
//        self.save(meme: meme)
//        self.save(meme: meme)
//        self.save(meme: meme)
        
        let controller = UIActivityViewController(activityItems: [meme], applicationActivities: nil)

        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if (completed) {
                self.save(meme: meme)
            }

            self.dismiss(animated: true, completion: nil)
        }

        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
//        self.shareButton.isEnabled = false
//        self.cancelButton.isEnabled = false
//        self.topField.text = ""
//        self.bottomField.text = ""
//        self.imagePickerView.image = nil
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if bottomField.isEditing {
                view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func save(meme: UIImage) -> Void {
        // Create the meme
        let newMeme = Meme(topText: topField.text!, bottomText: bottomField.text!, originalImage: imagePickerView.image!, memedImage: meme)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(newMeme)
        self.dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        setButtons(show: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        self.setButtons(show: false)
        
        return memedImage
    }
    
    func setButtons(show: Bool) {
        self.navigationController?.navigationBar.isHidden = show
        self.topToolBar.isHidden = show
        self.toolBar.isHidden = show
    }
}

