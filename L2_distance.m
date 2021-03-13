function dist = L2_distance(a, b)
% norm 2 distance
dist1 = sum((a-b).^2);
dist = sqrt(dist1);
end