

import SwiftUI

struct DeadlineFilterType: View {
    /// The `FileViewModel` for this view and its subviews
    @EnvironmentObject var deadlineViewModel: DeadlineViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Typen", isOn: $deadlineViewModel.filterByType)
                .font(.title2)
            if deadlineViewModel.filterByType {
                ForEach(deadlineViewModel.types.map { $0.key }.sorted(by: (<)), id: \.self) { key in
                    Toggle(isOn: Binding(
                        // get the binded value
                        get: { deadlineViewModel.types[key] ?? false },
                        // set new binding, if the key does not exist already
                        set: { deadlineViewModel.types[key] = $0 }),
                           label: {
                        Text(key)
                    }).foregroundColor(.secondary)
                    .toggleStyle(CheckToggleStyle2())
                }
            } else {
                Text("Es wird nicht nach den Typen gefiltert.").foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 40)
    }
}
