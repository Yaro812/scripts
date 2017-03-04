#!/usr/bin/env xcrun swift

import Foundation
import Darwin

let start = CFAbsoluteTimeGetCurrent()
var timeFromStart: Double { return CFAbsoluteTimeGetCurrent() - start }
var timePrefix: String { return String(format: "%.3f", timeFromStart) + "s. passed: " }

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

func printHelp() {
    print("\n please write arguments in the following format:\n"
        + "./wordsSearch.swift <SOURCE TEXT FILE> <RESULT TEXT FILE>"
        + "\n\n Please be adviced that both files should be put to Desktop first")
}

func printError(text: String) {
    print("\(text). Type ./wordsSearch.swift help for help")
}

//main

print("Script activated")
var args = CommandLine.arguments
var inFile, outFile : String?
guard args.count > 2 else {
    if args[1] == "help" {
        printHelp()
    } else {
        printError(text: "Wrong args")
    }
    exit(0)
}

for (idx, arg) in args.enumerated() {
    switch idx {
    case 1:
        print("\(timePrefix)File to read from: \(arg)")
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
    
    print("\(timePrefix)Reading")
    if let text = try? String(contentsOfFile: readPath, encoding: String.Encoding.utf8) {
        print("\(timePrefix)Finding words")
        let set = matchesForRegexInText(regex: "\\b\\w*\\b", text: text)
        let result = Array(set).sorted()
        print("\(timePrefix)Unique words found \(result.count)")
        let resultString = stringFrom(array: result)
        print("\(timePrefix)Prepared text")
        try? resultString.write(toFile: writePath, atomically: false, encoding: String.Encoding.utf8)
        print("\(timePrefix)Execution complete")
    } else {
        printError(text: "Couldn't read")
    }
} else {
    printError(text: "An error occured")
}

