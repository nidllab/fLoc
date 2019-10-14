function famfloc(name, start_run)
% Prompts experimenter for session parameters and executes functional
% localizer experiment used to define regions in high-level visual cortex
% selective to faces, places, bodies, and printed characters.
%
% Inputs (optional):
%   1) name -- session-specific identifier (e.g., particpant's initials)
%   2) trigger -- option to trigger scanner (0 = no, 1 = yes)
%   3) stim_set -- stimulus set (1 = standard, 2 = alternate, 3 = both)
%   4) num_runs -- number of runs (stimuli repeat after 2 runs/set)
%   5) task_num -- which task (1 = 1-back, 2 = 2-back, 3 = oddball)
%   6) start_run -- run number to begin with (if sequence is interrupted)
%
% Version 3.0 8/2017
% Anthony Stigliani (astiglia@stanford.edu)
% Department of Psychology, Stanford University

%if ismac; Screen('Preference', 'SkipSyncTests', 1); end

mfile_name = mfilename('fullpath');
[pathstr, ~, ~] = fileparts(mfile_name);
addpath([pathstr '/functions']);

% session name
if nargin < 1
    name = [];
    while isempty(deblank(name))
        name = input('Subject ID : ', 's');
    end
end

% option to trigger scanner
% if nargin < 2
%     trigger = -1;
%     while ~ismember(trigger, 0:1)
%         trigger = input('Trigger scanner? (0 = no, 1 = yes) : ');
%     end
% end
trigger=0;

% which stimulus set/s to use
% if nargin < 3
%     stim_set = -1;
% %     while ~ismember(stim_set, 1:3)                                                            %lotusea
% %         stim_set = input('Which stimulus set? (1 = standard, 2 = alternate, 3 = both) : ');   %lotusea     
%     while ~ismember(stim_set, 1:4)                                                                        %lotusea
%         stim_set = input('Which stimulus set? (1 = standard, 2 = alternate, 3 = both, 4 = custom) : ');   %lotusea
%     end
% end
stim_set = 4;
 
% number of runs to generate
% if nargin < 4
%     num_runs = -1;
%     while ~ismember(num_runs, 1:24)
%         num_runs = input('How many runs? : ');
%     end
% end
num_runs = 2;

% which task to use
% if nargin < 5
%     task_num = -1;
%     while ~ismember(task_num, 1:3)
%         task_num = input('Which task? (1 = 1-back, 2 = 2-back, 3 = oddball) : ');
%     end
% end
task_num = 1;

% which run number to begin executing (default = 1)
if nargin < 2
    start_run_string = [];
    while isempty(deblank(start_run_string))
        start_run_string = input('Run : ', 's');
    end
    start_run=str2num(start_run_string);
end


%% initialize session object and execute experiment

% setup fLocSession and save session information
session = fLocSession(name, trigger, stim_set, num_runs, task_num); % FB modified countdown
             % edit fLocSession stim_size to change the display size
session = load_seqs(session);
session_dir = (fullfile(session.exp_dir, 'data', session.id));
if ~exist(session_dir, 'dir') == 7
    mkdir(session_dir);
end
fpath = fullfile(session_dir, [session.id '_fLocSession.mat']);
save(fpath, 'session', '-v7.3');

% execute all runs from start_run to num_runs and save parfiles
fname = [session.id '_fLocSession.mat'];
fpath = fullfile(session.exp_dir, 'data', session.id, fname);
do_run='y';
for rr = start_run:num_runs
    if strcmp(do_run,'y')
        session = run_exp(session, rr);
        save(fpath, 'session', '-v7.3');
    else
        disp('Quitting.')
    end
    
    % if some runs are remaining, ask experimenter whether to continue or
    % not
    if rr~=num_runs
        do_run=    input('Do you want to continue to the next run? (y/n)   ','s');
        if ~strcmp(do_run,'y') && ~strcmp(do_run,'n') 
            do_run=input('Wrong input. Continue? Type ''y'' or ''n''.      ','s');
        end
    end
end

write_parfiles(session);

end
