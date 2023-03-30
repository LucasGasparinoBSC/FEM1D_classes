#include "GaussPoint.cuh"

// GaussPoint class methods

// Constructors: Defualt, Copy, and Parameterized
GaussPoint::GaussPoint() : Node(), gp_Weight(0.0f){}
GaussPoint::GaussPoint(GaussPoint &in) : Node(in), gp_Weight(in.gp_Weight){}
GaussPoint::GaussPoint(int &n, float &f, float &v, float &w) : Node(n, f, v), gp_Weight(w){}

// Destructor
GaussPoint::~GaussPoint(){printf("Destroying GaussPoint object %d...\n", n_Id);}

// Getters and Extractors
const float& GaussPoint::get_gpWeight() {return gp_Weight;}
float& GaussPoint::extract_gpWeight() {return gp_Weight;}

// Setters
void GaussPoint::set_gpWeight(float &w) {gp_Weight = w;}