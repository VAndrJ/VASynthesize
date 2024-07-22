//
//  VASynthesizeTests+Deprecated.swift
//  VASynthesize
//
//  Created by VAndrJ on 21.07.2024.
//

#if canImport(VASynthesizeMacros)
import SwiftSyntaxMacrosTestSupport
import XCTest
import VASynthesizeMacros

extension VASynthesizeTests {

    func test_Deprecation_NotDeprecated() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("_a", deprecation: .notDeprecated)
                public let a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                public let a: Int = 1
            
                public var _a: Int {
                    a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Deprecation_Deprecated() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("_a", deprecation: .deprecated)
                public let a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                public let a: Int = 1
            
                @available(*, deprecated, message: "Use a instead.", renamed: "a")
                public var _a: Int {
                    a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Deprecation_DeprecatedMessage() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("_a", deprecation: .deprecatedMessage("Don't use"))
                public let a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                public let a: Int = 1
            
                @available(*, deprecated, message: "Don't use", renamed: "a")
                public var _a: Int {
                    a
                }
            }
            """,
            macros: testMacros
        )
    }
}
#endif
