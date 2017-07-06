function varargout = bioinfor_project(varargin)
% BIOINFOR_PROJECT MATLAB code for bioinfor_project.fig
%      BIOINFOR_PROJECT, by itself, creates a new BIOINFOR_PROJECT or raises the existing
%      singleton*.
%
%      H = BIOINFOR_PROJECT returns the handle to a new BIOINFOR_PROJECT or the handle to
%      the existing singleton*.
%
%      BIOINFOR_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIOINFOR_PROJECT.M with the given input arguments.
%
%      BIOINFOR_PROJECT('Property','Value',...) creates a new BIOINFOR_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bioinfor_project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bioinfor_project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bioinfor_project

% Last Modified by GUIDE v2.5 04-Jan-2017 16:59:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bioinfor_project_OpeningFcn, ...
                   'gui_OutputFcn',  @bioinfor_project_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bioinfor_project is made visible.
function bioinfor_project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bioinfor_project (see VARARGIN)

% Choose default command line output for bioinfor_project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bioinfor_project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bioinfor_project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% Do not touch

% --------------------------------------------------------------------
function statistic_analysis_Callback(hObject, eventdata, handles)
% Do not touch

% --------------------------------------------------------------------
function Get_ArrayExpress_txt_Callback(hObject, eventdata, handles)
filename=uigetfile({'*.*'},'File Selector','MultiSelect','on');

for i=1:length(filename)
    id = fopen(filename{i});
    a=1;  
    
    while ~feof(id)
        [A,count]=sscanf(fgets(id),'%*s\t%g\t');

        if count==0
            Values(a,i)=0;
            
        else
            Values(a,i)=A;
        end
        a=a+1;
    end

    fprintf('%s is uploaded, %d left\n',filename{i},length(filename)-i)
    fclose(id);
    a=1;
end

xlswrite('Values.xlsx',Values);


% --------------------------------------------------------------------
function Separate_Control_Case_Callback(hObject, eventdata, handles)
filename=uigetfile({'*.xlsx'},'File Selector');
Values=xlsread(filename);
n=size(Values);
[a,b]=deal(1);

for i=1:n(2)
    if Values(length(Values),i)==0
        Cont(:,a)=Values(:,i);
        a=a+1;
    elseif Values(length(Values),i)==1
        Case(:,b)=Values(:,i);
        b=b+1;
    end
    fprintf('%d left\n',n(2)-i)
end

filename='cont_case.mat';
save(filename,'Cont','Case');
fprintf('Successfully saved in %s\n',filename)

% --------------------------------------------------------------------
function transpose_sdfr_Callback(hObject, eventdata, handles)
filename=uigetfile({'*.xlsx'},'File Selector');
[num,txt,raw]=xlsread(filename);
n=size(raw);

for i=1:n(1)
    for j=1:n(2)
        transposed(j,i)=raw(i,j);
    end
end

fid = fopen('trasposed_GB.txt', 'w');
for i=1:n(2)
    fprintf(fid, '%s,', transposed{i,1:end});
end

fclose(fid) ;
 
% --------------------------------------------------------------------
function pValue_Callback(hObject, eventdata, handles)
open(uigetfile({'*.mat'},'File Selector'));

%Defining Variables
Cont=ans.Cont;
Case=ans.Case;
n=size(Case);

%T-test
for i=1:n(1)
    [h,p]=ttest2(Case(i,:),Cont(i,:),'Vartype','unequal');
    p_Values(i,1)=p;
    fprintf('%d left\n',n(1)-i)
end

%Create file
fileID = fopen('Results_p_Value.txt','w');
fprintf(fileID,'%6E\r\n',p_Values);
fclose(fileID);
fprintf('Done\n')


% --------------------------------------------------------------------
function regression_Callback(hObject, eventdata, handles)
open(uigetfile({'*.mat'},'File Selector'));

%Defining Variables
Cont=ans.Cont;
Case=ans.Case;

n=size(Cont);
m=size(Case);
a=1;

for k=1:n(1)
    for i=1:n(2)
        for j=2:m(2)
            Current_Residual(1,a)=Case(k,j)-Cont(k,i);
            a=a+1;
        end
    end
    Residual_Value(k,1)=mean(Current_Residual(1,:));
    Residual_Value(k,2)=std(Current_Residual,1);
    fprintf('%d left\n',n(1)-k)
    a=1;
end

dlmwrite('Results_Residuals.txt',Residual_Value,'delimiter','\t');
fprintf('Done\n')


% --------------------------------------------------------------------
function mean_ATE_GB_Callback(hObject, eventdata, handles)
filename=uigetfile({'*.*'},'File Selector','MultiSelect','on');

for i=1:length(filename)
    id = fopen(filename{i});
    a=1;  
    
    while ~feof(id)
        [A,count]=sscanf(fgets(id),'%*s\t%*g\t%*g\t%*g\t%*g\t%*g\t%g\t');

        if count==0
            ATE_Values(a,i)=i;
            
        else
            ATE_Values(a,i)=A;
        end
        a=a+1;
    end

    fprintf('%s is uploaded, %d left\n',filename{i},length(filename)-i)
    fclose(id);
    a=1;
end

for i=1:length(ATE_Values)
    Mean_ATE(i,1)=mean(ATE_Values(i,:));
end

dlmwrite('Mean_ATE.txt',Mean_ATE,'delimiter','\t');
fprintf('Done\n')


% --------------------------------------------------------------------
function gen_family_Callback(hObject, eventdata, handles)
filename=uigetfile({'*.txt'},'File Selector');
id = fopen(filename);
a=1;
    
while ~feof(id)
    str=fgets(id);
    A=regexp(str,'\d');
    b=1;
    
%     if length(A)>1
%         for i=1:length(A)-1
%             B(i,b)=A(i+1)-A(i);
%         end
%         b=b+1;
%     end

    
    if length(A)~=0 & A(1)>3
        Gen_Family{a,2}=str(1:A(1)-1);
    else
        Gen_Family{a,2}=str(1:length(str)-1);
    end
    Gen_Family{a,1}=str(1:length(str)-1);
    a=a+1;
end

xlswrite('Gen_Family.xlsx',Gen_Family);
