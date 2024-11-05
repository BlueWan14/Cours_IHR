function [A, B, C, D] = calcIAD(K, C1, C2, m, M)
    mK = K / m;
    mC = C1 / m;
    MK = K / M;

    A = [
         0      0       1       0;
         0      0       0       1;
        -mK     mK      -mC     mC;
         MK     -MK     C1/M    -(C1+C2)/M
        ];

    B = [
         0;
         0;
         1/m;
         0
        ];

    C = [
         0      0       0       0;
         0      1       0       0;
         0      0       0       0;
         0      0       0       1
        ];

    D = zeros(4, 1);
end
