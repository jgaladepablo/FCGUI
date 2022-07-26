function subplotsFigureTool(varargin)

BIGPLOT = 70000;
MEDIUMPLOT = 10000;
DEFAULTBINS_BIG = 100;
DEFAULTBINS_MEDUIM = 50;
DEFAULTBINS_SMALL = 10;

twoDhistParam.isolineNo = 0;
twoDhistParam.xBinNo = 0;
twoDhistParam.yBinNo = 0;

folderName = '';

standAlone = 0; %If it was called without input arguments standAlone == 1
metaFile = [];%A cell that will contain the data from all the files in the folder
metaData = []; %An a x 2 x n-dimentional matrix, while n is the number of files in the
               %folder, each dimention contain a ax2 matrix, the x and y axis of each of
               %the files (if it is in histogram plot mode than the second column = NaNs.
tableData = []; %the data that will be presented in tableData
histPlotData = []; %the data that will be ploted in histogram plot mode:
autoColor = [];%the color selected for auto color 
operationX = []; operationY = []; %the math operations on data, if defined.

handles.figure = figure('Visible','off','MenuBar','None','NumberTitle','off',...
                        'Toolbar','none','HandleVisibility','callback',...
                        'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                        'name','Create multi-plot figure',...
                        'Position',[320 250 900 600]);    
buildfcn;
callbackassignfcn;
initialfcn;

function buildfcn
icons = load('icons.mat'); icons = icons.icons;

handles.bigLayout = uiextras.VBox('Parent',handles.figure,'Spacing',5);

handles.chooseDir.panel = uiextras.HBox('Parent',handles.bigLayout);
handles.chooseDir.text = uicontrol('Style','text','Parent',double(handles.chooseDir.panel),...
                                   'String','Choose directory:',...
                                   'HandleVisibility','callback');
handles.chooseDir.box = uicontrol('Style','edit','Parent',double(handles.chooseDir.panel),...
                                  'BackgroundColor','white','String',' ','HorizontalAlignment','left',...
                                  'HandleVisibility','callback');
handles.chooseDir.button = uicontrol('Style','Pushbutton','Parent',double(handles.chooseDir.panel),...
                                     'String','...',...
                                     'HandleVisibility','callback');
set(handles.chooseDir.panel,'Sizes',[100 -1 22]);

handles.plotModePanel = uiextras.HBox('Parent',double(handles.bigLayout));
handles.plotModeText = uicontrol('Style','text','parent',double(handles.plotModePanel),...
                             'String','Plot mode:',...
                             'HandleVisibility','callback'); 
handles.plotMode = uicontrol('Style','popupmenu','parent',double(handles.plotModePanel),...
                             'String',{'Histograms';'Scatter plots'},'BackgroundColor',[0.8706 0.9216 0.9804],...
                             'HandleVisibility','callback');
set(handles.plotModePanel,'Sizes',[70 -1]);                         
                         
handles.axesProps.panel = uiextras.HBox('Parent',handles.bigLayout,'Spacing',10);

handles.axesProps.paramsPanel = uiextras.VBox('Parent',handles.axesProps.panel);
handles.axesProps.paramsPanelTop = uiextras.HBox('Parent',handles.axesProps.paramsPanel);
handles.xAxis.text = uicontrol('Style','text','Parent',double(handles.axesProps.paramsPanelTop),...
                                        'String','Choose Parameter:',...
                                        'HandleVisibility','callback');
handles.xAxis.param = uicontrol('Style','popupmenu','Parent',double(handles.axesProps.paramsPanelTop),...
                                        'String',' ','BackgroundColor','white',...
                                        'HandleVisibility','callback');
handles.xAxis.math = uicontrol('Style','togglebutton','Parent',double(handles.axesProps.paramsPanelTop),...
                                        'CData',icons.calculator,...
                                        'HandleVisibility','callback');
handles.axesProps.paramsPanelBot = uiextras.HBox('Parent',handles.axesProps.paramsPanel);
handles.yAxis.text = uicontrol('Style','text','Parent',double(handles.axesProps.paramsPanelBot),...
                                        'String','Y axis:',...
                                        'HandleVisibility','callback');
handles.yAxis.param = uicontrol('Style','popupmenu','Parent',double(handles.axesProps.paramsPanelBot),...
                                        'String',' ','BackgroundColor','white',...
                                        'HandleVisibility','callback');
handles.yAxis.math = uicontrol('Style','togglebutton','Parent',double(handles.axesProps.paramsPanelBot),...
                                        'CData',icons.calculator,...
                                        'HandleVisibility','callback');
set(handles.axesProps.paramsPanelTop,'Sizes',[-1 -1 22]);
set(handles.axesProps.paramsPanelBot,'Sizes',[-1 -1 22]);
set(handles.axesProps.paramsPanel,'Sizes',[22 22],'Spacing',5);

handles.axesProps.xAxis.trans.panelBig = uiextras.Panel('Parent',double(handles.axesProps.panel),'Title','X Axis transformation:','BorderType','etchedout');
handles.axesProps.xAxis.trans.panel = uiextras.HBox('Parent',double(handles.axesProps.xAxis.trans.panelBig));
handles.xAxis.trans.log = uicontrol('Style','radiobutton','Parent',double(handles.axesProps.xAxis.trans.panel),'String','Log','HandleVisibility','callback');
handles.xAxis.trans.none = uicontrol('Style','radiobutton','Parent',double(handles.axesProps.xAxis.trans.panel),'String','None','HandleVisibility','callback');
set(handles.axesProps.xAxis.trans.panel,'Sizes',[-1 -1]);

handles.histParamsYaxisTransPanel = uiextras.CardPanel('Parent',double(handles.axesProps.panel));

handles.axesProps.histPanelBig = uiextras.HBox('Parent',double(handles.histParamsYaxisTransPanel),'Spacing',5);
handles.axesProps.histBins.panel = uiextras.VBox('Parent',double(handles.axesProps.histPanelBig));
handles.axesProps.histBins.text = uicontrol('Style','text','Parent',double(handles.axesProps.histBins.panel),...
                                            'String','Specify bin number:',...
                                            'HandleVisibility','callback');
handles.hist.binNo = uicontrol('Style','edit','Parent',double(handles.axesProps.histBins.panel),...
                               'String',' ','BackgroundColor','white',...
                               'HandleVisibility','callback');
handles.axesProps.histSmooth.panel = uiextras.VBox('Parent',double(handles.axesProps.histPanelBig));                        

handles.hist.smooth.checkBox = uicontrol('Style','Checkbox','Parent',double(handles.axesProps.histSmooth.panel),...
                                       'String','Smooth',...
                                       'HandleVisibility','Callback'); 
handles.axesProps.histSmooth.panelSmall = uiextras.HBox('Parent',double(handles.axesProps.histSmooth.panel));                                
handles.hist.smooth.text1 = uicontrol('Style','text','Parent',double(handles.axesProps.histSmooth.panelSmall),...
                                       'String','(Width: ','Enable','off',...
                                       'HandleVisibility','Callback'); 
handles.hist.smooth.width = uicontrol('Style','edit','Parent',double(handles.axesProps.histSmooth.panelSmall),...
                                       'String',' ','Enable','off',...
                                       'HandleVisibility','Callback');
handles.hist.smooth.text2 = uicontrol('Style','text','Parent',double(handles.axesProps.histSmooth.panelSmall),...
                                       'String',')','Enable','off',...
                                       'HandleVisibility','Callback'); 
set(handles.axesProps.histBins.panel,'Sizes',[-1 22]);

handles.axesProps.yAxis.trans.panelBig = uiextras.Panel('Parent',double(handles.histParamsYaxisTransPanel),'Title','Y Axis transformation:','BorderType','etchedout');
handles.axesProps.yAxis.trans.panel = uiextras.HBox('Parent',double(handles.axesProps.yAxis.trans.panelBig));
handles.yAxis.trans.log = uicontrol('Style','radiobutton','Parent',double(handles.axesProps.yAxis.trans.panel),'String','Log','HandleVisibility','callback');
handles.yAxis.trans.none = uicontrol('Style','radiobutton','Parent',double(handles.axesProps.yAxis.trans.panel),'String','None','HandleVisibility','callback');
set(handles.axesProps.yAxis.trans.panel,'Sizes',[-1 -1]);

handles.table = uitable('Parent',double(handles.bigLayout),'HandleVisibility','callback',...
                        'ColumnEditable',logical([1 0 1 0 0 0 0 0 0 0 0 0]),...
                        'ColumnFormat',{'logical','char','char','char','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'},...
                        'ColumnName',{'Include','File name','Label','Color','X min. value','X axis min.','X max. value','X axis max.','Y min. value','Y axis min.','Y max. value','Y axis max.'},...
                        'ColumnWidth',{60,120,120,35,'auto','auto','auto','auto','auto','auto','auto','auto'},...
                        'RowName',[]);

handles.underTableRow = uiextras.HBox('Parent',double(handles.bigLayout));
handles.selectAll = uicontrol('Style','toggleButton','Parent',double(handles.underTableRow),...
                                            'String','Select All',...
                                            'HandleVisibility','callback');
handles.selectFirst = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow),...
                                'String','Select First',...
                                'HandleVisibility','callback');
handles.moveUp = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow),...
                                'CData',icons.up,'Enable','off',...
                                'HandleVisibility','callback');
handles.moveDown = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow),...
                                'CData',icons.down,'Enable','off',...
                                'HandleVisibility','callback');
handles.underTableRowSpace1 = uiextras.Empty('Parent',double(handles.underTableRow)); 
handles.autoColor.text = uicontrol('Style','text','Parent',double(handles.underTableRow),...
                                   'String','Auto color (on):','FontWeight','bold',...
                                   'HandleVisibility','callback');   
handles.autoColor.panel = uiextras.HBox('Parent',double(handles.underTableRow));
handles.autoColor.red = uicontrol('Style','toggleButton','Parent',double(handles.autoColor.panel),...
                                  'String',' ','BackgroundColor',[1 0 0],...
                                  'HandleVisibility','callback');
handles.autoColor.yellow = uicontrol('Style','toggleButton','Parent',double(handles.autoColor.panel),...
                                  'String',' ','BackgroundColor',[1 1 0],...
                                  'HandleVisibility','callback');
handles.autoColor.green = uicontrol('Style','toggleButton','Parent',double(handles.autoColor.panel),...
                                  'String',' ','BackgroundColor',[0 1 0],...
                                  'HandleVisibility','callback');
