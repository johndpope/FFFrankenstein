//
//  String+Utilities.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 10/29/18.
//

import Foundation
import Path

// FIXME: Remove Error conformance
extension String: Error {
    init(localizedKey: String) {
        self = NSLocalizedString(localizedKey, comment: "")
    }
    
    func isEqual(to conditions: [String]) -> Bool {
        if conditions.contains(self) {
            return true
        }
        
        return false
    }
}
