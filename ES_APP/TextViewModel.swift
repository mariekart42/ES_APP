
import Foundation
import SwiftUI

/// class to store the notes which the user can enter in family details or in deadline details in the user defaults
class TextViewModel: ObservableObject {
    private var notesDic: [String: String]
    private var notesDeadlineDic: [String: String]
    let userDefaults: UserDefaults
    
    init() {
        userDefaults = UserDefaults.standard
        notesDic = userDefaults.object(forKey: "Notes") as? [String: String] ?? [:]
        notesDeadlineDic = userDefaults.object(forKey: "NotesDeadlines") as? [String: String] ?? [:]
    }
    
    func textMatch(_ family: FileFamily, _ searchString: String) -> Bool {
        if let text = notesDic[family.id] {
            if text.lowercased().contains(searchString) {
                return true
            }
        }
        return false
    }
    
    /// addNote for FamilyDetails
    func addNote(_ family: FileFamily, _ text: String) {
        objectWillChange.send()
        notesDic[family.id] = text
        save()
    }
    
    /// addNote for Deadline Details
    func addNote(_ deadlineID: String, _ text: String) {
        objectWillChange.send()
        notesDeadlineDic[deadlineID] = text
        saveDeadline()
    }
    
    func getNote(_ family: FileFamily) -> String {
        if let text = notesDic[family.id] {
            return text
        }
        return ""
    }
    
    func getNote(_ deadlineId: String) -> String {
        if let text = notesDeadlineDic[deadlineId] {
            return text
        }
        return ""
    }
    
    func save() {
        for dic in notesDic {
            if dic.value.isEmpty {
                notesDic[dic.key] = nil
            }
        }
        userDefaults.set(notesDic, forKey: "Notes")
    }
    
    func saveDeadline() {
        for dic in notesDeadlineDic {
            if dic.value.isEmpty {
                notesDeadlineDic[dic.key] = nil
            }
        }
        userDefaults.set(notesDeadlineDic, forKey: "NotesDeadlines")
    }
}
