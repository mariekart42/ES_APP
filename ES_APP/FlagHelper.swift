import Foundation

class FlagHelper: ObservableObject {
    static func flag(countries: [StringCD]) -> String {
        var flags = ""
        var countriesString: [String] = []
        for entry in countries {
            countriesString.append(entry.name)
        }
        var countriesSorted = countriesString
        countriesSorted.sort()
        for country in countriesSorted {
            let flag = flagForOneCountry(country: country)
            if !flags.contains(flag) {
                flags += flag
            }
        }
        return flags
    }
    
    static func flagForOneCountry(country: String) -> String {
        var flag = ""
        let base: UInt32 = 127397
        if country.contains("WO") {
            flag = "🌎"
        } else if country.contains("EP") {
            flag = "🇪🇺"
        } else {
            for scalars in country.unicodeScalars {
                flag.unicodeScalars.append(UnicodeScalar(base + scalars.value)!)
            }
        }
        return flag
    }
}
