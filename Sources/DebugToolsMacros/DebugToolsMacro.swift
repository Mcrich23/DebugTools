import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct DebugToolsPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SignPoster.self,
    ]
}