handles.autoColor.cyan = uicontrol('Style','toggleButton','Parent',double(handles.autoColor.panel),...
                                  'String',' ','BackgroundColor',[0 1 1],...
                                  'HandleVisibility','callback');
handles.autoColor.blue = uicontrol('Style','toggleButton','Parent',double(handles.autoColor.panel),...
                                  'String',' ','BackgroundColor',[0 0 1],...
                                  'HandleVisibility','callback');
handles.autoColor.magenta = uicontrol('Style','toggleButton','Parent',double(handles.autoColor.panel),...
                                  'String',' ','BackgroundColor',[1 0 1],...
                                  'HandleVisibility','callback');
handles.autoColor.semiAutoDlg = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow),...
                                  'CData',icons.gradient,'TooltipString','Set color sequence',...
                                  'HandleVisibility','callback');   
handles.underTableRowSpace2 = uiextras.Empty('Parent',double(handles.underTableRow)); 

set(handles.underTableRow,'Sizes',[100 100 22 22 -1 100 100 22 -1],'Spacing',10);

handles.underTableRow2 = uiextras.HBox('Parent',double(handles.bigLayout));
handles.sameLimits = uicontrol('Style','checkbox','Parent',double(handles.underTableRow2),...
                                      'String','Apply the same axes limits to all subplots',...
                                      'HandleVisibility','callback','Value',1);
handles.limitsXaxisText = uicontrol('Style','text','Parent',double(handles.underTableRow2),...
                                     'String','X axis:',...
                                     'HandleVisibility','callback');                           
handles.xAxis.limits.low = uicontrol('Style','edit','Parent',double(handles.underTableRow2),...
                                     'String',' ','BackgroundColor','white',...
                                     'HandleVisibility','callback');
handles.xAxis.limits.hi = uicontrol('Style','edit','Parent',double(handles.underTableRow2),...
                                     'String',' ','BackgroundColor','white',...
                                     'HandleVisibility','callback'); 
handles.limitsYaxisText = uicontrol('Style','text','Parent',double(handles.underTableRow2),...
                                     'String','Y axis:',...
                                     'HandleVisibility','callback');                           
handles.yAxis.limits.low = uicontrol('Style','edit','Parent',double(handles.underTableRow2),...
                                     'String',' ','BackgroundColor','white',...
                                     'HandleVisibility','callback');
handles.yAxis.limits.hi = uicontrol('Style','edit','Parent',double(handles.underTableRow2),...
                                     'String',' ','BackgroundColor','white',...
                                     'HandleVisibility','callback');
handles.limitsHistText = uicontrol('Style','text','Parent',double(handles.underTableRow2),...
                                     'String','Histogram:',...
                                     'HandleVisibility','callback');                           
handles.hist.limits.low = uicontrol('Style','edit','Parent',double(handles.underTableRow2),...
                                     'String',' ','BackgroundColor','white',...
                                     'HandleVisibility','callback');
handles.hist.limits.hi = uicontrol('Style','edit','Parent',double(handles.underTableRow2),...
                                     'String',' ','BackgroundColor','white',...
                                     'HandleVisibility','callback');
handles.updateLimBasedOnSelection = uicontrol('Style','Pushbutton','Parent',double(handles.underTableRow2),...
                                           'CData',icons.update,'TooltipString','Update limits based on selection',...
                                           'HandleVisibility','Callback');                                 
handles.resetLimBasedOnAll = uicontrol('Style','Pushbutton','Parent',double(handles.underTableRow2),...
                                           'CData',icons.reset,'TooltipString','Reset limits based on all',...
                                           'HandleVisibility','Callback');
handles.underTableRow2Space = uiextras.Empty('Parent',double(handles.underTableRow2)); 
set(handles.underTableRow2,'Sizes',[-1 50 50 50 50 50 50 70 50 50 22 22 -0.3],...
                           'MinimumSizes',[250 50 50 50 50 50 50 70 50 50 22 22 0],'Spacing',5);

handles.underTableRow3 = uiextras.CardPanel('Parent',double(handles.bigLayout));

handles.histAddProps.panel = uiextras.HBox('Parent',double(handles.underTableRow3));
handles.histAddProps.panel1 = uiextras.HBox('Parent',double(handles.histAddProps.panel));
handles.histAddProps.space = uiextras.Empty('Parent',double(handles.histAddProps.panel));
handles.histAddProps.panel2 = uiextras.HBox('Parent',double(handles.histAddProps.panel));
handles.histAddProps.space2 = uiextras.Empty('Parent',double(handles.histAddProps.panel));
handles.histAddProps.grey.checkBox = uicontrol('Style','Checkbox','Parent',double(handles.histAddProps.panel1),...
                                           'String','Show grey line over the ',...
                                           'HandleVisibility','Callback'); 
handles.histAddProps.grey.statParam = uicontrol('Style','popupmenu','Parent',double(handles.histAddProps.panel1),...
                                           'String',{'Mean';'Median';'Mode'},'BackgroundColor','white',...
                                           'HandleVisibility','Callback','Enable','off'); 
handles.histAddProps.addStatParam.checkBox = uicontrol('Style','Checkbox','Parent',double(handles.histAddProps.panel2),...
                                           'String','Show value of other statistical measure:',...
                                           'HandleVisibility','Callback'); 
handles.histAddProps.addStatParam.statParam = uicontrol('Style','popupmenu','Parent',double(handles.histAddProps.panel2),...
                                           'String',{'Min';'Max';'STD';'Variance';'CV';'CV^2';'Var/mean';'Skewness'},'BackgroundColor','white',...
                                           'HandleVisibility','Callback','Enable','off'); 
set(handles.histAddProps.panel1,'Sizes',[180 100]); 
set(handles.histAddProps.panel2,'Sizes',[220 100]);    
set(handles.histAddProps.panel,'Sizes',[280 -1 320 -1]);

handles.dotplotAddProps.panel = uiextras.HBox('Parent',double(handles.underTableRow3));
handles.dotplotAddProps.panel1 = uiextras.HBox('Parent',double(handles.dotplotAddProps.panel));
handles.dotplotAddProps.space = uiextras.Empty('Parent',double(handles.dotplotAddProps.panel));
handles.dotplotAddProps.panel2 = uiextras.HBox('Parent',double(handles.dotplotAddProps.panel));
handles.dotplotAddProps.space2 = uiextras.Empty('Parent',double(handles.dotplotAddProps.panel));
handles.dotplotAddProps.twoDhist.checkBox = uicontrol('Style','Checkbox','Parent',double(handles.dotplotAddProps.panel1),...
                                           'String','Show density color map',...
                                           'HandleVisibility','Callback'); 
handles.dotplotAddProps.twoDhist.dlg = uicontrol('Style','pushbutton','Parent',double(handles.dotplotAddProps.panel1),...
                                           'CData',icons.changeIsolineParams,'ToolTipString','Set density color map parameters',...
                                           'HandleVisibility','Callback','Enable','off');
handles.dotplotAddProps.layout.text = uicontrol('Style','text','Parent',double(handles.dotplotAddProps.panel2),...
                                           'String','',...
                                           'HandleVisibility','Callback');
handles.dotplotAddProps.layout.panelBig = uiextras.Panel('Parent',double(handles.dotplotAddProps.panel2));                                                         
handles.dotplotAddProps.layout.panel = uiextras.HBox('Parent',double(handles.dotplotAddProps.layout.panelBig));
handles.dotplotAddProps.layout.rows = uicontrol('Style','edit','Parent',double(handles.dotplotAddProps.layout.panel),...
                                           'String',' ','BackgroundColor','white',...
                                           'HandleVisibility','Callback');
handles.dotplotAddProps.layout.text2 = uicontrol('Style','text','Parent',double(handles.dotplotAddProps.layout.panel),...
                                           'String','rows     X',...
                                           'HandleVisibility','Callback');
handles.dotplotAddProps.layout.cols = uicontrol('Style','edit','Parent',double(handles.dotplotAddProps.layout.panel),...
                                           'String',' ','BackgroundColor','white',...
                                           'HandleVisibility','Callback'); 
handles.dotplotAddProps.layout.text3 = uicontrol('Style','text','Parent',double(handles.dotplotAddProps.layout.panel),...
                                           'String','columns',...
                                           'HandleVisibility','Callback'); 
handles.dotplotAddProps.layout.reset = uicontrol('Style','pushbutton','Parent',double(handles.dotplotAddProps.layout.panel),...
                                           'TooltipString','Reset based on selection','CData',icons.zero,...
                                           'HandleVisibility','Callback');                                        
set(handles.dotplotAddProps.panel1,'Sizes',[-1 22]);
set(handles.dotplotAddProps.panel2,'Sizes',[200 -1]);
set(handles.dotplotAddProps.layout.panel,'Sizes',[60 100 60 100 22]);
set(handles.dotplotAddProps.panel,'Sizes',[170 -1 520 -1],'MinimumSizes',[170 1 520 1]);
handles.underTableRow4 = uiextras.HBox('Parent',double(handles.bigLayout));
handles.cancel = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow4),...
                           'String','Cancel',...
                           'HandleVisibility','Callback');
handles.saveMetaFile = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow4),...
                           'String','Save meta-file',...
                           'HandleVisibility','Callback'); 
handles.text = uicontrol('Style','text','Parent',double(handles.underTableRow4),...
                           'String','Specify figure name:',...
                           'HandleVisibility','Callback');   
handles.figureName = uicontrol('Style','edit','Parent',double(handles.underTableRow4),...
                           'String',' ','BackgroundColor','white',...
                           'HandleVisibility','Callback','HorizontalAlignment','left'); 
handles.createFig = uicontrol('Style','pushbutton','Parent',double(handles.underTableRow4),...
                           'String','Create figure',...
                           'HandleVisibility','Callback');
set(handles.underTableRow4,'Sizes',[100 100 100 -1 100],'Spacing',5);

set(handles.bigLayout,'Sizes',[22 22 40 -1 22 22 22 22],'Spacing',10,'Padding',10); 
end
function callbackassignfcn
set(handles.plotMode,           'Callback',             @plotMode_callback);
set([handles.chooseDir.box,handles.chooseDir.button],...
                                'Callback',             @chooseDir_callback);
                            
set([handles.xAxis.param,handles.yAxis.param,handles.xAxis.math,handles.yAxis.math],...
                                'Callback',             @axesParamChange_callback);
