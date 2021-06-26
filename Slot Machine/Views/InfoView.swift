//
//  InfoView.swift
//  Slot Machine
//
//  Created by Manoel Filho on 24/06/21.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Logo()
            Spacer()
            
            Form{
                Section(header: Text("Sobre o aplicativo")){
                    FormRowView(firsItem: "Aplicativo", secondItem: "Slot Machine")
                    FormRowView(firsItem: "Plataformas", secondItem: "iPad, iPhone, Mac")
                    FormRowView(firsItem: "Desenvolvedor", secondItem: "@manoelfilho")
                    FormRowView(firsItem: "Designer", secondItem: "Robert Petras")
                    FormRowView(firsItem: "Music", secondItem: "Dan Lebovitz")
                    FormRowView(firsItem: "Copyright", secondItem: "© 2020 All rights reserved")
                    FormRowView(firsItem: "Version", secondItem: "1.0.0")
                }
            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top, 40)
        .overlay(
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark.circle").font(.title)
            }
            .padding(.top, 15)
            .padding(.trailing, 10),
            alignment: .topTrailing
        )
    }
}

struct FormRowView: View {
    var firsItem: String
    var secondItem: String
    var body: some View {
        HStack {
            Text(firsItem).foregroundColor(.gray)
            Spacer()
            Text(secondItem)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
