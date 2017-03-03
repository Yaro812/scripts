#!/usr/bin/env xcrun swift

import Foundation

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
        let set = matchesForRegexInText(regex: "\\b\\w*\\b", text: text)
        let result = Array(set).sorted()
        print("Unique words found \(result.count)")
        let resultString = stringFrom(array: result)
        print("Prepared text")
        try? resultString.write(toFile: writePath, atomically: false, encoding: String.Encoding.utf8)
        print("Execution complete")
    }
}

func matchesForRegexInText(regex: String, text: String) -> Set<String> {
    guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
    
    let results = regex.matches(in: text,
                                options: [],
                                range: NSMakeRange(0, text.characters.count)) as [NSTextCheckingResult]
    let nsString = text as NSString
    return Set(results.map { nsString.substring(with: $0.range) })
}

func stringFrom(array: [String]) -> String {
    var idx = 1
    return array.reduce("") { idx += 1; return $0 + "\(idx). \($1)\n" }
}
