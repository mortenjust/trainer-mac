//
//  Util.swift
//  Shellpad
//
//  Created by Morten Just Petersen on 11/1/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class Util: NSObject {

    func findMatchesInString(_ rawdata:String, regex:String) -> [String]? {
        do {
            let re = try NSRegularExpression(pattern: regex,
                options: NSRegularExpression.Options.caseInsensitive)
            
            let matches = re.matches(in: rawdata,
                options: NSRegularExpression.MatchingOptions.reportProgress,
                range:
                NSRange(location: 0, length: rawdata.utf16.count))
            
            if matches.count != 0 {
                var results = [String]()
                for match in matches {
                    let result = (rawdata as NSString).substring(with: match.rangeAt(1))
                    results.append(result)
                }
                return results
            }
            else {
                return nil
            }
            
        } catch {
            print("Problem!")
            return nil
        }
    }
}
