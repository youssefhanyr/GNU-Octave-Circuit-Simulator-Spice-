% This is the GUI of a Circuit Simulator(SPICE)


f = figure('Name', 'Circuit Simulator', 'Position', [200, 100, 1000, 650], 'Color', [0.94, 0.94, 0.94]);
    uicontrol('Style', 'text', ...
              'String', 'Circuit Simulator', ...
              'Position', [400, 550, 150, 50], ...
              'FontSize', 12, ...
              'FontWeight', 'bold', ...
              'ForegroundColor', [1, 0, 0], ...
              'HorizontalAlignment', 'center');

global component_array maxnode nodes number_ofcomp texthandles comp_panel current4sourceslist freq allvoltagesources;
% each variable is for the following, arr of structs for later processing
% number of nodes, an arr that contains the node numbers, number of components
%an array of all handles of texts, the panel of components, arr of indexes for
%1st array for all places of dc and ac vs, and finally the frequency
component_array = [];
maxnode =  1;
nodes = {'0', '1'};
number_ofcomp = 1;
texthandles = [];
comp_panel = 0;
current4sourceslist = [];
freq = 0.0;
allvoltagesources = [];

% the panel for solution variables, uptop to pass it as a variable
sol_panel = uipanel('Parent', f, 'Title', 'Circuit Solution', 'Position', [0.04, 0.005, 0.35, 0.4]);

% list for depeneding starting nodes
depstart = uicontrol('Style', 'popupmenu', 'Position', [80, 280, 60, 30],...
                       'String', nodes, 'Visible', 'off');

% list for depending end nodes
depend = uicontrol('Style', 'popupmenu', 'Position', [260, 280, 60, 30],...
                     'String', nodes, 'Visible', 'off');

% the text aboce the dep start list, so as to make it disapper as well
deptext1 = uicontrol('Style', 'text', 'Position', [30, 320, 170, 20],...
                       'String', '');

% the text above the dep end list, so as to make it disapper as well
deptext2 = uicontrol('Style', 'text', 'Position', [210, 320, 170, 20],...
                       'String', '');

% the text above the freq value ip field
freq_text = uicontrol('Style', 'text', 'Position', [10, 560, 140, 20], ...
                       'String', 'Enter Ac Frequency', 'Visible', 'off');

% Frequency value ip field TODO include it in clear

freq_val_ipfield = uicontrol('Style', 'edit', 'Position', [40, 520, 80, 30] ...
                             , 'Visible', 'off', 'Value' , 0.0);
% Unit table for freq

frequnit_ipfield = uicontrol('Style', 'listbox', 'Position', [180 520, 100, 100] ...
                          , 'String', {'G', 'M', 'K', 'Base', 'm'},...
                          'Value', 1, 'Visible', 'off');

% Text above unit table for freq

frequnit_text = uicontrol('Style', 'text', 'Position', [160, 620, 140, 20], ...
                       'String', 'Enter Ac Freq unit', 'Visible', 'off');

% text above component list
uicontrol('Style', 'text', 'Position', [2, 480, 220, 20], 'String', 'Add a component');

% component list, currently has Resistance, independent dc current and voltage sources
% a placeholder for dependendt sources, and ac voltage source
comp_slide = uicontrol('Style', 'popupmenu', 'String', {'R', 'indp dc cs', ...
                             'indp dc vs', 'indp ac vs', 'inductor', 'capacitor'...
                             , 'dep vccs', 'dep cccs', 'dep vcvs', 'dep ccvs'}, ...
                       'Position', [60, 440, 100, 20], 'Max', 1, 'Min', 1, ...
                       'Callback', @(src, event) listboxcallback(src, ...
                                         depstart, depend, freq_val_ipfield, ...
                                         frequnit_ipfield, deptext1, deptext2,...
                                         freq_text, frequnit_text));
% the function sends all of the previous handles as to collect ip data from

% the input field for values of all kinds
value_ipfield = uicontrol('Style', 'edit', 'Position', [230 440, 80, 30]);

% text above the value input field
uicontrol('Style', 'text', 'Position', [220, 480, 100, 20], 'String', 'Value');
freqtext = uicontrol('Style', 'text', 'Position', [220, 580, 100, 20],...
                     'String', 'Value', 'Visible', 'off');

% units list box, giga, mega, kilo, base unit, mili, micro, nano and pico
unit_ipfield = uicontrol('Style', 'listbox', 'Position', [410 400, 100, 100] ...
                          , 'String', {'G', 'M', 'K', 'Base', 'm', 'μ', 'n', 'p'}, 'Value', 1);
uicontrol('Style', 'text', 'Position', [420, 520, 100, 20], 'String', 'Unit');

% starting node list box
start_ipfield = uicontrol('Style', 'popupmenu', 'Position', [630 470, 60, 30], 'String', nodes);

