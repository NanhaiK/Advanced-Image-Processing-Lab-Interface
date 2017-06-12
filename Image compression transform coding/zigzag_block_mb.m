function [z] = zigzag_block_mb(x)
% function z = zz(x)
% put a 8x8 block <x> in jpeg zigzag order (z is a vector)
zi= [ 0,  1,  5,  6, 14, 15, 27, 28,
   2,  4,  7, 13, 16, 26, 29, 42,
   3,  8, 12, 17, 25, 30, 41, 43,
   9, 11, 18, 24, 31, 40, 44, 53,
  10, 19, 23, 32, 39, 45, 52, 54,
  20, 22, 33, 38, 46, 51, 55, 60,
  21, 34, 37, 47, 50, 56, 59, 61,
  35, 36, 48, 49, 57, 58, 62, 63]+1;
% work on columns
zi = zi(:);
x = x.data(:);
z(zi) = x;
