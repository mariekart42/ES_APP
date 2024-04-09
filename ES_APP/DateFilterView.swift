//
//  DateFilterView.swift
//  My IP Port
//
//  Created by Henri Petuker on 7/2/22.
//

import SwiftUI

struct DateFilterView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $fileViewModel.filterByDate, label: {
                Text("Datum")
                Image(systemName: "calendar")
            })
                .font(.title2)
            
            if fileViewModel.filterByDate {
                HStack {
                    Text("von").foregroundColor(.secondary)
                    DatePicker("", selection: $fileViewModel.startDate, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                    Spacer()
                    Text("bis").foregroundColor(.secondary)
                    DatePicker("", selection: $fileViewModel.endDate, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                }
            } else {
                Text("Es wird nicht nach dem Datum gefiltert.").foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 40)
    }
}

/*
struct DateFilterView_Previews: PreviewProvider {
    static var previews: some View {
        DateFilterView()
    }
}
 */
