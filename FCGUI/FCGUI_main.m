function FCGUI_main(varargin)
%Shared variables between functions
fcData.colheadars = cell(1,1);
fcData.data = 0;
fcData.dataLog = 0;
plotData = [];
filteredCells = 0;
gates.name = {'All data'};
gates.tag = 0;
gates.data = {''};
gates.type = {''};
gates.axes = {''};
gates.trans = {''};
gates.coordinates = {''};
gates.color = {[0 0 0]};
gates.parents = {[]};
gates.unparentedData = {[]};
tableData = [];
twoDhistParam.n = 0;
twoDhistParam.xi = 0;
twoDhistParam.yi = 0;
twoDhistParam.z = 0;
twoDhistParam.c = 0;
interactiveShape = [];
interactiveShapePos = [];
editGate = 0;

DEFAULT_GATECOLORS = zeros(10,3);
DEFAULT_GATECOLORS(1,:) = [0.2784	0.0706	0.5804  ];
DEFAULT_GATECOLORS(2,:) = [0.1686	0.5059	0.3373  ];
DEFAULT_GATECOLORS(3,:) = [0.8471	0.1608	0       ];
DEFAULT_GATECOLORS(4,:) = [0         0.4     0.8     ];
DEFAULT_GATECOLORS(5,:) = [1         0.6941	0.3922  ];
DEFAULT_GATECOLORS(6,:) = [0.749     0       0.749   ];
DEFAULT_GATECOLORS(7,:) = [0.5569    0.2784	0       ];
DEFAULT_GATECOLORS(8,:) = [0.2       1       0       ];
DEFAULT_GATECOLORS(9,:) = [0         0.8     0.8     ];
DEFAULT_GATECOLORS(10,:) = [0.6       0.6     0       ];
DEFAULT_GATECOLOR_QUAD1 = [0.8549 0.7020 1.0000];
DEFAULT_GATECOLOR_QUAD2 = [0.7020 0.7804 1.0000];
DEFAULT_GATECOLOR_QUAD3 = [0.7569 0.8667 0.7765];
DEFAULT_GATECOLOR_QUAD4 =  [1.0000 0.8510 0.7059];
BIGPLOT = 70000;
MEDIUMPLOT = 10000;
DEFAULT_BINS_BIG = 100;
DEFAULT_BINS_MEDIUM = 50;
DEFAULT_BINS_SMALL = 10;
DEFAULT_HISTNOOFBINS = 1024; 
DEFAULT_HISTSMOOOTHWIDTH = 0.05;

%The following parameters will be saved in the application data of the
%figure (if defined by user):
% 'fileName' - FC data file name
% 'folderName' - FC data file folder name
% 'params' - the parameters of the FC data file
% 'calParams' - the parameters that are result of calculation
% 'filters' - the filters defined by user

handles = FCGUI_build;
callbackAssign; %Assigning callbacks to uicontrol objects
guiInitial; %Gui initialization functioî

function callbackAssign
set(handles.toolbar.open,           'ClickedCallback',  @toolbar_open_callback);
set(handles.menu.open,              'Callback',         @toolbar_open_callback);
set(handles.toolbar.openNewWin,     'ClickedCallback',  @toolbar_openNewWin_callback);
set(handles.menu.openNewWin,        'Callback',         @toolbar_openNewWin_callback);
set(handles.toolbar.duplicateWin,   'ClickedCallback',  @toolbar_duplicateWin_callback);
set(handles.menu.duplicateWin,      'Callback',         @toolbar_duplicateWin_callback);
set([handles.toolbar.openLastNewWin,handles.toolbar.openLast,...
     handles.toolbar.openNext,      handles.toolbar.openNextNewWin],...
                                    'ClickedCallback',  @toolbar_autoLoad_callback);
set([handles.menu.openLastNewWin,   handles.menu.openLast,...
     handles.menu.openNext,         handles.menu.openNextNewWin],...
                                    'Callback',         @toolbar_autoLoad_callback);
set(handles.toolbar.newWin,         'ClickedCallback',  @toolbar_newWin_callback);
set(handles.menu.newWin,            'Callback',         @toolbar_newWin_callback);
set(handles.toolbar.closeWin,       'ClickedCallback',  @toolbar_closeWin_callback);
set(handles.menu.closeWin,          'Callback',         @toolbar_closeWin_callback);
set(handles.toolbar.filter,         'ClickedCallback',  @toolbar_filter_callback);
set(handles.menu.filter,            'Callback',         @toolbar_filter_callback);
set(handles.toolbar.calAxis,        'ClickedCallback',  @toolbar_calAxis_callback);
set(handles.menu.calAxis,           'Callback',         @toolbar_calAxis_callback);
set(handles.toolbar.resetView,      'ClickedCallback',  @toolbar_resetView_callback);
set(handles.menu.resetView,         'Callback',         @toolbar_resetView_callback);
set(handles.toolbar.twoDhist,       'ClickedCallback',  @toolbar_twoDhist_callback);
set(handles.menu.twoDhist,          'Callback',         @toolbar_twoDhist_callback);
set([handles.toolbar.zoomIn,handles.toolbar.pan],...
                                    'Oncallback',       @toolbar_zoomInPan_ONcallback,...
                                    'Offcallback',      @toolbar_zoomInPan_OFFcallback,...
                                    'ClickedCallback',  @toolbar_zoomInPan_clickedcallback);
set([handles.menu.zoomIn,handles.menu.pan],...
                                    'Callback',         @toolbar_zoomInPan_clickedcallback);
set(handles.toolbar.zoomOut,        'ClickedCallback',  @toolbar_zoomOut_callback);
set(handles.menu.zoomOut,           'Callback',         @toolbar_zoomOut_callback);
set([handles.toolbar.rectGate,  handles.toolbar.freeShapeGate,...
     handles.toolbar.polyGate,  handles.toolbar.autoGate,...
     handles.toolbar.quadrantGate,handles.toolbar.histGate],...
                                    'ClickedCallback',  @interactiveGate_callback);
set([handles.menu.rectGate,     handles.menu.freeShapeGate,...
     handles.menu.polyGate,     handles.menu.autoGate,...
     handles.menu.quadrantGate, handles.menu.histGate],...
                                    'Callback',         @interactiveGate_callback);
set(handles.toolbar.semiAutoGate,   'ClickedCallback',  @toolbar_semiAutoGate_callback);
set(handles.menu.semiAutoGate,      'Callback',         @toolbar_semiAutoGate_callback);
set(handles.toolbar.dotPlotMultiPlot,'ClickedCallback', @toolbar_dotPlotMultiPlot_callback);
set(handles.menu.dotPlotMultiPlot,  'Callback',         @toolbar_dotPlotMultiPlot_callback);
set(handles.toolbar.histMultiPlot,  'ClickedCallback',  @toolbar_histMultiPlot_callback);
set(handles.menu.histMultiPlot,     'Callback',         @toolbar_histMultiPlot_callback);
set(handles.toolbar.help,           'ClickedCallback',  @toolbar_help_callback);
set(handles.menu.help,              'Callback',         @toolbar_help_callback);
set([handles.tableTools.selectAll,handles.tableTools.selectNone],...
                                    'Callback',         @tableSelectAllNone_callback);
set([handles.tableTools.moveDown],...
                                    'Callback',         @tableTools_moveGate_callback);
set([handles.tableTools.moveUp],...
                                    'Callback',         @tableTools_moveGate_callback);
set([handles.tableTools.clearGate,handles.menu.clearGate],...
                                    'Callback',         @tableTools_clearGate_callback);
set([handles.tableTools.dupliGate,handles.menu.dupliGate],...
                                    'Callback',         @tableTools_dupliGate_callback);
set([handles.tableTools.editGate,handles.menu.editGate],...
                                    'Callback',         @tableTools_editGate_callback);                                
set([handles.tableTools.loadGate,handles.menu.loadGate],...
                                    'Callback',         @tableTools_loadGate_callback);
set([handles.tableTools.saveGate,handles.menu.saveGate,...
     handles.tableTools.saveGateReads,handles.menu.saveGateReads],...
                                    'Callback',         @tableTools_saveGate2File_callback);
set([handles.tableTools.inverseGate,    handles.menu.inverseGate,...
     handles.tableTools.unionGate,      handles.menu.unionGate,...
     handles.tableTools.intersectGate,  handles.menu.intersectGate,...
     handles.tableTools.XORGate,        handles.menu.XORGate],...
                                    'Callback',         @tableTools_logicalGate_callback);
set([handles.xAxis.param,handles.yAxis.param],...
                                    'Callback',         @axisParamChange_callback);
set([handles.xAxis.trans.log,           handles.yAxis.trans.log,...
     handles.xAxis.trans.none,          handles.yAxis.trans.none],...
                                    'Callback',         @axisTransChange_callback);
set([handles.xAxis.lim.low,             handles.xAxis.lim.hi,...
     handles.yAxis.lim.low,             handles.yAxis.lim.hi,...
     handles.hist.yAxis.lim.low,        handles.hist.yAxis.lim.hi,...
     handles.hist.xAxis.lim.low,        handles.hist.xAxis.lim.hi],...
                                    'Callback',         @axisLimChange_callback);
set(handles.switchAxes,             'Callback',         @switchAxes_callback);
set(handles.hist.yAxis.param,       'Callback',         @histYAxisChange_callback);
set(handles.hist.smooth,            'Callback',         @histSmooth_callback);
set(handles.hist.smoothWidth,       'Callback',         @histSmoothWidth_callback);
set(handles.hist.noOfBins,          'Callback',         @histNoOfBins_callback);

set(handles.upPanel.manualGate.calculate,'Callback',    @manualGate_cal_callback);
set(handles.upPanel.quadrantGate.calculate,'Callback',  @quadrantGate_cal_callback);
set(handles.upPanel.histGate.calculate,'Callback',      @histGate_cal_callback);
set(handles.upPanel.autoGate.centerX,'Callback',        @autoGate_center_callback);
set(handles.upPanel.autoGate.centerY,'Callback',        @autoGate_center_callback);
set(handles.upPanel.autoGate.expansMode.radial,  'Callback',@autoGate_expansMode_callback);
set(handles.upPanel.autoGate.expansMode.isolines,'Callback',@autoGate_expansMode_callback);
set([handles.upPanel.histGate.bound.histMin,handles.upPanel.histGate.bound.low,...
     handles.upPanel.histGate.bound.hi,handles.upPanel.histGate.bound.histMax,...
     handles.upPanel.histGate.autoBound],...
                                    'Callback',         @histGate_boundChange_callback);
set([handles.upPanel.manualGate.color,  handles.upPanel.autoGate.color,...
     handles.upPanel.histGate.color,handles.upPanel.quadrantGate.quadrant1color,...
     handles.upPanel.quadrantGate.quadrant2color,handles.upPanel.quadrantGate.quadrant3color,...
     handles.upPanel.quadrantGate.quadrant4color],...
                                    'Callback',         @chooseColor_callback);
set([handles.upPanel.manualGate.name,   handles.upPanel.autoGate.noOfCells,...
    handles.upPanel.autoGate.name,      handles.upPanel.histGate.name,...
    handles.upPanel.quadrantGate.name],...
                                    'Callback',         @chooseName_callback,...
                                    'ButtonDownFcn',    @chooseName_buttonDownCallback);
set([handles.upPanel.manualGate.save,   handles.upPanel.autoGate.save,...
    handles.upPanel.histGate.save,handles.upPanel.quadrantGate.save],...
                                    'Callback',         @saveGate_callback);
set([handles.upPanel.manualGate.cancel, handles.upPanel.autoGate.cancel,...
    handles.upPanel.histGate.cancel,handles.upPanel.quadrantGate.cancel],...
                                    'Callback',         @cancelGate_callback);
set([handles.axes.plotMode,handles.menu.plotMode],...
                                    'Callback',         @plotModeChange_callback);
set(handles.table,                  'CellEditCallback', @tableCellEdit_callback,...
                                    'CellSelectionCallback', @tableChangeColor_callback);
set(handles.toolbar.exportFig,      'ClickedCallback',  @toolbar_exportFig_callback);
set(handles.menu.exportFig,         'Callback',         @toolbar_exportFig_callback);
set([handles.toolbar.histMultiPlot,handles.toolbar.dotPlotMultiPlot],...
                                    'ClickedCallback',  @toolbar_subplotsFigureTools_callback);
set([handles.menu.histMultiPlot,handles.menu.dotPlotMultiPlot],...
                                    'Callback',         @toolbar_subplotsFigureTools_callback);
end
function guiInitial
%There are 3 ways of opening new GUI figure:
%1. The first run (or by pressing 'new window') - do nothing present rorschach image
%2. Pressing open in a new window - preserve the old settings.
%3. Pressing open next/lest in a new window or duplicate - auto load the next/last/same
%   file and preserve the old settings.

if isempty(varargin) %case 1 (see above)
    %rorschach = load('private\rorschach.mat');
    %image(rorschach.rorschach,'Parent',handles.axes.axes);
    set(handles.axes.axes,'XTick',[],'YTick',[]);
    set(handles.figure,'Name','FC Data Analysis Tool');
else
	previousHandles = varargin{1,1};
    if length(varargin) == 1 %case 2 (see above)
        ok = helperfcn_load('','',previousHandles);
    else %case 3 (see above)
        ok = helperfcn_load(varargin{1,2},varargin{1,3},previousHandles);
    end
    if ok ~=1 %in case it didn't work
        %rorschach = load('private\rorschach.mat');
        %image(rorschach.rorschach,'Parent',handles.axes.axes);
        set(handles.axes.axes,'XTick',[],'YTick',[]);
        set(handles.figure,'name','FC Data Analysis Tool');
        figure(handles.figure);
    end
end
set(handles.figure,'Visible','on');
clear('rorschach','icons');
end
%------------------------------------CALLBACKS----------------------------------
function toolbar_closeWin_callback(hObject,eventdata)%#ok
delete(handles.figure);
end
function toolbar_open_callback(hObject,eventdata)%#ok
helperfcn_load;
end
function toolbar_openNewWin_callback(hObject,eventdata)%#ok
FCGUI_main(handles);
end
function toolbar_autoLoad_callback(hObject,eventdata)%#ok
folderName = getappdata(handles.figure,'folderName');
fileName = getappdata(handles.figure,'fileName');
filesInFolder = dir([folderName,'/*.mat']);
filesInFolder = struct2cell(filesInFolder);
filesInFolder = filesInFolder(1,:)';
currentFile = find(strcmp(fileName,filesInFolder));
switch hObject
    case {handles.toolbar.openNextNewWin,handles.toolbar.openNext}
        nextFile = currentFile+1;
        if nextFile>size(filesInFolder,1)
        	nextFile = rem(nextFile,size(filesInFolder,1));
        end    
    case {handles.toolbar.openLastNewWin,handles.toolbar.openLast}
        nextFile = currentFile-1;
        if nextFile == 0
            nextFile = size(filesInFolder,1);
        end    
end
fileName = filesInFolder{nextFile};
switch hObject
    case {handles.toolbar.openNextNewWin,handles.toolbar.openLastNewWin}
        figHandles=findall(0,'type','figure');
        for i = 1:length(figHandles)
            if strcmp(getappdata(figHandles(i),'fileName'),fileName) &&...
               strcmp(getappdata(figHandles(i),'folderName'),folderName)     
                figure(figHandles(i));
                return;
            end
        end
        FCGUI_main(handles,folderName,fileName);
    case {handles.toolbar.openNext,handles.toolbar.openLast}
        helperfcn_load(folderName,fileName);
end
end
function toolbar_duplicateWin_callback(hObject,eventdata)%#ok
folderName = getappdata(handles.figure,'folderName');
fileName = getappdata(handles.figure,'fileName');
FCGUI_main(handles,folderName,fileName);
end
function toolbar_newWin_callback(hObject,eventdata)%#ok
FCGUI_main;
end
function toolbar_calAxis_callback(hObject,eventdata)%#ok
output = mathParam_dlg(getappdata(handles.figure,'params'));
if iscell(output)
	helperfcn_calParams(output{1,1},output{1,2});
end
end
function toolbar_filter_callback(hObject,eventdata)%#ok
if ~isappdata(handles.figure,'filters')
    set(handles.toolbar.filter,'State','off');
    set(handles.menu.filter,'Selected','off');
    output = createFilter_dlg(fcData);
else
    set(handles.toolbar.filter,'state','on');
    set(handles.menu.filter,'Selected','on');
	output = createFilter_dlg(fcData,getappdata(handles.figure,'filters'));
end
if iscell(output)
    switch output{1,1}
        case 'gate'
            if ~isempty(find(output{1,3},1))
                filter = output{1,2};
                nameStr = '';
                if isfield(filter,'time')
                    nameStr = [nameStr,'First ',num2str(filter.time),'cells; '];
                end
                if isfield(filter,'axis')
                    for i = 1:size(filter.axis,1)
                        nameStr = [nameStr,filter.axis{i,1},': ',...
                                   num2str(filter.axis{i,2}),'% Low, ',...
                                   num2str(filter.axis{i,3}),'% High;']; %#ok<AGROW>
                    end
                end
                gates.name(end+1) = {nameStr};
                gates.tag(end+1) = size(gates.tag,2);
                gates.data(end+1) = output(1,3);
                gates.type(end+1) = {'filter'};
                gates.axes(end+1) = {''};
                gates.trans(end+1) = {''};
                gates.coordinates(end+1) = {''};
                gates.color(end+1) = {[0.9 0.9 0.9]};
                gates.parents(end+1) = {[]};
                gates.unparentedData(end+1) = {[]};

                lengthOfGate = length(find(gates.data{end}));
                precentage = lengthOfGate/size(fcData.data,1)*100;
                tableData(end+1,:) = ...
                    [{true(1,1)},gates.name(end),color2htmlStr(gates.color{end}),...
                     {num2str(lengthOfGate)},{num2str(precentage,3)},{''},...
                     gates.parents(end),gates.type(end),gates.axes(end),...
                     gates.trans(end),gates.coordinates(end)];
                set(handles.table,'data',tableData);
                if ~isappdata(handles.figure,'filters')
                    set(handles.toolbar.filter,'State','off');
                    set(handles.menu.filter,'Selected','off');
                end
                helperfcn_tableToolsEnableDisable;
            else
                errordlg('Empty filter, gate will be not saved!','Error','replace');
                return;
            end
        case 'filter'
            if ~isappdata(handles.figure,'filters')
                fcData.nonFilteredData = fcData.data;
            else
                fcData.data = fcData.nonFilteredData;
            end
            if ~isempty(find(output{1,3},1))
                filteredCells = output{1,3};
                setappdata(handles.figure,'filters',output{1,2});
                fcData.data(filteredCells,:) = NaN;
                fcData.dataLog(filteredCells,:) = NaN;
                set(handles.toolbar.filter,'State','on');
                set(handles.menu.filter,'Selected','on');
                
                if size(gates.tag,2)>1
                    for i = 2:size(gates.tag,2)
                        data = gates.data{i};
                        data(filteredCells) = false;
                        gates.data{i} = data;
                    end
                    for i = 2:size(gates.tag,2)
                        lengthOfGate = length(find(gates.data{i}));
                        precentage = lengthOfGate/(size(fcData.data,1)-length(find(filteredCells)))*100;
                        
                        if ~isempty(gates.parents{i})
                            parentsLengths = length(find(any(cell2mat(gates.data(gates.parents{i})),2)));
                            precentOfParent = lengthOfGate/parentsLengths*100;
                        else
                            precentOfParent = [];
                        end
                        tableData(i,[4,5,6]) = ...
                            [{num2str(lengthOfGate)},{num2str(precentage,3)},{num2str(precentOfParent,3)}];
                    end
                end
            else
                fcData = rmfield(fcData,'nonFilteredData');
                fcData.dataLog = trans_Log(fcData.data);
                if find(strcmpi(fcData.colheaders,'Time'))
                    fcData.dataLog(1,strcmpi(fcData.colheaders,'Time'))=0;
                end
                rmappdata(handles.figure,'filters');
                set(handles.toolbar.filter,'State','off');
                set(handles.menu.filter,'Selected','off');
                tableData(1,4) = {num2str(size(fcData.data,1))};
                set(handles.table,'data',tableData);
            end
            if isappdata(handles.figure,'filters')
                tableData(1,4) = {[num2str((size(fcData.data,1)-length(find(filteredCells)))),...
                                   ' (',num2str(length(find(filteredCells))),...
                                   ' filtered)']};
            else
                tableData(1,4) = {num2str(size(fcData.data,1))};
            end
            set(handles.table,'data',tableData);
        case 'cancelAll'
            fcData.data = fcData.nonFilteredData;
            fcData = rmfield(fcData,'nonFilteredData');
            fcData.dataLog = trans_Log(fcData.data);
            if find(strcmpi(fcData.colheaders,'Time'))
                fcData.dataLog(1,strcmpi(fcData.colheaders,'Time'))=0;
            end
            rmappdata(handles.figure,'filters');
            set(handles.toolbar.filter,'State','off');
            set(handles.menu.filter,'Selected','off');
            tableData(1,4) = {num2str(size(fcData.data,1))};
            set(handles.table,'data',tableData);
    end
    helperfcn_plot('ResetLimits','UpdatePlotData');
