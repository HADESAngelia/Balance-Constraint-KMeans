clc;
clear;
load iris.dat;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Clustering Statistic
row=1;
count=1;
%start clustering processing
sizeConsMat=[50,50,50];
data{count}=iris;

try
    for loop=1:50               %��50�ξ��࣬ͳ��ACC&NMI��ƽ��ֵ
        dataLength=length(data{1});
        for k=3
            [~,u]=kmeanspp(data{count}',k);
            u=u';
            %the original author algorithm
            [~,~,result_S]=balanced_kmeans(data{count},k,u);
            %my algorithm
            [ ~,tmpResult,~,~] = SizeConsKmeansIntLinPro( data{count},k,u,sizeConsMat );
            %kbs algorithm
            [~,result_Kbs]=BalancedKmeansWithKbs(data{count},k,sizeConsMat);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ACC&NMI%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        gnd = [ones(50,1);ones(50,1)*2;ones(50,1)*3];%���iris���ݼ���ground truth����

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ͳ�������㷨��ACC��NMI%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %�������ݱ�ǩ�ĸ�ʽ�Է��ϵ��õ�������ʵ�ֵ�evaluation�㷨(�ҵ��㷨���ݱ�ǩ��ע���䲻һ��)
        for i=1:length(data{1})
            result_Me(i) =tmpResult(find(tmpResult(:,2)==i,1));
        end
        result_Me=result_Me';
        %ִ����ع����㷨
        result_Me = bestMap(gnd,result_Me);
        AC_Me(loop) = length(find(gnd == result_Me))/length(gnd);
        NMI_Me(loop) = MutualInfo(gnd,result_Me);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ͳ��������BK�㷨��ACC��NMI%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %�������ݱ�ǩ�ĸ�ʽ�Է��ϵ��õ�������ʵ�ֵ�evaluation�㷨
        result_S=result_S';
        %ִ����ع����㷨
        result_S = bestMap(gnd,result_S);
        AC_S(loop) = length(find(gnd == result_S))/length(gnd);
        NMI_S(loop) = MutualInfo(gnd,result_S);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ͳ��KMeans�㷨��ACC��NMI%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        result_KM=kmeans(iris,3);
        result_KM=bestMap(gnd,result_KM);
        AC_KM(loop)=length(find(gnd==result_KM))/length(gnd);
        NMI_KM(loop)=MutualInfo(gnd,result_KM);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%ͳ��KBS SizeConstraint Clustering�㷨��ACC��NMI%%%%%%%%%%%%%%%%%%%%%%%%%%%
        result_Kbs=bestMap(gnd,result_Kbs);
        AC_Kbs(loop)=length(find(gnd==result_Kbs))/length(gnd);
        NMI_Kbs(loop)=MutualInfo(gnd,result_Kbs);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ACC&NMIƽ��ֵͳ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AC_Me_Mean=mean(AC_Me);
    NMI_Me_Mean=mean(NMI_Me);

    AC_S_Mean=mean(AC_S);
    NMI_S_Mean=mean(NMI_S);

    AC_KM_Mean=mean(AC_KM);
    NMI_KM_Mean=mean(NMI_KM);

    AC_Kbs_Mean=mean(AC_Kbs);
    NMI_Kbs_Mean=mean(NMI_Kbs);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ACC&NMI%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch ErrorInfo 
    disp(ErrorInfo.identifier);
    disp(ErrorInfo.message);
end