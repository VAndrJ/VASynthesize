import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SynthesizeMacro: PeerMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        if let decl = declaration.as(VariableDeclSyntax.self) {
            guard decl.bindings.count == 1, let name = decl.bindings.first?.pattern.trimmed, !name.is(TuplePatternSyntax.self) else {
                throw VASynthesizeMacroError.notSupported
            }

            let arguments = try getArguments(
                node: node,
                modifiers: decl.modifiers,
                context: context,
                variableName: name.description
            )
            var modifiers = decl.modifiers
            if let modifier = arguments.accessModifierKeyword {
                modifiers = modifiers.filter { modifier in
                    switch modifier.name.tokenKind {
                    case let .keyword(keyword):
                        switch keyword {
                        case .open, .public, .package, .internal, .fileprivate, .private:
                            return false
                        default:
                            return true
                        }
                    default:
                        return true
                    }
                }
                modifiers.append(DeclModifierSyntax(name: .keyword(modifier)))
            }

            return [
                DeclSyntax(
                    try VariableDeclSyntax("""
                    \(raw: (arguments.deprecationMessage.map { #"@available(*, deprecated, message: "\#($0)", renamed: "\#(name)")"# } ?? ""))
                    \(modifiers.with(\.trailingTrivia, Trivia()))\(raw: (modifiers.isEmpty ? "" : " "))var \(raw: arguments.name): \(try getType(declaration: decl))
                    """) {
                        if decl.isMutable {
                            AccessorDeclSyntax(accessorSpecifier: .keyword(.get)) {
                                "\(name)"
                            }
                            AccessorDeclSyntax(accessorSpecifier: .keyword(.set)) {
                                "\(name)\(raw: " = newValue")"
                            }
                        } else {
                            "\(name)"
                        }
                    }
                )
            ]
        } else if let decl = declaration.as(FunctionDeclSyntax.self) {
            let name = decl.name
            let arguments = try getArguments(
                node: node,
                modifiers: decl.modifiers,
                context: context,
                variableName: name.description
            )
            let parameters = decl.signature.parameterClause.parameters.map {
                var firstName: String? = $0.firstName.text
                if firstName == "_" {
                    firstName = nil
                }

                return (firstName, $0.secondName?.text)
            }.joinedParameters
            var modifiers = decl.modifiers
            var trivia = Trivia.newline
            if let modifier = arguments.accessModifierKeyword {
                modifiers = modifiers.filter { modifier in
                    switch modifier.name.tokenKind {
                    case let .keyword(keyword):
                        switch keyword {
                        case .open, .public, .package, .internal, .fileprivate, .private:
                            return false
                        default:
                            return true
                        }
                    default:
                        return true
                    }
                }
                modifiers.append(DeclModifierSyntax(name: .keyword(modifier)))
                trivia = .space
            }

            // TODO: - Generalize
            return [
                """
                \(raw: (arguments.deprecationMessage.map { #"@available(*, deprecated, message: "\#($0)", renamed: "\#(name)") "# } ?? ""))\(decl
                    .with(\.attributes, AttributeListSyntax())
                    .with(\.modifiers, modifiers)
                    .with(\.funcKeyword, decl.funcKeyword.with(\.leadingTrivia, trivia))
                    .with(\.name, .identifier(arguments.name))
                    .with(\.body, CodeBlockSyntax {
                        "\(name)(\(raw: parameters))"
                    })
                )
                """
            ]
        }

        throw VASynthesizeMacroError.notSupported
    }

    static func getType(declaration: VariableDeclSyntax) throws -> TypeSyntax {
        if let type = declaration.bindings.first?.typeAnnotation?.type.trimmed {
            return type
        } else {
            if let type = try declaration.bindings.first?.initializer?.value.getLiteralOrExprType() {
                return type
            }

            throw VASynthesizeMacroError.noType
        }
    }

    static func getArguments(
        node: AttributeSyntax,
        modifiers: DeclModifierListSyntax,
        context: some MacroExpansionContext,
        variableName: String
    ) throws -> Arguments {
        var name: String?
        var accessModifier: Keyword?
        var deprecation: String?
        var isModifierChecked = false

        node.arguments?.as(LabeledExprListSyntax.self)?.forEach { argument in
            if let nameArgument = argument.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text {
                name = nameArgument
            }
            if let arg = argument.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
                if argument.label?.text == "modifier" {
                    if let modifier = getModifier(
                        arg,
                        node: node,
                        modifiers: modifiers,
                        context: context
                    ) {
                        accessModifier = modifier
                    }
                    isModifierChecked = true
                }
                if let depr = getDeprecation(
                    arg,
                    node: node,
                    name: variableName
                ) {
                    deprecation = depr
                }
            }
            if let argument = argument.expression.as(FunctionCallExprSyntax.self), argument.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text == "deprecatedMessage", let depr = argument.arguments.first?.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text {
                deprecation = depr
            }
        }
        if !isModifierChecked && accessModifier == nil {
            accessModifier = getModifier(
                "inherited",
                node: node,
                modifiers: modifiers,
                context: context
            )
        }

        if let name {
            return Arguments(
                name: name,
                accessModifierKeyword: accessModifier,
                deprecationMessage: deprecation
            )
        } else {
            throw VASynthesizeMacroError.wrongArguments
        }
    }

    static func getModifier(
        _ parameter: String,
        node: AttributeSyntax,
        modifiers: DeclModifierListSyntax,
        context: some MacroExpansionContext
    ) -> Keyword? {
        switch parameter {
        case "inheritedNarrowContext":
            switch getSurroundingAccessModifierKeyword(context: context) {
            case .open, .public: .public
            case .package: .package
            case .fileprivate: .fileprivate
            case .internal, .private: .internal
            default: nil
            }
        case "inheritedContext": getSurroundingAccessModifierKeyword(context: context)
        case "inherited": getModifierKeyword(modifiers: modifiers)
        case "open": .open
        case "public": .public
        case "package": .package
        case "internal": .internal
        case "fileprivate": .fileprivate
        case "private": .private
        default: nil
        }
    }

    static func getDeprecation(
        _ parameter: String,
        node: AttributeSyntax,
        name: String
    ) -> String? {
        switch parameter {
        case "deprecated":
            return "Use \(name) instead."
        case "deprecatedMessage":
            return ""
        default:
            return nil
        }
    }

    static func getSurroundingAccessModifierKeyword(context: some MacroExpansionContext) -> Keyword? {
        for syntax in context.lexicalContext {
            if let modifiers = syntax.as(ClassDeclSyntax.self)?.modifiers ?? syntax.as(StructDeclSyntax.self)?.modifiers ?? syntax.as(EnumDeclSyntax.self)?.modifiers {
                if let modifier = getModifierKeyword(modifiers: modifiers) {
                    return modifier
                }
            }
        }

        return nil
    }

    static func getModifierKeyword(modifiers: DeclModifierListSyntax) -> Keyword? {
        for modifier in modifiers {
            switch modifier.name.tokenKind {
            case let .keyword(keyword):
                switch keyword {
                case .open, .public, .package, .internal, .fileprivate, .private:
                    return keyword
                default:
                    continue
                }
            default:
                continue
            }
        }

        return nil
    }
}

@main
struct VASynthesizePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SynthesizeMacro.self,
    ]
}
