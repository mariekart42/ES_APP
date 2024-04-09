//
//  TimelineView.swift
//  My IP Port
//
//  Created by Dominik Remo on 03.07.22.
//

import SwiftUI

@MainActor
protocol TimelineDataProtocol {
    associatedtype Entry
    var timelineData: [TimelineGroup] { get }
    var searchString: String { get }
    var showDetail: Bool { get set }
    var showDetailID: String { get set }
}

@MainActor
struct TimelineTable<ViewModel: ObservableObject>: UIViewControllerRepresentable where ViewModel: TimelineDataProtocol {
    @ObservedObject var viewModel: ViewModel
    let clickable: Bool
    
    init(viewModel: ViewModel, clickable: Bool) {
        self.viewModel = viewModel
        self.clickable = clickable
    }
    
    /// Creates a `UITableViewController`
    func makeUIViewController(context: Context) -> UITableViewController {
        UITableViewController()
    }
    
    /// Updates the UIViewController
    func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        uiViewController.tableView.separatorStyle = .none
        
        uiViewController.tableView.rowHeight = UITableView.automaticDimension
        uiViewController.tableView.estimatedRowHeight = UITableView.automaticDimension
        uiViewController.tableView.allowsSelection = clickable
        
        uiViewController.tableView.dataSource = context.coordinator
        uiViewController.tableView.delegate = context.coordinator
        
        uiViewController.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        uiViewController.tableView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// MARK: Coordinator
extension TimelineTable {
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var parent: TimelineTable

        init(_ parent: TimelineTable) {
            self.parent = parent
        }

        /// returns the number of sections/groups
        func numberOfSections(in tableView: UITableView) -> Int {
            parent.viewModel.timelineData.count
        }

        /// returns the number of entries within a group
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            parent.viewModel.timelineData[section].entries.count
        }
        
        /// returns the title for a group
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            parent.viewModel.timelineData[section].group
        }

        /// returns a new `UITableViewCell` that is styled for the timeline
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath)
                as! TimelineTableViewCell
            // swiftlint:enable force_cast

            let entry = parent.viewModel.timelineData[indexPath.section].entries[indexPath.row]
            
            var frontColor = UIColor(named: "Blue01") ?? UIColor.systemGray3
            var backColor = UIColor(named: "Blue01") ?? UIColor.systemGray3
            let pointColor = entry.bubbleColor ?? UIColor.systemGray
            if indexPath.row == 0 {
                frontColor = UIColor.clear
            }
            if indexPath.row == parent.viewModel.timelineData[indexPath.section].entries.count - 1 {
                backColor = UIColor.clear
            }

            cell.timelinePoint = TimelinePoint(diameter: 12, lineWidth: 1, color: pointColor, filled: true)
            styleCell(cell: cell, fColor: frontColor, bColor: backColor, pColor: pointColor)
            
            cell.timeline.leftMargin = tableView.bounds.width * 0.22

            cell.titleLabel.attributedText = entry.title
            cell.descriptionLabel.attributedText = entry.description

            cell.illustrationSize.constant = tableView.bounds.width * 0.08
            cell.illustrationImageView.image = entry.image

            cell.bubbleEnabled = false
            return cell
        }
        
        /// styles the color of a cell
        func styleCell(cell: TimelineTableViewCell, fColor: UIColor, bColor: UIColor, pColor: UIColor) {
            cell.timeline.frontColor = fColor
            cell.timeline.backColor = bColor
            cell.timelinePoint.color = pColor
            cell.timeline.width = 20
            cell.titleLabel.textColor = UIColor(.primary)
            cell.descriptionLabel.textColor = UIColor(.primary)
        }
        
        /// is called when the user taps on an entry
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let entry = parent.viewModel.timelineData[indexPath.section].entries[indexPath.row]
            parent.viewModel.showDetailID = entry.id
            parent.viewModel.showDetail = true
        }
    }
}