end
end
function toolbar_zoomInPan_ONcallback(hObject,eventdata)%#ok
switch hObject
    case handles.toolbar.zoomIn
        h = zoom;
    case handles.toolbar.pan
        h = pan;
end
set(h,'ActionPostCallback',@limUpdate,'Enable','on');
if get(handles.axes.plotMode,'Value') == 2
    set(h,'Motion','horizontal');
else
    set(h,'Motion','both');
end
function limUpdate(obj,evd)%#ok
xLim = get(evd.Axes,'XLim');
if get(handles.xAxis.trans.log,'Value')
    set(handles.xAxis.lim.low,'string',num2str(10.^xLim(1)),'UserData',10.^xLim(1));
    set(handles.xAxis.lim.hi,'string',num2str(10.^xLim(2)),'UserData',10.^xLim(2));
else
    set(handles.xAxis.lim.low,'string',num2str(xLim(1)),'UserData',xLim(1));
    set(handles.xAxis.lim.hi,'string',num2str(xLim(2)),'UserData',xLim(2));
end
if get(handles.axes.plotMode,'Value') == 1
    yLim = get(evd.Axes,'YLim');
    if get(handles.yAxis.trans.log,'Value')
        set(handles.yAxis.lim.low,'string',num2str(10.^yLim(1)),'UserData',10.^yLim(1));
        set(handles.yAxis.lim.hi,'string',num2str(10.^yLim(2)),'UserData',10.^yLim(2));
    else
        set(handles.yAxis.lim.low,'string',num2str(yLim(1)),'UserData',yLim(1));
        set(handles.yAxis.lim.hi,'string',num2str(yLim(2)),'UserData',yLim(2));
    end
end
helperfcn_plot(~'resetLimits',~'UpdatePlotData','Zoomming');
end    
end
function toolbar_zoomInPan_OFFcallback(hObject,eventdata)%#ok
switch hObject
    case handles.toolbar.zoomIn
        zoom off;
    case handles.toolbar.pan
        pan off;    
end
end
function toolbar_zoomInPan_clickedcallback(hObject,eventdata)%#ok
switch hObject
    case {handles.toolbar.zoomIn,handles.menu.zoomIn}
    	set(handles.toolbar.pan,'state','off');        
    case {handles.toolbar.pan,handles.menu.pan}
    	set(handles.toolbar.zoomIn,'state','off'); 
end
end
function toolbar_zoomOut_callback(hObject,eventdata)%#ok
set(handles.toolbar.zoomIn,'State','off');
set(handles.toolbar.pan,'State','off');
maxX = max(plotData(:,1));
minX = min(plotData(:,1));
maxY = max(plotData(:,2));
minY = min(plotData(:,2));
maxMinPoints = [maxX,maxY;minX,maxY;maxX,minY;minX,minY];
set(handles.axes.axes,'XLimMode','auto','YLimMode','auto');
plot(handles.axes.axes,maxMinPoints(:,1),maxMinPoints(:,2),'.k','MarkerSize',1);
set(handles.axes.axes,'TickDir','out');
xLim = get(handles.axes.axes,'XLim');
yLim = get(handles.axes.axes,'YLim');
set(handles.axes.axes,'XLimMode','manual','YLimMode','manual');
if get(handles.xAxis.trans.log,'Value')
    set(handles.xAxis.lim.low,'string',num2str(10.^xLim(1)),'UserData',10.^xLim(1));
    set(handles.xAxis.lim.hi,'string',num2str(10.^xLim(2)),'UserData',10.^xLim(2));
    set(handles.hist.xAxis.lim.low,'string',num2str(10.^minX),'UserData',10.^minX);
    set(handles.hist.xAxis.lim.hi,'string',num2str(10.^maxX),'UserData',10.^maxX); 
else
    set(handles.xAxis.lim.low,'string',num2str(xLim(1)),'UserData',xLim(1));
    set(handles.xAxis.lim.hi,'string',num2str(xLim(2)),'UserData',xLim(2));
    set(handles.hist.xAxis.lim.low,'string',num2str(minX),'UserData',minX);
    set(handles.hist.xAxis.lim.hi,'string',num2str(maxX),'UserData',maxX); 
end
if get(handles.yAxis.trans.log,'Value')
    set(handles.yAxis.lim.low,'string',num2str(10.^yLim(1)),'UserData',10.^yLim(1));
    set(handles.yAxis.lim.hi,'string',num2str(10.^yLim(2)),'UserData',10.^yLim(2));
else
    set(handles.yAxis.lim.low,'string',num2str(yLim(1)),'UserData',yLim(1));
    set(handles.yAxis.lim.hi,'string',num2str(yLim(2)),'UserData',yLim(2));
end
helperfcn_plot(~'resetLimits',~'updataPlotData');
end
function toolbar_resetView_callback(hObject,eventdata)%#ok
set(handles.toolbar.zoomIn,'state','off');
set(handles.toolbar.pan,'state','off');

set(handles.tableTools.selectAll,'value',0,'enable','on');
tableData(:,1) = num2cell(false(size(tableData,1),1));
tableData(1,1) = num2cell(true(1,1));
set(handles.table,'data',tableData);

set(handles.xAxis.param,'value',1);
set(handles.xAxis.trans.log,'value',1,'Enable','inactive');
set(handles.xAxis.trans.none,'value',0,'Enable','on');

if get(handles.axes.plotMode,'Value') == 1
    set(handles.toolbar.twoDhist,'state','off');
    set(handles.menu.twoDhist,'checked','off');
    set(handles.yAxis.param,'value',2);
    set(handles.yAxis.trans.log,'value',1,'Enable','inactive');
    set(handles.yAxis.trans.none,'value',0,'Enable','on');
else
    set(handles.hist.noOfBins,'string','1024');
    set(handles.hist.smooth,'Value',0);
    set(handles.hist.smoothWidthText,'enable','off');
    set(handles.hist.smoothWidthText2,'enable','off');
    set(handles.hist.smoothWidth,'String','0.05','enable','off');
    set(handles.hist.yAxis.param,'string',char('Counts','Percentage'),'enable','on');
end
helperfcn_plot('resetLimits','updatePlotData');
end
function toolbar_twoDhist_callback(hObject,eventdata)%#ok
switch hObject
    case handles.toolbar.twoDhist
        switch get(hObject,'State')    
            case 'on'
                set(handles.menu.twoDhist,'Checked','on');    
            case 'off'
                set(handles.menu.twoDhist,'Checked','off');        
        end
    case handles.menu.twoDhist
        switch get(hObject,'Checked')    
            case 'on'
                set(handles.toolbar.twoDhist,'State','off');                
                set(handles.menu.twoDhist,'Checked','off');    
            case 'off'
                set(handles.toolbar.twoDhist,'State','on');
                set(handles.menu.twoDhist,'Checked','on'); 
        end
end
helperfcn_plot(~'resetLimits',~'updatePlotData');    
end

function switchAxes_callback(hObject,eventdata)%#ok
xAxis = get(handles.xAxis.param,'value');
xLimHi = get(handles.xAxis.lim.hi,'UserData');
xLimLow = get(handles.xAxis.lim.low,'UserData');
xTransLogValue = get(handles.xAxis.trans.log,'Value');
xTransNoneValue = get(handles.xAxis.trans.none,'Value');
yAxis = get(handles.yAxis.param,'value');
yLimHi = get(handles.yAxis.lim.hi,'UserData');
yLimLow = get(handles.yAxis.lim.low,'UserData');
yTransLogValue = get(handles.yAxis.trans.log,'Value');
yTransNoneValue = get(handles.yAxis.trans.none,'Value');
set(handles.xAxis.param,'value',yAxis);
set(handles.xAxis.lim.hi,'string',num2str(yLimHi),'UserData',yLimHi);
set(handles.xAxis.lim.low,'string',num2str(yLimLow),'UserData',yLimLow);
set(handles.xAxis.trans.log,'Value',yTransLogValue);
set(handles.xAxis.trans.none,'Value',yTransNoneValue);
set(handles.yAxis.param,'value',xAxis);
set(handles.yAxis.lim.hi,'string',num2str(xLimHi),'UserData',xLimHi);
set(handles.yAxis.lim.low,'string',num2str(xLimLow),'UserData',xLimLow);
set(handles.yAxis.trans.log,'Value',xTransLogValue);
set(handles.yAxis.trans.none,'Value',xTransNoneValue);
helperfcn_plot(~'resetLimits','updatePlotData');
end
function axisParamChange_callback(hObject,eventdata)%#ok
helperfcn_plot('resetLimits','updatePlotData');
end
function axisTransChange_callback(hObject,eventdata)%#ok
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
helperfcn_plot('resetLimits','updatePlotData');
end
function axisLimChange_callback(hObject,eventdata)%#ok
newLim = str2double(get(hObject,'string'));
if isnan(newLim) || ...
   (hObject == handles.xAxis.lim.hi)      && (newLim <= str2double(get(handles.xAxis.lim.low,'String'))) || ...
   (hObject == handles.xAxis.lim.low)     && (newLim >= str2double(get(handles.xAxis.lim.hi,'String')))  || ...
   (hObject == handles.yAxis.lim.hi)      && (newLim <= str2double(get(handles.yAxis.lim.low,'String'))) || ...
   (hObject == handles.yAxis.lim.low)     && (newLim >= str2double(get(handles.yAxis.lim.hi,'String')))  || ...
   (hObject == handles.hist.xAxis.lim.hi) && (newLim <= str2double(get(handles.hist.xAxis.lim.low,'String'))) || ...
   (hObject == handles.hist.xAxis.lim.low)&& (newLim >= str2double(get(handles.hist.xAxis.lim.hi,'String'))) || ...
   (hObject == handles.hist.yAxis.lim.hi) && (newLim <= str2double(get(handles.hist.yAxis.lim.low,'String'))) || ...   
   (hObject == handles.hist.yAxis.lim.low)&& (newLim >= str2double(get(handles.hist.yAxis.lim.hi,'String'))) || ...
   (get(handles.xAxis.trans.log,'Value') && ismember(hObject,[handles.xAxis.lim.hi,handles.xAxis.lim.low,handles.hist.xAxis.lim.hi,handles.hist.xAxis.lim.low]) && newLim < 0) || ...
   (get(handles.yAxis.trans.log,'Value') && ismember(hObject,[handles.yAxis.lim.hi,handles.yAxis.lim.low]) && newLim < 0)

    set(hObject,'String',num2str(get(hObject,'UserData')));
elseif    (hObject == handles.hist.yAxis.lim.hi) && (newLim > str2double(get(handles.hist.yAxis.lim.low,'String'))) || ...   
          (hObject == handles.hist.yAxis.lim.low)&& (newLim < str2double(get(handles.hist.yAxis.lim.hi,'String')))
    set(hObject,'UserData',str2double(get(hObject,'String')));
    set(handles.axes.axes,'YLim',[str2double(get(handles.hist.yAxis.lim.low,'String')),...
                                  str2double(get(handles.hist.yAxis.lim.hi,'String'))]);
else
    set(hObject,'UserData',str2double(get(hObject,'String')));
    helperfcn_plot(~'resetLimits',~'updatePlotData');
end
end
function histYAxisChange_callback(hObject,eventdata)%#ok
helperfcn_plot(~'ResetLimits',~'updatePlotData');
end
function histNoOfBins_callback(hObject,eventdata)%#ok
newVal = round(str2double(get(hObject,'String')));
if isnan(newVal) || newVal < 2
    set(hObject,'String',get(hObject,'UserData'));
else
    set(hObject,'String',num2str(newVal),'UserData',newVal);
    helperfcn_plot(~'resetLimits',~'updatePlotData');    
end
end
function histSmooth_callback(hObject,eventdata)%#ok
switch get(hObject,'Value')
    case 1
        set(handles.hist.smoothWidthText,'enable','on');
        set(handles.hist.smoothWidthText2,'enable','on');
        set(handles.hist.smoothWidth,'enable','on');
        set(handles.hist.yAxis.param,'string',{'Density function'},'enable','off','Value',1);
    case 0
        set(handles.hist.smoothWidthText,'enable','off');
        set(handles.hist.smoothWidthText2,'enable','off');
        set(handles.hist.smoothWidth,'enable','off');
        set(handles.hist.yAxis.param,'string',{'Counts','Percentage'},'enable','on');
end
helperfcn_plot(~'resetLimits',~'updatePlotData');
end
function histSmoothWidth_callback(hObject,eventdata)%#ok
if isnan(str2double(get(hObject,'String')))||str2double(get(hObject,'String'))<=0
    set(hObject,'String',get(hObject,'UserData'));
else
    set(hObject,'UserData',get(hObject,'String'));
    helperfcn_plot(~'resetLimits',~'updatePlotData');    
end
end
function plotModeChange_callback(hObject,eventdata)%#ok
if hObject == handles.menu.plotMode
    oldValue = get(handles.axes.plotMode,'Value');
    if oldValue == 1
        set(handles.axes.plotMode,'Value',2);
    else
        set(handles.axes.plotMode,'Value',1);
    end
end
switch get(handles.axes.plotMode,'Value')
    case 1
        set(handles.yAxisORhistPanel,'Selection',1);
        set(handles.rightColumn,'Heights',[0 -1],'MinimumHeights',[0 200]);
        set(handles.upPanel.panel,'Visible','off');
        set(handles.switchAxes,'Visible','on');
        set([handles.toolbar.twoDhist,handles.menu.twoDhist,...
             handles.toolbar.rectGate,handles.toolbar.freeShapeGate,...
             handles.toolbar.polyGate,handles.toolbar.quadrantGate,handles.toolbar.autoGate,...
             handles.toolbar.semiAutoGate,handles.menu.rectGate,handles.menu.freeShapeGate,...
             handles.menu.polyGate,handles.menu.quadrantGate,handles.menu.autoGate,...
             handles.menu.semiAutoGate,handles.toolbar.dotPlotMultiPlot,...
             handles.menu.dotPlotMultiPlot],'Enable','on'); 
        set([handles.toolbar.histGate,handles.menu.histGate,handles.toolbar.histMultiPlot,...
            handles.menu.histMultiPlot],'Enable','off'); 
    case 2
        set(handles.yAxisORhistPanel,'Selection',2);
        set(handles.rightColumn,'Heights',[60 -1],'MinimumHeights',[40 200]);
        set(handles.upPanel.panel,'Visible','on','Selection',5);
        set(handles.switchAxes,'Visible','off');
        set([handles.toolbar.histGate,handles.menu.histGate,handles.toolbar.histMultiPlot,...
            handles.menu.histMultiPlot],'Enable','on'); 
        set([handles.toolbar.twoDhist,handles.menu.twoDhist,...
             handles.toolbar.rectGate,handles.toolbar.freeShapeGate,...
             handles.toolbar.polyGate,handles.toolbar.quadrantGate,handles.toolbar.autoGate,...
             handles.toolbar.semiAutoGate,handles.menu.rectGate,handles.menu.freeShapeGate,...
             handles.menu.polyGate,handles.menu.quadrantGate,handles.menu.autoGate,...
             handles.menu.semiAutoGate,handles.toolbar.dotPlotMultiPlot,...
             handles.menu.dotPlotMultiPlot],'Enable','off');
        switch get(handles.hist.smooth,'Value')
            case 1
                set([handles.hist.smoothWidthText,handles.hist.smoothWidthText2,handles.hist.smoothWidth],...
                    'enable','on');
                set(handles.hist.smoothWidth,'string',get(handles.hist.smoothWidth,'string'));
                set(handles.hist.yAxis.param,'string',char('Density function'),'enable','off');
            case 0
                set([handles.hist.smoothWidthText,handles.hist.smoothWidthText2,handles.hist.smoothWidth],...
                    'enable','off');
                set(handles.hist.yAxis.param,'string',char('Counts','Percentage'),'enable','on');
        end
end
if ~strcmp(hObject,'loadFcnCall')
    helperfcn_plot(~'resetLimits','updatePlotData');
end
end

function interactiveGate_callback(hObject,eventdata)%#ok
%There are six type of interactive gate creations:
%1. Polygonal gate
%2. Free shape gate
%3. Rectangular gate
%4. Auto gate
%5. Quadrant gate
%6. Histogram based gate 
set([handles.toolbar.zoomIn,handles.toolbar.pan],'state','off');
%set(handles.leftColumn,'Enable','off');
set([handles.axes.plotMode,handles.toolbar.toolbar],'Visible','off');
set([handles.menu.file,handles.menu.display,handles.menu.gates,...
     handles.menu.histMultiPlot,handles.menu.dotPlotMultiPlot,...
     handles.menu.calAxis,handles.menu.filter],'Enable','off');
 
originalXLim = get(handles.axes.axes,'XLim');
originalYLim = get(handles.axes.axes,'YLim');
originalXlabel = get(get(handles.axes.axes,'XLabel'),'String');
originalYlabel = get(get(handles.axes.axes,'YLabel'),'String');
x0 = originalXLim(1);
xLength = originalXLim(2)-originalXLim(1);
y0 = originalYLim(1);
yLength = originalYLim(2)-originalYLim(1);

