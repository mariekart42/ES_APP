//
//  DataViewModel.swift
//  My IP Port
//
//  Created by Henri Petuker on 6/28/22.
//
//  View Model that collects the data from the Eisenführ Speiser Workflow
//  Service API and updates the persistent data.


import Foundation
import CoreData
import SwiftUI

@MainActor class DataViewModel: ObservableObject {
    // Service for fetching `Files`s from the Workflow Service
    private let fileService: FileNS
    // Service for fetching `Deadline`s from the Workflow Service
    private let deadlineService: DeadlineNS
    
    private let dateFormatter: ISO8601DateFormatter
    private let referenceDate: Date
    
    // The current User Defaults
    let userDefaults: UserDefaults
    
    init() {
        self.fileService = FileNS()
        self.deadlineService = DeadlineNS()
        self.dateFormatter = ISO8601DateFormatter()
        self.referenceDate = Date(timeIntervalSinceReferenceDate: 0)
        self.userDefaults = UserDefaults.standard
    }
    
    //swiftlint:disable function_body_length
    func updateFiles(context: NSManagedObjectContext) async {
        do {
            let response = try await fileService.fetchFileData()
            for file in response.listing {
                let newFile = File(context: context)
                // Setting all attributes by hand (more elegant solution?)
                newFile.issueDate = dateFormatter.date(from: (file.issueDate ?? "") + "Z") ?? referenceDate
                newFile.registrationDate = dateFormatter.date(from:
                    (file.registrationDate ?? "") + "Z") ?? referenceDate
                newFile.changeDate = dateFormatter.date(from:
                    (file.changeDate ?? "") + "Z") ?? referenceDate
                newFile.creationDate = dateFormatter.date(from:
                    (file.creationDate ?? "") + "Z") ?? referenceDate
                newFile.publishDate = dateFormatter.date(from:
                    (file.publishDate ?? "") + "Z") ?? referenceDate
                // new brand/design data
                newFile.entryDate = dateFormatter.date(from:
                    (file.entryDate ?? "") + "Z") ?? referenceDate
                if let image1 = file.imageBrand {
                    newFile.image = image1.data(using: .utf8)!
                } else {
                    newFile.image = "".data(using: .utf8)!
                }
                if let image2 = file.imageDesign {
                    newFile.imageDesign = image2.data(using: .utf8)!
                } else {
                    newFile.imageDesign = "".data(using: .utf8)!
                }
                newFile.applicant = file.applicant ?? ""
                newFile.brandClass = file.brandClass ?? ""
                newFile.caseStatus = file.caseStatus ?? ""
                newFile.clientSymbol = file.clientSymbol ?? ""
                newFile.country = file.country ?? ""
                newFile.currentState = file.currentState ?? ""
                newFile.familySymbol = file.familySymbol // keep Optional for build Method
                newFile.id = file.id ?? ""
                newFile.issueNb = file.issueNb ?? ""
                newFile.matterType = file.matterType ?? ""
                newFile.publishNb = file.publishNb ?? ""
                newFile.registrationNb = file.registrationNb ?? ""
                newFile.title = file.title ?? ""
                //Parsing Inventors
                let newInventorsRAW = file.inventors ?? ""
                let newInventorsArray = newInventorsRAW.components(separatedBy: "/")
                newInventorsArray.forEach { newInventorString in
                    let newInventor = StringCD(context: context)
                    newInventor.name = newInventorString
                    newFile.addToInventors(newInventor)
                }
                //Parsing products
                let newProductsRAW = file.products ?? ""
                let newProductsArray = newProductsRAW.components(separatedBy: "\n")
                newProductsArray.forEach { newProductString in
                    let newProduct = StringCD(context: context)
                    newProduct.name = newProductString
                    newFile.addToProducts(newProduct)
                }
                //Parsing new productclasses
                let newProductClassesRAW = file.productClasses ?? ""
                let newProductClassesArray = newProductClassesRAW.components(separatedBy: "\n")
                newProductClassesArray.forEach { newProductClassString in
                    let newProductClass = StringCD(context: context)
                    newProductClass.name = newProductClassString
                    newFile.addToProductClasses(newProductClass)
                }
            }
            try context.save()
        } catch {
            // Update Error Handling
            print("IN DATA_VIEW_MODEL: Error while trying to fetch and store files: \(error.localizedDescription)")
        }
    }
    
    
    func updateDeadlines(context: NSManagedObjectContext) async {
        do {
            let response = try await deadlineService.fetchDeadlineData()
            for deadline in response.listing {
                let newDeadline = Deadline(context: context)

                // Setting all attributes by hand (more elegant solution?)
                newDeadline.deadlineDate = dateFormatter.date(from:
                    (deadline.deadlineDate ?? "") + "Z") ?? referenceDate
                newDeadline.changeDate = dateFormatter.date(from:
                    (deadline.changeDate ?? "") + "Z") ?? referenceDate
                newDeadline.creationDate = dateFormatter.date(from:
                    (deadline.creationDate ?? "") + "Z") ?? referenceDate
                newDeadline.esSymbol = deadline.esSymbol ?? ""
                newDeadline.id = deadline.id ?? ""
                newDeadline.occasion = deadline.occasion ?? ""
                newDeadline.occasionText = deadline.occasionText ?? ""
                newDeadline.title = deadline.title ?? ""
                newDeadline.type = deadline.type ?? ""
                newDeadline.calenderWeek = Int16(0)
            }
            try context.save()
        } catch {
            // Update Error Handling
            print("Error while trying to fetch and store Deadlines: \(error.localizedDescription)")
        }
    }
    
    
    // Function that updates the persistently stored File Families
    func updateFileFamilies(context: NSManagedObjectContext) {
        // Build the File Families from the stored File objects
        let familyHelpers = buildFileFamiliyHelpers(context: context)
        
        do {
            // Create managed Objects from Helpers
            for family in familyHelpers {
                let newFamily = FileFamily(context: context)
                newFamily.id = family.id ?? ""
                newFamily.matterType = family.matterType ?? ""
                newFamily.registrationDate = family.registrationDate ?? referenceDate
                newFamily.title = family.title ?? ""
                
                for file in family.associatedFiles {
                    newFamily.addToAssociatedFiles(file)
                    file.family = newFamily
                }
                for country in family.countries {
                    let newString = StringCD(context: context)
                    newString.name = country ?? ""
                    newString.family1 = newFamily
                    newFamily.addToCountries(newString)
                }
                try context.save()
            }
        } catch {
            // Update Error Handling
            print("Error while saving File Families: \(error.localizedDescription)")
        }
    }
    
    
    // Function that builds FileFamiliyHelpers from the currently stored File objects
    func buildFileFamiliyHelpers(context: NSManagedObjectContext) -> [FileFamilyHelper] {
        // Order stored files such that the ones containing -01 in id are at the front
        
        let request01: NSFetchRequest<File> = NSFetchRequest(entityName: "File")
        request01.predicate = NSPredicate(format: "id CONTAINS[c] '-01'")
        let request02: NSFetchRequest<File> = NSFetchRequest(entityName: "File")
        request02.predicate = NSPredicate(format: "NOT id CONTAINS[c] '-01'")
        
        do {
            var first = try context.fetch(request01)
            let second = try context.fetch(request02)
            first.append(contentsOf: second)
            var familiesDict: [String: FileFamilyHelper] = [:]
            
            for file in first {
                if let familySymbol = file.familySymbol {
                    // CASE 1: If file is a potential family root (-01) and family not yet created
                    
                    if file.id.contains("-01") && familiesDict[familySymbol] == nil {
                        // Create new family and store it in dictionary
                        familiesDict[familySymbol] = FileFamilyHelper(
                                id: familySymbol,
                                title: file.title,
                                registrationDate: file.registrationDate,
                                matterType: file.matterType)
                        familiesDict[familySymbol]?.associatedFiles.append(file)
                        familiesDict[familySymbol]?.countries.append(file.country)
                    } else if familiesDict[familySymbol] != nil {
                        // CASE 2: File not potential family root and family already exists
                        
                        familiesDict[familySymbol]?.associatedFiles.append(file)
                        familiesDict[familySymbol]?.countries.append(file.country)
                    }
                } else {
                    // CASE 3: File has no Family -> becomes its own family
                    familiesDict[file.id] = FileFamilyHelper(
                        id: file.id,
                        title: file.title,
                        registrationDate: file.registrationDate,
                        matterType: file.matterType)
                    familiesDict[file.id]?.associatedFiles.append(file)
                    familiesDict[file.id]?.countries.append(file.country)
                }
            }
            
            // Get families into an array
            var familyHelpers: [FileFamilyHelper] = []
            for (_, value) in familiesDict {
                familyHelpers.append(value)
            }
            return familyHelpers
        } catch {
            print("Error while loading files: \(error.localizedDescription)")
            let empty: [FileFamilyHelper] = []
            return empty
        }
    }
    
        
    func removeAllFiles(context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "File")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
        } catch {
            // Update Error Handling
            print("Error while deleting all Files from storage: \(error.localizedDescription)")
        }
    }
    
    
    func removeAllDeadlines(context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Deadline")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
        } catch {
            // Update Error Handling
            print("Error while deleting all Deadlines from storage: \(error.localizedDescription)")
        }
    }
    
    
    func removeAllFileFamilies(context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FileFamily")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
        } catch {
            // Update Error Handling
            print("Error while deleting all FileFamilies from storage: \(error.localizedDescription)")
        }
    }
    
    
    func getAllFileFamilies(context: NSManagedObjectContext, matterType: String) -> [FileFamily] {
        let request: NSFetchRequest<FileFamily> = FileFamily.fetchRequest()
        request.predicate = NSPredicate(format: "matterType CONTAINS[c] '\(matterType)'")
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error while loading File Families: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func getAllFileFamilies(context: NSManagedObjectContext) -> [FileFamily] {
        let request: NSFetchRequest<FileFamily> = FileFamily.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error while loading File Families: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func getAllFiles(context: NSManagedObjectContext) -> [File] {
        let request: NSFetchRequest<File> = File.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error while loading Files: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func getAllDeadlines(context: NSManagedObjectContext) -> [Deadline] {
        let request: NSFetchRequest<Deadline> = Deadline.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error while loading Deadlines: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func updateLogo() async {
        do {
            let logo = try await fileService.fetchLogo()
            self.userDefaults.set(logo, forKey: "userLogo")
        } catch {
            print("Error while loading Logo: \(error.localizedDescription)")
        }
    }
    
    
    // Function that fully refreshes all of the stored properties of the portfolio
    func updateModel(context: NSManagedObjectContext) async {
        removeAllFiles(context: context)
        await updateFiles(context: context)
        removeAllFileFamilies(context: context)
        updateFileFamilies(context: context)
        removeAllDeadlines(context: context)
        await updateDeadlines(context: context)
        await updateLogo()
    }
    
    
    // This function is used when checking to update the local user data.
    // It returns true if it's at least the next day after the last update day and after 6 am
    func updateNextMorning() -> Bool {
        if let lastUpdateDate = userDefaults.object(forKey: "lastUpdateDate") as? Date {
            if let dayDifference = Calendar.current.dateComponents([.day], from: lastUpdateDate, to: Date()).day {
                let currentHour = Calendar.current.component(.hour, from: Date())
                
                if dayDifference > 0 && currentHour >= 6 {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    func updateLastViewedFiles (file: File) {
        objectWillChange.send()
        if let lastUsedFile = userDefaults.object(forKey: "lastUsedFile") as? String {
            if lastUsedFile == file.id {
                return
            } else {
                if let secondLastUsedFile = userDefaults.object(forKey: "secondLastUsedFile") as? String {
                    if secondLastUsedFile == file.id {
                        userDefaults.set(file.id, forKey: "lastUsedFile")
                        userDefaults.set(lastUsedFile, forKey: "secondLastUsedFile")
                        return
                    } else {
                        userDefaults.set(file.id, forKey: "lastUsedFile")
                        userDefaults.set(lastUsedFile, forKey: "secondLastUsedFile")
                        userDefaults.set(secondLastUsedFile, forKey: "thirdLastUsedFile")
                        return
                    }
                } else {
                    userDefaults.set(file.id, forKey: "lastUsedFile")
                    userDefaults.set(lastUsedFile, forKey: "secondLastUsedFile")
                    return
                }
            }
        } else {
            userDefaults.set(file.id, forKey: "lastUsedFile")
            return
        }
    }
}
