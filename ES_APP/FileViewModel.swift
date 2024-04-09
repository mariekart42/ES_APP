//
//  FileViewModel.swift
//  My IP Port
//
//  Created by Julian Heiß on 01.06.22.
//

import Foundation
import SwiftUI
import Charts
import CoreData

// MARK: FileViewModel
/// View model for `PortfolioView` and `DashboardView`
//swiftlint:disable type_body_length
//swiftlint:disable file_length
@MainActor class FileViewModel: ObservableObject {
    // Bool that triggers Filter Sheet
    @Published var showFilter = false
    //mail states
    @Published var showMailView = false
    // The File Objects that are loaded from storage
    private var files: [File]
    // The FileFamily Objects that are loaded from storage
    var fileFamilies: [FileFamily]
    // Attributes for the filter sheet
    @Published var filterByDate = false
    @Published var filterByCountry = false
    @Published var filterByCurrentState = false
    @Published var filterByProduct = false
    @Published var filterByProductClass = false
    @Published var startDate = ISO8601DateFormatter().date(from: "2000-01-01T00:00:00Z")!
    @Published var endDate = Date()
    @Published var country: [String: Bool] = [:]
    //swiftlint:disable line_length
    @Published var state: [String: Bool] = ["in Planung": false, "angemeldet": false, "eingetragen/erteilt": false, "erloschen": false]
    @Published var product: [String: Bool] = [:]
    @Published var productClass: [String: Bool] = [:]
    
    
    init() {
        let viewContext = PersistenceController.shared.container.viewContext
        let requestFiles: NSFetchRequest<File> = File.fetchRequest()
        let requestFamilies: NSFetchRequest<FileFamily> = FileFamily.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(FileFamily.registrationDate), ascending: false)
        requestFamilies.sortDescriptors = [sortByDate]
        
