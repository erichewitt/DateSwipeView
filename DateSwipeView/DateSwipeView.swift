//
//  DateSwipeView.swift
//  DateSwipeView
//
//  Created by Eric Hewitt on 1/19/22.
//

import SwiftUI

/**
 * @struct DateSwipeView
 * Swipe through views based on calendar days up to today. This will dynamically load dates as users swipes back in time, 7 at a time, to minimize
 * memory foot print.
 */
struct DateSwipeView<CardContent : View> : View {
    @Binding var current: Date      // initial date to view
    var earliestDate: Date          // earliest date
    var preloadDays: Int = 7        // when going backward, preload count days
    let cardContent: (Date, Int) -> CardContent
    
    @State private var offset: CGFloat = 0
    @State private var index: Int = 0
    @State private var dates: [Date] = []
    @State var start: Date = Date()
    
    let spacing: CGFloat = 8
    let calendar = Calendar.current
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal], showsIndicators: true) {
                HStack {
                    ForEach(dates, id:\.self) { day in
                        cardContent(day, index)
                    }
                    .frame(width: geometry.size.width)
                }
            }
            .content.offset(x: offset)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offset = value.translation.width - (geometry.size.width + spacing) * CGFloat(index)
                    })
                    .onEnded({ value in
                        if -value.predictedEndTranslation.width > geometry.size.width / 4, index < dates.endIndex-1 {
                            current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
                        }
                        if value.predictedEndTranslation.width > geometry.size.width / 4, index > dates.startIndex {
                            current = Calendar.current.date(byAdding: .day, value: -1, to: current)!
                        } else {
                            withAnimation { offset = -(geometry.size.width + spacing) * CGFloat(index) }
                        }
                    })
            )
            .onAppear {
                index = loadDates(current: current, end: Date())
                offset = -(geometry.size.width + spacing) * CGFloat(index)
            }
            .onChange(of: current, perform: { date in
                let diff = calendar.daysBetween(date, and: Date())
                index = dates.endIndex - 1 - diff
                
                withAnimation { offset = -(geometry.size.width + spacing) * CGFloat(index) }
                
                if index <= 1 {
                    index = loadDates(current: date, end: Date())
                    offset = -(geometry.size.width + spacing) * CGFloat(index)
                }
            })
        }
    }
    
    /**
     * @method: loadDates
     * Load dates in the range from current minus 'preloadDays' days to end.  Return the index in the array where current is pointing.
     *
     * @parameter: cur
     * Current date to load around.
     * @parameter: end
     * End of range of dates to load
     */
    private func loadDates(current cur:Date, end:Date) -> Int {
        var start = calendar.date(byAdding: .day, value: -preloadDays, to: cur)!
        start = max(start, earliestDate)
        
        dates.removeAll()
        let range = calendar.dateRange(startDate: start, endDate: Date(), stepUnits: .day, stepValue: 1)
        for day in range {
            dates.append(day)
        }
        return calendar.daysBetween(start, and: cur)
    }
}

