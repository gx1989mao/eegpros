clc; clear;
%% draw sphere
v=10;
axis([-26400 7000 -10000 42400 ]);
[x1,y1,z1]=sphere(10);
x1=x1*6400;
y1=y1*6400;
z1=z1*6400;
mesh(x1,y1,z1);
surf(x1,y1,z1);
grid off;



%%
x0=[6400,0,0,v/6400];
%r  dr/dt theta dtheta/dt
% ��λ�� ���ٶ� ��λ�� ���ٶ�
[t,y]=ode45(@YunDongFangCheng,[0,100000],x0);
X=y(:,1).*cos(y(:,3));
Y=y(:,1).*sin(y(:,3));
hold on;
plot(X,Y,'r.');
plot(X,Y,'b-');
grid on;
%%

clc;
clear;

% �ǵĳ�ʼ���꣬ ״̬��
x = 6400e3;
y = 0;
% �ǵĳ�ʼ�ٶȣ� ״̬��
vx = 6e3;
vy = 6e3;
GM = 6.67e-11*5.98e24;

R = 6400e3;
% rectangle('position',[-R,-R,2*R,2*R],'curvature',[1,1]);hold on;

figure(1);
axis([-26400 7000 -10000 42400 ]);
[x1,y1,z1]=sphere(100);
x1=x1*6400e3;
y1=y1*6400e3;
z1=z1*6400e3;
mesh(x1,y1,z1);
surf(x1,y1,z1);
hold on;
sc=2;
axis([-7400e3*sc,7400e3*sc,-7400e3*sc,7400e3*sc,-7400e3*sc,7400e3*sc]);
tic;
for i = 1:1000
    vector = x(i)+1j*y(i);
    Th = angle(vector); %����
    r = abs(vector);
    theta(i+1) = Th;
    
    f=GM/r/r; 
    % ���ٶ�
    x(i+1) = x(i)+vx(i);
    y(i+1) = y(i)+vy(i);
    vx(i+1) = vx(i)-f*cos(Th);
    vy(i+1) = vy(i)-f*sin(Th);
    
    figure(1);
    % �����ǵ�λ��ͼ
    if mod(i,100)==0
        plot(x(i+1),y(i+1),'b.'); hold on;  % ������-û������ ��Ϊ�ǲ����� -��ɢ��û������

    end
    drawnow;
end
toc;

    







