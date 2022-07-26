function varargout = mathParam_dlg(varargin)

handles.figure = figure('Visible','off','Position',[520 632 310 168],'Resize','off','Name','Math operations on parameters','MenuBar','None','NumberTitle','off','Toolbar','none','HandleVisibility','callback','Color',get(0,'defaultuicontrolbackgroundcolor'));
handles.param1 = uicontrol('Callback',@helperfcn_updateOperations,'Parent',handles.figure,'Style','popupmenu','position',[9 131 94 22],'String',' ','BackgroundColor','white');
handles.operator = uicontrol('Callback',{@helperfcn_updateOperations,'operator'},'Parent',handles.figure,'Style','popupmenu','position',[128 131 30 22],'String',{'*';'/';'-';'+';'^'},'BackgroundColor','white');
handles.param2 = uibuttongroup('SelectionChangeFcn',@helperfcn_updateOperations,'Parent',handles.figure,'units','pixels','Position',[174 67 126 95],'BorderType','none');
handles.numeric = uicontrol('Parent',handles.param2,'Style','radiobutton','Position',[7 62 89 23]);
handles.column = uicontrol('Parent',handles.param2,'Style','radiobutton','Position',[7 37 87 23]);
handles.statistics = uicontrol('Parent',handles.param2,'Style','radiobutton','Position',[7 12 87 23]);
handles.numericParam = uicontrol('Callback',{@helperfcn_updateOperations,'numeric'},'Parent',handles.param2,'Style','edit','position',[26 63 94 22],'BackgroundColor','white');
handles.columnParam = uicontrol('Callback',{@helperfcn_updateOperations,'column'},'Parent',handles.param2,'Style','popupmenu','position',[26 34 94 26],'BackgroundColor','white','String',' ');
handles.statisticsParam = uicontrol('Callback',{@helperfcn_updateOperations,'statistics'},'Parent',handles.param2,'Style','popupmenu','position',[26 10 94 23],'BackgroundColor','white','String',{'Mean';'Median'});
handles.nameText = uicontrol('Parent',handles.figure,'Style','text','Position',[72 50 32 14],'String','Name:');
handles.name = uicontrol('Callback',@name_Callback,'Parent',handles.figure,'Style','edit','Position',[108 46 94 22],'String',' ','BackgroundColor','white');
handles.cancel = uicontrol('Callback',@cancel_Callback,'Parent',handles.figure,'Position',[9 14 68 22],'String','Cancel');
handles.ok = uicontrol('Callback',@ok_Callback,'Parent',handles.figure,'Position',[232 12 68 22],'String','OK');

colheaders  = varargin{1,1};
set(handles.param1,'String',colheaders);
set(handles.columnParam,'String',colheaders,'Value',2);
operations = get(handles.operator,'string');
set(handles.param2,'SelectedObject',handles.column);
operatorStr = {get(handles.param1,'value'),...
               operations{get(handles.operator,'value')},...
               'column',get(handles.columnParam,'value')};
nameStr = ['',colheaders{operatorStr{1}},' ',operatorStr{2},' ',colheaders{operatorStr{4}},''];
set(handles.name,'String',nameStr,'UserData',nameStr);

set(handles.figure,'Visible','on');
varargout{1} = 0;
uiwait(handles.figure);

function name_Callback(hObject,eventdata)%#ok
name = get(hObject,'String');
notgoodsigns = strfind(name, '''');
notgoodsigns = [notgoodsigns,strfind(name, '[')];
notgoodsigns = [notgoodsigns,strfind(name, ']')];
notgoodsigns = [notgoodsigns,strfind(name, '"')];
name(notgoodsigns) = '';
if isempty(name)
	set(hObject,'String',get(hObject,'UserData'));
else
	set(hObject,'String',name,'UserData',name);
end
end
function ok_Callback(hObject,eventdata)%#ok
name = get(handles.name,'String');
if ~isempty(find(strcmp(colheaders,name),1))
	errordlg('Parameter in that name already exists','Error','replace');
	return;
end
if isequal(get(handles.param2,'SelectedObject'),handles.numeric)...
   && ...
   isnan(str2double(get(handles.numericParam,'string')))
   errordlg('Numeric parameter is not defined','Error','replace');
   return;
end
varargout{1} = {name,operatorStr};
% end
uiresume(handles.figure);
delete(handles.figure);
end
function cancel_Callback(hObject,eventdata)%#ok
uiresume(handles.figure);
delete(handles.figure);
end
function helperfcn_updateOperations(hObject,eventdata,varargin)%#ok
if nargin == 3
    switch varargin{1,1}
        case 'numeric'
            set(handles.param2,'SelectedObject',handles.numeric);
            if isnan(str2double(get(handles.numericParam,'string')))
                set(handles.numericParam,'string',' ');
            end
        case 'column'
            set(handles.param2,'SelectedObject',handles.column);
        case 'statistics'
            set(handles.param2,'SelectedObject',handles.statistics);
        case 'operator'
            if get(handles.operator,'value')==5
                set([handles.columnParam,handles.statisticsParam,...
                    handles.column,handles.statistics],'enable','off');
                set(handles.param2,'SelectedObject',handles.numeric);
            else
                set([handles.columnParam,handles.statisticsParam,...
                    handles.column,handles.statistics],'enable','on');
            end
    end
end
switch get(handles.param2,'SelectedObject')
    case handles.numeric
        operatorStr = {get(handles.param1,'value'),...
                       operations{get(handles.operator,'value')},...
                       'numeric',get(handles.numericParam,'string')};
        nameStr = ['',colheaders{operatorStr{1}},' ',operatorStr{2},' ',operatorStr{4},''];        
    case handles.column
        operatorStr = {get(handles.param1,'value'),...
                       operations{get(handles.operator,'value')},...
                       'column',get(handles.columnParam,'value')};
        nameStr = ['',colheaders{operatorStr{1}},' ',operatorStr{2},' ',colheaders{operatorStr{4}},''];        
    case handles.statistics
        statParam = get(handles.statisticsParam,'String');
        statParam = statParam{get(handles.statisticsParam,'Value')};
        operatorStr = {get(handles.param1,'value'),...
                       operations{get(handles.operator,'value')},...
                       'statistics',statParam};
        nameStr = ['',colheaders{operatorStr{1}},' ',operatorStr{2},' ',operatorStr{4},''];        
end
set(handles.name,'String',nameStr);
end
end