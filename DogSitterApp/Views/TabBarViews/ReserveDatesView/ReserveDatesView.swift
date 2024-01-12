//
//  ReserveDatesView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 12/27/23.
//  Copyright © 2023 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct ReserveDatesView: View {
    @EnvironmentObject var appState: AppState
    let authAPI = AuthenticationAPI()
    
    var body: some View {
        
        Button(action: {
            print("Reserve selected")
        }) {
            Text("Reserve")
        }
    }
}

#Preview {
    ReserveDatesView()
}
