
//  Structs used to parse the raw JSON response and to select the relevant
//  attributes for the Deadline objects.

import Foundation

struct DeadlineParsing: Codable {
    let listId: String
    let maxRowCount: Int
    let listing: [DeadlineDict]
}

struct DeadlineDict: Identifiable, Codable {
    let deadlineDate: String?
    let type: String?
    let calenderWeek: String?
    let occasion: String?
    let occasionText: String?
    let title: String?
    let id: String?
    let esSymbol: String?
    let creationDate: String?
    let changeDate: String?

    enum CodingKeys: String, CodingKey {
        case deadlineDate = "Fristende"
        case type = "Fristtyp"
        case calenderWeek = "KW"
        case occasion = "Anlass"
        case occasionText = "Manuelltext"
        case title = "Stichwort_Titel__A"
        case id = "ID"
        case esSymbol = "Unser_Zeichen"
        case creationDate = "Angelegt_Datum"
        case changeDate = "_nderungs_Datum"
    }
}
