function struct1 = append_to_fields(struct1, struct2s)
for i=1:length(struct2s)
    struct2 = struct2s{i};
    for fields = fieldnames(struct2)'
        if isfield(struct1, fields{1})
            struct1.(fields{1}) = [struct1.(fields{1}); struct2.(fields{1})];
        else
            struct1.(fields{1}) = struct2.(fields{1});
        end
    end
end
end