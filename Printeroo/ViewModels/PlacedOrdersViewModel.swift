//
//  PlacedOrdersViewModel.swift
//  Printeroo
//
//  Created by Admin on 9/16/22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

final class PlacedOrdersViewModel: ObservableObject {
    
    @Published var allOrders: [OrderInfo] = []

    
    func getOrders() {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference()
        
        ref.child("orders").queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshotDict = snapshot.value as? [String: Any] else {
                return
            }
            
            for orderDict in snapshotDict {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: orderDict.value, options: [])
                    let order = try JSONDecoder().decode(OrderInfo.self, from: jsonData)
                    
                    self.allOrders.append(order)
                }
                catch let error {
                    print(error)
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY"
            
            self.allOrders = self.allOrders.sorted(by: { dateFormatter.date(from: $0.dateOfCreation)?.compare(dateFormatter.date(from: $1.dateOfCreation)!) == .orderedDescending })
        })
    }
}
