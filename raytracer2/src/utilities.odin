package main

import "core:fmt"
import "core:math"

Scalar :: f64

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

writeColor :: proc(c: Color) {

	ir := int(255.999 * c.r)
	ig := int(255.999 * c.g)
	ib := int(255.999 * c.b)

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

// TODO: use Scalar infinity instead of math.INF_F64
EMPTY :: Interval{math.INF_F64, math.NEG_INF_F64}
UNIVERSE :: Interval{math.NEG_INF_F64, math.INF_F64}
