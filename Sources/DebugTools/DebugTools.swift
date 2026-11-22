// The Swift Programming Language
// https://docs.swift.org/swift-book

@_exported import Foundation
@_exported import OSLog

/// Measures a function's execution with a signpost interval, ending it on every exit.
@attached(body)
public macro SignPoster(subsystem: String? = nil, category: OSLog.Category) = #externalMacro(module: "DebugToolsMacros", type: "SignPoster")

/// Measures a function's execution with a signpost interval, ending it on every exit.
@attached(body)
public macro SignPoster(subsystem: String? = nil, category: String) = #externalMacro(module: "DebugToolsMacros", type: "SignPoster")