set([handles.xAxis.trans.log,handles.xAxis.trans.none,...
     handles.yAxis.trans.log,handles.yAxis.trans.none],...
                                'Callback',             @axesTransChange_callback);
set(handles.hist.binNo,         'Callback',             @histBinNo_callback);
set([handles.autoColor.red,handles.autoColor.yellow,handles.autoColor.green,...
     handles.autoColor.cyan,handles.autoColor.blue,handles.autoColor.magenta],...
                                'Callback',             @autoColor_callback);
set(handles.autoColor.semiAutoDlg,'Callback',           @semiAutoColor_Callback);
set([handles.selectAll,handles.selectFirst],...
                                'Callback',             @tableSelectAllOrFirst_callback);
set(handles.table,              'CellEditCallback',     @tableCellEdit_callback,...
                                'CellSelectionCallback',@tableChangeColor_callback); 
set([handles.moveUp,handles.moveDown],'Callback',       @tableMoveUpDown_callback);
set([handles.sameLimits,handles.updateLimBasedOnSelection,handles.resetLimBasedOnAll,...
     handles.xAxis.limits.low,handles.xAxis.limits.hi,handles.yAxis.limits.low,...
     handles.yAxis.limits.hi,handles.hist.limits.low,handles.hist.limits.hi],...
                                'Callback',             @sameLimits_callback);
set([handles.histAddProps.grey.checkBox,handles.histAddProps.addStatParam.checkBox],...
                                'Callback',             @histAddPropsCheckBoxes_callback);
set([handles.hist.smooth.checkBox,handles.hist.smooth.width],...
                                'Callback',             @histSmooth_callback);
set([handles.dotplotAddProps.twoDhist.checkBox,handles.dotplotAddProps.twoDhist.dlg],...
                                'Callback',             @dotplotTwoDhist_callback);
set([handles.dotplotAddProps.layout.rows,handles.dotplotAddProps.layout.cols,...
     handles.dotplotAddProps.layout.reset],...
                                'Callback',             @dotplotLayout_callback);
set(handles.cancel,             'Callback',             @(~,~) delete(handles.figure));
set(handles.createFig,          'Callback',             @createFig_callback);
set(handles.saveMetaFile,       'Callback',             @saveMetaFile_callback);

end
function initialfcn
set(handles.autoColor.blue,'Value',1,'Enable','inactive');
autoColor = get(handles.autoColor.blue,'BackgroundColor');
if ~isempty(varargin)
	standAlone = 0;
    mainFigHandles = varargin{1,1};
    folderName = getappdata(mainFigHandles.figure,'folderName');
    ok = helperfcn_load;
    if ~ok 
        standAlone = 1;
        set(handles.hist.binNo,'String','1024','UserData',1024);
        set(handles.hist.smooth.width,'String','0.05','UserData',0.05);
        set([handles.xAxis.trans.log,handles.yAxis.trans.log],'Value',1,'Enable','inactive');
        set([handles.axesProps.panel,handles.plotModePanel,handles.underTableRow,...
            handles.underTableRow2],'Enable','off');
        set(handles.underTableRow3,'Enable','off');
        set([handles.saveMetaFile,handles.createFig,handles.table,handles.figureName,handles.text],'Enable','off');
    else
        set(handles.xAxis.trans.log,'Value',get(mainFigHandles.xAxis.trans.log,'Value'),...
                                    'Enable',get(mainFigHandles.xAxis.trans.log,'Enable'));
        set(handles.xAxis.trans.none,'Value',get(mainFigHandles.xAxis.trans.none,'Value'),...
                                    'Enable',get(mainFigHandles.xAxis.trans.log,'Enable'));
        set(handles.yAxis.trans.log,'Value',get(mainFigHandles.yAxis.trans.log,'Value'),...
                                    'Enable',get(mainFigHandles.yAxis.trans.log,'Enable'));
        set(handles.yAxis.trans.none,'Value',get(mainFigHandles.yAxis.trans.none,'Value'),...
                                    'Enable',get(mainFigHandles.yAxis.trans.log,'Enable'));
        set(handles.xAxis.param,'String',metaFile{1}.colheaders,...
                                'Value',get(mainFigHandles.xAxis.param,'value'));
        set(handles.hist.binNo,'String',num2str(get(mainFigHandles.hist.noOfBins,'UserData')),...
                               'UserData',get(mainFigHandles.hist.noOfBins,'UserData'));
        set(handles.hist.smooth.checkBox,'Value',get(mainFigHandles.hist.smooth,'Value'));
        set(handles.hist.smooth.width,'String',num2str(get(mainFigHandles.hist.smoothWidth,'UserData')),...
                                              'UserData',get(mainFigHandles.hist.smoothWidth,'UserData'));                   
        if get(mainFigHandles.axes.plotMode,'Value') == 1
            set(handles.plotMode,'Value',2);
            set(handles.yAxis.param,'Value',get(mainFigHandles.yAxis.param,'value'));
        else
        	set(handles.plotMode,'Value',1);
        end 
        plotMode_callback('loadCall');

        helperfcn_updateData('resetLimits');
        set(handles.chooseDir.box,'String',folderName,'UserData',folderName);
    end
else
    standAlone = 1;
    set(handles.hist.binNo,'String','1024','UserData',1024);
    set(handles.hist.smooth.width,'String','0.05','UserData',0.05);
    set([handles.xAxis.trans.log,handles.yAxis.trans.log],'Value',1,'Enable','inactive');
    set([handles.axesProps.panel,handles.plotModePanel,handles.underTableRow,...
        handles.underTableRow2],'Enable','off');
    set(handles.underTableRow3,'Enable','off');
    set([handles.saveMetaFile,handles.createFig,handles.table,handles.figureName,handles.text],'Enable','off');
end
plotMode_callback('loadCall');
set(handles.figure,'Visible','on');
end

%------------------------------------CALLBACKS----------------------------------
function chooseDir_callback(hObject,eventdata)%#ok
ok = 1;
switch hObject 
    case handles.chooseDir.box
        folderName = get(hObject,'String');
        if isempty(folderName) || ~exist(folderName,'dir')
            ok = 0;
            set(handles.chooseDir.box,'String',get(handles.chooseDir.box,'UserData'));
        end
    case handles.chooseDir.button
        currentPath = get(handles.chooseDir.box,'UserData');
        if ~isempty(currentPath)
            [~,folderName,ok] = uigetfile('*.mat','Choose a folder to create subplot figure',currentPath);
        else
            [~,folderName,ok] = uigetfile('*.mat','Choose a folder to create subplot figure');
        end
end
if ok
    ok = helperfcn_load;
    if ~ok && hObject == handles.chooseDir.box
    	set(handles.chooseDir.box,'String',get(handles.chooseDir.box,'UserData'));
    elseif strcmp(folderName,get(handles.chooseDir.box,'UserData'))
        return;
    elseif ok
        helperfcn_updateData('resetLimits');
        set(handles.chooseDir.box,'String',folderName,'UserData',folderName);  
        set(handles.xAxis.param,'String',metaFile{1}.colheaders,'Value',1);
        plotMode_callback('');
        if standAlone
            set([handles.axesProps.panel,handles.plotModePanel,handles.underTableRow,...
                handles.underTableRow2],'Enable','on');
            set(handles.underTableRow3,'Enable','on');
            set([handles.saveMetaFile,handles.createFig,handles.figureName,handles.text,handles.table],'Enable','on');
            set(handles.yAxis.limits.low,'String','0','UserData',0,'Enable','off');
            standAlone = 0;
        end  
    end
end
end    
function plotMode_callback(hObject,eventdata)%#ok
switch get(handles.plotMode,'Value')
    case 1
        set(handles.yAxis.math,'Visible','off');
        set(handles.histParamsYaxisTransPanel,'SelectedChild',1);
        set(handles.underTableRow3,'SelectedChild',1);
        set(handles.xAxis.text,'String','Choose parameter:');
        set(handles.yAxis.text,'String','Y Axis:');
        set(handles.yAxis.limits.low,'String','0','UserData',0,'Enable','off');
        set([handles.hist.limits.low,handles.hist.limits.hi,handles.limitsHistText],'Visible','on');
        if ~get(handles.hist.smooth.checkBox,'Value')
            set(handles.yAxis.param,'String',{'Counts';'Percentage'});
            if ~strcmp(hObject,'loadCall')
                set(handles.yAxis.param,'Enable','on');
            end
        else
            set(handles.yAxis.param,'String',{'Density function'},'Value',1,'Enable','off');
        end
        if get(handles.sameLimits,'Value')
            set(handles.table,'ColumnEditable',logical([1,0,1,0,0,0,0,0,0,0,0,0]));
        else
            set(handles.table,'ColumnEditable',logical([1,0,1,0,0,1,0,1,0,0,0,1]));
        end
    case 2
        set(handles.yAxis.math,'Visible','on');
        set(handles.histParamsYaxisTransPanel,'SelectedChild',2);
        set(handles.underTableRow3,'SelectedChild',2);
        set(handles.xAxis.text,'String','X axis parameter:');
        set(handles.yAxis.text,'String','Y axis parameter:');
        set([handles.hist.limits.low,handles.hist.limits.hi,handles.limitsHistText],'Visible','off');
        set(handles.yAxis.param,'String',metaFile{1}.colheaders,...
            'Value',find(1:length(metaFile{1}.colheaders)~=get(handles.xAxis.param,'Value'),1,'first'));
        if ~strcmp(hObject,'loadCall')
            set([handles.yAxis.param,handles.yAxis.limits.low],'Enable','on')
        end
        if get(handles.sameLimits,'Value')
            set(handles.table,'ColumnEditable',logical([1,0,1,0,0,0,0,0,0,0,0,0]));
        else
            set(handles.table,'ColumnEditable',logical([1,0,1,0,0,1,0,1,0,1,0,1]));
        end
end
if ~strcmp(hObject,'loadCall')
    helperfcn_updateData('resetLimits');
end
end
function axesParamChange_callback(hObject,eventdata)%#ok
switch hObject
    case {handles.xAxis.math,handles.yAxis.math}
        if get(hObject,'value')
            output = mathParam_dlg(metaFile{1}.colheaders);
            if ~iscell(output)
                set(hObject,'value',0);
                return;
            else
                if hObject == handles.xAxis.math
                    operationX = output{1,2};
                    set(handles.xAxis.param,'String',output(1,1),'Value',1,'Enable','off');
                else
                    operationY = output{1,2};
                    set(handles.yAxis.param,'String',output(1,1),'Value',1,'Enable','off');
                end
            end
        else        
            if hObject == handles.xAxis.math
                set(handles.xAxis.param,'String',metaFile{1}.colheaders,'Enable','on');
                operationX = '';
            else
                set(handles.yAxis.param,'String',metaFile{1}.colheaders,'Enable','on');
                operationY = '';
            end
        end
