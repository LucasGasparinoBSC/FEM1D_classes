#include <stdio.h>
#include <stdlib.h>
#include "Node.cuh"
#include "GaussPoint.cuh"
#include "MasterElement.cuh"

int main()
{
    // Test creation of nodes
    printf("*----*\n");
        // Use parametrized constructor
        int idx = 1;
        float x = 1.5f;
        float val = 2.0f;
        Node n0(idx, x, val);
        printf("Node n0: idx = %d, x = %f, val = %f\n", n0.get_nId(), n0.get_nX(), n0.get_nVal());

        // Create a default node
        Node n1;
        printf("Node n1: idx = %d, x = %f, val = %f\n", n1.get_nId(), n1.get_nX(), n1.get_nVal());

        // Create a node using copy constructor
        Node n2(n0);
        printf("Node n2: idx = %d, x = %f, val = %f\n", n2.get_nId(), n2.get_nX(), n2.get_nVal());

        // Modify node n1 using values from n0
        int i = n0.extract_nId()+1;
        float x1 = n0.extract_nX()+1.0;
        float val1 = n0.extract_nVal()+1.0;
        n1.set_nId(i);
        n1.set_nX(x1);
        n1.set_nVal(val1);
        printf("Node n1: idx = %d, x = %f, val = %f\n", n1.get_nId(), n1.get_nX(), n1.get_nVal());
    
    // Test creation of Gauss points
    printf("*----*\n");
        // Use parametrized constructor
        float wgp = 10.0f;
        GaussPoint gp0(idx, x, val, wgp);
        printf("Gauss point gp0: idx = %d, x = %f, val = %f, wgp = %f\n", gp0.get_nId(), gp0.get_nX(), gp0.get_nVal(), gp0.get_gpWeight());

        // Create a default Gauss point
        GaussPoint gp1;
        printf("Gauss point gp1: idx = %d, x = %f, val = %f, wgp = %f\n", gp1.get_nId(), gp1.get_nX(), gp1.get_nVal(), gp1.get_gpWeight());

        // Create a Gauss point using copy constructor
        GaussPoint gp2(gp0);
        printf("Gauss point gp2: idx = %d, x = %f, val = %f, wgp = %f\n", gp2.get_nId(), gp2.get_nX(), gp2.get_nVal(), gp2.get_gpWeight());

        // Modify Gauss point gp1 using values from gp0
        int j = gp0.extract_nId()+1;
        float x2 = gp0.extract_nX()+1.0;
        float val2 = gp0.extract_nVal()+1.0;
        float wgp2 = gp0.extract_gpWeight()+1.0;
        gp1.set_nId(j);
        gp1.set_nX(x2);
        gp1.set_nVal(val2);
        gp1.set_gpWeight(wgp2);
        printf("Gauss point gp1: idx = %d, x = %f, val = %f, wgp = %f\n", gp1.get_nId(), gp1.get_nX(), gp1.get_nVal(), gp1.get_gpWeight());

    // Test creation of Master element
    printf("*----*\n");
        // Create a parametrized me
        int p0 = 2;
        MasterElement me0(p0);
        // Print basic info
        printf("Master element me0: p = %d, nNodes = %d, nGaussPoints = %d\n", me0.get_eOrder(), me0.get_eNumNodes(), me0.get_eNumGPs());
        // Print Gauss points
        for (int igaus = 0; igaus < me0.get_eNumGPs(); igaus++)
        {
            GaussPoint gp = me0.extract_GaussPoint(igaus);
            printf("Gauss point %d: idx = %d, x = %f, val = %f, wgp = %f\n", igaus, gp.get_nId(), gp.get_nX(), gp.get_nVal(), gp.get_gpWeight());
        }
        // Print N
        float *auxN = (float*)malloc(me0.get_eNumNodes()*me0.get_eNumGPs()*sizeof(float));
        auxN = me0.extract_eNgp();
        for (int igaus = 0; igaus < me0.get_eNumGPs(); igaus++)
        {
            for (int inode = 0; inode < me0.get_eNumNodes(); inode++)
            {
                printf("N[%d][%d] = %f\n", igaus, inode, auxN[igaus*me0.get_eNumNodes()+inode]);
            }
        }
        // Print dN
        float *auxdN = (float*)malloc(me0.get_eNumNodes()*me0.get_eNumGPs()*sizeof(float));
        auxdN = me0.extract_edNgp();
        for (int igaus = 0; igaus < me0.get_eNumGPs(); igaus++)
        {
            for (int inode = 0; inode < me0.get_eNumNodes(); inode++)
            {
                printf("dN[%d][%d] = %f\n", igaus, inode, auxdN[igaus*me0.get_eNumNodes()+inode]);
            }
        }

        // Create a default me
        MasterElement me1;
        // Print basic info
        printf("Master element me1: p = %d, nNodes = %d, nGaussPoints = %d\n", me1.get_eOrder(), me1.get_eNumNodes(), me1.get_eNumGPs());
        // Modify me1 to be order 3
        int me1_p = 3;
        me1.CreateMasterElement(me1_p);
        // Print basic info
        printf("Master element me1: p = %d, nNodes = %d, nGaussPoints = %d\n", me1.get_eOrder(), me1.get_eNumNodes(), me1.get_eNumGPs());
        // Print Gauss points
        for (int igaus = 0; igaus < me1.get_eNumGPs(); igaus++)
        {
            GaussPoint gp = me1.extract_GaussPoint(igaus);
            printf("Gauss point %d: idx = %d, x = %f, val = %f, wgp = %f\n", igaus, gp.get_nId(), gp.get_nX(), gp.get_nVal(), gp.get_gpWeight());
        }
        // Print N
        float *auxN1 = (float*)malloc(me1.get_eNumNodes()*me1.get_eNumGPs()*sizeof(float));
        auxN1 = me1.extract_eNgp();
        for (int igaus = 0; igaus < me1.get_eNumGPs(); igaus++)
        {
            for (int inode = 0; inode < me1.get_eNumNodes(); inode++)
            {
                printf("N[%d][%d] = %f\n", igaus, inode, auxN1[igaus*me1.get_eNumNodes()+inode]);
            }
        }
        // Print dN
        float *auxdN1 = (float*)malloc(me1.get_eNumNodes()*me1.get_eNumGPs()*sizeof(float));
        auxdN1 = me1.extract_edNgp();
        for (int igaus = 0; igaus < me1.get_eNumGPs(); igaus++)
        {
            for (int inode = 0; inode < me1.get_eNumNodes(); inode++)
            {
                printf("dN[%d][%d] = %f\n", igaus, inode, auxdN1[igaus*me1.get_eNumNodes()+inode]);
            }
        }

        // Create a me using copy constructor
        MasterElement me2(me0);
        printf("Master element me2: p = %d, nNodes = %d, nGaussPoints = %d\n", me2.get_eOrder(), me2.get_eNumNodes(), me2.get_eNumGPs());
        for (int igaus = 0; igaus < me2.get_eNumGPs(); igaus++)
        {
            GaussPoint gp = me2.extract_GaussPoint(igaus);
            printf("Gauss point %d: idx = %d, x = %f, val = %f, wgp = %f\n", igaus, gp.get_nId(), gp.get_nX(), gp.get_nVal(), gp.get_gpWeight());
        }
    return EXIT_SUCCESS;
}