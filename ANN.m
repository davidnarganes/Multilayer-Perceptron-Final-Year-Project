%Timer
clear;
tic;


id = fopen(uigetfile({'*.txt'},'File Selector'));
i=1;
    
while ~feof(id)
    [A,count]=sscanf(fgets(id),'%g\t');
    if count~=0
        Values(i,1:count)=A;
        i=i+1;
    end
end

%Normalize Data [0-1]
for i=1:size(Values,2)
    a{1}(:,i)=Values(:,i)/(1.3*max(Values(:,i)));
end


%Defining variables
[i,b,c]=deal(1,1,1);
HidLay=[size(Values,1) size(Values,1) size(Values,1) size(Values,1) size(Values,1) size(Values,1) 1];
y=a{1}(:,size(Values,2));
a{1}=a{1}(:,1:size(Values,2)-1);
clearvars A id count Values

for g=1:30
    %Forward
    for i=1:length(HidLay)-1
        if c==1
            u{i}=randn(1,1)*ones(size(a{i},1),HidLay(i+1));
            w{i}=randn(size(a{i},2),HidLay(i+1));
        end
        z{i}=(a{i}*w{i})+u{i};
        a{i+1}=sigmf(z{i},[1 0]);
    end

    %Cost function
    difference=-y+a{length(HidLay)};
    J=sum(0.5*(difference.^2));
   
        gradient(1,c)=sum(0.5*(difference.^2));
        gradient(2,c)=c;

    
    %Back propagation
    m=1; 
    for i=1:length(HidLay)-1
        if i>1
            m=m*w{length(HidLay)-i+1}'*sigmpri(z{length(HidLay)-i});
        end
        dJdU{length(HidLay)-i}=(difference.*sigmpri(z{length(HidLay)-1})*m);
        dJdW{length(HidLay)-i}=a{length(HidLay)-i}'*(difference.*sigmpri(z{length(HidLay)-1})*m);
    end
    
    %Redefine Random Matrices
    learn_speed=0.5;
    
    for i=1:length(HidLay)-1
        w{i}=w{i}-learn_speed*dJdW{i};
        u{i}=u{i}-learn_speed*dJdU{i};
    end

    if J<0.0001
        if gradient(1,c-1)<gradient(1,c)
            b=b+1;
        end
    end
    
%     b=J(1,c);
    c=c+1;
end

plot(gradient(2,:),gradient(1,:),'--ob')
toc
J