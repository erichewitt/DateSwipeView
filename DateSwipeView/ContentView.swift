//
//  ContentView.swift
//  DateSwipeViewApp
//
//  Created by Eric Hewitt on 11/17/21.
//

import SwiftUI

struct ContentView: View {
    @State var current = Date()
    var calendar = Calendar.current

    let earliest = Calendar.current.date(byAdding: .month, value: -3, to: Date())!

    var body: some View {
        VStack {
            HStack {
                Button(action: { prev() }) { Image.init(systemName: "chevron.left") }
                .disabled(isMin())
                Spacer()
                DatePicker("", selection: $current,
                           in: earliest...Date(),
                           displayedComponents: .date)
                           .labelsHidden()
                           .id(current)     // Hack to fix date displaying oddly on certain dates

                Spacer()
                Button(action: { next() }) { Image.init(systemName: "chevron.right") }
                .disabled(isMax())
            }
            .padding()
            DateSwipeView(current:$current, earliestDate: earliest) { date, index in
                CardView(date: date, index: index)
            }
        }
    }
    
    func next() {
        current = min(Date(), Calendar.current.date(byAdding: .day, value: 1, to: current)!)
    }
    func prev() {
        current = max(earliest, Calendar.current.date(byAdding: .day, value: -1, to: current)!)
    }
    
    private func isMax() -> Bool {
        return calendar.daysBetween(current, and: Date()) == 0
    }
    private func isMin() -> Bool {
        return calendar.daysBetween(current, and: earliest) == 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}