% ending node list box
end_ipfield = uicontrol('Style', 'popupmenu', 'Position', [780 470, 60, 30], 'String', nodes);
uicontrol('Style', 'text', 'Position', [610, 520, 110, 20], 'String', 'Start point (-)/(-)');
uicontrol('Style', 'text', 'Position', [755, 520, 110, 20], 'String', 'End point (+)/(>)');

% a clear button for clearing all ip fields, for clearing everything, just restart the GUI
uicontrol('Style', 'pushbutton', 'Position', [150, 360, 80, 50], 'String', 'Clear' ...
          , 'Callback', @(src, event) clearer(comp_slide, value_ipfield, unit_ipfield, ...
          start_ipfield, end_ipfield, depstart, depend, deptext1, deptext2,...
          freq_text, frequnit_text, freq_val_ipfield, frequnit_ipfield), 'ForegroundColor', [0, 0, 0]...
           ,'FontWeight', 'bold', 'FontSize', 12, 'BackgroundColor', [1, 1, 1]);

% a button for adding the component with the current ip'ed info
uicontrol('Style', 'pushbutton', 'Position', [420, 340, 80, 50], 'String', 'Add' ...
          , 'Callback', @(src, event) add_component(comp_slide, value_ipfield, unit_ipfield, ...
          start_ipfield, end_ipfield, depstart, depend, freq_val_ipfield,...
          frequnit_ipfield),...
          'ForegroundColor', [0, 0, 0]...
           ,'FontWeight', 'bold', 'FontSize', 12, 'BackgroundColor', [0, 1, 1]);

% a button to solve the system with the current info
uicontrol('Style', 'pushbutton', 'Position', [420, 250, 80, 50], 'String', 'Solve' ...
          , 'Callback', @(src, event) starterfunc(src, sol_panel, f),...
           'ForegroundColor', [0, 0, 0]...
           ,'FontWeight', 'bold', 'FontSize', 12, 'BackgroundColor', [0, 1, 0]);

% a button that generates netlists
uicontrol('Style', 'pushbutton', 'Position', [580, 330, 160, 30], 'String', 'Generate netlink' ...
          , 'Callback', @(src, event) passer(src), 'ForegroundColor', [0, 0, 0]...
           ,'FontWeight', 'bold', 'FontSize', 10, 'BackgroundColor', [0.3, 0.3, 0.3]);

% this removes the last component added, will raise a warning if nthing more can be removed
uicontrol('Style', 'pushbutton', 'Position', [780, 330, 160, 30], 'String', 'Remove component' ...
          , 'Callback', @(src, event) remove_comp(), 'ForegroundColor', [0, 0, 0]...
           ,'FontWeight', 'bold', 'FontSize', 10, 'BackgroundColor', [1, 0, 1]);

% this increases the number of nodes currently by one, adds to all the lists
uicontrol('Style', 'pushbutton', 'Position', [630, 400, 80, 30], 'String', 'Add Node' ...
          , 'Callback', @(src, event) add_node(start_ipfield, end_ipfield,...
          depstart, depend), 'ForegroundColor', [0, 0, 0]...
           ,'FontWeight', 'bold', 'FontSize', 10, 'BackgroundColor', [0, 0, 1]);

% this deccreases the no of nodes by one
uicontrol('Style', 'pushbutton', 'Position', [750, 400, 100, 30], 'String', 'Remove Node' ...
          , 'Callback', @(src, event) rmv_node(start_ipfield, end_ipfield,...
          depstart, depend), 'ForegroundColor', [0, 0, 0]...
           ,'FontWeight', 'bold', 'FontSize', 10, 'BackgroundColor', [1, 0, 0]);


% this panel contains all the current components present
comp_panel = uipanel('Parent', f, 'Title', 'Current components', 'Position', [0.53, 0.01, 0.45, 0.45]);



