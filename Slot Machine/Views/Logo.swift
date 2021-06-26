//
//  Logo.swift
//  Slot Machine
//
//  Created by Manoel Filho on 24/06/21.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        Image("gfx-slot-machine")
            .resizable()
            .scaledToFit()
            .frame(
                minWidth: 256, idealWidth: 300, maxWidth: 320,
                minHeight: 112, idealHeight: 130, maxHeight: 140,
                alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/
            )
            .padding(.horizontal)
            .layoutPriority(1)
            .modifier(ShadowModifier())
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
