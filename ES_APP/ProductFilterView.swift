//
//  ProductFilterView.swift
//  My IP Port
//
//  Created by Maximilian Hau on 06.07.22.
//

import SwiftUI

struct ProductFilterView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $fileViewModel.filterByProduct, label: {
                Text("Produkte")
                Image(systemName: "bag")
            })
            .font(.title2)
            
            if fileViewModel.filterByProduct {
                LazyVGrid(columns: [
                    GridItem(.flexible(), alignment: .leading),
                    GridItem(.flexible(), alignment: .leading)
                ]) {
                    ForEach(fileViewModel.product.map { $0.key }.sorted(by: (<)), id: \.self) { key in
                        Toggle(isOn: Binding(
                            // get the binded value
                            get: { fileViewModel.product[key] ?? false },
                            // set new binding, if the key does not exist already
                            set: { fileViewModel.product[key] = $0 }),
                               label: {
                            Text(key)
                        }).foregroundColor(.secondary)
                            .toggleStyle(CheckToggleStyle2())
                    }
                }
            } else {
                Text("Es wird nicht nach dem Produkt gefiltert.").foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 40)
    }
}

struct ProductFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ProductFilterView()
    }
}
