function Create_Bus(num_signals)
% This function automates the creation of a Simulink model containing a Subsystem with a dynamically configured Bus Selector and Bus Creator.
% The internal wiring is automatically routed based on the user-defined number of signals.

modelName = 'AutoBusSystem';

% 1. Check if the model is already open and close it.
if bdIsLoaded(modelName)
    close_system(modelName, 0); 
end

% 2. Create new model (Blank Model)
new_system(modelName);

% 3. Open the model
open_system(modelName);

% 4. Create a Subsystem 
subsystemPath = [modelName '/MyBusSubsystem'];
add_block('simulink/Commonly Used Blocks/Subsystem', subsystemPath);

% 5. Find and Delete all lines in the Subsystem
lines = find_system(subsystemPath, 'SearchDepth', 1, 'FindAll', 'on', 'Type', 'line');
if ~isempty(lines)
    delete_line(lines);
end

% 6. Find and Delete all blocks in the Subsystem and Delete
blocks = find_system(subsystemPath, 'SearchDepth', 1, 'Type', 'block');

for i = 1:length(blocks)
    if ~strcmp(blocks{i}, subsystemPath)
        delete_block(blocks{i});
    end
end


% 7. Selector & Creator Positions and Paths
selectorPos = [150, 50, 155, 50 + (num_signals * 30)];
creatorPos  = [300, 50, 305, 50 + (num_signals * 30)];

selectorPath = [subsystemPath '/MyBusSelector'];
creatorPath = [subsystemPath '/MyBusCreator'];


% 8. Create Blocks
add_block('simulink/Sources/In1', [subsystemPath '/In1'], 'Position', [50, 100, 80, 115]);
add_block('simulink/Signal Routing/Bus Selector', selectorPath, 'Position', selectorPos);
add_block('simulink/Signal Routing/Bus Creator', creatorPath, 'Position', creatorPos);
add_block('simulink/Sinks/Out1', [subsystemPath '/Out1'], 'Position', [450, 100, 480, 115]);


% 9. Generate and configure N signal names
sigNamesCell = arrayfun(@(x) ['sig' num2str(x)], 1:num_signals, 'UniformOutput', false);
sigNamesStr = strjoin(sigNamesCell, ',');


% 10. Block parameter settings
set_param(selectorPath, 'OutputSignals', sigNamesStr);
set_param(creatorPath, 'Inputs', num2str(num_signals));


% 11. Connect In1 to Bus-Selector
add_line(subsystemPath, 'In1/1', 'MyBusSelector/1');

% 12. Connect Bus-Selector's Ports to Bus-Creator's Ports
for i = 1:num_signals
    srcPort = ['MyBusSelector/' num2str(i)];
    dstPort = ['MyBusCreator/' num2str(i)];
    add_line(subsystemPath, srcPort, dstPort);
end

% 13. Connect Bus-Creator to Out1
add_line(subsystemPath, 'MyBusCreator/1', 'Out1/1');

% 14. Auto-layout
Simulink.BlockDiagram.arrangeSystem(subsystemPath);


end