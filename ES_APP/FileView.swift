//
//  FileView.swift
//  My IP Port
//
//  Created by Julian Heiß on 31.05.22.
//

import SwiftUI

struct FileView: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    @State private var showingAlert = false
    @State private var note: String = ""
    @State private var addToRecentViewedFiles: Bool
    @EnvironmentObject var dataViewModel: DataViewModel
    var file: File
    var inventorsArray: [String]
    var productsArray: [String]
    var productClassesArray: [String]
    var output: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                FileViewLogoGeneral(file: file)
                    .environmentObject(fileViewModel)
                FileViewInventorsStatus(file: file, inventorsArray: inventorsArray)
                FileViewAmtSymbols(file: file)
                    .environmentObject(fileViewModel)
                FileViewProductClassOther(file: file, productsArray: productsArray, productClassesArray: productClassesArray)
            }
            .padding(.horizontal, 12)
        }
        .onAppear {
            if addToRecentViewedFiles {
                if file.matterType.contains("Patent") &&
                    !file.matterType.contains("Beratung") && !file.matterType.contains("kte") {
                    dataViewModel.updateLastViewedFiles(file: file)
                }
            }
        }
        .onDisappear {
            if !addToRecentViewedFiles {
                if file.matterType.contains("Patent") &&
                    !file.matterType.contains("Beratung") && !file.matterType.contains("kte") {
                    dataViewModel.updateLastViewedFiles(file: file)
                }
            }
        }
        .navigationTitle(file.id)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button {
            fileViewModel.eMail(id: file.id)
        }
                            label: { Image(systemName: "envelope")
                .disabled(!MailView.canSendMail)
                .sheet(isPresented: $fileViewModel.showMailView, content: { MailView(subject: "--\(file.id)--", mail: "mail@eisenfuhr.com") })
        }
        )
    }
    
    init(_ file: File, _ addToRecentFiles: Bool ) {
        self.file = file
        inventorsArray = []
        productsArray = []
        productClassesArray = []
        self.addToRecentViewedFiles = addToRecentFiles
        
        if let stringArray = file.inventors.allObjects as? [StringCD] {
            stringArray.forEach { inventor in
                inventorsArray.append(inventor.name.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        if let stringArray = file.products.allObjects as? [StringCD] {
            stringArray.forEach { product in
                productsArray.append(product.name.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        if let stringArray = file.productClasses.allObjects as? [StringCD] {
            stringArray.forEach { productClass in
                productClassesArray.append(productClass.name.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
}


struct FileViewLogoGeneral: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    var file: File
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
            Text("\(file.title)").font(Font.system(size: 16)).fontWeight(.bold).padding(.vertical, 5).multilineTextAlignment(.center)
                Spacer()
            }
            if fileViewModel.findBrand(matterType: file.matterType) {
                if let image = fileViewModel.getLogo(data: file.image) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                }
            }
            if fileViewModel.findDesign(matterType: file.matterType) {
                if let image = fileViewModel.getLogo(data: file.imageDesign) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                }
            }
        }
        .padding(15)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
        .padding(.top, 20)
        .frame(maxWidth: .infinity)
        
        Spacer().frame(height: 20)
        Text("   Allgemein")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Vorgangsart:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(file.matterType)")
            }
            Divider()
            VStack(alignment: .leading) {
                Text("Land:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(file.country)")
            }
            Divider()
            VStack(alignment: .leading) {
                Text("Online Register:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if !file.caseStatus.contains("geschlossen") && !file.caseStatus.contains("Vernichtet") {
                    if file.issueNb != " " && file.matterType.contains("Patent") {
                        Link("Google Patents", destination: URL(string: "\(fileViewModel.getPatenLink(country: file.country, issueNb: file.issueNb))")!)
                    } else {
                        Text("k.A.")
                    }
                } else {
                    Text("k.A.")
                }
            }
            Divider()
            VStack(alignment: .leading) {
                Text("Mandanten-Titel:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(file.clientSymbol.isEmpty ? "k.A.": file.clientSymbol)")
            }
        }
        .padding(15)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
    }
    
    init(file: File) {
        self.file = file
    }
}

struct FileViewInventorsStatus: View {
    var file: File
    var inventorsArray: [String]
    
    var body: some View {
        Spacer().frame(height: 20)
        Text("   Erfinder")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            //map with ForEach over inventors
            if inventorsArray[0].isEmpty {
                HStack {
                    Text("k.A.")
                    Spacer()
                }
            } else {
                HStack {
                    Text("\(inventorsArray[0])")
                    Spacer()
                }
                ForEach(inventorsArray[1...], id: \.self) { inventor in
                    Divider()
                    VStack(alignment: .leading) {
                        Text("\(inventor)")
                    }
                }
            }
        }
        .padding(15)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
        
        
        Spacer().frame(height: 20)
        Text("   Status")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Sachstatus:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(file.currentState)")
            }
            Divider()
            VStack(alignment: .leading) {
                Text("Aktenstatus:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(file.caseStatus)")
            }
        }
        .padding(15)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
    }
    
    init(file: File, inventorsArray: [String]) {
        self.file = file
        self.inventorsArray = inventorsArray
    }
}

