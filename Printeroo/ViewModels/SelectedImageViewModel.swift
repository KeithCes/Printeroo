//
//  SelectedImageViewModel.swift
//  Printeroo
//
//  Created by Admin on 10/6/22.
//

import Foundation
import SwiftUI

final class SelectedImageViewModel: ObservableObject {
    
    @Published var isShowingOrderSelection: Bool = false
    @Published var selectedImage: UIImage = UIImage()
    @Published var isFromCameraRoll: Bool = false
}
