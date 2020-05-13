//
//  CameraControlView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/3/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct CameraControlView: View {
    var body: some View {
        NavigationLink(destination: LiveVideoView()) {
            Text("View Camera")
        }
        .navigationBarTitle("Camera Control", displayMode: .inline)
    }
}

struct CameraControlView_Previews: PreviewProvider {
    static var previews: some View {
        CameraControlView()
    }
}
