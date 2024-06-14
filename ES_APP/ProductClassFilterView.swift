
import SwiftUI

struct ProductClassFilterView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $fileViewModel.filterByProductClass, label: {
                Text("Produktklasse")
                Image(systemName: "archivebox")
            })
            .font(.title2)
            
            if fileViewModel.filterByProductClass {
                LazyVGrid(columns: [
                    GridItem(.flexible(), alignment: .leading),
                    GridItem(.flexible(), alignment: .leading)
                ]) {
                    ForEach(fileViewModel.productClass.map { $0.key }.sorted(by: (<)), id: \.self) { key in
                        Toggle(isOn: Binding(
                            // get the binded value
                            get: { fileViewModel.productClass[key] ?? false },
                            // set new binding, if the key does not exist already
                            set: { fileViewModel.productClass[key] = $0 }),
                               label: {
                            Text(key)
                        }).foregroundColor(.secondary)
                            .toggleStyle(CheckToggleStyle2())
                    }    
                }
            } else {
                Text("Es wird nicht nach der Produktklasse gefiltert.").foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 40)
    }
}

struct ProductClassFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ProductClassFilterView()
    }
}
