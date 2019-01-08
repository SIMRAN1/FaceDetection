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
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        setupImageView()
    }
    func setupImageView() {
        guard let image = UIImage(named: "faces") else {
            return
        }
        guard let cgImage = image.cgImage else {
            return
        }
        let imagView = UIImageView(image: image)
        imagView.contentMode = .scaleAspectFit
        let scaledHeight = (view.frame.width/image.size.width)*image.size.height
        imagView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        view.addSubview(imagView)
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
        let yellowView = UIView()
        yellowView.backgroundColor = .clear
        yellowView.layer.borderColor = UIColor.yellow.cgColor
        yellowView.layer.borderWidth = 3
        yellowView.layer.cornerRadius = 5
        yellowView.alpha = 0.0
        yellowView.frame = rectangle
        self.view.addSubview(yellowView)
        UIView.animate(withDuration: 0.3) {
            yellowView.alpha = 0.75
            self.activityIndicator.alpha = 0.0
            self.messageLabel.alpha = 0.0
        }
        self.activityIndicator.stopAnimating()
    }

}