        do {
            self.files = try viewContext.fetch(requestFiles)
            self.fileFamilies = try viewContext.fetch(requestFamilies)
            self.country = getCountries()
            self.product = getProducts()
            self.productClass = getProductClasses()
        } catch {
            print("Error while loading Files and File Families: \(error.localizedDescription)")
            self.files = []
            self.fileFamilies = []
            self.country = [:]
            self.product = [:]
            self.productClass = [:]
        }
    }
    func getCountries() -> [String: Bool] {
        var dict: [String: Bool] = [:]
        for entry in files.map({ $0.country }) {
            if dict[entry] == nil {
                dict[entry] = false
            }
        }
        return dict
    }
    
    func getProducts() -> [String: Bool] {
        var dict: [String: Bool] = [:]
        files.forEach { file in
            if let stringArray = file.products.allObjects as? [StringCD] {
                stringArray.forEach { product in
                    if !product.name.isEmpty {
                        if dict[product.name] == nil {
                            dict[product.name] = false
                        }
                    }
                }
            }
        }
        return dict
    }
    
    func getProductClasses() -> [String: Bool] {
        var dict: [String: Bool] = [:]
        files.forEach { file in
            if let stringArray = file.productClasses.allObjects as? [StringCD] {
                stringArray.forEach { productClass in
                    if !productClass.name.isEmpty {
                        if dict[productClass.name] == nil {
                            dict[productClass.name] = false
                        }
                    }
                }
            }
        }
        return dict
    }
    
    /// Applying the filters from FamilySearchView filter
    func applyFamilyFilter(families: [FileFamily]) -> [FileFamily] {
        var toReturn: [FileFamily] = []
        toReturn = familyDateFilter(families: families)
        toReturn = familyCountryFilter(families: toReturn)
        toReturn = familyStateFilter(families: toReturn)
        toReturn = familyProductFilter(families: toReturn)
        toReturn = familyProductClassFilter(families: toReturn)
        // more filters
        return toReturn
    }
    /*
     if let stringArray = file.inventors.allObjects as? [StringCD] {
     stringArray.forEach {
     inventor in
     inventorsArray.append(inventor.name.trimmingCharacters(in: .whitespacesAndNewlines))
     }
     }
     */
    
    private func familyProductFilter(families: [FileFamily]) -> [FileFamily] {
        if filterByProduct {
            let onlyTrueProducts = product.filter({ $0.value == true }).keys
            var familiestoReturn: [FileFamily] = []
            for family in families {
                var isAdded = false
                var productsArray: [String] = []
                if let files = family.associatedFiles.allObjects as? [File] {
                    files.forEach { file in
                        if let productStringArray = file.products.allObjects as? [StringCD] {
                            productStringArray.forEach { productsString in
                                productsArray.append(productsString.name)
                            }
                        }
                    }
                }
                productsArray.forEach { products in
                    if onlyTrueProducts.contains(products) && !isAdded {
                        familiestoReturn.append(family)
                        isAdded = true
                    }
                }
            }
            return familiestoReturn
        }
        return families
    }
    private func familyProductClassFilter(families: [FileFamily]) -> [FileFamily] {
        if filterByProductClass {
            let onlyTrueProductClasses = productClass.filter({$0.value == true}).keys
            var familiestoReturn: [FileFamily] = []
            for family in families {
                var isAdded = false
                var productClassArray: [String] = []
                if let files = family.associatedFiles.allObjects as? [File] {
                    files.forEach { file in
                        if let productClassStringArray = file.productClasses.allObjects as? [StringCD] {
                            productClassStringArray.forEach { productClassString in
                                productClassArray.append(productClassString.name)
                            }
                        }
                    }
                }
                productClassArray.forEach { productClass in
                    if onlyTrueProductClasses.contains(productClass) && !isAdded {
                        familiestoReturn.append(family)
                        isAdded = true
                    }
                }
            }
            return familiestoReturn
        }
        return families
    }
    /// Function to filter by registration date
    private func familyDateFilter(families: [FileFamily]) -> [FileFamily] {
        if self.filterByDate {
            return families.filter { $0.registrationDate >= startDate && $0.registrationDate <= endDate
            }
        } else {
            return families
        }
    }
    
    private func familyCountryFilter(families: [FileFamily]) -> [FileFamily] {
        // check country property of individual files
        if filterByCountry {
            var familiesToReturn: [FileFamily] = []
            for family in families {
                if let files = family.associatedFiles.allObjects as? [File] {
                    if files.contains(where: { country[$0.country] == true }) {
                        familiesToReturn.append(family)
                    }
                }
            }
            return familiesToReturn
        } else {
            return families
        }
    }
    
    /// Function to get the status of a file depending on the combination of caseStus and currentState
    func getFileStatus(file: File) -> String {
        var description = ""
        if file.caseStatus.contains("geschlossen") || file.caseStatus.contains("Vernichtet") {
            description = "erloschen"
        } else if file.currentState.contains("Akte angelegt") {
            description = "in Planung"
        } else if file.currentState.contains("angemeldet") {
            description = "angemeldet"
        } else if file.currentState.contains("eingetragen") || file.currentState.contains("erteilt") {
            description = "eingetragen/erteilt"
        }
        return description
    }
    
    
    /// Function to filter Array of `Families`s by currentState
    private func familyStateFilter(families: [FileFamily]) -> [FileFamily] {
        // check country property of individual files
        if filterByCurrentState {
            var familiesToReturn: [FileFamily] = []
            for family in families {
                if let files = family.associatedFiles.allObjects as? [File] {
                    for file in files {
                        let description = getFileStatus(file: file)
                        if state[description] == true {
                            familiesToReturn.append(family)
                        }
                    }
                }
            }
            return familiesToReturn
        } else {
            return families
        }
    }
