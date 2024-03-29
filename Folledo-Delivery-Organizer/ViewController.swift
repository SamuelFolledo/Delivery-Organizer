//
//  ViewController.swift
//  Folledo-Delivery-Organizer
//
//  Created by Macbook Pro 15 on 10/19/19.
//  Copyright © 2019 SamuelFolledo. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    
    @IBOutlet weak var shippingImageView: UIImageView!
    
    @IBOutlet weak var shippingTextView: UITextView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var frameSublayer = CALayer()
    var scannedText: String = "Detected text can be edited here." {
        didSet {
            shippingTextView.text = scannedText
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Notifications to slide the keyboard up
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        shippingImageView.layer.addSublayer(frameSublayer)
    }
    
// MARK: Touch handling to dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let evt = event, let tchs = evt.touches(for: view), tchs.count > 0 {
            shippingTextView.resignFirstResponder()
        }
    }
  
// MARK: Actions
    @IBAction func cameraButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentImagePickerController(withSourceType: .camera)
        } else {
            let alert = UIAlertController(title: "Camera Not Available", message: "A camera is not available. Please try picking an image from the image library instead.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func libraryButtonTapped(_ sender: Any) {
        presentImagePickerController(withSourceType: .photoLibrary)
    }
    
  
    @IBAction func shareButtonTapped(_ sender: Any) { //shows share activityVC
        let vc = UIActivityViewController(activityItems: [scannedText, shippingImageView.image!], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
  
// MARK: Keyboard slide up
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
  
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
// MARK: UIImagePickerController
    private func presentImagePickerController(withSourceType sourceType: UIImagePickerController.SourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        controller.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
        present(controller, animated: true, completion: nil)
    }
  
// MARK: UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            shippingImageView.contentMode = .scaleAspectFit
            shippingImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
