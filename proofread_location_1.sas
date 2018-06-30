proc sql;
create table investor as select distinct F12_T0401D,F14_T0401D from broker.T_0401D;
quit;

data nonfund;
set investor;
if F12_T0401D ne '基金';
run;

proc sql;
create table nonfund_1 as select a.*,b.province,b.branch_city from nonfund a,broker.city_2 b;
quit;

data nonfund_2;
set nonfund_1;
k=index(F12_T0401D,compress(branch_city));
if index(F12_T0401D,compress(branch_city))^=0;
m=index(F14_T0401D,compress(branch_city));
run;

data nonfund_2;
set nonfund_2;
if m^=0 and substr(F12_T0401D,k,8)=substr(F14_T0401D,m,8) then delete;
run;

proc sort;
by F12_T0401D k;
run;

data nonfund_3;
set nonfund_2;
by F12_T0401D k;
if first.F12_T0401D;
drop k m;
run;

proc sql;
create table nonfund_4 as select * from nonfund
where F12_T0401D not in (select F12_T0401D from Nonfund_3) ;
quit;



data branch_location;
set nonfund_3 nonfund_4;
run;

proc sql;
create table proofread1 as select distinct F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,home_province,home_city,branch_city,province from broker.T_0401D;
quit;


proc sql;
create table proofread2 as select a.*,b.province as province1,b.branch_city as branch_city1 from proofread1 a left join branch_location b
on a.F12_T0401D=b.F12_T0401D;
quit;

data proofread2;
set proofread2;
if F12_T0401D='基金' then branch_city1='基金';
run;

data proofread3;
set proofread2;
if compress(branch_city)^=compress(branch_city1);
run;

proc sql;
create table proofread4 as select distinct F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,branch_city,province,branch_city1,province1 from proofread3;
quit;


proc sort;
by branch_city1 branch_city;
run;
