//
//  vec3.swift
//  raytracer1
//
//  Created by Anthony Clark on 12/24/20.
//

// TODO: Try SIMD Vectors

typealias Scalar = Double

// Add clamping to Scalar
extension Scalar {
    func clamped(lo: Self, hi: Self) -> Self {
        return min(max(self, lo), hi)
    }
}

struct Vec3 {
    let i: Scalar
    let j: Scalar
    let k: Scalar
}

extension Vec3 {
    
    func lengthSquared() -> Scalar {
        return i * i + j * j + k * k
    }
    
    func length() -> Scalar {
        return lengthSquared().squareRoot()
    }
    
    func getUnit() -> Vec3 {
        return self / self.length()
    }
    
    func getClamped(lo: Scalar, hi: Scalar) -> Vec3 {
        return Vec3(
            i: self.i.clamped(lo: lo, hi: hi),
            j: self.j.clamped(lo: lo, hi: hi),
            k: self.k.clamped(lo: lo, hi: hi)
        )
    }
    
    static func getRandom(lo: Scalar = 0, hi: Scalar = 1) -> Vec3 {
        return Vec3(
            i: Scalar.random(in: lo ... hi),
            j: Scalar.random(in: lo ... hi),
            k: Scalar.random(in: lo ... hi)
        )
    }
    
    static func getRandomInUnitSphere() -> Vec3 {
        var randomVec: Vec3
        repeat {
            randomVec = Vec3.getRandom(lo: -1, hi: 1)
        } while randomVec.lengthSquared() >= 1
        return randomVec
    }
    
    static func getRandomUnitVector() -> Vec3 {
        return getRandomInUnitSphere().getUnit()
    }
    
    static func getRandomInHemisphere(normal: Vec3) -> Vec3 {
        let inUnitSphere = Vec3.getRandomInUnitSphere()
        return dot(a: inUnitSphere, b: normal) > 0 ? inUnitSphere : -inUnitSphere
    }
    
    static prefix func - (vec: Vec3) -> Vec3 {
        return Vec3(i: -vec.i, j: -vec.j, k: -vec.k)
    }
    
    static func + (lhs: Vec3, rhs: Vec3) -> Vec3 {
        return Vec3(i: lhs.i + rhs.i, j: lhs.j + rhs.j, k: lhs.k + rhs.k)
    }
    
    static func - (lhs: Vec3, rhs: Vec3) -> Vec3 {
        return Vec3(i: lhs.i - rhs.i, j: lhs.j - rhs.j, k: lhs.k - rhs.k)
    }

    static func * (lhs: Vec3, rhs: Scalar) -> Vec3 {
        return Vec3(i: lhs.i * rhs, j: lhs.j * rhs, k: lhs.k * rhs)
    }
    
    static func * (lhs: Scalar, rhs: Vec3) -> Vec3 {
        return rhs * lhs
    }
    
    static func / (lhs: Vec3, rhs: Scalar) -> Vec3 {
        return Vec3(i: lhs.i / rhs, j: lhs.j / rhs, k: lhs.k / rhs)
    }
    
    static func += (lhs: inout Vec3, rhs: Vec3) {
        lhs = lhs + rhs
    }
}

func dot(a: Vec3, b: Vec3) -> Scalar {
    return a.i * b.i + a.j * b.j + a.k * b.k
}

typealias Color = Vec3
extension Color {
    init(r: Scalar, g: Scalar, b: Scalar) {
        self.init(i: r, j: g, k: b)
    }
    
    var r: Scalar { return i }
    var g: Scalar { return j }
    var b: Scalar { return k }
    
    func toString255() -> String {
        let clampedColor = self.getClamped(lo: 0, hi: 0.999)
        let r255 = Int(256 * clampedColor.r);
        let g255 = Int(256 * clampedColor.g);
        let b255 = Int(256 * clampedColor.b);
        return "\(r255) \(g255) \(b255)"
    }
}

typealias Point = Vec3
extension Point {
    init(x: Scalar, y: Scalar, z: Scalar) {
        self.init(i: x, j: y, k: z)
    }
    
    var x: Scalar { return i }
    var y: Scalar { return j }
    var z: Scalar { return k }
}
