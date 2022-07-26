function cvs2mat

handles.figure = figure('Visible','off','MenuBar','None','NumberTitle','off',...
                        'Toolbar','none','HandleVisibility','callback','Resize','off',...
                        'Color',get(0,'defaultuicontrolbackgroundcolor'),...
                        'name','cvs2mat',...
                        'Position',[520 647 332 153]);
handles.text1 = uicontrol('Style','text','parent',handles.figure,...
                          'String','1. Choose source directory:',...
                          'Handlevisibility','callback',...
                          'Position',[22 126 138 14]);
handles.sourceDir = uicontrol('callback',@sourceDir_callback,...
                          'Style','edit','parent',handles.figure,...
                          'String',' ','BackgroundColor','white','horizontalalignment','left',...
                          'Handlevisibility','callback',...
                          'Position',[22 103 275 22]);
handles.sourceDirDir = uicontrol('Callback',@setDir_callback,...
                          'Style','pushbutton','parent',handles.figure,...
                          'String','...',...
                          'Handlevisibility','callback',...
                          'Position',[297 103 22 22]); 
handles.text2 = uicontrol('Style','text','parent',handles.figure,...
                          'String','2. Choose destination directory:',...
                          'Handlevisibility','callback',...
                          'Position',[22 70 157 14]);
handles.destDir = uicontrol('Style','edit','parent',handles.figure,...
                          'String',' ','BackgroundColor','white','horizontalalignment','left',...
                          'Handlevisibility','callback',...
                          'Position',[22 46 275 22]);
handles.destDirDir = uicontrol('Callback',@setDir_callback,...
                          'Style','pushbutton','parent',handles.figure,...
                          'String','...',...
                          'Handlevisibility','callback',...
                          'Position',[297 46 22 22]); 
handles.ok = uicontrol('Callback',@ok_Callback,'Style','pushbutton','parent',handles.figure,...
                          'String','OK',...
                          'Handlevisibility','callback',...
                          'Position',[251 13 68 22]); 
handles.cancel = uicontrol('Callback',@(~,~) delete(handles.figure),...
                          'Style','pushbutton','parent',handles.figure,...
                          'String','Cancel',...
                          'Handlevisibility','callback',...
                          'Position',[22 13 68 22]); 
set(handles.figure,'Visible','on');

function sourceDir_callback(hObject,eventdata)%#ok
folderName = get(hObject,'String');
if ~isempty(folderName)
	set(handles.destDir,'String',[folderName,filesep,'MAT_FILES']);    
end
end


function setDir_callback(hObject,eventdata)%#ok
folderName = uigetdir;
if folderName
    switch hObject
        case handles.sourceDirDir
            set(handles.sourceDir,'String',folderName);
            set(handles.destDir,'String',[folderName,filesep,'MAT_FILES']);
        case handles.destDirDir
            set(handles.destDir,'String',folderName);
    end    
end
end

function ok_Callback(hObject, eventdata)%#ok
sourceDir = get(handles.sourceDir,'String');
destDir = get(handles.destDir,'String');

if isempty(sourceDir)
    errordlg('Choose source directory','Error','replace');
    return;
end
if isempty(destDir)
	errordlg('Choose destination directory','Error','replace');
    return;
end
if ~exist(sourceDir,'dir')
    errordlg('Source directory does not exist','Error','replace');
    return;
end
if ~exist(destDir,'dir')
    mkdir(destDir);
end

dirContent = dir(sourceDir);
if isempty(dirContent)
    disp(['There are no files in source dir',sourceDir]);
    return;
else
    fileNames = cell(length(dirContent),1);
    for i = 1:length(fileNames)
        fileNames{i} = dirContent(i).name;
    end
    fileNames(1:2,:) = [];
    fileNames = cellfun(@(x) strtok(x,'.'),fileNames,'UniformOutput',false);
    fileNames = unique(fileNames);
end

for i = 1:length(fileNames)
    cvsFileName = [fileNames{i},'.csv'];
    txtFileName = [fileNames{i},'.txt'];
    
    try   
        fcData = importdata([sourceDir,filesep,cvsFileName], ',');
    catch exception %#ok
        disp(['Unable to open file: ',[fileNames{i},'.csv']]);
        continue;
    end
    fcData = rmfield(fcData, 'textdata');
    fcData.voltage = cell(1,size(fcData.data,2));

    try
        file = fopen([sourceDir,filesep,txtFileName]);
    catch exception %#ok
        disp(['Unable to open file: ',[fileNames{i},'.csv']]);
        continue;
    end
    text = textscan(file,'%s','delimiter','\n');
    fclose(file);

    text = text{1,1};

    token = regexp(text, 'THRESHOLD,(.*)','tokens','once');
    token = token(~cellfun('isempty',token));
    if ~isempty(token)
            fcData.threshold = token{1,1}{1,1};
    end

    for j = 1:size(fcData.data,2)
        regularExp = ['\$P',num2str(j),'N\,(.*)'];
        token = regexp(text, regularExp,'tokens','once');
        token = token(~cellfun('isempty',token));
        if ~isempty(token)
            fcData.colheaders{1,j} = token{1,1}{1,1};
        end

        regularExp = ['\$P',num2str(j),'V\,(.*)'];
        token = regexp(text, regularExp,'tokens','once');
        token = token(~cellfun('isempty',token));
        if ~isempty(token)
            fcData.voltage{1,j} = str2double(token{1,1}{1,1});
        end
    end
    save([destDir,filesep,fileNames{i},'.mat'],'fcData');
    msgbox([num2str(i),'/',num2str(length(fileNames)),' completed'],'Done!','help','replace');
end
end
end