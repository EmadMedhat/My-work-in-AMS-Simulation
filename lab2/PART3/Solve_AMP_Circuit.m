function [symbolic_ans numeric_ans] = Solve_AMP_Circuit(netlist_directory)
%{
Part 1: reading the netlist
Part 2: parsing the netlist
Part 3: creating the matrices
Part 4: solving the matrices
%}

%__Part 1__

%loading netlist
raw_netlist = fopen(netlist_directory);
raw_netlist = fscanf(raw_netlist, '%c');

%Deleting multiple spaces, etc. using regular expressions
netlist = regexprep(raw_netlist,' *',' ');
netlist = regexprep(netlist,' I','I');
netlist = regexprep(netlist,' R','R');

netlist = regexprep(netlist,' C','C');
netlist = regexprep(netlist,' L','L');

netlist = regexprep(netlist,' E','E');
netlist = regexprep(netlist,' G','G');



netlist = regexprep(netlist,' V','V');
netlist = regexp(netlist,'[^\n]*','match');

%__Part 2__
%You may visit "ParseNetlist.m"
[R_Node_1 R_Node_2 R_Values R_Names] = ParseNetlist(netlist, 'R');

[C_Node_1 C_Node_2 C_Values C_Names] = ParseNetlist(netlist, 'C');
[L_Node_1 L_Node_2 L_Values L_Names] = ParseNetlist(netlist, 'L');

[E_Node_1 E_Node_2 E_Values E_Names E_Node_3 E_Node_4] = ParseNetlist(netlist, 'E');
[G_Node_1 G_Node_2 G_Values G_Names G_Node_3 G_Node_4] = ParseNetlist(netlist, 'G');



[V_Node_1 V_Node_2 V_Values V_Names] = ParseNetlist(netlist, 'V');
[I_Node_1 I_Node_2 I_Values I_Names] = ParseNetlist(netlist, 'I');

[DEC n fmin fmax] = ParseNetlist(netlist, '.');


%
%
%
%
%

%Counting nodes
%Nodes should be named in order 0, 1, 2, 3, ..
%We will combine all parsed nodes, then find the maximum number which is
%the number of nodes assuming that they are named in order

nodes_list = [R_Node_1 R_Node_2 C_Node_1 C_Node_2 L_Node_1 L_Node_2  V_Node_1 V_Node_2 I_Node_1 I_Node_2 G_Node_1 G_Node_2 G_Node_3 G_Node_4 E_Node_1 E_Node_2 E_Node_3 E_Node_4];
nodes_number = max(str2double(nodes_list));


%__Part 3__
%Matrices_size = no. nodes + no. Vsources+ no.vcvs
matrices_size = nodes_number + numel(V_Names) + numel(E_Names) ;

%Z matrix
%Initialize zero matrix
unit_matrix = cell(matrices_size, 1);
for i = 1:1:numel(unit_matrix)
    unit_matrix{i} = ['0'];
end
z = unit_matrix;

%stamping Isources
for I = 1:1:numel(I_Names)
    current_node_1 = str2double(I_Node_1(I));
    current_node_2 = str2double(I_Node_2(I));
    current_name = I_Names{I};
    if current_node_1 ~= 0
        z{current_node_1} = [z{current_node_1} '-' current_name];
    end
    if current_node_2 ~= 0
        z{current_node_2} = [z{current_node_2} '+' current_name];
    end
end

%stamping Vsources
for V = 1:1:numel(V_Names)
    z{nodes_number + V} = [V_Names{V}];
end
Z = sym(z);

%X matrix
x = cell(matrices_size, 1);
for node = 1:1:nodes_number
    x{node} = ['V_' num2str(node)];
end
%Stamping Vsources
for V = 1:1:numel(V_Names)
    x{nodes_number + V} = ['I_' V_Names{V}];
end
X = sym(x);

%A matrix
%_G matirix
G = repmat(unit_matrix(1:nodes_number), 1, nodes_number);
%Stamping R
for R = 1:1:numel(R_Names)
    current_node_1 = str2double(R_Node_1(R));
    current_node_2 = str2double(R_Node_2(R));
    current_name = R_Names{R};
    if current_node_1 ~= 0
        G{current_node_1, current_node_1} = [G{current_node_1, current_node_1} '+1/' current_name];
    end
    if current_node_2 ~= 0
    G{current_node_2, current_node_2} = [G{current_node_2, current_node_2} '+1/' current_name];

        end
    if current_node_1 ~= 0 && current_node_2 ~= 0
    G{current_node_1, current_node_2} = [G{current_node_1, current_node_2} '-1/' current_name ];
        G{current_node_2, current_node_1} = [G{current_node_2, current_node_1} '-1/' current_name];
  end
end






for C = 1:1:numel(C_Names)
    current_node_1 = str2double(C_Node_1(C));
    current_node_2 = str2double(C_Node_2(C));
    current_name = C_Names{C};
    if current_node_1 ~= 0
        G{current_node_1, current_node_1} = [G{current_node_1, current_node_1} '+S*' current_name];
    end
    if current_node_2 ~= 0
%    helpp
    G{current_node_2, current_node_2} = [G{current_node_2, current_node_2} '+S*' current_name];
%
        end
    if current_node_1 ~= 0 && current_node_2 ~= 0
%helpp
    G{current_node_1, current_node_2} = [G{current_node_1, current_node_2} '-S*' current_name ];
        G{current_node_2, current_node_1} = [G{current_node_2, current_node_1} '-S*' current_name];
%
  end
end



