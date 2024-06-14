

import Foundation

// To shorten the String in the main feed as a preview
extension String {
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    func slice(from: String, to: String) -> String? {
            return (range(of: from)?.upperBound).flatMap { substringFrom in
                (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                    String(self[substringFrom..<substringTo])
                }
            }
        }
}
