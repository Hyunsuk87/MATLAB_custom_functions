function Convert_mdl_to_slx()
% This function converts Simulink files from .mdl to .slx format.

bdclose('all');
mdlFiles = dir('*.mdl');

for n=1:length(mdlFiles)
    originalPath = fullfile(mdlFiles(n).folder, mdlFiles(n).name);
    [~, modelName] = fileparts(mdlFiles(n).name);
    newName = fullfile(mdlFiles(n).folder, [modelName '.slx']);
    
    tempPath = fullfile(tempdir, mdlFiles(n).name);
    copyfile(originalPath, tempPath);
    
    load_system(tempPath);
    
    % setting off
    set_param(modelName, 'Lock', 'off'); % Lock off
    set_param(modelName, 'PreSaveFcn', ''); % callback delete

    save_system(modelName, newName); % save as .slx
    close_system(modelName, 0);
end

end