switch hObject
    case  {handles.toolbar.polyGate,handles.menu.polyGate,...
           handles.toolbar.freeShapeGate,handles.menu.freeShapeGate,...
           handles.toolbar.rectGate,handles.menu.rectGate}
       
        set(handles.rightColumn,'Heights',[55 -1],'MinimumHeights',[55 200]);
        set(handles.upPanel.panel,'Visible','on','Selection',1);
        set(handles.upPanel.warnning,'String','Double-click inside the shape in order to finish gating');
        set(handles.upPanel.manualGate.color,'BackgroundColor',DEFAULT_GATECOLORS(rem(max(floor(gates.tag)),10)+1,:));
        set(handles.upPanel.manualGate.name,'String','Choose name','foregroundColor',[0.5 0.5 0.5],'FontAngle','italic','Enable','inactive');

    case {handles.toolbar.autoGate,handles.menu.autoGate}
        set(handles.rightColumn,'Heights',[55 -1],'MinimumHeights',[55 200]);
        set(handles.upPanel.panel,'Visible','on','Selection',3);
        set(handles.upPanel.autoGate.color,'BackgroundColor',DEFAULT_GATECOLORS(rem(max(floor(gates.tag)),10)+1,:))
        set(handles.upPanel.autoGate.name,'String','Choose name','foregroundColor',[0.5 0.5 0.5],'FontAngle','italic','Enable','inactive');
        set(handles.upPanel.autoGate.noOfCells,'String','Specify number of cells','foregroundColor',[0.5 0.5 0.5],'FontAngle','italic','Enable','inactive');
        set(handles.upPanel.autoGate.expansMode.radial,'Value',1,'Enable','inactive');
        set(handles.upPanel.autoGate.expansMode.isolines,'Value',0,'Enable','on');    
        set(handles.toolbar.twoDhist,'State','on');
        set(handles.menu.twoDhist,'Checked','on');
        helperfcn_plot(~'resetLimits',~'updatePlotData');
        [maxValInEachColumn,maxValIndexRow] = max(twoDhistParam.z);
        [~,maxValIndexCol] = max(maxValInEachColumn);
        maxValIndexRow = maxValIndexRow(maxValIndexCol);
        center = [twoDhistParam.xi(maxValIndexCol),twoDhistParam.yi(maxValIndexRow)];
        if get(handles.xAxis.trans.log,'Value')
        	set(handles.upPanel.autoGate.centerX,'string',num2str(10.^center(1)));
        else
            set(handles.upPanel.autoGate.centerX,'string',num2str(center(1)));
        end
        if get(handles.yAxis.trans.log,'Value')
            set(handles.upPanel.autoGate.centerY,'string',num2str(10.^center(2)));   
        else
            set(handles.upPanel.autoGate.centerY,'string',num2str(center(2)));  
        end
        set(handles.upPanel.autoGate.xAxisText,'string',[originalXlabel,' : ']);
        set(handles.upPanel.autoGate.yAxisText,'string',[originalYlabel,' : ']);
        
    case {handles.toolbar.quadrantGate,handles.menu.quadrantGate}
        chosenGates = find(cellfun(@(x) x==1,tableData(:,1)));
        if ~ismember(1,chosenGates)
            tableData(1,1) = {true};
            set(handles.table,'Data',tableData);
            helperfcn_plot(~'resetLimits','updatePlotData');
        end
        set(handles.rightColumn,'Heights',[55 -1],'MinimumHeights',[55 200]);
        set(handles.upPanel.panel,'Visible','on','Selection',1);
        set(handles.upPanel.warnning,'String','Double-click on the point in order to finish gating');
        set([handles.upPanel.quadrantGate.quadrant1color,handles.upPanel.quadrantGate.quadrant1],'BackgroundColor',DEFAULT_GATECOLOR_QUAD1);
        set([handles.upPanel.quadrantGate.quadrant2color,handles.upPanel.quadrantGate.quadrant2],'BackgroundColor',DEFAULT_GATECOLOR_QUAD2);
        set([handles.upPanel.quadrantGate.quadrant3color,handles.upPanel.quadrantGate.quadrant3],'BackgroundColor',DEFAULT_GATECOLOR_QUAD3);
        set([handles.upPanel.quadrantGate.quadrant4color,handles.upPanel.quadrantGate.quadrant4],'BackgroundColor',DEFAULT_GATECOLOR_QUAD4);
        set(handles.upPanel.quadrantGate.name,'String','Choose name','foregroundColor',[0.5 0.5 0.5],'FontAngle','italic','Enable','inactive');

    case {handles.toolbar.histGate,handles.menu.histGate}
        set(handles.rightColumn,'Heights',[40 -1],'MinimumHeights',[40 200]);
        set(handles.upPanel.panel,'Visible','on','Selection',6);
        set(handles.upPanel.histGate.color,'BackgroundColor',DEFAULT_GATECOLORS(rem(max(floor(gates.tag)),10)+1,:))
        set(handles.upPanel.histGate.name,'String','Choose name','foregroundColor',[0.5 0.5 0.5],'FontAngle','italic','Enable','inactive');

        bound1 = x0+xLength/2-0.1*xLength;
        bound2 = x0+xLength/2+0.1*xLength;
    case 'edit'
        switch(gates.type{editGate})
            case 'manual'
            	set(handles.rightColumn,'Heights',[40 -1],'MinimumHeights',[40 200]);
                set(handles.upPanel.panel,'Visible','on','Selection',2);
                set(handles.upPanel.manualGate.color,'BackgroundColor',gates.color{editGate});
                set(handles.upPanel.manualGate.name,'String',gates.name{editGate},'foregroundColor',[0 0 0],'FontAngle','normal','Enable','on');
                startPosition = gates.coordinates{editGate};
                if get(handles.xAxis.trans.log,'value')
                    startPosition(:,1) = log10(startPosition(:,1));
                end
                if get(handles.xAxis.trans.log,'value')
                	startPosition(:,2) = log10(startPosition(:,2));
                end
                hObject = 'editManual';
            case 'quadrant'
                quadrantsInds = find(floor(gates.tag) == floor(gates.tag(editGate)));
                set(handles.rightColumn,'Heights',[40 -1],'MinimumHeights',[40 200]);
                set(handles.upPanel.panel,'Visible','on','Selection',4);
                set([handles.upPanel.quadrantGate.quadrant1color,handles.upPanel.quadrantGate.quadrant1],'BackgroundColor',gates.color{quadrantsInds(1)});
                set([handles.upPanel.quadrantGate.quadrant2color,handles.upPanel.quadrantGate.quadrant2],'BackgroundColor',gates.color{quadrantsInds(2)});
                set([handles.upPanel.quadrantGate.quadrant3color,handles.upPanel.quadrantGate.quadrant3],'BackgroundColor',gates.color{quadrantsInds(3)});
                set([handles.upPanel.quadrantGate.quadrant4color,handles.upPanel.quadrantGate.quadrant4],'BackgroundColor',gates.color{quadrantsInds(4)});
                quadrantName = regexp(gates.name{quadrantsInds(1)},'(.*)_qI','tokens');
                quadrantName = quadrantName{1,1}{1,1};
                set(handles.upPanel.quadrantGate.name,'String',quadrantName,'foregroundColor',[0 0 0],'FontAngle','normal','Enable','on');
                startPosition = gates.coordinates{editGate};
                if get(handles.xAxis.trans.log,'value')
                    startPosition(:,1) = log10(startPosition(:,1));
                end
                if get(handles.xAxis.trans.log,'value')
                    startPosition(:,2) = log10(startPosition(:,2));
                end
                hObject = 'editQuadrant';
            case 'hist'
            	set(handles.rightColumn,'Heights',[40 -1],'MinimumHeights',[40 200]);
                set(handles.upPanel.panel,'Visible','on','Selection',6);
                set(handles.upPanel.histGate.color,'BackgroundColor',gates.color{editGate})
                set(handles.upPanel.histGate.name,'String',gates.name{editGate},'foregroundColor',[0 0 0],'FontAngle','normal','Enable','on');
                bound1 = gates.coordinates{editGate}(1);
                bound2 = gates.coordinates{editGate}(2);
                if get(handles.xAxis.trans.log,'value')
                    bound1 = log10(bound1);
                    bound2 = log10(bound2);
                end
                hObject = 'editHist';
                
        end
        if ismember(floor(gates.tag(editGate)),floor(cell2mat(gates.parents)))
            editWarnHandle = warndlg('Gate''s children will be updated only if they are of type manual, quadrant, hist and logical (not auto and semiauto), and only children of the first level (i.e. grandchildren will not be updated)','Warnning','replace');
        end
end

xTick = get(handles.axes.axes,'XTick');
xTick = (xTick-x0)./xLength;
yTick = get(handles.axes.axes,'YTick');
yTick = (yTick-y0)./yLength;
xTicklabel = get(handles.axes.axes,'XTickLabel');
yTicklabel = get(handles.axes.axes,'YTickLabel');

frame = getframe(handles.axes.axes);
frame.cdata(:,:,1) = frame.cdata(end:-1:1,:,1);
frame.cdata(:,:,2) = frame.cdata(end:-1:1,:,2);
frame.cdata(:,:,3) = frame.cdata(end:-1:1,:,3);

background = image(frame.cdata);
set(handles.axes.axes,'TickDir','out','YDir','normal','XLimMode','manual','YLimMode','manual');

xLim = get(handles.axes.axes,'XLim');
yLim = get(handles.axes.axes,'YLim');
xx0 = xLim(1);
xxLength = xLim(2)-xLim(1);
yy0 = yLim(1);
yyLength = yLim(2)-yLim(1);
xTick = xx0+xTick.*xxLength;
yTick = yy0+yTick.*yyLength;
set(handles.axes.axes,'XTick',xTick,'YTick',yTick,'XTickLabel',xTicklabel,'YTickLabel',yTicklabel);
xlabel(handles.axes.axes,originalXlabel);
ylabel(handles.axes.axes,originalYlabel);

switch hObject
    case {handles.toolbar.polyGate,handles.menu.polyGate,'editManual'}
        fcn = makeConstrainToRectFcn('impoly',xLim,yLim);
        if ~strcmp(hObject,'editManual')
            interactiveShape = impoly(handles.axes.axes,'PositionConstraintFcn',fcn);
            position = wait(interactiveShape); 
            set(handles.rightColumn,'Heights',[40 -1],'MinimumHeights',[40 200]);
            set(handles.upPanel.panel,'Visible','on','Selection',2);
        else
            startPosition(:,1) = xx0+((startPosition(:,1)-x0)./xLength).*xxLength;
            startPosition(:,2) = yy0+((startPosition(:,2)-y0)./yLength).*yyLength;
            interactiveShape = impoly(handles.axes.axes,startPosition,'PositionConstraintFcn',fcn);            
            position = startPosition;
            if exist('editWarnHandle','var'), figure(editWarnHandle); end
        end
        interactiveShapePos(:,1) = x0+((position(:,1)-xx0)./xxLength).*xLength;
        interactiveShapePos(:,2) = y0+((position(:,2)-yy0)./yyLength).*yLength;
        addNewPositionCallback(interactiveShape,@newPosPolyFreeHand);
        
    case {handles.toolbar.freeShapeGate,handles.menu.freeShapeGate}
        fcn = makeConstrainToRectFcn('imfreehand',xLim,yLim);
        interactiveShape = imfreehand(handles.axes.axes,'PositionConstraintFcn',fcn);
        position = wait(interactiveShape);
        
        set(handles.rightColumn,'Heights',[40 -1],'MinimumHeights',[40 200]);
        set(handles.upPanel.panel,'Visible','on','Selection',2);
        interactiveShapePos(:,1) = x0+((position(:,1)-xx0)./xxLength).*xLength;
        interactiveShapePos(:,2) = y0+((position(:,2)-yy0)./yyLength).*yLength;
        addNewPositionCallback(interactiveShape,@newPosPolyFreeHand);
        
    case {handles.toolbar.rectGate,handles.menu.rectGate}
        fcn = makeConstrainToRectFcn('imrect',xLim,yLim);
        interactiveShape = imrect(handles.axes.axes,'PositionConstraintFcn',fcn); 
        position = wait(interactiveShape);
        
        set(handles.rightColumn,'Heights',[40 -1],'MinimumHeights',[40 200]);
        set(handles.upPanel.panel,'Visible','on','Selection',2);
        pos = zeros(4,2);
        pos(1,1) = x0+((position(1)-xx0)./xxLength).*xLength;
        pos(1,2) = y0+((position(2)-yy0)./yyLength).*yLength;
        pos(2,1) = x0+((position(1)+position(3)-xx0)./xxLength).*xLength;
        pos(2,2) = pos(1,2);
        pos(3,1) = x0+((position(1)+position(3)-xx0)./xxLength).*xLength;
        pos(3,2) = y0+((position(2)+position(4)-yy0)./yyLength).*yLength;
        pos(4,1) = pos(1,1);
        pos(4,2) = y0+((position(2)+position(4)-yy0)./yyLength).*yLength;
        interactiveShapePos = pos;
        addNewPositionCallback(interactiveShape,@newPosRect);
        
    case {handles.toolbar.autoGate,handles.menu.autoGate}
        centerInPlot(1) = xx0+((center(1)-x0)./xLength).*xxLength;
        centerInPlot(2) = yy0+((center(2)-y0)./yLength).*yyLength;
        fcn = makeConstrainToRectFcn('impoint',xLim,yLim);
        interactiveShape = impoint(handles.axes.axes,centerInPlot,'PositionConstraintFcn',fcn);
        setColor(interactiveShape,[0 1 0]);
        position = getPosition(interactiveShape);
        interactiveShapePos(:,1) = x0+((position(:,1)-xx0)./xxLength).*xLength;
        interactiveShapePos(:,2) = y0+((position(:,2)-yy0)./yyLength).*yLength;
        addNewPositionCallback(interactiveShape,@newPosAutoGate);
        
    case {handles.toolbar.quadrantGate,handles.menu.quadrantGate,'editQuadrant'}
        fcn = makeConstrainToRectFcn('impoint',xLim,yLim);
        if ~strcmp(hObject,'editQuadrant')
            interactiveShape.center = impoint(handles.axes.axes,'PositionConstraintFcn',fcn);
            position1 = wait(interactiveShape.center);
            set(handles.rightColumn,'Heights',[40 -1],'MinimumHeights',[40 200]);
            set(handles.upPanel.panel,'Visible','on','Selection',4);
            position = zeros(5,2);
            position(1,:) = position1;
            position(2,:) = [position1(1),yLim(2)];
            position(3,:) = [xLim(1),position1(2)];
            position(4,:) = [position1(1),yLim(1)];
            position(5,:) = [xLim(2),position1(2)];
        else
            startPosition(:,1) = xx0+((startPosition(:,1)-x0)./xLength).*xxLength;
            startPosition(:,2) = yy0+((startPosition(:,2)-y0)./yLength).*yyLength;
            lineY = (@(x1,x2,y1,y2,X) ((y1-y2)/(x1-x2))*X + y1-x1*((y1-y2)/(x1-x2)));
            lineX = (@(x1,x2,y1,y2,Y) Y/((y1-y2)/(x1-x2))-y1/((y1-y2)/(x1-x2))+x1);
            xvalLine1 = lineX(startPosition(1,1),startPosition(2,1),...
                startPosition(1,2),startPosition(2,2),...
                yLim(2));
            yvalLine2 = lineY(startPosition(1,1),startPosition(3,1),...
                startPosition(1,2),startPosition(3,2),...
                xLim(1));
            xvalLine3 = lineX(startPosition(1,1),startPosition(4,1),...
                startPosition(1,2),startPosition(4,2),...
                yLim(1));
            yvalLine4 = lineY(startPosition(1,1),startPosition(5,1),...
                startPosition(1,2),startPosition(5,2),...
                xLim(2));
            position = zeros(5,2);
            position(1,:) = startPosition(1,:);
            position(2,:) = [xvalLine1,yLim(2)];
            position(3,:) = [xLim(1),yvalLine2];
            position(4,:) = [xvalLine3,yLim(1)];
            position(5,:) = [xLim(2),yvalLine4];
            interactiveShape.center = impoint(handles.axes.axes,position(1,:),'PositionConstraintFcn',fcn);
            if exist('editWarnHandle','var'), figure(editWarnHandle); end
        end
        pos(:,1) = x0+((position(:,1)-xx0)./xxLength).*xLength;
        pos(:,2) = y0+((position(:,2)-yy0)./yyLength).*yLength;
        interactiveShapePos = pos;
        
        fcn = makeConstrainToRectFcn('impoint',xLim,[yLim(2) yLim(2)]);
        interactiveShape.one = impoint(handles.axes.axes,position(2,:),'PositionConstraintFcn',fcn);
        fcn = makeConstrainToRectFcn('impoint',[xLim(1),xLim(1)],yLim);
        interactiveShape.two = impoint(handles.axes.axes,position(3,:),'PositionConstraintFcn',fcn);
        fcn = makeConstrainToRectFcn('impoint',xLim,[yLim(1),yLim(1)]);
        interactiveShape.three = impoint(handles.axes.axes,position(4,:),'PositionConstraintFcn',fcn);
        fcn = makeConstrainToRectFcn('impoint',[xLim(2),xLim(2)],yLim);
        interactiveShape.four = impoint(handles.axes.axes,position(5,:),'PositionConstraintFcn',fcn);
        setColor(interactiveShape.center,[0.4784 0.0627 0.8941]);
        setColor(interactiveShape.one,[0.0431 0.5176 0.7804]);
        setColor(interactiveShape.two,[0.0431 0.5176 0.7804]);
        setColor(interactiveShape.three,[0.0431 0.5176 0.7804]);
        setColor(interactiveShape.four,[0.0431 0.5176 0.7804]);
               
        linePlot.one = line('Parent',handles.axes.axes,'XData',position([1,2],1),'YData',position([1,2],2),'Color',[0.8 0.8 0.8],'LineWidth',3);
        linePlot.two = line('Parent',handles.axes.axes,'XData',position([1,3],1),'YData',position([1,3],2),'Color',[0.8 0.8 0.8],'LineWidth',3);
        linePlot.three = line('Parent',handles.axes.axes,'XData',position([1,4],1),'YData',position([1,4],2),'Color',[0.8 0.8 0.8],'LineWidth',3);
        linePlot.four = line('Parent',handles.axes.axes,'XData',position([1,5],1),'YData',position([1,5],2),'Color',[0.8 0.8 0.8],'LineWidth',3);
        
        allChildren = get(handles.axes.axes,'Children');
        set(handles.axes.axes,'Children',allChildren([5:9,1:4,10:end]));
        
        addNewPositionCallback(interactiveShape.center,@(pos) newPosQuadrantGate(pos,'center'));
        addNewPositionCallback(interactiveShape.one,@(pos) newPosQuadrantGate(pos,'1'));
        addNewPositionCallback(interactiveShape.two,@(pos) newPosQuadrantGate(pos,'2'));
        addNewPositionCallback(interactiveShape.three,@(pos) newPosQuadrantGate(pos,'3'));
        addNewPositionCallback(interactiveShape.four,@(pos) newPosQuadrantGate(pos,'4'));
        
    case {handles.toolbar.histGate,handles.menu.histGate,'editHist'}
        if exist('editWarnHandle','var'), figure(editWarnHandle); end
        
        bound1OnPlot = xx0+((bound1-x0)./xLength).*xxLength;
        bound2OnPlot = xx0+((bound2-x0)./xLength).*xxLength;
        ycenter = (yLim(1)+yLim(2))/2;
        %Makes two grey rectangles out of the image to better visualize the limits
        imageCdata = get(background,'CData');
        brightImageCdata = (repmat(uint8(220),size(imageCdata)) * 0.6) + (imageCdata * (1.0 - 0.6));
        set(background,'CData',[brightImageCdata(:,1:round(bound1OnPlot),:),...
                                imageCdata(:,round(bound1OnPlot)+1:round(bound2OnPlot)-1,:),...
                                brightImageCdata(:,round(bound2OnPlot):end,:)]);
                            
        interactiveShape.low = imline(handles.axes.axes,[bound1OnPlot,yLim(1);bound1OnPlot,yLim(2)],...
                                        'PositionConstraintFcn',@(pos) posConstrainHistGate(pos,'low'));
        interactiveShape.hi =  imline(handles.axes.axes,[bound2OnPlot,yLim(1);bound2OnPlot,yLim(2)],...
                                        'PositionConstraintFcn',@(pos) posConstrainHistGate(pos,'hi'));
        interactiveShape.line =  imline(handles.axes.axes,[bound1OnPlot,ycenter;bound2OnPlot,ycenter],...
                                        'PositionConstraintFcn',@(pos) posConstrainHistGate(pos,'line'));
                                    
        setColor(interactiveShape.low,[0 1 0]);
        setColor(interactiveShape.hi,[0 1 0]);
        setColor(interactiveShape.line,[0 1 0]);
        
        set(handles.axes.axes,'XLim',xLim,'YLim',yLim);
        
        position = getPosition(interactiveShape.low);
        pos(1) = position(1,1);
        position = getPosition(interactiveShape.hi);
        pos(2) = position(1,1);
        interactiveShapePos = x0+((pos-xx0)./xxLength).*xLength;
        if get(handles.xAxis.trans.log,'Value')
            set(handles.upPanel.histGate.bound.low,'String',num2str(10.^interactiveShapePos(1)),'UserData',10.^interactiveShapePos(1));
            set(handles.upPanel.histGate.bound.hi,'String',num2str(10.^interactiveShapePos(2)),'UserData',10.^interactiveShapePos(2));   
        else
            set(handles.upPanel.histGate.bound.low,'String',num2str(interactiveShapePos(1)),'UserData',interactiveShapePos(1));
            set(handles.upPanel.histGate.bound.hi,'String',num2str(interactiveShapePos(2)),'UserData',interactiveShapePos(2));    
        end
        addNewPositionCallback(interactiveShape.low,@(pos) newPosHistGate(pos,'low'));
        addNewPositionCallback(interactiveShape.hi,@(pos) newPosHistGate(pos,'hi'));
        addNewPositionCallback(interactiveShape.line,@(pos) newPosHistGate(pos,'line'));
end

function newPosPolyFreeHand(pos)
    set(handles.upPanel.manualGate.noOfCells,'Visible','off');
    pos(:,1) = x0+((pos(:,1)-xx0)./xxLength).*xLength;
    pos(:,2) = y0+((pos(:,2)-yy0)./yyLength).*yLength;
    interactiveShapePos = pos;        
end
function newPosRect(position)
    set(handles.upPanel.manualGate.noOfCells,'Visible','off');
    pos = zeros(4,2);
    pos(1,1) = x0+((position(1)-xx0)./xxLength).*xLength;
    pos(1,2) = y0+((position(2)-yy0)./yyLength).*yLength;
    pos(2,1) = x0+((position(1)+position(3)-xx0)./xxLength).*xLength;
    pos(2,2) = pos(1,2);
    pos(3,1) = x0+((position(1)+position(3)-xx0)./xxLength).*xLength;
    pos(3,2) = y0+((position(2)+position(4)-yy0)./yyLength).*yLength;
    pos(4,1) = pos(1,1);
    pos(4,2) = y0+((position(2)+position(4)-yy0)./yyLength).*yLength;
    interactiveShapePos = pos;
end
function newPosAutoGate(pos)
    pos(:,1) = x0+((pos(:,1)-xx0)./xxLength).*xLength;
    pos(:,2) = y0+((pos(:,2)-yy0)./yyLength).*yLength;
    interactiveShapePos = pos;
    if get(handles.xAxis.trans.log,'Value')
        set(handles.upPanel.autoGate.centerX,'string',num2str(10.^pos(:,1)));
    else
        set(handles.upPanel.autoGate.centerX,'string',num2str(pos(:,1)));
    end
    if get(handles.yAxis.trans.log,'Value')
        set(handles.upPanel.autoGate.centerY,'string',num2str(10.^pos(:,2)));   
    else
        set(handles.upPanel.autoGate.centerY,'string',num2str(pos(:,2)));  
    end