function passer(src)
% This function generates the netlist(Spice)
  global component_array number_ofcomp freq
  path = uigetdir();
  if path
    filename = fullfile(path, 'CircuitSimulatorGNU.civ');
    filehandler = fopen(filename, 'w')

    if filehandler != -1
      AC = 0;
      fprintf(filehandler, '***** This is the circuit you inputted ******  \n') % first line is usually ignored
      for i = 1:length(component_array)
        componentname = component_array(i).type;
        unit = component_array(i).unit;
        if strcmp(unit, 'Base')
          unit = '';
        endif
        switch componentname

          case 'R'                                                      % the space before \n fixed everything
            fprintf(filehandler, 'R%d %d %d %.3f \n', i, ...
            component_array(i).endpoint, component_array(i).startpoint, ...
            component_array(i).value)

          case 'indp dc vs'
            fprintf(filehandler, 'V%d %d %d %.3f \n', i, ...
            component_array(i).endpoint, component_array(i).startpoint, ...
            component_array(i).value)

          case 'indp dc cs'
            fprintf(filehandler, 'I%d %d %d %.3f \n', i, ...
            component_array(i).endpoint, component_array(i).startpoint, ...
            component_array(i).value)

          case 'indp ac vs'
            fprintf(filehandler, 'V%d %d %d AC %f SIN(0 %.3f %.3f)\n', i, ...
            component_array(i).endpoint, component_array(i).startpoint, ...
            component_array(i).value, component_array(i).value, freq)
            AC = 1;

          case 'inductor'
            fprintf(filehandler, 'L%d %d %d %f\ n', i, ...
            component_array(i).endpoint, component_array(i).startpoint, ...
            component_array(i).value)

          case 'capacitor'
            fprintf(filehandler, 'C%d %d %d %f \n', i, ...
            component_array(i).endpoint, component_array(i).startpoint, ...
            component_array(i).value)

          case 'dep cccs'
            fprintf(filehandler, 'F%d %d %d V%d %.3f \n', i, ...
            component_array(i).endpoint, component_array(i).startpoint, ...
            find_battery_amonglist(component_array(i).dep_startp, component_array(i).dep_endp, 1),...
            component_array(i).value)

          case 'dep vccs'
            fprintf(filehandler, 'G%d %d %d %d %d %.3f \n', i, ...
            component_array(i).endpoint, component_array(i).startpoint, ...
            component_array(i).dep_endp, component_array(i).dep_startp,...
            component_array(i).value)

          case 'dep vcvs'
            fprintf(filehandler, 'E%d %d %d %d %d %.3f \n', i, ...
            component_array(i).endpoint, component_array(i).startpoint, ...
            component_array(i).dep_endp, component_array(i).dep_startp,...
            component_array(i).value)

          case 'dep ccvs'
            fprintf(filehandler, 'H%d %d %d V%d %.3f \n', i, ...
            component_array(i).endpoint, component_array(i).startpoint, ...
            find_battery_amonglist(component_array(i).dep_startp, component_array(i).dep_endp, 1),...
            component_array(i).value)

        endswitch
      endfor
      if AC == 0
        fprintf(filehandler, '.op \n');
      else
        fprintf(filehandler, '.AC DEC 10 10 %.3f ', freq)
      endif
      fprintf(filehandler, '.end');
      fclose(filehandler);
      disp('File Saved succefully')
    else
      disp("Couldn't create, the file, re check the path..")
    endif
  else
    disp('didnt get a path, aborting..')
  endif


endfunction

function clearer(h1, h2, h3, h4, h5, h6, h7, deptext1, deptext2, frqtxt1, frqtxt2,...
                  h8, h9)

% callback function for the call function, clears all ip fields, and adjusts text
  set(h1, 'Value', 1);          % i should probably name each one, oh well :p
  set(h2, 'String', '0.0');
  set(h3, 'Value', 1);
  set(h4, 'Value', 1);
  set(h5, 'Value', 1);
  set(h6, 'Value', 1);
  set(h7, 'Value', 1);
  set(h8, 'Value', 0.0);
  set(h9, 'Value', 1);
  make_depnodes_visible(h1, h6, h7, deptext1, deptext2);
  make_freq_visible(h1, h8, h9, frqtxt1, frqtxt2);

endfunction

function listboxcallback(src, menu1, menu2, field, table, txt1, txt2, txt3, txt4)
  % control function that calls for vis/invis if needed
  value = get(src, 'String'){get(src, 'Value'), 1};
  if strcmp(value, 'testers') || strcmp(value, 'dep vccs') || ...
    strcmp(value, 'dep cccs') || strcmp(value, 'dep vcvs') ||...
    strcmp(value, 'dep ccvs') || ...
    (strcmp(get(menu1, 'Visible'), 'on') && (~strcmp(value, 'testers') ||...
     ~strcmp(value, 'dep vccs') || ~strcmp(value, 'dep cccs')) ...
     || ~strcmp(value, 'dep vcvs') || ~~strcmp(value, 'dep ccvs'))
    make_depnodes_visible(src, menu1, menu2, txt1, txt2);
  endif
  if strcmp(value, 'indp ac vs') || (strcmp(get(field, 'Visible'), 'on') &&...
                                   ~strcmp(value, 'indp ac vs'))
    make_freq_visible(src, field, table, txt3, txt4);
  endif
endfunction

function make_depnodes_visible(src, menu1, menu2, text1, text2)

  % dep start nodes and end are by def invisible, this makes them visible
 value = get(src, 'String'){get(src, 'Value'), 1};
 if strcmp(value, 'testers') || strcmp(value, 'dep vccs') || ...
    strcmp(value, 'dep cccs') || strcmp(value, 'dep vcvs') || ...
    strcmp(value, 'dep ccvs')
   set(menu1, 'Visible', 'on');
   set(menu2, 'Visible', 'on');
   set(text1, 'String', 'Depending start node (-)/(-)');
   set(text2, 'String', 'Depending end node (+)/(>)');

 else

   set(menu1, 'Visible', 'off');
   set(menu2, 'Visible', 'off');
   set(menu1, 'Value', 1);
   set(menu2, 'Value', 1);
   set(text1, 'String', '');
   set(text2, 'String', '');
 endif

