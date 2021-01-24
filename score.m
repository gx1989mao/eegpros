clear;
clc;

A = [81
84
60
76
70
78
88
82
72
82
66
60
70
84
65
42
80
74
58
42
64
48
62
47
64
32
30
36
54
82
72
85
79
67
70
48
69
66
85
78
76
86
86
92
82
78
80
60
62
66
88
51
96
64
63
69
72
71
80
86
92
52
72
61
72
70
90
74
66
82
];

P = [100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
90
100
100
100
90
100
100
100
100
100
90
85
85
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
100
];


pire = [27
2
23
7
32
8
33
25
9
24
25
9
29
8
21
36
29
31
31
10
11
30
11
37
21
38
38
38
26
26
23
7
36
33
13
20
20
13
34
34
1
3
28
4
5
3
6
6
12
12
19
1
35
22
18
5
14
15
15
14
16
16
17
18
19
17
35
28
22
4
];
%%
now = zeros(length(A),1);
pr = now;

now = (P*0.25+A*0.6);
top = (100-now)/0.15/4;
top(top>100)=100;

sigma = 10;

PR = zeros(length(A),1);
floatp = 70;
for i=1:38
    number = mean(A(pire==i));
    tmp = floor((floatp+normrnd(number/100*(100-floatp),sigma))/5)*5;
    PR(pire==i) = tmp;
end

final = floor(now+0.15*PR);
while (~isempty(PR(PR>100)) || ~isempty(PR(PR<60)) || length(final(final>=90))>6 )
    for i=1:38
        number = mean(A(pire==i));
        tmp = floor((floatp+normrnd(number/100*(100-floatp),sigma))/5)*5;
        PR(pire==i) = tmp;
    end
    final = floor(now+0.15*PR);
    
    % µ¥¶ÀÐÞÕý
    for i = [2,35]
    PR(pire==i) =100;
    final(pire==i) = floor(now(pire==i)+0.15*PR(pire==i));
    end
    for i = [38]
    PR(pire==i) =60;
    final(pire==i) = floor(now(pire==i)+0.15*PR(pire==i));
    end
    for i = [10]
    PR(pire==i) =70;
    final(pire==i) = floor(now(pire==i)+0.15*PR(pire==i));
    end
    for i = [36]
    PR(pire==i) =70;
    final(pire==i) = floor(now(pire==i)+0.15*PR(pire==i));
    end
end



figure;
bar(PR,'b','linewidth',1);hold on;
plot(A,'r','linewidth',1);hold on;
x = 1:length(A);
plot(x(A<45),A(A<45),'g*');hold on;
plot(final,'k','linewidth',1);hold on;
figure;
XX = sort(final);
bar(XX,'b');hold on;
disp(length(XX(XX>=90)));


%%



xlswrite('D:\final.xlsx',[P,PR,A,final]);
%%
list = pire(ZZ==89);
for i = 1:length(list)
PR(pire==list(i)) =PR(pire==list(i))-5;
% final(pire==i) = floor(now(pire==i)+0.15*PR(pire==i));
end
%%
xlswrite('D:\final1.xlsx',[PR,pire]);


