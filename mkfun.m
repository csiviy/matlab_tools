function mkfun(varargin)
% MKFUN Make a function with help text
% 
% 
%     USAGE:
%         mkfun(varargin)
%         mkfun('mkfun(varargin)', 'Make a function with help text')
%
%
%     INPUTS:
%           'funstr': (Optional) A string with the function definition
%           'descLine': (Optinoal) Single-line description of the function
%
%
%     OUTPUTS:
%
%
%     SEE ALSO:
%
%
% Chris Siviy, 10-May-2016  1:10 PM

%% Parse inputs

p = inputParser();

p.addOptional('funStr' , '' , @ischar)
p.addOptional('descLine', '', @ischar)

p.parse(varargin{:})

funStr   = p.Results.funStr;
descLine = p.Results.descLine;


%% Either create the new file or add text to the current one

if isempty(funStr) % Add to current function
    
    newFile = false;
    
    hEditor = matlab.desktop.editor.getActive;
    
    [~, funStr] = fileparts(hEditor.Filename);
   
    firstLine = textscan(hEditor.Text, '%s[\n]', 'delimiter', '\n'); % Grab the first line
    firstLine = firstLine{1}{1};
    firstLine = regexprep(firstLine, 'function[\s]*', '');
    
else
    
    newFile = true;
    
    hEditor = matlab.desktop.editor.newDocument; 
    
    firstLine = funStr; % Use the funStr input as the first line of the function
    
end

%% Get all the parts of the first line

% Outputs are everything in brackets
outStr = regexp(firstLine, '\[([^\[\]]*)\]', 'tokens');
if ~isempty(outStr)
    outStr = outStr{1}{1};
    
    outputs = strsplit(outStr, ',');
else
    outStr  = '';
    outputs = {};
end

% Inputs are in parentheses
inStr = regexp(firstLine, '\(([^\(\)]*)\)', 'tokens');
if ~isempty(inStr)
    inStr = inStr{1}{1};
    
    inputs = strsplit(inStr, ',');
else
    inStr  = '';
    inputs = {};
end

% Any characters left over are the function name (not including =, ' ',
% etc)

funName = strrep(firstLine, sprintf('[%s]', outStr), ''); % Remove outputs
funName = strrep(funName  , sprintf('(%s)', inStr) , ''); % Remove inputs
funName = regexp(funName, '[^\s=]*', 'match'); % Everything else
funName = funName{1};

%% Build up the function

str = [];

if newFile
%     hEditor.appendText(sprintf('function %s\n', firstLine))
    str = [str sprintf('function %s\n', firstLine)];
else
    str = [str sprintf('\n')];
end


% Add a line with a description of the function
% hEditor.appendText(sprintf('%% %s %s\n%% \n%% \n', upper(funName), descLine));
str = [str sprintf('%% %s %s\n%% \n%% \n', upper(funName), descLine)];

% Usage section
% hEditor.appendText(sprintf('%% \tUSEAGE:\n%% \t\t%s\n%%\n%%\n', firstLine))
str = [str sprintf('%%     USAGE:\n%%         %s\n%%\n%%\n', firstLine)];

% Inputs section
% hEditor.appendText(sprintf('%% \tINPUTS:\n'))
str = [str sprintf('%%     INPUTS:\n')];

% Figure out how long each row needs to be
maxLen = max(cellfun(@numel, [inputs,outputs]));

for i = 1:numel(inputs)
    
%     hEditor.appendText(sprintf('%% \t\t%s%s: \n', repmat(' ', maxLen-numel(inputs{i})), inputs{i}));
    str = [str sprintf('%%         %s%s: \n', repmat(' ', [1 maxLen-numel(inputs{i})]), inputs{i})];
    
end

% Outputs section
% hEditor.appendText(sprintf('%%\n%%\n%% \tOUTPUTS:\n'))
str = [str sprintf('%%\n%%\n%%     OUTPUTS:\n')];

for i = 1:numel(outputs)
    
%     hEditor.appendText(sprintf('%% \t\t%s%s: \n', repmat(' ', maxLen-numel(outputs{i})), outputs{i}));
    str = [str sprintf('%%         %s%s: \n', repmat(' ', [1 maxLen-numel(outputs{i})]), outputs{i})];
    
end

% See also section
% hEditor.appendText(sprintf('%%\n%%\n%% \tSEE ALSO:\n'))
str = [str sprintf('%%\n%%\n%%     SEE ALSO:\n')];

% Name and date
% hEditor.appendText(sprintf('%%\n%%\n%% Chris Siviy, %s\n\n', datestr(clock, 'dd-mmm-yyyy HH:MM AM'))) 
str = [str sprintf('%%\n%%\n%% Chris Siviy, %s\n\n', datestr(clock, 'dd-mmm-yyyy HH:MM AM'))];

% Add an end
str = [str sprintf('\n\nend')];
hEditor.appendText(str)




