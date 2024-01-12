//
//  OverallCalendarView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 9/21/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct OverallCalendarView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Current Bookings")
                    .font(.custom("AppleSDGothicNeo-SemiBold", size: 28.0))
                Spacer()
            }
            .padding(8.0)
            
            CalendarSwiftUIView()
        }
    }
}

struct OverallCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        OverallCalendarView()
    }
}
