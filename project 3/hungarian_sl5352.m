function [assignment]= hungarian_sl5352(weight, nopts) 
%--------------------------------------------------------------------------
% function input weight matrix and number of points. Returns assignment
% mask.
% EL-GY 9143 project #3 3D image registration 
% Shuaiyu Liang(sl5352) @ NYU Tandon school of Engineering.
%--------------------------------------------------------------------------

% initializing
assignment = zeros(size(weight));
exit_flag = 1; 
step = 1; 
weight_size = size(weight,1);
%% Main function
while exit_flag 
    switch step 
      case 1 
        [weight, step] = step1(weight, nopts); 
      case 2 
        [r_cov, c_cov, Mask, step] = step2(weight); 
      case 3 
        [c_cov, step] = step3(Mask, weight_size); 
      case 4 
        [Mask, r_cov, c_cov, Z_r, Z_c, step] = step4(weight, r_cov, c_cov, Mask); 
      case 5 
        [Mask, r_cov, c_cov, step] = step5(Mask, Z_r, Z_c, r_cov, c_cov); 
      case 6 
        [weight, step] = step6(weight, r_cov, c_cov); 
      case 7 
        exit_flag = 0; 
    end 
end

assignment = Mask; 

%% step 1---------------------------------------------------------
% find min and subtract from row
function [weight, step] = step1(weight, nopts)
    rowmin = min(weight')';
    weight = weight - repmat(rowmin,1,nopts);
    step = 2;

%% step 2---------------------------------------------------------
% find zeros and cover col. if no starred zeros in its column or row, star the zero
function [r_cov, c_cov, Mask, step] = step2(weight)

    % r_cov and c_cov represent cover status of columns and rows
    % Mask that shows if a position is starred or primed
    weight_size = size(weight,1);
    r_cov = zeros(weight_size,1);  
    c_cov = zeros(weight_size,1);  
    Mask = zeros(weight_size);
    
    % Find zeros element by element
    for i = 1:weight_size
        for j = 1:weight_size
            if weight(i,j) == 0 && r_cov(i) == 0 && c_cov(j) == 0
                Mask(i,j) = 1;
                r_cov(i) = 1;
                c_cov(j) = 1;
            end
        end
    end
    step = 3;

%% step 3------------------------------------------------------
% cover each column with a starred zero. If K cols are covered, 
% go to done, otherwise go to step 4
function [c_cov, step] = step3(Mask, weight_size)
    c_cov = sum(Mask,1);
    if sum(c_cov) == weight_size
        step = 7;
    else
        step = 4;
    end
    
%% step 4------------------------------------------------------
% Find a noncovered zero and prime it.  If there is no starred 
% zero in the row containing this primed zero, Go to Step 5.   
% Otherwise, cover this row and uncover the column containing  
% the starred zero. Continue in this manner until there are no  
% uncovered zeros left. Save the smallest uncovered value and  
% Go to Step 6. 
function [Mask, r_cov, c_cov, Z_r, Z_c,step] = step4(weight,r_cov,c_cov,Mask) 
weight_size = length(weight); 
zflag = 1; % uncovered zero flag, this was to be primed
while zflag   
    % Find the first uncovered zero
    % initialize
      row = 0; col = 0; 
      exit_flag = 1; 
      i = 1; j = 1; 
      while exit_flag 
          if weight(i,j) == 0 && r_cov(i) == 0 && c_cov(j) == 0 
              row = i; 
              col = j; 
              exit_flag = 0; 
          end       
          j = j + 1;       
          if j > weight_size
              j = 1;
              i = i+1; 
          end       
          if i > weight_size 
              exit_flag = 0; 
          end       
      end 
 
    % If there are no uncovered zeros go to step 6 
      if row == 0 
        step = 6; 
        zflag = 0; 
        Z_r = 0; % uncovered zero row index
        Z_c = 0; % uncovered zero column index
      else 
        Mask(row,col) = 2; % Prime the uncovered zero 
        % If there is a starred zero in that row 
        % Cover the row and uncover the column containing the zero 
          if sum(find(Mask(row,:)==1)) ~= 0 
            r_cov(row) = 1; 
            zcol = find(Mask(row,:)==1); 
            c_cov(zcol) = 0; 
          else 
            step = 5; 
            zflag = 0; 
            Z_r = row; 
            Z_c = col; 
          end             
      end 
end 
   
%% step 5---------------------------------------------------------
% Construct a series of alternating primed and starred zeros as 
% follows.  Let Z0 represent the uncovered primed zero found in Step 4. 
% Let Z1 denote the starred zero in the column of Z0 (if any).  
% Let Z2 denote the primed zero in the row of Z1 (there will always 
% be one).  Continue until the series terminates at a primed zero 
% that has no starred zero in its column.  Unstar each starred  
% zero of the series, star each primed zero of the series, erase  
% all primes and uncover every line in the matrix.  Return to Step 3. 
function [Mask,r_cov,c_cov,step] = step5(Mask,Z_r,Z_c,r_cov,c_cov) 
zflag = 1; 
i = 1; 
while zflag 
    % Find the index number of the starred zero in the column 
    rindex = find(Mask(:,Z_c(i))==1); 
    if rindex > 0 
        % Save the starred zero 
        i = i+1; 
        Z_r(i,1) = rindex; % Save the row of the starred zero 
        % The column of the starred zero is the same as the column of the  
        % primed zero 
        Z_c(i,1) = Z_c(i-1); 
    else 
        zflag = 0; 
    end 

    % Continue if there is a starred zero in the column of the primed zero 
    if zflag == 1; 
        % Find the column of the primed zero in the last starred zeros row 
        cindex = find(Mask(Z_r(i),:)==2); 
        i = i+1; 
        Z_r(i,1) = Z_r(i-1); 
        Z_c(i,1) = cindex;     
    end     
end 

% UNSTAR all the starred zeros in the path and STAR all primed zeros 
for i = 1:length(Z_r) 
    if Mask(Z_r(i),Z_c(i)) == 1 
       Mask(Z_r(i),Z_c(i)) = 0; 
    else 
       Mask(Z_r(i),Z_c(i)) = 1; 
    end 
end 

% Clear the covers 
r_cov = r_cov.*0; 
c_cov = c_cov.*0; 

% Remove all the primes 
Mask(Mask==2) = 0; 

step = 3; 
 
%% step 6------------------------------------------------------
% Add the minimum uncovered value to every element of each covered 
% row, and subtract it from every element of each uncovered column.   
% Return to Step 4 without altering any stars, primes, or covered lines. 
function [weight,step] = step6(weight,r_cov,c_cov) 
uncov_min_col = find(r_cov == 0); 
uncov_min_row = find(c_cov == 0); 
min_value = min(min(weight(uncov_min_col,uncov_min_row))); 
 
weight(find(r_cov == 1),:) = weight(find(r_cov == 1),:) + min_value; 
weight(:,find(c_cov == 0)) = weight(:,find(c_cov == 0)) - min_value; 
 
step = 4; 