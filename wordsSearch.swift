#!/usr/bin/env xcrun swift

import Foundation

func unique(source: [String]) -> [String] {
    var previous = String()
    return source.flatMap {
        if $0 != previous { previous = $0; return $0 }
        return nil
    }
}

func uniqueOrdered(array: [String]) -> [String] {
    let result = array.sorted()
    print("Words sorted")
    return unique(source: result)
}

func matchesForRegexInText(regex: String, text: String) -> [String] {
    guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
    
    let results = regex.matches(in: text,
                                options: [],
                                range: NSMakeRange(0, text.characters.count)) as [NSTextCheckingResult]
    let nsString = text as NSString
    return results.map { nsString.substring(with: $0.range) }
}

func stringFromArray(data: [String]) -> String {
    var result = String()
    for (idx, word) in data.enumerated() {
        result += ("\(idx+1). \(word)\n")
    }
    return result
}

//main

print("Script activated")
var args = CommandLine.arguments
var inFile, outFile : String?
for (idx, arg) in args.enumerated() {
    switch idx {
    case 1:
        print("File to read from: \(arg)")
        inFile = arg
    case 2:
        print("File to write to: \(arg)")
        outFile = arg
    default:
        break
    }
}

if let inF = inFile, let outF = outFile {
    let file = "\(outF).txt"
    let dir = "\(NSHomeDirectory())/Desktop/"
    let readPath = "\(dir)\(inF)"
    let writePath = "\(dir)\(outF)"
    
    print("Reading")
    if let text = try? String(contentsOfFile: readPath, encoding: String.Encoding.utf8) {
        print("Finding words")
        var result = matchesForRegexInText(regex: "\\b\\w*\\b", text: text)
        print("\(result.count) words found")
        
        result = uniqueOrdered(array: result)
        print("Unique words found \(result.count)")
        
        let resultString = stringFromArray(data: result)
        print("Prepared text")
        
        try? resultString.write(toFile: writePath, atomically: false, encoding: String.Encoding.utf8)
        print("Execution complete")
    }
}
