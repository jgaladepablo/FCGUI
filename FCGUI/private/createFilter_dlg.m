function varargout = createFilter_dlg(varargin)

handles.figure = figure('Visible','off','MenuBar','None','NumberTitle','off',...
                        'Toolbar','none','HandleVisibility','callback','Resize','off',...
                        'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                        'name','Create filter',...
                        'Position',[520 454 509 376]);
                    
fcData = varargin{1,1};
tableData = cell(length(fcData.colheaders),6);
if length(varargin)>1
    filter = varargin{1,2};
end
filteredCells = 0;

builtfcn
callbackassignfcn
initializefcn

function builtfcn
handles.timeFilter.checkbox = uicontrol('Style','checkbox','Parent',handles.figure,...
                           'String','Filter the','Position',[13 340 68 23],...
                           'HandleVisibility','callback');
handles.timeFilter.cellNo = uicontrol('Style','edit','Parent',handles.figure,...
                                  'String','0','UserData',0,'BackgroundColor','white',...
                                  'Enable','off','Position',[80 341 94 21],...
                                  'HandleVisibility','callback');
handles.text1 = uicontrol('Style','text','Parent',handles.figure,...
                      'String','first cells','Position',[177 345 51 14],...
                      'HandleVisibility','callback');
handles.text2 = uicontrol('Style','text','Parent',handles.figure,...
                      'String','Filter extreme values:','Position',[13 315 107 14],...
                      'HandleVisibility','callback');
handles.table = uitable('Parent',handles.figure,'HandleVisibility','callback',...
                    'Position',[13 158 474 151],...
                    'ColumnEditable',logical([1 0 1 1 1 1]),...
                    'ColumnFormat',{'logical','char','numeric','numeric','numeric','numeric'},...
                    'ColumnName',{'Filter','Parameter Name','% of extreme low values','# of extreme low values','% of extreme high values','# of extreme high values'},...
                    'ColumnWidth',{40,'auto','auto','auto','auto','auto'},...
                    'RowName',[]);
handles.text3 = uicontrol('Style','text','Parent',handles.figure,...
                      'String','Total # of cells:','Position',[13 131 73 14],...
                      'HandleVisibility','callback');
handles.totalCellNoText = uicontrol('Style','text','Parent',handles.figure,...
                                'String','##############','Position',[84 131 78 14],...
                                'ForegroundColor',[0 0 1],...
                                'HandleVisibility','callback');                      
handles.text4 = uicontrol('Style','text','Parent',handles.figure,...
                      'String','# of filtered cells:','Position',[159 131 84 14],...
                      'HandleVisibility','callback');
handles.filteredCellNoText = uicontrol('Style','text','Parent',handles.figure,...
                                'String','##############','Position',[243 131 77 14],...
                                'ForegroundColor',[0.847 0.161 0],...
                                'HandleVisibility','callback'); 
handles.text5 = uicontrol('Style','text','Parent',handles.figure,...
                      'String','# of remaining cells:','Position',[320 131 97 14],...
                      'HandleVisibility','callback');
handles.remainCellNoText = uicontrol('Style','text','Parent',handles.figure,...
                                'String','##############','Position',[417 131 77 14],...
                                'ForegroundColor',[0 0.8 0.2],...
                                'HandleVisibility','callback');
handles.createGateCheckbox = uicontrol('Style','checkbox','Parent',handles.figure,...
                           'String','Create a gate of the filter','Position',[14 103 148 23],...
                           'HandleVisibility','callback');
handles.text5 = uicontrol('Style','text','Parent',handles.figure,...
                      'String',{'Choosing this option will leave all the filtered cells in the data as a defined gate.';
                                'Even when this option is not chosen, filtering is reversible.'},...
                                'FontAngle','oblique','ForegroundColor',[0.5 0.5 0.5],...
                                'HorizontalAlignment','left','Position',[32 78 400 29],...
                                'HandleVisibility','callback');  
handles.text6 = uicontrol('Style','text','Parent',handles.figure,...
                            'String',{'!! Filtering is not reversible regarding existing gates !! they will be updated by the';...
                                'filter and will remain the same even after removing the filter.'},...
                                'ForegroundColor',[0.847 0.161 0],...
                                'HorizontalAlignment','left','Position',[32 48 400 29],...
                                'HandleVisibility','callback'); 
