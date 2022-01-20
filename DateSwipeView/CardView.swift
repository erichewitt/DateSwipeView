//
//  CardView.swift
//  DateSwipeView
//
//  Created by Eric Hewitt on 1/19/22.
//

import SwiftUI

struct CardView: View {
    var date: Date
    var index: Int
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(height: 300, alignment: .center)
                    .foregroundColor(.gray)
                    .padding()
                VStack {
                    Text("\(date.toDayString())").bold()
                    Text("current index:\(index)")
                }
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    @State static var date: Date = Date()
    @State static var index: Int = 0
    static var previews: some View {
        CardView(date: date, index: index)
    }
}
