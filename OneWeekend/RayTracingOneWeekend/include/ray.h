#pragma once
#ifndef RAY_H
#define RAY_H

#include "vec3.h"

/**
* A ray can be define as P(t) = A + tb, where P is the ray's position in 3D space,
* A is the ray's origin, b is the ray's direction. t is a real number (positive numbers only),
* that moves P(t) to trace the ray. 
*/

class ray
{
public:
	ray() {}

	// Input is A + tb
	ray(const point3& origin, const vec3& direction) : orig(origin), dir(direction) {}

	// Get the values
	point3 origin()  const { return orig; }
	vec3 direction() const { return dir; }

	// Calculates P(t) = A + tb
	point3 at(double t) const
	{
		return orig + t * dir;
	}

private:
	point3 orig;
	vec3 dir;
};

#endif