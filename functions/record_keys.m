function [keys, is_empty] = record_keys(start_time, dur, device_num)
% Collects all keypresses for a given duration (in secs).
% Written by KGS Lab
% Edited by AS 8/2014
% Edited by FB to ignore TTLs ('5%')

% wait until keys are released
keys = [];
while KbCheck(device_num)
    if (GetSecs - start_time) > dur
        break
    end
end

% check for pressed keys
while 1
    [key_is_down, ~, key_code] = KbCheck(device_num);
    key_code(KbName('5%'))=0; % added by FB to ignore TTL signals
    if key_is_down
        keys = [keys KbName(key_code)];
        while KbCheck(device_num)
            if (GetSecs - start_time) > dur
                break
            end
        end
    end
    if (GetSecs - start_time) > dur
        break
    end
end

% label null responses and store multiple presses as an array
if isempty(keys)
    is_empty = 1;
elseif iscell(keys)
    keys = num2str(cell2mat(keys));
    is_empty = 0;
else
    is_empty = 0;
end

end
