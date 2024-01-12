//
//  SystemImage.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 11/1/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct SystemImage: View {
    
    private var imageName: String
    init(name: String) {
        self.imageName = name
    }
    
    var body: some View {
        Image(systemName: imageName)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.primary)
    }
}

struct SystemImage_Previews: PreviewProvider {
    static var previews: some View {
        SystemImage(name: "eye.slash")
    }
}
