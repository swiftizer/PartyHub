//
//  String+EncodeURL+Strip.swift
//  PartyHub
//
//  Created by Dinar Garaev on 19.08.2022.
//

import Foundation

extension String {
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }

    var decodeUrl: String {
        return self.removingPercentEncoding!
    }

    var length: Int {
        return count
    }

    subscript (ind: Int) -> String {
        return self[ind ..< ind + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (range: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (
            lower: max(0, min(length, range.lowerBound)),
            upper: min(length, max(0, range.upperBound)))
        )
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

    func strip(by str: String) -> String {
        return self.trimmingCharacters(in: CharacterSet.init(charactersIn: str))
    }
}
