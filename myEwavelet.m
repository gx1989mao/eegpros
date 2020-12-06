function [E_delta,E_theta,E_alpha,E_beta] = myEwavelet(x)

order = 6;
wpt=wpdec(x,order,'db10'); %进行3层小波包分解

nodesNum = 2^(order+1)-2;  % 3阶为例：不算根节点  第二层 1 2  第三层 3 4 5 6 第三层 7 8 9 10 11 12 13 14
nodes = nodesNum-2^order+1:nodesNum;
nodes_ord = wpfrqord(nodes'); % 格雷码编码结果

E_wavelet = wenergy(wpt);
E_wavelet(:) = E_wavelet(nodes_ord(:)); % 顺序调整好

E_delta = sum(E_wavelet(1:2));
E_theta = sum(E_wavelet(3:4));
E_alpha = sum(E_wavelet(5:7));
E_beta = sum(E_wavelet(8:13));

end

