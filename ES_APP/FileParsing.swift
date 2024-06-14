
//  Structs used to parse the raw JSON response and to select the relevant
//  attributes for the File objects.

import Foundation

struct FileParsing: Decodable {
    let listId: String
    let maxRowCount: Int
    let listing: [Item]

    struct Item: Decodable {
        let clientSymbol: String?
        let id: String?
        let imageBrand: String?
        let title: String?
        let applicant: String?
        let country: String?
        let matterType: String?
        let currentState: String?
        let caseStatus: String?
        let registrationDate: String?
        let registrationNb: String?
        let issueDate: String?
        let issueNb: String?
        let publishDate: String?
        let publishNb: String?
        let familySymbol: String?
        let brandClass: String?
        let inventors: String?
        let products: String?
        let productClasses: String?
        let changeDate: String?
        let creationDate: String?
        let imageDesign: String?
        let entryDate: String?

        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case title = "Titel"
            case applicant = "Anmelder"
            case country = "Country"
            case matterType = "Vorgangsart"
            case currentState = "Sachstatus_Klartext"
            case caseStatus = "Aktenstatus_ausgeschrieben"
            case registrationDate = "Anmeldedatum"
            case registrationNb = "Anmelde_Nr___C"
            case issueDate = "Erteilungsdatum"
            case issueNb = "AKTEAMAZERTREG"
            case publishDate = "Datum_Ver_ffentl__Anm___PUB"
            case publishNb = "Ver_ffentlichungs_Nr___PUB"
            case familySymbol = "Familienschl_ssel"
            case clientSymbol = "Ihr_Zeichen__AG"
            case brandClass = "Markenklassen__C"
            case inventors = "Erfinder"
            case products = "Produkte__C"
            case productClasses = "Produktklasse__C"
            case changeDate = "_nderungs_Datum"
            case creationDate = "Angelegt_Datum"
            case imageBrand = "Image"
            case imageDesign = "Bild_des_Design"
            case entryDate = "Registrierungssdatum"
        }
    }
}
