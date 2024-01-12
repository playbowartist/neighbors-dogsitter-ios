//
//  MonthHeaderLabel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 9/21/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation
import HorizonCalendar

struct MonthHeaderLabel: CalendarItemViewRepresentable {
    
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        var font: UIFont
        var textColor: UIColor
        var backgroundColor: UIColor
    }
    
    /// Properties that will vary depending on the particular date being displayed.
    struct Content: Equatable {
        let month: MonthComponents
    }
    
    static func makeView(withInvariantViewProperties invariantViewProperties: InvariantViewProperties) -> UILabel {
        
        let label = UILabel()
        
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        label.textAlignment = .left
        label.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15.0, leading: 0, bottom: 0, trailing: 0)
        
        return label
    }
    
    static func setContent(_ content: Content, on view: UILabel) {
        let monthSymbol = DateFormatter().monthSymbols[content.month.month - 1]
        view.text = "\(monthSymbol) \(content.month.year)"
    }
}

