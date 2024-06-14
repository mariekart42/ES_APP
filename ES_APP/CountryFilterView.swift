
import SwiftUI

struct CountryFilterView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Länder", isOn: $fileViewModel.filterByCountry)
                            .font(.title2)
            if fileViewModel.filterByCountry {
                // for each country that can be retrieved from all files
                LazyVGrid(columns: [
                    GridItem(.flexible(), alignment: .leading),
                    GridItem(.flexible(), alignment: .leading),
                    GridItem(.flexible(), alignment: .leading)
                ]) {
                    ForEach(fileViewModel.country.map { $0.key }.sorted(by: (<)), id: \.self) { key in
                        Toggle(isOn: Binding(
                            // get the binded value
                            get: { fileViewModel.country[key] ?? false },
                            // set new binding, if the key does not exist already
                            set: { fileViewModel.country[key] = $0 }),
                               label: {
                            Text(fileViewModel.flagForOneCountry(country: key) + " " + key)
                        }).foregroundColor(.secondary)
                        .toggleStyle(CheckToggleStyle2())
                    }
                }
            } else {
                Text("Es wird nicht nach den Ländern gefiltert.").foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
    }
}