endfunction

function make_freq_visible(src, field, table, text1, text2)
  % freq ip field and unit table are invis, this makes them visible
  value = get(src, 'String'){get(src, 'Value'), 1};
  if strcmp(value, 'indp ac vs')
    set(field, 'Visible', 'on');
    set(table, 'Visible', 'on');
    set(text1, 'Visible', 'on');
    set(text2, 'Visible', 'on');

  else

    set(field, 'Visible', 'off');
    set(table, 'Visible', 'off');
    set(text1, 'Visible', 'off');
    set(text2, 'Visible', 'off');
   endif
endfunction

function starterfunc(src, panel, f)
 % NAME CHANGE DUE, this is the solve function 09/07/2024 i aint changing it
 global maxnode number_ofcomp component_array current4sourceslist;
 j = 0;
 k = 1;
 current4sourceslist = [];

 cccsid = [];
 ccvsid = [];
 for i = 1:length(component_array)
   if strcmp(component_array(i).type, 'indp dc vs') || ...
     strcmp(component_array(i).type, 'indp ac vs') ||...
     strcmp(component_array(i).type, 'dep vcvs') ||...
     strcmp(component_array(i).type, 'dep ccvs')
     j += 1;
   endif

 endfor

  % creates the matrices, Y is for normal stamps like R and L and C, adds them all
  % I is for all the RHS of equ's
  % A is Y for its size, and rows and cols for same no of vs's
  % adjusts the extra rows and cols then adds the pre finished Y to the rest
  Y = zeros(maxnode);
  I = zeros(maxnode+j, 1);
  A = -1;
  % Looping over the struct array

 for i = 1:length(component_array)
   startp = component_array(i).startpoint;
   endp = component_array(i).endpoint;
   depstartp = component_array(i).dep_startp;
   dependp = component_array(i).dep_endp;

   if strcmp(component_array(i).type, 'dep cccs')   % skips cccs and ccvs until all batteries have been proccessed
     cccsid(end+1) = i;
     continue;
   elseif strcmp(component_array(i).type, 'dep ccvs')
     ccvsid(end+1) = i;
     continue
   endif

   if strcmp(component_array(i).type, 'capacitor')% i should have made this into  switch case instead, oh well 09/07/2024
     addant = component_array(i).value;
   else
     addant = 1/component_array(i).value;
   endif
   if strcmp(component_array(i).type, 'R') || ...
      strcmp(component_array(i).type, 'inductor')...
       || strcmp(component_array(i).type, 'capacitor') % Checks for gnd nodes the adjust stamps
     if startp == 0
       Y(endp, endp) += addant

     elseif endp == 0
       Y(startp, startp) += addant

     else
       disp([startp, endp])
       Y(min(startp, endp):max(startp, endp), min(startp, endp):max(startp, endp)) ...
       += component_array(i).mat

   endif
