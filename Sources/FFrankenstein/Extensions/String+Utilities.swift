//
//  String+Utilities.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 10/29/18.
//

import Foundation
import Files

extension String {
    init(localizedKey: String) {
        self = NSLocalizedString(localizedKey, comment: "")
    }
    
    func chomp() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func encapsulated() -> String {
        return "\"\(self)\""
    }
    
    var isDirectory: Bool {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: self, isDirectory: &isDir) {
            return isDir.boolValue
        } else {
            return false
        }
    }
    
    var isFile: Bool {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: self, isDirectory: &isDir) {
            return !isDir.boolValue
        } else {
            return false
        }
    }
    
    func isEqual(to conditions: [String]) -> Bool {
        if conditions.contains(self) {
            return true
        }
        
        return false
    }
    
    func expandingTildeInPath() -> String {
        return replacingOccurrences(of: "~/", with: FileSystem().homeFolder.path)
    }
}