end
function newPosQuadrantGate(position,caller)
	set(handles.upPanel.quadrantGate.noOfCellsPanel,'Visible','off');
    oldCenter = getPosition(interactiveShape.center);
    switch caller
        case 'center'
           	set(linePlot.one,'XData',[position(1,1) position(1,1)],'YData',[position(1,2) yLim(2)]);
            set(linePlot.two,'XData',[position(1,1) xLim(1)],'YData',[position(1,2) position(1,2)]);
            set(linePlot.three,'XData',[position(1,1) position(1,1)],'YData',[position(1,2) yLim(1)]);
            set(linePlot.four,'XData',[position(1,1) xLim(2)],'YData',[position(1,2) position(1,2)]);
            setPosition(interactiveShape.one,[position(1,1),yLim(2)]);
            setPosition(interactiveShape.two,[xLim(1),position(1,2)]);
            setPosition(interactiveShape.three,[position(1,1),yLim(1)]);
            setPosition(interactiveShape.four,[xLim(2),position(1,2)]);
            pos = [x0+((position(1,1)-xx0)./xxLength).*xLength,...
                   y0+((position(1,2)-yy0)./yyLength).*yLength;...
                   x0+((position(1,1)-xx0)./xxLength).*xLength,...
                   y0+((yLim(2)-yy0)./yyLength).*yLength;...
                   x0+((xLim(1)-xx0)./xxLength).*xLength,...
                   y0+((position(1,2)-yy0)./yyLength).*yLength;...
                   x0+((position(1,1)-xx0)./xxLength).*xLength,...
                   y0+((yLim(1)-yy0)./yyLength).*yLength;...
                   x0+((xLim(2)-xx0)./xxLength).*xLength,...
                   y0+((position(1,2)-yy0)./yyLength).*yLength;];
        case '1'
            set(linePlot.one,'XData',[oldCenter(1,1) position(1,1)],'YData',[oldCenter(1,2) yLim(2)]);
            pos(2,1) = x0+((position(1,1)-xx0)./xxLength).*xLength;
            pos(2,2) = y0+((yLim(2)-yy0)./yyLength).*yLength;
        case '2'
            set(linePlot.two,'XData',[oldCenter(1,1) xLim(1)],'YData',[oldCenter(1,2) position(1,2)]);
            pos(3,1) = x0+((xLim(1)-xx0)./xxLength).*xLength;
            pos(3,2) = y0+((position(1,2)-yy0)./yyLength).*yLength;
        case '3'
            set(linePlot.three,'XData',[oldCenter(1,1) position(1,1)],'YData',[oldCenter(1,2) yLim(1)]);
            pos(4,1) = x0+((position(1,1)-xx0)./xxLength).*xLength;
            pos(4,2) = y0+((yLim(1)-yy0)./yyLength).*yLength;
        case '4'
            set(linePlot.four,'XData',[oldCenter(1,1) xLim(2)],'YData',[oldCenter(1,2) position(1,2)]);
            pos(5,1) = x0+((xLim(2)-xx0)./xxLength).*xLength;
            pos(5,2) = y0+((position(1,2)-yy0)./yyLength).*yLength;
    end
    interactiveShapePos = pos;
end
function newPosHistGate(position,caller)
    set(handles.upPanel.histGate.noOfCells,'Visible','off');
    switch caller
        case 'low'
            otherPos = getPosition(interactiveShape.hi);
            pos = [position(1,1),otherPos(1,1)];
            setPosition(interactiveShape.line,[pos(1) ycenter;pos(2) ycenter]);
        case 'hi'
            otherPos = getPosition(interactiveShape.low);
            pos = [otherPos(1,1),position(1,1)];
            setPosition(interactiveShape.line,[pos(1) ycenter;pos(2) ycenter]);
        case 'line'
            pos = [position(1,1),position(2,1)];
            setPosition(interactiveShape.low,[position(1,1) yLim(1);position(1,1) yLim(2)]);
            setPosition(interactiveShape.hi,[position(2,1) yLim(1);position(2,1) yLim(2)]);
    end 
    set(background,'CData',[brightImageCdata(:,1:round(pos(1)),:),...
                            imageCdata(:,round(pos(1))+1:round(pos(2))-1,:),...
                            brightImageCdata(:,round(pos(2)):end,:)]);

    interactiveShapePos = x0+((pos-xx0)./xxLength).*xLength;
    if get(handles.xAxis.trans.log,'Value')
        set(handles.upPanel.histGate.bound.low,'String',num2str(10.^interactiveShapePos(1)),'UserData',10.^interactiveShapePos(1));
        set(handles.upPanel.histGate.bound.hi,'String',num2str(10.^interactiveShapePos(2)),'UserData',10.^interactiveShapePos(2));   
    else
        set(handles.upPanel.histGate.bound.low,'String',num2str(interactiveShapePos(1)),'UserData',interactiveShapePos(1));
        set(handles.upPanel.histGate.bound.hi,'String',num2str(interactiveShapePos(2)),'UserData',interactiveShapePos(2));    
    end
    set(handles.upPanel.histGate.bound.histMin,'Value',0,'Enable','on');
    set(handles.upPanel.histGate.bound.histMax,'Value',0,'Enable','on');
end
function constrainedPos = posConstrainHistGate(position,caller)
    switch caller
        case 'low'
            hiLimit = getPosition(interactiveShape.hi);
            if position(1,1) > hiLimit(1,1)-((xLim(2)-xLim(1))*0.01);
                constrainedPos = [hiLimit(1,1)-((xLim(2)-xLim(1))*0.01),yLim(1);...
                                  hiLimit(1,1)-((xLim(2)-xLim(1))*0.01),yLim(2)];
            elseif position(1,1) < xLim(1) 
                constrainedPos = [xLim(1),yLim(1);...
                                  xLim(1),yLim(2)];
            else
                constrainedPos = [position(1,1),yLim(1);...
                                  position(1,1),yLim(2)];                
            end
        case 'hi'
            lowLimit = getPosition(interactiveShape.low);
            if position(1,1) < lowLimit(1,1)+((xLim(2)-xLim(1))*0.01);
                constrainedPos = [lowLimit(1,1)+((xLim(2)-xLim(1))*0.01),yLim(1);...
                                  lowLimit(1,1)+((xLim(2)-xLim(1))*0.01),yLim(2)];
            elseif position(1,1) > xLim(2) 
                constrainedPos = [xLim(2),yLim(1);...
                                  xLim(2),yLim(2)];
            else
                constrainedPos = [position(1,1),yLim(1);...
                                  position(1,1),yLim(2)]; 
            end
        case 'line'
            constrainedPos = [position(1,1),ycenter;...
                              position(2,1),ycenter];
            if position(2,1) == pos(2) 
                if position(1,1) > position(2,1)-((xLim(2)-xLim(1))*0.01)
                    constrainedPos = [position(2,1)-((xLim(2)-xLim(1))*0.01),ycenter;...
                                      position(2,1),ycenter];
                elseif position(1,1) < xLim(1)
                    constrainedPos = [xLim(1),ycenter;...
                                      position(2,1),ycenter];
                end
            elseif position(1,1) == pos(1) 
               if position(2,1) < position(1,1)+((xLim(2)-xLim(1))*0.01)
                    constrainedPos = [position(1,1),ycenter;...
                                      position(1,1)+((xLim(2)-xLim(1))*0.01),ycenter];
               elseif position(2,1) > xLim(2)
                    constrainedPos = [position(1,1),ycenter;...
                                      xLim(2),ycenter];
               end
            else
                width = pos(2)-pos(1);
                if position(1,1) < xLim(1)
                    constrainedPos = [xLim(1),ycenter;...
                                      xLim(1)+width,ycenter];
                elseif position(2,1) > xLim(2)
                    constrainedPos = [xLim(2)-width,ycenter;...
                                      xLim(2),ycenter];
                end
            end
    end
end
end
function manualGate_cal_callback(hObject,eventdata)%#ok
dotsInPoly = inpoly(plotData,interactiveShapePos);
set(handles.upPanel.manualGate.noOfCells,'Visible','on','string',...
    [num2str(length(find(dotsInPoly))),' / ',num2str(size(plotData,1)),'   ',...
     num2str(length(find(dotsInPoly))/size(plotData,1)*100,3),'%']);
end
function quadrantGate_cal_callback(hObject,eventdata)%#ok
xAxis = get(handles.xAxis.param,'value');
yAxis = get(handles.yAxis.param,'value');
if get(handles.xAxis.trans.log,'Value')
    maxXval = max(fcData.dataLog(:,xAxis));
    minXval = min(fcData.dataLog(:,xAxis));
else
    maxXval = max(fcData.data(:,xAxis));
    minXval = min(fcData.data(:,xAxis));
end
if get(handles.yAxis.trans.log,'Value')
    maxYval = max(fcData.dataLog(:,yAxis));
    minYval = min(fcData.dataLog(:,yAxis));
else
    maxYval = max(fcData.data(:,yAxis));
    minYval = min(fcData.data(:,yAxis));
end
lineY = (@(x1,x2,y1,y2,X) ((y1-y2)/(x1-x2))*X + y1-x1*((y1-y2)/(x1-x2)));
lineX = (@(x1,x2,y1,y2,Y) Y/((y1-y2)/(x1-x2))-y1/((y1-y2)/(x1-x2))+x1);
xvalLine1 = lineX(interactiveShapePos(1,1),interactiveShapePos(2,1),...
                  interactiveShapePos(1,2),interactiveShapePos(2,2),...
                  maxYval);
yvalLine2 = lineY(interactiveShapePos(1,1),interactiveShapePos(3,1),...
                  interactiveShapePos(1,2),interactiveShapePos(3,2),...
                  minXval);
xvalLine3 = lineX(interactiveShapePos(1,1),interactiveShapePos(4,1),...
                  interactiveShapePos(1,2),interactiveShapePos(4,2),...
                  minYval); 
yvalLine4 = lineY(interactiveShapePos(1,1),interactiveShapePos(5,1),...
                  interactiveShapePos(1,2),interactiveShapePos(5,2),...
                  maxXval);
quadrant1polygon = [interactiveShapePos(1,:);...
                    [xvalLine1,maxYval];...
                    [maxXval,maxYval];...
                    [maxXval,yvalLine4];...
                    interactiveShapePos(1,:)];
quadrant2polygon = [interactiveShapePos(1,:);...
                    [xvalLine1,maxYval];...
                    [minXval,maxYval];...
                    [minXval,yvalLine2];...
                    interactiveShapePos(1,:)];
quadrant3polygon = [interactiveShapePos(1,:);...
                    [minXval,yvalLine2];...
                    [minXval,minYval];...
                    [xvalLine3,minYval];...
                    interactiveShapePos(1,:)];
quadrant4polygon = [interactiveShapePos(1,:);...
                    [xvalLine3,minYval];...
                    [maxXval,minYval];...
                    [maxXval,yvalLine4];...
                    interactiveShapePos(1,:)];
quadrant1cells = length(find(inpoly(plotData,quadrant1polygon)));                
quadrant2cells = length(find(inpoly(plotData,quadrant2polygon)));
quadrant3cells = length(find(inpoly(plotData,quadrant3polygon)));
quadrant4cells = length(find(inpoly(plotData,quadrant4polygon))); 
set(handles.upPanel.quadrantGate.quadrant1,'String',...
        ['I .    ',num2str(quadrant1cells),' / ',num2str(size(plotData,1)),'   ',...
         num2str(quadrant1cells/size(plotData,1)*100,3),'%']);
set(handles.upPanel.quadrantGate.quadrant2,'String',...
        ['II .   ',num2str(quadrant2cells),' / ',num2str(size(plotData,1)),'   ',...
         num2str(quadrant2cells/size(plotData,1)*100,3),'%']);
set(handles.upPanel.quadrantGate.quadrant3,'String',...
        ['III .  ',num2str(quadrant3cells),' / ',num2str(size(plotData,1)),'   ',...
         num2str(quadrant3cells/size(plotData,1)*100,3),'%']);
set(handles.upPanel.quadrantGate.quadrant4,'String',...
        ['IV .   ',num2str(quadrant4cells),' / ',num2str(size(plotData,1)),'   ',...
         num2str(quadrant4cells/size(plotData,1)*100,3),'%']);
set(handles.upPanel.quadrantGate.noOfCellsPanel,'Visible','on');    
end
function autoGate_center_callback(hObject,eventdata)%#ok
newCenter = str2double(get(hObject,'string'));
switch hObject
    case handles.upPanel.autoGate.centerX
        if isnan(newCenter) || ...
           (get(handles.xAxis.trans.log,'Value') && newCenter < 0)
       
            if get(handles.xAxis.trans.log,'Value')
                set(hObject,'string',num2str(10.^interactiveShapePos(1)));
            else
                set(hObject,'string',num2str(interactiveShapePos(1)));
            end
            return;
        else
            originalLim(1) = str2double(get(handles.xAxis.lim.low,'string'));
            originalLim(2) = str2double(get(handles.xAxis.lim.hi,'string'));
            lim = get(handles.axes.axes,'XLim');
            if get(handles.xAxis.trans.log,'Value')
                newCenter = log10(newCenter);
                originalLim = log10(originalLim);
            end
        end
    case handles.upPanel.autoGate.centerY
        if isnan(newCenter) || ...
           (get(handles.yAxis.trans.log,'Value') && newCenter < 0)
            if get(handles.yAxis.trans.log,'Value')
                set(hObject,'string',num2str(10.^interactiveShapePos(2)));                
            else
                set(hObject,'string',num2str(interactiveShapePos(2)));
            end
            return;
        else
            originalLim(1) = str2double(get(handles.yAxis.lim.low,'string'));
            originalLim(2) = str2double(get(handles.yAxis.lim.hi,'string'));
            lim = get(handles.axes.axes,'YLim');
            if get(handles.yAxis.trans.log,'Value')
                newCenter = log10(newCenter);
                originalLim = log10(originalLim);
            end
        end        
end

if newCenter < originalLim(1)
    newCenter = originalLim(1);
    set(hObject,'string',num2str(originalLim(1)));
elseif newCenter > originalLim(2)
    newCenter = originalLim(2);
    set(hObject,'string',num2str(originalLim(2)));    
end

x0 = originalLim(1);
xLength = originalLim(2)-originalLim(1);

xx0 = lim(1);
xxLength = lim(2)-lim(1);

newCenter = xx0+((newCenter-x0)./xLength).*xxLength;
oldCenter = getPosition(interactiveShape);

switch hObject
    case handles.upPanel.autoGate.centerX
        setPosition(interactiveShape,[newCenter,oldCenter(2)]);        
    case handles.upPanel.autoGate.centerY
        setPosition(interactiveShape,[oldCenter(1),newCenter]);
end
end
function autoGate_expansMode_callback(hObject,eventdata)%#ok
switch hObject
    case handles.upPanel.autoGate.expansMode.radial
        set(hObject,'Enable','inactive');
        set(handles.upPanel.autoGate.expansMode.isolines,'Value',0,'Enable','on');
    case handles.upPanel.autoGate.expansMode.isolines
        set(hObject,'Enable','inactive');
        set(handles.upPanel.autoGate.expansMode.radial,'Value',0,'Enable','on');
end
end
function histGate_boundChange_callback(hObject,eventdata)%#ok
xLim = [get(handles.xAxis.lim.low,'UserData'),get(handles.xAxis.lim.hi,'UserData')];
histLim = [get(handles.hist.xAxis.lim.low,'UserData'),get(handles.hist.xAxis.lim.hi,'UserData')];

switch hObject
    case handles.upPanel.histGate.bound.low
        newLowBound = str2double(get(hObject,'String'));
        upBound = str2double(get(handles.upPanel.histGate.bound.hi,'String'));
        if isnan(newLowBound) || ...
           get(handles.xAxis.trans.log,'Value') && newLowBound < 0
            set(hObject,'String',num2str(get(hObject,'UserData')));
            return;
        elseif newLowBound > upBound
            if get(handles.xAxis.trans.log,'Value')
                newLowBound = 10.^(log10(upBound)-((log10(xLim(2))-log10(xLim(1)))*0.01));
            else
                newLowBound = upBound-((xLim(2)-xLim(1))*0.01);
            end
            set(hObject,'String',num2str(newLowBound),'UserData',newLowBound);
        elseif newLowBound <= histLim(1)
            set(hObject,'String',num2str(histLim(1)),'UserData',histLim(1));
        else
            set(hObject,'String',num2str(newLowBound),'UserData',newLowBound);
        end
    case handles.upPanel.histGate.bound.hi
        newHiBound = str2double(get(hObject,'String'));
        lowBound = str2double(get(handles.upPanel.histGate.bound.low,'String'));
        if isnan(newHiBound) || ...
           get(handles.xAxis.trans.log,'Value') && newHiBound < 0
            set(hObject,'String',num2str(get(hObject,'UserData')));
            return;
        elseif newHiBound < lowBound
            if get(handles.xAxis.trans.log,'Value')
                newHiBound = 10.^(log10(lowBound)+((log10(xLim(2))-log10(xLim(1)))*0.01));
            else
                newHiBound = lowBound+((xLim(2)-xLim(1))*0.01);
            end
            set(hObject,'String',num2str(newHiBound),'UserData',newHiBound);
        elseif newHiBound >= histLim(2)
            set(hObject,'String',num2str(histLim(2)),'UserData',histLim(2));
        else
            set(hObject,'String',num2str(newHiBound),'UserData',newHiBound);
        end      
    case handles.upPanel.histGate.bound.histMin
        newLowBound = get(handles.hist.xAxis.lim.low,'UserData');
        set(handles.upPanel.histGate.bound.low,'String',num2str(newLowBound),...
                                               'UserData',newLowBound);
    case handles.upPanel.histGate.bound.histMax
        newHiBound = get(handles.hist.xAxis.lim.hi,'UserData');
        set(handles.upPanel.histGate.bound.hi,'string',num2str(newHiBound),...
                                              'userData',newHiBound);
    case handles.upPanel.histGate.autoBound
        histTableData = get(handles.upPanel.histData,'Data');
        %'Mean','Median','Mode','Min','Max','STD','Variance','CV','CV^2','Var/Mean'
        stats = cellfun(@(x) str2double(x),histTableData(2,:));
        output = histGate_boundSet_dlg(stats);
        if isequal(output,0)
        	return;
        else
            [firstParam,percent,secondParam] = deal(output{:});
            newLowBound = stats(firstParam)-percent/100*stats(secondParam);
            newHiBound = stats(firstParam)+percent/100*stats(secondParam);
            
            if newLowBound <= histLim(1)
                newLowBound = histLim(1);
            end
            if newHiBound >= histLim(2)
                newHiBound = histLim(2);
            end
            if newLowBound > newHiBound
                if get(handles.xAxis.trans.log,'Value')
                    newLowBound = 10.^(log10(newHiBound)-((log10(xLim(2))-log10(xLim(1)))*0.01));
                else
                    newLowBound = newHiBound-((xLim(2)-xLim(1))*0.01);
                end
            end
            set(handles.upPanel.histGate.bound.low,'String',num2str(newLowBound),'UserData',newLowBound);
            set(handles.upPanel.histGate.bound.hi,'String',num2str(newHiBound),'UserData',newHiBound);
        end
end
set(handles.upPanel.histGate.noOfCells,'Visible','off');
realBounds = [get(handles.upPanel.histGate.bound.low,'UserData'),...
              get(handles.upPanel.histGate.bound.hi,'UserData')];
if get(handles.xAxis.trans.log,'Value')
	bounds = log10(realBounds);
    xLim = log10(xLim);
else
    bounds = realBounds;
end
if bounds(1) < xLim(1)
    bounds(1) = xLim(1);    
end
if bounds(2) > xLim(2)
    bounds(2) = xLim(2);    
end
x0 = xLim(1);
xLength = xLim(2)-xLim(1);
xLimPlot = get(handles.axes.axes,'XLim');
xx0 = xLimPlot(1);
xxLength = xLimPlot(2)-xLimPlot(1);
yLimPlot = get(handles.axes.axes,'YLim');
ycenter = (yLimPlot(1)+yLimPlot(2))/2;

boundsOnPlot = xx0+((bounds-x0)./xLength).*xxLength;
setPosition(interactiveShape.line,[boundsOnPlot(1) ycenter; boundsOnPlot(2) ycenter]);
setPosition(interactiveShape.low,[boundsOnPlot(1) yLimPlot(1); boundsOnPlot(1) yLimPlot(2)]);
setPosition(interactiveShape.hi,[boundsOnPlot(2) yLimPlot(1); boundsOnPlot(2) yLimPlot(2)]);

