//
//  VASynthesizeTests+Variable.swift
//  VASynthesize
//
//  Created by VAndrJ on 21.07.2024.
//

#if canImport(VASynthesizeMacros)
import SwiftSyntaxMacrosTestSupport
import XCTest
import VASynthesizeMacros

extension VASynthesizeTests {

    func test_Variable_DefaultParameters_Var() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("d")
                var _d = Optional(1)
                @Synthesize("c")
                class var _c = 1
                @Synthesize("b")
                static var _b = 1
                @Synthesize("a")
                var _a: Int = 1
            }
            """,
            expandedSource: """
            class SomeClass {
                var _d = Optional(1)
            
                var d: Int? {
                    get {
                        _d
                    }
                    set {
                        _d = newValue
                    }
                }
                class var _c = 1
            
                class var c: Int {
                    get {
                        _c
                    }
                    set {
                        _c = newValue
                    }
                }
                static var _b = 1
            
                static var b: Int {
                    get {
                        _b
                    }
                    set {
                        _b = newValue
                    }
                }
                var _a: Int = 1
            
                var a: Int {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Let() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("b")
                static let _b = "b"
                @Synthesize("a")
                let _a: Int = 1
            }
            """,
            expandedSource: """
            class SomeClass {
                static let _b = "b"
            
                static var b: String {
                    _b
                }
                let _a: Int = 1
            
                var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Let_Implicit() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                let _a = 1
            }
            """,
            expandedSource: """
            class SomeClass {
                let _a = 1
            
                var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Var_Implicit_Int() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                var _a = 1
            }
            """,
            expandedSource: """
            class SomeClass {
                var _a = 1
            
                var a: Int {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Var_Implicit_IntArray() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                var _a = [1]
            }
            """,
            expandedSource: """
            class SomeClass {
                var _a = [1]
            
                var a: [Int] {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Var_Implicit_String() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                var _a = "1"
            }
            """,
            expandedSource: """
            class SomeClass {
                var _a = "1"
            
                var a: String {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Var_Implicit_StringArray() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                var _a = ["1"]
            }
            """,
            expandedSource: """
            class SomeClass {
                var _a = ["1"]
            
                var a: [String] {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Var_Implicit_Floating() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                var _a = 1.0
            }
            """,
            expandedSource: """
            class SomeClass {
                var _a = 1.0
            
                var a: Double {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Var_Implicit_FloatingArray() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                var _a = [1.0]
            }
            """,
            expandedSource: """
            class SomeClass {
                var _a = [1.0]
            
                var a: [Double] {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Var_Implicit_Bool() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                var _a = true
            }
            """,
            expandedSource: """
            class SomeClass {
                var _a = true
            
                var a: Bool {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Var_Implicit_BoolArray() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                var _a = [true]
            }
            """,
            expandedSource: """
            class SomeClass {
                var _a = [true]
            
                var a: [Bool] {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Var_Implicit_Custom() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                var _a = SomeCustomType(t: 1)
            }
            """,
            expandedSource: """
            class SomeClass {
                var _a = SomeCustomType(t: 1)
            
                var a: SomeCustomType {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_DefaultParameters_Var_Implicit_CustomArray() throws {
        assertMacroExpansion(
            """
            class SomeClass {
                @Synthesize("a")
                var _a = [SomeCustomType(t: 1)]
            }
            """,
            expandedSource: """
            class SomeClass {
                var _a = [SomeCustomType(t: 1)]
            
                var a: [SomeCustomType] {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Computed() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a")
                private var _a: Int { 1 }
            }
            """,
            expandedSource: """
            open class SomeClass {
                private var _a: Int { 1 }
            
                private var a: Int {
                    _a
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Computed_GetterSetter() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a")
                private var _a: Int { 
                    get { 1 }
                    set {}
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                private var _a: Int { 
                    get { 1 }
                    set {}
                }
            
                private var a: Int {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_Variable_Initialized() throws {
        assertMacroExpansion(
            """
            open class SomeClass {
                @Synthesize("a")
                private var _a: Int
                
                public init(a: Int) {
                    self._a = a
                }
            }
            """,
            expandedSource: """
            open class SomeClass {
                private var _a: Int
            
                private var a: Int {
                    get {
                        _a
                    }
                    set {
                        _a = newValue
                    }
                }
                
                public init(a: Int) {
                    self._a = a
                }
            }
            """,
            macros: testMacros
        )
    }
}
#endif
