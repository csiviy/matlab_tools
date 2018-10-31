classdef H5MatGroup
    properties
        file_location
        path_in_file
        object
        fields
    end
    methods
        function obj = H5MatGroup(file_location, path_in_file)
            if nargin == 1
                obj.object = h5info(file_location);
                obj.path_in_file = '';
            else
                obj.object = h5info(file_location, path_in_file);
                obj.path_in_file = path_in_file;
            end
            obj.file_location = file_location;
            obj.fields = AllFields(obj);
        end
        
        function groups = AllFields(obj, exclude)
            if nargin == 1
                exclude = {};
            end
            % Read all the groups, get rid of the file separator, and
            % remove unwanted ones. If this group houses either more groups
            % or datasets, use the names of those datasets
            if ~isempty(obj.object.Groups)
                all_groups = {obj.object.Groups.Name};
            elseif ~isempty(obj.object.Datasets)
                all_groups = {obj.object.Datasets.Name};
            else
                all_groups = {};
            end
            [~, all_groups] = cellfun(@fileparts, all_groups, 'uniformoutput', 0);
            groups = setdiff(all_groups, [{'#refs#'}, exclude]);
        end
        
        function new_obj = subsref(obj, ref)
            % If they're only indexing one thing and it's a property,
            % return the property
            if numel(ref) == 1 && ismember(ref.subs, properties(obj))
                new_obj = builtin('subsref', obj, ref);
            else
                new_path = strjoin({ref.subs}, '/');
                new_path = [obj.path_in_file '/' new_path];
                new_obj = FilterObjects(obj.file_location, new_path);
            end
        end
        
        % The following preserve compatibility to make it look more like a
        % struct
        function fields = fieldnames(obj)
            fields = obj.AllFields();
        end
        
        function tf = isfield(obj, fieldname)
            tf = ismember(fieldname, obj.fields);
        end
    end
end

function new_obj = FilterObjects(file_location, new_path)
% Filter through a potential new object and figure out what type of data it
% is
% Check out what kind of object the new group is
try
    new_obj_info = h5info(file_location, new_path);
catch err
    if strcmp(err.identifier, 'MATLAB:imagesci:h5info:libraryError')
            error('Path %s does not exist', new_path)
    else
            rethrow(err)
    end    
end

if isfield(new_obj_info, 'Dataspace')
    % It's a dataset. Now find out which type
    switch new_obj_info.Attributes(1).Value
        case 'char'
            new_obj = char(h5read(file_location, new_path));
        otherwise    
            new_obj = h5read(file_location, new_path);
    end
    
else
    new_obj = H5MatGroup(file_location, new_path);
end

end
