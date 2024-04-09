//
//  FileFamilyHelper.swift
//  My IP Port
//
//  Created by Henri Petuker on 6/29/22.
//
//  This struct is used to temporarily generate FileFamilyHelper objects during
//  the function buildFileFamiliyHelpers in DataViewModel.

import Foundation

struct FileFamilyHelper {
    let id: String?
    let title: String?
    let matterType: String?
    let registrationDate: Date?
    var associatedFiles: [File]
    var countries: [String?]
    
    init(id: String, title: String?, registrationDate: Date?, matterType: String?) {
        self.id = id
        self.title = title
        self.matterType = matterType
        self.registrationDate = registrationDate
        self.associatedFiles = []
        self.countries = []
    }
}
