function [Node_1 Node_2 Values Names Node_3 Node_4] = ParseNetlist(netlist, instances_key)

%{
Part 1: We loop on the netlist lines to search for the given instances' key
For each hit (instance found) we save the fist, and second nodes, value,
and name
Part 2: Evaluating prefixes
%}

Node_1 = [];
Node_2 = [];

Node_3 = [];
Node_4 = [];

Values = [];
Names = [];


%__Part 1__
%We loop starting from line_number = 2 to skip the title (the first line)
for line_number = 2:1:numel(netlist)
    line = netlist{line_number};
    %Check if the first letter in the line matches the key
    if line(1) == upper(instances_key)
        %Split the line at spaces
        splitted_line = strsplit(line);
        %Remove the empty cells due to strsplit function
        splitted_line = splitted_line(~cellfun('isempty',splitted_line));
        %Splitted_line = 'Name' 'Node_1' 'Node_2' 'Value'
        %Append each cell to its vector
  
       if instances_key=='V'
        if strcmp(splitted_line(4),'AC') || strcmp(splitted_line(4),'ac') || strcmp(splitted_line(4),'DC') strcmp(splitted_line(4),'dc')
     Node_1 = [Node_1 splitted_line(2)];
        Node_2 = [Node_2 splitted_line(3)];
        %
        %
        Values = [Values splitted_line(5)];
        Names = [Names splitted_line(1)];  
        
        Values=prefixes(Values);
   continue;
        end
       end
        
       
       
            if instances_key=='E' || instances_key=='G'
     Node_1 = [Node_1 splitted_line(2)];
        Node_2 = [Node_2 splitted_line(3)];
        Node_3 = [Node_3 splitted_line(4)];
        Node_4 = [Node_4 splitted_line(5)];
        Values = [Values splitted_line(6)];
        Names = [Names splitted_line(1)];  
        
        Values=prefixes(Values);
   continue;
        end
       
       
       
       
       
       
       
    if instances_key=='.'
       if strcmp(splitted_line(1),'.AC') || strcmp(splitted_line(1),'.ac')
     Node_1 = [splitted_line(2)];
       
        Node_2 = [splitted_line(3)]; %n
        Node_2=prefixes(Node_2);

       
        Values = [splitted_line(4)]; %fmin
        Values=prefixes(Values);

        Names = [splitted_line(5)];  %fmax    
        Names=prefixes(Names);

   continue;
       end
       continue;
    end
        
     
        Node_1 = [Node_1 splitted_line(2)];
        Node_2 = [Node_2 splitted_line(3)];
        %
        %
        Values = [Values splitted_line(4)];
        Names = [Names splitted_line(1)];
        Values=prefixes(Values);
    end




    
end
