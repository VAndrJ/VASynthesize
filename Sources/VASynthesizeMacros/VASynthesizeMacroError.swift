//
//  VASynthesizeMacroError.swift
//  VASynthesize
//
//  Created by VAndrJ on 21.07.2024.
//

enum VASynthesizeMacroError: Error, CustomStringConvertible {
    case notSupported
    case wrongArguments
    case noType

    var description: String {
        switch self {
        case .notSupported: "Attaching to this type is not supported"
        case .wrongArguments: "Wrong arguments"
        case .noType: "Unable to infer type"
        }
    }
}
