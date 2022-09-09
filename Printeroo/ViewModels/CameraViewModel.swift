//
//  PrelogViewModel.swift
//  Printeroo
//
//  Created by Admin on 9/8/22.
//

import Foundation
import SwiftUI
import AVFoundation

final class CameraViewModel:  NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {

    @Published var showPicker = false
    @Published var source = "library"
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    @Published var selectedImage = UIImage()
    
    
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func switchCamera() {
        
        guard let currentCameraInput: AVCaptureInput = self.session.inputs.first else {
            return
        }
        
        self.session.beginConfiguration()
        self.session.removeInput(currentCameraInput)
        
        do {
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if input.device.position == .back {
                    if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .front) ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front){
                        let input = try AVCaptureDeviceInput(device: device)
                        
                        if self.session.canAddInput(input) {
                            self.session.addInput(input)
                        }
                        
                        if self.session.canAddOutput(self.output) {
                            self.session.addOutput(self.output)
                        }
                        
                        self.session.commitConfiguration()
                    }
                    else {
                        fatalError("Missing expected back camera")
                    }
                }
                else {
                    if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                        let input = try AVCaptureDeviceInput(device: device)
                        
                        if self.session.canAddInput(input) {
                            self.session.addInput(input)
                        }
                        
                        if self.session.canAddOutput(self.output) {
                            self.session.addOutput(self.output)
                        }
                        
                        self.session.commitConfiguration()
                    }
                    else {
                        fatalError("Missing expected back camera")
                    }
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func setUp() {
        do {
            self.session.beginConfiguration()
            
            if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)  {
                
                let input = try AVCaptureDeviceInput(device: device)
                
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }
                
                if self.session.canAddOutput(self.output) {
                    self.session.addOutput(self.output)
                }
                
                self.session.commitConfiguration()
            }
            else {
                fatalError("Missing expected back camera")
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            
            DispatchQueue.main.async {
                self.session.stopRunning()
            }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
                self.isSaved = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if error != nil {
            return
        }
        
        print("picture taken")
        
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        self.picData = imageData
    }
    
    func savePic() {
        let image = UIImage(data: self.picData)!
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.selectedImage = image
        self.isSaved = true
        
        print("saved successfully...")
    }
    
    func continueWithPic() {
        let image = UIImage(data: self.picData)!
        
        self.selectedImage = image
    }
}