end
helperfcn_updateData('resetLimits');
end
function axesTransChange_callback(hObject,eventdata)%#ok
set(hObject,'Enable','inactive');
switch hObject
    case handles.xAxis.trans.log
        set(handles.xAxis.trans.none,'Value',0,'Enable','on');
    case handles.xAxis.trans.none
        set(handles.xAxis.trans.log,'Value',0,'Enable','on');
    case handles.yAxis.trans.log
        set(handles.yAxis.trans.none,'Value',0,'Enable','on');
    case handles.yAxis.trans.none
        set(handles.yAxis.trans.log,'Value',0,'Enable','on');
end
helperfcn_updateData('resetLimits');
end

function histBinNo_callback(hObject,eventdata)%#ok
newVal = round(str2double(get(hObject,'String')));    
if isnan(newVal) || newVal < 2
    set(hObject,'String',num2str(get(hObject,'UserData')));
else
    set(hObject,'String',num2str(newVal),'UserData',newVal);
    helperfcn_updateData('resetLimits');
end
end
function histAddPropsCheckBoxes_callback(hObject,eventdata)%#ok
switch hObject
    case handles.histAddProps.grey.checkBox
        switch get(hObject,'Value')
            case 1
                set(handles.histAddProps.grey.statParam,'Enable','on');
            case 0
                set(handles.histAddProps.grey.statParam,'Enable','off');
        end
    case handles.histAddProps.addStatParam.checkBox
        switch get(hObject,'Value')
            case 1
                set(handles.histAddProps.addStatParam.statParam,'Enable','on');
            case 0
                set(handles.histAddProps.addStatParam.statParam,'Enable','off');
        end
end
end
function histSmooth_callback(hObject,venetData)%#ok
switch hObject
    case handles.hist.smooth.checkBox
        switch get(hObject,'Value')
            case 1
                set([handles.hist.smooth.width,handles.hist.smooth.text1,...
                    handles.hist.smooth.text2],'Enable','on');
                set(handles.yAxis.param,'string',{'Density function'},'enable','off','Value',1);
            case 0
                set([handles.hist.smooth.width,handles.hist.smooth.text1,...
                    handles.hist.smooth.text2],'Enable','off');
                set(handles.yAxis.param,'string',{'Counts','Percentage'},'enable','on');
        end
    case handles.hist.smooth.width
        newVal = str2double(get(hObject,'String'));
        if isnan(newVal) || newVal<0 || newVal == get(hObject,'UserData')
            set(hObject,'String',num2str(get(hObject,'UserData')));
            return;
        else
            set(hObject,'String',num2str(newVal),'UserData',newVal);
        end
end
helperfcn_updateData('resetLimits');
end
function dotplotTwoDhist_callback(hObject,eventdata)%#ok
switch hObject
    case handles.dotplotAddProps.twoDhist.checkBox
        switch get(hObject,'Value')
            case 1
                set(handles.dotplotAddProps.twoDhist.dlg,'Enable','on');
            case 0
                set(handles.dotplotAddProps.twoDhist.dlg,'Enable','off');                
        end
    case handles.dotplotAddProps.twoDhist.dlg
        cols = metaFile{1}.colheaders;
        xAxis = cols{get(handles.xAxis.param,'Value')};
        yAxis = cols{get(handles.yAxis.param,'Value')};
        output = isolineParam_dlg(xAxis,yAxis,twoDhistParam.xBinNo,...
                                  twoDhistParam.yBinNo,twoDhistParam.isolineNo);
        if ~isequal(output,0)
            twoDhistParam.xBinNo = output(1);
            twoDhistParam.yBinNo = output(2);
            twoDhistParam.isolineNo = output(3);
        end
end
end
function dotplotLayout_callback(hObject,eventdata)%#ok
chosenFiles = find(cellfun(@(x) x==1,tableData(:,1)));    
switch hObject
    case {handles.dotplotAddProps.layout.rows,handles.dotplotAddProps.layout.cols}
        newVal = round(str2double(get(hObject,'String')));
        if isnan(newVal) || newVal < 1
            set(hObject,'String',num2str(get(hObject,'UserData')));
        else
            set(hObject,'String',num2str(newVal),'UserData',newVal);
            rows = get(handles.dotplotAddProps.layout.rows,'UserData');
            cols = get(handles.dotplotAddProps.layout.cols,'UserData');
            if rows*cols < length(chosenFiles)
                set([handles.dotplotAddProps.layout.rows,handles.dotplotAddProps.layout.cols],...
                                                        'BackgroundColor',[1 0.8 1]);
            elseif rows*cols == length(chosenFiles)
                set(handles.dotplotAddProps.layout.rows,'BackgroundColor','white');
                set(handles.dotplotAddProps.layout.cols,'BackgroundColor','white');
            else
                calRows = floor(sqrt(length(chosenFiles)));
                calCols = ceil(sqrt(length(chosenFiles)));
                if (calRows * calCols  < length(chosenFiles) && calRows+1 * calCols < rows*cols) ||...
                   (calRows * calCols >= length(chosenFiles) && calRows   * calCols < rows*cols)
                    if calRows*calCols < length(chosenFiles)
                        calRows = calRows + 1;
                    end
                end
                set(handles.dotplotAddProps.layout.rows,'String',num2str(calRows),'UserData',calRows,'BackgroundColor','white');
                set(handles.dotplotAddProps.layout.cols,'String',num2str(calCols),'UserData',calCols,'BackgroundColor','white');
            end
        end
    case handles.dotplotAddProps.layout.reset
    	rows = floor(sqrt(length(chosenFiles)));
    	cols = ceil(sqrt(length(chosenFiles)));
        if rows*cols < length(chosenFiles)
            rows = rows + 1;
        end
        set(handles.dotplotAddProps.layout.rows,'String',num2str(rows),'UserData',rows,'BackgroundColor','white');
        set(handles.dotplotAddProps.layout.cols,'String',num2str(cols),'UserData',cols,'BackgroundColor','white');
end
end

function autoColor_callback(hObject,eventdata)%#ok
set([handles.autoColor.red,handles.autoColor.yellow,handles.autoColor.green,...
     handles.autoColor.cyan,handles.autoColor.blue,handles.autoColor.magenta],...
     'Value',0);
set(hObject,'Value',1);
set(handles.autoColor.text,'String','Auto color (on):','FontWeight','bold');
autoColor = get(hObject,'BackgroundColor');

chosenFiles = find(cellfun(@(x) x==1,tableData(:,1)));
notChosenFiles = ~ismember(1:size(tableData,1),chosenFiles);
colorAdd = (length(chosenFiles):-1:1).*(0.8/length(chosenFiles));
for i = 1:length(chosenFiles)
    specColor = autoColor;
    specColor(specColor<1) = colorAdd(i);
    tableData(chosenFiles(i),4) = {color2htmlStr(specColor)};
end
tableData(notChosenFiles,4) = {color2htmlStr([1 1 1])};
set(handles.table,'Data',tableData);
end
function semiAutoColor_Callback(hObject,eventdata)%#ok
chosenFiles = find(cellfun(@(x) x==1,tableData(:,1)));
output = subplotsFigureTool_semiAutoColor_dlg(tableData(chosenFiles,2));
if iscell(output)
    fileIndeces = output{1,1};
    color = output{1,2};
    set([handles.autoColor.red,handles.autoColor.yellow,handles.autoColor.green,...
         handles.autoColor.cyan,handles.autoColor.blue,handles.autoColor.magenta],...
        'Value',0);
    set(handles.autoColor.text,'String','Auto color (off):','FontWeight','normal');
    autoColor = '';

    colorAdd = (length(fileIndeces):-1:1).*(0.8/length(fileIndeces));
    for i = 1:length(fileIndeces)
        specColor = color;
        specColor(specColor<1) = colorAdd(i);
        tableData(chosenFiles(fileIndeces(i)),4) = {color2htmlStr(specColor)};
    end
    set(handles.table,'Data',tableData); 
end
end
function tableSelectAllOrFirst_callback(hObject,eventData)%#ok
if hObject == handles.selectAll
    tableData(:,1) = {true};
    set(hObject,'Enable','inactive');
elseif hObject == handles.selectFirst
	tableData(:,1) = {false};
    tableData(1,1) = {true};
    set(handles.selectAll,'Enable','on','Value',0);
end
set(handles.table,'Data',tableData);
chosenFiles = find(cellfun(@(x) x==1,tableData(:,1)));   
set(handles.dotplotAddProps.layout.text,'String',['Subplots layout (',num2str(length(chosenFiles)),' subplots):']);
rows = get(handles.dotplotAddProps.layout.rows,'UserData');
cols = get(handles.dotplotAddProps.layout.cols,'UserData');
if rows*cols < length(chosenFiles)
    set([handles.dotplotAddProps.layout.rows,handles.dotplotAddProps.layout.cols],...
                                            'BackgroundColor',[1 0.8 1]);

elseif rows*cols == length(chosenFiles)
    set(handles.dotplotAddProps.layout.rows,'BackgroundColor','white');
    set(handles.dotplotAddProps.layout.cols,'BackgroundColor','white');
else
    calRows = floor(sqrt(length(chosenFiles)));
    calCols = ceil(sqrt(length(chosenFiles)));
    if (calRows * calCols  < length(chosenFiles) && calRows+1 * calCols < rows*cols) ||...
       (calRows * calCols >= length(chosenFiles) && calRows   * calCols < rows*cols)
        if calRows*calCols < length(chosenFiles)
            calRows = calRows + 1;
        end
    end
    set(handles.dotplotAddProps.layout.rows,'String',num2str(calRows),'UserData',calRows,'BackgroundColor','white');
    set(handles.dotplotAddProps.layout.cols,'String',num2str(calCols),'UserData',calCols,'BackgroundColor','white');
end
helperfcn_updateData('resetLimits');
helperfcn_upDownEnableDisable;    
end
function tableCellEdit_callback(hObject,eventdata)
newTableData = get(hObject,'data');
chosenFiles = find(cellfun(@(x) x==1,newTableData(:,1)));   
tableRow = eventdata.Indices(1,1);
tableCol = eventdata.Indices(1,2);

