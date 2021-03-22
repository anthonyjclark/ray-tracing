//
//  Camera.swift
//  raytracer1
//
//  Created by Anthony Clark on 3/7/21.
//

import Foundation

struct Camera {
    let origin: Point
    let horizontal: Vec
    let vertical: Vec
    let lowerLeftCorner: Point
    let u: Vec
    let v: Vec
    let w: Vec
    let lensRadius: Scalar

    init (lookfrom: Point, lookat: Point, vup: Vec, vfov: Scalar, aspectRatio: Scalar, aperture: Scalar, focusDist: Scalar) {
        
        let theta = vfov * 3.1415926 / 180.0
        let h = tan(theta / 2.0)
        let viewport_height = 2.0 * h
        let viewport_width = aspectRatio * viewport_height
        
        w = (lookfrom - lookat).getUnit()
        u = cross(vup, w).getUnit()
        v = cross(w, u)

        origin = lookfrom
        horizontal = focusDist * viewport_width * u
        vertical = focusDist * viewport_height * v
        lowerLeftCorner = origin - horizontal/2 - vertical/2 - focusDist*w
        
        lensRadius = aperture / 2
    }
    
    func getRay(_ s: Scalar, _ t: Scalar) -> Ray {
        let rd = lensRadius * Vec.getRandomInUnitDisk()
        let offset = u * rd.i + v * rd.j
        return Ray(
            origin: origin + offset,
            direction: lowerLeftCorner + s*horizontal + t*vertical - origin - offset)
    }
}
