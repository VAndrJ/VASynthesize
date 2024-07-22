#if canImport(VASynthesizeMacros)
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import VASynthesizeMacros

let testMacros: [String: Macro.Type] = [
    "Synthesize": SynthesizeMacro.self,
]

final class VASynthesizeTests: XCTestCase {}
#endif