handles.cancel = uicontrol('Parent',handles.figure,'String','Cancel',...
                       'Position',[12 16 68 22],'HandleVisibility','callback');
handles.cancelAll = uicontrol('Parent',handles.figure,'String','Cancel all filters',...
                       'FontAngle','oblique','ForegroundColor',[0.043 0.518 0.78],...
                       'Position',[199 16 106 22],'HandleVisibility','callback','Visible','off');
handles.ok = uicontrol('Parent',handles.figure,'String','OK',...
                       'Position',[421 16 68 22],'HandleVisibility','callback'); 
end
function callbackassignfcn
set(handles.timeFilter.checkbox,    'Callback',         @timeFilterCheckBox_callback);
set(handles.timeFilter.cellNo,      'Callback',         @timeFilterCellNo_callback);
set(handles.table,                  'CellEditCallback', @tableCellEdit_callback);
set(handles.cancel,                 'Callback',         @cancel_callback);
set(handles.cancelAll,              'Callback',         @cancelAll_callback);
set(handles.ok,                     'Callback',         @ok_callback);
end
function initializefcn
tableData(:,1) = {false};
tableData(:,2) = fcData.colheaders;
tableData(:,3) = {4};
tableData(:,4) = {ceil(4*size(fcData.data,1)/100)};
tableData(:,5) = {4};
tableData(:,6) = {ceil(4*size(fcData.data,1)/100)};
if exist('filter','var')
    set(handles.cancelAll,'Visible','on');
    set(handles.cancel,'String','Close');
    fcData.data = fcData.nonFilteredData;
    if isfield(filter,'time')
        set(handles.timeFilter.checkbox,'Value',1);
        set(handles.timeFilter.cellNo,'Enable','on','string',num2str(filter.time),'UserData',filter.time);
    end
    if get(handles.timeFilter.checkbox ,'Value')
        alreadyFiltered = get(handles.timeFilter.cellNo,'UserData');
    else
        alreadyFiltered = 0;
    end
    if isfield(filter,'axis')
        for i = 1:size(filter.axis,1)
            row = strcmp(tableData(:,2),filter.axis{i,1});
            tableData(row,1) = {true};
            tableData(row,3) = filter.axis(i,2);
            tableData(row,5) = filter.axis(i,3);
            tableData(row,4) = {ceil(filter.axis{i,2}*(size(fcData.data,1)-alreadyFiltered)/100)};
        	tableData(row,6) = {ceil(filter.axis{i,3}*(size(fcData.data,1)-alreadyFiltered)/100)};
        end
    end
    helperfcn_updateFilters;
else
    filteredCells = false(size(fcData.data,1),1);
    set(handles.filteredCellNoText,'String','0');
end
set(handles.table,'Data',tableData);
set(handles.totalCellNoText,'String',num2str(size(fcData.data,1)));
set(handles.remainCellNoText,'String',num2str(size(fcData.data,1)-length(find(filteredCells))));    
varargout{1} = 0;
uiwait(handles.figure);
end

function ok_callback(hObject,eventdata)%#ok
if ~isempty(find(filteredCells,1))
    if get(handles.timeFilter.checkbox,'Value')
        filter.time = get(handles.timeFilter.cellNo,'UserData');
    end
    chosenFilters = find(cellfun(@(x) x==1,tableData(:,1)));
    if ~isempty(chosenFilters)
        filter.axis = cell(length(chosenFilters),3);
        for i = 1:length(chosenFilters)
            filter.axis(i,:) = {fcData.colheaders{chosenFilters(i)},tableData{chosenFilters(i),3},tableData{chosenFilters(i),5}};
        end
    end
    if get(handles.createGateCheckbox,'value')
        varargout{1} = {'gate',filter,filteredCells};
    else
        varargout{1} = {'filter',filter,filteredCells};
    end
else
    if get(handles.createGateCheckbox,'value')
        varargout{1} = {'gate','',filteredCells};
    else
        varargout{1} = {'filter','',filteredCells};
    end
