#include "Element.cuh"

// Element class methods

// Constructors: default, copy and parameterized
Element::Element() : MasterElement(), e_Id(-1), e_Length(0.0f), e_Jacobian(0.0f), e_Nodes(NULL){}
Element::Element(Element &in) : MasterElement(in), e_Id(in.e_Id), e_Length(in.e_Length), e_Jacobian(in.e_Jacobian)
{
    // Create array of element nodes
    e_Nodes = (Node *)malloc(me_NumNodes * sizeof(Node));

    // Copy nodes
    memcpy(e_Nodes, in.e_Nodes, me_NumNodes * sizeof(Node));
}
Element::Element(int &p, int &id) : MasterElement(p), e_Id(id)
{
    // Create array of element nodes
    e_Nodes = (Node *)malloc(me_NumNodes * sizeof(Node));

    // Set the element endpoints based on the element id
    int auxId = e_Id+1;
    e_Nodes[0].set_nId(e_Id);
    e_Nodes[1].set_nId(auxId);

    // Set the element length
    e_Length = e_Nodes[1].get_nX() - e_Nodes[0].get_nX();
    e_Jacobian = e_Length / 2.0f;
}

// Destructor
Element::~Element()
{
    // Free memory
    if(e_Nodes != NULL) free(e_Nodes);
}

// Getters and extractors
const int& Element::get_eId() {return e_Id;}
const float& Element::get_eLength() {return e_Length;}
int& Element::extract_eId() {return e_Id;}
float& Element::extract_eLength() {return e_Length;}
Node& Element::extract_Node(int i) {return e_Nodes[i];}

// Setters
void Element::set_eId(int &id) {e_Id = id;}
void Element::set_eNodes(Node *nodes)
{
    e_Nodes = nodes;
    e_Length = e_Nodes[1].get_nX() - e_Nodes[0].get_nX();
    e_Jacobian = e_Length / 2.0f;

    // Here the node positions should be well defined, so element length > 0
    if (e_Length <= 0.0f)
    {
        printf("Element length %ff <= 0.0. Check node positions.\n", e_Length);
        exit(1);
    }
}