% fix zero conditions in the morning chatgpt messedup pq zeroes matter
   elseif strcmp(component_array(i).type, 'dep vccs')
   pstart = startp;
   pend = endp;
   pdepstart = depstartp;
   pdepend = dependp;

   if depstartp == 0    % adjusting gnd nodes
     pdepstart = 1;

   elseif dependp == 0
     pdepend = 1;

   endif

   if startp == 0
     Y(endp, min(pdepstart, pdepend):max(pdepstart, pdepend)) += ...  % skip the bottom row and add the rows to each other
                                        component_array(i).mat(end, :)
   elseif endp == 0
     Y(startp, min(pdepstart, pdepend):max(pdepstart, pdepend)) += ...    % same here
                                          component_array(i).mat(1, :)
   else
     Y(min(pstart, pend):max(pstart, pend), min(pdepstart, pdepend):max(pdepstart, pdepend)) += ...
                                          component_array(i).mat
   current4sourceslist(end+1) = i;
   endif

   elseif strcmp(component_array(i).type, 'indp dc cs') % checks for dc indp cs to add
     if startp == 0                               % them to I
       I(endp, 1) += component_array(i).value
     elseif endp == 0
       I(startp, 1) -= component_array(i).value
     else
       I(endp, 1) += component_array(i).value
       I(startp, 1) -= component_array(i).value
     endif

    % This handles vcvs commponents
    elseif strcmp(component_array(i).type, 'dep vcvs')
       if A == -1                       % Creates A if itsnt already
         A = zeros(maxnode + j)
       endif

       if startp == 0             % places the 1's and -1's accordingaly, no need to check for the battery
         A(maxnode+k, endp) = 1;
         A(endp, maxnode+k) = 1;
       elseif endp == 0
         A(maxnode+k, startp) = -1;
         A(startp, maxnode+k) = -1;
       else
         A(maxnode+k, startp) = -1;
         A(startp, maxnode+k) = -1;
         A(maxnode+k, endp) = 1
         A(endp, maxnode+k) = 1
       endif

       if depstartp == 0
         A(maxnode+k, dependp) = -component_array(i).value
       elseif dependp == 0
         A(maxnode+k, depstartp) = component_array(i).value
       else
         A(maxnode+k, depstartp) = component_array(i).value
         A(maxnode+k, dependp) = -component_array(i).value
        endif
       k += 1;
       current4sourceslist(end+1) = i;

    elseif strcmp(component_array(i).type, 'indp dc vs') || ...
            strcmp(component_array(i).type, 'indp ac vs') % Checks for them to adjust A
     if A == -1                       % Creates A if itsnt
       A = zeros(maxnode + j)
     endif

     if endp == 0               % checks for gnd nodes to adjust stamp
       A(maxnode+k, startp) = -1  % k  is the number of the order of the curnt vs
       A(startp, maxnode+k) = -1  % so as to put in it in right col and row and
                                  % to display results later on
     elseif startp == 0
       A(maxnode+k, endp) = 1
       A(endp, maxnode+k) = 1

     else
       A(maxnode+k, endp) = 1
       A(endp, maxnode+k) = 1
       A(startp, maxnode+k) = -1
       A(maxnode+k, startp) = -1

     endif

     current4sourceslist(end+1) = i;
     I(k+maxnode, 1) = component_array(i).value
     k += 1;
   endif
 endfor

 % Handles cccs's, finds if the dummy vs is a real one and proceeds to either update the col and rows
 % or make a new one and update k
 if length(cccsid) != 0
   for cccs_i = 1:length(cccsid)

     startp = component_array(cccsid(cccs_i)).startpoint;
     endp = component_array(cccsid(cccs_i)).endpoint;
     depstartp = component_array(cccsid(cccs_i)).dep_startp;
     dependp = component_array(cccsid(cccs_i)).dep_endp;

     k_ans = find_battery(current4sourceslist, component_array(cccsid(cccs_i)));

    if k_ans != -1         % will never fail
       kpivot = k_ans;    
      endif

    mode = 0;         % change to use the normal cccs stamp, im keeping it this way because this one gave the closest answers
    if mode == 0

      if startp != 0
        A(startp, maxnode+k) = -1
      endif

      if endp != 0
        A(endp, maxnode+k) = 1
      endif

      A(maxnode+k, maxnode+k) = 1
      A(maxnode+k, kpivot+maxnode) = -component_array(cccsid(cccs_i)).value
      I(maxnode+k, 1) = 0

    else                  % even though both didn't get LTSpice's answers for some reason

      if startp != 0
        A(startp, maxnode+kpivot) = component_array(cccsid(cccs_i)).value
      endif

      if endp != 0
        A(endp, maxnode+kpivot) = -component_array(cccsid(cccs_i)).value
      endif

    endif

  endfor

  if mode == 0
    k += 1;
  endif

 endif

 % Handles ccvs's, finds if the dummy vs is a real one and proceeds to either update the col and rows
 % or make a new one and update k
  if length(ccvsid) != 0
     for ccvs_i = 1:length(ccvsid)

       startp = component_array(ccvsid(ccvs_i)).startpoint;
       endp = component_array(ccvsid(ccvs_i)).endpoint;
       depstartp = component_array(ccvsid(ccvs_i)).dep_startp;
       dependp = component_array(ccvsid(ccvs_i)).dep_endp;

       k_ans = find_battery(current4sourceslist, component_array(ccvsid(ccvs_i)))

       if k_ans != -1
         kpivot = k_ans       % k_ans will always be there, else the component wont get through anyway
         kpivot2 = k           
       endif

         I(kpivot2 + maxnode, 1) = 0      
         current4sourceslist(end+1) = ccvsid(ccvs_i);
         A(maxnode+kpivot2, maxnode+kpivot) = -component_array(ccvsid(ccvs_i)).value
         if endp == 0
           A(startp, maxnode+kpivot2) = -1
           A(maxnode+kpivot2, startp) = -1
         elseif startp == 0
           A(endp, maxnode+kpivot2) = 1
           A(maxnode+kpivot2, endp) = 1
         else
           A(maxnode+kpivot2, endp) = 1
           A(endp, maxnode+kpivot2) = 1
           A(maxnode+kpivot2, startp) = -1
           A(startp, maxnode+kpivot2) = -1
         endif
     k += 1;
    endfor
   endif


 if A == -1
   v = inv(Y)*I     % Solving by getting inv is temp, might change later
                        %SIKE IM NOT CHANGING IT
 else

   A(1:maxnode, 1:maxnode) += Y    % Inserting Stamps into A for the final answs
   v = inv(A)*I

 endif

 % Calling to display the answers
 showanswers(v, current4sourceslist, panel, k, f);
endfunction

