function Parameter_Modify()
% This function modifies parameters in .mat files.


% change, where your mat files are
folder_path = 'D:\Simulatoren\Parameter';
files = dir(fullfile(folder_path, '*.mat'));

for i = 1:length(files)
    filename = fullfile(files(i).folder, files(i).name);
    
    data = load(filename);
    
    % write, what you want to change
    data.Components.Sensors.MRPS1_rel_amplitude_sine = 0.5;
    data.Components.Sensors.MRPS1_rel_amplitude_cosine = 0.3;
    data.Components.Sensors.MRPS2_rel_amplitude_sine = 0.3;
    data.Components.Sensors.MRPS2_rel_amplitude_cosine = 0.3;
    
    %if isfield(data, 'my_var')
    %    data.my_var = data.my_var * 2;
    %end
     
    % overwrite
    save(filename, '-struct', 'data');
end

end