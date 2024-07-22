# VASynthesize


[![StandWithUkraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)
[![Support Ukraine](https://img.shields.io/badge/Support-Ukraine-FFD500?style=flat&labelColor=005BBB)](https://opensource.fb.com/support-ukraine)


[![Language](https://img.shields.io/badge/language-Swift%206.0-orangered.svg?style=flat)](https://www.swift.org)
[![SPM](https://img.shields.io/badge/SPM-compatible-limegreen.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20macOS%20%7C%20macCatalyst-lightgray.svg?style=flat)](https://developer.apple.com/discover)


Synthesizes a computed property for a variable or renamed function to simplify version migration.


### @VASynthesize


Example 1:


Synthesize variable


```swift
class SomeClass {
    @Synthesize("a")
    let _a = 1
}

// expands to
            
class SomeClass {
    let _a = 1

    var a: Int {
        _a
    }
}
```


Example 2:


Synthesize variable with deprecation and custom access modifier


```swift
open class SomeClass {
    @Synthesize("_a", modifier: .public, deprecation: .deprecated)
    open var a: Int { 1 }
}

// expands to

open class SomeClass {
    open var a: Int { 1 }

    @available(*, deprecated, message: "Use a instead.", renamed: "a")
    public var _a: Int {
        a
    }
}
```


Example 3:


Synthesize function


```swift
open class SomeClass {
    @Synthesize("someFunc", modifier: .inheritedNarrowContext)
    func _someFunc() {...}
}

// expands to

open class SomeClass {
    func _someFunc() {...}

    public func someFunc() {
        _someFunc()
    }
}
```


Example 4:


Synthesize function with deprecation and custom access modifier


```swift
class SomeClass {
    @Synthesize("_someFunc", deprecation: .deprecated)
    func someFunc(_ a: Int, b c: String) {...}
}

// expands to

class SomeClass {
    func someFunc(_ a: Int, b c: String) {...}

    @available(*, deprecated, message: "Use someFunc instead.", renamed: "someFunc")
    func _someFunc(_ a: Int, b c: String) {
        someFunc(a, b: c)
    }
}
```


## Author


Volodymyr Andriienko, vandrjios@gmail.com


## License


VASynthesize is available under the MIT license. See the LICENSE file for more info.