struct FileViewAmtSymbols: View {
    @EnvironmentObject var fileViewModel: FileViewModel
    var file: File
    
    var body: some View {
        Spacer().frame(height: 20)
        Text("   Amtliche Zeichen")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Anmeldung:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if file.registrationDate.timeIntervalSinceReferenceDate != 0 {
                    Text("\(fileViewModel.getDate(date: file.registrationDate))  \(file.registrationNb)")
                } else {
                    Text("k.A.")
                }
            }
            Divider()
            VStack(alignment: .leading) {
                Text("Veröffentl. Anmeldung:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if file.publishDate.timeIntervalSinceReferenceDate != 0 {
                    Text("\(fileViewModel.getDate(date: file.publishDate))  \(file.publishNb)")
                } else {
                    Text("k.A.")
                }
            }
            Divider()
            VStack(alignment: .leading) {
                if file.matterType != "Patent"{
                    Text("Eintragung:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("Erteilung:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                if file.issueDate.timeIntervalSinceReferenceDate != 0 {
                    Text("\(fileViewModel.getDate(date: file.issueDate))  \(file.issueNb)")
                } else if file.entryDate.timeIntervalSinceReferenceDate != 0 {
                    Text("\(fileViewModel.getDate(date: file.entryDate))  \(file.issueNb)")
                } else {
                    Text("k.A.")
                }
            }
        }
        .padding(15)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
    }
    
    init(file: File) {
        self.file = file
    }
}


struct FileViewProductClassOther: View {
    var file: File
    var productsArray: [String]
    var productClassesArray: [String]
    
    var body: some View {
        Spacer().frame(height: 20)
        Text("   Produktklassen")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            if productClassesArray[0].isEmpty {
                HStack {
                    Text("k.A.")
                    Spacer()
                }
            } else {
                HStack {
                    Text("\(productClassesArray[0])")
                    Spacer()
                }
                ForEach(productClassesArray[1...], id: \.self) { productClass in
                    Divider()
                    VStack(alignment: .leading) {
                        Text("\(productClass)")
                    }
                }
            }
        }
        .padding(15)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
        
        Spacer().frame(height: 20)
        Text("   Produkte")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            if productsArray[0].isEmpty {
                HStack {
                    Text("k.A.")
                    Spacer()
                }
            } else {
                HStack {
                    Text("\(productsArray[0])")
                    Spacer()
                }
                ForEach(productsArray[1...], id: \.self) { product in
                    Divider()
                    VStack(alignment: .leading) {
                        Text("\(product)")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
        
        Spacer().frame(height: 20)
        Text("   Weitere Informationen")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Anmelder:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(file.applicant.isEmpty ? "k.A.": file.applicant)")
            }
            Divider()
            VStack(alignment: .leading) {
                Text("Bewertung:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                StarsView(file)
            }
        }
        .padding(15)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
        .padding(.bottom, 20)
    }
    
    init(file: File, productsArray: [String], productClassesArray: [String]) {
        self.file = file
        self.productsArray = productsArray
        self.productClassesArray = productClassesArray
    }
}

/*
 struct File_Previews: PreviewProvider {
 private static let model: Model = MockModel()
 
 static var previews: some View {
 ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
 FileView(model.files.first!, FileViewModel(model))
 .preferredColorScheme(colorScheme)
 }
 }
 }
 }*/
