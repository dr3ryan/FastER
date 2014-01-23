FastER
======

Graphs are frequently used to model data. An example is a social network graph: people are represented by vertices and their mutual relationships are encoded in edges. One then can  extract useful information about the encoded data by measuring various combinatorial quantities;  traditional examples include shortest paths or graph cuts. On the other hand, graph themselves can be viewed as a resistive electrical networks. Electrical measures, and in particular the effective resistances between vertices, often capture information that is not readily available through combinatorial measures. However, computing effective resistances is a challenging computational task especially for very large graphs. In this report we discuss a MATLAB implementation of a near-linear time algorithm for the computation of effective resistance, discovered by Spielman and Srivastava. We explore the trade-offs between running time and approximation quality, and we propose a space-efficient variant of the method.

Dependencies: MATLAB, [MATLAB Parrallel Toolbox (optional)], CMG-Solver (http://ccom.uprrp.edu/~ikoutis/cmg.html) 

OLD-CODE: http://ccom.uprrp.edu/~ikoutis/SpectralAlgorithms.htm

web: http://richardgl.zzl.org/
