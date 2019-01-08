//
//  ViewController.swift
//  FaceDetection
//
//  Created by Apple on 07/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.startAnimating()
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
        imagView.layer.borderColor = UIColor.white.cgColor
        imagView.layer.borderWidth = 2
        view.addSubview(imagView)
    }


}