function k = find_battery(currentindexlist, cccs_struct)
  % This looks if the dep nodes of a cccs is an actual battery and to fine the k count for sources
  global component_array
  depstartp = cccs_struct.dep_startp;
  dependp = cccs_struct.dep_endp;
  vccscount = 0;
  k = -1;
  for i = 1:length(currentindexlist)
    if component_array(currentindexlist(i)).startpoint== depstartp && ...
      component_array(currentindexlist(i)).endpoint == dependp ... &&
      (strcmp(component_array(currentindexlist(i)).type, 'indp ac vs') || ...
      strcmp(component_array(currentindexlist(i)).type, 'indp dc vs'))

      k = i - vccscount;
      break
    endif
    if strcmp(component_array(currentindexlist(i)).type, 'dep vccs')
      vccscount += 1;
    endif
  endfor

endfunction

function k = find_battery_amonglist(depstartp, dependp, mode)
  % Find if a dummy or a real battery exists for ccvs or cccs
  global allvoltagesources
  k = -1;
  for n = 1:length(allvoltagesources)
    if (allvoltagesources(n).startpoint== depstartp && ...
       allvoltagesources(n).endpoint == dependp) || (allvoltagesources(n).startpoint== dependp && ...
       allvoltagesources(n).endpoint == depstartp)

      if mode == 0
        k = n;
      else
        k = allvoltagesources(n).number;
      endif

      break
    endif
  endfor

endfunction

function showanswers(answers, currentanswers, panel, k, f)
  % Displays the answers
 global component_array maxnode

 % Resets the solution panel instead of deleting past solutions
 panel = uipanel('Parent', f, 'Title', 'Circuit Solution', 'Position', [0.04, 0.005, 0.35, 0.4]);

 % This loops over all rows and cols for node equ's and extra 1s for vs's
 for i = 1:maxnode+k - 1

   if i <= maxnode
     if iscomplex(answers(i, 1))
       msg = sprintf('V%d0 %.5f + %.5fj', i, real(answers(i, 1)), imag(answers(i, 1)));
     else
       msg = sprintf('V%d0 %.5f', i, answers(i, 1));
     endif
     uicontrol(panel, 'Style', 'text', 'String', msg, 'Position', [4, 225 - 15*(i - 1), 230, 20])

   else         % there is an extra iteration that happens, idk why, but its harmless so im leaving it

    if strcmp(component_array(currentanswers(i - maxnode)).type, 'dep cccs')
        startp = component_array(currentanswers(i - maxnode)).dep_startp;
        endp = component_array(currentanswers(i - maxnode)).dep_endp;

%{    elseif strcmp(component_array(currentanswers(i - maxnode)).type, 'dep ccvs')
        startp = component_array(currentanswers(i - maxnode)).startpoint;
        endp = component_array(currentanswers(i - maxnode)).endpoint;
                                                                        
        if iscomplex(answers(i, 1))
        msg = sprintf('I%d%d %.5f + %.5fj', component_array(currentanswers(i - maxnode)).dep_endp,...
                    component_array(currentanswers(i - maxnode)).dep_startp,...
                    real(answers(i, 1)), imag(answers(i, 1)));          % since it prints
        else
          msg = sprintf('I%d%d %.3f', component_array(currentanswers(i - maxnode)).dep_endp,...
                    component_array(currentanswers(i - maxnode)).dep_startp, answers(i, 1));
          uicontrol(panel, 'Style', 'text', 'String', msg, 'Position', [4, 225 - 15*(i - 1), 230, 20]);
          i += 1;
        endif
        %} % i think this was the cultprit
     else
        startp = component_array(currentanswers(i - maxnode)).startpoint
        endp = component_array(currentanswers(i - maxnode)).endpoint
     endif
     if iscomplex(answers(i, 1))
       msg = sprintf('I%d%d %.5f + %.5fj', endp,...
                   startp,...
                   real(answers(i, 1)), imag(answers(i, 1)));
     else
       msg = sprintf('I%d%d %.3f', endp,...
                   startp, answers(i, 1));
     endif

     uicontrol(panel, 'Style', 'text', 'String', msg, 'Position', [4, 225 - 15*(i - 1), 230, 20]);

   endif
 endfor

endfunction

function add_node(st_node, end_node, dep_start_node, dep_end_node)
% This is to increase the number of nodes and update lists, dep including

  global maxnode nodes;


  maxnode += 1;
  nodes(end+1) = num2str(maxnode);
  set(st_node, 'String', nodes);
  set(end_node, 'String', nodes);
  set(dep_start_node, 'String', nodes);
  set(dep_end_node, 'String', nodes);


endfunction

function rmv_node(st_node, end_node, dep_start_node, dep_end_node)
% This is to decrease the number of nodes and update lists, dep including

  global maxnode nodes;

  if maxnode > 1
    maxnode -= 1;
    nodes(end) = [];
    set(st_node, 'String', nodes);
    set(end_node, 'String', nodes);
    set(dep_start_node, 'String', nodes);
    set(dep_end_node, 'String', nodes);

  else

    warndlg('Cant remove any more nodes!');

  endif