set(handles.upPanel.histGate.bound.low,'string',num2str(realBounds(1)),'UserData',realBounds(1));
set(handles.upPanel.histGate.bound.hi,'string',num2str(realBounds(2)),'UserData',realBounds(2));
if realBounds(1) == histLim(1)
	set(handles.upPanel.histGate.bound.histMin,'Value',1,'Enable','inactive');
else
	set(handles.upPanel.histGate.bound.histMin,'Value',0,'Enable','on');    
end
if realBounds(2) == histLim(2)
	set(handles.upPanel.histGate.bound.histMax,'Value',1,'Enable','inactive');
else
	set(handles.upPanel.histGate.bound.histMax,'Value',0,'Enable','on');        
end
end
function histGate_cal_callback(hObject,eventdata)%#ok
bounds = [get(handles.upPanel.histGate.bound.low,'UserData'),...
          get(handles.upPanel.histGate.bound.hi,'UserData')];
if get(handles.xAxis.trans.log,'Value')
    bounds = log10(bounds);
end
[sortedValues,~] = sort(plotData(:,1));
firstIndex = find(sortedValues>=bounds(1),1,'first');
lastIndex = find(sortedValues<=bounds(2),1,'last');      
set(handles.upPanel.histGate.noOfCells,'Visible','on','string',...
    [num2str(lastIndex-firstIndex+1),' / ',num2str(size(plotData(:,1),1)),'   ',...
     num2str((lastIndex-firstIndex+1)/size(plotData(:,1),1)*100,3),'%']);
end
function toolbar_semiAutoGate_callback(hObject,eventdata)%#ok
set([handles.rightColumn,handles.leftColumn],'Enable','off');
set([handles.axes.plotMode,handles.toolbar.toolbar],'Visible','off');
set([handles.menu.file,handles.menu.display,handles.menu.gates,...
     handles.menu.histMultiPlot,handles.menu.dotPlotMultiPlot,...
     handles.menu.calAxis,handles.menu.filter],'Enable','off');
output = semiAutoGate(handles,plotData,DEFAULT_GATECOLORS(rem(max(floor(gates.tag)),10)+1,:));
if ~isequal(output,0)
    saveGate_callback('semiauto',output);
    set(handles.rightColumn,'Enable','on');
else
    cancelGate_callback(0,0);
    set(handles.rightColumn,'Enable','on');
end
end
function chooseColor_callback(hObject,eventdata)%#ok
color = uisetcolor;
if ~isequal(color,0)
    set(hObject,'BackgroundColor',color);
    switch hObject 
        case handles.upPanel.quadrantGate.quadrant1color
            set(handles.upPanel.quadrantGate.quadrant1,'BackgroundColor',color);
        case handles.upPanel.quadrantGate.quadrant2color
            set(handles.upPanel.quadrantGate.quadrant2,'BackgroundColor',color);
        case handles.upPanel.quadrantGate.quadrant3color
            set(handles.upPanel.quadrantGate.quadrant3,'BackgroundColor',color);
        case handles.upPanel.quadrantGate.quadrant4color  
            set(handles.upPanel.quadrantGate.quadrant4,'BackgroundColor',color);
    end
end
end
function chooseName_callback(hObject,eventdata)%#ok
if hObject == handles.upPanel.autoGate.noOfCells && isnan(str2double(get(hObject,'String')))
	set(handles.upPanel.autoGate.noOfCells,'String','Specify number of cells','foregroundColor',[0.5 0.5 0.5],'FontAngle','italic','enable','inactive');
elseif isempty(get(hObject,'String'))
    set(hObject,'String','Choose name','foregroundColor',[0.5 0.5 0.5],'FontAngle','italic','Enable','inactive');
end
end
function chooseName_buttonDownCallback(hObject,eventdata)%#ok
if isequal(get(hObject,'Enable'),'inactive')
    set(hObject,'String','','fontAngle','normal','ForegroundColor',[0 0 0],'Enable','on');
    uicontrol(hObject);
end
end
function saveGate_callback(hObject,additionalInput)
switch hObject
    case handles.upPanel.manualGate.save
        gateName = {get(handles.upPanel.manualGate.name,'string')};
        gateType = 'manual';
        gateColor = get(handles.upPanel.manualGate.color,'backgroundcolor'); 
    case handles.upPanel.autoGate.save
        gateName = {get(handles.upPanel.autoGate.name,'string')};
        gateType = 'auto';      
        gateColor = get(handles.upPanel.autoGate.color,'backgroundcolor');    
    case handles.upPanel.quadrantGate.save
        gateName = cell(4,1);
        name = get(handles.upPanel.quadrantGate.name,'string');
        if isempty(name) || ~ischar(name) || strcmp(name,'Choose name')
            gateName{1} = ['Gate',num2str(floor(max(gates.tag))+1),'_qI'];
            gateName{2} = ['Gate',num2str(floor(max(gates.tag))+1),'_qII'];
            gateName{3} = ['Gate',num2str(floor(max(gates.tag))+1),'_qIII'];
            gateName{4} = ['Gate',num2str(floor(max(gates.tag))+1),'_qIV'];
        else
            gateName{1} = [name,'_qI'];
            gateName{2} = [name,'_qII'];
            gateName{3} = [name,'_qIII'];
            gateName{4} = [name,'_qIV'];
        end
        gateType = 'quadrant';
        gateColor = zeros(4,3);
        gateColor(1,:) = get(handles.upPanel.quadrantGate.quadrant1color,'BackgroundColor');
        gateColor(2,:) = get(handles.upPanel.quadrantGate.quadrant2color,'BackgroundColor');
        gateColor(3,:) = get(handles.upPanel.quadrantGate.quadrant3color,'BackgroundColor');
        gateColor(4,:) = get(handles.upPanel.quadrantGate.quadrant4color,'BackgroundColor');
    case handles.upPanel.histGate.save
        gateName = {get(handles.upPanel.histGate.name,'string')};
        gateType = 'hist';
        gateColor = get(handles.upPanel.histGate.color,'backgroundcolor');
        bounds = [get(handles.upPanel.histGate.bound.low,'UserData'),...
                  get(handles.upPanel.histGate.bound.hi,'UserData')];
        if get(handles.xAxis.trans.log,'Value')
            bounds = log10(bounds);
        end
        interactiveShapePos = bounds;
    case 'semiauto'
        gateName = additionalInput(1,1);
        gateType = 'semiauto';
        [data,gateColor,interactiveShapePos] = deal(additionalInput{1,2:end}); 
    case 'logical'
        gateName = additionalInput(1,1);
        [gateColor,data,gateType] = deal(additionalInput{1,2:end}); 
    case 'loadGate'
        gateName = additionalInput.name';
        gateType = additionalInput.type{1};
        if strcmp(gateType,'quadrant')
            gateColor = zeros(4,3);
            for i = 1:4
                gateColor(i,:) = additionalInput.color{i};
            end
        else
            gateColor = additionalInput.color{1};
        end
        interactiveShapePos = additionalInput.coordinates{1};
        if ~strcmp(gateType,'hist')
            if get(handles.xAxis.trans.log,'Value')
                interactiveShapePos(:,1) = log10(interactiveShapePos(:,1));
            end
            if get(handles.yAxis.trans.log,'Value')
            	interactiveShapePos(:,2) = log10(interactiveShapePos(:,2));               
            end
        else
            if get(handles.xAxis.trans.log,'Value')
                interactiveShapePos = log10(interactiveShapePos);
            end
        end
            
end
if isempty(gateName) || (~ischar(hObject) && hObject~=handles.upPanel.quadrantGate.save && ~ischar(gateName{1,1}))...
                     || any(strcmp(gateName,'Choose name'))
    gateName = {['Gate',num2str(max(floor(gates.tag))+1)]};
end

xAxis = get(handles.xAxis.param,'value');
yAxis = get(handles.yAxis.param,'value');

if get(handles.xAxis.trans.log,'Value')
    xTrans = 'Log';
else 
    xTrans = '';
end
if get(handles.yAxis.trans.log,'Value')
    yTrans = 'Log';
else 
    yTrans = '';
end

chosenGates = find(cellfun(@(x) x==1,tableData(:,1)));
if ~ismember(1,chosenGates) && ...
      (isempty(strfind(gateType,'logical')) && ...
       isempty(strfind(gateType,'semiauto'))&& ...
       hObject~=handles.upPanel.autoGate.save)
    plotData = NaN(size(fcData.data,1),2);
    if strcmp(xTrans,'Log')
        plotData(:,1) = fcData.dataLog(:,xAxis);
    else
        plotData(:,1) = fcData.data(:,xAxis);
    end
    if strcmp(yTrans,'Log')
        plotData(:,2) = fcData.dataLog(:,yAxis);
    else
        plotData(:,2) = fcData.data(:,yAxis);
    end
end
switch gateType
    case 'manual'
        gateData = {inpoly(plotData,interactiveShapePos)};
    case 'auto'
        if strcmpi(get(handles.upPanel.autoGate.noOfCells,'Enable'),'inactive')
            errordlg('Specify no. of cells!','Error','Replace');
            return;
        end
        center(1) = interactiveShapePos(:,1);
        center(2) = interactiveShapePos(:,2);
        noOfCells = str2double(strtrim(get(handles.upPanel.autoGate.noOfCells,'string')));
        if get(handles.upPanel.autoGate.expansMode.radial,'Value')
            dists = sqrt((plotData(:,1)-center(1)).^2+(plotData(:,2)-center(2)).^2);
            [~,indeces] = sort(dists);
            indeces = indeces(1:noOfCells);
            data = false(size(plotData,1),1);
            data(indeces) = true;
            gateData = {data};
        else
            gateData = {calCellsInIsolines('auto',plotData,contourMat2contour3DMat(twoDhistParam.c),center,noOfCells)};
        end
    case 'quadrant'
        if strcmp(xTrans,'Log')
            maxXval = max(fcData.dataLog(:,xAxis));
            minXval = min(fcData.dataLog(:,xAxis));
        else
            maxXval = max(fcData.data(:,xAxis));
            minXval = min(fcData.data(:,xAxis));            
        end
        if strcmp(yTrans,'Log')
            maxYval = max(fcData.dataLog(:,yAxis));
            minYval = min(fcData.dataLog(:,yAxis));
        else
            maxYval = max(fcData.data(:,yAxis));
            minYval = min(fcData.data(:,yAxis));
        end
        lineY = (@(x1,x2,y1,y2,X) ((y1-y2)/(x1-x2))*X + y1-x1*((y1-y2)/(x1-x2)));
        lineX = (@(x1,x2,y1,y2,Y) Y/((y1-y2)/(x1-x2))-y1/((y1-y2)/(x1-x2))+x1);
        xvalLine1 = lineX(interactiveShapePos(1,1),interactiveShapePos(2,1),...
                          interactiveShapePos(1,2),interactiveShapePos(2,2),...
                          maxYval);
        yvalLine2 = lineY(interactiveShapePos(1,1),interactiveShapePos(3,1),...
                          interactiveShapePos(1,2),interactiveShapePos(3,2),...
                          minXval);
        xvalLine3 = lineX(interactiveShapePos(1,1),interactiveShapePos(4,1),...
                          interactiveShapePos(1,2),interactiveShapePos(4,2),...
                          minYval); 
        yvalLine4 = lineY(interactiveShapePos(1,1),interactiveShapePos(5,1),...
                          interactiveShapePos(1,2),interactiveShapePos(5,2),...
                          maxXval);
        quadrant1polygon = [interactiveShapePos(1,:);...
                            [xvalLine1,maxYval];...
                            [maxXval,maxYval];...
                            [maxXval,yvalLine4];...
                            interactiveShapePos(1,:)];
        quadrant2polygon = [interactiveShapePos(1,:);...
                            [xvalLine1,maxYval];...
                            [minXval,maxYval];...
                            [minXval,yvalLine2];...
                            interactiveShapePos(1,:)];
        quadrant3polygon = [interactiveShapePos(1,:);...
                            [minXval,yvalLine2];...
                            [minXval,minYval];...
                            [xvalLine3,minYval];...
                            interactiveShapePos(1,:)];
        quadrant4polygon = [interactiveShapePos(1,:);...
                            [xvalLine3,minYval];...
                            [maxXval,minYval];...
                            [maxXval,yvalLine4];...
                            interactiveShapePos(1,:)];
        quadrant1cells = inpoly(plotData,quadrant1polygon);                
        quadrant2cells = inpoly(plotData,quadrant2polygon);
        quadrant3cells = inpoly(plotData,quadrant3polygon);
        quadrant4cells = inpoly(plotData,quadrant4polygon); 
        gateData = {quadrant1cells,quadrant2cells,quadrant3cells,quadrant4cells};
     case 'hist'
        [sortedValues,indeces] = sort(plotData(:,1));
        firstIndex = find(sortedValues>=interactiveShapePos(1),1,'first');
        lastIndex = find(sortedValues<=interactiveShapePos(2),1,'last');      
        data = false(size(plotData(:,1)));
        data(indeces(firstIndex:lastIndex)) = true;
        gateData = {data};
    otherwise %'logical' and 'semiauto'       
        gateData = {data};
