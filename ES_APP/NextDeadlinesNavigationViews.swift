
import Foundation
import SwiftUI

struct NextDeadlinesNavigationView: View {
    @EnvironmentObject var deadlineViewModel: DeadlineViewModel
    let outDateFormatter: DateFormatter = {
        let dfm = DateFormatter()
        dfm.dateFormat = "dd.MM.yyyy"
        dfm.locale = Locale(identifier: "de_DE")
        return dfm
    }()
    
    var body: some View {
        if deadlineViewModel.getUpcomingDeadlinesLength() != 0 {
            let nextFiveDeadlines = deadlineViewModel.deadlines[0...deadlineViewModel.getUpcomingDeadlinesLength()]
            VStack(alignment: .leading, spacing: 10) {
                    ForEach(nextFiveDeadlines, id: \.self) { deadline in
                        NavigationLink(destination: DeadlineDetailView(deadline.id).environmentObject(deadlineViewModel)) {
                            VStack(alignment: .leading) {
                                HStack {
                                    if deadline.type == "WVL" {
                                        Text("TODO: \(deadline.occasion)").foregroundColor(Color("HighlightText"))
                                            .lineLimit(1)
                                    } else if deadline.type == "NOT" {
                                        Text("\(deadline.occasion)")
                                            .foregroundColor(.red)
                                            .lineLimit(1)
                                    } else {
                                        Text("\(deadline.occasion)")
                                            .lineLimit(1)
                                    }
                                }.padding(.bottom, 3)
                                HStack(alignment: .center) {
                                    Spacer()
                                    Image(systemName: "calendar")
                                    if deadline.deadlineDate.timeIntervalSinceReferenceDate != 0 {
                                        Text("\(outDateFormatter.string(from: deadline.deadlineDate))")
                                    Spacer()
                                    } else {
                                        Text("k.A")
                                    }
                                }
                                
                                Divider()
                                Text("\(deadline.occasionText)").foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .padding(.bottom, 3)
                                
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(15)
                        .background(Color("BoxBackground"))
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
                    }
            }
        }
    }
}

struct NextDEadlinesNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            NextDeadlinesNavigationView()
                .preferredColorScheme(colorScheme)
        }
    }
}
