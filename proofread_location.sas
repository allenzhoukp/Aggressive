data proofread1;
set broker.T_0401D;
keep F11_T0401D F12_T0401D F13_T0401D F14_T0401D home_province home_city branch_city province;
run;

data proofread1;
set proofread1;
branch=catx('&',F13_T0401D,F11_T0401D);
run;

proc sql;
create table proofread2 as select a.*,b.province as province1,b.branch_city as branch_city1 from proofread1 a left join branch_location b
on a.branch=b.branch;
quit;

data proofread3;
set proofread2;
if compress(branch_city)^=compress(branch_city1);
run;

proc sql;
create table proofread4 as select distinct F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,branch_city,province,branch_city1,province1 from proofread3;
quit;

proc sort;
by branch_city;
run;
