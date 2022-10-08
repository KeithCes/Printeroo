//
//  ImageEditor.swift
//  Printeroo
//
//  Created by Admin on 9/13/22.
//

import Foundation
import SwiftUI
import Mantis

struct ImageEditor: UIViewControllerRepresentable {
    
    typealias Coordinator = ImageEditorCoordinator
    @Binding var image: UIImage
    @Binding var isShowingEditor: Bool
    @Binding var selectedImage: UIImage
    @Binding var cropStyle: CropShapeType
 
    func makeCoordinator() -> Coordinator {
        return ImageEditorCoordinator(image: $image, isShowingEditor: $isShowingEditor)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageEditor>) -> Mantis.CropViewController {
        let editor = Mantis.cropViewController(image: selectedImage)
        editor.delegate = context.coordinator
        editor.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1)
        editor.config.cropShapeType = self.cropStyle
        return editor
    }
}

class ImageEditorCoordinator: NSObject, CropViewControllerDelegate {
    
    @Binding var image: UIImage
    @Binding var isShowingEditor: Bool
    
    init(image: Binding<UIImage>, isShowingEditor: Binding<Bool>) {
        self._image = image
        self._isShowingEditor = isShowingEditor
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
        
    }
    
    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
        
    }
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        self.image = cropped
        self.isShowingEditor = false
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.isShowingEditor = false
    }
}
