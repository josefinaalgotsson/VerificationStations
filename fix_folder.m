function z = fix_folder(t)

if not(t(end) == '\')
    z = [t '\'];
else
    z = t;
end

end