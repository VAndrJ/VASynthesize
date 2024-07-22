// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(peer, names: arbitrary)
public macro Synthesize(
    _ name: String,
    modifier: AccessModifier = .inherited,
    deprecation: Deprecation = .notDeprecated
) = #externalMacro(module: "VASynthesizeMacros", type: "SynthesizeMacro")

public enum Deprecation {
    case notDeprecated
    case deprecated
    case deprecatedMessage(String)
}

public enum AccessModifier {
    /// Inherits an access modifier from the surrounding context (class/struct/enum/extension)
    case inheritedContext
    /// Inherits an access modifier from the surrounding context (class/struct/enum/extension) and narrows it: `open` becomes `public`, `private` becomes `internal`.
    case inheritedNarrowContext
    /// Inherits the access modifier.
    case inherited
    /// Add or replace the access modifier with the `open` keyword.
    case `open`
    /// Add or replace the access modifier with the `public` keyword.
    case `public`
    /// Add or replace the access modifier with the `package` keyword.
    case `package`
    /// Add or replace the access modifier with the `internal` keyword.
    case `internal`
    /// Add or replace the access modifier with the `fileprivate` keyword.
    case `fileprivate`
    /// Add or replace the access modifier with the `private` keyword.
    case `private`
}
