//
//  CoreDataPhotosTableViewController.swift
//  CoreDataPhotos
//
//  Created by Brady Webb on 10/25/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//

import UIKit

class CoreDataPhotosTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let dateFormatter = DateFormatter()
    let newTextDateFormatter = DateFormatter()
    let imagePickerController = UIImagePickerController()
    
    var text: Text?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.layer.borderWidth = 1.0
        bodyTextView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        bodyTextView.layer.cornerRadius = 6.0
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        newTextDateFormatter.dateStyle = .medium
        
        if let text = text {
            titleTextField.text = text.title
            bodyTextView.text = text.body
            if let addDate = text.addDate {
                dateLabel.text = dateFormatter.string(from: addDate)
            }
            image = text.image
            imageView.image = image
        } else {
            titleTextField.text = ""
            bodyTextView.text = ""
            dateLabel.text = newTextDateFormatter.string(from: Date(timeIntervalSinceNow: 0))
            imageView.image = nil
        }
    }

    @IBAction func selectImage(_ sender: Any) {
        selectImageSource()
    }

    func selectImageSource() {
        let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (alertAction) in
            self.takePhotoUsingCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alertAction) in
            self.selectPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func takePhotoUsingCamera() {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            alertNotifyUser(message: "No camera.")
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func selectPhotoFromLibrary() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            imagePickerController.dismiss(animated: true, completion: nil)
        }
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        image = selectedImage
        imageView.image = image
        if let text = text {
            text.image = selectedImage
        }
    }
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            alertNotifyUser(message: "Enter a title.")
            return
        }
        if let text = text {
            do {
                let managedContext = text.managedObjectContext
                try managedContext?.save()
            } catch {
                alertNotifyUser(message: "Can't save.")
            }
            
        } else {
            alertNotifyUser(message: "Can't create.")
        }
        navigationController?.popViewController(animated: true)
    }
}
