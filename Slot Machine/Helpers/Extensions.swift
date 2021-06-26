//
//  Extensions.swift
//  Slot Machine
//
//  Created by Manoel Filho on 24/06/21.
//

import SwiftUI

extension Text {
    
    func scoreLabelStyle() -> Text {
        self
            .foregroundColor(Color.white)
            .font(.system(size: 10, weight: .bold, design: .rounded))
    }
    
    func scoreNumberStyle() -> Text {
        self
            .foregroundColor(.white)
            .font(.system(.title, design: .rounded))
            .fontWeight(.heavy)
    }
    
}
