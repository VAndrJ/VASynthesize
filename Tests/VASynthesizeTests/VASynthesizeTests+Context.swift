//
//  VASynthesizeTests+Context.swift
//  VASynthesize
//
//  Created by VAndrJ on 21.07.2024.
//

#if canImport(VASynthesizeMacros)
import SwiftSyntaxMacrosTestSupport
import XCTest
import VASynthesizeMacros

extension VASynthesizeTests {

    func test_Variable_Extension() throws {
        assertMacroExpansion(
            """
            public protocol SomeProtocol {
                var c: Int { get set }
            }

            extension SomeProtocol {
                @Synthesize("_d", deprecation: .deprecated)
                var d: Int { c }
            }
            """,
            expandedSource: """
            public protocol SomeProtocol {
                var c: Int { get set }
            }

            extension SomeProtocol {
                var d: Int { c }

                @available(*, deprecated, message: "Use d instead.", renamed: "d")
                var _d: Int {
                    d
                }
            }
            """,
            macros: testMacros
        )
    }
}
#endif
