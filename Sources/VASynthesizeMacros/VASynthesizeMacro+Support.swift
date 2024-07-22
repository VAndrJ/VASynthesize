//
//  VASynthesizeMacro+Support.swift
//  VASynthesize
//
//  Created by VAndrJ on 21.07.2024.
//

import SwiftSyntax

extension ExprSyntax {

    func getLiteralOrExprType() throws -> TypeSyntax? {
        if self.is(StringLiteralExprSyntax.self) {
            return TypeSyntax("String")
        } else if self.is(IntegerLiteralExprSyntax.self) {
            return TypeSyntax("Int")
        } else if self.is(BooleanLiteralExprSyntax.self) {
            return TypeSyntax("Bool")
        } else if self.is(FloatLiteralExprSyntax.self) {
            return TypeSyntax("Double")
        } else if let arr = try self.as(ArrayExprSyntax.self)?.elements.first?.expression.getLiteralOrExprType() {
            return TypeSyntax("[\(raw: arr)]")
        } else if let member = self.as(MemberAccessExprSyntax.self)?.base?.description {
            return TypeSyntax("\(raw: member)")
        } else if let expr = self.as(FunctionCallExprSyntax.self), let member = expr.calledExpression.as(MemberAccessExprSyntax.self)?.base?.description ?? expr.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text {
            if member == "Optional" {
                if let argumentType = try expr.arguments.first?.expression.getLiteralOrExprType() {
                    return TypeSyntax("\(raw: argumentType)?")
                }
            } else {
                return TypeSyntax("\(raw: member)")
            }
        }

        return nil
    }
}

private let letKeyword: TokenKind = .keyword(.let)

extension VariableDeclSyntax {
    public var isLet: Bool { bindingSpecifier.tokenKind == letKeyword }
    public var isMutable: Bool {
        if isLet {
            false
        } else {
            bindings.first?.accessorBlock == nil && bindings.first?.initializer == nil ||
            bindings.first?.initializer != nil ||
            bindings.first?.accessorBlock?.accessors.as(AccessorDeclListSyntax.self)?.contains(where: { $0.accessorSpecifier.tokenKind == .keyword(.set) }) == true
        }
    }
}

extension Array where Element == (String?, String?) {
    var joinedParameters: String {
        var arr: [String] = []
        for element in self {
            if let firstName = element.0, let secondName = element.1 {
                arr.append("\(firstName): \(secondName)")
            } else if let firstName = element.0 {
                arr.append("\(firstName): \(firstName)")
            } else if let secondName = element.1 {
                arr.append(secondName)
            }
        }

        return arr.joined(separator: ", ")
    }
}

struct Arguments {
    let name: String
    let accessModifierKeyword: Keyword?
    let deprecationMessage: String?
}
