#ifndef MASTERELEMENT_H
#define MASTERELEMENT_H

#include <stdio.h>
#include <stdlib.h>
#include "GaussPoint.cuh"

#define MAX_ORDER 10
#define MAX_NGAUS MAX_ORDER+1
#define MAX_NNODE MAX_ORDER+1

// Create a Master element class
class MasterElement
{
    protected:
        int me_Order;
        int me_NumNodes;
        int me_NumGPs;
        int me_hoNodes;
        int *me_NodeOrdering;
        float *me_Ngp;
        float *me_dNgp;
        GaussPoint *me_GaussPoints;
    private:
        void createGaussPoints();
        void createNodeOrdering();
        void createShapeFunctions();
    public:
        MasterElement();
        MasterElement(MasterElement &in);
        MasterElement(int &p);
        ~MasterElement();
        const int& get_eOrder();
        const int& get_eNumNodes();
        const int& get_eNumGPs();
        const int& get_ehoNodes();
        const int* get_eNodeOrdering();
        const float* get_eNgp();
        const float* get_edNgp();
        const GaussPoint& get_GaussPoint(int &i);
        int& extract_eOrder();
        int& extract_eNumNodes();
        int& extract_eNumGPs();
        int& extract_ehoNodes();
        int* extract_eNodeOrdering();
        float* extract_eNgp();
        float* extract_edNgp();
        GaussPoint& extract_GaussPoint(int &i);
        void CreateMasterElement(int &p);
};

#endif