function [outstr] = eNotation2Latex(instr)
% ENOTATION2LATEX Convert E notation to latex formatting that looks nicer
% 
% 
%     USAGE:
%         [outstr] = eNotation2Latex(instr)
%
%
%     INPUTS:
%          instr: 
%
%
%     OUTPUTS:
%         outstr: 
%
%
%     SEE ALSO:
%
% Chris Siviy, 11-Apr-2017 11:43 AM

% The pattern to match
pattern = ['^\s*(?<sign>[-+])?' ...
           '(?<number>\d+)'...
           '(?<decimal>\.\d*)?' ...
           'e(?<exponent_sign>[-+])?'...
           '(?<exponent>\d+)\s*$'];

n = regexp(instr, pattern, 'names');
n.exponent_sign = strrep(n.exponent_sign, '+', '');  % Strip out plus signs in the exponent
n.exponent = strip(n.exponent, 'left', '0');  % Strip leading zeros


% Build up the latex version
outstr = [n.sign n.number n.decimal ' \\times 10^{' n.exponent_sign n.exponent '}'];
end