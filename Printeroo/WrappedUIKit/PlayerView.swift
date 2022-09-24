//
//  PlayerView.swift
//  Printeroo
//
//  Created by Admin on 9/24/22.
//

import Foundation
import SwiftUI

struct PlayerView: UIViewRepresentable {
    
    private var videoName: String = ""
    
    init(videoName: String) {
        self.videoName = videoName
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    
    func makeUIView(context: Context) -> UIView {
        let videoPlayer = LoopingPlayer(frame: .zero)
        videoPlayer.setupVideo(videoName: self.videoName)
        return videoPlayer
    }
}
