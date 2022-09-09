//
//  CameraPreview.swift
//  Printeroo
//
//  Created by Admin on 9/9/22.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        viewModel.preview = AVCaptureVideoPreviewLayer(session: viewModel.session)
        viewModel.preview.frame = view.frame
        viewModel.preview.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(viewModel.preview)
        
        viewModel.session.startRunning()
        
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
