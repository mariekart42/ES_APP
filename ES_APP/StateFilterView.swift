//
//  StateFilterView.swift
//  My IP Port
//
//  Created by Julian Heiß on 06.07.22.
//

import SwiftUI

struct StateFilterView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    var showClosed: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $fileViewModel.filterByCurrentState, label: {
                Text("Status")
                Image(systemName: "clock")
            })
                .font(.title2)
            
            if fileViewModel.filterByCurrentState {
                VStack(alignment: .leading) {
                    ForEach(fileViewModel.state.map { $0.key }.sorted(by: (<)), id: \.self) { key in
                        if (!showClosed && !key.contains("erloschen")) || (showClosed && key.contains("erloschen")) ||
                            (showClosed && !key.contains("erloschen")) {
                        Toggle(isOn: Binding(
                            // get the binded value
                            get: { fileViewModel.state[key] ?? false },
                            // set new binding, if the key does not exist already
                            set: { fileViewModel.state[key] = $0 }),
                               label: {
                            Text(key)
                        }).foregroundColor(.secondary)
                        .toggleStyle(CheckToggleStyle2())
                        }
                    }
                }
            } else {
                Text("Es wird nicht nach dem Status gefiltert.").foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 40)
    }
}

struct StateFilterView_Previews: PreviewProvider {
    static var previews: some View {
        StateFilterView(showClosed: true)
    }
}
