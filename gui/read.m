function varargout = read(varargin)
% READ MATLAB code for read.fig
%      READ, by itself, creates a new READ or raises the existing
%      singleton*.
%
%      H = READ returns the handle to a new READ or the handle to
%      the existing singleton*.
%
%      READ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in READ.M with the given input arguments.
%
%      READ('Property','Value',...) creates a new READ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before read_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to read_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help read

% Last Modified by GUIDE v2.5 18-Jul-2016 14:55:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @read_OpeningFcn, ...
                   'gui_OutputFcn',  @read_OutputFcn, ...
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

% --- Executes just before read is made visible.
function read_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to read (see VARARGIN)

% Choose default command line output for read
handles.output = hObject;
addpath(genpath('functions'));              % All needed subfunctions

% Update the available list_of_ports
global port;
port = updatePorts(handles);

% Initialize the arduino
global arduino;
arduino = initArduino(port, handles);


% Label the axes
axes(handles.dt);
xlabel('Time in seconds');
ylabel('Distance in mm');
grid(handles.dt, 'on');
axes(handles.pe);
xlabel('Error in mm');
ylabel('Frequency');
grid(handles.pe, 'on');



% Number of variables to be stored (nSamples, times, distance)
global nData;
nData = 3;

% Params input (determine when to stop measurements)
global isLimitedBySamples;
isLimitedBySamples = 0;
global isLimitedByTime;
isLimitedByTime = 0;
global isStopped;
isStopped = 0;
% Actual distance (defect value = 0)
global actual_distance;
actual_distance = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes read wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = read_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function text_nsamples_Callback(hObject, eventdata, handles)
% hObject    handle to text_nsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_nsamples as text
%        str2double(get(hObject,'String')) returns contents of text_nsamples as a double

% Update nSamples are wanted to be measured
global nSamples;
nSamples = str2double(get(hObject,'String'));

% guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function text_nsamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_nsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculate_button.
function calculate_button_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Clear the maps
cla(handles.dt);
cla(handles.pe);


% Initialize the arduino
global port;
global arduino;
arduino = initArduino(port, handles);
% if (port == '0')
%     close;
% end
fopen(arduino);

% Disable rest of buttons
changeVisibility(handles, 'off');
set(handles.update_button, 'Enable', 'off');

% TBD
% global destination_id;
% Funciona! imprime en hex lo correcto
% fprintf(arduino,hex2num(destination_id(3:4)))

% % Wait a bit to read the data
% pause(1);
% fprintf(arduino,'%x',destination_id(1));
% pause(0.1)
% fprintf(arduino,'%x',destination_id(2));
% pause(0.4)
% fprintf(arduino,'%x',destination_id(3));
% pause(0.4)
% fprintf(arduino,'%x',destination_id(4));
% fscanf(arduino,'%s')
% fscanf(arduino,'%s')
% fscanf(arduino,'%s')
% fscanf(arduino,'%s')
% fscanf(arduino,'%s')
% fscanf(arduino,'%s')
% fscanf(arduino,'%s')
% fscanf(arduino,'%s')
% fscanf(arduino,'%s')
% fscanf(arduino,'%s')
% fscanf(arduino,'%s')

% Variables to stop the code if:
% - is limited by samples
% - is limited by time
% - is pressed the stop button (isDone)
global isLimitedBySamples;
global nSamples;
global isLimitedByTime;
global nTime;
global isStopped;
isStopped = 0;

% More input data
global actual_distance;
global nData;

% Output data, READ matrix:
% - row: number of sample, initialize it to the first one
% - nData column: nSample, time (ms) and distance (mm) 
clear READ;
global READ;
READ = [];
row = 1;

% Wait until Arduino outputs READY: that means next output is nSample = 1
    % see .ino code for more info
% and can store into READ the first value
isReadyToRange = 0;
while(not(isReadyToRange))
    if(arduino.BytesAvailable > 0)
        if (strcmp('READY',fscanf(arduino, '%s')))
            isReadyToRange = 1;
        end
    end
end

