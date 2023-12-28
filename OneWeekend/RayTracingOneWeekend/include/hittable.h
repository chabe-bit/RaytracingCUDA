#pragma once

#ifndef HITTABLE_H
#define HITTABLE_H

#include "rtweekend.h"

class material;

class hit_record {
public:
    point3 p;
    vec3 normal;
    shared_ptr<material> mat;
    double t;
    bool front_face;

    /**
     * Determine if the ray interaction is outisde or inside
     * We can do so by using the dot product on the ray direction and surface of the object, or outward normal, for a positive value.
     * These are called normals because range only from -1 to 1.
     * In the case we want to handle rays interacting with inside an object, we simply check if the output is a negative value
    */
    void set_face_normal(const ray& r, const vec3& outward_normal) {
        // Sets the hit record normal vector.
        // NOTE: the parameter `outward_normal` is assumed to have unit length.

        front_face = dot(r.direction(), outward_normal) < 0;
        normal = front_face ? outward_normal : -outward_normal;
    }
   
};

class hittable {
public:
    virtual ~hittable() = default;
    virtual bool hit(const ray& r, interval ray_t, hit_record& rec) const = 0;

};

#endif