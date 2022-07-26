function varargout = semiAutoGate(mainGUIhandles,plotData,DEFAULT_GATECOLOR)

handles.figure = figure('visible','off','MenuBar','None','NumberTitle','off',...
                        'Toolbar','none','HandleVisibility','callback',...
                        'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                        'name',['Semi-autoumatic gating - ',get(mainGUIhandles.figure,'name')]);
[nanRows,~] = find(isnan(plotData));
plotDataNonNaN = plotData;
plotDataNonNaN(nanRows,:) = [];
twoDhistParam.isolineNo = 0;
twoDhistParam.xBinNo = 0;
twoDhistParam.yBinNo = 0;
twoDhistParam.xi = 0;
twoDhistParam.yi = 0;
twoDhistParam.z = 0;
twoDhistParam.c = 0;

radial.indeces = zeros(length(plotData),1);
radial.dists = zeros(length(plotData),1);
radial.areas = zeros(length(plotData),1);
radial.cellDens.n = 0;
radial.cellDens.x = 0;
radial.colors = 0;
isolines.cells = [];
isolines.polygons = [];
isolines.areas = [];
isolines.center = [NaN NaN];
isolines.partialLastIsoline = NaN;
isolines.colors = [];
isolines.cellDens.n = 0;
isolines.cellDens.x = 0;
isolines.originalCellDens.n = 0;
isolines.originalCellDens.x = 0; 

plotHandles.isolines.cellGroups = [];
plotHandles.isolines.partialLastIsoline = [];
plotHandles.radial.chosenCells = [];
plotHandles.allCells = [];
plotHandles.contour = [];
plotHandles.colorbar = [];
plotHandles.cellDens.isolines.plot = [];
plotHandles.cellDens.isolines.pointer = [];
plotHandles.cellDens.radial.plot = [];
plotHandles.cellDens.radial.pointer = [];

manualCenterInteractivePoint = 0;
manualCenterPos = NaN;

BIGPLOT = 70000;
MEDIUMPLOT = 10000;
DEFAULTBINS_BIG = 100;
DEFAULTBINS_MEDUIM = 50;
DEFAULTBINS_SMALL = 10;

tableData = get(mainGUIhandles.table,'Data');
xLimit = get(mainGUIhandles.axes.axes,'Xlim');
yLimit = get(mainGUIhandles.axes.axes,'Ylim');

buildFcn
callbackAssignFcn
initialFcn
varargout{1} = 0;
uiwait(handles.figure);

function buildFcn
icons = load('icons.mat'); icons = icons.icons;
handles.toolbar.toolbar = uitoolbar('Parent',handles.figure,'HandleVisibility','callback');
handles.toolbar.twoDhist = uitoggletool('Parent',handles.toolbar.toolbar,'HandleVisibility','callback',...
                                        'TooltipString','Density color map','CData',icons.twoDhist,'Separator','on');
handles.toolbar.zoomIn = uitoggletool('Parent',handles.toolbar.toolbar,'HandleVisibility','callback',...
                                        'TooltipString','Zoom In','CData',icons.zoomIn,'Separator','on');
handles.toolbar.zoomOut = uipushtool('Parent',handles.toolbar.toolbar,'HandleVisibility','callback',...
                                        'TooltipString','Zoom Out','CData',icons.zoomOut);
handles.toolbar.pan = uitoggletool('Parent',handles.toolbar.toolbar,'HandleVisibility','callback',...
                                        'TooltipString','Pan','CData',icons.hand);                                    
handles.bigGrid = uiextras.VBox('Parent',handles.figure,'Padding',10,'Spacing',10);
handles.axes.Panel = uiextras.HBox('Parent',double(handles.bigGrid));
handles.axes.axes1PanelBig = uiextras.VBox('Parent',double(handles.axes.Panel));
handles.axes.axes1Warn = uicontrol('Parent',double(handles.axes.axes1PanelBig),'Style','text','String',...
                                  'Press Enter to finish, Esc to cancel','FontSize',20,'Enable','off');
handles.axes.axes1Panel = uipanel('Parent',double(handles.axes.axes1PanelBig),'BorderType','none');
handles.axes.axes1 = axes('Parent',double(handles.axes.axes1Panel),'HandleVisibility','callback');
handles.axes.axes1ColorBar = colorbar('peer',handles.axes.axes1,'location','south');
set(handles.axes.axes1PanelBig,'Sizes',[0 -1]);
handles.axes.axes2Panel = uiextras.CardPanel('Parent',double(handles.axes.Panel));
handles.axes.axes2radial = axes('Parent',double(handles.axes.axes2Panel),'HandleVisibility','callback');
handles.axes.axes2isolines = axes('Parent',double(handles.axes.axes2Panel),'HandleVisibility','callback');
handles.belowaxesPanel1 = uiextras.HBox('Parent',double(handles.bigGrid));
handles.expansMode.panelBig = uiextras.Panel('Parent',double(handles.belowaxesPanel1),'Title','Mode of expansion:','BorderType','etchedout');
handles.expansMode.panel = uiextras.HBox('Parent',double(handles.expansMode.panelBig));
handles.expansMode.radial = uicontrol('Style','radiobutton','Parent',double(handles.expansMode.panel),'String','Radial','HandleVisibility','callback');
handles.expansMode.isolines = uicontrol('Style','radiobutton','Parent',double(handles.expansMode.panel),'String','isoliness','HandleVisibility','callback');
handles.level.text = uicontrol('Style','text','Parent',double(handles.belowaxesPanel1),'String','        : ','HorizontalAlignment','right','HandleVisibility','callback');
handles.level.number = uicontrol('Style','edit','Parent',double(handles.belowaxesPanel1),'String',' ','Backgroundcolor','white','HandleVisibility','callback');
handles.level.totalText = uicontrol('Style','text','Parent',double(handles.belowaxesPanel1),'String',' /        ','HorizontalAlignment','left','HandleVisibility','callback');
handles.AreaOrCellNo.text = uicontrol('Style','text','Parent',double(handles.belowaxesPanel1),'String','Area: ','HorizontalAlignment','right','HandleVisibility','callback');
handles.AreaOrCellNo.box = uicontrol('Style','edit','Parent',double(handles.belowaxesPanel1),'String',' ','Backgroundcolor','white','HandleVisibility','callback','Enable','off');
handles.center.text = uicontrol('Style','text','Parent',double(handles.belowaxesPanel1),'String','Center: ','HorizontalAlignment','right','HandleVisibility','callback');
handles.center.panel = uiextras.VBox('Parent',double(handles.belowaxesPanel1));
handles.center.panelX = uiextras.HBox('Parent',double(handles.center.panel));
handles.center.panelY = uiextras.HBox('Parent',double(handles.center.panel));
handles.center.Xtext = uicontrol('Style','text','Parent',double(handles.center.panelX),'String','        ','HandleVisibility','callback');
handles.center.X = uicontrol('Style','edit','Parent',double(handles.center.panelX),'String',' ','Backgroundcolor','white','HandleVisibility','callback');
handles.center.Ytext = uicontrol('Style','text','Parent',double(handles.center.panelY),'String','        ','HandleVisibility','callback');
handles.center.Y = uicontrol('Style','edit','Parent',double(handles.center.panelY),'String',' ','Backgroundcolor','white','HandleVisibility','callback');
handles.center.manual = uicontrol('Style','pushbutton','Parent',double(handles.belowaxesPanel1),'ToolTipString','Move center manually','CData',icons.handCenter,'HandleVisibility','callback');
handles.changeIsolineParams = uicontrol('Style','pushbutton','Parent',double(handles.belowaxesPanel1),'ToolTipString','Change isolines parameters ','Cdata',icons.changeIsolineParams,'HandleVisibility','callback');
handles.reset = uicontrol('Style','pushbutton','Parent',double(handles.belowaxesPanel1),'ToolTipString','Reset to defaults','CData',icons.zero,'HandleVisibility','callback');
handles.slider = uicontrol('Style','slider','Parent',double(handles.bigGrid),'Backgroundcolor',[0.8039 0.8784 0.9686],'HandleVisibility','callback');
handles.belowaxesPanel2 = uiextras.HBox('Parent',double(handles.bigGrid));
handles.belowaxesPanel2GAP = uipanel('Parent',double(handles.belowaxesPanel2),'HandleVisibility','callback','BorderType','none');
handles.color = uicontrol('Style','pushbutton','Parent',double(handles.belowaxesPanel2),'String','Choose color','HandleVisibility','callback');
handles.name = uicontrol('Style','edit','Parent',double(handles.belowaxesPanel2),'String',' ','BackgroundColor','White','HandleVisibility','callback');
handles.save = uicontrol('Style','pushbutton','Parent',double(handles.belowaxesPanel2),'ToolTipString','Save gate','CData',icons.saveGate,'HandleVisibility','callback');
handles.cancel = uicontrol('Style','pushbutton','Parent',double(handles.belowaxesPanel2),'ToolTipString','Cancel','CData',icons.closeWin,'HandleVisibility','callback');

set(handles.bigGrid,'Sizes',[-1,35,22,25]);
set(handles.belowaxesPanel1,'Sizes',[150 -1 -1 -1 -1 -1 -1 200 22 22 22]);
set(handles.belowaxesPanel2,'Sizes',[-1 70 80 22 22],'Spacing',10);
end
function callbackAssignFcn
set([handles.toolbar.zoomIn,handles.toolbar.pan],...
                                'ClickedCallback',      @toolbar_zoomInPan_clickedcallback,...
                                'OnCallback',           @toolbar_zoomInPan_ONcallback,...
                                'OffCallback',          @toolbar_zoomInPan_OFFcallback);
set(handles.toolbar.zoomOut,    'ClickedCallback',      @toolbar_zoomOut_callback);
set(handles.slider,             'Callback',             @changeLevel_callback);
set(handles.level.number,       'Callback',             @changeLevel_callback);
set(handles.toolbar.twoDhist,   'ClickedCallback',      @toolbar_twoDhist_clickedcallback,...
                                'OnCallback',           @toolbar_twoDhist_ONcallback,...
                                'OffCallback',          @toolbar_twoDhist_OFFcallback);
set(handles.AreaOrCellNo.box,   'Callback',             @changeNoOfCells_callback);
set([handles.expansMode.radial,handles.expansMode.isolines],...
                                'Callback',             @changeExpansMode_callback);
set([handles.center.X,handles.center.Y,handles.center.manual],...
                                'Callback',             @changeCenter_callback);
set(handles.reset,              'Callback',             @reset_callback);
set(handles.changeIsolineParams,'Callback',             @changeIsolineParams_callback);
set(handles.color,              'Callback',             @color_callback);
set(handles.name,               'Callback',             @name_callback,...
                                'ButtonDownFcn',        @name_buttonDownCallback);
set(handles.save,               'Callback',             @save_callback);
set(handles.cancel,             'Callback',             @cancel_callback);
end
function initialFcn
xAxisLabel = get(get(mainGUIhandles.axes.axes,'Xlabel'),'String');
yAxisLabel = get(get(mainGUIhandles.axes.axes,'Ylabel'),'String');
set(handles.center.Xtext,'String',[xAxisLabel,' :']);
set(handles.center.Ytext,'String',[yAxisLabel,' :']);

set(handles.name,'String','Choose name','Foregroundcolor',[0.5 0.5 0.5],'FontAngle','italic','Enable','inactive');    
set(handles.color,'BackgroundColor',DEFAULT_GATECOLOR);
set(handles.expansMode.radial,'Value',1,'Enable','inactive');
if length(plotDataNonNaN(:,1)) > BIGPLOT
    twoDhistParam.isolineNo = DEFAULTBINS_BIG;
    twoDhistParam.xBinNo = DEFAULTBINS_BIG;
    twoDhistParam.yBinNo = DEFAULTBINS_BIG;
elseif length(plotDataNonNaN(:,1)) > MEDIUMPLOT
    twoDhistParam.isolineNo = DEFAULTBINS_MEDUIM;
    twoDhistParam.xBinNo = DEFAULTBINS_MEDUIM;
    twoDhistParam.yBinNo = DEFAULTBINS_MEDUIM;
else
    twoDhistParam.isolineNo = DEFAULTBINS_SMALL;
    twoDhistParam.xBinNo = DEFAULTBINS_SMALL;
    twoDhistParam.yBinNo = DEFAULTBINS_SMALL;
end
[twoDhistParam.xi,twoDhistParam.yi,twoDhistParam.z] = histmap(plotDataNonNaN(:,1),plotDataNonNaN(:,2),twoDhistParam.xBinNo,twoDhistParam.yBinNo);
twoDhistParam.c = contourc(twoDhistParam.xi,twoDhistParam.yi,twoDhistParam.z,twoDhistParam.isolineNo);    
[maxValInEachColumn,maxValIndexRow] = max(twoDhistParam.z);
[~,maxValIndexCol] = max(maxValInEachColumn);
maxValIndexRow = maxValIndexRow(maxValIndexCol);
center = [twoDhistParam.xi(maxValIndexCol),twoDhistParam.yi(maxValIndexRow)];
if get(mainGUIhandles.xAxis.trans.log,'Value')
	set(handles.center.X,'string',num2str(10.^center(1)),'userData',10.^center(1));
else
    set(handles.center.X,'string',num2str(center(1)),'userData',center(1));
end
if get(mainGUIhandles.yAxis.trans.log,'Value')
	set(handles.center.Y,'string',num2str(10.^center(2)),'userData',10.^center(2));
else
    set(handles.center.Y,'string',num2str(center(2)),'userData',center(2));
end
%Calculate distance of cells and sort them by distance for radial
%expansion mode
radial.dists = sqrt((plotData(:,1)-center(1)).^2+(plotData(:,2)-center(2)).^2);
[radial.dists,radial.indeces] = sort(radial.dists);
radial.areas = pi*radial.dists.^2;

helperfcn_makeCalOfIsolines;
isolines.originalCellDens.n = isolines.noOfCells./isolines.areas;
isolines.originalCellDens.x = 1:length(isolines.areas);

helperfcn_initialplot;
helperfcn_changeMode;
end

function toolbar_zoomInPan_ONcallback(hObject,eventdata)%#ok
switch hObject
    case handles.toolbar.zoomIn
        zoom;
    case handles.toolbar.pan
        pan;
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
    case handles.toolbar.zoomIn
    	set(handles.toolbar.pan,'state','off');
    case handles.toolbar.pan
    	set(handles.toolbar.zoomIn,'state','off');  
end
end
function toolbar_zoomOut_callback(hObject,eventdata)%#ok
zoom out
set(handles.toolbar.zoomIn,'State','off');
set(handles.toolbar.pan,'State','off');
end
function toolbar_twoDhist_clickedcallback(hObject,eventdata)%#ok
set(handles.toolbar.pan,'state','off');
set(handles.toolbar.zoomIn,'state','off');    
end
function toolbar_twoDhist_ONcallback(hObject,eventdata)%#ok
set(plotHandles.contour,'Visible','on');
drawnow;
helperfcn_arrangeColorbarTicks;
end
function toolbar_twoDhist_OFFcallback(hObject,eventdata)%#ok
set(plotHandles.contour,'Visible','off');
drawnow;
helperfcn_arrangeColorbarTicks;
end

function changeNoOfCells_callback(hObject,eventdata)%#ok
noOfCells = str2double(get(hObject,'String'));
if isnan(noOfCells) || noOfCells > length(plotData) || noOfCells < 1 
    set(hObject,'String',num2str(get(hObject,'UserData')));
    return;
elseif noOfCells < isolines.noOfCells(1)
    delete(plotHandles.isolines.partialLastIsoline);
    isolines.partialLastIsoline = NaN;
    plotHandles.isolines.partialLastIsoline = [];
    set(hObject,'String',num2str(isolines.noOfCells(1)),'UserData',isolines.noOfCells(1));
    set(handles.slider,'Value',1,'BackgroundColor',[0.8039 0.8784 0.9686]);
    set(handles.level.number,'String','1','ForegroundColor',[0 0 0]);
    set(plotHandles.isolines.cellGroups(1),'MarkerEdgeColor',isolines.colors(1,:));
    set(plotHandles.isolines.cellGroups(2:end),'MarkerEdgeColor',[0.9 0.9 0.9]);
    set(plotHandles.cellDens.isolines.pointer,'XData',1,...
        'YData',isolines.cellDens.n(1),'MarkerFaceColor',[0.8039 0.8784 0.9686]);
else
    set(hObject,'String',num2str(noOfCells),'UserData',noOfCells);
    helperfcn_makeCalNoOfCells;
end
end
function changeLevel_callback(hObject,eventdata)%#ok
delete(plotHandles.isolines.partialLastIsoline);
isolines.partialLastIsoline = NaN;
plotHandles.isolines.partialLastIsoline = [];    
switch hObject
    case handles.slider
        level = round(get(hObject,'Value'));
        set(hObject,'Value',level,'Backgroundcolor',[0.8039 0.8784 0.9686]);
        previousLevel = floor(str2double(get(handles.level.number,'String')));
        set(handles.level.number,'String',num2str(level),'Foregroundcolor',[0 0 0]);
    case handles.level.number
        level = str2double(get(hObject,'String'));
        previousLevel = get(handles.slider,'Value');
        if isnan(level) || level < 1 || level == previousLevel || round(level) ~= level ||... 
            (get(handles.expansMode.radial,'Value') && level > size(plotData,1)) ||...
            (get(handles.expansMode.isolines,'Value') && level > size(isolines.cells,2)) 
            set(hObject,'String',num2str(previousLevel));
            return;
        else
            set(hObject,'String',num2str(level),'Foregroundcolor',[0 0 0]);
            set(handles.slider,'Value',level,'Backgroundcolor',[0.8039 0.8784 0.9686]);
        end
end
if get(handles.expansMode.radial,'Value')
    set(plotHandles.radial.chosenCells,'XData',plotData(radial.indeces(1:level),1),...
                                       'YData',plotData(radial.indeces(1:level),2));
    set(handles.AreaOrCellNo.box,'String',num2str(radial.areas(level)),'UserData',[]);
    cellDistIndex = find(radial.cellDens.x<=radial.dists(level),1,'Last');
    set(plotHandles.cellDens.radial.pointer,'XData',cellDistIndex,'YData',radial.cellDens.n(cellDistIndex));
else
    if level > previousLevel
        set(plotHandles.isolines.cellGroups(previousLevel:level),{'MarkerEdgeColor'},mat2cell(isolines.colors(previousLevel:level,:),ones(level-previousLevel+1,1),3));
    else
        set(plotHandles.isolines.cellGroups(level+1:previousLevel),'MarkerEdgeColor',[0.9 0.9 0.9]);
    end
    set(handles.AreaOrCellNo.box,'String',num2str(isolines.noOfCells(level)),'UserData',isolines.noOfCells(level));
    set(plotHandles.cellDens.isolines.pointer,'XData',level,...
        'YData',isolines.cellDens.n(level),'MarkerFaceColor',[0.8039 0.8784 0.9686]);
end
end
function changeExpansMode_callback(hObject,eventdata)%#ok
set(hObject,'Enable','inactive');
switch hObject
    case handles.expansMode.radial
        set(handles.expansMode.isolines,'Value',0,'Enable','on');
    case handles.expansMode.isolines
        set(handles.expansMode.radial,'Value',0,'Enable','on');
end
helperfcn_changeMode;
end
function changeIsolineParams_callback(hObject,eventdata)%#ok
xAxis = get(get(mainGUIhandles.axes.axes,'Xlabel'),'String');
yAxis = get(get(mainGUIhandles.axes.axes,'Ylabel'),'String');
output = isolineParam_dlg(xAxis,yAxis,twoDhistParam.xBinNo,twoDhistParam.yBinNo,twoDhistParam.isolineNo);    
if ~isequal(output,0)
    twoDhistParam.xBinNo = output(1);
    twoDhistParam.yBinNo = output(2);
    twoDhistParam.isolineNo = output(3);
    [twoDhistParam.xi,twoDhistParam.yi,twoDhistParam.z] = histmap(plotDataNonNaN(:,1),plotDataNonNaN(:,2),twoDhistParam.xBinNo,twoDhistParam.yBinNo);
    twoDhistParam.c = contourc(twoDhistParam.xi,twoDhistParam.yi,twoDhistParam.z,twoDhistParam.isolineNo);   
    [maxValInEachColumn,maxValIndexRow] = max(twoDhistParam.z);
    [~,maxValIndexCol] = max(maxValInEachColumn);
    maxValIndexRow = maxValIndexRow(maxValIndexCol);
    center = [twoDhistParam.xi(maxValIndexCol),twoDhistParam.yi(maxValIndexRow)];
    if get(mainGUIhandles.xAxis.trans.log,'Value')
        set(handles.center.X,'string',num2str(10.^center(1)),'userData',10.^center(1));
    else
        set(handles.center.X,'string',num2str(center(1)),'userData',center(1));
    end
    if get(mainGUIhandles.yAxis.trans.log,'Value')
        set(handles.center.Y,'string',num2str(10.^center(2)),'userData',10.^center(2));
    else
        set(handles.center.Y,'string',num2str(center(2)),'userData',center(2));
    end
    %Calculate distance of cells and sort them by distance for radial
    %expansion mode
    radial.dists = sqrt((plotData(:,1)-center(1)).^2+(plotData(:,2)-center(2)).^2);
    [radial.dists,radial.indeces] = sort(radial.dists);
    radial.areas = pi*radial.dists.^2;
    %Make the calculation of how many cells inside each isoline for
    %isolines expansion mode
    helperfcn_makeCalOfIsolines;
    isolines.originalCellDens.n = isolines.noOfCells./isolines.areas;
    isolines.originalCellDens.x = 1:length(isolines.areas);
    helperfcn_initialplot;
    helperfcn_changeMode;
end
end
function changeCenter_callback(hObject,eventdata)%#ok
switch hObject
    case {handles.center.X,handles.center.Y}
        newValue = str2double(get(hObject,'String'));
        oldValue = get(hObject,'UserData');
        if isnan(newValue) || newValue == oldValue || ...
           (hObject == handles.center.X && get(mainGUIhandles.xAxis.trans.log,'Value') && newValue < 0) || ...
           (hObject == handles.center.Y && get(mainGUIhandles.yAxis.trans.log,'Value') && newValue < 0)
            
            set(hObject,'String',num2str(oldValue));
            return;
        else
            set(hObject,'String',num2str(newValue),'UserData',newValue);
        end
    case handles.center.manual
        manualChangeCenter;
        helperfcn_initialplot;
        if isnan(manualCenterPos)
            set(handles.center.X,'String',num2str(get(handles.center.X,'UserData')));
            set(handles.center.Y,'String',num2str(get(handles.center.Y,'UserData')));
        	return;
        else
            if ((~get(mainGUIhandles.xAxis.trans.log,'Value') && manualCenterPos(1) == get(handles.center.X,'UserData')) && ...
               (~get(mainGUIhandles.yAxis.trans.log,'Value') && manualCenterPos(2) == get(handles.center.Y,'UserData'))) || ...
               ((get(mainGUIhandles.xAxis.trans.log,'Value') && manualCenterPos(1) == log10(get(handles.center.X,'UserData'))) && ...
               (get(mainGUIhandles.yAxis.trans.log,'Value') && manualCenterPos(2) == log10(get(handles.center.Y,'UserData'))))
                return;
            else
                if get(mainGUIhandles.xAxis.trans.log,'Value')
                	set(handles.center.X,'UserData',10.^manualCenterPos(1));
                else
                    set(handles.center.X,'UserData',manualCenterPos(1));
                end
                if get(mainGUIhandles.yAxis.trans.log,'Value')
                	set(handles.center.Y,'UserData',10.^manualCenterPos(2));          
                else
                	set(handles.center.Y,'UserData',manualCenterPos(2));          
                end
                manualCenterPos = NaN;
            end
        end
end
center = [get(handles.center.X,'UserData'),get(handles.center.Y,'UserData')];
if get(mainGUIhandles.xAxis.trans.log,'Value')
    center(1) = log10(center(1));
end
if get(mainGUIhandles.yAxis.trans.log,'Value')
	center(2) = log10(center(2));
end
%Calculate distance of cells and sort them by distance for radial
%expansion mode
radial.dists = sqrt((plotData(:,1)-center(1)).^2+(plotData(:,2)-center(2)).^2);
[radial.dists,radial.indeces] = sort(radial.dists);
radial.areas = pi*radial.dists.^2;
%Make the calculation of how many cells inside each isoline for
%isolines expansion mode
helperfcn_makeCalOfIsolines;
helperfcn_initialplot;
helperfcn_changeMode;
end
function manualChangeCenter
cancel = 0;
set([handles.toolbar.zoomIn,handles.toolbar.pan],'state','off','enable','off');
set([handles.toolbar.zoomOut,handles.slider,handles.expansMode.radial,...
    handles.expansMode.isolines,handles.level.number,handles.AreaOrCellNo.box,...
    handles.center.X,handles.center.Y,handles.center.manual,handles.reset,...
    handles.changeIsolineParams,handles.toolbar.twoDhist],'enable','off');
set(handles.axes.axes1PanelBig,'Sizes',[30 -1]);
set(handles.figure,'KeyPressFcn',@cancelCenter);
center = [get(handles.center.X,'UserData'),get(handles.center.Y,'UserData')];
if get(mainGUIhandles.xAxis.trans.log,'Value')
    center(1) = log10(center(1));
end
if get(mainGUIhandles.yAxis.trans.log,'Value')
    center(2) = log10(center(2));
end
originalXLim = get(handles.axes.axes1,'XLim');
originalYLim = get(handles.axes.axes1,'YLim');
if center(1)<originalXLim(1)
    originalXLim = [center(1)-center(1)*0.01,originalXLim(2)];
elseif center(1)>originalXLim(2)
    originalXLim = [originalXLim(1),center(1)+center(1)*0.01];
elseif center(2)<originalYLim(1)
    originalYLim = [center(2)-center(2)*0.01 originalYLim(2)];
elseif center(2)>originalYLim(2)
    originalYLim = [originalYLim(1) center(2)+center(2)*0.01];
end
set(handles.axes.axes1,'XLim',originalXLim,'YLim',originalYLim);

x0 = originalXLim(1);
xLength = originalXLim(2)-originalXLim(1);
y0 = originalYLim(1);
yLength = originalYLim(2)-originalYLim(1);

xLabel = get(get(handles.axes.axes1,'XLabel'),'String');
yLabel = get(get(handles.axes.axes1,'YLabel'),'String');
xTick = get(handles.axes.axes1,'XTick');
xTick = (xTick-x0)./xLength;
yTick = get(handles.axes.axes1,'YTick');
yTick = (yTick-y0)./yLength;
xTicklabel = get(handles.axes.axes1,'XTickLabel');
yTicklabel = get(handles.axes.axes1,'YTickLabel');

frame = getframe(handles.axes.axes1);
frame.cdata(:,:,1) = frame.cdata(end:-1:1,:,1);
frame.cdata(:,:,2) = frame.cdata(end:-1:1,:,2);
frame.cdata(:,:,3) = frame.cdata(end:-1:1,:,3);

h = image(frame.cdata,'parent',handles.axes.axes1);
set(handles.axes.axes1,'TickDir','out','YDir','normal');
xLim = get(handles.axes.axes1,'XLim');
yLim = get(handles.axes.axes1,'YLim');
xx0 = xLim(1);
xxLength = xLim(2)-xLim(1);
yy0 = yLim(1);
yyLength = yLim(2)-yLim(1);
xTick = xx0+xTick.*xxLength;
yTick = yy0+yTick.*yyLength;
set(handles.axes.axes1,'XTick',xTick,'YTick',yTick,'XTickLabel',xTicklabel,'YTickLabel',yTicklabel);
xlabel(handles.axes.axes1,xLabel);
ylabel(handles.axes.axes1,yLabel);

centerInPlot(1) = xx0+((center(1)-x0)./xLength).*xxLength;
centerInPlot(2) = yy0+((center(2)-y0)./yLength).*yyLength;

fcn = makeConstrainToRectFcn('impoint',xLim,yLim);
manualCenterInteractivePoint = impoint(handles.axes.axes1,centerInPlot,'PositionConstraintFcn',fcn);
setColor(manualCenterInteractivePoint,[0 1 0]);
addNewPositionCallback(manualCenterInteractivePoint,@newPos);
pos = getPosition(manualCenterInteractivePoint);
pos(:,1) = x0+((pos(:,1)-xx0)./xxLength).*xLength;
pos(:,2) = y0+((pos(:,2)-yy0)./yyLength).*yLength;
manualCenterPos = pos;
waitfor(h);
set([handles.toolbar.zoomIn,handles.toolbar.pan,handles.toolbar.twoDhist,...
     handles.toolbar.zoomOut,handles.slider,handles.expansMode.radial,...
     handles.expansMode.isolines,handles.level.number,...
     handles.center.X,handles.center.Y,handles.center.manual,handles.reset,...
     handles.changeIsolineParams],'enable','on');
if get(handles.expansMode.isolines,'Value')
    set(handles.AreaOrCellNo.box,'enable','on');
    set(handles.expansMode.isolines,'enable','inactive');
else
    set(handles.expansMode.radial,'enable','inactive');
end
set(handles.figure,'Keypressfcn',[]);
set(handles.axes.axes1PanelBig,'Sizes',[0 -1]);
if cancel
	manualCenterPos = NaN;
end
function newPos(pos)
    pos(:,1) = x0+((pos(:,1)-xx0)./xxLength).*xLength;
    pos(:,2) = y0+((pos(:,2)-yy0)./yyLength).*yLength;
    if get(mainGUIhandles.xAxis.trans.log,'Value')
        set(handles.center.X,'string',10.^pos(:,1),'UserData',10.^pos(:,1));
    else
        set(handles.center.X,'string',pos(:,1),'UserData',pos(:,1));
    end
    if get(mainGUIhandles.yAxis.trans.log,'Value')
        set(handles.center.Y,'string',10.^pos(:,2),'UserData',10.^pos(:,2));
    else
        set(handles.center.Y,'string',pos(:,2),'UserData',pos(:,2));
    end
    manualCenterPos = pos;
end
function cancelCenter(src,event)%#ok
if strcmp(event.Key,'escape') || strcmp(event.Key,'return')
    delete(manualCenterInteractivePoint);
    delete(h);
    if strcmp(event.Key,'escape')
        cancel = 1;
    end
end
end
end
function reset_callback(hObject,eventdata)%#ok
set(handles.toolbar.twoDhist,'State','off');
makeNewCal = 0;
if length(plotDataNonNaN(:,1)) > BIGPLOT
    isolineNo = DEFAULTBINS_BIG;
    xbins = DEFAULTBINS_BIG;
    ybins = DEFAULTBINS_BIG;
elseif length(plotDataNonNaN(:,1))> MEDIUMPLOT
    isolineNo = DEFAULTBINS_MEDUIM;
    xbins = DEFAULTBINS_MEDUIM;
    ybins = DEFAULTBINS_MEDUIM;
else
    isolineNo = DEFAULTBINS_SMALL;
    xbins = DEFAULTBINS_SMALL;
    ybins = DEFAULTBINS_SMALL;
end    

if isolineNo ~= twoDhistParam.isolineNo	|| ...
   xbins ~= twoDhistParam.xBinNo        	|| ...
   ybins ~= twoDhistParam.yBinNo 
    makeNewCal = 1;
    twoDhistParam.isolineNo = isolineNo;       
    twoDhistParam.xBinNo = xbins;               
    twoDhistParam.yBinNo = ybins;
    [twoDhistParam.xi,twoDhistParam.yi,twoDhistParam.z] = histmap(plotDataNonNaN(:,1),plotDataNonNaN(:,2),twoDhistParam.xBinNo,twoDhistParam.yBinNo);
    twoDhistParam.c = contourc(twoDhistParam.xi,twoDhistParam.yi,twoDhistParam.z,twoDhistParam.isolineNo);   
end
    
[maxValInEachColumn,maxValIndexRow] = max(twoDhistParam.z);
[~,maxValIndexCol] = max(maxValInEachColumn);
maxValIndexRow = maxValIndexRow(maxValIndexCol);
center = [twoDhistParam.xi(maxValIndexCol),twoDhistParam.yi(maxValIndexRow)];

if (~get(mainGUIhandles.xAxis.trans.log,'Value') && center(1) ~= get(handles.center.X,'UserData')) || ...
   (~get(mainGUIhandles.yAxis.trans.log,'Value') && center(2) ~= get(handles.center.Y,'UserData')) || ...
   (get(mainGUIhandles.xAxis.trans.log,'Value') && center(1) ~= log10(get(handles.center.X,'UserData'))) || ...
   (get(mainGUIhandles.yAxis.trans.log,'Value') && center(2) ~= log10(get(handles.center.Y,'UserData'))) || ...
   makeNewCal

    if get(mainGUIhandles.xAxis.trans.log,'Value')
        set(handles.center.X,'string',10.^center(1),'UserData',10.^center(1));
    else
        set(handles.center.X,'string',center(1),'userData',center(1));
    end
    if get(mainGUIhandles.yAxis.trans.log,'Value')
        set(handles.center.Y,'string',10.^center(2),'UserData',10.^center(2));
    else
        set(handles.center.Y,'string',center(2),'userData',center(2));
    end
    %Calculate distance of cells and sort them by distance for radial
    %expansion mode
    radial.dists = sqrt((plotData(:,1)-center(1)).^2+(plotData(:,2)-center(2)).^2);
    [radial.dists,radial.indeces] = sort(radial.dists);
    radial.areas = pi*radial.dists.^2;
    %Make the calculation of how many cells inside each isoline for
    %isolines expansion mode
    helperfcn_makeCalOfIsolines;
    helperfcn_initialplot;
    helperfcn_changeMode;
else
    return;
end
end

function color_callback(hObject,eventdata)%#ok
color = uisetcolor;
if ~isequal(color,0)
    set(hObject,'BackgroundColor',color);
end
end
function name_callback(hObject,eventdata)%#ok
if isempty(get(hObject,'String'))
    set(hObject,'String','Choose name','foregroundColor',[0.5 0.5 0.5],'FontAngle','italic','Enable','inactive');
end
end
function name_buttonDownCallback(hObject,eventdata)%#ok
if isequal(get(hObject,'Enable'),'inactive')
    set(hObject,'String','','fontAngle','normal','ForegroundColor',[0 0 0],'Enable','on');
    uicontrol(hObject);
end
end
function save_callback(hObject,eventdata)%#ok
name = get(handles.name,'String');
if isempty(name) || strcmp(name,'Choose name')
    name = ['Gate',num2str(size(tableData,1))];
end
level = str2double(get(handles.level.number,'String'));
if get(handles.expansMode.radial,'Value')
    data = false(size(plotData,1),1);
    data(radial.indeces(1:level)) = true;
else
    level = floor(level);
    if isnan(isolines.partialLastIsoline)
        data = logical(sum(isolines.cells(:,1:level),2));
    else
        data = logical(sum([isolines.cells(:,1:level),isolines.partialLastIsoline],2));
    end
end
color = get(handles.color,'BackgroundColor');
center = [get(handles.center.X,'UserData'),get(handles.center.Y,'UserData')];
if get(mainGUIhandles.xAxis.trans.log,'Value')
    center(1) = log10(center(1));
end
if get(mainGUIhandles.yAxis.trans.log,'Value')
    center(2) = log10(center(2));    
end
varargout{1} = {name,data,color,center};
uiresume(handles.figure);
delete(handles.figure);    
end
function cancel_callback(hObject,eventdata)%#ok
uiresume(handles.figure);
delete(handles.figure);    
end

function helperfcn_initialplot
cla(handles.axes.axes1,'reset');
cla(handles.axes.axes2isolines,'reset');
cla(handles.axes.axes2radial,'reset');
xlabel(handles.axes.axes1,get(get(mainGUIhandles.axes.axes,'Xlabel'),'String'));
ylabel(handles.axes.axes1,get(get(mainGUIhandles.axes.axes,'Ylabel'),'String'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1. Calculate cell densities:
%in radial mode:
[radial.cellDens.n,radial.cellDens.x] = hist(radial.dists,linspace(0,max(radial.dists),twoDhistParam.isolineNo));
radial.cellDens.n = cumsum(radial.cellDens.n);
radial.cellDens.n = radial.cellDens.n./(pi.*(radial.cellDens.x.^2));
radial.cellDens.n = [radial.cellDens.n(2:end),0];
%in isolines mode:
isolines.cellDens.n = isolines.noOfCells./isolines.areas;
isolines.cellDens.x = 1:length(isolines.areas);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%2. Plot on the right axes:
plotHandles.cellDens.radial.plot = line('Parent',handles.axes.axes2radial,...
                                        'XData',1:length(radial.cellDens.x),'YData',radial.cellDens.n,...
                                        'Marker','.','Color','b');
hold(handles.axes.axes2radial,'on');
plotHandles.cellDens.isolines.plot = line('Parent',handles.axes.axes2isolines,...
                                        'Xdata',1:length(isolines.cellDens.x),'YData',isolines.cellDens.n,...
                                        'Marker','.','Color','b');
hold(handles.axes.axes2isolines,'on');
plotHandles.cellDens.radial.pointer = line('Parent',handles.axes.axes2radial,...
                                'Xdata',1,'YData',radial.cellDens.n(1),...
                                'Marker','o','LineStyle','none','LineWidth',3,...
                                'MarkerFaceColor',[0.8039 0.8784 0.9686],...
                                'MarkerEdgeColor','k','MarkerSize',10);
plotHandles.cellDens.isolines.pointer = line('Parent',handles.axes.axes2isolines,...
                                'XData',1,'Ydata',isolines.cellDens.n(1),...
                                'Marker','o','LineStyle','none','LineWidth',3,...
                                'MarkerFaceColor',[0.8039 0.8784 0.9686],...
                                'MarkerEdgeColor','k','MarkerSize',10);
inds = (1:10:101)-1;
inds(1) = 1;
tickLabels = pi.*(radial.cellDens.x(inds).^2);
tickLabelsStr = cell(size(tickLabels));
for i = 1:length(tickLabels)
    tickLabelsStr{i} = num2str(tickLabels(i),4);
end
set(handles.axes.axes2radial,'XLim',[1 length(radial.cellDens.x)],'TickDir','out','XTick',inds,'XTickLabel',tickLabelsStr);
xlabel(handles.axes.axes2radial,'Area (binned)');
ylabel(handles.axes.axes2radial,'Cell density');
set(handles.axes.axes2isolines,'TickDir','out','XLim',[1 length(isolines.cellDens.x)]);
xlabel(handles.axes.axes2isolines,'Isoline number');
ylabel(handles.axes.axes2isolines,'Cell density');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3. Plot on the left axes:
%All the cells in grey (background):
plotHandles.allCells = ...
    line(plotData(:,1),plotData(:,2),'Parent',handles.axes.axes1,'LineStyle','none',...
        'Marker','.','MarkerSize',1,'MarkerEdgeColor',[0.9 0.9 0.9]);
hold(handles.axes.axes1,'on');
%The chosen cells in radial mode:
plotHandles.radial.chosenCells = ...
    line(plotData(radial.indeces(1),1),plotData(radial.indeces(1),2),'Parent',handles.axes.axes1,'LineStyle','none',...
            'Marker','.','MarkerSize',1,'MarkerEdgeColor',get(handles.color,'Backgroundcolor'));
%The cell groups in isolines mode:
for i = length(plotHandles.isolines.cellGroups):-1:2
    plotHandles.isolines.cellGroups(i) = line(plotData(isolines.cells(:,i),1),plotData(isolines.cells(:,i),2),...
                                            'Parent',handles.axes.axes1,'LineStyle','none','Marker','.',...
                                            'MarkerSize',1,'MarkerEdgeColor',[0.9 0.9 0.9]);
end   
plotHandles.isolines.cellGroups(1) = line(plotData(isolines.cells(:,1),1),plotData(isolines.cells(:,1),2),...
                             'Parent',handles.axes.axes1,'LineStyle','none','Marker','.',...
                             'MarkerSize',1,'MarkerEdgeColor',isolines.colors(1,:));
%Contour plot:
[X,Y] = meshgrid(twoDhistParam.xi,twoDhistParam.yi);
[~,plotHandles.contour] = contour(handles.axes.axes1,X,Y,twoDhistParam.z,twoDhistParam.isolineNo,'Visible','off');
plotHandles.colorbar = colorbar('peer',handles.axes.axes1,'location','south');
%arrange colorbar ticks:
helperfcn_arrangeColorbarTicks;

%Arrange ticks for transformations:
if get(mainGUIhandles.xAxis.trans.log,'Value')
    start = ceil(xLimit(1));
    ending = floor(xLimit(2));
    xTick = start-1:ending+1;
    for j = 1:(length(xTick)-1)
        xg = xTick(j)+log10(linspace(1,10,10));
        xg(any([xg<xLimit(1);xg>xLimit(2)])) = [];
        xx = reshape([xg;xg;NaN(1,length(xg))],1,length(xg)*3);
        yg = [yLimit(1) yLimit(1)-0.005*(yLimit(2)-yLimit(1))];
        yy = repmat([yg NaN],1,length(xg));
        line('Parent',handles.axes.axes1,'XData',xx,'YData',yy,'Color','k','Clipping','off');
        yg = [yLimit(2) yLimit(2)+0.005*(yLimit(2)-yLimit(1))];
        yy = repmat([yg NaN],1,length(xg));
        line('Parent',handles.axes.axes1,'XData',xx,'YData',yy,'Color','k','Clipping','off');
    end
    xTickLabels = cell(size(xTick));
    xTickLabels(all([xTick<=2;xTick>=-2])) = num2cell(10.^xTick(all([xTick<=2;xTick>=-2])));
    xTickLabels(any([xTick>2;xTick<-2])) = arrayfun(@(x) ['10^',num2str(x)],xTick(any([xTick>2;xTick<-2])),'UniformOutput',false);
    set(handles.axes.axes1,'XTick',xTick,'XtickLabel',xTickLabels);
end
if get(mainGUIhandles.yAxis.trans.log,'Value')
    start = ceil(yLimit(1));
    ending = floor(yLimit(2));
    yTick = start-1:ending+1;
    for j = 1:(length(yTick)-1)
        yg = yTick(j)+log10(linspace(1,10,10));
        yg(any([yg<yLimit(1);yg>yLimit(2)])) = [];
        yy = reshape([yg;yg;NaN(1,length(yg))],1,length(yg)*3);
        xg = [xLimit(1) xLimit(1)-0.005*(xLimit(2)-xLimit(1))];
        xx = repmat([xg NaN],1,length(yg));
        line('Parent',handles.axes.axes1,'XData',xx,'YData',yy,'Color','k','Clipping','off');
        xg = [xLimit(2) xLimit(2)+0.005*(xLimit(2)-xLimit(1))];
        xx = repmat([xg NaN],1,length(yg));
        line('Parent',handles.axes.axes1,'XData',xx,'YData',yy,'Color','k','Clipping','off');
    end
    yTickLabels = cell(size(yTick));
    yTickLabels(all([yTick<=2;yTick>=-2])) = num2cell(10.^yTick(all([yTick<=2;yTick>=-2])));
    yTickLabels(any([yTick>2;yTick<-2])) = arrayfun(@(x) ['10^',num2str(x)],yTick(any([yTick>2;yTick<-2])),'UniformOutput',false);
    set(handles.axes.axes1,'YTick',yTick,'YtickLabel',yTickLabels);
end
set([handles.axes.axes1,handles.axes.axes2radial,handles.axes.axes2isolines],'NextPlot','replace');
set(handles.axes.axes1,'Xlim',xLimit,'Ylim',yLimit,'TickDir','out','Box','on');
end
function helperfcn_arrangeColorbarTicks
axes1ColorBarXLim = get(plotHandles.colorbar,'XLim');
noOfDigits = numel(num2str(round(max(isolines.originalCellDens.n))))-1;
xTicksLabels = fliplr(round(linspace(1,length(isolines.originalCellDens.n),10)));
xTicksLabels = sort(isolines.originalCellDens.n(xTicksLabels));
if noOfDigits>3
    xTicksLabels = xTicksLabels./10^(noOfDigits);
    xTicksLabels = arrayfun(@(x) sprintf('%11.3g',x),xTicksLabels,'UniformOutput',false);
    xTicksLabels{end} = [xTicksLabels{end},' *10^',num2str(noOfDigits)];
else
    xTicksLabels = arrayfun(@(x) sprintf('%11.3g',x),xTicksLabels,'UniformOutput',false);
end
set(plotHandles.colorbar,'XTick',linspace(axes1ColorBarXLim(1),axes1ColorBarXLim(2),10),...
                                'XTickLabel',xTicksLabels);
end

function helperfcn_changeMode
set(handles.level.number,'String','1');
delete(plotHandles.isolines.partialLastIsoline);
isolines.partialLastIsoline = NaN;
plotHandles.isolines.partialLastIsoline = [];
set(handles.level.number,'String','1','ForegroundColor',[0 0 0]);
if get(handles.expansMode.radial,'Value')
    set(handles.slider,'Value',1,'Min',1,'Max',size(plotData,1),'SliderStep',[0.01 0.10],'BackgroundColor',[0.8039 0.8784 0.9686]);
    set(handles.level.text,'String','No. of cells:');
    set(handles.level.totalText,'String',[' / ',num2str(size(plotData,1))]);
    set(handles.AreaOrCellNo.text,'String','Area:');
    set(handles.AreaOrCellNo.box,'String',num2str(radial.areas(1)),'UserData',[],'Enable','off');
    set(plotHandles.radial.chosenCells,'XData',plotData(radial.indeces(1),1),...
                                       'YData',plotData(radial.indeces(1),2),'Visible','on');
    set(plotHandles.cellDens.radial.pointer,'XData',1,'YData',radial.cellDens.n(1));
    set(plotHandles.isolines.cellGroups,'Visible','off');
    set(handles.axes.axes2Panel,'SelectedChild',1);
else
    set(handles.slider,'Value',1,'Min',1,'Max',size(isolines.cells,2),'Sliderstep',([1 1]/(size(isolines.cells,2)-1)),'BackgroundColor',[0.8039 0.8784 0.9686]);
    set(handles.level.text,'String','Isoline No.:');
    set(handles.level.totalText,'String',[' / ',num2str(size(isolines.cells,2))]);
    set(handles.AreaOrCellNo.text,'String','Cell No.:');
    set(handles.AreaOrCellNo.box,'String',num2str(isolines.noOfCells(1)),...
                                 'UserData',isolines.noOfCells(1),'Enable','on');
    set(plotHandles.isolines.cellGroups(1),'MarkerEdgeColor',isolines.colors(1,:),'Visible','on');
    set(plotHandles.isolines.cellGroups(2:end),'MarkerEdgeColor',[0.9 0.9 0.9],'Visible','on');
    set(plotHandles.cellDens.isolines.pointer,'XData',1,...
        'YData',isolines.cellDens.n(1),'MarkerFaceColor',[0.8039 0.8784 0.9686]);
    set(plotHandles.radial.chosenCells,'Visible','off');
    set(handles.axes.axes2Panel,'SelectedChild',2);
end
end
function helperfcn_makeCalOfIsolines
center = [get(handles.center.X,'UserData'),get(handles.center.Y,'UserData')];
if get(mainGUIhandles.xAxis.trans.log,'Value')
    center(1) = log10(center(1));
end
if get(mainGUIhandles.yAxis.trans.log,'Value')
	center(2) = log10(center(2));
end
%Make the calculation of how many cells inside each isoline for isolines expansion mode
isolines.polygons = contourMat2contour3DMat(twoDhistParam.c);
output = calCellsInIsolines('semiauto',plotData,isolines.polygons,center);
[isolines.polygons,isolines.cells,isolines.areas] = deal(output{:});
isolines.cells(:,end+1) = false;
isolines.cells(~any(isolines.cells(:,1:end-1),2),end) = true;
isolines.polygons(:,end+1,:) = NaN(size(isolines.polygons,1),1,2);
isolines.areas(end+1) = Inf;
isolines.noOfCells = zeros(1,size(isolines.cells,2));
for i = 1:size(isolines.cells,2)
    isolines.noOfCells(i) = length(find(any(isolines.cells(:,1:i),2)));
end
isolines.colors = jet(size(isolines.cells,2));
isolines.colors(1:end,:) = isolines.colors(end:-1:1,:);
plotHandles.isolines.cellGroups = zeros(size(isolines.cells,2),1);
end
function helperfcn_makeCalNoOfCells
%make the calculation when No. of cells is entered manually by user, finds
%the isoline in which no. of cells is reached, and then include cells from
%the next isoline, by their distance from the previous isoline polygon
noOfCells = str2double(get(handles.AreaOrCellNo.box,'string'));
lastIsoline = find(isolines.noOfCells < noOfCells,1,'last');
previousIsoline = floor(str2double(get(handles.level.number,'String')));
delete(plotHandles.isolines.partialLastIsoline);
isolines.partialLastIsoline = NaN;
plotHandles.isolines.partialLastIsoline = [];

distanceFromGoal = isolines.noOfCells(lastIsoline+1) - noOfCells;    
if distanceFromGoal > 0
    cellsInNextIsoline = find(isolines.cells(:,lastIsoline+1));
	dists = zeros(length(cellsInNextIsoline),1);
    lastPolygonLength = isolines.polygons(1,lastIsoline,2);
    for i = 1:length(cellsInNextIsoline)
        [dists(i),~,~] = p_poly_dist(plotData(cellsInNextIsoline(i),1),plotData(cellsInNextIsoline(i),2),...
                                    isolines.polygons(2:lastPolygonLength+1,lastIsoline,1),...
                                    isolines.polygons(2:lastPolygonLength+1,lastIsoline,2));
    end
	[~,indeces] = sort(dists,'descend');
    isolines.partialLastIsoline = isolines.cells(:,lastIsoline+1);
    isolines.partialLastIsoline(cellsInNextIsoline(indeces(1:distanceFromGoal))) = false;    
    plotHandles.isolines.partialLastIsoline = line(plotData(isolines.partialLastIsoline,1),plotData(isolines.partialLastIsoline,2),...
                                                'Parent',handles.axes.axes1,'LineStyle','none','Marker','.',...
                                                'MarkerSize',1,'MarkerEdgeColor',[1 0 1]);
    set(handles.slider,'Value',lastIsoline + ...
        ((length(cellsInNextIsoline)-distanceFromGoal)/length(cellsInNextIsoline))...
        ,'BackgroundColor',[1 0.8 1]);
    set(handles.level.number,'String',num2str(lastIsoline + ...
        ((length(cellsInNextIsoline)-distanceFromGoal)/length(cellsInNextIsoline))),...
        'Foregroundcolor',[1 0 0]);
    set(plotHandles.cellDens.isolines.pointer,'XData',lastIsoline,'YData',isolines.cellDens.n(lastIsoline),'MarkerFaceColor',[1 0.8 1]);
else
    lastIsoline = lastIsoline+1;
    set(handles.slider,'Value',lastIsoline,'BackgroundColor',[0.8039 0.8784 0.9686]);
    set(handles.level.number,'String',num2str(lastIsoline),'Foregroundcolor',[0 0 0]);
    set(plotHandles.cellDens.isolines.pointer,'XData',lastIsoline,'YData',isolines.cellDens.n(lastIsoline),'MarkerFaceColor',[0.8039 0.8784 0.9686]);
end

if lastIsoline>previousIsoline
    set(plotHandles.isolines.cellGroups(previousIsoline:lastIsoline),{'MarkerEdgeColor'},...
        mat2cell(isolines.colors(previousIsoline:lastIsoline,:),ones(lastIsoline-previousIsoline+1,1),3));
elseif lastIsoline<previousIsoline
    set(plotHandles.isolines.cellGroups(lastIsoline+1:previousIsoline),'MarkerEdgeColor',...
        [0.9 0.9 0.9]);
end
end
end