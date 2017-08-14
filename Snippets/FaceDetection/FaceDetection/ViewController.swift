//
//  ViewController.swift
//  FaceDetection
//
//  Created by Clint Cabanero on 8/13/17.
//  Copyright © 2017 Clint Cabanero. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    // MARK: - ViewController Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeImagePicker()
        detectFacesInImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Vision
    
    func detectFacesInImage() {
        
        let faceRectangleRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaceRectangles)
        guard let image = imageView.image else { return }
        guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try imageRequestHandler.perform([faceRectangleRequest])
            } catch let reqErr {
                print("Failed to perform FaceRectanglesRequest: ", reqErr)
            }
        }
    }
    
    func handleFaceRectangles(request: VNRequest, error: Error?) {
        
        if let error = error {
            print("Failed to detect faces: " , error)
            return
        }
        
        // Draw each face observation rectangle
        guard var drawnImage = imageView.image else { return }
        if let foundFaces = request.results as? [VNFaceObservation] {
            for faceObservation in foundFaces {
                
                // Draw original image
                UIGraphicsBeginImageContextWithOptions(drawnImage.size, false, 1.0)
                drawnImage.draw(in: CGRect(x: 0, y: 0, width: drawnImage.size.width, height: drawnImage.size.height))
                
                // Get bounding box for face observation
                let rect = faceObservation.boundingBox
                let tf = CGAffineTransform.init(scaleX: 1, y: -1).translatedBy(x: 0, y: -drawnImage.size.height)
                let ts = CGAffineTransform.identity.scaledBy(x: drawnImage.size.width, y: drawnImage.size.height)
                let convertedRect = rect.applying(ts).applying(tf)
                
                // Draw face rect on image
                guard let graphicsContext = UIGraphicsGetCurrentContext() else { return }
                graphicsContext.setStrokeColor(UIColor.red.cgColor)
                graphicsContext.setLineWidth(0.01 * drawnImage.size.width)
                graphicsContext.stroke(convertedRect)
                
                // Get the new image
                guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return }
                UIGraphicsEndImageContext()
                drawnImage = result
            }
        }
        
        // Display the image with face rectangles on the Main/UI thread
        DispatchQueue.main.async {
            self.imageView.image = drawnImage
        }
    }
    
    // MARK: - Camera
    
    func initializeImagePicker() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    // Handle when a user taps on the camera icon
    @IBAction func handleCameraButtonTap(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    // After user chooses a photo, we present it then run Face Detection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage

        detectFacesInImage()
    }
}

