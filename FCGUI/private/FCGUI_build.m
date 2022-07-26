function handles = FCGUI_build
handles.figure = figure('visible','off','MenuBar','None','NumberTitle','off',...
                        'Toolbar','none','HandleVisibility','callback',...
                        'Color',get(0,'defaultuicontrolbackgroundcolor'));
%---------Toolbar
handles.toolbar.toolbar = uitoolbar('Parent',handles.figure,'HandleVisibility','callback');
icons = load('icons.mat'); icons = icons.icons;
handles.toolbar.open  =  uipushtool(...
                        'TooltipString','Open FC data file','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.open,'Separator','on');
handles.toolbar.openNewWin  =  uipushtool(...
                        'TooltipString','Open FC data file in a new window','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.openNewWin);
handles.toolbar.duplicateWin  =  uipushtool(...
                        'TooltipString','Open current file in a new window','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.duplicateWin);
handles.toolbar.openLastNewWin  =  uipushtool(...
                        'TooltipString','Open previous file in folder in a new window','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.openLastNewWin,'Enable','off',...
                        'Separator','on');
handles.toolbar.openLast  =  uipushtool(...
                        'TooltipString','Open previous file in folder','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.openLast,'Enable','off');
handles.toolbar.openNext  =  uipushtool(...
                        'TooltipString','Open next file in folder','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.openNext,'Enable','off');
handles.toolbar.openNextNewWin  =  uipushtool(...
                        'TooltipString','Open next file in folder in a new window','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.openNextNewWin,'Enable','off');
handles.toolbar.filter  =  uitoggletool(...
                        'TooltipString','Filter according to time or extreme values','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.filter,'Enable','off',...
                        'Separator','on');
handles.toolbar.calAxis  =  uipushtool(...
                        'TooltipString','Math operations on parameters','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.calculator,'Enable','off',...
                        'Separator','on');
handles.toolbar.resetView  =  uipushtool(...
                        'TooltipString','Reset View','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.zero,'Enable','off',...
                        'Separator','on');
handles.toolbar.twoDhist  =  uitoggletool(...
                        'TooltipString','Density color map','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.twoDhist,'Enable','off');
handles.toolbar.zoomIn  =  uitoggletool('TooltipString','Zoom in','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.zoomIn,'Enable','off');
handles.toolbar.zoomOut  =  uipushtool('TooltipString','Zoom out','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.zoomOut,'Enable','off');
handles.toolbar.pan  =  uitoggletool('TooltipString','Pan','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.hand,'Enable','off');
handles.toolbar.rectGate  =  uipushtool('TooltipString','Rectangular Gate','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.rectGate,'Enable','off',...
                        'Separator','on');
handles.toolbar.freeShapeGate  =  uipushtool(...
                        'TooltipString','Free Shape Gate','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.freeShapeGate,'Enable','off');
handles.toolbar.polyGate  =  uipushtool(...
                        'TooltipString','Polygon Gate','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.polygonGate,'Enable','off');
handles.toolbar.quadrantGate  =  uipushtool(...
                        'TooltipString','Quadrants Gate','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.quartersGate,'Enable','off',...
                        'Separator','on');
handles.toolbar.histGate  =  uipushtool(...
                        'TooltipString','Interval Gate','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.intervalGate,'Enable','off');
handles.toolbar.autoGate  =  uipushtool(...
                        'TooltipString','Automatic gating (N cells from center)','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.autoGate,'Enable','off',...
                        'Separator','on');
handles.toolbar.semiAutoGate  =  uipushtool(...
                        'TooltipString','Semi-automatic gating','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.semiAutoGate,'Enable','off');
handles.toolbar.exportFig  =  uipushtool(...
                        'TooltipString','Export to Matlab figure','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.undock,'Enable','off',...
                        'Separator','on');                    
handles.toolbar.dotPlotMultiPlot  =  uipushtool(...
                        'TooltipString','Create a multiple plot figure of scatter plots','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.multiPlot);
handles.toolbar.histMultiPlot  =  uipushtool(...
                        'TooltipString','Create a multiple plot figure of histograms','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.histMultiplot);
handles.toolbar.newWin  =  uipushtool(...
                        'TooltipString','New Window','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.newWin,'Separator','on');
handles.toolbar.closeWin  =  uipushtool(...
                        'TooltipString','Close window','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.closeWin);
handles.toolbar.help  =  uipushtool(...
                        'TooltipString','Help','Parent',handles.toolbar.toolbar,...
                        'HandleVisibility','callback','CData',icons.help,'Separator','on');

handles.menu.file = uimenu('Label','File','parent',handles.figure,'HandleVisibility','callback');
handles.menu.display = uimenu('Label','Display','parent',handles.figure,'enable','off','HandleVisibility','callback');
handles.menu.gates = uimenu('Label','Gates','parent',handles.figure,'Enable','off','HandleVisibility','callback');
handles.menu.tools = uimenu('Label','Tools','parent',handles.figure,'HandleVisibility','callback');

handles.menu.open = uimenu('Label','Open',...
	'Accelerator','O','Parent',handles.menu.file);
handles.menu.openNewWin = uimenu('Label','Open in a new window',...
                        'Parent',handles.menu.file,'HandleVisibility','callback');
handles.menu.duplicateWin = uimenu('Label','Duplicate window',...
	'Accelerator','D','Parent',handles.menu.file,'HandleVisibility','callback');
handles.menu.openLastNewWin = uimenu('Label','Open previous file in a new window',...
	'Accelerator','.','Parent',handles.menu.file,'enable','off','HandleVisibility','callback');
handles.menu.openLast = uimenu('Label','Open previous file',...
                        'Parent',handles.menu.file,'enable','off','HandleVisibility','callback');
handles.menu.openNext = uimenu('Label','Open next file',...
                        'Parent',handles.menu.file,'enable','off','HandleVisibility','callback');
handles.menu.openNextNewWin = uimenu('Label','Open next file in a new window',...
   'Accelerator',',','Parent',handles.menu.file,'enable','off','HandleVisibility','callback');
handles.menu.newWin = uimenu('Label','New window',...
	'Accelerator','N','Parent',handles.menu.file,'HandleVisibility','callback');
handles.menu.closeWin = uimenu('Label','Close',...
	'Accelerator','X','Parent',handles.menu.file,'Separator','on','HandleVisibility','callback');
handles.menu.resetView = uimenu('Label','Reset view',...
	'Accelerator','R','Parent',handles.menu.display,'HandleVisibility','callback');
handles.menu.twoDhist = uimenu('Label','Density color map',...
	'Accelerator','Q','Parent',handles.menu.display,'HandleVisibility','callback');
handles.menu.zoomIn = uimenu('Label','Zoom In',...
    'Accelerator','=','Parent',handles.menu.display,'HandleVisibility','callback');
handles.menu.zoomOut = uimenu('Label','Zoom Out',...
    'Accelerator','-','Parent',handles.menu.display,'HandleVisibility','callback');
handles.menu.pan = uimenu('Label','Pan',...
    'Accelerator','P','Parent',handles.menu.display,'HandleVisibility','callback');
handles.menu.plotMode = uimenu('Label','Change plot mode',...
    'Accelerator','M','Parent',handles.menu.display,'HandleVisibility','callback');
handles.menu.rectGate = uimenu('Label','New rectangular gate',...
                        'Parent',handles.menu.gates,'HandleVisibility','callback');
handles.menu.freeShapeGate = uimenu('Label','New free shape gate',...
                        'Parent',handles.menu.gates,'HandleVisibility','callback');
handles.menu.polyGate = uimenu('Label','New polygon gate',...
                        'Parent',handles.menu.gates,'HandleVisibility','callback');
handles.menu.quadrantGate = uimenu('Label','New quadrant gate',...
                        'Parent',handles.menu.gates,'HandleVisibility','callback');
handles.menu.histGate = uimenu('Label','New histogram gate',...
                        'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.autoGate = uimenu('Label','New automatic gate',...
                        'Parent',handles.menu.gates,'HandleVisibility','callback');
handles.menu.semiAutoGate = uimenu('Label','New semi-automatic gate',...
                        'Parent',handles.menu.gates,'HandleVisibility','callback');
handles.menu.operation = uimenu('Label','Operations on gates:',...
                        'Parent',handles.menu.gates,'Separator','on','Enable','off','HandleVisibility','callback');
handles.menu.editGate = uimenu('Label','Edit gate',...
                       'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.dupliGate = uimenu('Label','Duplicate gate',...
                       'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.clearGate = uimenu('Label','Delete gate',...
                        'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.loadGate = uimenu('Label','Load gate coordinates',...
                        'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.saveGate = uimenu('Label','Save gate coordinates',...
                        'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.saveGateReads = uimenu('Label','Save gate reads',...
                        'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.logicalOperation = uimenu('Label','Logical operations:',...
                        'Parent',handles.menu.gates,'Separator','on','Enable','off','HandleVisibility','callback');
handles.menu.inverseGate = uimenu('Label','New inverse gate',...
                        'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.unionGate = uimenu('Label','New union gate',...
                        'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.intersectGate = uimenu('Label','New intersection gate',...
                        'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.XORGate = uimenu('Label','New XOR gate',...
                        'Parent',handles.menu.gates,'Enable','off','HandleVisibility','callback');
handles.menu.filter = uimenu('Label','Create filter',...
                        'Parent',handles.menu.tools,'Enable','off','HandleVisibility','callback');
handles.menu.calAxis = uimenu('Label','Math operation on parameters',...
                        'Parent',handles.menu.tools,'Enable','off','HandleVisibility','callback');
handles.menu.exportFig =  uimenu('Label','Export to Matlab figure','Enable','off',...
                        'Parent',handles.menu.tools,'Separator','on','HandleVisibility','callback');
handles.menu.dotPlotMultiPlot =  uimenu('Label','Create a multiple plot figure of scatter plots',...
                        'Parent',handles.menu.tools,'HandleVisibility','callback');
handles.menu.histMultiPlot =  uimenu('Label','Create a multiple plot figure of histograms',...
                        'Parent',handles.menu.tools);     
handles.menu.help =  uimenu('Label','Help',...
	'Accelerator','H','Parent',handles.menu.tools,'Separator','on','HandleVisibility','callback');                        
                    
%---------GUI window
handles.bigGrid = uix.HBoxFlex('Parent',handles.figure,'Padding',5,'Spacing',3);
handles.leftColumn = uix.VBoxFlex('Parent',handles.bigGrid,'Padding',5,'Spacing',3);
handles.rightColumn = uix.VBoxFlex('Parent',handles.bigGrid,'Padding',5,'Spacing',3);

%---------Left Column
%Table and table tools
handles.table = uitable('Parent',handles.leftColumn,'HandleVisibility','callback','Visible','off',...
    'ColumnEditable',logical([1 1 0 0 0 0 0 0 0 0 0]),...
    'ColumnFormat',{'logical','char','char','numeric','numeric','char','char','char','char','char','char'},...
    'ColumnName',{'','Name','Color','No. of cells','% of total','% of parent(s)','Parent(s)','Type','X,Y','Transformation X,Y','Coordinates'},...
    'ColumnWidth',{20,'auto',33,'auto',60,90,'auto',100,'auto','auto',500},...
    'RowName',[]);
handles.tableTools.panel = uix.VBox('Parent',handles.leftColumn,'Visible','off');
handles.tableTools.row1 = uix.HBox('Parent',handles.tableTools.panel);
handles.tableTools.row2 = uix.HButtonBox('Parent',handles.tableTools.panel,'ButtonSize',[22 22]);
handles.tableTools.row3 = uix.Panel('Parent',handles.tableTools.panel,'Title','Logical Operators:','BorderType','etchedout');
set(handles.tableTools.panel,'Heights',[22 22 44],'Spacing',3);
handles.tableTools.selectAll = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row1),'String','Select All','HandleVisibility','callback');
handles.tableTools.selectNone = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row1),'String','Select None','HandleVisibility','callback');
handles.tableTools.moveDown = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row1),'CData',icons.down,'TooltipString','Move gate down','HandleVisibility','callback');
handles.tableTools.moveUp = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row1),'CData',icons.up,'TooltipString','Move gate up','HandleVisibility','callback');
set(handles.tableTools.row1,'Widths',[-1 -1 22 22],'Spacing',5,'MinimumWidths',[70 70 22 22]);
handles.tableTools.dupliGate = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row2),'CData',icons.duplicateGate,'TooltipString','Duplicate selected gate(s)','HandleVisibility','callback');
handles.tableTools.editGate = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row2),'CData',icons.editGate,'TooltipString','Edit gate coordinates (only manual, quadrant and hist types)','HandleVisibility','callback');
handles.tableTools.clearGate = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row2),'CData',icons.clearGate,'TooltipString','Delete selected gate(s)','HandleVisibility','callback');
handles.tableTools.loadGate = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row2),'CData',icons.loadGate,'TooltipString','Load gate coordinates','HandleVisibility','callback');
handles.tableTools.saveGate = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row2),'CData',icons.saveGate,'TooltipString','Save selected gate(s) coordinates','HandleVisibility','callback');
handles.tableTools.saveGateReads = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row2),'CData',icons.saveGateReads,'TooltipString','Save selected gate(s) reads','HandleVisibility','callback');
handles.tableTools.row3low = uix.HButtonBox('Parent',handles.tableTools.row3,'Padding',3,'ButtonSize',[22 22]);
handles.tableTools.inverseGate = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row3low),'CData',icons.complement,'TooltipString','Complement (NOT)','HandleVisibility','callback');
handles.tableTools.unionGate = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row3low),'CData',icons.union,'TooltipString','Union (OR)','HandleVisibility','callback');
handles.tableTools.intersectGate = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row3low),'CData',icons.intersection,'TooltipString','Intersection (AND)','HandleVisibility','callback');
handles.tableTools.XORGate = uicontrol('Style','pushbutton','Parent',double(handles.tableTools.row3low),'CData',icons.xor,'TooltipString','XOR','HandleVisibility','callback');
%X axis properties
handles.xAxis.panelBig = uix.Panel('Parent',handles.leftColumn,'Visible','off','Title','X Axis:','BorderType','etchedout');
handles.xAxis.panel = uix.VBox('Parent',handles.xAxis.panelBig,'Padding',5);
handles.xAxis.param = uicontrol('Style','Popupmenu','Parent',double(handles.xAxis.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.xAxis.trans.panelBig = uix.Panel('Parent',double(handles.xAxis.panel),'Title','Transformation:','BorderType','etchedout');
handles.xAxis.trans.panel = uix.HBox('Parent',double(handles.xAxis.trans.panelBig));
handles.xAxis.trans.log = uicontrol('Style','radiobutton','Parent',double(handles.xAxis.trans.panel),'String','Log','HandleVisibility','callback');
handles.xAxis.trans.none = uicontrol('Style','radiobutton','Parent',double(handles.xAxis.trans.panel),'String','None','HandleVisibility','callback');
set(handles.xAxis.trans.panel,'Widths',[-1 -1]);
handles.xAxis.lim.panel = uix.HBox('Parent',double(handles.xAxis.panel));
handles.xAxis.lim.text = uicontrol('Style','Text','Parent',double(handles.xAxis.lim.panel),'String','Limits:','HandleVisibility','callback');
handles.xAxis.lim.low = uicontrol('Style','edit','Parent',double(handles.xAxis.lim.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.xAxis.lim.hi = uicontrol('Style','edit','Parent',double(handles.xAxis.lim.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
set(handles.xAxis.lim.panel,'Widths',[50 -1 -1],'Spacing',5);
set(handles.xAxis.panel,'Heights',[20 40 20],'Spacing',5);
%Switch axes
handles.switchAxes = uicontrol('Parent',double(handles.leftColumn),'Visible','off','HandleVisibility','Callback','Cdata',icons.up_down);
%Y axis / histogram properties:
handles.yAxisORhistPanel = uix.CardPanel('Parent',handles.leftColumn,'Visible','off');
%Y axis properties
handles.yAxis.panelBig = uix.Panel('Parent',handles.yAxisORhistPanel,'Title','Y Axis:','BorderType','etchedout');
handles.yAxis.panel = uix.VBox('Parent',handles.yAxis.panelBig,'Padding',5);
handles.yAxis.param = uicontrol('Style','Popupmenu','Parent',double(handles.yAxis.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.yAxis.trans.panelBig = uix.Panel('Parent',double(handles.yAxis.panel),'Title','Transformation:','BorderType','etchedout');
handles.yAxis.trans.panel = uix.HBox('Parent',double(handles.yAxis.trans.panelBig));
handles.yAxis.trans.log = uicontrol('Style','radiobutton','Parent',double(handles.yAxis.trans.panel),'String','Log','HandleVisibility','callback');
handles.yAxis.trans.none = uicontrol('Style','radiobutton','Parent',double(handles.yAxis.trans.panel),'String','None','HandleVisibility','callback');
set(handles.yAxis.trans.panel,'Widths',[-1 -1]);
handles.yAxis.lim.panel = uix.HBox('Parent',double(handles.yAxis.panel));
handles.yAxis.lim.text = uicontrol('Style','Text','Parent',double(handles.yAxis.lim.panel),'String','Limits:','HandleVisibility','callback');
handles.yAxis.lim.low = uicontrol('Style','edit','Parent',double(handles.yAxis.lim.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.yAxis.lim.hi = uicontrol('Style','edit','Parent',double(handles.yAxis.lim.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
set(handles.yAxis.lim.panel,'Widths',[50 -1 -1],'Spacing',5);
set(handles.yAxis.panel,'Heights',[20 40 20],'Spacing',5);
%Histogram properties
handles.hist.panelBig = uix.Panel('Parent',handles.yAxisORhistPanel,'Title','Histogram options:','BorderType','etchedout');
handles.hist.panel = uix.VBox('Parent',handles.hist.panelBig,'Padding',5);
handles.hist.yAxis.panelBig = uix.Panel('Parent',handles.hist.panel,'Title','Y Axis:','BorderType','etchedout');
handles.hist.yAxis.panel = uix.VBox('Parent',handles.hist.yAxis.panelBig,'Padding',5);
handles.hist.yAxis.param = uicontrol('Style','Popupmenu','Parent',double(handles.hist.yAxis.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.hist.yAxis.lim.panel = uix.HBox('Parent',double(handles.hist.yAxis.panel));
handles.hist.yAxis.lim.text = uicontrol('Style','Text','Parent',double(handles.hist.yAxis.lim.panel),'String','Limits:','HandleVisibility','callback');
handles.hist.yAxis.lim.low = uicontrol('Style','edit','Parent',double(handles.hist.yAxis.lim.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.hist.yAxis.lim.hi = uicontrol('Style','edit','Parent',double(handles.hist.yAxis.lim.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
set(handles.hist.yAxis.lim.panel,'Widths',[50 -1 -1],'Spacing',5);
set(handles.hist.yAxis.panel,'Heights',[20 20],'Spacing',5);
handles.hist.lowPanel1 = uix.HBox('Parent',handles.hist.panel);
handles.hist.smooth = uicontrol('Style','Checkbox','Parent',double(handles.hist.lowPanel1),'String','Smooth','HandleVisibility','callback');
handles.hist.smoothWidthText = uicontrol('Style','text','Parent',double(handles.hist.lowPanel1),'String','(Width: ','Enable','off','HandleVisibility','callback');
handles.hist.smoothWidth = uicontrol('Style','edit','Parent',double(handles.hist.lowPanel1),'String',' ','UserData','0.05','BackgroundColor','white','Enable','off','HandleVisibility','callback');
handles.hist.smoothWidthText2 = uicontrol('Style','text','Parent',double(handles.hist.lowPanel1),'String',' )','Enable','off','HandleVisibility','callback');
set(handles.hist.lowPanel1,'Widths',[100 -1 -1 5]);
handles.hist.lowPanel2 = uix.HBox('Parent',handles.hist.panel);
handles.hist.noOfBinsText = uicontrol('Style','text','Parent',double(handles.hist.lowPanel2),'String','No. of bins:','HandleVisibility','callback');
handles.hist.noOfBins = uicontrol('Style','edit','Parent',double(handles.hist.lowPanel2),'String',' ','UserData','1024','BackgroundColor','white','HandleVisibility','callback');
handles.hist.xAxis.lim.panel = uix.HBox('Parent',handles.hist.panel);
handles.hist.xAxis.lim.text = uicontrol('Style','Text','Parent',double(handles.hist.xAxis.lim.panel),'String','Histogram limits:','HandleVisibility','callback');
handles.hist.xAxis.lim.low = uicontrol('Style','edit','Parent',double(handles.hist.xAxis.lim.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.hist.xAxis.lim.hi = uicontrol('Style','edit','Parent',double(handles.hist.xAxis.lim.panel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
set(handles.hist.xAxis.lim.panel,'Widths',[80 -1 -1],'Spacing',5);
set(handles.hist.panel,'Heights',[70 20 20 20]);
%Final arrangments
set(handles.yAxisORhistPanel,'Selection',1);
set(handles.leftColumn,'Heights',[-2 -0.5 -0.5 20 -0.5],'MinimumHeights',[200 105 110 20 150],'Spacing',10,'Padding',5,'Visible','off');

%---------Right Column
handles.upPanel.panel = uix.CardPanel('Parent',double(handles.rightColumn),'Visible','off');
handles.axes.panel = uix.VBox('Parent',double(handles.rightColumn));
%Upper panels
%1/6. Warnning Panel
handles.upPanel.warnning = uicontrol('Parent',double(handles.upPanel.panel),'Style','Text','String','Double-click inside the shape in order to finish gating','Fontsize',20,'Enable','off');
%2/6. Manual Panel
handles.upPanel.manualGate.panel = uix.HBox('Parent',double(handles.upPanel.panel));
handles.upPanel.manualGate.calculate = uicontrol('Parent',double(handles.upPanel.manualGate.panel),'Cdata',icons.calculator,'TooltipString','Calculate no. of cells inside gate','HandleVisibility','callback');
handles.upPanel.manualGate.noOfCells = uicontrol('Style','text','Parent',double(handles.upPanel.manualGate.panel),'String','              ','HorizontalAlignment', 'left','HandleVisibility','callback');
handles.upPanel.manualGate.color = uicontrol('Parent',double(handles.upPanel.manualGate.panel),'String','Choose color','HandleVisibility','callback');
handles.upPanel.manualGate.name = uicontrol('Style','edit','Parent',double(handles.upPanel.manualGate.panel),'String',' ','BackgroundColor','white','Enable','inactive','HandleVisibility','callback');
handles.upPanel.manualGate.save = uicontrol('Parent',double(handles.upPanel.manualGate.panel),'TooltipString','Save gate to table','Cdata',icons.saveGate,'HandleVisibility','callback');
handles.upPanel.manualGate.cancel = uicontrol('Parent',double(handles.upPanel.manualGate.panel),'TooltipString','Cancel','Cdata',icons.closeWin,'HandleVisibility','callback');
set(handles.upPanel.manualGate.panel,'Widths',[22 -1 70 80 22 22],'Spacing',5);
%3/6. Auto Panel
handles.upPanel.autoGate.panel = uix.HBox('Parent',double(handles.upPanel.panel));
handles.upPanel.autoGate.centerText = uicontrol('Style','text','Parent',double(handles.upPanel.autoGate.panel),'String','Center:','HandleVisibility','callback');
handles.upPanel.autoGate.centerPanelBig = uix.VBox('Parent',double(handles.upPanel.autoGate.panel));
handles.upPanel.autoGate.centerPanel1 = uix.HBox('Parent',double(handles.upPanel.autoGate.centerPanelBig));
handles.upPanel.autoGate.centerPanel2 = uix.HBox('Parent',double(handles.upPanel.autoGate.centerPanelBig));
handles.upPanel.autoGate.xAxisText = uicontrol('Style','text','Parent',double(handles.upPanel.autoGate.centerPanel1),'String','X axis:','HandleVisibility','callback');
handles.upPanel.autoGate.yAxisText = uicontrol('Style','text','Parent',double(handles.upPanel.autoGate.centerPanel2),'String','Y axis:','HandleVisibility','callback');
handles.upPanel.autoGate.centerX = uicontrol('Style','edit','Parent',double(handles.upPanel.autoGate.centerPanel1),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.upPanel.autoGate.centerY = uicontrol('Style','edit','Parent',double(handles.upPanel.autoGate.centerPanel2),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.upPanel.autoGate.optionsPanel = uix.VBox('Parent',double(handles.upPanel.autoGate.panel));
handles.upPanel.autoGate.noOfCells = uicontrol('Style','edit','Parent',double(handles.upPanel.autoGate.optionsPanel),'String',' ','BackgroundColor','white');
handles.upPanel.autoGate.expansMode.panelBig = uix.Panel('Parent',double(handles.upPanel.autoGate.optionsPanel),'Title','Mode of expansion:','BorderType','etchedout');
handles.upPanel.autoGate.expansMode.panel = uix.HBox('Parent',double(handles.upPanel.autoGate.expansMode.panelBig));
handles.upPanel.autoGate.expansMode.radial = uicontrol('Style','radiobutton','Parent',double(handles.upPanel.autoGate.expansMode.panel),'String','Radial','HandleVisibility','callback');
handles.upPanel.autoGate.expansMode.isolines = uicontrol('Style','radiobutton','Parent',double(handles.upPanel.autoGate.expansMode.panel),'String','Isolines','HandleVisibility','callback');
handles.upPanel.autoGate.color = uicontrol('Style','pushbutton','Parent',double(handles.upPanel.autoGate.panel),'String','Choose color','HandleVisibility','callback');
handles.upPanel.autoGate.name = uicontrol('Style','edit','Parent',double(handles.upPanel.autoGate.panel),'String',' ','BackgroundColor','white','Enable','inactive','HandleVisibility','callback');
handles.upPanel.autoGate.save = uicontrol('Style','pushbutton','Parent',double(handles.upPanel.autoGate.panel),'TooltipString','Save gate to table','Cdata',icons.saveGate,'HandleVisibility','callback');
handles.upPanel.autoGate.cancel = uicontrol('Style','pushbutton','Parent',double(handles.upPanel.autoGate.panel),'TooltipString','Cancel','Cdata',icons.closeWin,'HandleVisibility','callback');
set(handles.upPanel.autoGate.panel,'Widths',[80 200 -1 70 80 22 22],'Spacing',5);
set(handles.upPanel.autoGate.optionsPanel,'Heights',[-0.8 -1],'Spacing',5);
%4/6. Quadrant Gate Panel
handles.upPanel.quadrantGate.panel = uix.HBox('Parent',double(handles.upPanel.panel));
handles.upPanel.quadrantGate.calculate = uicontrol('Parent',double(handles.upPanel.quadrantGate.panel),'Cdata',icons.calculator,'TooltipString','Calculate no. of cells inside gate','HandleVisibility','callback');
handles.upPanel.quadrantGate.noOfCellsPanel = uix.Grid('Parent',double(handles.upPanel.quadrantGate.panel),'Visible','off');
handles.upPanel.quadrantGate.quadrant2 = uicontrol('Parent',double(handles.upPanel.quadrantGate.noOfCellsPanel),'Style','Text','String','II:','HandleVisibility','callback');
handles.upPanel.quadrantGate.quadrant3 = uicontrol('Parent',double(handles.upPanel.quadrantGate.noOfCellsPanel),'Style','Text','String','III:','HandleVisibility','callback');
handles.upPanel.quadrantGate.quadrant1 = uicontrol('Parent',double(handles.upPanel.quadrantGate.noOfCellsPanel),'Style','Text','String','I:','HandleVisibility','callback');
handles.upPanel.quadrantGate.quadrant4 = uicontrol('Parent',double(handles.upPanel.quadrantGate.noOfCellsPanel),'Style','Text','String','IV:','HandleVisibility','callback');
set(handles.upPanel.quadrantGate.noOfCellsPanel,'Widths',[-1 -1]);
handles.upPanel.quadrantGate.chooseColorPanelBig = uix.Panel('Parent',double(handles.upPanel.quadrantGate.panel),'Title','Choose color:');
handles.upPanel.quadrantGate.chooseColorPanel = uix.Grid('Parent',double(handles.upPanel.quadrantGate.chooseColorPanelBig));
handles.upPanel.quadrantGate.quadrant2color = uicontrol('Parent',double(handles.upPanel.quadrantGate.chooseColorPanel),'String','II','HandleVisibility','callback');
handles.upPanel.quadrantGate.quadrant3color = uicontrol('Parent',double(handles.upPanel.quadrantGate.chooseColorPanel),'String','III','HandleVisibility','callback');
handles.upPanel.quadrantGate.quadrant1color = uicontrol('Parent',double(handles.upPanel.quadrantGate.chooseColorPanel),'String','I','HandleVisibility','callback');
handles.upPanel.quadrantGate.quadrant4color = uicontrol('Parent',double(handles.upPanel.quadrantGate.chooseColorPanel),'String','IV','HandleVisibility','callback');
set(handles.upPanel.quadrantGate.chooseColorPanel,'Widths',[-1 -1]);
handles.upPanel.quadrantGate.name = uicontrol('Style','edit','Parent',double(handles.upPanel.quadrantGate.panel),'String',' ','BackgroundColor','white','Enable','inactive','HandleVisibility','callback');
handles.upPanel.quadrantGate.save = uicontrol('Parent',double(handles.upPanel.quadrantGate.panel),'TooltipString','Save gate to table','Cdata',icons.saveGate,'HandleVisibility','callback');
handles.upPanel.quadrantGate.cancel = uicontrol('Parent',double(handles.upPanel.quadrantGate.panel),'TooltipString','Cancel','Cdata',icons.closeWin,'HandleVisibility','callback');
set(handles.upPanel.quadrantGate.panel,'Widths',[22 -1 80 80 22 22],'Spacing',5);
%5/6. Histogram data Panel
handles.upPanel.histData = uitable('Parent',double(handles.upPanel.panel),'Data',magic(10),'HandleVisibility','callback');
%6/6. Histogram gate Panel
handles.upPanel.histGate.panel = uix.HBox('Parent',handles.upPanel.panel);
handles.upPanel.histGate.calculate = uicontrol('Parent',double(handles.upPanel.histGate.panel),'Cdata',icons.calculator,'TooltipString','Calculate no. of cells inside gate','HandleVisibility','callback');
handles.upPanel.histGate.noOfCells = uicontrol('Style','text','Parent',double(handles.upPanel.histGate.panel),'String','              ','HorizontalAlignment', 'left','HandleVisibility','callback');
handles.upPanel.histGate.boundPanelBig = uix.Panel('Parent',handles.upPanel.histGate.panel,'BorderType','etchedout','Title','Gate boundaries:');
handles.upPanel.histGate.boundPanel = uix.HBox('Parent',handles.upPanel.histGate.boundPanelBig);
handles.upPanel.histGate.bound.histMin = uicontrol('Style','togglebutton','Parent',double(handles.upPanel.histGate.boundPanel),'String','Hist. Min.','HandleVisibility','callback');
handles.upPanel.histGate.bound.low = uicontrol('Style','edit','Parent',double(handles.upPanel.histGate.boundPanel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.upPanel.histGate.bound.hi = uicontrol('Style','edit','Parent',double(handles.upPanel.histGate.boundPanel),'String',' ','BackgroundColor','white','HandleVisibility','callback');
handles.upPanel.histGate.bound.histMax = uicontrol('Style','togglebutton','Parent',double(handles.upPanel.histGate.boundPanel),'String','Hist. Max.','HandleVisibility','callback');
handles.upPanel.histGate.autoBound = uicontrol('Style','pushbutton','Parent',double(handles.upPanel.histGate.boundPanel),'TooltipString','Set boundaries from statistical measures','Cdata',icons.histGateBoundSet,'HandleVisibility','callback');
set(handles.upPanel.histGate.boundPanel,'Widths',[100 100 100 100 22]);
handles.upPanel.histGate.color = uicontrol('Style','pushbutton','Parent',double(handles.upPanel.histGate.panel),'String','Choose color','HandleVisibility','callback');
handles.upPanel.histGate.name = uicontrol('Style','edit','Parent',double(handles.upPanel.histGate.panel),'String',' ','BackgroundColor','white','Enable','inactive','HandleVisibility','callback');
handles.upPanel.histGate.save = uicontrol('Style','pushbutton','Parent',double(handles.upPanel.histGate.panel),'TooltipString','Save gate to table','Cdata',icons.saveGate,'HandleVisibility','callback');
handles.upPanel.histGate.cancel = uicontrol('Style','pushbutton','Parent',double(handles.upPanel.histGate.panel),'TooltipString','Cancel','Cdata',icons.closeWin,'HandleVisibility','callback');
set(handles.upPanel.histGate.panel,'Widths',[22 -1 423 70 80 22 22],'MinimumWidths',[22 100 423 70 80 22 22],'Spacing',5);

%Axes tab panel
handles.axes.plotMode = uicontrol('parent',double(handles.axes.panel),'Style','popupmenu','String',{'2d Scatter Plot','1d Histogram'},'BackgroundColor',[0.8706 0.9216 0.9804],'Visible','off','HandleVisibility','callback');
handles.axes.axesPanel = uipanel('Parent',double(handles.axes.panel),'HandleVisibility','callback');
handles.axes.axes = axes('Parent',double(handles.axes.axesPanel),'Visible','off','HandleVisibility','callback');
set(handles.axes.panel,'Heights',[15 -1],'MinimumHeights',[15 200]);
set(handles.bigGrid,'Widths',[0 -1],'MinimumWidths',[0 200]);
set(handles.rightColumn,'Heights',[0 -1],'MinimumHeights',[0 200]);
end