if tableCol == 1 
    if isempty(chosenFiles)
        set(hObject,'Data',tableData);
        return;
    else
        if length(chosenFiles)==size(tableData,1)
            set(handles.selectAll,'value',1,'Enable','inactive');    
        else     
            set(handles.selectAll,'value',0,'Enable','on');    
        end
        tableData = newTableData;
        set(handles.dotplotAddProps.layout.text,'String',['Subplots layout (',num2str(length(chosenFiles)),' subplots):']);
        rows = get(handles.dotplotAddProps.layout.rows,'UserData');
        cols = get(handles.dotplotAddProps.layout.cols,'UserData');
        if rows*cols < length(chosenFiles)
            set([handles.dotplotAddProps.layout.rows,handles.dotplotAddProps.layout.cols],...
                                                    'BackgroundColor',[1 0.8 1]);
                                                
        elseif rows*cols == length(chosenFiles)
            set(handles.dotplotAddProps.layout.rows,'BackgroundColor','white');
            set(handles.dotplotAddProps.layout.cols,'BackgroundColor','white');
        else
            calRows = floor(sqrt(length(chosenFiles)));
            calCols = ceil(sqrt(length(chosenFiles)));
            if (calRows * calCols  < length(chosenFiles) && calRows+1 * calCols < rows*cols) ||...
               (calRows * calCols >= length(chosenFiles) && calRows   * calCols < rows*cols)
                if calRows*calCols < length(chosenFiles)
                    calRows = calRows + 1;
                end
            end
            set(handles.dotplotAddProps.layout.rows,'String',num2str(calRows),'UserData',calRows,'BackgroundColor','white');
            set(handles.dotplotAddProps.layout.cols,'String',num2str(calCols),'UserData',calCols,'BackgroundColor','white');
        end
        helperfcn_updateData('resetLimits');
        helperfcn_upDownEnableDisable;
    end
elseif ismember(tableCol,[6,8,10,12])
    newVal = str2double(eventdata.EditData);
    if ~tableData{tableRow,1} || isnan(newVal) || ...
       tableCol == 6 && newVal >= tableData{tableRow,8} ||...
       tableCol == 8 && newVal <= tableData{tableRow,6} ||...
       tableCol == 10 && newVal >= tableData{tableRow,12} ||...
       tableCol == 12 && newVal <= tableData{tableRow,10} ||...
       (get(handles.xAxis.trans.log,'Value') && ismember(tableCol,[6,8]) && newVal<0) ||...
       (get(handles.yAxis.trans.log,'Value') && ismember(tableCol,[10,12]) && newVal<0)
   
        set(hObject,'Data',tableData);
        return;
    end
    tableData = newTableData;
elseif tableCol == 3
    tableData = newTableData;
end
set(hObject,'Data',tableData);
end
function tableChangeColor_callback(hObject,eventdata)
if ~isempty(eventdata.Indices)
    row = eventdata.Indices(1,1);
    column = eventdata.Indices(1,2);
    if column == 4
        color = uisetcolor;
        if ~isequal(color,0)
            color = color2htmlStr(color);
            if ~isequal(color,tableData{row,column})
                set([handles.autoColor.red,handles.autoColor.yellow,handles.autoColor.green,...
                     handles.autoColor.cyan,handles.autoColor.blue,handles.autoColor.magenta],...
                     'Value',0);
                set(handles.autoColor.text,'String','Auto color (off):','FontWeight','normal');
                autoColor = '';
                tableData(row,column) = {color};
                set(hObject,'Data',tableData);
            end
        end
    end
end
end
function tableMoveUpDown_callback(hObject,eventdata)%#ok
currentIndex = find(cellfun(@(x) x==1,tableData(:,1)));
switch hObject
    case {handles.moveUp}
        newIndex = currentIndex-1;
    case {handles.moveDown}
        newIndex = currentIndex+1;
end
metaFile([currentIndex,newIndex]) = metaFile([newIndex,currentIndex]);
metaData(:,:,[currentIndex,newIndex]) = metaData(:,:,[newIndex,currentIndex]);
tableData([currentIndex,newIndex],:) = tableData([newIndex,currentIndex],:);
set(handles.table,'data',tableData); 
helperfcn_upDownEnableDisable;    
end

function sameLimits_callback(hObject,eventdata)%#ok
resetLimits = 0;
switch hObject
    case handles.sameLimits
        if get(hObject,'Value')
            set([handles.xAxis.limits.low,handles.xAxis.limits.hi,...
                handles.yAxis.limits.hi,handles.hist.limits.low,handles.hist.limits.hi,...
                handles.updateLimBasedOnSelection,handles.resetLimBasedOnAll],...
                'Enable','on');
            set(handles.table,'ColumnEditable',logical([1,0,1,0,0,0,0,0,0,0,0,0]));
            if get(handles.plotMode,'Value') == 2
                set(handles.yAxis.limits.low,'Enable','on')
            end
        else
            set([handles.xAxis.limits.low,handles.xAxis.limits.hi,handles.yAxis.limits.low,...
                handles.yAxis.limits.hi,handles.hist.limits.low,handles.hist.limits.hi,...
                handles.updateLimBasedOnSelection,handles.resetLimBasedOnAll],...
                'Enable','off');
            if get(handles.plotMode,'Value') == 1
                set(handles.table,'ColumnEditable',logical([1,0,1,0,0,1,0,1,0,0,0,1]));
            else
                set(handles.table,'ColumnEditable',logical([1,0,1,0,0,1,0,1,0,1,0,1]));
            end
        end
        resetLimits = 1;
    case {handles.xAxis.limits.low,handles.xAxis.limits.hi,handles.yAxis.limits.low,...
          handles.yAxis.limits.hi,handles.hist.limits.low,handles.hist.limits.hi}

        newLim = str2double(get(hObject,'String'));
        
        if isnan(newLim) || ...
           (hObject == handles.xAxis.limits.low && newLim > get(handles.xAxis.limits.hi,'UserData')) || ...
           (hObject == handles.xAxis.limits.hi  && newLim < get(handles.xAxis.limits.low,'UserData'))|| ...
           (hObject == handles.yAxis.limits.low && newLim > get(handles.yAxis.limits.hi,'UserData')) || ...
           (hObject == handles.yAxis.limits.hi  && newLim < get(handles.yAxis.limits.low,'UserData'))|| ...
           (hObject == handles.hist.limits.low  && newLim > get(handles.hist.limits.hi,'UserData'))  || ...
           (hObject == handles.hist.limits.hi   && newLim < get(handles.hist.limits.low,'UserData')) || ...
           (get(handles.xAxis.trans.log,'Value') && ismember(hObject,[handles.xAxis.limits.low,handles.xAxis.limits.hi,handles.hist.limits.low,handles.hist.limits.hi]) && newLim<0) ||...
           (get(handles.yAxis.trans.log,'Value') && ismember(hObject,[handles.yAxis.limits.low,handles.yAxis.limits.hi]) && newLim<0)

            set(hObject,'String',num2str(get(hObject,'UserData')));
            return;
        else
        	set(hObject,'String',num2str(newLim),'UserData',newLim);
            if ismember(hObject,[handles.xAxis.limits.low,handles.xAxis.limits.hi,...
                                 handles.yAxis.limits.low,handles.yAxis.limits.hi])
                chosenFiles = find(cellfun(@(x) x==1,tableData(:,1)));
                notChosenFiles = ~ismember(1:size(tableData,1),chosenFiles);
                tableData(chosenFiles,6) = {get(handles.xAxis.limits.low,'UserData')};
                tableData(chosenFiles,8) = {get(handles.xAxis.limits.hi,'UserData')};
                tableData(chosenFiles,10) = {get(handles.yAxis.limits.low,'UserData')};
                tableData(chosenFiles,12) = {get(handles.yAxis.limits.hi,'UserData')};
                tableData(notChosenFiles,[6,8,10,12]) = {''};
                set(handles.table,'Data',tableData);
            	return;
            else
                resetLimits = 'userDefinedHistLimits';
            end
        end
    case handles.updateLimBasedOnSelection
        resetLimits = 1;
    case handles.resetLimBasedOnAll
        resetLimits = 'resetBasedOnAll';
end
helperfcn_updateData(resetLimits);
end

function saveMetaFile_callback(hObject,eventdata)%#ok
xParam = get(handles.xAxis.param,'String');
xParam = xParam{get(handles.xAxis.param,'Value')};
if get(handles.plotMode,'Value') == 1
    yParam = '';
else
    yParam = get(handles.yAxis.param,'String');
    yParam = yParam{get(handles.yAxis.param,'Value')};
