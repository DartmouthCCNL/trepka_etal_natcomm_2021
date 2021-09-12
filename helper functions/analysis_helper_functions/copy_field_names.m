function struct1 = copy_field_names(struct1, struct2s)
for i=1:length(struct2s)
    struct2 = struct2s{i};
    for fields = fieldnames(struct2)'
        struct1.(fields{1}) = struct2.(fields{1});
    end
end
end