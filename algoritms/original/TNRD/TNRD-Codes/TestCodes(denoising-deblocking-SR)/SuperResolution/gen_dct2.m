function C = gen_dct2(n)
C = zeros(n^2,n^2);
for i = 1:n
    for j = 1:n
        A = zeros(n,n);
        A(i,j) = 1;
        B = idct2(A);
        C(:,(j-1)*n + i) = B(:);
    end
end