end
chosenFiles = find(cellfun(@(x) x==1,tableData(:,1)));
defaultFileName = [folderName,filesep,[xParam,yParam],'_MetaFile'];
[FileName,PathName] = uiputfile('*.mat','Save Meta-file of untransformed data from all selected files',defaultFileName);
if FileName
    data = NaN(max(cellfun(@(x) length(x.data),metaFile(chosenFiles))),2,length(chosenFiles));
    if get(handles.xAxis.math,'Value')
        for i = 1:length(chosenFiles)
            lengthOfThisFile = length(metaFile{chosenFiles(i)}.data);
            param1 = metaFile{chosenFiles(i)}.data(:,operationX{1});
            switch operationX{3}
                     case 'numeric'
                         param2 = str2double(operationX{4});
                     case 'column'
                         param2 = metaFile{chosenFiles(i)}.data(:,operationX{4});
                     case 'statistics'
                         switch operationX{4}
                             case 'Mean'
                                 param2 = nanmean(param1);
                             case 'Median'
                                 param2 = nanmedian(param1);
                         end
            end
            switch operationX{2}
                case '+'
                    data(1:lengthOfThisFile,1,i) = param1+param2;
                case '-'
                    data(1:lengthOfThisFile,1,i) = param1-param2;
                case '*'
                    data(1:lengthOfThisFile,1,i) = param1.*param2;
                case '/'
                    data(1:lengthOfThisFile,1,i) = param1./param2;
                case '^'
                    data(1:lengthOfThisFile,1,i) = param1.^param2;
            end
        end
    else %~get(handles.xAxis.math,'Value')
        for i = 1:size(tableData,1)
            lengthOfThisFile = length(metaFile{chosenFiles(i)}.data);
            data(1:lengthOfThisFile,1,i) = metaFile{chosenFiles(i)}.data(:,get(handles.xAxis.param,'Value'));
        end
    end
    if get(handles.plotMode,'Value') == 2
        if get(handles.yAxis.math,'Value')
            for i = 1:size(tableData,1)
                lengthOfThisFile = length(metaFile{chosenFiles(i)}.data);
                param1 = metaFile{chosenFiles(i)}.data(:,operationY{1});
                switch operationY{3}
                         case 'numeric'
                             param2 = str2double(operationY{4});
                         case 'column'
                             param2 = metaFile{chosenFiles(i)}.data(:,operationY{4});
                         case 'statistics'
                             switch operationY{4}
                                 case 'Mean'
                                     param2 = nanmean(param1);
                                 case 'Median'
                                     param2 = nanmedian(param1);
                             end
                end
                switch operationY{2}
                    case '+'
                        data(1:lengthOfThisFile,2,i) = param1+param2;
                    case '-'
                        data(1:lengthOfThisFile,2,i) = param1-param2;
                    case '*'
                        data(1:lengthOfThisFile,2,i) = param1.*param2;
                    case '/'
                        data(1:lengthOfThisFile,2,i) = param1./param2;
                    case '^'
                        data(1:lengthOfThisFile,2,i) = param1.^param2;
                end
            end
        else %~get(handles.yAxis.math,'Value')
            for i = 1:size(tableData,1)
                lengthOfThisFile = length(metaFile{chosenFiles(i)}.data);
                data(1:lengthOfThisFile,2,i) = metaFile{chosenFiles(i)}.data(:,get(handles.yAxis.param,'Value'));
            end
        end
    end
    if get(handles.plotMode,'Value') == 1
        data(:,2,:) = [];%#ok
    end
    save([PathName,FileName],'data');
end    
end
function createFig_callback(hObject,eventdata)%#ok
chosenFiles = find(cellfun(@(x) x==1,tableData(:,1)));

yAxis = get(handles.yAxis.param,'string');
yAxis = yAxis{get(handles.yAxis.param,'value')};
xAxis = get(handles.xAxis.param,'string');
xAxis = xAxis{get(handles.xAxis.param,'value')};
newFig = figure('Name',get(handles.figureName,'String'),'PaperType', 'A4','Visible','off');
subplotsHandles = zeros(size(chosenFiles));

colorCell= cellfun(@(x) htmlstr2rgb(x), tableData(chosenFiles,4),'uniformOutput',false);
color = cell2mat(cellfun(@(x) cell2mat(x),colorCell,'uniformoutput',false));
xLims = [cell2mat(tableData(chosenFiles,6)),cell2mat(tableData(chosenFiles,8))];
yLims = [cell2mat(tableData(chosenFiles,10)),cell2mat(tableData(chosenFiles,12))];

if get(handles.xAxis.trans.log,'Value')
    xLims = log10(xLims);
end
if get(handles.plotMode,'Value') == 2 && get(handles.yAxis.trans.log,'Value')
    yLims = log10(yLims);
end

switch get(handles.plotMode,'Value')
    case 1 %histograms
        histLim(1) = get(handles.hist.limits.low,'UserData');
        histLim(2) = get(handles.hist.limits.hi,'UserData');
        if get(handles.xAxis.trans.log,'Value')
        	histLim = log10(histLim);
        end
        binNo = get(handles.hist.binNo,'UserData');
        scale = linspace(histLim(1),histLim(2),binNo);
        
        if get(handles.sameLimits,'Value')
            spacing = 0.01;
        else
            spacing = 0.03;
        end
        
        for i = 1:length(chosenFiles)
            xLim = xLims(i,:);
            yLim = yLims(i,:);

            subplotsHandles(i) = subaxis(length(chosenFiles),1,i,'SpacingVert',spacing); 
            area(scale,histPlotData(:,i),'FaceColor',color(i,:));            
            set(subplotsHandles(i),'NextPlot','add','Xlim',xLim,'YLim',yLim,'FontWeight','bold','Box','off','Layer','top','TickDir','out');
            
            if get(handles.histAddProps.grey.checkBox,'Value') || get(handles.histAddProps.addStatParam.checkBox,'Value')
                data = metaData(~isnan(metaData(:,1,chosenFiles(i))),1,chosenFiles(i));
                if get(handles.xAxis.trans.log,'Value')
                    data = 10.^data;
                end
                
                if get(handles.histAddProps.grey.checkBox,'Value')
                    switch get(handles.histAddProps.grey.statParam,'Value')
                        case 1 %mean
                            val = mean(data);
                            str = ['Mean: ',num2str(val,3)];
                        case 2 %median
                            val = median(data);
                            str = ['Median: ',num2str(val,3)];
                        case 3 %mode
                            [~,modeIndex] = max(histPlotData(:,i));
                            val = scale(modeIndex);
                            if get(handles.xAxis.trans.log,'Value')
                                str = ['Mode: ',num2str(10.^val,3)];
                            else
                                str = ['Mode: ',num2str(val,3)];
                            end                                
                    end
                    if get(handles.xAxis.trans.log,'Value') && ...
                       get(handles.histAddProps.grey.statParam,'Value') ~= 3
                    	val = log10(val);
                    end
                    line([val val],yLim,'parent',subplotsHandles(i),'LineWidth',3,'Color',[.6 .6 .6]);
                    text('string',str,'Units','normalized','Position',[0.85 0.85],...
                         'parent',subplotsHandles(i),'Color',[.6 .6 .6],'FontWeight','bold');
                end
                if get(handles.histAddProps.addStatParam.checkBox,'Value')
                    switch get(handles.histAddProps.addStatParam.statParam,'Value')
                        case 1 %Min
                            val = min(data);
                            str = ['Min: ',num2str(val,3)];
                        case 2 %Max
                            val = max(data);
                            str = ['Max: ',num2str(val,3)];
                        case 3 %STD
                            val = std(data);
                            str = ['STD: ',num2str(val,3)];
                        case 4 %Variance
                            val = var(data);
                            str = ['Var.: ',num2str(val,3)];
                        case 5 %CV
                            val = std(data)/mean(data);
                            str = ['CV: ',num2str(val,3)];
                        case 6 %CV^2
                            val = (std(data)/mean(data))^2;
                            str = ['CV^2: ',num2str(val,3)];
                        case 7 %Var/mean
                            val = var(data)/mean(data);
                            str = ['Var./Mean: ',num2str(val,3)];
                        case 8
                            val = skewness(data);
                            str = ['Skewness: ',num2str(val,3)];
                    end
                    text('string',str,'Units','normalized','Position',[0.85,0.55],...
                         'parent',subplotsHandles(i),'Color','k','FontWeight','bold');
                end
            end
            text('string',tableData{chosenFiles(i),3},'Units','normalized',...
                'Position',[0.01,0.80],'parent',subplotsHandles(i),'Color','k',...
                'FontWeight','bold');     
            hold(subplotsHandles(i),'off');
        end
        %Arrange ticks for transformations:
        if get(handles.xAxis.trans.log,'Value')
            set(subplotsHandles,'Xtick',[]);
            for i = 1:length(subplotsHandles)
                position = get(subplotsHandles(i),'Position');
                position(2) = position(2)-0.007;
                position(4) = 0.007;
                h1 = axes('Position',position);
                xLim = get(subplotsHandles(i),'XLim');
                start = ceil(xLim(1));
                ending = floor(xLim(2));
                xTick = start-1:ending+1;
                xg = xTick;
                yg = [0 1];
                xx = reshape([xg;xg;NaN(1,length(xg))],1,length(xg)*3);
                yy = repmat([yg NaN],1,length(xg));
                plot(xx,yy,'k');
                hold(h1,'on');
                for j = 1:(length(xTick)-1)
                    xg = xTick(j)+log10(linspace(1,10,10));
                    yg = [0.5 1];
                    xx = reshape([xg;xg;NaN(1,length(xg))],1,length(xg)*3);
                    yy = repmat([yg NaN],1,length(xg));
                    plot(h1,xx,yy,'k');
                end
                set(h1,'XLim',xLim,'YLim',[0 1],'XTick',[],'YTick',[],'Color','none','Visible','off','HitTest','off');
                hold(h1,'off');
                xTickLabels = cell(size(xTick));
                xTickLabels(all([xTick<=2;xTick>=-2])) = num2cell(10.^xTick(all([xTick<=2;xTick>=-2])));
                xTickLabels(any([xTick>2;xTick<-2])) = arrayfun(@(x) ['10^',num2str(x)],xTick(any([xTick>2;xTick<-2])),'UniformOutput',false);
                set(subplotsHandles(i),'XTick',xTick,'XtickLabel',xTickLabels);
            end
        end   
        if get(handles.sameLimits,'Value')
            set(subplotsHandles(1:end-1),'XtickLabel',{''});
        end
        if get(handles.xAxis.trans.log,'Value')
            xlabel(subplotsHandles(end),[xAxis,' (Log)']);
        else
            xlabel(subplotsHandles(end),xAxis);
        end
        newAxes = axes('Position',[0 0 1 1],'XLim',[0 1],'YLim',[0 1],'XTick',[],'YTick',[],'Color','none','Visible','off','HitTest','off');
        text('String',yAxis,'Parent',newAxes,'Position',[0.01 0.5],'Color','k','FontWeight','bold','Rotation',90);
    case 2 %scatter plots
        subAxisRows = get(handles.dotplotAddProps.layout.rows,'UserData');
        subAxisCols = get(handles.dotplotAddProps.layout.cols,'UserData');
        if subAxisRows*subAxisCols < length(chosenFiles)
            errordlg('Layout error, number of rows and columns is not sufficient for the number of chosen files','Layour error','Replace');
            delete(newFig);
            return;
        end
        for i = 1:length(chosenFiles)
            xLim = xLims(i,:);
            yLim = yLims(i,:);
            
            subplotsHandles(i) = subaxis(subAxisRows,subAxisCols,i);
            
            line('Parent',subplotsHandles(i),'XData',metaData(:,1,i),'YData',metaData(:,2,i),...
                'Color',color(i,:),'Marker','.','markerSize',1,'LineStyle','none');
            hold(subplotsHandles(i),'on');
            
            if get(handles.dotplotAddProps.twoDhist.checkBox,'Value')
                [nanRows,~] = find(isnan(metaData(:,:,i)));
                nonNaNplot = metaData(:,:,i);
                nonNaNplot(unique(nanRows),:) = [];
                [xi,yi,z] = histmap(nonNaNplot(:,1),nonNaNplot(:,2),twoDhistParam.xBinNo,twoDhistParam.yBinNo);
                [X,Y]=meshgrid(xi,yi);
                contour(subplotsHandles(i),X,Y,z,twoDhistParam.isolineNo);
            end
            text('string',tableData{chosenFiles(i),3},'Units','normalized',...
                'Position',[0.01,0.95],'parent',subplotsHandles(i),'Color','k',...
                'FontWeight','bold'); 
            set(subplotsHandles(i),'NextPlot','replace','Xlim',xLim,'YLim',yLim,'FontWeight','bold','Box','off','Layer','top','TickDir','out');
        end
        %Arrange ticks for transformations:
        if get(handles.xAxis.trans.log,'Value')
            set(subplotsHandles,'Xtick',[]);
            for i = 1:length(subplotsHandles)
                position = get(subplotsHandles(i),'Position');
                position(2) = position(2)-0.007;
                position(4) = 0.007;
                h1 = axes('Position',position);
                xLim = get(subplotsHandles(i),'XLim');
                start = ceil(xLim(1));
                ending = floor(xLim(2));
                xTick = start-1:ending+1;
                xg = xTick;
                yg = [0 1];
                xx = reshape([xg;xg;NaN(1,length(xg))],1,length(xg)*3);
                yy = repmat([yg NaN],1,length(xg));
                plot(xx,yy,'k');
                hold(h1,'on');
                for j = 1:(length(xTick)-1)
                    xg = xTick(j)+log10(linspace(1,10,10));
                    yg = [0.5 1];
                    xx = reshape([xg;xg;NaN(1,length(xg))],1,length(xg)*3);
                    yy = repmat([yg NaN],1,length(xg));
                    plot(h1,xx,yy,'k');
                end
                set(h1,'XLim',xLim,'YLim',[0 1],'XTick',[],'YTick',[],'Color','none','Visible','off','HitTest','off');
                hold(h1,'off');
                xTickLabels = cell(size(xTick));
                xTickLabels(all([xTick<=2;xTick>=-2])) = num2cell(10.^xTick(all([xTick<=2;xTick>=-2])));
                xTickLabels(any([xTick>2;xTick<-2])) = arrayfun(@(x) ['10^',num2str(x)],xTick(any([xTick>2;xTick<-2])),'UniformOutput',false);
                set(subplotsHandles(i),'XTick',xTick,'XtickLabel',xTickLabels);
            end
        end   
        if get(handles.yAxis.trans.log,'Value')
            set(subplotsHandles,'Ytick',[]);
            for i = 1:length(subplotsHandles)
                position = get(subplotsHandles(i),'Position');
                position(1) = position(1)-0.007;
                position(3) = 0.007;
                h1 = axes('Position',position);
                yLim = get(subplotsHandles(i),'YLim');
                start = ceil(yLim(1));
                ending = floor(yLim(2));
                yTick = start-1:ending+1;
                yg = yTick;
                xg = [1 0];
                yy = reshape([yg;yg;NaN(1,length(yg))],1,length(yg)*3);
                xx = repmat([xg NaN],1,length(yg));
                plot(xx,yy,'k');
                hold(h1,'on');
                for j = 1:(length(yTick)-1)
                    yg = yTick(j)+log10(linspace(1,10,10));
                    xg = [1 0.5];
                    yy = reshape([yg;yg;NaN(1,length(yg))],1,length(yg)*3);
                    xx = repmat([xg NaN],1,length(yg));
                    plot(h1,xx,yy,'k');
                end
                set(h1,'XLim',[0 1],'YLim',yLim,'XTick',[],'YTick',[],'Color','none','Visible','off','HitTest','off');
                hold(h1,'off');
                yTickLabels = cell(size(yTick));
                yTickLabels(all([yTick<=2;yTick>=-2])) = num2cell(10.^yTick(all([yTick<=2;yTick>=-2])));
                yTickLabels(any([yTick>2;yTick<-2])) = arrayfun(@(x) ['10^',num2str(x)],yTick(any([yTick>2;yTick<-2])),'UniformOutput',false);
                set(subplotsHandles(i),'YTick',yTick,'YtickLabel',yTickLabels);
            end
        end   
        newAxes = axes('Position',[0 0 1 1],'XLim',[0 1],'YLim',[0 1],'XTick',[],'YTick',[],'Color','none','Visible','off','HitTest','off');
        if get(handles.yAxis.trans.log,'Value')
            text('String',[xAxis, '(Log)'],'Parent',newAxes,'Position',[0.5 0.01],'Color','k','FontWeight','bold');     
        else
            text('String',xAxis,'Parent',newAxes,'Position',[0.5 0.01],'Color','k','FontWeight','bold');     
        end
        if get(handles.yAxis.trans.log,'Value')
            text('String',[yAxis,' (Log)'],'Parent',newAxes,'Position',[0.01 0.5],'Color','k','FontWeight','bold','Rotation',90);     
        else
            text('String',yAxis,'Parent',newAxes,'Position',[0.01 0.5],'Color','k','FontWeight','bold','Rotation',90);     
        end
