#include "MasterElement.cuh"

// MasterElement class methods

// Constructors: Defualt, Copy, and Parameterized
MasterElement::MasterElement() : me_Order(-1), me_NumNodes(-1), me_NumGPs(-1), me_hoNodes(-1), me_NodeOrdering(NULL), me_Ngp(NULL), me_dNgp(NULL), me_GaussPoints(NULL){}
MasterElement::MasterElement(MasterElement &in) : me_Order(in.me_Order), me_NumNodes(in.me_NumNodes), me_NumGPs(in.me_NumGPs), me_hoNodes(in.me_hoNodes)
{
    // Allocate arrays for node ordering, shape functions, shape function derivatives and Gauss points
    me_NodeOrdering = (int*)malloc(me_NumNodes*sizeof(int));
    me_Ngp = (float*)malloc(me_NumNodes*me_NumGPs*sizeof(float));
    me_dNgp = (float*)malloc(me_NumNodes*me_NumGPs*sizeof(float));
    me_GaussPoints = (GaussPoint*)malloc(me_NumGPs*sizeof(GaussPoint));

    // Copy arrays
    memcpy(me_NodeOrdering, in.me_NodeOrdering, me_NumNodes*sizeof(int));
    memcpy(me_Ngp, in.me_Ngp, me_NumNodes*me_NumGPs*sizeof(float));
    memcpy(me_dNgp, in.me_dNgp, me_NumNodes*me_NumGPs*sizeof(float));
    memcpy(me_GaussPoints, in.me_GaussPoints, me_NumGPs*sizeof(GaussPoint));
}
MasterElement::MasterElement(int &p) : me_Order(p), me_NumNodes(p+1), me_NumGPs(p+1), me_hoNodes(me_NumNodes-2)
{
    // If order p greater than MAX_ORDER, abort
    if (me_Order > MAX_ORDER)
    {
        printf("ERROR: Order of element greater than MAX_ORDER. Aborting.\n");
        exit(1);
    }
    // Allocate arrays for node ordering, shape functions, shape function derivatives and Gauss points
    me_NodeOrdering = (int*)malloc(me_NumNodes*sizeof(int));
    me_Ngp = (float*)malloc(me_NumNodes*me_NumGPs*sizeof(float));
    me_dNgp = (float*)malloc(me_NumNodes*me_NumGPs*sizeof(float));
    me_GaussPoints = (GaussPoint*)malloc(me_NumGPs*sizeof(GaussPoint));

    // Create Gauss points, shape functions and derivatives
    createGaussPoints();
    createNodeOrdering();
    createShapeFunctions();
}

// Destructor
MasterElement::~MasterElement()
{
    printf("Destroying MasterElement object...\n");
    if(me_NodeOrdering != NULL) free(me_NodeOrdering);
    if(me_Ngp != NULL) free(me_Ngp);
    if(me_dNgp != NULL) free(me_dNgp);
    if(me_GaussPoints != NULL) free(me_GaussPoints);
}

