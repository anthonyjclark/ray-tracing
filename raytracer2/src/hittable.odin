package main

import "core:fmt"
import "core:math"

// ----------------------------------------------------------------
//  ▗▄▖                ▗▄▖               ▗▖  █
//  █▀█                ▝▜▌               ▐▌  ▀
// ▐▌ ▐▌▐▙ ▟▌ ▟█▙  █▟█▌ ▐▌   ▟█▙  ▟██▖ ▟█▟▌ ██  ▐▙██▖ ▟█▟▌
// ▐▌ ▐▌ █ █ ▐▙▄▟▌ █▘   ▐▌  ▐▛ ▜▌ ▘▄▟▌▐▛ ▜▌  █  ▐▛ ▐▌▐▛ ▜▌
// ▐▌ ▐▌ ▜▄▛ ▐▛▀▀▘ █    ▐▌  ▐▌ ▐▌▗█▀▜▌▐▌ ▐▌  █  ▐▌ ▐▌▐▌ ▐▌
//  █▄█  ▐█▌ ▝█▄▄▌ █    ▐▙▄ ▝█▄█▘▐▙▄█▌▝█▄█▌▗▄█▄▖▐▌ ▐▌▝█▄█▌
//  ▝▀▘   ▀   ▝▀▀  ▀     ▀▀  ▝▀▘  ▀▀▝▘ ▝▀▝▘▝▀▀▀▘▝▘ ▝▘ ▞▀▐▌
//                                                    ▜█▛▘
// ----------------------------------------------------------------

hit :: proc {
	hit_hittables,
	hit_sphere,
}

// ----------------------------------------------------------------
// ▗▖ ▗▖  █            ▗▖   ▗▖   ▗▄▖
// ▐▌ ▐▌  ▀   ▐▌       ▐▌   ▐▌   ▝▜▌
// ▐▌ ▐▌ ██  ▐███  ▟██▖▐▙█▙ ▐▙█▙  ▐▌   ▟█▙ ▗▟██▖
// ▐███▌  █   ▐▌   ▘▄▟▌▐▛ ▜▌▐▛ ▜▌ ▐▌  ▐▙▄▟▌▐▙▄▖▘
// ▐▌ ▐▌  █   ▐▌  ▗█▀▜▌▐▌ ▐▌▐▌ ▐▌ ▐▌  ▐▛▀▀▘ ▀▀█▖
// ▐▌ ▐▌▗▄█▄▖ ▐▙▄ ▐▙▄█▌▐█▄█▘▐█▄█▘ ▐▙▄ ▝█▄▄▌▐▄▄▟▌
// ▝▘ ▝▘▝▀▀▀▘  ▀▀  ▀▀▝▘▝▘▀▘ ▝▘▀▘   ▀▀  ▝▀▀  ▀▀▀
// ----------------------------------------------------------------

Hittables :: struct {
	spheres: [dynamic]Sphere,
}

hit_hittables :: proc(h: Hittables, r: Ray, ray_t: Interval) -> Maybe(HitRecord) {

	closest_so_far := ray_t.max
	closest_hit: Maybe(HitRecord) = nil

	for s in h.spheres {

		hit, ok := hit(s, r, Interval{ray_t.min, closest_so_far}).?

		if ok {
			closest_so_far = hit.t
			closest_hit = hit
		}

	}

	return closest_hit

}

// ----------------------------------------------------------------
// ▗▖ ▗▖  █            ▗▄▄▖                        ▗▖
// ▐▌ ▐▌  ▀   ▐▌       ▐▛▀▜▌                       ▐▌
// ▐▌ ▐▌ ██  ▐███      ▐▌ ▐▌ ▟█▙  ▟██▖ ▟█▙  █▟█▌ ▟█▟▌
// ▐███▌  █   ▐▌       ▐███ ▐▙▄▟▌▐▛  ▘▐▛ ▜▌ █▘  ▐▛ ▜▌
// ▐▌ ▐▌  █   ▐▌       ▐▌▝█▖▐▛▀▀▘▐▌   ▐▌ ▐▌ █   ▐▌ ▐▌
// ▐▌ ▐▌▗▄█▄▖ ▐▙▄      ▐▌ ▐▌▝█▄▄▌▝█▄▄▌▝█▄█▘ █   ▝█▄█▌
// ▝▘ ▝▘▝▀▀▀▘  ▀▀      ▝▘ ▝▀ ▝▀▀  ▝▀▀  ▝▀▘  ▀    ▝▀▝▘
// ----------------------------------------------------------------

HitRecord :: struct {
	point:      Point,
	normal:     Vector,
	t:          Scalar,
	front_face: bool,
}

create_hit_record :: proc(p: Point, n: Vector, t: Scalar, front_face: bool) -> HitRecord {

	return HitRecord{point = p, normal = front_face ? n : -n, t = t, front_face = front_face}

}

// ----------------------------------------------------------------
//  ▗▄▖      ▗▖
// ▗▛▀▜      ▐▌
// ▐▙   ▐▙█▙ ▐▙██▖ ▟█▙  █▟█▌ ▟█▙
//  ▜█▙ ▐▛ ▜▌▐▛ ▐▌▐▙▄▟▌ █▘  ▐▙▄▟▌
//    ▜▌▐▌ ▐▌▐▌ ▐▌▐▛▀▀▘ █   ▐▛▀▀▘
// ▐▄▄▟▘▐█▄█▘▐▌ ▐▌▝█▄▄▌ █   ▝█▄▄▌
//  ▀▀▘ ▐▌▀▘ ▝▘ ▝▘ ▝▀▀  ▀    ▝▀▀
//      ▐▌
// ----------------------------------------------------------------

Sphere :: struct {
	center: Point,
	radius: Scalar,
}

hit_sphere :: proc(s: Sphere, r: Ray, ray_t: Interval) -> Maybe(HitRecord) {

	oc := Vector(r.origin - s.center)

	a := length_squared(r.direction)
	half_b := dot(oc, r.direction)
	c := length_squared(oc) - s.radius * s.radius

	discriminant := half_b * half_b - a * c

	if discriminant < 0 do return nil

	sqrtd := math.sqrt(discriminant)

	root := (-half_b - sqrtd) / a

	if !surrounds(ray_t, root) {

		root := (-half_b + sqrtd) / a

		if !surrounds(ray_t, root) do return nil

	}

	hit_loc := at(r, root)
	outward_normal := Vector((hit_loc - s.center) / s.radius)
	front_face := dot(r.direction, outward_normal) < 0

	return create_hit_record(hit_loc, outward_normal, root, front_face)

}
