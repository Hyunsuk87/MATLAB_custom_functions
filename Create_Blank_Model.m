function Create_Blank_Model()

% This function creates a blank Simulink-model.

modelName = 'Blank_Model';

% 1. Check if the model is already open and close it.
if bdIsLoaded(modelName)
    close_system(modelName, 0); 
end

% 2. Create new model (Blank Model)
new_system(modelName);

% 3. Open the model
open_system(modelName);

end