//
//  SelectedImageViewModel.swift
//  Printeroo
//
//  Created by Admin on 10/6/22.
//

import Foundation
import SwiftUI

final class SelectedImageViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    func checkIfCreateInfoValid() {
        
    }
}
