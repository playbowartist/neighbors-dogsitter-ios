//
//  AsyncImage.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 10/25/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//
import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    let image: UIImage?
    let placeholder: Placeholder

    init(image: UIImage?, @ViewBuilder placeholder: () -> Placeholder) {
        self.image = image
        self.placeholder = placeholder()
    }

    var body: some View {
        Group {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                placeholder
            }
        }
    }
}
