#ifndef GAUSSPOINT_H
#define GAUSSPOINT_H

#include <stdio.h>
#include "Node.cuh"

// Create a Gauss point class that inherits from the Node class
class GaussPoint : public Node
{
    private:
        float gp_Weight;
    public:
        GaussPoint();
        GaussPoint(GaussPoint &in);
        GaussPoint(int &n, float &f, float &v, float &w);
        ~GaussPoint();
        const float& get_gpWeight();
        float& extract_gpWeight();
        void set_gpWeight(float &w);
};

#endif