for L = 1:1:numel(L_Names)
    current_node_1 = str2double(L_Node_1(L));
    current_node_2 = str2double(L_Node_2(L));
    current_name = L_Names{L};
    if current_node_1 ~= 0
        G{current_node_1, current_node_1} = [G{current_node_1, current_node_1} '+1/S * 1/' current_name];
    end
    if current_node_2 ~= 0
%    helpp
    G{current_node_2, current_node_2} = [G{current_node_2, current_node_2} '+1/S * 1/' current_name];
%
        end
    if current_node_1 ~= 0 && current_node_2 ~= 0
%helpp
    G{current_node_1, current_node_2} = [G{current_node_1, current_node_2} '-1/S * 1/' current_name ];
        G{current_node_2, current_node_1} = [G{current_node_2, current_node_1} '-1/S * 1/' current_name];
%
  end
end

for GG = 1:1:numel(G_Names) %VCCS
    current_node_1 = str2double(G_Node_1(GG));  %p
    current_node_2 = str2double(G_Node_2(GG));  %q
    current_node_3 = str2double(G_Node_3(GG));  %k
    current_node_4 = str2double(G_Node_4(GG));  %L
    current_name = G_Names{GG};
    
    if current_node_1 ~= 0 && current_node_3 ~= 0
        G{current_node_1, current_node_3} = [G{current_node_1, current_node_3} '+gm' ];
    end
    
    
    if current_node_1 ~= 0 && current_node_4 ~= 0
        G{current_node_1, current_node_4} = [G{current_node_1, current_node_4} '-gm' ];
    end
    
    if current_node_2 ~= 0 && current_node_3 ~= 0
        G{current_node_2, current_node_3} = [G{current_node_2, current_node_3} '-gm' ];
    end
    
        if current_node_2 ~= 0 && current_node_4 ~= 0
        G{current_node_2, current_node_4} = [G{current_node_2, current_node_4} '+gm' ];
        end

    
end

%B matrix
B = repmat(unit_matrix, 1, numel(V_Names)+numel(E_Names) );

%Stamping Vsource
for V = 1:1:numel(V_Names)
    current_node_1 = str2double(V_Node_1(V));
    current_node_2 = str2double(V_Node_2(V));
 if current_node_1 ~= 0
      B{current_node_1,V} = [B{current_node_1,V} '+' '1'];
  end
    if current_node_2 ~= 0
      B{current_node_2,V} = [B{current_node_2,V} '-' '1'];
    end
end

C = B.';

for E = 1:1:numel(E_Names)
    current_node_1 = str2double(E_Node_1(E));
    current_node_2 = str2double(E_Node_2(E));
    current_node_3 = str2double(E_Node_3(E));
    current_node_4 = str2double(E_Node_4(E));
    
 if current_node_1 ~= 0
      B{current_node_1,E+V} = [B{current_node_1,E+V} '1'];
  end
    if current_node_2 ~= 0
      B{current_node_2,E+V} = [B{current_node_2,E+V} '-1'];
    end    
    if current_node_1 ~=0
C{E+V,current_node_1}='1' ;
    end
    
        if current_node_2 ~=0
C{E+V,current_node_2}='-1' ;
        end
    
        if current_node_3 ~=0
C{E+V,current_node_3}='-u' ;
        end
                if current_node_4 ~=0
C{E+V,current_node_4}='u' ;
        end

end



%Combining all in A matrix
a = [G; C(:,1:nodes_number)];
a = [a B];
glength=length(G) ;
A = sym(a) ;


%__Part 4__
%Symbolic
symbolic_ans = A\Z ;
%Numeric
%Fetch variables values

    
for R=1:1:numel(R_Names)
  eval([R_Names{R} ' = ' num2str(R_Values{R}) ';']) ;
end

for C=1:1:numel(C_Names)
    eval([C_Names{C} ' = ' num2str(C_Values{C}) ';']);
  
end




for L=1:1:numel(L_Names)
    eval([L_Names{L} ' = ' num2str(L_Values{L}) ';']);
  
end



for V=1:1:numel(V_Names)

    % add a line here to assign voltage sources values into double variables
  eval([V_Names{V} ' = ' num2str(V_Values{V}) ';']);

    end

for I=1:1:numel(I_Names)

    % add a line here to assign voltage sources values into double variables
   eval([I_Names{I} ' = ' num2str(I_Values{I}) ';']);

end
    


for E=1:1:numel(E_Names)
   eval([E_Names{E} ' = ' num2str(E_Values{E}) ';']);
    end

for G=1:1:numel(G_Names)
   eval([G_Names{G} ' = ' num2str(G_Values{G}) ';']);
end

u=str2double(E_Values);
gm=str2double(G_Values);


fmax=str2double(fmax)  ; 
fmin=str2double (fmin) ; 
n=str2double (n) ; 

f=logspace(log10(fmin),log10(fmax),log10(fmax)*n) ;
for k=1:length(f)
            S=1i*2*pi*f(k) ;
      numeric_ans=subs(symbolic_ans);
      
      for ii = 1:1:numel(symbolic_ans)
 solv(ii,k)=double(numeric_ans(ii));
      end
end
  
  

for i = 1:1:numel(symbolic_ans)
   
    figure 
    solution=semilogx(f,20*log10(abs(solv(i,:)))) ;
    if i<=glength
    title(['v',num2str(i)]);
    else
    title(['I',num2str(i-glength)]);     
    end
    xlabel('frequency')
    ylabel('Magnitude in DB')
       grid on

end

for i = 1:1:numel(symbolic_ans)

      figure 
    solution=semilogx(f,rad2deg(angle(solv(i,:)))) ;
    
    if i<=glength
    title(['v',num2str(i)]);
    else
    title(['I',num2str(i-glength)]);     
    end
    xlabel('frequency')
    ylabel('Phase')
       grid on
end

end