endfunction

function remove_comp()
 % This to remove the last component added
  global number_ofcomp component_array texthandles allvoltagesources freq;

  if number_ofcomp > 1
  number_ofcomp -= 1;
  name = component_array(end).type;
  component_array(end) = [];
  set(texthandles(end), 'String', '');
  texthandles(end) = [];
  if strcmp(name, 'indp ac vs')
    freq = 0.0;
    uicontrol('Style', 'text', 'String', '','Position', [520, 580, 440, 10]);
    allvoltagesources(end) = [];

  elseif strcmp(name, 'indp dc vs')
    allvoltagesources(end) = [];
  endif

else

    warndlg('Cant remove any more components!');

  endif
endfunction

function add_component(h1, h2, h3, h4, h5, h6, h7, h8, h9)
% This adds the component according to the ip'ed info

  global component_array maxnode texthandles number_ofcomp comp_panel rmvspc freq allvoltagesources;

  % Extracts and converts data from all ips
  component_name = get(h1, 'String'){get(h1, 'Value'), 1};
  value = str2double(get(h2, 'String'));
  unit = get(h3, 'String'){get(h3, 'Value'), 1}
  startp = str2num(get(h4, 'String'){get(h4, 'Value'), 1});
  endp = str2num(get(h5, 'String'){get(h5, 'Value'), 1});
  depstartp = str2num(get(h6, 'String'){get(h6, 'Value'), 1});
  dependp = str2num(get(h7, 'String'){get(h7, 'Value'), 1});
  freqvalue = str2double(get(h8, 'String'));
  frequnit = get(h9, 'String'){get(h9, 'Value'), 1};



   if ~isfloat(value) && ~iscomplex(value)
      warndlg('Wrong type of value for the component please enter a float number or a cmplx')

   elseif ~isfloat(freq) || freq < 0.0
      warndlg('Wrong type of value for the frequency, please enter a float number');
   elseif (startp == endp ||...
      (dependp == depstartp && strcmp(get(h6, 'Visible'), 'on')))
           warndlg('Wrong starting or end point, cant have something connected to itself')

   elseif (strcmp(component_name, 'dep cccs') || strcmp(component_name, 'dep ccvs')) && ....
      find_battery_amonglist(depstartp, dependp, 0) == -1                               % Size of the A might be right
    warndlg('Must have a voltage source sort of any sort present between the two nodes')    % but all components will be parallel with the battery
    
   else

    oldvalue = value;
    value = scaleswitch(unit, value);
    if strcmp(component_name, 'indp ac vs')

      freq = scaleswitch(frequnit, freqvalue);
    endif

    if strcmp(component_name, 'inductor') || strcmp(component_name, 'capacitor')
      s = 2*pi*freq;
      value = value*s*i;
    endif

    if (strcmp(component_name, 'inductor') && freq == 0)                % if no frequency treat the inductor as a dummy voltage
      component = struct('type', 'indp dc vs', 'unit', unit, 'value', 0 ...
        , 'startpoint', startp, 'endpoint', endp, 'mat', NaN,...
        'dep_startp', depstartp, 'dep_endp', dependp, 'oldvalue', oldvalue, 'number', number_ofcomp);

    elseif (component_name == 'R' || strcmp(component_name, 'inductor'))...
      &&  startp != 0 && endp != 0 % creates the stamps
                                                      % for R's and L's and C's

      if abs(startp - endp) == 1                                          % 2x2 mat if two consective nodes
        mater = [1/value, -1/value ; -1/value, 1/value];
      else

        mater = zeros(abs(startp - endp) + 1, abs(startp - endp) + 1);        % makes a large if two nodes are not consective
        mater(1, 1) = 1/value;
        mater (1, end) = -1/value;
        mater (end, 1) = -1/value;
        mater(end, end) = 1/value;
      endif

    elseif strcmp(component_name, 'capacitor')
      if freq == 0
        component = struct('type', 'indp dc cs', 'unit', unit, 'value', 0 ...             % treat the capacitor as zero current source
         , 'startpoint', startp, 'endpoint', endp, 'mat', NaN,...
         'dep_startp', depstartp, 'dep_endp', dependp, 'oldvalue', oldvalue, 'number', number_ofcomp);

      elseif abs(startp - endp) == 1
        mater = [value, -value; -value, value];

      else
        mater = zeros(abs(startp - endp) + 1, abs(startp - endp) + 1);
        mater(1, 1) = value;
        mater (1, end) = -value;
        mater (end, 1) = value;
        mater(end, end) = -value;
      endif

    elseif strcmp(component_name, 'dep vccs')
      oingo = 0;        % they are to subsitute the 1 from the gnd nodes, so as to not compromise the size
      bingo = 0;
      if startp == 0 || endp == 0
        oingo = 1;
      endif
      if dependp == 0 || depstartp == 0
        bingo = 1;
      endif
      mater = zeros(abs(startp - endp) + 1- oingo, abs(depstartp - dependp) + 1-bingo)
      mater(1, 1) = value
      mater(1, end) = -value

      if size(mater, 1) > 1
        mater(end, 1) = -value
        mater(end, end) = value
      endif

      if depstartp == 0 % l
        mater(1, end) = 0
        mater(end, end) = 0
      elseif depndp == 0 % k      i found the a notebook on github that does the opposite with these, im sticking to my sources
        mater(1, 1) = 0
        mater(end, 1) = 0
      endif
      if endp == 0 && size(mater, 1) > 1 % j
        mater(end, :) = 0
      elseif startp == 0 && size(mater, 1) > 1 % i
        mater(1, :) = 0
      endif
      if dependp > depstartp                  % Switch the elements if N+ is Greater than N- So everything gets added right
        swithcher = [mater(1, end) ; mater(end, end)]
        mater(1, end) = mater(1, 1)
        mater(end, end) = mater(end, 1)
        mater(1, 1) = swithcher(1)
        mater(end, 1) = swithcher(end, 1)
      endif
    else
   % Will not call this attr if it has a gnd node, will adjust A with value only
      mater = NaN;      % i dont think this line is of any use may delete may not dont care
    endif

   % Constructs the struct with all the needed ips for later
    if ~((strcmp(component_name, 'inductor') || strcmp(component_name, 'capacitor')) && freq == 0)
      component = struct('type', component_name, 'unit', unit, 'value', value ...
       , 'startpoint', startp, 'endpoint', endp, 'mat', mater,...
       'dep_startp', depstartp, 'dep_endp', dependp, 'oldvalue', oldvalue, 'number', number_ofcomp);
    endif

   % Adds the last added component
    component_array= [component_array, component];

    if strcmp(component_name, 'indp ac vs')
      % to set the frequecy
      message = sprintf(...
       'Frequency is set to %.2f',...
       freq);
      id = uicontrol('Style', 'text', 'String', message, ...,
       'Position', [520, 580, 440, 10]);
    endif

    if strcmp(component_name, 'testers') || strcmp(component_name, 'dep vccs') ...
      || strcmp(component_name, 'dep cccs') || strcmp(component_name, 'dep vcvs') ...
      || strcmp(component_name, 'dep ccvs')

      % message for all dependent components

      message = sprintf(...
       '%s%d of value %.2f from %d to %d and depends on source between %d %d',...
       component_name, number_ofcomp, value, startp, endp, depstartp, dependp);
       id = uicontrol(comp_panel, 'Style', 'text', 'String', message, ...,
       'Position', [15, 260 - 15*(number_ofcomp - 1), 440, 10]);
      texthandles = [texthandles, id];
      number_ofcomp += 1;

    elseif strcmp(component_name, 'indp ac vs') || ...
    strcmp(component_name, 'inductor') || strcmp(component_name, 'capacitor')
      % Message for all components indp ac
      realpart = real(value);
      cmplxpart = imag(value);
      if strcmp(component_name, 'capacitor') || strcmp(component_name, 'inductor')
        message = sprintf('%s%d of value %.2f%s from node %d to node %d',...
                          component_name, number_ofcomp, oldvalue,...
                           unit, startp, endp);

      else
        message = sprintf('%s%d of value %.2f + %.2fj from node %d to node %d',...
                          component_name, number_ofcomp, realpart,...
                           cmplxpart, startp, endp);
      endif

      id = uicontrol(comp_panel, 'Style', 'text', 'String', message, ...,
      'Position', [30, 260 - 15*(number_ofcomp - 1), 330, 15]);

      texthandles = [texthandles, id];
      number_ofcomp += 1;
    else

    % Message for all components indp dc
      if ~strcmp(unit, 'Base')
        message = sprintf('%s%d of value %.2f%s from node %d to node %d',...
                          component_name, number_ofcomp, oldvalue, unit, startp, endp);
      else
        message = sprintf('%s%d of value %.2f from node %d to node %d',...
                          component_name, number_ofcomp, value, startp, endp);
      endif
      id = uicontrol(comp_panel, 'Style', 'text', 'String', message, ...,
      'Position', [15, 260 - 15*(number_ofcomp - 1), 300, 10]);

      texthandles = [texthandles, id];
      number_ofcomp += 1;
    endif
   endif

   if strcmp(component_name, 'indp ac vs') || strcmp(component_name, 'indp dc vs')
    allvoltagesources = [allvoltagesources, component];
   endif

  endfunction

function result = scaleswitch(unit, value)
  %Multiplies the value given according to its decimal unit
  switch unit
    case 'G'
      result = value*(10^9);
    case 'M'
      result = value*(10^6);
    case 'K'
      result = value*(10^3);
    case 'm'
      result = value*(10^-3);
    case 'μ'
      result = value*(10^-6);
    case 'n'
      result = value*(10^-9);
    case 'p'
      result = value*(10^-12);
    otherwise
      result = value;
  endswitch
endfunction
