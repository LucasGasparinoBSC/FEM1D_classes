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
        const float& get_eJacobian();
        int& extract_eId();
        float& extract_eLength();
        float& extract_eJacobian();
        Node& extract_Node(int i);
        void set_eId(int &id);
        void set_eNodes(Node *n);
        void CreateElement(int &id, int &p, Node *nodes);
};

#endif