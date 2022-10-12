//
//  CanvasView.swift
//  Printeroo
//
//  Created by Admin on 10/12/22.
//

import Foundation
import PencilKit
import SwiftUI

struct CanvasView {
    @Binding var canvasView: PKCanvasView
    let onSaved: () -> Void

    @State var toolPicker = PKToolPicker()
}

extension CanvasView: UIViewRepresentable {
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.marker, color: .red, width: 10)
        canvasView.drawingPolicy = .anyInput
        canvasView.delegate = context.coordinator
        canvasView.becomeFirstResponder()
        self.canvasView.backgroundColor = UIColor.clear
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: $canvasView, onSaved: onSaved)
    }
}

class Coordinator: NSObject {
    var canvasView: Binding<PKCanvasView>
    let onSaved: () -> Void

    init(canvasView: Binding<PKCanvasView>, onSaved: @escaping () -> Void) {
        self.canvasView = canvasView
        self.onSaved = onSaved
    }
}

extension Coordinator: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if !canvasView.drawing.bounds.isEmpty {
            onSaved()
        }
    }
}