// Define Gauss points
void MasterElement::createGaussPoints()
{
    // Create a table of possible Gauss points based on order p
    float *auxXgp = (float*)malloc(MAX_NGAUS*sizeof(float));
    float *auxWgp = (float*)malloc(MAX_NGAUS*sizeof(float));
    memset(auxXgp, 0.0f, MAX_NGAUS*sizeof(float));
    memset(auxWgp, 0.0f, MAX_NGAUS*sizeof(float));
    if (me_Order == 0) {
        auxXgp[0] = 0.0f;
        auxWgp[0] = 2.0f;
    }
    else if (me_Order == 1) {
        auxXgp[0] = -0.577350269189626f;
        auxXgp[1] = 0.577350269189626f;
        auxWgp[0] = 1.0f;
        auxWgp[1] = 1.0f;
    }
    else if (me_Order == 2) {
        auxXgp[0] = -0.774596669241483f;
        auxXgp[1] = 0.0f;
        auxXgp[2] = 0.774596669241483f;
        auxWgp[0] = 0.555555555555556f;
        auxWgp[1] = 0.888888888888889f;
        auxWgp[2] = 0.555555555555556f;
    }
    else if (me_Order == 3) {
        auxXgp[0] = -0.861136311594053f;
        auxXgp[1] = -0.339981043584856f;
        auxXgp[2] = 0.339981043584856f;
        auxXgp[3] = 0.861136311594053f;
        auxWgp[0] = 0.347854845137454f;
        auxWgp[1] = 0.652145154862546f;
        auxWgp[2] = 0.652145154862546f;
        auxWgp[3] = 0.347854845137454f;
    }
    else if (me_Order == 4) {
        auxXgp[0] = -0.906179845938664f;
        auxXgp[1] = -0.538469310105683f;
        auxXgp[2] = 0.0f;
        auxXgp[3] = 0.538469310105683f;
        auxXgp[4] = 0.906179845938664f;
        auxWgp[0] = 0.236926885056189f;
        auxWgp[1] = 0.478628670499366f;
        auxWgp[2] = 0.568888888888889f;
        auxWgp[3] = 0.478628670499366f;
        auxWgp[4] = 0.236926885056189f;
    }
    else if (me_Order == 5) {
        auxXgp[0] = -0.932469514203152f;
        auxXgp[1] = -0.661209386466265f;
        auxXgp[2] = -0.238619186083197f;
        auxXgp[3] = 0.238619186083197f;
        auxXgp[4] = 0.661209386466265f;
        auxXgp[5] = 0.932469514203152f;
        auxWgp[0] = 0.171324492379170f;
        auxWgp[1] = 0.360761573048139f;
        auxWgp[2] = 0.467913934572691f;
        auxWgp[3] = 0.467913934572691f;
        auxWgp[4] = 0.360761573048139f;
        auxWgp[5] = 0.171324492379170f;
    }
    else if (me_Order == 6) {
        auxXgp[0] = -0.949107912342759f;
        auxXgp[1] = -0.741531185599394f;
        auxXgp[2] = -0.405845151377397f;
        auxXgp[3] = 0.0f;
        auxXgp[4] = 0.405845151377397f;
        auxXgp[5] = 0.741531185599394f;
        auxXgp[6] = 0.949107912342759f;
        auxWgp[0] = 0.129484966168870f;
        auxWgp[1] = 0.279705391489277f;
        auxWgp[2] = 0.381830050505119f;
        auxWgp[3] = 0.417959183673469f;
        auxWgp[4] = 0.381830050505119f;
        auxWgp[5] = 0.279705391489277f;
        auxWgp[6] = 0.129484966168870f;
    }
    else if (me_Order == 7) {
        auxXgp[0] = -0.960289856497536f;
        auxXgp[1] = -0.796666477413627f;
        auxXgp[2] = -0.525532409916329f;
        auxXgp[3] = -0.183434642495650f;
        auxXgp[4] = 0.183434642495650f;
        auxXgp[5] = 0.525532409916329f;
        auxXgp[6] = 0.796666477413627f;
        auxXgp[7] = 0.960289856497536f;
        auxWgp[0] = 0.101228536290376f;
        auxWgp[1] = 0.222381034453374f;
        auxWgp[2] = 0.313706645877887f;
        auxWgp[3] = 0.362683783378362f;
        auxWgp[4] = 0.362683783378362f;
        auxWgp[5] = 0.313706645877887f;
        auxWgp[6] = 0.222381034453374f;
        auxWgp[7] = 0.101228536290376f;
    }
    else if (me_Order == 8) {
        printf("Gauss quadrature order 8 not implemented yet!\n");
        exit(1);
    }

    // Set Gauss points
    for (int i = 0; i < me_NumGPs; i++)
    {
        // Set Gauss point ID
        me_GaussPoints[i].set_nId(i);
        // Set Gauss point location
        me_GaussPoints[i].set_nX(auxXgp[i]);
        // Set Gauss point weight
        me_GaussPoints[i].set_gpWeight(auxWgp[i]);
    }

    // Free memory
    free(auxXgp);
    free(auxWgp);
}

// Define element orrdering
void MasterElement::createNodeOrdering()
{
    me_NodeOrdering[0] = 0;
    me_NodeOrdering[1] = 1;
    if (me_Order > 1) {
        for (int i = 2; i < me_NumNodes; i++)
        {
            me_NodeOrdering[i] = i;
        }
    }
}

