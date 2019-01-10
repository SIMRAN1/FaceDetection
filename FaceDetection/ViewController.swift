//
//  ViewController.swift
//  FaceDetection
//
//  Created by Apple on 07/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
      let imageView = UIImageView(image: UIImage(named: "face")!)
       var yellowView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
       guard let image = UIImage(named: "face") else {
            return
        }
 
        
        
        setupImageView(for: image)
    }
    
    
    func setupImageView(for image:UIImage) {
    
        guard let cgImage = image.cgImage else {
            return
        }
       
        imageView.image = nil
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let scaledHeight = (view.frame.width/image.size.width)*image.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        view.addSubview(imageView)
        self.activityIndicator.alpha = 1.0
        self.messageLabel.alpha = 1.0
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async {
            self.performVisionRequest(for: cgImage, with: scaledHeight)
        }
        
    }

    func performVisionRequest(for image: CGImage,with scaledHeight: CGFloat) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                print("Failed to detect Face",error)
                return
            }
            request.results?.forEach({ (result) in
                guard let faceObservation = result as? VNFaceObservation else {
                    return
                }
                
                DispatchQueue.main.async {
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let y = scaledHeight * (1-faceObservation.boundingBox.origin.y)-height
                    let faceRectangle = CGRect(x: x, y: y, width: width, height: height)
                    self.createfaceOutline(for: faceRectangle )
                }
               
                
            })
            
        }
        let imageRequestHandler = VNImageRequestHandler(cgImage: image, options: [:])
        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
        print("Failed to detect Face")
          return
        }
    }
    
    func createfaceOutline(for rectangle: CGRect) {
        
      
        yellowView.backgroundColor = .clear
        yellowView.layer.borderColor = UIColor.yellow.cgColor
        yellowView.layer.borderWidth = 3
        yellowView.layer.cornerRadius = 5
        yellowView.alpha = 0.0
        yellowView.frame = rectangle
        self.view.addSubview(yellowView)
        UIView.animate(withDuration: 0.3) {
            self.yellowView.alpha = 0.75
            self.activityIndicator.alpha = 0.0
            self.messageLabel.alpha = 0.0
        }
        self.activityIndicator.stopAnimating()
    }
    
    func removefaceOutline() {
         self.yellowView.alpha = 0
      
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        photoSourcePicker.addAction(takePhotoAction)
        photoSourcePicker.addAction(choosePhotoAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        photoSourcePicker.addAction(cancelAction)
        present(photoSourcePicker, animated: true, completion: nil)
    }
    
    func presentPhotoPicker(sourceType : UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }

    }
    

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("No Image Returned")
        }
        removefaceOutline()
        setupImageView(for: image)
    }
}


