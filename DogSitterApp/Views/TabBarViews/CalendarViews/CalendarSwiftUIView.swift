//
//  CalendarSwiftUIView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 9/8/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import HorizonCalendar

struct CalendarSwiftUIView: UIViewRepresentable {
    
    @EnvironmentObject var appState: AppState
    @ObservedObject var calendarVM = CalendarViewModel()
    
    func updateUIView(_ uiView: UIView, context: Context) {
            
        if let uiView = uiView as? CalendarView,
            let calendarViewContent = self.calendarVM.calendarViewContent {
            uiView.setContent(calendarViewContent)
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        
        guard let calendarViewContent = calendarVM.calendarViewContent else { return UIView() }
        let calendarView = CalendarView(initialContent: calendarViewContent)
        
        // Short delay needed so system can populate appState environmentObject with data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.calendarVM.firebaseUser = self.appState.firebaseUser
            self.calendarVM.fetchDataAndUpdateView(userData: self.appState.userData) {
                calendarView.setContent(self.calendarVM.calendarViewContent!)
            }
        }
        return calendarView
    }
}

