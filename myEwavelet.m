function [E_delta,E_theta,E_alpha,E_beta] = myEwavelet(x)

order = 6;
wpt=wpdec(x,order,'db10'); %����3��С�����ֽ�

nodesNum = 2^(order+1)-2;  % 3��Ϊ����������ڵ�  �ڶ��� 1 2  ������ 3 4 5 6 ������ 7 8 9 10 11 12 13 14
nodes = nodesNum-2^order+1:nodesNum;
nodes_ord = wpfrqord(nodes'); % �����������

E_wavelet = wenergy(wpt);
E_wavelet(:) = E_wavelet(nodes_ord(:)); % ˳�������

E_delta = sum(E_wavelet(1:2));
E_theta = sum(E_wavelet(3:4));
E_alpha = sum(E_wavelet(5:7));
E_beta = sum(E_wavelet(8:13));

end