// Define element shape functions and derivatives using Lagrangian polynomials
void MasterElement::createShapeFunctions()
{
    // Form the element grid (equispaced)
    float *xgrid = (float *)malloc(me_NumNodes * sizeof(float));
    xgrid[0] = -1.0f;
    xgrid[1] = 1.0f;
    for (int inode = 2; inode < me_NumNodes; inode++)
    {
        xgrid[inode] = -1.0f + 2.0f * ((float)(inode - 1) / (float)(me_NumNodes - 1));
    }

    // Compute shape functions and derivatives at every gauss point
    for (int igaus = 0; igaus < me_NumGPs; igaus++)
    {
        // Get Gauss point location
        const float xgp = me_GaussPoints[igaus].get_nX();

        // Compute Lagrangian polynomial of order p and iits derivative
        for (int inode = 0; inode < me_NumNodes; inode++)
        {
            float N = 1.0f;
            float dN = 0.0f;
            for (int j = 0; j < me_NumNodes; j++)
            {
                if (j != inode)
                {
                    N *= (xgp - xgrid[j]) / (xgrid[inode] - xgrid[j]);
                    float l = 1.0f;
                    for (int m = 0; m < me_NumNodes; m++)
                    {
                        if (m != inode && m != j)
                        {
                            l *= (xgp - xgrid[m]) / (xgrid[inode] - xgrid[m]);
                        }
                    }
                    dN += l / (xgrid[inode] - xgrid[j]);
                }
            }
            me_Ngp[igaus* me_NumNodes + inode] = N;
            me_dNgp[igaus* me_NumNodes + inode] = dN;
        }
    }

    // Free the memory
    free(xgrid);
}

// Getters and extractors
const int& MasterElement::get_eOrder() {return me_Order;}
const int& MasterElement::get_eNumNodes() {return me_NumNodes;}
const int& MasterElement::get_eNumGPs() {return me_NumGPs;}
const int& MasterElement::get_ehoNodes() {return me_hoNodes;}
const int* MasterElement::get_eNodeOrdering() {return me_NodeOrdering;}
const float* MasterElement::get_eNgp() {return me_Ngp;}
const float* MasterElement::get_edNgp() {return me_dNgp;}
int& MasterElement::extract_eOrder() {return me_Order;}
int& MasterElement::extract_eNumNodes() {return me_NumNodes;}
int& MasterElement::extract_eNumGPs() {return me_NumGPs;}
int& MasterElement::extract_ehoNodes() {return me_hoNodes;}
int* MasterElement::extract_eNodeOrdering() {return me_NodeOrdering;}
float* MasterElement::extract_eNgp() {return me_Ngp;}
float* MasterElement::extract_edNgp() {return me_dNgp;}
GaussPoint& MasterElement::extract_GaussPoint(int &i) {return me_GaussPoints[i];}

// Master Element creator
void MasterElement::CreateMasterElement(int &p)
{
    // Set element order
    me_Order = p;

    // Set number of nodes
    me_NumNodes = me_Order + 1;

    // Set number of Gauss points
    me_NumGPs = me_Order + 1;

    // Set number of high order nodes
    me_hoNodes = me_NumNodes-2;

    // Allocate memory if necessary, otherwise reallocate to fiit new bounds
    if (me_NodeOrdering == NULL)
    {
        me_NodeOrdering = (int *)malloc(me_NumNodes * sizeof(int));
        me_Ngp = (float *)malloc(me_NumGPs * me_NumNodes * sizeof(float));
        me_dNgp = (float *)malloc(me_NumGPs * me_NumNodes * sizeof(float));
        me_GaussPoints = (GaussPoint *)malloc(me_NumGPs * sizeof(GaussPoint));
    }
    else
    {
        me_NodeOrdering = (int *)realloc(me_NodeOrdering, me_NumNodes * sizeof(int));
        me_Ngp = (float *)realloc(me_Ngp, me_NumGPs * me_NumNodes * sizeof(float));
        me_dNgp = (float *)realloc(me_dNgp, me_NumGPs * me_NumNodes * sizeof(float));
        me_GaussPoints = (GaussPoint *)realloc(me_GaussPoints, me_NumGPs * sizeof(GaussPoint));
    }

    // Create Gauss points
    createGaussPoints();
    // Create node ordering
    createNodeOrdering();
    // Create shape functions
    createShapeFunctions();
}