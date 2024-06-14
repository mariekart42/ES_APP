

import Foundation
import SwiftUI
//To view the map, a javascript will be executed with the needed parameters. Parameters depend on which countries and if its day or darkmode.
struct FamilyMapViewModel {
    //There are three parts because a string with the countries (+values) will be added inbetween
    var javaScriptCodePart1: String
    var javaScriptCodePart2: String
    var javaScriptCodePart3: String
    var javaScriptCodeOptionDay: String
    var javaScriptCodeOptionNight: String
    var isDarkMode: Bool
    var fFamily: FileFamily
    var dic: [String: Int] = [:]
    var colourSetHex: [String]
    
    //swiftlint:disable function_body_length
    init(fFamily: FileFamily, colorScheme: String) {
        colourSetHex = ["#8AE3EB", "#6783C7", "#2D2B64", "#3B7D6C"]
        javaScriptCodeOptionNight = """
        var options = {
                        legend: 'none',
                        colorAxis: {minValue: 0,colors:
                        ['#8AE3EB', '#6783C7',
                        '#2D2B64','#3B7D6C'], maxValue: 3},
                        backgroundColor: '#0e161f',
                        datalessRegionColor: '#6a6b6b'
                        };
        """
        javaScriptCodeOptionDay = """
        var options = {
                legend: 'none',
                colorAxis: {minValue: 0,colors: ['#8AE3EB', '#6783C7',
                        '#2D2B64','#3B7D6C'], maxValue: 3},
                };
        
        """
        if colorScheme == "dark" {
            isDarkMode = true
        } else {
            isDarkMode = false
        }
        javaScriptCodePart1 = """
                <html>
                    <head>
                        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
                        <script type="text/javascript">
                            google.charts.load('current', {'packages':['geochart'],});
                            google.charts.setOnLoadCallback(drawRegionsMap);
                            function drawRegionsMap() {
                            var data = google.visualization.arrayToDataTable([
                            ['Country', 'Status'],
        """
        javaScriptCodePart2 = """
                                ]);
                            """
        javaScriptCodePart3 = """
                    var chart = new google.visualization.GeoChart(document.getElementById('regions_div'));
                    chart.draw(data, options);
                    }
                    </script>
                    </head>
                    <body>
                    <div id="regions_div" style="width: 2500px; height: 2500px;"></div>
                    </body>
                    </html>
        
        """
        self.fFamily = fFamily
        setUpDicFromFamily()
    }
    
    //    Main Function which "connects" all needed parts for a complete javascript
        func getJavaScriptString() -> String {
            let dicFiltered: [ String: Int ] = self.dic
            var javaStringCountries: String = ""
            var javaScriptCodeOption: String = ""
            for (key, value) in dicFiltered {
                javaStringCountries += "['\(key)', \(value)], "
            }
            if isDarkMode {
                javaScriptCodeOption = javaScriptCodeOptionNight
            } else {
                javaScriptCodeOption = javaScriptCodeOptionDay
            }
            
            return "\(javaScriptCodePart1) \(javaStringCountries) \(javaScriptCodePart2) \(javaScriptCodeOption) \(javaScriptCodePart3)"
        }
    
//    Sets up a dictionary based on the family
    mutating func setUpDicFromFamily() {
        if let files = fFamily.associatedFiles.allObjects as? [File] {
            files.forEach { file in
                if self.dic[file.country] == nil {
                    self.dic[file.country] = setStatus(currentState: file.currentState, caseStatus: file.caseStatus)
                } else if self.dic[file.country]! <
                            setStatus(currentState: file.currentState, caseStatus: file.caseStatus) {
                    self.dic[file.country] = setStatus(currentState: file.currentState, caseStatus: file.caseStatus)
                    }
            }
        }
    }
    
//Sets up the status for each file based on their current state and case status
//Each state has an Int as Google Geochart unfortunately only supports Ints and no Strings
//    Erloschen         -> 0
//    Akte angelegt     -> 1
//    angemeldet        -> 2
//    erteilt           -> 3
    func setStatus(currentState: String, caseStatus: String) -> Int {
        var status: Int = 0
        if caseStatus.contains("geschlossen") || caseStatus.contains("Vernichtet") {
            status = 0
        } else {
            switch currentState {
            case "Akte angelegt":
                status = 1
            case "angemeldet":
                status = 2
            case "erteilt":
                status = 3
            case "eingetragen":
                status = 3
            default:
                status = -1
            }
        }
        return status
    }
}
