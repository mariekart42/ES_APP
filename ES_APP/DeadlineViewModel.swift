//
//  DeadlineVM.swift
//  My IP Port
//
//  Created by Dominik Remo on 07.06.22.
//

import Foundation
import CoreData
import UIKit

// MARK: DeadlineViewModel
/// View model for `DeadlineView`
@MainActor
class DeadlineViewModel: TimelineDataProtocol, ObservableObject {
    // The Deadline Objects that are loaded from storage
    @Published var deadlines: [Deadline]
    
    // Attributes for Filtering
    @Published var showFilter = false
    @Published var filterByType = false
    @Published var types: [String: Bool] = [:]
    
    // Needed by Protocol TimelineDataProtocol
    typealias Entry = Deadline
    @Published var searchString = ""
    @Published var showDetail = false
    @Published var showDetailID: String = ""
    
    //For email sheet
    @Published var showMailView = false
    
    init() {
        let viewContext = PersistenceController.shared.container.viewContext
        let requestDeadlines: NSFetchRequest<Deadline> = Deadline.fetchRequest()
        
        let sortByDate = NSSortDescriptor(key: #keyPath(Deadline.deadlineDate), ascending: true)
        requestDeadlines.sortDescriptors = [sortByDate]
        
        do {
            self.deadlines = try viewContext.fetch(requestDeadlines)
            self.types = getTypes()
        } catch {
            print("Error while loading Deadlines: \(error.localizedDescription)")
            self.deadlines = []
        }
    }
    
    /// Checks the `Deadline`s for their types
    /// - Returns: A `Dictionary` with the types as a string and a bool for indication of filtering
    func getTypes() -> [String: Bool] {
        var dict: [String: Bool] = [:]
        for entry in deadlines.map({ $0.type }) {
            if dict[entry] == nil {
                dict[entry] = false
            }
        }
        return dict
    }
    
    /// Counts the `Deadline`s
    /// - Returns: The number of `Deadline`s minus 1, minimum 0 and maximum 4
    func getUpcomingDeadlinesLength () -> Int {
        var deadlinelength = deadlines.count
        if deadlinelength == 0 {
            return 0
        } else if deadlinelength > 5 {
            deadlinelength = 4
        } else {
            deadlinelength -= 1
        }
        return deadlinelength
    }
    
    // MARK: Timeline Data
    /// The Array of `TimelineGroup`s that need to be displayed in the TimelineView for the `DeadlineView`
    var timelineData: [TimelineGroup] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        // call to `getTimelineData` function for getting all neccessary data.
        // passes dateFormat that is used to display above each group. Groups are sorted alphabetically by their groupTitle. The groupTitle is converted from a data through the dateFormat.
        // passes entries that can be an array of any type
        // passes a function that is able to convert each entry in entries to a `TimelineEntry`
        var deadlines = self.deadlines
        
        // Search Deadlines
        if !searchString.isEmpty {
            deadlines = deadlines.filter {
                $0.title.lowercased().contains(searchString.lowercased())
                || $0.occasion.lowercased().contains(searchString.lowercased())
                || $0.occasionText.lowercased().contains(searchString.lowercased())
                || $0.esSymbol.lowercased().contains(searchString.lowercased())
            }
        }
        
        // Filter Deadlines
        if filterByType {
            deadlines = deadlines.filter {
                types[$0.type] ?? false
            }
        }
        
        return TimelineViewData
            .getTimelineData(dateFormat: "yyyy - MM", entries: deadlines) { (deadline: Deadline) -> TimelineEntry in
                var image: UIImage?
                // set the image for the entry
                getDeadlineImage(deadline, &image)
                
                // set the color of the bubble that is displayed between the icon and the title & description
                let bubbleColor: UIColor? = UIColor(named: "Blue02") ?? .systemGray
                
                // set the title. You can format the title (e.g. color, font, size etc.) as long as it is an `AttributedString`
                let title = getFormattedTitle(deadline.occasion)
                
                // set the description. You can format the description (e.g. color, font, size etc.) as long as it is an `AttributedString`
                let dateString = dateFormatter.string(from: deadline.deadlineDate)
                let descriptionString = dateString + "\n" + deadline.esSymbol + "\n" + "\n" + deadline.occasionText
                let description = getFormattedDescription(descriptionString)
                
                // set the date, which is used to sort the entries within a group
                let date = deadline.deadlineDate
                
                return TimelineEntry(id: deadline.id,
                                     image: image,
                                     bubbleColor: bubbleColor,
                                     title: title,
                                     description: description,
                                     date: date)
            }
    }
    
    
    /// Checks the `Deadline`s attributes and returns a fitting icon
    /// - Parameters:
    ///   - deadline: The `Deadline` that an icon is needed for
    ///   - image: The `UIImage?` that needs to be set to a fitting Icon
    fileprivate func getDeadlineImage(_ deadline: Deadline, _ image: inout UIImage?) {
        var imageString = ""
        if deadline.type.contains("WVL") {
            imageString = "Globus-100"
        } else if deadline.occasion.contains("PCT") {
            imageString = "ToDo Icon-100"
        } else if deadline.occasion.contains("Gebühr") {
            imageString = "Geld-100"
        } else if deadline.type.contains("FRI") &&
                    (deadline.occasion.contains("Verhandlung") || deadline.occasion.contains("VER")) {
            imageString = "Unterhaltung_V1-100"
        } else {
            imageString = "Dokument-100"
        }
        image = UIImage(named: imageString)?
            .withTintColor(UIColor(.secondary), renderingMode: .alwaysOriginal)
    }
    
    
    /// Formats the title for an entry in the deadline timeline
    /// - Parameter title: the `String` that needs to be formatted as a title
    /// - Returns: the formatted title
    fileprivate func getFormattedTitle(_ title: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        
        let nsTitle = NSMutableAttributedString(
            string: title.trunc(length: 28),
            attributes: [
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor(named: "HighlightText") ?? UIColor(.primary)
            ])
        
        nsTitle
            .addAttribute(.font,
                          value: UIFont.systemFont(ofSize: 15, weight: .semibold),
                          range: NSRange(location: 0, length: nsTitle.length))
        return nsTitle
    }
    
    /// Formats the description for an entry in the deadline timeline
    /// - Parameter description: the `String` that needs to be formatted as a description
    /// - Returns: the formatted description
    fileprivate func getFormattedDescription(_ description: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        
        let nsDescription = NSMutableAttributedString(
            string: description,
            attributes: [.paragraphStyle: paragraphStyle, .foregroundColor: UIColor(.primary)])
        
        nsDescription
            .addAttribute(.font,
                          value: UIFont.systemFont(ofSize: 14, weight: .medium),
                          range: NSRange(location: 0, length: nsDescription.length))
        return nsDescription
    }
    
    func getDeadline (_ deadlines: [Deadline], id: String) -> Deadline {
        deadlines.filter {
            $0.id.contains(id)
        }.first!
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
    
    func changeShowDetails() {
        showDetail.toggle()
    }
}