end

set(newFig,'Visible','on');
end

%------------------------------HELPER FUNCTIONS----------------------------
function ok = helperfcn_load
ok = 1;
filesInFolder = dir([folderName,'/*.mat']);
filesInFolder = struct2cell(filesInFolder);
filesInFolder = filesInFolder(1,:)';

%reset colors if number of files in the new dir ~= number of files loaded before
resetColor = 0;
if length(filesInFolder) ~= size(tableData,1)
    resetColor = 1;
end
if length(filesInFolder) > 16
   answer = questdlg({'It is not advisable to open more than 16 files, as the figure will be crouded and computation time long.';...
                  'Are you sure you want to open all these files?'},...
                  'Warning','Cancel','Yes','Cancel');
   if strcmp(answer,'Cancel')
       ok = 0;
       return;
   end
end
name = regexp(folderName,['.*\',filesep,'(.*)\',filesep],'tokens');
set(handles.figureName,'String',name{1,1}{1,1});
metaFile = cell(length(filesInFolder),1); 
for i = 1:length(filesInFolder)
    try
        varName = who('-file',[folderName,filesInFolder{i}]);
        externalVar = load([folderName,filesInFolder{i}]);
        metaFile{i} = externalVar.(varName{1,1});
        if size(varName,1)>1
            errordlg('All the .mat files in folder should contain only one variable that is a structure with the fields ''data'' and ''colheaders'', see help button (?)','error','replace');
            ok = 0;
            return;
        elseif    ~isstruct(metaFile{i})||~isfield(metaFile{i},'data')||~isfield(metaFile{i},'colheaders')
            errordlg(['The variable contains in one of the .mat files in the folder (''',filesInFolder{i},''') is not a structure with the fields ''data'' and ''colheaders'', see help button (?)'],'error','replace');
            ok = 0;
            return;
        end        
    catch exception
        errordlg(exception.message,'error','replace');
        ok = 0;
        return;
    end 
end
colheaders = metaFile{1}.colheaders;
for i = 2:length(filesInFolder)
    if ~isequal (colheaders,metaFile{i}.colheaders);
        errordlg('Not all of the .mat files in folder contain the same colheaders (parameters), the parameters must match, see help button (?)','Error','replace');
        ok = 0;
        return;
    end
end
if resetColor
    tableData = cell(length(filesInFolder),12);
end
tableData(:,1) = {true};
tableData(:,2) = cellfun(@(x) strtok(x,'.'),filesInFolder,'UniformOutput',false);
tableData(:,3) = tableData(:,2);
set(handles.selectAll,'value',1,'Enable','inactive');    

rows = floor(sqrt(length(filesInFolder)));
cols = ceil(sqrt(length(filesInFolder)));
if rows*cols < length(filesInFolder)
    rows = rows + 1;
end
set(handles.dotplotAddProps.layout.text,'String',['Subplots layout (',num2str(length(filesInFolder)),' subplots):']);
set(handles.dotplotAddProps.layout.rows,'String',num2str(rows),'UserData',rows);
set(handles.dotplotAddProps.layout.cols,'String',num2str(cols),'UserData',cols);

maxNoOfCells = max(cellfun(@(x) length(x.data),metaFile));
if maxNoOfCells > BIGPLOT
    twoDhistParam.isolineNo = DEFAULTBINS_BIG;
    twoDhistParam.xBinNo = DEFAULTBINS_BIG;
    twoDhistParam.yBinNo = DEFAULTBINS_BIG;
elseif maxNoOfCells > MEDIUMPLOT
    twoDhistParam.isolineNo = DEFAULTBINS_MEDUIM;
    twoDhistParam.xBinNo = DEFAULTBINS_MEDUIM;
    twoDhistParam.yBinNo = DEFAULTBINS_MEDUIM;
else
    twoDhistParam.isolineNo = DEFAULTBINS_SMALL;
    twoDhistParam.xBinNo = DEFAULTBINS_SMALL;
    twoDhistParam.yBinNo = DEFAULTBINS_SMALL;
end
end
function helperfcn_updateData(resetLimits)
metaData = NaN(max(cellfun(@(x) length(x.data),metaFile)),2,size(tableData,1));
if get(handles.xAxis.math,'Value')
    for i = 1:size(tableData,1)
        lengthOfThisFile = length(metaFile{i}.data);
        param1 = metaFile{i}.data(:,operationX{1});
        switch operationX{3}
                 case 'numeric'
                     param2 = str2double(operationX{4});
                 case 'column'
                     param2 = metaFile{i}.data(:,operationX{4});
                 case 'statistics'
                     switch operationX{4}
                         case 'Mean'
                             param2 = nanmean(param1);
                         case 'Median'
                             param2 = nanmedian(param1);
                     end
        end
        switch operationX{2}
            case '+'
                metaData(1:lengthOfThisFile,1,i) = param1+param2;
            case '-'
                metaData(1:lengthOfThisFile,1,i) = param1-param2;
            case '*'
                metaData(1:lengthOfThisFile,1,i) = param1.*param2;
            case '/'
                metaData(1:lengthOfThisFile,1,i) = param1./param2;
            case '^'
                metaData(1:lengthOfThisFile,1,i) = param1.^param2;
        end
    end
else %~get(handles.xAxis.math,'Value')
    for i = 1:size(tableData,1)
        lengthOfThisFile = length(metaFile{i}.data);
        metaData(1:lengthOfThisFile,1,i) = metaFile{i}.data(:,get(handles.xAxis.param,'Value'));
    end
end
if get(handles.xAxis.trans.log,'Value')
    metaData(:,1,:) = trans_Log(metaData(:,1,:));
end
if get(handles.plotMode,'Value') == 2
    if get(handles.yAxis.math,'Value')
        for i = 1:size(tableData,1)
            lengthOfThisFile = length(metaFile{i}.data);
            param1 = metaFile{i}.data(:,operationY{1});
            switch operationY{3}
                     case 'numeric'
                         param2 = str2double(operationY{4});
                     case 'column'
                         param2 = metaFile{i}.data(:,operationY{4});
                     case 'statistics'
                         switch operationY{4}
                             case 'Mean'
                                 param2 = nanmean(param1);
                             case 'Median'
                                 param2 = nanmedian(param1);
                         end
            end
            switch operationY{2}
                case '+'
                    metaData(1:lengthOfThisFile,2,i) = param1+param2;
                case '-'
                    metaData(1:lengthOfThisFile,2,i) = param1-param2;
                case '*'
                    metaData(1:lengthOfThisFile,2,i) = param1.*param2;
                case '/'
                    metaData(1:lengthOfThisFile,2,i) = param1./param2;
                case '^'
                    metaData(1:lengthOfThisFile,2,i) = param1.^param2;
            end
        end
    else %~get(handles.yAxis.math,'Value')
        for i = 1:size(tableData,1)
            lengthOfThisFile = length(metaFile{i}.data);
            metaData(1:lengthOfThisFile,2,i) = metaFile{i}.data(:,get(handles.yAxis.param,'Value'));
        end
    end
    if get(handles.yAxis.trans.log,'Value')
        metaData(:,2,:) = trans_Log(metaData(:,2,:));
    end
end

chosenFiles = find(cellfun(@(x) x==1,tableData(:,1)));
notChosenFiles = ~ismember(1:size(tableData,1),chosenFiles);
if get(handles.plotMode,'Value') == 1
    if resetLimits
        if strcmp(resetLimits,'resetBasedOnAll') 
            histLim(1) = min(min(metaData(:,1,:)));
            histLim(2) = max(max(metaData(:,1,:)));
        elseif strcmp(resetLimits,'userDefinedHistLimits')
        	histLim(1) = get(handles.hist.limits.low,'UserData');
            histLim(2) = get(handles.hist.limits.hi,'UserData');
            if get(handles.xAxis.trans.log,'Value')
                histLim = log10(histLim);
            end
        else
            histLim(1) = min(min(metaData(:,1,chosenFiles)));
            histLim(2) = max(max(metaData(:,1,chosenFiles)));
        end
        if get(handles.xAxis.trans.log,'Value')
            set(handles.hist.limits.low,'String',num2str(10.^histLim(1)),'UserData',10.^histLim(1));
            set(handles.hist.limits.hi,'String',num2str(10.^histLim(2)),'UserData',10.^histLim(2));
            set(handles.xAxis.limits.low,'String',num2str(10.^histLim(1)),'UserData',10.^histLim(1));
            set(handles.xAxis.limits.hi,'String',num2str(10.^histLim(2)),'UserData',10.^histLim(2));
        else
            set(handles.hist.limits.low,'String',num2str(histLim(1)),'UserData',histLim(1));
            set(handles.hist.limits.hi,'String',num2str(histLim(2)),'UserData',histLim(2));
            set(handles.xAxis.limits.low,'String',num2str(histLim(1)),'UserData',histLim(1));
            set(handles.xAxis.limits.hi,'String',num2str(histLim(2)),'UserData',histLim(2));
        end
    else
        histLim(1) = get(handles.hist.limits.low,'UserData');
        histLim(2) = get(handles.hist.limits.hi,'UserData');
        if get(handles.xAxis.trans.log,'Value')
        	histLim = log10(histLim);
        end
    end
    nBins = get(handles.hist.binNo,'UserData');
    scale = linspace(histLim(1),histLim(2),nBins);
    yAxis = get(handles.yAxis.param,'value');

    histPlotData = NaN(length(scale),length(chosenFiles));
    for i = 1:length(chosenFiles)
        if ~get(handles.hist.smooth.checkBox,'value')
            [x,~] = hist(metaData(:,1,chosenFiles(i)),scale);
            if yAxis == 2
                x = 100*x./sum(x);
            end
        else
            [x,~] = ksdensity(metaData(:,1,chosenFiles(i)),scale,...
                             'width',get(handles.hist.smooth.width,'UserData')); 
        end
        histPlotData(:,i) = x;
    end
    
    if get(handles.xAxis.trans.log,'Value')
        tableData(:,5) = num2cell(10.^min(metaData(:,1,:)));
        tableData(:,7) = num2cell(10.^max(metaData(:,1,:)));
    else
        tableData(:,5) = num2cell(min(metaData(:,1,:)));
        tableData(:,7) = num2cell(max(metaData(:,1,:)));
    end
   
    tableData(:,9) = {0};
    tableData(chosenFiles,10) = {0};
    tableData(chosenFiles,11) = num2cell(max(histPlotData));    
    tableData(notChosenFiles,[6,8,10,12]) = {''};

    if resetLimits
    	maxVal = max(max(histPlotData));
        set(handles.yAxis.limits.hi,'String',num2str(maxVal),'UserData',maxVal);
    end
    if	get(handles.sameLimits,'Value')
        tableData(chosenFiles,6) = {get(handles.xAxis.limits.low,'UserData')};
        tableData(chosenFiles,8) = {get(handles.xAxis.limits.hi,'UserData')};
        tableData(chosenFiles,12) = {get(handles.yAxis.limits.hi,'UserData')};
    else %~get(handles.sameLimits,'Value')
        if resetLimits
            tableData(chosenFiles,6) = tableData(chosenFiles,5);
            tableData(chosenFiles,8) = tableData(chosenFiles,7);
            tableData(chosenFiles,12) = tableData(chosenFiles,11);
        end
    end  
    
else %get(handles.plotMode,'Value') == 2
    if resetLimits
        if strcmp(resetLimits,'resetBasedOnAll') 
            xLim = [min(min(metaData(:,1,:))),max(max(metaData(:,1,:)))];
            yLim = [min(min(metaData(:,2,:))),max(max(metaData(:,2,:)))];
        else
            xLim = [min(min(metaData(:,1,chosenFiles))),max(max(metaData(:,1,chosenFiles)))];
            yLim = [min(min(metaData(:,2,chosenFiles))),max(max(metaData(:,2,chosenFiles)))];            
        end
        if get(handles.xAxis.trans.log,'Value')
            set(handles.xAxis.limits.low,'String',num2str(10.^xLim(1)),'UserData',10.^xLim(1));
            set(handles.xAxis.limits.hi,'String',num2str(10.^xLim(2)),'UserData',10.^xLim(2));
        else
            set(handles.xAxis.limits.low,'String',num2str(xLim(1)),'UserData',xLim(1));
            set(handles.xAxis.limits.hi,'String',num2str(xLim(2)),'UserData',xLim(2));
        end
        if get(handles.yAxis.trans.log,'Value')
            set(handles.yAxis.limits.low,'String',num2str(10.^yLim(1)),'UserData',10.^yLim(1));
            set(handles.yAxis.limits.hi,'String',num2str(10.^yLim(2)),'UserData',10.^yLim(2));
        else
            set(handles.yAxis.limits.low,'String',num2str(yLim(1)),'UserData',yLim(1));
            set(handles.yAxis.limits.hi,'String',num2str(yLim(2)),'UserData',yLim(2));
        end
    end
    
    if get(handles.xAxis.trans.log,'Value')
        tableData(:,5) = num2cell(10.^min(metaData(:,1,:)));
        tableData(:,7) = num2cell(10.^max(metaData(:,1,:)));      
    else
        tableData(:,5) = num2cell(min(metaData(:,1,:)));
        tableData(:,7) = num2cell(max(metaData(:,1,:)));
    end
    if get(handles.yAxis.trans.log,'Value')
        tableData(:,9) = num2cell(10.^min(metaData(:,2,:)));
        tableData(:,11) = num2cell(10.^max(metaData(:,2,:)));  
    else        
        tableData(:,9) = num2cell(min(metaData(:,2,:)));
        tableData(:,11) = num2cell(max(metaData(:,2,:)));
    end
    tableData(notChosenFiles,[6,8,10,12]) = {''};
    if get(handles.sameLimits,'Value')
        tableData(chosenFiles,6) = {get(handles.xAxis.limits.low,'UserData')};
        tableData(chosenFiles,8) = {get(handles.xAxis.limits.hi,'UserData')};
        tableData(chosenFiles,10) = {get(handles.yAxis.limits.low,'UserData')};
        tableData(chosenFiles,12) = {get(handles.yAxis.limits.hi,'UserData')};
    else
        if resetLimits
            tableData(chosenFiles,6) = tableData(chosenFiles,5);
        	tableData(chosenFiles,8) = tableData(chosenFiles,7);
            tableData(chosenFiles,10) = tableData(chosenFiles,9);
            tableData(chosenFiles,12) = tableData(chosenFiles,11);
        end
    end
end

if ~isempty(autoColor)
    colorAdd = (length(chosenFiles):-1:1).*(0.8/length(chosenFiles));
    for i = 1:length(chosenFiles)
        specColor = autoColor;
        specColor(specColor<1) = colorAdd(i);
        tableData(chosenFiles(i),4) = {color2htmlStr(specColor)};
    end
    tableData(notChosenFiles,4) = {color2htmlStr([1 1 1])};
end
set(handles.table,'Data',tableData);
end
function helperfcn_upDownEnableDisable
chosenGates = find(cellfun(@(x) x==1,tableData(:,1)));
if length(chosenGates)==1
    if size(tableData,1)==1
        set([handles.moveDown,handles.moveUp],'Enable','off');
    elseif size(tableData,1) > 1 && chosenGates == 1
        set(handles.moveDown,'Enable','on');
        set(handles.moveUp,'Enable','off');            
    elseif size(tableData,1) > 1 && chosenGates == size(tableData,1)
        set(handles.moveDown,'Enable','off');
        set(handles.moveUp,'Enable','on');
    else
        set([handles.moveDown,handles.moveUp],'Enable','on');            
    end
else
	set([handles.moveDown,handles.moveUp],'Enable','off');    
end
end
end