function [dropbox_path] = GetDbPath(varargin)
% GETDBPATH Get the path the the dropbox home directory
% 
% 
%     USAGE:
%         [dropbox_path] = GetDbPath(varargin)
%
%
%     INPUTS:
%             account_type (optional): The type of account, either business
%                                      or personal (default: 'business')
%
%
%     OUTPUTS:
%         dropbox_path: 
%
%
%     SEE ALSO:
%
%
% Chris Siviy, 27-Jul-2018 11:03 AM

% Parse and check inputs
p = inputParser();
p.addOptional('account_type', 'business');

p.parse(varargin{:})

account_type = lower(p.Results.account_type);

if ~ismember(account_type, {'business', 'personal'})
    error('Valid account types are ''business'' or ''personal''')
end

% Find the home directory
if ismac
    home_dir = getenv('HOME');
    db_dir = '.dropbox';
elseif ispc
    home_dir = getenv('LOCALAPPDATA');
    db_dir = 'Dropbox';
end

info_path = fullfile(home_dir, db_dir, 'info.json');

db_info = jsondecode(fileread(info_path));

dropbox_path = db_info.(account_type).path;


end