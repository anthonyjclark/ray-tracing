//
//  hittableList.swift
//  raytracer1
//
//  Created by Anthony Clark on 3/7/21.
//

import Foundation

class HittableList: Hittable {
        
    var hittables: [Hittable]
    
    init () {
        hittables = []
    }
    
    init (hittableItem: Hittable) {
        hittables = [hittableItem]
    }
    
    func clear() {
        hittables.removeAll()
    }
    
    func add(hittableItem: Hittable) {
        hittables.append(hittableItem)
    }

    // Hittable protocol
    func hit(ray: Ray, tmin: Scalar, tmax: Scalar) -> HitRecord? {
        var closestHittable: HitRecord?
        var closestTVal = tmax
        
        for hittableItem in hittables {
            if let tempHittable = hittableItem.hit(ray: ray, tmin: tmin, tmax: closestTVal) {
                closestHittable = tempHittable
                closestTVal = tempHittable.tval
            }
        }
        
        return closestHittable
    }
}
