//
//  Vec.swift
//  raytracer1
//
//  Created by Anthony Clark on 12/24/20.
//

// TODO: Try SIMD Vectors

import Foundation

typealias Scalar = Double

// Add clamping to Scalar
extension Scalar {
    func clamped(lo: Self, hi: Self) -> Self {
        return min(max(self, lo), hi)
    }
}

struct Vec {
    let i: Scalar
    let j: Scalar
    let k: Scalar
}

extension Vec {
    
    func lengthSquared() -> Scalar {
        return i * i + j * j + k * k
    }
    
    func length() -> Scalar {
        return lengthSquared().squareRoot()
    }
    
    func getUnit() -> Vec {
        return self / self.length()
    }
    
    func getClamped(lo: Scalar, hi: Scalar) -> Vec {
        return Vec(
            i: self.i.clamped(lo: lo, hi: hi),
            j: self.j.clamped(lo: lo, hi: hi),
            k: self.k.clamped(lo: lo, hi: hi)
        )
    }
    
    func nearZero() -> Bool {
        let epsilon = 1e-8;
        return abs(i) < epsilon && abs(j) < epsilon && abs(k) < epsilon
    }
    
    static func getRandom(lo: Scalar = 0, hi: Scalar = 1) -> Vec {
        return Vec(
            i: Scalar.random(in: lo ... hi),
            j: Scalar.random(in: lo ... hi),
            k: Scalar.random(in: lo ... hi)
        )
    }
    
    static func getRandomInUnitSphere() -> Vec {
        var randomVec: Vec
        repeat {
            randomVec = Vec.getRandom(lo: -1, hi: 1)
        } while randomVec.lengthSquared() >= 1
        return randomVec
    }
    
    static func getRandomUnitVector() -> Vec {
        return getRandomInUnitSphere().getUnit()
    }
    
    static func getRandomInHemisphere(normal: Vec) -> Vec {
        let inUnitSphere = Vec.getRandomInUnitSphere()
        return dot(inUnitSphere, normal) > 0 ? inUnitSphere : -inUnitSphere
    }
    
    static func getRandomInUnitDisk() -> Vec {
        while true {
            let p = Vec(i: Scalar.random(in: -1 ... 1), j: Scalar.random(in: -1 ... 1), k: 0)
            if p.lengthSquared() >= 1 { continue }
            return p
        }
    }
    
    static prefix func - (vec: Vec) -> Vec {
        return Vec(i: -vec.i, j: -vec.j, k: -vec.k)
    }
    
    static func + (lhs: Vec, rhs: Vec) -> Vec {
        return Vec(i: lhs.i + rhs.i, j: lhs.j + rhs.j, k: lhs.k + rhs.k)
    }
    
    static func - (lhs: Vec, rhs: Vec) -> Vec {
        return Vec(i: lhs.i - rhs.i, j: lhs.j - rhs.j, k: lhs.k - rhs.k)
    }

    static func * (lhs: Vec, rhs: Scalar) -> Vec {
        return Vec(i: lhs.i * rhs, j: lhs.j * rhs, k: lhs.k * rhs)
    }
    
    static func * (lhs: Scalar, rhs: Vec) -> Vec {
        return rhs * lhs
    }
    
    static func * (lhs: Vec, rhs: Vec) -> Vec {
        return Vec(i: lhs.i * rhs.i, j: lhs.j * rhs.j, k: lhs.k * rhs.k)
    }
    
    static func / (lhs: Vec, rhs: Scalar) -> Vec {
        return Vec(i: lhs.i / rhs, j: lhs.j / rhs, k: lhs.k / rhs)
    }
    
    static func += (lhs: inout Vec, rhs: Vec) {
        lhs = lhs + rhs
    }
}

extension Vec: CustomStringConvertible {
    var description: String {
        return String(format: "%.3f, %.3f, %.3f", i, j, k)
    }
}

func dot(_ a: Vec, _ b: Vec) -> Scalar {
    return a.i * b.i + a.j * b.j + a.k * b.k
}

func cross(_ u: Vec, _ v: Vec) -> Vec {
    return Vec(
        i: u.j * v.k - u.k * v.j,
        j: u.k * v.i - u.i * v.k,
        k: u.i * v.j - u.j * v.i);
}


func reflect(v: Vec, n: Vec) -> Vec {
    return v - 2 * dot(v, n) * n
}

func refract(uv: Vec, n: Vec, etaiOverEtat: Scalar) -> Vec {
    let cosTheta = dot(-uv, n)//min(dot(a: -uv, b: n), 1.0)
    let rOutPerp = etaiOverEtat * (uv + cosTheta * n)
    let rOutPara = -sqrt(1 - rOutPerp.lengthSquared())*n//-sqrt(abs(1 - rOutPerp.lengthSquared())) * n
    return rOutPerp + rOutPara
}

typealias Color = Vec
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

typealias Point = Vec
extension Point {
    init(x: Scalar, y: Scalar, z: Scalar) {
        self.init(i: x, j: y, k: z)
    }
    
    var x: Scalar { return i }
    var y: Scalar { return j }
    var z: Scalar { return k }
}
