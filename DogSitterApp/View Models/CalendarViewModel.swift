//
//  CalendarViewModel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 9/10/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import HorizonCalendar

class CalendarViewModel: ObservableObject {
    
    @Published var firebaseUser: User?
    @Published var appointmentList = [Appointment]()
    @Published var needsRefresh: Bool = false
    var calendarViewContent: CalendarViewContent?
    
    init() {
        self.calendarViewContent = self.makeContent(appointmentList: self.appointmentList)
    }
    
    func fetchDataAndUpdateView(userData: UserData?, completionHandler: @escaping () -> Void) {
        // Send userData to getAcuityAppointments, and sort out whether customer or dogsitter there
        guard let userData = userData else { return }
        
        // Test hard-coded appointmentList
        let testAppointment = Appointment(email: "muddalum@gmail.com", date: "January 3, 2024", datetime: "2023-12-25T10:15:00-0700", calendarID: 123)
        self.appointmentList.append(testAppointment)
        self.calendarViewContent = self.makeContent(appointmentList: appointmentList)
        completionHandler()
        
        //        getAcuityAppointments(userData: userData, optionalNetworkingAPI: nil) { appointmentList in
        //            DispatchQueue.main.async {
        //                self.appointmentList = appointmentList
        //                self.calendarViewContent = self.makeContent(appointmentList: self.appointmentList)
        //                completionHandler()
        //            }
        //        }
    }
    
    func makeContent(appointmentList: [Appointment]) -> CalendarViewContent {
        
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calculateStartingDate()
        let endDate = calculateEndingDate()
        let appointmentDates = appointmentsToDates(appointmentList: appointmentList)
        let verticalMonthsLayoutOptions = VerticalMonthsLayoutOptions(pinDaysOfWeekToTop: true, alwaysShowCompleteBoundaryMonths: true)
        
        return CalendarViewContent(calendar: calendar,
                                   visibleDateRange: startDate...endDate,
                                   monthsLayout: .vertical(options: verticalMonthsLayoutOptions))
        .interMonthSpacing(30.0)
        .verticalDayMargin(8.0)
        .horizontalDayMargin(8.0)
        .monthDayInsets(.init(top: 15.0, leading: 0.0, bottom: 15.0, trailing: 0.0))
        .daysOfTheWeekRowSeparator(options: .systemStyleSeparator)
        .monthHeaderItemProvider { month in
            
            let invariantViewProperties = MonthHeaderLabel.InvariantViewProperties(
                font: UIFont.init(name: "HelveticaNeue-Medium", size: 18.0)!,
                textColor: .label,
                backgroundColor: .systemBackground)
            
            return MonthHeaderLabel.calendarItemModel(invariantViewProperties:
                    .init(font: UIFont.init(name: "HelveticaNeue-Medium", size: 18.0)!,
                          textColor: .label,
                          backgroundColor: .systemBackground),
                                                      content: .init(month: month))
        }
        
        .dayItemProvider { day in
            
            var invariantViewProperties = DayLabel.InvariantViewProperties(
                font: UIFont.init(name: "HelveticaNeue-Medium", size: 14.0)!,
                textColor: .label,
                backgroundColor: .systemBackground)
            
            // Change day label if day in question is contained in appointmentDates array
            if appointmentDates.contains(where: {
                $0.get(.year) == day.month.year &&
                $0.get(.month) == day.month.month &&
                $0.get(.day) == day.day
            }) {
                invariantViewProperties.textColor = .label
                invariantViewProperties.backgroundColor = .systemTeal
            }
            
            return DayLabel.calendarItemModel(invariantViewProperties: invariantViewProperties, content: .init(day: day))
        }
    }
    
    
    // TODO: Filter getAcuityAppointments - by email if Customer; by calendarID if DogSitter
    func getAcuityAppointments(userData: UserData, optionalNetworkingAPI: NetworkingAPIProtocol?, completionHandler: @escaping (([Appointment]) -> Void)) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        let minDate = dateFormatter.string(from: calculateStartingDate())
        let maxDate = dateFormatter.string(from: calculateEndingDate())
        
        // Provide networkingAPI if none passed in as a parameter
        var networkingAPI: NetworkingAPIProtocol {
            if let networkingAPI = optionalNetworkingAPI { return networkingAPI }
            else { return NetworkingAPIFactory.networkingAPI() }
        }
        
        guard let userType = userData.userType else { return }
        // If customer, simply get appointments and filter by customer's email
        if userType == .customer,
           let customerEmail = userData.email {
            networkingAPI.getAcuityAppointments(minDate: minDate, maxDate: maxDate, email: customerEmail, phoneNumber: nil, calendarID: nil) { (appointmentList) in
                
                guard let appointmentList = appointmentList else { return }
                DispatchQueue.main.async {
                    self.appointmentList = appointmentList
                    completionHandler(appointmentList)
                }
            }
            // If dogsitter, need to get calendarList from Acuity, fish out matching calendarID, and get appointments by calendarID
        } else if userType == .dogsitter,
                  let dogsitterEmail = userData.email {
            networkingAPI.getAcuityCalendars { calendarList in
                print("calendarList for dogSitter: \(calendarList)")
                print("dogSitterEmail: \(dogsitterEmail)")
                guard let calendarList = calendarList else { return }
                let matchingCalendarList = calendarList.filter { $0.email == dogsitterEmail }
                guard let matchingCalendar = matchingCalendarList.first else { return }
                let dogsitterCalendarID = matchingCalendar.id
                
                networkingAPI.getAcuityAppointments(minDate: minDate, maxDate: maxDate, email: nil, phoneNumber: nil, calendarID: dogsitterCalendarID) { (appointmentList) in
                    
                    guard let appointmentList = appointmentList else { return }
                    DispatchQueue.main.async {
                        self.appointmentList = appointmentList
                        completionHandler(appointmentList)
                    }
                }
            }
        }
    }
    
    func calculateStartingDate() -> Date {
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        let oneMonthAgo = calendar.date(byAdding: .month,
                                        value: -1,
                                        to: today)
        let startingDate = calendar.nextDate(after: oneMonthAgo!, matching: DateComponents(day: 1), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)
        return startingDate!
    }
    
    func calculateEndingDate() -> Date {
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        let sixMonthsLater = calendar.date(byAdding: .month,
                                           value: 6,
                                           to: today)
        let endingDate = sixMonthsLater!.endOfMonth
        return endingDate
    }
    
    // Convert [Appointment] to [Date]
    func appointmentsToDates(appointmentList: [Appointment]) -> [Date] {
        var appointmentDates = [Date]()
        let iso8601dateFormatter = ISO8601DateFormatter()
        for appointment in appointmentList {
            if let appointmentDate = iso8601dateFormatter.date(from: appointment.datetime) {
                appointmentDates.append(appointmentDate)
            }
        }
        return appointmentDates
    }
}