//    Main Function which filters all files on after another
    private func filterFiles(_ files: [File]) -> [File] {
        var filtered = files
        filtered = filesDateFilter(files: filtered)
        filtered = filesCountryFilter(files: filtered)
        filtered = filesStateFilter(files: filtered)
        return filtered
    }
    
    /// Function to filter Array of `File`s by registration date
    private func filesDateFilter(files: [File]) -> [File] {
        if filterByDate {
            return files.filter { $0.registrationDate >= startDate && $0.registrationDate <= endDate
            }
        } else {
            return files
        }
    }
    
    /// Function to filter Array of `File`s by countries
    private func filesCountryFilter(files: [File]) -> [File] {
        // check country property of individual files
        if filterByCountry {
            var filesToReturn: [File] = []
            for file in files {
                if country[file.country] == true {
                    filesToReturn.append(file)
                }
            }
            return filesToReturn
        } else {
            return files
        }
    }
    
    /// Function to filter Array of `File`s by currentState
    private func filesStateFilter(files: [File]) -> [File] {
        // check country property of individual files
        if filterByCurrentState {
            var filesToReturn: [File] = []
            for file in files {
                let description = getFileStatus(file: file)
                if state[description] == true {
                    filesToReturn.append(file)
                }
            }
            return filesToReturn
        } else {
            return files
        }
    }
    
    // TODO: Correct filtering
    /// The `FileFamily`s of type Patent
    var fileFamilyPatent: [FileFamily] {
        fileFamilies.filter { $0.matterType.contains("Patent") &&
            !$0.matterType.contains("Beratung") && !$0.matterType.contains("kte")
        }
    }
    
    /// The `FileFamily`s of type Gebrauchsmuster
    var fileFamilyGS: [FileFamily] {
        fileFamilies.filter { $0.matterType.contains("Gebrauchsmuster") && !$0.matterType.contains("Beratung") }
    }
    
    /// The `FileFamily`s of type Design
    var fileFamilyDesign: [FileFamily] {
        fileFamilies.filter { $0.matterType.contains("Design") && !$0.matterType.contains("Beratung") }
    }
    
    /// The `FileFamily`s of type Brand
    var fileFamilyBrand: [FileFamily] {
        fileFamilies.filter { $0.matterType.contains("Marke") &&
            !$0.matterType.contains("Beratung") && !$0.matterType.contains("kte")
        }
    }
    
    /// The `FileFamily`s of all other types
    var fileFamilyMT: [FileFamily] {
        fileFamilies.filter {
            $0.matterType.contains("Beratung") || $0.matterType.contains("kte") || (!$0.matterType.contains("Patent") && !$0.matterType.contains("Design") &&
              !$0.matterType.contains("Marke") && !$0.matterType.contains("Gebrauchs"))
        }
    }
    
    enum FileType {
        case patent, gebrauchsmuster, design, brand, other
    }
    //filter matter Type design & brand for FileView
    func findBrand(matterType: String) -> Bool {
        if matterType.contains("Marke") && !matterType.contains("Beratung") {
            return true
        } else {
            return false
        }
    }
    func findDesign(matterType: String) -> Bool {
        if matterType.contains("Design") && !matterType.contains("Beratung") && !matterType.contains("kte") {
            return true
        } else {
            return false
        }
    }
    
    
    /// `PieChartDataEntry`s for the pie chart that is being displayed on the portfolio screen
    var pieChartDataEntry: [PieChartDataEntry] {
        // get total number of patents
        let numPatent = counts.filter { $0.category == .patent }.map { $0.total }[0]
        
        // get total number of utilityModels
        let numUtilityModel = counts.filter { $0.category == .utilityModel }.map { $0.total }[0]
        
        // get total number of designs
        let numDesign = counts.filter { $0.category == .design }.map { $0.total }[0]
        
        // get total number of brands
        let numBrand = counts.filter { $0.category == .brand }.map { $0.total }[0]
        
        let totalCount = Double(numPatent + numDesign + numBrand + numUtilityModel)
        
        let counts = [
            PieChartDataEntry(value: 0 < numPatent && Double(numPatent) < totalCount / 10 ?
                              totalCount / 10 : Double(numPatent),
                              label: FileCategory.patent.rawValue),
            PieChartDataEntry(value: 0 < numUtilityModel && Double(numUtilityModel) < totalCount / 10 ?
                              totalCount / 10 : Double(numUtilityModel),
                              label: FileCategory.utilityModel.rawValue),
            PieChartDataEntry(value: 0 < numDesign && Double(numDesign) < totalCount / 10 ?
                              totalCount / 10 : Double(numDesign),
                              label: FileCategory.design.rawValue),
            PieChartDataEntry(value: 0 < numBrand && Double(numBrand) < totalCount / 10 ?
                              totalCount / 10 : Double(numBrand),
                              label: FileCategory.brand.rawValue)
        ]
        return counts.filter { $0.value != 0 }
    }
    
    var counts: [FileCount] {
        [getPatentCount(), getUtilityModelCount(), getBrandCount(), getDesignCount()]
    }
    
    
    let outDateFormatter: DateFormatter = {
        let dfm = DateFormatter()
        dfm.dateFormat = "dd.MM.yyyy"
        dfm.locale = Locale(identifier: "de_DE")
        return dfm
    }()
    
    
    func getDate(date: Date) -> String {
        let formattedString = outDateFormatter.string(from: date)
        return formattedString
    }
    
    /// Functions for searching `FileFamily`s by name or id
    func filterPatentFamilyByNameAndID(value: String) -> [FileFamily] {
        fileFamilyPatent.filter { $0.id.lowercased().contains(value) || $0.title.lowercased().contains(value) }
    }
    
    func filterDesignFamilyByNameAndID(value: String) -> [FileFamily] {
        fileFamilyDesign.filter { $0.id.lowercased().contains(value) || $0.title.lowercased().contains(value) }
    }
    
    //Check if there is a registration date, only if yes, then assume, that the file is registered
    // Check if the case status isn't 'geschlossen'x
    func getRegisteredFilesCount(fileFamily: FileFamily) -> Int {
        if let files = fileFamily.associatedFiles.allObjects as? [File] {
            return files.filter { $0.registrationDate.timeIntervalSinceReferenceDate != 0
                && !$0.caseStatus.contains("geschlossen") &&  !$0.caseStatus.contains("Vernichtet")
            }.count
        } else {
            return 0
        }
    }
    
    //Check if there is a issued date, only if yes, then assume, that the file is issued
    func getIssuedPatentsCount(fileFamily: FileFamily) -> Int {
        if let files = fileFamily.associatedFiles.allObjects as? [File] {
            //let hasDates = files.filter { $0.issueDate.timeIntervalSinceReferenceDate != 0 }.count
            let isIssued = files.filter { $0.currentState.contains("erteilt") && !$0.caseStatus.contains("geschlossen") &&
                !$0.caseStatus.contains("Vernichtet")
            }.count
            return isIssued
            // return hasDates + isIssued
        } else {
            return 0
        }
    }
    
    func getClosedFilesCount(fileFamily: FileFamily) -> Int {
        if let files = fileFamily.associatedFiles.allObjects as? [File] {
            return files.filter { $0.caseStatus.contains("geschlossen")
                || $0.caseStatus.contains("Vernichtet")
            }.count
        }
        return 0
    }
    
    // returns the number of incorparted files like designs or brands
    func getIncorpartedCount(fileFamily: FileFamily) -> Int {
        if let files = fileFamily.associatedFiles.allObjects as? [File] {
            return files.filter { $0.currentState.contains("eingetragen")
                && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
            }.count
        } else {
            return 0
        }
    }
    
    func filterBrandFamilyByNameAndID(value: String) -> [FileFamily] {
        fileFamilyBrand.filter { $0.id.lowercased().contains(value) || $0.title.lowercased().contains(value) }
    }
    
    func filterMTFamilyByNameAndID(value: String) -> [FileFamily] {
        fileFamilyMT.filter { $0.id.lowercased().contains(value) || $0.title.lowercased().contains(value) }
    }
    
    
    func filterFileByMatterType(value: String) -> [File] {
        files.filter { $0.matterType.contains(value) }
    }
    
    func filterFileByCountry(value: String) -> [File] {
        files.filter { $0.country.contains(value) }
    }
    
    // TODO: WHY go through all patent families to count not files? ALSO: could be "sonstige"
    // Akte inside a Patent Family too!
    
    // MARK: Get Number of Files
    /// Get number of registered / granted / other `Patent`s
    //swiftlint:disable function_body_length
    private func getPatentCount() -> FileCount {
        var patentRegistered = 0
        for fam in fileFamilyPatent {
            if let files = fam.associatedFiles.allObjects as? [File] {
                patentRegistered += filterFiles(files).filter { $0.currentState.contains("angemeldet")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var patentGranted = 0
        for fam in fileFamilyPatent {
            if let files = fam.associatedFiles.allObjects as? [File] {
                patentGranted +=
                filterFiles(files).filter { $0.currentState.contains("erteilt")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var patentPlanned = 0
        for fam in fileFamilyPatent {
            if let files = fam.associatedFiles.allObjects as? [File] {
                patentPlanned +=
                filterFiles(files).filter { $0.currentState.contains("Akte angelegt")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var patentOther = 0
        for fam in fileFamilyPatent {
            if let files = fam.associatedFiles.allObjects as? [File] {
                patentOther += filterFiles(files).count
            }
        }
        
        var closedPatents = 0
        for fam in fileFamilyPatent {
            if let files = fam.associatedFiles.allObjects as? [File] {
                closedPatents += filterFiles(files).filter { $0.caseStatus.contains("geschlossen")
                    || $0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        patentOther -= (patentRegistered + patentGranted + closedPatents + patentPlanned)
        
        let patentCounts: [FileState: Int] = [
            .registered: patentRegistered,
            .granted: patentGranted,
            .planned: patentPlanned,
            .other: patentOther
        ]
        
        let total = patentRegistered + patentGranted + patentOther + patentPlanned
        
        return FileCount(category: .patent, counts: patentCounts, total: total)
    }
    
    /// Get number of registered / granted / other `Patent`s
    private func getUtilityModelCount() -> FileCount {
        var utilityModelRegistered = 0
        for fam in fileFamilyGS {
            if let files = fam.associatedFiles.allObjects as? [File] {
                utilityModelRegistered += filterFiles(files).filter { $0.currentState.contains("angemeldet")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var utilityModelGranted = 0
        for fam in fileFamilyGS {
            if let files = fam.associatedFiles.allObjects as? [File] {
                utilityModelGranted +=
                filterFiles(files).filter { $0.currentState.contains("erteilt")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var utilityModelIncorparted = 0
        for fam in fileFamilyGS {
            if let files = fam.associatedFiles.allObjects as? [File] {
                utilityModelIncorparted += filterFiles(files).filter { $0.currentState.contains("eingetragen")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var utilityModelPlanned = 0
        for fam in fileFamilyGS {
            if let files = fam.associatedFiles.allObjects as? [File] {
                utilityModelPlanned +=
                filterFiles(files).filter { $0.currentState.contains("Akte angelegt")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var utilityModelOther = 0
        for fam in fileFamilyGS {
            if let files = fam.associatedFiles.allObjects as? [File] {
                utilityModelOther += filterFiles(files).count
            }
        }
        
        var closedUtilityModel = 0
        for fam in fileFamilyGS {
            if let files = fam.associatedFiles.allObjects as? [File] {
                closedUtilityModel += filterFiles(files).filter { $0.caseStatus.contains("geschlossen")
                    || $0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        utilityModelOther -= (utilityModelRegistered + utilityModelGranted + closedUtilityModel + utilityModelPlanned + utilityModelIncorparted)
        
        let utilityModelCounts: [FileState: Int] = [
            .registered: utilityModelRegistered,
            .incorparted: utilityModelIncorparted,
            .granted: utilityModelGranted,
            .planned: utilityModelPlanned,
            .other: utilityModelOther
        ]
        
        let total = utilityModelRegistered + utilityModelGranted + utilityModelOther + utilityModelPlanned + utilityModelIncorparted
        return FileCount(category: .utilityModel, counts: utilityModelCounts, total: total)
    }
    
    /// Get number of incorparted / other `Brand`s
    private func getBrandCount() -> FileCount {
        var brandRegistered = 0
        for fam in fileFamilyBrand {
            if let files = fam.associatedFiles.allObjects as? [File] {
                brandRegistered += filterFiles(files).filter { $0.currentState.contains("angemeldet")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var brandIncorparted = 0
        for fam in fileFamilyBrand {
            if let files = fam.associatedFiles.allObjects as? [File] {
                brandIncorparted += filterFiles(files).filter { $0.currentState.contains("eingetragen")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var brandPlanned = 0
        for fam in fileFamilyBrand {
            if let files = fam.associatedFiles.allObjects as? [File] {
                brandPlanned +=
                filterFiles(files).filter { $0.currentState.contains("Akte angelegt")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var brandOther = 0
        for fam in fileFamilyBrand {
            if let files = fam.associatedFiles.allObjects as? [File] {
                brandOther += filterFiles(files).count
            }
        }
        var closedBrands = 0
        for fam in fileFamilyBrand {
            if let files = fam.associatedFiles.allObjects as? [File] {
                closedBrands += filterFiles(files).filter { $0.caseStatus.contains("geschlossen")
                    || $0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        brandOther -= (brandRegistered + brandIncorparted + closedBrands + brandPlanned)
        
        let brandCounts: [FileState: Int] = [
            .registered: brandRegistered,
            .incorparted: brandIncorparted,
            .planned: brandPlanned,
            .other: brandOther
        ]
        
        let total = brandRegistered + brandIncorparted + brandOther + brandPlanned
        
        return FileCount(category: .brand, counts: brandCounts, total: total)
    }
    
    /// Get number of incorparted / other `Design`s
    private func getDesignCount() -> FileCount {
        var designRegistered = 0
        for fam in fileFamilyDesign {
            if let files = fam.associatedFiles.allObjects as? [File] {
                designRegistered += filterFiles(files).filter { $0.currentState.contains("angemeldet")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var designIncorparted = 0
        for fam in fileFamilyDesign {
            if let files = fam.associatedFiles.allObjects as? [File] {
                designIncorparted += filterFiles(files).filter { $0.currentState.contains("eingetragen")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var designPlanned = 0
        for fam in fileFamilyDesign {
            if let files = fam.associatedFiles.allObjects as? [File] {
                designPlanned +=
                filterFiles(files).filter { $0.currentState.contains("Akte angelegt")
                    && !$0.caseStatus.contains("geschlossen") && !$0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        var designOther = 0
        for fam in fileFamilyDesign {
            if let files = fam.associatedFiles.allObjects as? [File] {
                designOther += filterFiles(files).count
            }
        }
        
        var closedDesigns = 0
        for fam in fileFamilyDesign {
            if let files = fam.associatedFiles.allObjects as? [File] {
                closedDesigns += filterFiles(files).filter { $0.caseStatus.contains("geschlossen")
                    || $0.caseStatus.contains("Vernichtet")
                }.count
            }
        }
        
        designOther -= (designRegistered + designIncorparted + closedDesigns + designPlanned)
        
        let designCounts: [FileState: Int] = [
            .registered: designRegistered,
            .incorparted: designIncorparted,
            .planned: designPlanned,
            .other: designOther
        ]
        
        let total = designRegistered + designIncorparted + designOther + designPlanned
        
        return FileCount(category: .design, counts: designCounts, total: total)
    }
    
    /// returns a string of flag emojis for a list of countries
    func flag(countries: [StringCD]) -> String {
        var flags = ""
        var countriesString: [String] = []
        for entry in countries {
            countriesString.append(entry.name)
        }
        var countriesSorted = countriesString
        countriesSorted.sort()
        for country in countriesSorted {
            let flag = flagForOneCountry(country: country)
            if !flags.contains(flag) {
                flags += flag
            }
        }
        return flags
    }
    
    /// returns a the flag emoji for a flag string
    func flagForOneCountry(country: String) -> String {
        var flag = ""
        let base: UInt32 = 127397
        if country.contains("WO") {
            flag = "🌎"
        } else if country.contains("EP") {
            flag = "🇪🇺"
        } else {
            for scalars in country.unicodeScalars {
                flag.unicodeScalars.append(UnicodeScalar(base + scalars.value)!)
            }
        }
        return flag
    }
    
    
    // get GooglePatentLink for FileView
    //alternative searching with Title "https://patents.google.com/?q=TITLE"
    func getPatenLink (country: String, issueNb: String) -> String {
        let patentId = issueNb
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: ",", with: "")
            //.dropLast()
        var countryFinal = country
        if country.contains("CH") || country.contains("AT") || country.contains("BE") || country.contains("FR") || country.contains("NL") || country.contains("GB") || country.contains("CZ") || country.contains("IT") || country.contains("SE") || country.contains("NO") {
            countryFinal = "EP"
        }
        let registerLink = "https://patents.google.com/?q=\(countryFinal)\(patentId)"
        return registerLink
    }
    
    // eMail Button fallback function for FileView
    func eMail (id: String) {
        if MailView.canMFController {
            showMailView.toggle()
        } else {
            let email = "mail@eisenfuhr.com"
            let id = id.replacingOccurrences(of: " ", with: "%20")
            if let url = URL(string: "mailto:\(email)?subject=--\(id)--") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    
    func getAllNewFiles (date: Date, filetype: FileType) -> [File] {
        var filesToBeReturned = [File]()
        for file in files {
            if file.creationDate > date {
                switch filetype {
                case .patent:
                    if file.matterType.contains("Patent") &&
                        !file.matterType.contains("Beratung") &&
                        !file.matterType.contains("kte") {
                        filesToBeReturned.append(file)
                    }
                case .gebrauchsmuster:
                    if file.matterType.contains("Gebrauchsmuster") && !file.matterType.contains("Beratung") {
                        filesToBeReturned.append(file)
                    }
                case .design:
                    if file.matterType.contains("Design") && !file.matterType.contains("Beratung") {
                        filesToBeReturned.append(file)
                    }
                case .brand:
                    if file.matterType.contains("Marke") &&
                        !file.matterType.contains("Beratung") && !file.matterType.contains("kte") {
                        filesToBeReturned.append(file)
                    }
                case .other:
                    if file.matterType.contains("Beratung") ||
                        file.matterType.contains("kte") ||
                        (!file.matterType.contains("Patent") &&
                         !file.matterType.contains("Design") &&
                         !file.matterType.contains("Marke") &&
                         !file.matterType.contains("Gebrauchs")) {
                        filesToBeReturned.append(file)
                    }
                }
            }
        }
        return filesToBeReturned
    }
    
    func getFileByID (id: String) -> File? {
        for file in files {
            if file.id == id {
                return file
            }
        }
        return nil
    }
    
    //parse String into jpeg for customer Logo
    func getCustomerLogo (data: [UInt8]) -> UIImage? {
        if !data.isEmpty {
            let datos: NSData = NSData(bytes: data, length: data.count)
            let newImage = UIImage(data: datos as Data)
            return newImage
        } else {
            return nil
        }
    }
    
    //convert design/brand logo to jpeg
    func getLogo (data: Data) -> UIImage? {
        if !data.isEmpty {
            let str = String(decoding: data, as: UTF8.self)
            let imageData = Data(base64Encoded: str)
            let newImage = UIImage(data: imageData!)!
            return newImage
        } else {
            return nil
        }
    }
}

enum FileCategory: String {
    case patent = "Patente", utilityModel = "Gebrauchs-\nmuster", design = "Designs", brand = "Marken"
}

enum FileState: String {
    case registered = "Angemeldet",
         published = "Veröffentlicht",
         granted = "Erteilt",
         incorparted = "Eingetragen",
         planned = "Geplant",
         other = "Sonstige"
}

struct FileCount {
    var category: FileCategory
    var counts: [FileState: Int]
    var total: Int
}
