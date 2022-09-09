//
//  CameraView.swift
//  Printeroo
//
//  Created by Admin on 9/9/22.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @State var isShowingOrderSelection: Bool = false
    
    @StateObject var camera = CameraModel()
    
    @StateObject var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera).ignoresSafeArea(.all, edges: .all)
            
            VStack {
                HStack {
                    if camera.isTaken {
                        Button(action: camera.reTake, label: {
                            Image(systemName: "x.circle")
                                .foregroundColor(.black)
                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                    }
                    
                    Button(action: camera.switchCamera, label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .foregroundColor(.black)
                            .padding()
                            .background(.white)
                            .clipShape(Circle())
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
                }
                Spacer()
                
                HStack {
                    if camera.isTaken {
                        Button(action: {
                            if !camera.isSaved {
                                camera.savePic()
                            }
                        }, label: {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.black)
                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        
                        Button(action: {
                            camera.continueWithPic()
                            viewModel.image = camera.selectedImage
                            self.isShowingOrderSelection.toggle()
                        }, label: {
                            Text("Continue →")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(.white)
                                .clipShape(Capsule())
                        })
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 30)
                    }
                    else {
                        HStack {
                            Button(action: camera.takePic, label: {
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 40, height: 40)
                                    Circle()
                                        .stroke(.white, lineWidth: 2)
                                        .frame(width: 50, height: 50)
                                }
                            })
                            .padding(.trailing, 20)
                            
                            Button(action: {
                                viewModel.image = UIImage()
                                viewModel.showPicker.toggle()
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .fill(.white)
                                        .frame(width: 12, height: 30)
                                    Rectangle()
                                        .stroke(.white, lineWidth: 2)
                                        .frame(width: 20, height: 40)
                                }
                            })
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 45)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showPicker, onDismiss: {
            if viewModel.image != UIImage() {
                self.isShowingOrderSelection.toggle()
            }
        }) {
            ImagePicker(sourceType: viewModel.source == "library" ? .photoLibrary : .camera, selectedImage: $viewModel.image)
        }
        .fullScreenCover(isPresented: $isShowingOrderSelection) {
            OrderSelectionView(isShowingOrderSelection: $isShowingOrderSelection, selectedImage: $viewModel.image)
        }
        .onAppear(perform: {
            camera.Check()
        })
    }
}


class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    //
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    // photo output
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    
    @Published var selectedImage = UIImage()
    
    func Check() {
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
                    if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .front) {
                        let input = try AVCaptureDeviceInput(device: device)
                        
                        if self.session.canAddInput(input) {
                            self.session.addInput(input)
                        }
                        
                        if self.session.canAddOutput(self.output) {
                            self.session.addOutput(self.output)
                        }
                        
                        self.session.commitConfiguration()
                    }
                    else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
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
                    if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                        let input = try AVCaptureDeviceInput(device: device)
                        
                        if self.session.canAddInput(input) {
                            self.session.addInput(input)
                        }
                        
                        if self.session.canAddOutput(self.output) {
                            self.session.addOutput(self.output)
                        }
                        
                        self.session.commitConfiguration()
                    }
                    else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
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
            
            // TODO: fix code is wack with double if
            
            if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                let input = try AVCaptureDeviceInput(device: device)
                
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }
                
                if self.session.canAddOutput(self.output) {
                    self.session.addOutput(self.output)
                }
                
                self.session.commitConfiguration()
            }
            else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
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
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
                    self.session.stopRunning()
                }
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


struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        camera.preview.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}
