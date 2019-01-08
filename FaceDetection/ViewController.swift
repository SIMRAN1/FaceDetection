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
        guard let image = UIImage(named: "face") else {
            return
        }
        let imagView = UIImageView(image: image)
        imagView.contentMode = .scaleAspectFit
        let scaledHeight = (view.frame.width/image.size.width)*image.size.height
        imagView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        view.addSubview(imagView)
    }

    func performVisionRequest() {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                print("Failed to detect Face")
                return
            }
            request.results?.forEach({ (result) in
                guard let faceObservation = result as? VNFaceObservation else {
                    return
                }
                print(faceObservation.boundingBox)
            })
            
        }
    }

}

