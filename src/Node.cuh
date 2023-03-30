#ifndef NODE_H
#define NODE_H

#include <stdlib.h>
#include <stdio.h>

// Create a node class
class Node
{
    protected:
        int n_Id;
        float n_X;
        float n_Val;
    public:
        Node();
        Node(Node &in);
        Node(int &n, float &f, float &v);
        ~Node();
        const int& get_nId();
        const float& get_nX();
        const float& get_nVal();
        int& extract_nId();
        float& extract_nX();
        float& extract_nVal();
        void set_nId(int &n);
        void set_nX(float &f);
        void set_nVal(float &v);
};

#endif // NODE_H