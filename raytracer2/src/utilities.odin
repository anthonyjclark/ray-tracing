package main

import "core:fmt"
import "core:math"
import "core:math/rand"

Scalar :: f64
POS_INF :: math.INF_F64
NEG_INF :: math.NEG_INF_F64
rand_scalar :: rand.float64

// ----------------------------------------------------------------
// ▗▄▄▖        █
// ▐▛▀▜▖       ▀        ▐▌
// ▐▌ ▐▌ ▟█▙  ██  ▐▙██▖▐███
// ▐██▛ ▐▛ ▜▌  █  ▐▛ ▐▌ ▐▌
// ▐▌   ▐▌ ▐▌  █  ▐▌ ▐▌ ▐▌
// ▐▌   ▝█▄█▘▗▄█▄▖▐▌ ▐▌ ▐▙▄
// ▝▘    ▝▀▘ ▝▀▀▀▘▝▘ ▝▘  ▀▀
// ----------------------------------------------------------------

Point :: distinct [3]Scalar

// ----------------------------------------------------------------
// ▗▖ ▗▖
// ▝█ █▘           ▐▌
//  █ █  ▟█▙  ▟██▖▐███  ▟█▙  █▟█▌
//  █ █ ▐▙▄▟▌▐▛  ▘ ▐▌  ▐▛ ▜▌ █▘
//  ▐█▌ ▐▛▀▀▘▐▌    ▐▌  ▐▌ ▐▌ █
//  ▐█▌ ▝█▄▄▌▝█▄▄▌ ▐▙▄ ▝█▄█▘ █
//  ▝▀▘  ▝▀▀  ▝▀▀   ▀▀  ▝▀▘  ▀
// ----------------------------------------------------------------

Vector :: distinct [3]Scalar

dot :: proc(v: Vector, u: Vector) -> Scalar {

	return v.x * u.x + v.y * u.y + v.z * u.z

}

length_squared :: proc(v: Vector) -> Scalar {

	return v.x * v.x + v.y * v.y + v.z * v.z

}

length :: proc(v: Vector) -> Scalar {

	return math.sqrt(length_squared(v))

}

unit :: proc(v: Vector) -> Vector {

	return v / length(v)

}

rand_vector :: proc {
	rand_vector_uniform,
	rand_vector_interval,
}

rand_vector_uniform :: proc() -> Vector {

	return Vector{rand_scalar(), rand_scalar(), rand_scalar()}

}

rand_vector_interval :: proc(min, max: Scalar) -> Vector {

	return(
		Vector {
			rand_scalar_interval(min, max),
			rand_scalar_interval(min, max),
			rand_scalar_interval(min, max),
		} \
	)

}

rand_vector_in_sphere :: proc() -> Vector {

	for {
		v := rand_vector_interval(-1.0, 1.0)
		if length_squared(v) < 1.0 do return v
	}

}

rand_unit_vector :: proc() -> Vector {

	return unit(rand_vector_in_sphere())

}

rand_vector_on_hemisphere :: proc(normal: Vector) -> Vector {

	on_unit_sphere := rand_unit_vector()
	return dot(on_unit_sphere, normal) > 0.0 ? on_unit_sphere : -on_unit_sphere

}

// ----------------------------------------------------------------
//   ▄▄      ▗▄▖
//  █▀▀▌     ▝▜▌
// ▐▛    ▟█▙  ▐▌   ▟█▙  █▟█▌
// ▐▌   ▐▛ ▜▌ ▐▌  ▐▛ ▜▌ █▘
// ▐▙   ▐▌ ▐▌ ▐▌  ▐▌ ▐▌ █
//  █▄▄▌▝█▄█▘ ▐▙▄ ▝█▄█▘ █
//   ▀▀  ▝▀▘   ▀▀  ▝▀▘  ▀
// ----------------------------------------------------------------

Color :: distinct [3]Scalar

writeColor :: proc(c: Color, samples_per_pixel: int) {

	scale := 1.0 / Scalar(samples_per_pixel)
	scaled_c := c * scale

	intensity := Interval{0.0, 0.999}

	ir := int(256 * clamp(intensity, scaled_c.r))
	ig := int(256 * clamp(intensity, scaled_c.g))
	ib := int(256 * clamp(intensity, scaled_c.b))

	fmt.println(ir, ig, ib)

}

// ----------------------------------------------------------------
//  ▄▄▄                               ▗▄▖
//  ▀█▀       ▐▌                      ▝▜▌
//   █  ▐▙██▖▐███  ▟█▙  █▟█▌▐▙ ▟▌ ▟██▖ ▐▌
//   █  ▐▛ ▐▌ ▐▌  ▐▙▄▟▌ █▘   █ █  ▘▄▟▌ ▐▌
//   █  ▐▌ ▐▌ ▐▌  ▐▛▀▀▘ █    ▜▄▛ ▗█▀▜▌ ▐▌
//  ▄█▄ ▐▌ ▐▌ ▐▙▄ ▝█▄▄▌ █    ▐█▌ ▐▙▄█▌ ▐▙▄
//  ▀▀▀ ▝▘ ▝▘  ▀▀  ▝▀▀  ▀     ▀   ▀▀▝▘  ▀▀
// ----------------------------------------------------------------

Interval :: struct {
	min, max: Scalar,
}

contains :: proc(i: Interval, v: Scalar) -> bool {

	return i.min <= v && v <= i.max

}

surrounds :: proc(i: Interval, v: Scalar) -> bool {

	return i.min < v && v < i.max

}

clamp :: proc(i: Interval, v: Scalar) -> Scalar {

	return math.max(i.min, math.min(i.max, v))

}

EMPTY :: Interval{POS_INF, NEG_INF}
UNIVERSE :: Interval{NEG_INF, POS_INF}

// ----------------------------------------------------------------
// ▗▄▄▖              ▗▖
// ▐▛▀▜▌             ▐▌
// ▐▌ ▐▌ ▟██▖▐▙██▖ ▟█▟▌ ▟█▙ ▐█▙█▖
// ▐███  ▘▄▟▌▐▛ ▐▌▐▛ ▜▌▐▛ ▜▌▐▌█▐▌
// ▐▌▝█▖▗█▀▜▌▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌█▐▌
// ▐▌ ▐▌▐▙▄█▌▐▌ ▐▌▝█▄█▌▝█▄█▘▐▌█▐▌
// ▝▘ ▝▀ ▀▀▝▘▝▘ ▝▘ ▝▀▝▘ ▝▀▘ ▝▘▀▝▘
// ----------------------------------------------------------------

rand :: proc {
	rand_scalar,
	rand_scalar_interval,
}

rand_scalar_interval :: proc(min, max: Scalar) -> Scalar {

	return min + (max - min) * rand_scalar()

}
