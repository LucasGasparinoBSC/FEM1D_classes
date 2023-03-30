#include "Node.cuh"

// Node class methods

// Constructors: Defualt, Copy, and Parameterized
Node::Node() : n_Id(-1), n_X(0.0f), n_Val(0.0f){}
Node::Node(Node &in) : n_Id(in.n_Id), n_X(in.n_X), n_Val(in.n_Val){}
Node::Node(int &n, float &f, float &v) : n_Id(n), n_X(f), n_Val(v){}

// Destructor
Node::~Node(){printf("Destroying Node object %d...\n", n_Id);}

// Getters and Extractors
const int& Node::get_nId() {return n_Id;}
const float& Node::get_nX() {return n_X;}
const float& Node::get_nVal() {return n_Val;}
int& Node::extract_nId() {return n_Id;}
float& Node::extract_nX() {return n_X;}
float& Node::extract_nVal() {return n_Val;}

// Setters
void Node::set_nId(int &n)  {n_Id = n;}
void Node::set_nX(float &f) {n_X = f;}
void Node::set_nVal(float &v) {n_Val = v;}