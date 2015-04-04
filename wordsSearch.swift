#!/usr/bin/env xcrun swift

import Foundation

func unique(source: [String]) -> [String] {
    var buffer = [String]()
    var previous = String()
    for elem in source {
        if elem != previous {
            buffer.append(elem)
        }
        previous = elem
    }
    return buffer
}

func uniqueOrdered(array: [String]) -> [String] {
    let result = sorted(array, <)
    println("Words sorted")
    return unique(result)
}

func matchesForRegexInText(regex: String!, text: String!) -> [String] {
    
    let regex = NSRegularExpression(pattern: regex,
        options: nil, error: nil)!
    let nsString = text as NSString
    let results = regex.matchesInString(nsString,
        options: nil, range: NSMakeRange(0, nsString.length))
        as [NSTextCheckingResult]
    return map(results) { nsString.substringWithRange($0.range)}
}

func stringFromArray(data: [String]) -> String {
    var result = String()
    for (idx, word) in enumerate(data) {
        result += ("\(idx+1). \(word)\n")
    }
    return result
}

//main

println("Script activated")
var args = Process.arguments
var inFile, outFile : String?
for (idx, arg) in enumerate(args) {
    switch idx {
    case 1:
        println("File to read from: \(arg)")
        inFile = arg
    case 2:
        println("File to write to: \(arg)")
        outFile = arg
    default:
        break
    }
}

if inFile != nil && outFile != nil  {
    let file = "\(outFile!).txt"
    let dir = "\(NSHomeDirectory())/Desktop/"
    let readPath = "\(dir)\(inFile!)"
    let writePath = "\(dir)\(outFile!)"
    
    println("Reading")
    let text = String(contentsOfFile: readPath, encoding: NSUTF8StringEncoding, error: nil)
    
    println("Finding words")
    var result = matchesForRegexInText("\\b\\w*\\b", text)
    println("\(result.count) words found")
    
    result = uniqueOrdered(result)
    println("Unique words found \(result.count)")
    
    let resultString = stringFromArray(result)
    println("Prepared text")
    
    resultString.writeToFile(writePath, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
    println("Execution complete")
}
