function [Values] = prefixes(Values)

symbols = {'f', 'p', 'n', 'u', 'm', 'k', 'meg', 'g', 't'};
factors = [1e-15 1e-12 1e-9 1e-6 1e-3 1e3 1e6 1e9 1e12];
for value_number = 1:1:numel(Values)
    value  = Values{value_number};
    strrep(value, 'A', '');
    strrep(value, 'V', '');
    strrep(value, 'ohm', '');
    %Add 000 to avoid errors in the checking processes
    value = strcat('000', value);
    %check if it's meg
    checked_prefix = ismember(symbols, lower(value(end-2:end)));
    if any(checked_prefix)
        value = str2num(value(1:end-3)) * factors(checked_prefix);
        value = num2str(value);
    end

    %check if it's any prefix else
    checked_prefix = ismember(symbols, lower(value(end)));
    if any(checked_prefix)
        value = str2num(value(1:end-1)) * factors(checked_prefix);
        value = num2str(value);
    end
    Values(value_number) = cellstr(value);
end
end