//
//  CameraController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/17/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let dismisskButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "right_arrow_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupHUD()
    }
    
    @objc func handleCapturePhoto() {
        
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        view.addSubview(dismisskButton)
           
        NSLayoutConstraint.activate([
            capturePhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                      
            dismisskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            dismisskButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ])
    }
    
    fileprivate func setupCaptureSession() {
        let captureSesseion = AVCaptureSession()
        
        //1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSesseion.canAddInput(input) {
                captureSesseion.addInput(input)
            }
        } catch let error {
            print("Could no setup camera inputs", error)
        }
        
        //2. setup outputs
        let output = AVCapturePhotoOutput()
        if captureSesseion.canAddOutput(output) {
            captureSesseion.addOutput(output)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSesseion)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSesseion.startRunning()
        
    }
}
