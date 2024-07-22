import VASynthesize

class SomeClass {
    @Synthesize("a")
    var _a = 1
    @Synthesize("_b", deprecation: .deprecated)
    var b = "1"

    @Synthesize("getA")
    func _getA() -> Int {
        _a
    }
}

let someClass = SomeClass()
assert(1 == someClass.a)
someClass.a = 2
assert(2 == someClass._a)
assert(someClass.getA() == someClass._getA())

assert("1" == someClass._b) // Should show deprecation warning
someClass._b = "2" // Should show deprecation warning
assert("2" == someClass.b)

struct SomeStruct {
    @Synthesize("a")
    var _a = 1

    @Synthesize("_calculate", deprecation: .deprecated)
    func calculate(a: Int, _ b: String) -> Int {
        a + (Int(b) ?? 0)
    }
}

var someStruct = SomeStruct()
assert(1 == someStruct.a)
someStruct.a = 2
assert(2 == someStruct._a)
assert(2 == someStruct.calculate(a: 1, "1"))
assert(2 == someStruct._calculate(a: 1, "1")) // Should show deprecation warning

enum SomeEnum: Int {
    case first = 1

    @Synthesize("_a", deprecation: .deprecatedMessage("Don't use"))
    var a: Int { rawValue }
}

let someEnum = SomeEnum.first
assert(1 == someEnum.a)
assert(1 == someEnum._a) // Should show deprecation warning

public protocol SomeProtocol {
    var c: Int { get set }
}

extension SomeProtocol {

    @Synthesize("_d", deprecation: .deprecated)
    var d: Int { c }
}
