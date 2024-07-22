//
//  VASynthesizeTests+Modifier.swift
//  VASynthesize
//
//  Created by VAndrJ on 21.07.2024.
//

#if canImport(VASynthesizeMacros)
import SwiftSyntaxMacrosTestSupport
import XCTest
import VASynthesizeMacros

extension VASynthesizeTests {

    func test_Variable_Modifier_inheritedNarrowContext_Open() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .inheritedNarrowContext)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                private let _a: Int = 1
            
                public var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedNarrowContext_Public() throws {
        assertMacroExpansion(
            """
            public class SomeClass {
                @Synthesize("a", modifier: .inheritedNarrowContext)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            public class SomeClass {
                private let _a: Int = 1
            
                public var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedNarrowContext_Package() throws {
        assertMacroExpansion(
            """
            package class SomeClass {
                @Synthesize("a", modifier: .inheritedNarrowContext)
                let _a: Int = 1
            }
            """,
            expandedSource: """
            package class SomeClass {
                let _a: Int = 1
            
                package var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedNarrowContext_Internal() throws {
        assertMacroExpansion(
            """
            internal class SomeClass {
                @Synthesize("a", modifier: .inheritedNarrowContext)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            internal class SomeClass {
                private let _a: Int = 1
            
                internal var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedNarrowContext_FilePrivate() throws {
        assertMacroExpansion(
            """
            fileprivate class SomeClass {
                @Synthesize("a", modifier: .inheritedNarrowContext)
                let _a: Int = 1
            }
            """,
            expandedSource: """
            fileprivate class SomeClass {
                let _a: Int = 1
            
                fileprivate var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedNarrowContext_Private() throws {
        assertMacroExpansion(
            """
            private class SomeClass {
                @Synthesize("a", modifier: .inheritedNarrowContext)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            private class SomeClass {
                private let _a: Int = 1
            
                internal var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedContext_Open() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .inheritedContext)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                private let _a: Int = 1
            
                open var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedContext_Public() throws {
        assertMacroExpansion(
            """
            public class SomeClass {
                @Synthesize("a", modifier: .inheritedContext)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            public class SomeClass {
                private let _a: Int = 1
            
                public var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedContext_Package() throws {
        assertMacroExpansion(
            """
            package class SomeClass {
                @Synthesize("a", modifier: .inheritedContext)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            package class SomeClass {
                private let _a: Int = 1
            
                package var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedContext_Internal() throws {
        assertMacroExpansion(
            """
            internal class SomeClass {
                @Synthesize("a", modifier: .inheritedContext)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            internal class SomeClass {
                private let _a: Int = 1
            
                internal var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedContext_FilePrivate() throws {
        assertMacroExpansion(
            """
            fileprivate class SomeClass {
                @Synthesize("a", modifier: .inheritedContext)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            fileprivate class SomeClass {
                private let _a: Int = 1
            
                fileprivate var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_inheritedContext_Private() throws {
        assertMacroExpansion(
            """
            private class SomeClass {
                @Synthesize("a", modifier: .inheritedContext)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            private class SomeClass {
                private let _a: Int = 1
            
                private var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Open() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .open)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                private let _a: Int = 1
            
                open var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Public() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .public)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                private let _a: Int = 1
            
                public var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Package() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .package)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                private let _a: Int = 1
            
                package var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Internal() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .internal)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                private let _a: Int = 1
            
                internal var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_FilePrivate() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .fileprivate)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                private let _a: Int = 1
            
                fileprivate var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Private() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .private)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                private let _a: Int = 1
            
                private var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Inheirted_Private() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .inherited)
                private let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                private let _a: Int = 1
            
                private var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Inheirted_FilePrivate() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .inherited)
                fileprivate let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                fileprivate let _a: Int = 1
            
                fileprivate var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Inheirted_Internal() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .inherited)
                internal let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                internal let _a: Int = 1
            
                internal var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Inheirted_Default() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .inherited)
                let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                let _a: Int = 1
            
                var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Inheirted_Package() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .inherited)
                package let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                package let _a: Int = 1
            
                package var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Inheirted_Public() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .inherited)
                public let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                public let _a: Int = 1
            
                public var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Modifier_Inheirted_Open() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a", modifier: .inherited)
                open let _a: Int = 1
            }
            """,
            expandedSource: """
            open class SomeClass {
                open let _a: Int = 1
            
                open var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }
}
#endif
