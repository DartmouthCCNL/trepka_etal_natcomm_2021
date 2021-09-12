function plot_violin_from_output(output, field_name, models)
y_array = [];
labels_array = [];

for i = 1:length(models)
    y = output.(models{i}.name).(convertCharsToStrings(field_name));
    if iscell(y)
        y = cell2mat(y);
    end
    y_array = [y_array; y'];
    labels_array = [labels_array; repmat(convertCharsToStrings((models{i}.name)),...
        length(y), 1)];
end
violinplot(y_array, labels_array);
ylabel(field_name);

end