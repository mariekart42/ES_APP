
import Foundation
import UIKit

enum TimelineViewData {
    // MARK: TimelineData Function
    /// Create an Array of `TimelineGroup`s for the TimelineView
    /// - Parameters:
    ///    - dateFormat: The format of the date that is being displayed for a group within the Timeline (e.g. "yyyy - MM", "y/MM/dd" ...)
    static func getTimelineData<T>(dateFormat: String,
                                   entries: [T],
                                   entryFormatter: (T) -> TimelineEntry) -> [TimelineGroup] {
        /// The `TimelineEntry`s in a dictionary
        var dataDict: [String: [TimelineEntry]] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat // different
        
        // fill dataDict
        for entry in entries {
            let timelineEntry = entryFormatter(entry)
            let date = timelineEntry.date
            
            let group: String
            if let date = date {
                group = dateFormatter.string(from: date)
            } else {
                group = ""
            }
            
            // grouped deadlines (grouped by Year - Month)
            var groupData = dataDict[group] ?? []
            groupData.insert(timelineEntry, at: 0)
            dataDict[group] = groupData
        }
        
        // sort entries for each group
        for group in dataDict {
            dataDict[group.key] = group.value.sorted { $0.date?.description ?? "" < $1.date?.description ?? "" }
        }
        
        /// The `TimelineGroup`s as a sorted list
        let dataList: [TimelineGroup] =
        dataDict.map { TimelineGroup(group: $0.key, entries: $0.value) }.sorted(by: { $0.group < $1.group })
        
        return dataList
    }
}

// MARK: TimelineGroup
struct TimelineGroup: Identifiable {
    let id = UUID()
    let group: String
    let entries: [TimelineEntry]
}

// MARK: TimelineEntry
struct TimelineEntry: Identifiable {
    let id: String
    let image: UIImage?
    let bubbleColor: UIColor?
    let title: NSAttributedString
    let description: NSAttributedString
    let date: Date?
}
