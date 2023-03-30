#ifndef ELEMENT_H
#define ELEMENT_H

#include <stdio.h>
#include "MasterElement.cuh"

// Create an Element class that extends the MasterElement class
class Element : public MasterElement
{
    private:
        int e_Id;
        float e_Length;
        float e_Jacobian;
        Node *e_Nodes;
    public:
        Element();
        Element(Element &in);
        Element(int &p, int &id);
        ~Element();
        const int& get_eId();
        const float& get_eLength();
        int& extract_eId();
        float& extract_eLength();
        Node& extract_Node(int i);
        void set_eId(int &id);
        void set_eNodes(Node *n);
};

#endif