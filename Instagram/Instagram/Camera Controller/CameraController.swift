//
//  CameraController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/17/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {
    
    //MARK: - Properties
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "right_arrow_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let output = AVCapturePhotoOutput()
    
    //MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        
        setupCaptureSession()
        setupHUD()
    }
    
    override var prefersStatusBarHidden: Bool { true }
    
    let customAnimationPresentor = CustomAnimationPresentor()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresentor
    }

    let customAnimationDismisser = CustomAnimationDismisser()
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
    //MARK: - Photo Capture Delegate
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageDate = photo.fileDataRepresentation() else { return }
        
        let previewImage = UIImage(data: imageDate)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }
    //MARK: - Action methods for selectors
    
    @objc func handleCapturePhoto() {
        
        let settings = AVCapturePhotoSettings()
        
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
    }

    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        view.addSubview(dismissButton)
           
        NSLayoutConstraint.activate([
            capturePhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                      
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
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
