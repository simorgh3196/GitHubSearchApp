//
//  KeyPath.swift
//  Himotoki
//
//  Created by Syo Ikeda on 6/5/15.
//  Copyright (c) 2015 Syo Ikeda. All rights reserved.
//

public struct KeyPath: Hashable {
    public let components: [String]

    public init(_ key: String) {
        self.init([key])
    }

    public init(_ components: [String]) {
        self.components = components
    }

    public static var empty: KeyPath {
        return KeyPath([])
    }
}

public func == (lhs: KeyPath, rhs: KeyPath) -> Bool {
    return lhs.components == rhs.components
}

public func + (lhs: KeyPath, rhs: KeyPath) -> KeyPath {
    return KeyPath(lhs.components + rhs.components)
}

extension KeyPath {
    public var hashValue: Int {
        return components.reduce(0) { $0 ^ $1.hashValue }
    }
}

extension KeyPath: CustomStringConvertible {
    public var description: String {
        return "KeyPath(\(components))"
    }
}

extension KeyPath: StringLiteralConvertible {
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension KeyPath: ArrayLiteralConvertible {
    public init(arrayLiteral elements: String...) {
        self.init(elements)
    }
}

extension KeyPath: NilLiteralConvertible {
    public init(nilLiteral: ()) {
        self.init([])
    }
}
