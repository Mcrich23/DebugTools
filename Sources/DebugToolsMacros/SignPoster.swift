import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct SignPoster: BodyMacro {
    private struct InvalidFunction: Error, CustomStringConvertible {
        var description: String {
            "@SignPoster requires a function with a body."
        }
    }

    static func expansion(
        of node: AttributeSyntax,
        providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
        in context: some MacroExpansionContext
    ) throws -> [CodeBlockItemSyntax] {
        guard let function = declaration.as(FunctionDeclSyntax.self),
              let body = function.body else {
            throw InvalidFunction()
        }

        var subsystem: ExprSyntax = "\"BundleIdentifier\""
        var category: ExprSyntax = ".pointsOfInterest"
        if case .argumentList(let arguments) = node.arguments {
            for argument in arguments {
                switch argument.label?.text {
                case "subsystem":
                    subsystem = argument.expression
                case "category":
                    category = argument.expression
                default:
                    break
                }
            }
        }

        let requestedSubsystem = context.makeUniqueName("requestedSubsystem")
        let resolvedSubsystem = context.makeUniqueName("resolvedSubsystem")
        let signposter = context.makeUniqueName("signposter")
        let interval = context.makeUniqueName("signpostInterval")
        let name = StringLiteralExprSyntax(content: function.name.text)
        var statements = Array(body.statements)

        // Adding statements removes Swift's implicit return for a single-expression body.
        if statements.count == 1, function.signature.returnClause != nil,
           let expression = statements.first?.item.as(ExprSyntax.self) {
            statements = [CodeBlockItemSyntax(item: .stmt(StmtSyntax(
                ReturnStmtSyntax(expression: expression)
            )))]
        }

        return [
            "let \(requestedSubsystem) = \(subsystem)",
            "let \(resolvedSubsystem) = \(requestedSubsystem) == \"BundleIdentifier\" ? (Bundle.main.bundleIdentifier ?? \(requestedSubsystem)) : \(requestedSubsystem)",
            "let \(signposter) = OSSignposter(logHandle: OSLog(subsystem: \(resolvedSubsystem), category: \(category)))",
            "let \(interval) = \(signposter).beginInterval(\(name), id: \(signposter).makeSignpostID())",
            """
            defer {
                \(signposter).endInterval(\(name), \(interval))
            }
            """
        ] + statements
    }
}