% Write the output data into READ while is not finished and it is ready
Finished = 0;
try
    while(not(Finished) && isReadyToRange)
        % no data to transmit => wait 0.5 s
        if(arduino.BytesAvailable <= 0)
            pause(0.5);
        end

        % wait until Arduino outputs data
        if (arduino.BytesAvailable >= nData) 

            % write a row matrix (nData columns)
            for column = 1:nData           
                READ(row, column)= fscanf(arduino, '%i');            
            end

            % Get sub columns
            samples_vector =  READ(:,1);
            times_vector =  READ(:,2)/1000;
            distances_vector =  READ(:,3);

            % Plot d(t) and p(e)
            hold(handles.dt, 'on');
            plot (handles.dt, times_vector, distances_vector,'g');
            % pause(0.01);
            
            ERROR = distances_vector - actual_distance;
            hist(handles.pe, ERROR);
            grid(handles.pe, 'on');
            
            xlabel('Error in mm');
            ylabel('Probability');
            % pause(0.01);

            % Update the text info
            set(handles.result_samples, 'String', samples_vector(end));
            set(handles.result_time, 'String', times_vector(end));
            set(handles.result_max_error, 'String', max(ERROR));
            set(handles.result_min_error, 'String', min(ERROR));
            set(handles.result_mean, 'String', mean(ERROR));
            set(handles.result_variance, 'String', var(ERROR));
            progress = 'Calculating';
            set(handles.calculate_button, 'String', progress);
            if (isLimitedBySamples && not(isLimitedByTime))
                progress =  strcat(num2str((round(row/nSamples * 100,2))),{' %'});
                set(handles.calculate_button, 'String', progress);
            end
            if (not(isLimitedBySamples) && (isLimitedByTime))
                progress =  strcat(num2str((round(times_vector(row)/nTime * 100,2))),{' %'});
                set(handles.calculate_button, 'String', progress);
            end
            if ((isLimitedBySamples) && (isLimitedByTime))                
                progress1 =  (round(row/nSamples * 100,2));
                progress2 = (round(times_vector(row)/nTime * 100,2));
                if (progress1 >= progress2)
                    progress_num = progress1;    
                else
                    progress_num = progress2;
                end
                progress =  strcat(num2str(progress_num),{' %'});
                set(handles.calculate_button, 'String', progress);
            end


            % Prepare next row
            row = row+1;

            % Finally, check if it has finished (wheter nSamples, nTime or
            % isStopped)
            Finished = checkIfFinished(isLimitedBySamples, nSamples, isLimitedByTime, nTime, isStopped, READ, times_vector);
            pause(0.01);
            % Remove zero rows (just in case)
            % READ = READ(any(READ,2),:)

        end
    end
    set(handles.calculate_button, 'String', 'Range');
    READ;
catch
    display('Stop');
    % Closes the arduino connection
    % fclose(arduino);

    % Active rest of buttons
    changeVisibility(handles,'on');
    set(handles.update_button, 'Enable', 'on');
end
% Closes the arduino connection
% fclose(arduino);

% Active rest of buttons
changeVisibility(handles,'on');
set(handles.update_button, 'Enable', 'on');



% --- Executes during object creation, after setting all properties.
function dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate dt


% --------------------------------------------------------------------
function Program_Callback(hObject, eventdata, handles)
% hObject    handle to Program (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ranging_Callback(hObject, eventdata, handles)
% hObject    handle to ranging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function positioning_Callback(hObject, eventdata, handles)
% hObject    handle to positioning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in list_of_ports.
function list_of_ports_Callback(hObject, eventdata, handles)
% hObject    handle to list_of_ports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_of_ports contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_of_ports

% Update the available list_of_ports
global port;
port = updatePorts(handles);

% Initialize the arduino
global arduino;
arduino = initArduino(port, handles);


% --- Executes during object creation, after setting all properties.
function list_of_ports_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_of_ports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update_button.
function update_button_Callback(hObject, eventdata, handles)
% hObject    handle to update_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Upadte the ports as the initialization
% Update the available list_of_ports
global port;
port = updatePorts(handles);


% --- Executes on button press in check_limit_samples.
function check_limit_samples_Callback(hObject, eventdata, handles)
% hObject    handle to check_limit_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_limit_samples

% Update the flag
global isLimitedBySamples;
isLimitedBySamples = get(hObject,'Value');


function text_tsamples_Callback(hObject, eventdata, handles)
% hObject    handle to text_tsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_tsamples as text
%        str2double(get(hObject,'String')) returns contents of text_tsamples as a double

% Update the seconds are wanted to be measured
global nTime;
nTime = str2double(get(hObject,'String'));



% --- Executes during object creation, after setting all properties.
function text_tsamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_tsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_limit_time.
function check_limit_time_Callback(hObject, eventdata, handles)
% hObject    handle to check_limit_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_limit_time

%Update the flag
global isLimitedByTime;
isLimitedByTime = get(hObject,'Value');


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Update the flag
global isStopped;
isStopped=true;

% Active rest of buttons
changeVisibility(handles,'on');

% % Update the available list_of_ports
global port;
updatePorts(handles);
% contents = cellstr(get(handles.list_of_ports,'String'));
% port =  contents{get(handles.list_of_ports,'Value')};

% Initialize the arduino for the next time
global arduino;
arduino = initArduino(port, handles);
pause(0.2);
set(handles.calculate_button, 'String', 'Range');

% --- Executes on key press with focus on text_nsamples and none of its controls.
function text_nsamples_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to text_nsamples (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function text_actual_distance_Callback(hObject, eventdata, handles)
% hObject    handle to text_actual_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_actual_distance as text
%        str2double(get(hObject,'String')) returns contents of text_actual_distance as a double

% Update the actual_distance
global actual_distance;
actual_distance = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function text_actual_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_actual_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

% Update the id_destination of the device
global destination_id;
destination_id = sprintf('%x',get(hObject,'String'))
destination_id = unicode2native(get(hObject,'String'),'utf-8')
hexString = dec2hex(destination_id)
destination_id = get(hObject,'String')




% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