end
uiresume(handles.figure);
delete(handles.figure);
end
function cancel_callback(hObject,eventdata)%#ok
uiresume(handles.figure);
delete(handles.figure);
end
function cancelAll_callback(hObject,eventdata)%#ok
varargout{1} = {'cancelAll'};    
uiresume(handles.figure);
delete(handles.figure);
end

function timeFilterCheckBox_callback(hObject,eventdata)%#ok
if get(hObject,'Value')
    set(handles.timeFilter.cellNo,'Enable','on');
    number = get(handles.timeFilter.cellNo,'UserData');
else
    set(handles.timeFilter.cellNo,'Enable','off');
    number = 0;
end
for row = 1:size(tableData,1)
    handles.tableData(row,4) = {ceil(tableData{row,3}*(size(fcData.data,1)-number)/100)};
    handles.tableData(row,6) = {ceil(tableData{row,5}*(size(fcData.data,1)-number)/100)};
end
set(handles.table,'Data',tableData);
helperfcn_updateFilters;
end
function timeFilterCellNo_callback(hObject,eventdata)%#ok
number = str2double(get(hObject,'string'));
if isnan(number)||number>size(fcData.data,1)||number<0
    set(hObject,'String',num2str(get(hObject,'userData')));
    number = get(hObject,'userData');
else
    number = round(number);
    set(hObject,'string',num2str(number),'userData',number);
end
for row = 1:size(handles.tableData,1)
    tableData(row,4) = {ceil(tableData{row,3}*(size(fcData.data,1)-number)/100)};
    tableData(row,6) = {ceil(tableData{row,5}*(size(fcData.data,1)-number)/100)};
end
set(handles.table,'Data',tableData);
helperfcn_updateFilters;
end
function tableCellEdit_callback(hObject,eventdata)%#ok
row = eventdata.Indices(1,1);
column = eventdata.Indices(1,2);
if get(handles.timeFilter.checkbox ,'Value')
    alreadyFiltered = get(handles.timeFilter.cellNo,'UserData');
else
    alreadyFiltered = 0;
end
if column == 1
    tableData = get(handles.table,'Data');
elseif column == 3||column == 5
    number = str2double(eventdata.EditData);
    if isnan(number) || number > 100 || number < 0
        set(handles.table,'Data',tableData);
        return;
    else
        tableData = get(handles.table,'Data');
        tableData(row,1) = {true};
        if column == 3
        	tableData(row,4) = {ceil(number*(size(fcData.data,1)-alreadyFiltered)/100)};
        else
        	tableData(row,6) = {ceil(number*(size(fcData.data,1)-alreadyFiltered)/100)};
        end
    end
elseif column == 4||column == 6
    number = str2double(eventdata.EditData);
    if isnan(number) || number>(size(fcData.data,1)-alreadyFiltered) || number < 1
        set(handles.table,'Data',tableData);
        return;
    else
        tableData = get(handles.table,'Data');
        tableData(row,1) = {true};
        number = round(number);
        tableData(row,column) = {number};
        if column == 4
        	tableData(row,3) = {number/(size(fcData.data,1)-alreadyFiltered)*100};
        else
            tableData(row,5) = {number/(size(fcData.data,1)-alreadyFiltered)*100};
        end
    end
end
set(handles.table,'Data',tableData);
helperfcn_updateFilters;
end

function helperfcn_updateFilters
filteredCells = false(size(fcData.data,1),1);
if get(handles.timeFilter.checkbox ,'Value')
    firstCells = get(handles.timeFilter.cellNo,'UserData');
    filteredCells(1:firstCells) = true;
else
    firstCells = 0;
end
chosenFilters = find(cellfun(@(x) x==1,tableData(:,1)));
for i = 1:length(chosenFilters)
    tempData = fcData.data(:,chosenFilters(i));
    [~,indeces] = sort(tempData);
    indeces(ismember(indeces,1:firstCells)) = [];
    lowCells = tableData{chosenFilters(i),4};
    if lowCells>1
        filteredCells(indeces(1:lowCells)) = true;
    end
    highCells = tableData{chosenFilters(i),6};
    if highCells>1
        filteredCells(indeces(end:-1:end-highCells+1)) = true;
    end
end
set(handles.filteredCellNoText,'String',num2str(length(find(filteredCells))));
set(handles.remainCellNoText,'String',num2str(size(fcData.data,1)-length(find(filteredCells))));
end
end