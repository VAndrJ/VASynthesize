//
//  VASynthesizeTests+Function.swift
//  VASynthesize
//
//  Created by VAndrJ on 21.07.2024.
//

#if canImport(VASynthesizeMacros)
import SwiftSyntaxMacrosTestSupport
import XCTest
import VASynthesizeMacros

extension VASynthesizeTests {

    func test_Function() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("someFunc")
                func _someFunc() {
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                func _someFunc() {
                }

                func someFunc() {
                    _someFunc()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_Parameter() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("someFunc")
                func _someFunc(a: Int) {
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                func _someFunc(a: Int) {
                }
            
                func someFunc(a: Int) {
                    _someFunc(a: a)
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_MultipleParameter() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("someFunc")
                func _someFunc(_ a: Int, b c: String) {
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                func _someFunc(_ a: Int, b c: String) {
                }
            
                func someFunc(_ a: Int, b c: String) {
                    _someFunc(a, b: c)
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_Deprecation() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("_someFunc", deprecation: .deprecated)
                func someFunc(_ a: Int, b c: String) {
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                func someFunc(_ a: Int, b c: String) {
                }
            
                @available(*, deprecated, message: "Use someFunc instead.", renamed: "someFunc")
                func _someFunc(_ a: Int, b c: String) {
                    someFunc(a, b: c)
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_DeprecationMessage() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("_someFunc", deprecation: .deprecatedMessage("Don't use"))
                func someFunc(_ a: Int, b c: String) {
                }
            }
            """,
            expandedSource: """
            class SomeClass {
                func someFunc(_ a: Int, b c: String) {
                }
            
                @available(*, deprecated, message: "Don't use", renamed: "someFunc")
                func _someFunc(_ a: Int, b c: String) {
                    someFunc(a, b: c)
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_Inherited() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("someFunc", modifier: .inherited)
                public func _someFunc() {
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                public func _someFunc() {
                }

                public func someFunc() {
                    _someFunc()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_Private() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("someFunc", modifier: .private)
                func _someFunc() {
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                func _someFunc() {
                }

                private func someFunc() {
                    _someFunc()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_FilePrivate() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("someFunc", modifier: .fileprivate)
                func _someFunc() {
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                func _someFunc() {
                }

                fileprivate func someFunc() {
                    _someFunc()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_Internal() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("someFunc", modifier: .internal)
                func _someFunc() {
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                func _someFunc() {
                }

                internal func someFunc() {
                    _someFunc()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_Package() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("someFunc", modifier: .package)
                func _someFunc() {
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                func _someFunc() {
                }

                package func someFunc() {
                    _someFunc()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_Public() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("someFunc", modifier: .public)
                func _someFunc() {
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                func _someFunc() {
                }

                public func someFunc() {
                    _someFunc()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_Open() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("someFunc", modifier: .open)
                func _someFunc() {
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                func _someFunc() {
                }

                open func someFunc() {
                    _someFunc()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_InheritedContext() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("someFunc", modifier: .inheritedContext)
                func _someFunc() {
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                func _someFunc() {
                }

                open func someFunc() {
                    _someFunc()
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Function_InheritedNarrowContext() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("someFunc", modifier: .inheritedNarrowContext)
                func _someFunc() {
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                func _someFunc() {
                }

                public func someFunc() {
                    _someFunc()
                }
            }
            """,
            macros: testMacros
        )
    }
}
#endif
