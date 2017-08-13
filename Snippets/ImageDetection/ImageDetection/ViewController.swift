//
//  ViewController.swift
//  ImageDetection
//
//  Created by Clint Cabanero on 8/12/17.
//  Copyright © 2017 Clint Cabanero. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: - UIViewController Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        initializeCapture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Image Detection methods
    
    func initializeCapture() {
        
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        captureSession.addInput(captureDeviceInput)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoCapture"))
        captureSession.addOutput(dataOutput)
    }
    
    func initializeViews() {
        
        view.layer.zPosition = 0
        reportView.layer.zPosition = 1
        reportView.layer.cornerRadius = 5
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate methods
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = results.first else { return }
            let observation = firstObservation.identifier + " (confidence: " + String(round(100 * firstObservation.confidence)/100) + ")"
            
            // update UI
            DispatchQueue.main.async {
                self.label.text = observation
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

