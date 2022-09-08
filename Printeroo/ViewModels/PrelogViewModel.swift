//
//  PrelogViewModel.swift
//  Printeroo
//
//  Created by Admin on 9/8/22.
//

import Foundation
import SwiftUI

final class PrelogViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var showPicker = false
    @Published var source = "library"
}