end
if editGate == 0
    for i = 1:size(gateName,1) %for every type of gate except quadrant - i == 1
        gates.name(end+1) = gateName(i);
        gates.color(end+1) = {gateColor(i,:)};
        if ~strcmp(gateType,'quadrant')
            gates.tag(end+1) =  max(floor(gates.tag))+1;
        else
            if i == 1
                firstTag = max(gates.tag)+1+0.1;
                gates.tag(end+1) =  firstTag;
            else
                gates.tag(end+1) = floor(firstTag)+0.1*i;
            end
        end
        gates.data(end+1) = gateData(i);
        gates.type(end+1) = {gateType};
        if ~strcmp(hObject,'logical') && ~strcmp(gateType,'hist')
            gates.axes(end+1) = {[xAxis,yAxis]};
            axesStr = ['''',fcData.colheaders{xAxis},''',''',fcData.colheaders{yAxis},''''];
            gates.trans(end+1) = {{xTrans,yTrans}};
            transStr = ['''',xTrans,''',''',yTrans,''''];
            pos = interactiveShapePos;
            if strcmp(xTrans,'Log')
                pos(:,1) = 10.^pos(:,1);
            end
            if strcmp(yTrans,'Log') 
                pos(:,2) = 10.^pos(:,2);    
            end
            gates.coordinates(end+1) = {pos};
            coordinatesStr = mat2str(pos,3);
        elseif strcmp(gateType,'hist')
            gates.axes(end+1) = {xAxis};
            axesStr = ['''',fcData.colheaders{xAxis},''''];
            gates.trans(end+1) = {{xTrans}};
            transStr = ['''',xTrans,'''']; 
            pos = interactiveShapePos;
            if strcmp(xTrans,'Log')
                pos = 10.^pos;
            end
            gates.coordinates(end+1) = {pos};
            coordinatesStr = mat2str(pos,3);
        else
            gates.axes(end+1) = {''};
            gates.coordinates(end+1) = {''};
            gates.trans(end+1) = {''};
            axesStr = '';
            transStr = '';
            coordinatesStr = '';
        end
        if ~ismember(1,chosenGates) || strcmp(hObject,'logical')
            if isempty(strfind(gateType,'logical'))
                parents = gates.tag(chosenGates);
                if isempty(strfind(gateType,'semiauto')) &&...
                   hObject~=handles.upPanel.autoGate.save
               
                    unparentedData = gates.data(end);
                    chosenCells = any(cell2mat(gates.data(chosenGates)),2);
                    gates.data(end) = {and(gates.data{end},chosenCells)};
                    subPlot = NaN(size(plotData));
                    subPlot(chosenCells,:) = plotData(chosenCells,:);
                    plotData = subPlot;
                else
                    unparentedData = {[]};
                end
            else
                parents = gates.tag(chosenGates(chosenGates~=1));
                unparentedData = {[]};
            end
            parentsStr = '';
            for j = 1:length(parents)
                parentsStr = [parentsStr,'''',gates.name{gates.tag == parents(j)},''','];%#ok
            end
            lengthOfGate = length(find(gates.data{end}));
            precentage = lengthOfGate/(size(fcData.data,1)-length(find(filteredCells)))*100;
            parentsStr(end) = '';
            gates.parents(end+1) = {parents};
            parentsLengths = length(find(any(cell2mat(gates.data(ismember(gates.tag,parents))),2)));
            precentOfParent = lengthOfGate/parentsLengths*100;
        else
            parentsStr = '';
            gates.parents(end+1) = {[]};
            unparentedData = {[]};
            precentOfParent = [];
            lengthOfGate = length(find(gates.data{end}));
            precentage = lengthOfGate/(size(fcData.data,1)-length(find(filteredCells)))*100;
        end
        gates.unparentedData(end+1) = unparentedData;
        tableData(end+1,:) = ...
            [{true(1,1)},gates.name(end),color2htmlStr(gates.color{end}),...
            {num2str(lengthOfGate)},{num2str(precentage,3)},{num2str(precentOfParent,3)},...
            {parentsStr},gates.type(end),{axesStr},...
            {transStr},{coordinatesStr}]; %#ok<AGROW>
    end
else
    sameTag = find(floor(gates.tag(editGate)) == floor(gates.tag));
    for i = 1:length(sameTag)
        gates.name(sameTag(i)) = gateName(i);
        gates.color(sameTag(i)) = {gateColor(i,:)};
        gates.data(sameTag(i)) = gateData(i);
        pos = interactiveShapePos;
        if strcmp(xTrans,'Log')
            pos(:,1) = 10.^pos(:,1);
        end
        if strcmp(yTrans,'Log') 
            pos(:,2) = 10.^pos(:,2);    
        end
        gates.coordinates(sameTag(i)) = {pos};
        coordinatesStr = mat2str(pos,3);
        lengthOfGate = length(find(gates.data{sameTag(i)}));
        precentage = lengthOfGate/(size(fcData.data,1)-length(find(filteredCells)))*100;
        if ~isempty(gates.parents{sameTag(i)})
            parentsLengths = length(find(any(cell2mat(gates.data(ismember(gates.tag,gates.parents{sameTag(i)}))),2)));
            precentOfParent = lengthOfGate/parentsLengths*100;
        else
            precentOfParent = [];
        end
        tableData(sameTag(i),[2:6 11]) = ...
            [gates.name(sameTag(i)),color2htmlStr(gates.color{sameTag(i)}),...
            {num2str(lengthOfGate)},{num2str(precentage,3)},{num2str(precentOfParent,3)},...
            {coordinatesStr}]; 
        %Update children
        if ismember(floor(gates.tag(sameTag(i))),floor(cell2mat(gates.parents)))
            childGatesInds = find(cellfun(@(x) ismember(floor(gates.tag(sameTag(i))),floor(x)),gates.parents));
            for j = 1:length(childGatesInds)
                parentsStr = '';
                parents = gates.parents{childGatesInds(j)};
                for k = 1:length(parents)
                    parentInd = gates.tag == parents(k);
                    parentsStr = [parentsStr,'''',gates.name{parentInd},''','];%#ok
                end
                parentsStr(end) = '';
                tableData(childGatesInds(j),7) = {parentsStr};
                parentsInds = ismember(gates.tag,gates.parents{childGatesInds(j)});
                if strfind(gates.type{childGatesInds(j)},'logical')
                        switch gates.type{childGatesInds(j)}
                            case 'logical (AND)'
                                data = all(cell2mat(gates.data(parentsInds)),2);
                            case 'logical (OR)'
                                data = any(cell2mat(gates.data(parentsInds)),2);
                            case 'logical (NOT)'
                                data = ~any(cell2mat(gates.data(parentsInds)),2);
                            case 'logical (XOR)'
                                data = any(cell2mat(gates.data(parentsInds)),2) & ~all(cell2mat(gates.data(parentsInds)),2);
                        end
                elseif ismember(gates.type{childGatesInds(j)},{'hist','manual','quadrant'})
                    chosenCells = any(cell2mat(gates.data(parentsInds)),2);
                    data = and(gates.unparentedData{childGatesInds(j)},chosenCells);
                end
                gates.data(childGatesInds(j)) = {data};
                lengthOfGate = length(find(gates.data{childGatesInds(j)}));
                precentage = lengthOfGate/(size(fcData.data,1)-length(find(filteredCells)))*100;
                parentsLengths = length(find(any(cell2mat(gates.data(parentsInds)),2)));
                precentOfParent = lengthOfGate/parentsLengths*100;
                tableData(childGatesInds(j),4:6) = ...
                    [{num2str(lengthOfGate)},{num2str(precentage,3)},{num2str(precentOfParent,3)}];
            end
        end
    end
    editGate = 0;
end
set(handles.table,'data',tableData);
if get(handles.axes.plotMode,'value') == 1
    set(handles.rightColumn,'Heights',[0 -1],'MinimumHeights',[0 200]);
    set(handles.upPanel.panel,'Visible','off');
else
    set(handles.rightColumn,'Heights',[60 -1],'MinimumHeights',[40 200]);
    set(handles.upPanel.panel,'Visible','on','Selection',5);
end
%set(handles.leftColumn,'Enable','on');
set([handles.axes.plotMode,handles.toolbar.toolbar],'Visible','on');
set([handles.menu.file,handles.menu.display,handles.menu.gates,...
     handles.menu.histMultiPlot,handles.menu.dotPlotMultiPlot,...
     handles.menu.calAxis,handles.menu.filter],'Enable','on');
if ~isstruct(interactiveShape)
    delete(interactiveShape);
else
    cellfun(@(x) delete(x),struct2cell(interactiveShape));
end
clear('interactiveShape');
interactiveShape = [];
interactiveShapePos = [];
helperfcn_tableToolsEnableDisable;
helperfcn_plot(~'resetLimits',~'updatePlotData');
end
function cancelGate_callback(hObject,eventdata)%#ok
if get(handles.axes.plotMode,'value') == 1
    set(handles.rightColumn,'Heights',[0 -1],'MinimumHeights',[0 200]);
    set(handles.upPanel.panel,'Visible','off');
else
    set(handles.rightColumn,'Heights',[60 -1],'MinimumHeights',[40 200]);
    set(handles.upPanel.panel,'Visible','on','Selection',5);
end
set(handles.leftColumn,'Enable','on');
set([handles.axes.plotMode,handles.toolbar.toolbar],'Visible','on');
set([handles.menu.file,handles.menu.display,handles.menu.gates,...
     handles.menu.histMultiPlot,handles.menu.dotPlotMultiPlot,...
     handles.menu.calAxis,handles.menu.filter],'Enable','on');
if ~isstruct(interactiveShape)
    delete(interactiveShape);
else
    cellfun(@(x) delete(x),(struct2cell(interactiveShape)));
end
clear('interactiveShape');
interactiveShape = [];
interactiveShapePos = [];
helperfcn_plot(~'resetLimits',~'updatePlotData');
end

function tableCellEdit_callback(hObject,eventdata)
newTableData = get(hObject,'data');
chosenGates = find(cellfun(@(x) x==1,newTableData(:,1)));
row = eventdata.Indices(1,1);
col = eventdata.Indices(1,2);
if (row==1 && col==2)||isempty(chosenGates)
    set(handles.table,'data',tableData);
    return;
elseif col==1
    tableData = newTableData;
    if length(chosenGates)==length(gates.tag)
    	set(handles.tableTools.selectAll,'value',1,'Enable','inactive');    
    else     
        set(handles.tableTools.selectAll,'value',0,'Enable','on');    
    end
    helperfcn_tableToolsEnableDisable;
    helperfcn_plot(~'resetLimits','updatePlotData');
elseif col==2
    if isempty(eventdata.EditData)
        set(handles.table,'data',tableData);
        return;
    end
    if strcmp(gates.type{row},'quadrant')
        sameTag = find(floor(gates.tag(row)) == floor(gates.tag));
        name = newTableData{row,col};
        newTableData(sameTag(1),2) = {[name,'_qI']};
        newTableData(sameTag(2),2) = {[name,'_qII']};
        newTableData(sameTag(3),2) = {[name,'_qIII']};
        newTableData(sameTag(4),2) = {[name,'_qIV']};
        gates.name(sameTag(1)) = {[name,'_qI']};
        gates.name(sameTag(2)) = {[name,'_qII']};
        gates.name(sameTag(3)) = {[name,'_qIII']};
        gates.name(sameTag(4)) = {[name,'_qIV']};
    else
    	gates.name(row) = {eventdata.EditData};
    end
    tableData = newTableData;
    if ismember(floor(gates.tag(row)),floor(cell2mat(gates.parents)))
        childGatesInds = find(cellfun(@(x) ismember(floor(gates.tag(row)),floor(x)),gates.parents));
        for i = 1:length(childGatesInds)
            parentsStr = '';
            parents = gates.parents{childGatesInds(i)};
            for j = 1:length(parents)
                parentInd = gates.tag == parents(j);
                parentsStr = [parentsStr,'''',gates.name{parentInd},''','];%#ok
            end
            parentsStr(end) = '';
        tableData(childGatesInds(i),7) = {parentsStr}; 
        end
    end
	set(hObject,'Data',tableData);
end
end
function tableChangeColor_callback(hObject,eventdata)
if ~isempty(eventdata.Indices)
    row = eventdata.Indices(1,1);
    column = eventdata.Indices(1,2);
    if column == 3 && row~= 1
        color = uisetcolor;
        if ~isequal(color,0)
            gates.color(row) = {color};
            tableData(row,column) = {color2htmlStr(color)};
            set(hObject,'Data',tableData);
            helperfcn_plot(~'resetLimits',~'updatePlotData');
        end
    end
end
end
function tableSelectAllNone_callback(hObject,eventdata)%#ok
switch hObject
    case handles.tableTools.selectAll
        set(hObject,'Enable','inactive');
        tableData(:,1) = {true};
    case handles.tableTools.selectNone
        set(handles.tableTools.selectAll,'Enable','on');
        tableData(:,1) = {false};
        tableData(1,1) = {true};
end
set(handles.table,'data',tableData);
helperfcn_tableToolsEnableDisable;
helperfcn_plot(~'resetLimits','updatePlotData');
end
function tableTools_clearGate_callback(hObject,eventdata)%#ok
chosenGates = find(cellfun(@(x) x==1,tableData(:,1)));
chosenGates(chosenGates == 1) = [];
chosenTags = unique(floor(gates.tag(chosenGates)));
names = gates.name(arrayfun(@(x) find(x == floor(gates.tag),1,'first'),chosenTags));
quadrantInd = find(strcmp('quadrant',gates.type(arrayfun(@(x) find(x == floor(gates.tag),1,'first'),chosenTags))));
for i = 1:length(quadrantInd)
   quadrantName = regexp(names{quadrantInd(i)},'(.*)_qI','tokens'); 
   quadrantName = quadrantName{1,1}{1,1};
   names{quadrantInd(i)} = quadrantName;
end
answer = questdlg(char('Are you sure you want to clear those gates?',...
                  char(names)),'Attention','Cancel','Proceed','Cancel');
if strcmp(answer,'Proceed')
    erasable = true(length(chosenTags),1);
    for i = 1:length(chosenTags)
        childGatesInds = find(cellfun(@(x) ismember(chosenTags(i),floor(x)),gates.parents));
        if ~all(ismember(childGatesInds,chosenGates))
            errordlg(char('The gate: ',gates.name{chosenGates(i)},...
                           'is a parent for the gate(s): ',gates.name{childGatesInds(~ismember(childGatesInds,chosenGates))},'First delete the children, and then move to the parent.') ,'error','replace');
            erasable(i) = false;
        end
    end
    inds = ismember(floor(gates.tag),chosenTags(erasable));
    gates.name(inds) = [];
    gates.tag(inds) = [];
    gates.data(inds) = [];
    gates.trans(inds) = [];
    gates.axes(inds) = [];
    gates.type(inds) = [];
    gates.coordinates(inds) = [];
    gates.color(inds) = [];
    gates.parents(inds) = [];
    gates.unparentedData(inds) = [];
    tableData(inds,:) = [];
    if length(gates.name)==1 || isempty(find(cellfun(@(x) x==1,tableData(:,1)),1))
       tableData(1,1) = {true(1,1)};
    end
    set(handles.table,'data',tableData);
    helperfcn_plot(~'resetLimits','updatePlotData');
    helperfcn_tableToolsEnableDisable;
end    
end
function tableTools_moveGate_callback(hObject,eventdata)%#ok
currentIndex = find(cellfun(@(x) x==1,tableData(:,1)));
currentIndex(currentIndex==1) = [];
switch hObject
    case {handles.tableTools.moveUp}
        newIndex = currentIndex-1;
    case {handles.tableTools.moveDown}
        newIndex = currentIndex+1;
end
gates.name([currentIndex,newIndex]) = gates.name([newIndex,currentIndex]);
gates.tag([currentIndex,newIndex]) = gates.tag([newIndex,currentIndex]);
gates.data([currentIndex,newIndex]) = gates.data([newIndex,currentIndex]);
gates.type([currentIndex,newIndex]) = gates.type([newIndex,currentIndex]);
gates.axes([currentIndex,newIndex]) = gates.axes([newIndex,currentIndex]);
gates.trans([currentIndex,newIndex]) = gates.trans([newIndex,currentIndex]);
gates.coordinates([currentIndex,newIndex]) = gates.coordinates([newIndex,currentIndex]);
gates.color([currentIndex,newIndex]) = gates.color([newIndex,currentIndex]);
gates.parents([currentIndex,newIndex]) = gates.parents([newIndex,currentIndex]);
gates.unparentedData([currentIndex,newIndex]) = gates.unparentedData([newIndex,currentIndex]);
tableData([currentIndex,newIndex],:) = tableData([newIndex,currentIndex],:);
set(handles.table,'data',tableData); 
helperfcn_tableToolsEnableDisable;
end
function tableTools_logicalGate_callback(hObject,eventdata)%#ok
chosenGates = find(cellfun(@(x) x==1,tableData(:,1)));
chosenGates(chosenGates == 1) = [];
switch hObject
    case {handles.tableTools.inverseGate,handles.menu.inverseGate}
        gateNameStr = ['NOT(',gates.name{chosenGates(1)}];
    case {handles.tableTools.unionGate,handles.menu.unionGate}
        gateNameStr = ['UNION(',gates.name{chosenGates(1)}];
    case {handles.tableTools.intersectGate,handles.menu.intersectGate}
        gateNameStr = ['INTERSECT(',gates.name{chosenGates(1)}];
    case {handles.tableTools.XORGate,handles.menu.XORGate}
        gateNameStr = ['XOR(',gates.name{chosenGates(1)}];
end
if length(chosenGates)>1
    for i = 2:length(chosenGates)
        gateNameStr = [gateNameStr,',',gates.name{chosenGates(i)}];%#ok
    end
end
gateNameStr = [gateNameStr,')'];
modGateNameStr = gateNameStr; 
i = 1;
while ~isempty(find(ismember(modGateNameStr,gates.name),1))
    modGateNameStr = [gateNameStr,'_',num2str(i)];
    i = i+1;
end
gateNameStr = modGateNameStr;
output = logicalGate_dlg(gates.name,gateNameStr,DEFAULT_GATECOLORS(rem(max(floor(gates.tag)),10)+1,:));
if ~isequal(output,0)
    switch hObject
        case {handles.tableTools.intersectGate,handles.menu.intersectGate}
            data = all(cell2mat(gates.data(chosenGates)),2);
            gateType = 'logical (AND)';
        case {handles.tableTools.unionGate,handles.menu.unionGate}
            data = any(cell2mat(gates.data(chosenGates)),2);
            gateType = 'logical (OR)';
        case {handles.tableTools.inverseGate,handles.menu.inverseGate}
            data = ~any(cell2mat(gates.data(chosenGates)),2);
            gateType = 'logical (NOT)';
        case {handles.tableTools.XORGate,handles.menu.XORGate}
            data = any(cell2mat(gates.data(chosenGates)),2) & ~all(cell2mat(gates.data(chosenGates)),2);
            gateType = 'logical (XOR)';
    end
    if isempty(find(data,1,'first'))
        errordlg('Empty set, gate will not be saved','Error','replace');
        return;
    else
        saveGate_callback('logical',[output,{data},{gateType}]);
    end
end
end
function tableTools_editGate_callback(hObject,eventdata)%#ok
allowedGates = ismember(gates.type,{'manual','quadrant','hist'});    
tags = unique(floor(gates.tag(allowedGates)));
names = gates.name(arrayfun(@(x) find(x == floor(gates.tag),1,'first'),tags));
quadrantInd = find(strcmp('quadrant',gates.type(arrayfun(@(x) find(x == floor(gates.tag),1,'first'),tags))));
for i = 1:length(quadrantInd)
   quadrantName = regexp(names{quadrantInd(i)},'(.*)_qI','tokens'); 
   quadrantName = quadrantName{1,1}{1,1};
   names{quadrantInd(i)} = quadrantName;
end
if length(tags) > 1
    [selection,ok] = listdlg('ListString',names,'SelectionMode','single','PromptString','Select gate for editing (only gates of types: manual, quadrant and hist, can be edited):');
    if ~ok
        return;
    end
else
    selection = tags;
end    

editGate = find(floor(gates.tag) == tags(selection),1,'first');
xAxis = gates.axes{editGate}(1);
set(handles.xAxis.param,'Value',xAxis);
xTrans = gates.trans{editGate}{1};

resetLimits = 0;
if strcmp(xTrans,'Log')
    if ~get(handles.xAxis.trans.log,'Value')
        set(handles.xAxis.trans.log,'Value',1,'Enable','inactive');
        set(handles.xAxis.trans.none,'Value',0,'Enable','on');
        resetLimits = 1;
    end
else
    if get(handles.xAxis.trans.log,'Value')
        set(handles.xAxis.trans.none,'Value',1,'Enable','inactive');
        set(handles.xAxis.trans.log,'Value',0,'Enable','on');
        resetLimits = 1;
    end
end
if ~strcmp(gates.type{editGate},'hist')
    set(handles.axes.plotMode,'Value',1);
    yAxis = gates.axes{editGate}(2);
    set(handles.yAxis.param,'Value',yAxis);
    yTrans = gates.trans{editGate}{2};
    if strcmp(yTrans,'Log')
        if ~get(handles.yAxis.trans.log,'Value')
            set(handles.yAxis.trans.log,'Value',1,'Enable','inactive');
            set(handles.yAxis.trans.none,'Value',0,'Enable','on');
            resetLimits = 1;
        end
    else
        if get(handles.yAxis.trans.log,'Value')
            set(handles.yAxis.trans.none,'Value',1,'Enable','inactive');
            set(handles.yAxis.trans.log,'Value',0,'Enable','on');
            resetLimits = 1;
        end
    end
else
    set(handles.axes.plotMode,'Value',2);
end
plotModeChange_callback('loadFcnCall');
if resetLimits
    helperfcn_plot(resetLimits,'updatePlotData');
end
coordinates = gates.coordinates{editGate};
xLim = [get(handles.xAxis.lim.low,'UserData'),get(handles.xAxis.lim.hi,'UserData')];
if min(coordinates(:,1)) < xLim(1)
    if strcmp(xTrans,'Log')
        xLim(1) = 10.^(log10(min(coordinates(:,1)))-((log10(xLim(2))-log10(xLim(1)))*0.1));
    else
        xLim(1) = min(coordinates(:,1))-((xLim(2)-xLim(1))*0.1);
    end
    set(handles.xAxis.lim.low,'String',num2str(xLim(1)),'UserData',xLim(1));
end
if max(coordinates(:,1)) > xLim(2)
    if strcmp(xTrans,'Log')
        xLim(2) = 10.^(log10(max(coordinates(:,1)))+((log10(xLim(2))-log10(xLim(1)))*0.1));
    else
        xLim(2) = max(coordinates(:,1))+((xLim(2)-xLim(1))*0.1);
    end
    set(handles.xAxis.lim.hi,'String',num2str(xLim(2)),'UserData',xLim(2));
end
if ~strcmp(gates.type{editGate},'hist')
    yLim = [get(handles.yAxis.lim.low,'UserData'),get(handles.yAxis.lim.hi,'UserData')];
    if min(coordinates(:,2)) < yLim(1)
        if strcmp(yTrans,'Log')
            yLim(1) = 10.^(log10(min(coordinates(:,2)))-((log10(yLim(2))-log10(yLim(1)))*0.1));
        else
            yLim(1) = min(coordinates(:,2))-((yLim(2)-yLim(1))*0.1);
        end
        set(handles.yAxis.lim.low,'String',num2str(yLim(1)),'UserData',yLim(1));
    end
    if max(coordinates(:,2)) > yLim(2)
        if strcmp(yTrans,'Log')
            yLim(2) = 10.^(log10(max(coordinates(:,2)))+((log10(yLim(2))-log10(yLim(1)))*0.1));
        else
            yLim(2) = max(coordinates(:,2))+((yLim(2)-yLim(1))*0.1);
        end
        set(handles.yAxis.lim.hi,'String',num2str(yLim(2)),'UserData',yLim(2));
    end
end
helperfcn_plot(~'resetLimits',~'updatePlotData');
interactiveGate_callback('edit',editGate);
end
function tableTools_dupliGate_callback(hObject,eventdata)%#ok
chosenGates = find(cellfun(@(x) x==1,tableData(:,1)));
chosenGates(chosenGates==1) = [];   
chosenTags = unique(floor(gates.tag(chosenGates)));
for i = 1:length(chosenTags)
    tagGates = find(chosenTags(i) == floor(gates.tag));
    gates.name(end+1:end+length(tagGates)) = gates.name(tagGates);
    gates.data(end+1:end+length(tagGates)) = gates.data(tagGates);
    gates.type(end+1:end+length(tagGates)) = gates.type(tagGates);
    gates.axes(end+1:end+length(tagGates)) = gates.axes(tagGates);
    gates.trans(end+1:end+length(tagGates)) = gates.trans(tagGates);
    gates.coordinates(end+1:end+length(tagGates)) = gates.coordinates(tagGates);
    gates.color(end+1:end+length(tagGates)) = gates.color(tagGates);
    gates.parents(end+1:end+length(tagGates)) = gates.parents(tagGates);
    gates.unparentedData(end+1:end+length(tagGates)) = gates.unparentedData(tagGates);
    tableData(end+1:end+length(tagGates),:) = tableData(tagGates,:);
    if length(tagGates) == 1 %not a quadrant gate
        gates.tag(end+1) = max(floor(gates.tag))+1;
    else
        gates.tag(end+1:end+length(tagGates)) = max(floor(gates.tag))+(1.1:0.1:1.4);
    end
end
set(handles.table,'Data',tableData);
helperfcn_tableToolsEnableDisable;
helperfcn_plot(~'resetLimits','updatePlotData');
end
function tableTools_saveGate2File_callback(hObject,eventData)%#ok
chosenGates = find(cellfun(@(x) x==1,tableData(:,1)));
chosenGates(chosenGates==1) = []; 
notAllowed = cellfun(@(x) ismember(x,{'filter','auto','semiauto'}),tableData(chosenGates,8)) | ...
             ~cellfun(@(x) isempty(x),cellfun(@(x) strfind(x,'logical'),tableData(chosenGates,8),'Uniformoutput',false));
haveParents = ~cellfun(@(x) isempty(x),gates.parents(chosenGates));
if ismember(hObject,[handles.tableTools.saveGate,handles.menu.saveGate])
    if ~isempty(find(notAllowed,1))
        errordlg('Only gates of type: ''manual'', ''quadrant'' and ''hist'' could be saved, deselect gates of other types (you can still save the reads of those gates). See help button (?)','Error','replace');
        return;
    end
    if  ~isempty(find(haveParents,1))
        h = warndlg('Gates that have dependencies (i.e. have parents) will be saved without the dependencies, only the coordinates will be saved. See help button (?)','Error','replace'); 
        uiwait(h);
    end
end
folderName = uigetdir(getappdata(handles.figure,'folderName'),'Choose destination folder');
if isequal(folderName,0)
    return;
end
switch hObject
    case {handles.tableTools.saveGateReads,handles.menu.saveGateReads}
        fileNames = cellfun(@(x) genvarname(x),gates.name(chosenGates),'Uniformoutput',false);
        for i = 1:length(chosenGates)
            gateData.data = fcData.data(gates.data{chosenGates(i)},:);
            gateData.colheaders = fcData.colheaders;
            save([folderName,filesep,fileNames{i}],'gateData');
        end
    case {handles.tableTools.saveGate,handles.menu.saveGate}
        chosenTags = unique(floor(gates.tag(chosenGates)));
        fileNames = cellfun(@(x) genvarname(x),gates.name(arrayfun(@(x) find(x == floor(gates.tag),1,'first'),chosenTags)),'Uniformoutput',false);
        for i = 1:length(chosenTags)
            tagGates = find(chosenTags(i) == floor(gates.tag));
            gateData = [];
            for j = 1:length(tagGates)
                gateData.name(j) = gates.name(tagGates(j));
                gateData.type(j) = gates.type(tagGates(j));
                gateData.axes(j) = gates.axes(tagGates(j));
                gateData.trans(j) = gates.trans(tagGates(j));
                gateData.coordinates(j) = gates.coordinates(tagGates(j));
                gateData.color(j) = gates.color(tagGates(j));
                gateData.colheaders = fcData.colheaders;
            end
            save([folderName,filesep,fileNames{i}],'gateData');
        end
end
end
function tableTools_loadGate_callback(hObject,eventData)%#ok
[fileName,folderName,ok] = uigetfile('*.mat','Choose gate coordinates .mat file');
if ok
    try
        varName = who('-file',[folderName,fileName]);
        externalVar = load([folderName,fileName]);
        data = externalVar.(varName{1,1});
        if size(varName,1)>1
            errordlg('The .mat file should contain only one variable that is a structure with the fields ''name'', ''type'', ''trans'', ''coordinates'' and ''color'', see help button (?)','error','replace');
            return;
        elseif    ~isstruct(data)||~isfield(data,'name')||~isfield(data,'type')||~isfield(data,'trans')||~isfield(data,'coordinates')||~isfield(data,'color')
            errordlg(['The variable contains in this .mat file: ''',fileName,''' is not a structure with the fields ''name'', ''type'', ''trans'', ''coordinates'' and ''color'', see help button (?)'],'error','replace');
            return;            
        end        
    catch exception
        errordlg(exception.message,'error','replace');
        return;
    end
else
    return;
end
xAxis = find(strcmp(data.colheaders{data.axes{1}(1)},fcData.colheaders));
if ~strcmp(data.type,'hist')
    yAxis = find(strcmp(data.colheaders{data.axes{1}(2)},fcData.colheaders));
    paramstr = [data.colheaders{data.axes{1}(1)},' , ',data.colheaders{data.axes{1}(2)}];
else
    yAxis = 0;
    paramstr = [data.colheaders{data.axes{1}(1)}];
end
if isempty(xAxis) || isempty(yAxis)
    errordlg(char({'The gate is based on a parameter that does not exist in this FC data file, the file could not be loaded','','Gate parameters:',paramstr,'','FC data file parameters:',char(fcData.colheaders),'','See help button (?)'}),'Error','replace');
    return;
end
set(handles.xAxis.param,'Value',xAxis);
data.axes = {[xAxis,yAxis]};
xTrans = data.trans{1}{1};
if strcmp(xTrans,'Log')
    set(handles.xAxis.trans.log,'Value',1,'Enable','inactive');
    set(handles.xAxis.trans.none,'Value',0,'Enable','on');
else
    set(handles.xAxis.trans.none,'Value',1,'Enable','inactive');
    set(handles.xAxis.trans.log,'Value',0,'Enable','on');
end
if ~strcmp(data.type,'hist')
    set(handles.axes.plotMode,'Value',1);
    yTrans = data.trans{1}{2};
    set(handles.yAxis.param,'Value',yAxis);
    if strcmp(yTrans,'Log')
        set(handles.yAxis.trans.log,'Value',1,'Enable','inactive');
        set(handles.yAxis.trans.none,'Value',0,'Enable','on');
    else
        set(handles.yAxis.trans.none,'Value',1,'Enable','inactive');
        set(handles.yAxis.trans.log,'Value',0,'Enable','on');
    end
else
    set(handles.axes.plotMode,'Value',2);
end
plotModeChange_callback('loadFcnCall');
helperfcn_plot('resetLimits','updatePlotData');
saveGate_callback('loadGate',data);
end

function toolbar_exportFig_callback(hObject,eventdata)%#ok
newFig = figure;
copyobj(handles.axes.axes,newFig);    
end
function toolbar_subplotsFigureTools_callback(hObject,eventdata)%#ok
if ~isappdata(handles.figure,'folderName')  
    subplotsFigureTool;
else
    subplotsFigureTool(handles);
end
end
function toolbar_help_callback(hObject,eventdata)%#ok
open('FCGUI_help.pdf');
end
%------------------------------HELPER FUNCTIONS----------------------------
function ok = helperfcn_load(folderName,fileName,previousHandles)
%There are 6 ways of loading files:
%1. The first load - choose file load data in defult parameters
%2. Open in new window using the same parameters:
%   a. the same file (duplicate window)
%   b. a new file (open the open dialog choose file and load it)
%   c. the next/last file in folder (auto load in a new window).
%3. Open in the same window using the same parameters:
%   a. a new file (open the open dialog choose file and load it).
%   b. the next/last file in folder (auto load in the same window).

%firstLoad == 1 in case 1 above.
%newWin == 1 in case 2abc above.
ok = 0;
firstLoad = 0;
newWin = 0;
switch nargin
    case 0 
        if ~isappdata(handles.figure,'folderName')
            %in case 1 above
            firstLoad = 1;
            [fileName,folderName,ok] = uigetfile('*.mat','Choose FC data .mat file');
        else %in case 3a above
            folderName = getappdata(handles.figure,'folderName');
            [fileName,folderName,ok] = uigetfile('*.mat','Choose FC data .mat file',folderName);
            oldParams = getappdata(handles.figure,'params');
        end
    case 2 %in case 3b above
        ok = 1;
        oldParams = getappdata(handles.figure,'params');
    case 3 
        newWin = 1;
        if isempty(folderName) %in case 2b above
            [fileName,folderName,ok] = uigetfile('*.mat','Choose FC data .mat file');
            if ~isappdata(previousHandles.figure,'folderName') %in case 2a without previous file
                                                               %practically the same as
                                                               %case 1
                firstLoad = 1;
            else 
                oldParams = getappdata(previousHandles.figure,'params'); %case 2b
            end
        else %cases 2a and 2c
            ok = 1;
            oldParams = getappdata(previousHandles.figure,'params');
        end
end

if ok
    try
        varName = who('-file',[folderName,fileName]);
        externalVar = load([folderName,fileName]);
        data = externalVar.(varName{1,1});
        if size(varName,1)>1
            errordlg('The .mat file should contain only one variable that is a structure with the fields ''data'' and ''colheaders'', see help button (?)','error','replace');
            return;
        elseif    ~isstruct(data)||~isfield(data,'data')||~isfield(data,'colheaders')
            errordlg(['The variable contains in this .mat file: ''',fileName,''' is not a structure with the fields ''data'' and ''colheaders'', see help button (?)'],'error','replace');
            return;
        elseif ~firstLoad && ~isequal(oldParams,data.colheaders)
            if ~newWin
                errordlg(['The parameters inside:''',varName{1,1},'.colheaders'' do not match the parameters in the last file that was opened, the parameters must match.',...
                            'In order to open the file press New Window button or ctrl+N and open the file there, see help button (?)'],'error','replace');
            else
                errordlg(['The parameters inside:''',varName{1,1},'.colheaders'' do not match the parameters in the last file that was opened, the parameters must match.',...
                            'In order to open the file you can press now the Open button or ctrl+O, however the previous settings will not be kept, see help button (?)'],'error','replace');
            end
            return;            
        end        
    catch exception
        errordlg(exception.message,'error','replace');
        return;
    end
else
    return;
end

fcData = data;
filteredCells = zeros(size(fcData,2),1);
fcData.dataLog = trans_Log(fcData.data);
if find(strcmpi(fcData.colheaders,'Time'))
    fcData.dataLog(1,strcmpi(fcData.colheaders,'Time'))=0;
end
setappdata(handles.figure,'fileName',fileName);
setappdata(handles.figure,'folderName',folderName);
setappdata(handles.figure,'params',fcData.colheaders);
ok = 1;

filesInFolder = dir([folderName,'/*.mat']);
filesInFolder = struct2cell(filesInFolder);
filesInFolder = filesInFolder(1,:)';

if size(filesInFolder,1)>1
    set([handles.toolbar.openNext,handles.toolbar.openNextNewWin,handles.toolbar.openLast,...
         handles.toolbar.openLastNewWin,handles.menu.openNext,handles.menu.openNextNewWin,...
         handles.menu.openLast,handles.menu.openLastNewWin,handles.toolbar.dotPlotMultiPlot,...
         handles.toolbar.histMultiPlot],'enable','on');
else
    set([handles.toolbar.openNext,handles.toolbar.openNextNewWin,handles.toolbar.openLast,...
         handles.toolbar.openLastNewWin,handles.menu.openNext,handles.menu.openNextNewWin,...
         handles.menu.openLast,handles.menu.openLastNewWin,handles.toolbar.dotPlotMultiPlot,...
         handles.toolbar.histMultiPlot],'enable','off');    
end
set(handles.figure,'Name',[strtok(fileName,'.'),' (',num2str(find(strcmp(fileName,filesInFolder))),'/',num2str(size(filesInFolder,1)),')']);    

if firstLoad||newWin
    set(handles.bigGrid,'Widths',[-0.25 -1],'MinimumWidths',[210 200]);
    set([handles.toolbar.filter,handles.toolbar.calAxis,handles.toolbar.resetView,...
         handles.toolbar.zoomIn,handles.toolbar.zoomOut,handles.toolbar.duplicateWin,...
         handles.menu.duplicateWin,handles.menu.display,handles.menu.gates,...
         handles.toolbar.twoDhist,handles.toolbar.pan,handles.menu.filter,handles.menu.calAxis,...
         handles.menu.loadGate,handles.toolbar.exportFig,handles.menu.exportFig],'enable','on');
    set([handles.axes.plotMode,double(handles.yAxisORhistPanel),double(handles.xAxis.panelBig),...
         handles.switchAxes,double(handles.leftColumn),double(handles.tableTools.panel),...
         handles.table],'Visible','on');
end
if firstLoad
    setappdata(handles.figure,'params',fcData.colheaders);
    set(handles.xAxis.param,'string',fcData.colheaders,'value',1);
    set(handles.xAxis.trans.log,'Value',1);
    set(handles.yAxis.trans.log,'Value',1);
    set(handles.hist.noOfBins,'String',num2str(DEFAULT_HISTNOOFBINS),'UserData',DEFAULT_HISTNOOFBINS);
    set(handles.hist.smoothWidth,'String',num2str(DEFAULT_HISTSMOOOTHWIDTH),'UserData',DEFAULT_HISTSMOOOTHWIDTH);
    tableData = [{true(1,1)},gates.name(end),color2htmlStr(gates.color{end}),{num2str(size(fcData.data,1))},{'100'},{''},{''},gates.type(end),gates.axes(end),gates.trans(end),gates.coordinates(end)];
    if size(fcData.data,2)>=2
        set(handles.yAxis.param,'string',fcData.colheaders,'value',2);
    else
        set(handles.yAxis.param,'string',fcData.colheaders,'value',1);
        set(handles.axes.plotMode,'Value',2,'Enable','off');
    end
    plotModeChange_callback('loadFcnCall');
    helperfcn_plot('resetLimits','updatePlotData');
else
    if newWin
        if isappdata(previousHandles.figure,'filters')
            setappdata(handles.figure,'filters',getappdata(previousHandles.figure,'filters'));
            set(handles.toolbar.filter,'State','on');
        end
        if isappdata(previousHandles.figure,'calParams')
            setappdata(handles.figure,'calParams',getappdata(previousHandles.figure,'calParams'));
        end
    else
        gates.name = {'All data'};
        gates.tag = 0;
        gates.data = {''};
        gates.type = {''};
        gates.axes = {''};
        gates.trans = {''};
        gates.coordinates = {''};
        gates.color = {[0 0 0]};
        gates.parents = {[]};
        gates.unparentedData = {[]};
    end
    
    if isappdata(handles.figure,'calParams')
        calParams = getappdata(handles.figure,'calParams');
        for i = 1:size(calParams.name,1)
            if isempty(find(strcmp(fcData.colheaders,calParams.name{i,1}),1))
                helperfcn_calParams(calParams.name{i,1},calParams.operation(i,:))
            end
        end
    end
    if isappdata(handles.figure,'filters')
        helperfcn_transferFilters;
        tableData = [{true(1,1)},gates.name(end),color2htmlStr(gates.color{end}),...
                    {[num2str((size(fcData.data,1)-length(find(filteredCells)))),...
                                   ' (',num2str(length(find(filteredCells))),...
                                   ' filtered)'],...
                                   },{'100'},{''},{''},gates.type(end),...
                                   gates.axes(end),gates.trans(end),gates.coordinates(end)];
    else
        tableData = [{true(1,1)},gates.name(end),color2htmlStr(gates.color{end}),...
                    {num2str(size(fcData.data,1))},{'100'},{''},{''},...
                    gates.type(end),gates.axes(end),gates.trans(end),gates.coordinates(end)];
    end    
    
    if newWin
        set(handles.xAxis.param,'string',fcData.colheaders,'value',get(previousHandles.xAxis.param,'value'));
        set(handles.yAxis.param,'string',fcData.colheaders,'value',get(previousHandles.yAxis.param,'value'));
        set(handles.toolbar.twoDhist,'State',get(previousHandles.toolbar.twoDhist,'State'));
        set(handles.xAxis.lim.low,'string',get(previousHandles.xAxis.lim.low,'string'),...
                                  'UserData',get(previousHandles.xAxis.lim.low,'UserData'));
        set(handles.xAxis.lim.hi,'string',get(previousHandles.xAxis.lim.hi,'string'),...
                                 'UserData',get(previousHandles.xAxis.lim.hi,'UserData'));
        set(handles.yAxis.lim.low,'string',get(previousHandles.yAxis.lim.low,'string'),...
                                  'UserData',get(previousHandles.yAxis.lim.low,'UserData'));
        set(handles.yAxis.lim.hi,'string',get(previousHandles.yAxis.lim.hi,'string'),...
                                 'UserData',get(previousHandles.yAxis.lim.hi,'UserData'));
        set(handles.xAxis.trans.log,'Value',get(previousHandles.xAxis.trans.log,'Value'),...
                                    'Enable',get(previousHandles.xAxis.trans.log,'Enable'));
        set(handles.yAxis.trans.log,'Value',get(previousHandles.yAxis.trans.log,'Value'),...
                                    'Enable',get(previousHandles.yAxis.trans.log,'Enable'));
        set(handles.xAxis.trans.none,'Value',get(previousHandles.xAxis.trans.none,'Value'));
        set(handles.yAxis.trans.none,'Value',get(previousHandles.yAxis.trans.none,'Value')); 
        set(handles.hist.xAxis.lim.low,'String',get(previousHandles.hist.xAxis.lim.low,'String'),...
                                       'UserData',get(previousHandles.hist.xAxis.lim.low,'UserData'));
        set(handles.hist.xAxis.lim.hi,'String',get(previousHandles.hist.xAxis.lim.hi,'String'),...
                                       'UserData',get(previousHandles.hist.xAxis.lim.hi,'UserData'));
        set(handles.hist.yAxis.lim.low,'String',get(previousHandles.hist.yAxis.lim.low,'String'),...
                                       'UserData',get(previousHandles.hist.yAxis.lim.low,'UserData'));
        set(handles.hist.yAxis.lim.hi,'String',get(previousHandles.hist.yAxis.lim.hi,'String'),...
                                      'UserData',get(previousHandles.hist.yAxis.lim.hi,'UserData'));
        set(handles.hist.noOfBins,'String',get(previousHandles.hist.noOfBins,'String'),...
                                  'UserData',get(previousHandles.hist.noOfBins,'UserData'));
        set(handles.axes.plotMode,'Value',get(previousHandles.axes.plotMode,'Value'),...
                                  'Enable',get(previousHandles.axes.plotMode,'Enable'));
        set(handles.hist.smooth,'value',get(previousHandles.hist.smooth,'Value'));
        set(handles.hist.smoothWidth,'string',get(previousHandles.hist.smoothWidth,'string'),...
                                     'UserData',get(previousHandles.hist.smoothWidth,'UserData'));
    end
    plotModeChange_callback('loadFcnCall');
    helperfcn_plot(~'resetLimits','updatePlotData');
end
set(handles.table,'data',tableData);
helperfcn_tableToolsEnableDisable;
end
function helperfcn_transferFilters
filters = getappdata(handles.figure,'filters');
fcData.nonFilteredData = fcData.data;
filteredCells = false(size(fcData.data,1),1);
if isfield(filters,'time')
    firstCells = filters.time;
    if ~isnan(firstCells)
        filteredCells(1:firstCells) = true;
    end
else
    firstCells = 0;
end

if isfield(filters,'axis')
    for i = 1:size(filters.axis,1)
        axis = strcmp(filters.axis{i,1},fcData.colheaders);
        tempData = fcData.data(:,axis);
        [~,indeces] = sort(tempData);
        indeces(ismember(indeces,1:firstCells)) = [];
        lowCells = ceil(filters.axis{i,2}*(size(fcData.data,1)-firstCells)/100);
        if lowCells>1
            filteredCells(indeces(1:lowCells)) = true;
        end
        highCells = ceil(filters.axis{i,3}*(size(fcData.data,1)-firstCells)/100);
        if highCells>1
            filteredCells(indeces(end:-1:end-highCells+1)) = true;
        end
    end
end
if ~isempty(find(filteredCells,1))
    fcData.data(filteredCells,:) = NaN;
    fcData.dataLog(filteredCells,:) = NaN;
    set(handles.toolbar.filter,'State','on'); 
    set(handles.menu.filter,'Selected','off');
end
end
function helperfcn_calParams(name,operation)
param1 = fcData.data(:,operation{1});

switch operation{3}
         case 'numeric'
             param2 = str2double(operation{4});
         case 'column'
             param2 = fcData.data(:,operation{4});
         case 'statistics'
             switch operation{4}
                 case 'Mean'
                     param2 = nanmean(param1);
                 case 'Median'
                     param2 = nanmedian(param1);
             end
end

switch operation{2}
    case '+'
        fcData.data(:,end+1) = param1+param2;
    case '-'
        fcData.data(:,end+1) = param1-param2;
    case '*'
        fcData.data(:,end+1) = param1.*param2;
    case '/'
        fcData.data(:,end+1) = param1./param2;
    case '^'
        fcData.data(:,end+1) = param1.^param2;
end
fcData.data(isinf(fcData.data(:,end)),end) = NaN;
fcData.colheaders{end+1} = name;       
fcData.dataLog(:,end+1) = trans_Log(fcData.data(:,end));

if ~isappdata(handles.figure,'calParams')
    calParams.name = {name};
    calParams.operation = operation;
else
    calParams = getappdata(handles.figure,'calParams');
    calParams.name(end+1,:) = {name};
    calParams.operation(end+1,:) = operation;
end
setappdata(handles.figure,'calParams',calParams);

set(handles.xAxis.param,'string',fcData.colheaders);
set(handles.yAxis.param,'string',fcData.colheaders);
end
function helperfcn_plot(resetLimits,updatePlotData,zoomingMode)%#ok
if nargin ~= 3
    set(handles.toolbar.zoomIn,'state','off');
    set(handles.toolbar.pan,'state','off');
end

xAxis = get(handles.xAxis.param,'value');
yAxis = get(handles.yAxis.param,'value');

if get(handles.xAxis.trans.log,'Value')
    xTrans = 'Log';
else 
    xTrans = '';
end
if get(handles.yAxis.trans.log,'Value')
    yTrans = 'Log';
else 
    yTrans = '';
end

if updatePlotData %In case it has to update plotData (if it is not only a switch plot mode)   
    plotData = NaN(size(fcData.data,1),2);
    if strcmp(xTrans,'Log')
        plotData(:,1) = fcData.dataLog(:,xAxis);
    else
        plotData(:,1) = fcData.data(:,xAxis);
    end
    if strcmp(yTrans,'Log')
        plotData(:,2) = fcData.dataLog(:,yAxis);
    else
        plotData(:,2) = fcData.data(:,yAxis);
    end
    chosenGates = find(cellfun(@(x) x==1,tableData(:,1)));
    if ~ismember(1,chosenGates)
        subPlot = NaN(size(plotData));
        chosenCells = any(cell2mat(gates.data(chosenGates)),2);
        subPlot(chosenCells,:) = plotData(chosenCells,:);
        plotData = subPlot;
    end
    
    if resetLimits  
        maxX = max(plotData(:,1));
        minX = min(plotData(:,1));
        maxY = max(plotData(:,2));
        minY = min(plotData(:,2));
        maxMinPoints = [maxX,maxY;minX,maxY;maxX,minY;minX,minY];
        set(handles.axes.axes,'XLimMode','auto','YLimMode','auto');
        plot(handles.axes.axes,maxMinPoints(:,1),maxMinPoints(:,2),'.k','MarkerSize',1);
        set(handles.axes.axes,'TickDir','out');
        xLim = get(handles.axes.axes,'XLim');
        yLim = get(handles.axes.axes,'YLim');
        set(handles.axes.axes,'XLimMode','manual','YLimMode','manual');
        if strcmp(xTrans,'Log')
            set(handles.xAxis.lim.low,'string',num2str(10.^xLim(1)),'UserData',10.^xLim(1));
            set(handles.xAxis.lim.hi,'string',num2str(10.^xLim(2)),'UserData',10.^xLim(2));
            set(handles.hist.xAxis.lim.low,'string',num2str(10.^minX),'UserData',10.^minX);
            set(handles.hist.xAxis.lim.hi,'string',num2str(10.^maxX),'UserData',10.^maxX); 
        else
        	set(handles.xAxis.lim.low,'string',num2str(xLim(1)),'UserData',xLim(1));
            set(handles.xAxis.lim.hi,'string',num2str(xLim(2)),'UserData',xLim(2));
            set(handles.hist.xAxis.lim.low,'string',num2str(minX),'UserData',minX);
            set(handles.hist.xAxis.lim.hi,'string',num2str(maxX),'UserData',maxX); 
        end
        if strcmp(yTrans,'Log')
            set(handles.yAxis.lim.low,'string',num2str(10.^yLim(1)),'UserData',10.^yLim(1));
            set(handles.yAxis.lim.hi,'string',num2str(10.^yLim(2)),'UserData',10.^yLim(2));
        else
        	set(handles.yAxis.lim.low,'string',num2str(yLim(1)),'UserData',yLim(1));
            set(handles.yAxis.lim.hi,'string',num2str(yLim(2)),'UserData',yLim(2));
        end
    end
else    %In case it does not has to update plotData (if it is only a switch plot mode)   
    chosenGates = find(cellfun(@(x) x==1,tableData(:,1)));
end  

xLim(1) = get(handles.xAxis.lim.low,'UserData');
xLim(2) = get(handles.xAxis.lim.hi,'UserData'); 
yLim(1) = get(handles.yAxis.lim.low,'UserData');
yLim(2) = get(handles.yAxis.lim.hi,'UserData');

if strcmp(xTrans,'Log')
    xLim(1) = log10(xLim(1));
    xLim(2) = log10(xLim(2));
end
if strcmp(yTrans,'Log')
    yLim(1) = log10(yLim(1));
    yLim(2) = log10(yLim(2));
end
if (get(handles.axes.plotMode,'Value') == 1)
    for i = 1:length(chosenGates)
        if isempty(gates.type{chosenGates(i)})
            plot(handles.axes.axes,plotData(:,1),plotData(:,2),'LineStyle','none','Marker','.','MarkerSize',1,'MarkerEdgeColor','k');
            hold(handles.axes.axes,'on');
            continue;
        end
        plotGate = plotData(gates.data{chosenGates(i)},:);
        
        plot(handles.axes.axes,plotGate(:,1),plotGate(:,2),'LineStyle','none','Marker','.','MarkerSize',1,'MarkerEdgeColor',[gates.color{chosenGates(i)}]);
        hold(handles.axes.axes,'on');
        if strcmp(gates.type{chosenGates(i)},'manual')
            if  gates.axes{chosenGates(i)}(1) == xAxis && ...
                gates.axes{chosenGates(i)}(2) == yAxis && ...
                strcmp(gates.trans{chosenGates(i)}{1},xTrans) && ...
                strcmp(gates.trans{chosenGates(i)}{2},yTrans)
            
                coordinates = gates.coordinates{chosenGates(i)};
                
            elseif gates.axes{chosenGates(i)}(1) == yAxis && ...
                   gates.axes{chosenGates(i)}(2) == xAxis && ...
                   strcmp(gates.trans{chosenGates(i)}{1},yTrans) && ...
                   strcmp(gates.trans{chosenGates(i)}{2},xTrans)
               
            	coordinates = fliplr(gates.coordinates{chosenGates(i)});
            end
            if exist('coordinates','var')
                if strcmp(xTrans,'Log')
                    coordinates(:,1) = log10(coordinates(:,1));
                end
                if strcmp(yTrans,'Log')
                    coordinates(:,2) = log10(coordinates(:,2));
                end
                plot(handles.axes.axes,[coordinates(:,1);coordinates(1,1)],...
                                       [coordinates(:,2);coordinates(1,2)],...
                    'LineStyle','-','Marker','none','LineWidth',3,'Color',[gates.color{chosenGates(i)}]);
                clear('coordinates');
            end
        elseif strcmp(gates.type{chosenGates(i)},'quadrant') 
           if  gates.axes{chosenGates(i)}(1) == xAxis && ...
                   gates.axes{chosenGates(i)}(2) == yAxis && ...
                   strcmp(gates.trans{chosenGates(i)}{1},xTrans) && ...
                   strcmp(gates.trans{chosenGates(i)}{2},yTrans)
               
               coordinates = gates.coordinates{chosenGates(i)};
               
           elseif gates.axes{chosenGates(i)}(1) == yAxis && ...
                   gates.axes{chosenGates(i)}(2) == xAxis && ...
                   strcmp(gates.trans{chosenGates(i)}{1},yTrans) && ...
                   strcmp(gates.trans{chosenGates(i)}{2},xTrans)
               
               coordinates = fliplr(gates.coordinates{chosenGates(i)});
           end
           if exist('coordinates','var')
               if strcmp(xTrans,'Log')
                   coordinates(:,1) = log10(coordinates(:,1));
               end
               if strcmp(yTrans,'Log')
                   coordinates(:,2) = log10(coordinates(:,2));
               end
               lineY = (@(x1,x2,y1,y2,X) ((y1-y2)/(x1-x2))*X + y1-x1*((y1-y2)/(x1-x2)));
               lineX = (@(x1,x2,y1,y2,Y) Y/((y1-y2)/(x1-x2))-y1/((y1-y2)/(x1-x2))+x1);
               xvalLine1 = lineX(coordinates(1,1),coordinates(2,1),...
                   coordinates(1,2),coordinates(2,2),...
                   yLim(2));
               yvalLine2 = lineY(coordinates(1,1),coordinates(3,1),...
                   coordinates(1,2),coordinates(3,2),...
                   xLim(1));
               xvalLine3 = lineX(coordinates(1,1),coordinates(4,1),...
                   coordinates(1,2),coordinates(4,2),...
                   yLim(1));
               yvalLine4 = lineY(coordinates(1,1),coordinates(5,1),...
                   coordinates(1,2),coordinates(5,2),...
                   xLim(2));
               plot(handles.axes.axes,[coordinates(1,1);xvalLine1],...
                                      [coordinates(1,2);yLim(2)],...
                   'LineStyle','-','Marker','none','LineWidth',2,'Color',[0.7 0.7 0.7]);
               plot(handles.axes.axes,[coordinates(1,1);xLim(1)],...
                                      [coordinates(1,2);yvalLine2],...
                   'LineStyle','-','Marker','none','LineWidth',2,'Color',[0.7 0.7 0.7]);
               plot(handles.axes.axes,[coordinates(1,1);xvalLine3],...
                                      [coordinates(1,2);yLim(1)],...
                   'LineStyle','-','Marker','none','LineWidth',2,'Color',[0.7 0.7 0.7]);
               plot(handles.axes.axes,[coordinates(1,1);xLim(2)],...
                                      [coordinates(1,2);yvalLine4],...
                   'LineStyle','-','Marker','none','LineWidth',2,'Color',[0.7 0.7 0.7]);
               clear('coordinates');
           end
        end
    end
    if strcmp(get(handles.toolbar.twoDhist,'State'),'on')
        [nanRows,~] = find(isnan(plotData));
        nonNaNplot = plotData;
        nonNaNplot(unique(nanRows),:) = [];
        if length(nonNaNplot(:,1))>BIGPLOT
            twoDhistParam.n = DEFAULT_BINS_BIG;
        elseif length(nonNaNplot(:,1))>MEDIUMPLOT
            twoDhistParam.n = DEFAULT_BINS_MEDIUM;
        else
            twoDhistParam.n = DEFAULT_BINS_SMALL;
        end
        [twoDhistParam.xi,twoDhistParam.yi,twoDhistParam.z] = histmap(nonNaNplot(:,1),nonNaNplot(:,2),twoDhistParam.n,twoDhistParam.n);
        [X,Y]=meshgrid(twoDhistParam.xi,twoDhistParam.yi);
        [twoDhistParam.c,~] = contour(handles.axes.axes,X,Y,twoDhistParam.z,twoDhistParam.n);
        colorbar('peer',handles.axes.axes,'location','south');
    end

    set(handles.axes.axes,'TickDir','out');
    if strcmp(xTrans,'Log')
        xlabel(handles.axes.axes,[fcData.colheaders{xAxis},' (',xTrans,')']);
    else
        xlabel(handles.axes.axes,fcData.colheaders{xAxis});
    end
    if strcmp(yTrans,'Log')
        ylabel(handles.axes.axes,[fcData.colheaders{yAxis},' (',yTrans,')']);
    else
        ylabel(handles.axes.axes,fcData.colheaders{yAxis});
    end
    set(handles.axes.axes,'Xlim',xLim,'YLim',yLim);

    %Arrange ticks for transformations:
    if strcmp(xTrans,'Log')
        start = ceil(xLim(1));
        ending = floor(xLim(2));
        xTick = start-1:ending+1;
        for j = 1:(length(xTick)-1)
            xg = xTick(j)+log10(linspace(1,10,10));
            xg(any([xg<xLim(1);xg>xLim(2)])) = [];
            xx = reshape([xg;xg;NaN(1,length(xg))],1,length(xg)*3);
            yg = [yLim(1) yLim(1)-0.005*(yLim(2)-yLim(1))];
            yy = repmat([yg NaN],1,length(xg));
            line('Parent',handles.axes.axes,'XData',xx,'YData',yy,'Color','k','Clipping','off');
            yg = [yLim(2) yLim(2)+0.005*(yLim(2)-yLim(1))];
            yy = repmat([yg NaN],1,length(xg));
            line('Parent',handles.axes.axes,'XData',xx,'YData',yy,'Color','k','Clipping','off');
        end
        xTickLabels = cell(size(xTick));
        xTickLabels(all([xTick<=2;xTick>=-2])) = num2cell(10.^xTick(all([xTick<=2;xTick>=-2])));
        xTickLabels(any([xTick>2;xTick<-2])) = arrayfun(@(x) ['10^',num2str(x)],xTick(any([xTick>2;xTick<-2])),'UniformOutput',false);
        set(handles.axes.axes,'XTick',xTick,'XtickLabel',xTickLabels);
    end
    if strcmp(yTrans,'Log')
        start = ceil(yLim(1));
        ending = floor(yLim(2));
        yTick = start-1:ending+1;
        for j = 1:(length(yTick)-1)
            yg = yTick(j)+log10(linspace(1,10,10));
            yg(any([yg<yLim(1);yg>yLim(2)])) = [];
            yy = reshape([yg;yg;NaN(1,length(yg))],1,length(yg)*3);
            xg = [xLim(1) xLim(1)-0.005*(xLim(2)-xLim(1))];
            xx = repmat([xg NaN],1,length(yg));
            line('Parent',handles.axes.axes,'XData',xx,'YData',yy,'Color','k','Clipping','off');
            xg = [xLim(2) xLim(2)+0.005*(xLim(2)-xLim(1))];
            xx = repmat([xg NaN],1,length(yg));
            line('Parent',handles.axes.axes,'XData',xx,'YData',yy,'Color','k','Clipping','off');
        end
        yTickLabels = cell(size(yTick));
        yTickLabels(all([yTick<=2;yTick>=-2])) = num2cell(10.^yTick(all([yTick<=2;yTick>=-2])));
        yTickLabels(any([yTick>2;yTick<-2])) = arrayfun(@(x) ['10^',num2str(x)],yTick(any([yTick>2;yTick<-2])),'UniformOutput',false);
        set(handles.axes.axes,'YTick',yTick,'YtickLabel',yTickLabels);
    end
    hold(handles.axes.axes,'off');
        
elseif (get(handles.axes.plotMode,'Value') == 2)        
        histXlim(1) = get(handles.hist.xAxis.lim.low,'UserData');
        histXlim(2) = get(handles.hist.xAxis.lim.hi,'UserData');
        if strcmp(xTrans,'Log')
            histXlim(1) = log10(histXlim(1));
            histXlim(2) = log10(histXlim(2));
        end
        histYaxis = get(handles.hist.yAxis.param,'value');
        n = get(handles.hist.noOfBins,'UserData');
        scale = linspace(histXlim(1),histXlim(2),n);
        if histXlim(1)<xLim(1)
            index = find(scale>xLim(1),1,'first');
            scale(1:index-1) = [];
        end
        if histXlim(2)>xLim(2)
            index = find(scale<xLim(2),1,'last');
            scale(end:-1:index+1) = []; 
        end

        for i = 1:length(chosenGates)
            if isempty(gates.type{chosenGates(i)})
                if ~get(handles.hist.smooth,'value')
                    [x,xout] = hist(plotData(:,1),scale);
                    if histYaxis == 2
                        x = 100*x./sum(x);
                    end
                    bar(handles.axes.axes,xout,x,'FaceColor','k','BarWidth',1,'LineStyle','none');
                else
                    [x,xout] = ksdensity(plotData(:,1),scale,'width',get(handles.hist.smoothWidth,'UserData')); 
                    area(handles.axes.axes,xout,x,'FaceColor','k');
                end
                hold(handles.axes.axes,'on');
                continue;
            end

            plotGate = plotData(gates.data{chosenGates(i)},1);

            if ~get(handles.hist.smooth,'value')
                [x,xout] = hist(plotGate,scale);
                if histYaxis == 2
                    x = 100*x./sum(x);
                end
                bar(handles.axes.axes,xout,x,'FaceColor',[gates.color{chosenGates(i)}],'BarWidth',1,'LineStyle','none');
            else
                [x,xout] = ksdensity(plotGate,scale,'width',str2double(get(handles.hist.smoothWidth,'string'))); 
                area(handles.axes.axes,xout,x,'FaceColor',[gates.color{chosenGates(i)}]);
            end
            hold(handles.axes.axes,'on');
        end

        if strcmp(xTrans,'Log')
            xlabel(handles.axes.axes,[fcData.colheaders{xAxis},' (',xTrans,')']);
        else
            xlabel(handles.axes.axes,fcData.colheaders{xAxis});
        end
        y = get(handles.hist.yAxis.param,'String');
        ylabel(handles.axes.axes,y(histYaxis,:));
        set(handles.axes.axes,'Xlim',xLim,'YLimMode','manual');
        yLim = get(handles.axes.axes,'YLim');
        set(handles.hist.yAxis.lim.low,'String',num2str(yLim(1)));
        set(handles.hist.yAxis.lim.hi,'String',num2str(yLim(2))); 
        set(handles.axes.axes,'TickDir','out');
        
        %Arrange ticks for transformations:
        if get(handles.xAxis.trans.log,'Value')
            start = ceil(xLim(1));
            ending = floor(xLim(2));
            xTick = start-1:ending+1;
            for j = 1:(length(xTick)-1)
                xg = xTick(j)+log10(linspace(1,10,10));
                xg(any([xg<xLim(1);xg>xLim(2)])) = [];
                xx = reshape([xg;xg;NaN(1,length(xg))],1,length(xg)*3);
                yg = [yLim(1) yLim(1)-0.005*(yLim(2)-yLim(1))];
                yy = repmat([yg NaN],1,length(xg));
                line('Parent',handles.axes.axes,'XData',xx,'YData',yy,'Color','k','Clipping','off');
                yg = [yLim(2) yLim(2)+0.005*(yLim(2)-yLim(1))];
                yy = repmat([yg NaN],1,length(xg));
                line('Parent',handles.axes.axes,'XData',xx,'YData',yy,'Color','k','Clipping','off');
            end
            xTickLabels = cell(size(xTick));
            xTickLabels(all([xTick<=2;xTick>=-2])) = num2cell(10.^xTick(all([xTick<=2;xTick>=-2])));
            xTickLabels(any([xTick>2;xTick<-2])) = arrayfun(@(x) ['10^',num2str(x)],xTick(any([xTick>2;xTick<-2])),'UniformOutput',false);
            set(handles.axes.axes,'XTick',xTick,'XtickLabel',xTickLabels);
        end
        hold(handles.axes.axes,'off');

        nonnanplot = plotData(~isnan(plotData(:,1)),1);
        if ~get(handles.hist.smooth,'value')
            [x,xout] = hist(nonnanplot,scale);
        else
            [x,xout] = ksdensity(nonnanplot,scale,'width',str2double(get(handles.hist.smoothWidth,'string'))); 
        end
        [~,x] = max(x);
        mode1 = xout(x);
        if get(handles.xAxis.trans.log,'Value')
            nonnanplot = 10.^nonnanplot;
            mode1 = 10.^mode1;
        end
        mean1 = mean(nonnanplot);
        std1 = std(nonnanplot);
        var1 = var(nonnanplot);
        coOfvar = std1/mean1;

        %Mean,Median,Mode,Min,Max,STD,Variance,CV,CV^2,Var/Mean,Skewness
        histDataTable = {'Mean','Median','Mode','Min','Max','STD','Variance','CV','CV^2','Var/Mean','Skewness';...
                     num2str(mean1),num2str(median(nonnanplot)),num2str(mode1),...
                     num2str(min(nonnanplot)),num2str(max(nonnanplot)),...
                     num2str(std1),num2str(var1),...
                     num2str(coOfvar),num2str(coOfvar^2),...
                     num2str(var1/mean1),num2str(skewness(nonnanplot))};
        set(handles.upPanel.histData,'Data',histDataTable,'RowName',[],'ColumnName',[]);
end
end
function helperfcn_tableToolsEnableDisable
chosenGates = find(cellfun(@(x) x==1,tableData(:,1)));
chosenGates(chosenGates==1) = [];    
if length(gates.tag)>1
    set([handles.tableTools.selectAll,handles.tableTools.selectNone],'enable','on');
    if length(chosenGates)+1 == length(gates.tag) && tableData{1,1}
        set(handles.tableTools.selectAll,'Value',1,'Enable','inactive');
    else
        set(handles.tableTools.selectAll,'Value',0,'Enable','on');
    end
else
    set([handles.tableTools.selectAll,handles.tableTools.selectNone],'enable','off');
end
if any(ismember({'manual','quadrant','hist'},gates.type))
    set([handles.tableTools.editGate,handles.menu.editGate],'Enable','on');
else
    set([handles.tableTools.editGate,handles.menu.editGate],'Enable','off');
end
if length(chosenGates)>1
    set([handles.tableTools.clearGate,handles.menu.clearGate,handles.tableTools.dupliGate,...
        handles.menu.dupliGate,handles.tableTools.saveGate,handles.menu.saveGate,...
        handles.tableTools.saveGateReads,handles.menu.saveGateReads,...
        handles.tableTools.inverseGate,handles.menu.inverseGate,handles.tableTools.unionGate,...
        handles.menu.unionGate,handles.tableTools.intersectGate,handles.menu.intersectGate,...
        handles.tableTools.XORGate,handles.menu.XORGate...
        ],'Enable','on');
    set([handles.tableTools.moveDown,handles.tableTools.moveUp],'Enable','off');

elseif length(chosenGates)==1
        set([handles.tableTools.clearGate,handles.menu.clearGate,handles.tableTools.dupliGate,...
            handles.menu.dupliGate,handles.tableTools.saveGate,handles.menu.saveGate,...
            handles.tableTools.saveGateReads,handles.menu.saveGateReads,...
            handles.tableTools.inverseGate,handles.menu.inverseGate],'Enable','on');
        set([handles.tableTools.unionGate,handles.menu.unionGate,handles.tableTools.intersectGate,...
            handles.menu.intersectGate,handles.tableTools.XORGate,handles.menu.XORGate...
            ],'Enable','off');
        if chosenGates == 2 && length(gates.tag)==2
            set([handles.tableTools.moveDown,handles.tableTools.moveUp],'Enable','off');
        elseif chosenGates == 2 && length(gates.tag) > 2
            set(handles.tableTools.moveDown,'Enable','on');
            set(handles.tableTools.moveUp,'Enable','off');            
        elseif chosenGates == length(gates.tag)
            set(handles.tableTools.moveDown,'Enable','off');
            set(handles.tableTools.moveUp,'Enable','on');
        else
            set([handles.tableTools.moveDown,handles.tableTools.moveUp],'Enable','on');            
        end
else
    set([handles.tableTools.moveDown,handles.tableTools.moveUp,...
    handles.tableTools.clearGate,handles.menu.clearGate,handles.tableTools.dupliGate,...
    handles.menu.dupliGate,handles.tableTools.saveGate,handles.menu.saveGate,...
    handles.tableTools.saveGateReads,handles.menu.saveGateReads,...
    handles.tableTools.inverseGate,handles.menu.inverseGate,...
    handles.tableTools.unionGate,handles.menu.unionGate,handles.tableTools.intersectGate,...
    handles.menu.intersectGate,handles.tableTools.XORGate,handles.menu.XORGate...
        ],'Enable','off');
end    
end
end