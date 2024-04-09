//
//  Portfolio-PieChart.swift
//  My IP Port
//
//  Created by Dominik Remo on 13.06.22.
//

import Foundation
import SwiftUI
import Charts


struct DashboardPieChart: UIViewRepresentable {
    @ObservedObject var viewModel: FileViewModel
    
    let pieChart = PieChartView()
    
    /// called when chart is shown the first time
    func makeUIView(context: Context) -> PieChartView {
        pieChart.delegate = context.coordinator
        return pieChart
    }
    
    /// called when chart is updated
    func updateUIView(_ pieChart: PieChartView, context: Context) {
        setChartData(pieChart)
        configureChart(pieChart)
        formatCenter(pieChart)
        formatLegend(pieChart.legend)
        pieChart.notifyDataSetChanged()
    }
    
    /// sets the data of this chart
    func setChartData(_ pieChart: PieChartView) {
        let dataSet = PieChartDataSet(entries: viewModel.pieChartDataEntry)
        dataSet.colors = [
            UIColor(Color("Blue01")),
            UIColor(Color("Blue02")),
            UIColor(Color("Blue03")),
            UIColor(Color("Blue04"))
        ]
        let pieChartData = PieChartData(dataSet: dataSet)
        pieChart.data = pieChartData
        formatDataSet(dataSet)
    }
    
    /// formats the labels on the chart
    func formatDataSet(_ dataSet: ChartDataSet) {
        dataSet.drawValuesEnabled = false
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
    }
    
    func configureChart( _ pieChart: PieChartView) {
        pieChart.rotationEnabled = false
    }
    
    func formatCenter(_ pieChart: PieChartView) {
        pieChart.centerAttributedText = getEntryString(entry: nil)
        pieChart.holeColor = UIColor.systemBackground
        pieChart.centerTextRadiusPercent = 0.95
    }
    
    func formatDescription( _ description: Description) {
        description.enabled = false
    }
    
    // disable the legend
    func formatLegend(_ legend: Legend) {
        legend.enabled = false
    }
    
    func setCenterText(_ text: NSAttributedString) {
        pieChart.centerAttributedText = text
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: DashboardPieChart
        var isSelected = false
        
        init(_ parent: DashboardPieChart) {
            self.parent = parent
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            parent.pieChart.centerAttributedText = parent.getEntryString(entry: entry)
            if isSelected == false {
                isSelected = true
            } else {
                chartValueNothingSelected(chartView)
            }
        }
        
        func chartValueNothingSelected(_ chartView: ChartViewBase) {
            parent.pieChart.centerAttributedText = parent.getEntryString(entry: nil)
            chartView.highlightValues([])
            isSelected = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func getEntryString(entry: ChartDataEntry?) -> NSAttributedString {
//        let viewModel = FileViewModel(model)
        
        if entry != nil {
            let label = "\(entry?.value(forKey: "label") ?? "")"
            var descriptionArray: [String] = []
            
            let counts = viewModel.counts.first(where: { $0.category.rawValue == label })?.counts
            
            for count in counts ?? [:] where count.value > 0 {
                descriptionArray.insert(count.key.rawValue + ": " + String(count.value), at: 0)
            }
            
            let descriptionText = descriptionArray.sorted(by: { $0 < $1 }).joined(separator: "\n")
            
            return formatted(labelText: label, descriptionText: descriptionText)
        } else {
            var labelText = "Gesamt:"
            var descriptionText = ""
            
            for entry in viewModel.pieChartDataEntry.sorted(by: { $0.label ?? "" < $1.label ?? "" }) {
                
                var label = "\(entry.label ?? "")"
                let total = viewModel.counts.first(where: { $0.category.rawValue == label })?.total ?? 42
                if label.contains("Gebrauchs-\nmuster"){
                    label = "Gebrauchsmuster"
                }
                descriptionText += "\(label): \(total)\n"
            }
            
            if descriptionText.isEmpty {
                labelText = "My IP Port"
                descriptionText = "Keine Daten zum Darstellen vorhanden"
            }
            return formatted(labelText: labelText, descriptionText: descriptionText)
        }
    }
    
    /// - returns: NSAttributedString containing a label and the description
    func formatted(labelText: String, descriptionText: String) -> NSAttributedString {
        let centerText = """
            \(labelText)
            \(descriptionText)
            """
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let centerAttributedText = NSMutableAttributedString(
            string: centerText,
            attributes: [.paragraphStyle: paragraphStyle, .foregroundColor: UIColor(.primary)])
        
        centerAttributedText
            .addAttribute(.font, value:
                           UIFont.systemFont(ofSize: 16, weight: .bold),
                          range: NSRange(location: 0, length: labelText.count))
        
        return centerAttributedText
    }
}

/*
struct PieChart_Previews: PreviewProvider {
    private static let model: Model = MockModel()

    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            DashboardPieChart(viewModel: FileViewModel(model))
                .preferredColorScheme(colorScheme)
        }
    }
}
 */
