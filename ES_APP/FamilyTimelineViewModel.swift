//
//  FamilyTimelineViewModel.swift
//  My IP Port
//
//  Created by Hochstrat, Selina on 04.07.22.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

// MARK: FamilyTimelineViewModel
/// View model for `FamilyTimelineView`
@MainActor
class FamilyTimelineViewModel: TimelineDataProtocol, ObservableObject {
    // required by TimelineDataProtocol
    typealias Entry = File
    @Published var searchString: String = ""
    @Published var showDetail = false
    @Published var showDetailID: String = ""
    
    @Published var family: FileFamily
    
    init() {
        let viewContext = PersistenceController.shared.container.viewContext
        self.family = FileFamily(context: viewContext)
    }
    
    var sortedFiles: [File] {
        if let files = family.associatedFiles.allObjects as? [File] {
            return files.sorted { $0.id < $1.id }
        } else {
            return []
        }
    }
    
    // MARK: Timeline Data
    /// The Array of `TimelineGroup`s that need to be displayed in the TimelineView for the `FamilyTimelineView`
    var timelineData: [TimelineGroup] {
        timelineData(files: sortedFiles)
    }
    
    func timelineData(files: [File]) -> [TimelineGroup] {
        let fileDates = getFileDates(currentFiles: files)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        // call to `getTimelineData` function for getting all neccessary data.
        // passes dateFormat that is used to display above each group. Groups are sorted alphabetically by their groupTitle. The groupTitle is converted from a data through the dateFormat.
        // passes entries that can be an array of any type
        // passes a function that is able to convert each entry in entries to a `TimelineEntry`
        return TimelineViewData
            .getTimelineData(dateFormat: "yyyy", entries: fileDates) { (file: FileDate) -> TimelineEntry in
                // set the image of the TimelineEntry
                let image = file.image
                // set the color of the bubble that is displayed between the icon and the title & description
                let bubbleColor: UIColor? = UIColor(named: "Blue02") ?? .systemGray
                // set the title. You can format the title (e.g. color, font, size etc.) as long as it is an `AttributedString`
                //flag: fileViewModel(family).getFlag?
                let title = NSMutableAttributedString(string: file.dateType + " " + FlagHelper.flagForOneCountry(country: file.country), attributes: [
                    .foregroundColor: UIColor(named: "HighlightText") ?? UIColor(.primary)
                ])
                
                title
                    .addAttribute(.font,
                                  value: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                  range: NSRange(location: 0, length: title.length))
                
                let dateString = dateFormatter.string(from: file.realDate)
                let descriptionString = file.id + "\n" + dateString
                // set the description. You can format the description (e.g. color, font, size etc.) as long as it is an `AttributedString`
                let description = NSMutableAttributedString(string: descriptionString)
                description.addAttribute(.font,
                                          value: UIFont.systemFont(ofSize: 14, weight: .medium),
                                          range: NSRange(location: 0, length: description.length))
                // set the date, which is used to sort the entries within a group
                let date = file.realDate
                
                return TimelineEntry(id: file.id,
                                     image: image,
                                     bubbleColor: bubbleColor,
                                     title: title,
                                     description: description,
                                     date: date)
            }
    }
    
    fileprivate func getFileDates (currentFiles: [File]) -> [FileDate] {
        var dates: [FileDate] = []
        for file in currentFiles {
            if file.registrationDate.timeIntervalSinceReferenceDate != 0 {
                let registeredDate = FileDate(id: file.id, dateType: "Anmeldung", country: file.country,
                realDate: file.registrationDate, image: UIImage(named: "icons8-registration")?
                .withTintColor(UIColor(.secondary), renderingMode: .alwaysOriginal))
                dates.append(registeredDate)
            }
            if file.entryDate.timeIntervalSinceReferenceDate == 0 {
                if file.issueDate.timeIntervalSinceReferenceDate != 0 {
                let issuedDate = FileDate(id: file.id, dateType: "Erteilung", country: file.country,
                    realDate: file.issueDate, image: UIImage(named: "icons8-granted")?
                    .withTintColor(UIColor(.secondary), renderingMode: .alwaysOriginal))
                dates.append(issuedDate)
                }
            } else {
                if file.entryDate.timeIntervalSinceReferenceDate != 0 {
                    let entryDate = FileDate(id: file.id, dateType: "Eintrag", country: file.country,
                        realDate: file.entryDate, image: UIImage(named: "icons8-entry")?
                        .withTintColor(UIColor(.secondary), renderingMode: .alwaysOriginal))
                    dates.append(entryDate)
                }
            }
            if file.publishDate.timeIntervalSinceReferenceDate != 0 {
                let publishedDate = FileDate(id: file.id, dateType: "Veröffentl. Anmeldung", country: file.country,
                    realDate: file.publishDate, image: UIImage(named: "icons8-publications")?
                    .withTintColor(UIColor(.secondary), renderingMode: .alwaysOriginal))
                dates.append(publishedDate)
            }
        }
        return dates
    }
}

//parse file data into different date objects
private struct FileDate {
    var id: String
    var dateType: String
    var country: String
    var realDate: Date
    var image: UIImage?
}
