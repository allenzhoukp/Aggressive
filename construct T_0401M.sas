proc sql;
create table investor as select distinct F12_T0401M,F14_T0401M from broker.T_0401M;
quit;

data nonfund;
set investor;
if F12_T0401M ne '基金';
run;

proc sql;
create table nonfund_1 as select a.*,b.province,b.branch_city from nonfund a,broker.city_2 b;
quit;

data nonfund_2;
set nonfund_1;
k=index(F12_T0401M,compress(branch_city));
if index(F12_T0401M,compress(branch_city))^=0;
m=index(F14_T0401M,compress(branch_city));
run;

data nonfund_2;
set nonfund_2;
if m^=0 and substr(F12_T0401M,k,8)=substr(F14_T0401M,m,8) then delete;
run;

proc sort;
by F12_T0401M F14_T0401M k;
run;

data nonfund_3;
set nonfund_2;
by F12_T0401M F14_T0401M k;
if first.F14_T0401M;
drop k m;
run;

proc sql;
create table nonfund_4 as select * from nonfund
where F12_T0401M not in (select F12_T0401M from Nonfund_3) ;
quit;

proc sql;
create table nonfund_5 as select a.*,b.province,b.branch_city from nonfund_4 a,broker.city_2 b;
quit;

data nonfund_5;
set nonfund_5;
if substr(F14_T0401M,1,4)=compress(branch_city);
run;

data nonfund_6;
set nonfund_3 nonfund_5;
run;

proc sql;
create table branch_location as select distinct * from nonfund_6;
quit;

proc sql;
create table T_0401M_1 as select distinct a.*,b.province as branch_province,b.branch_city from T_0401M a left join branch_location b
on a.F12_T0401M=b.F12_T0401M and a.F14_T0401M=b.F14_T0401M;
quit;


data T_0401M_1;
set T_0401M_1;
format F3_T0401M $12.;
drop OID_T0401M OTIME_T0401M ;
run;

data address;
set broker.industry_address;
rename stock_code_1=F3_T0401M province=head_province city=head_city;
keep stock_code_1 province city;
run;

proc sort data=T_0401M_1 out=T_0401M_1;
by F3_T0401M;
run;

proc sort data=address out=address;
by F3_T0401M;
run;

data T_0401M_1;
merge T_0401M_1 address;
by F3_T0401M;
run;

data T_0401M_1;
set T_0401M_1;
length branch_type $13.;
if F12_T0401M='基金' then branch_type='fund';
else if head_province=branch_province then branch_type='home_province';
else if branch_province='上海' then branch_type='shanghai';
else if branch_province='北京' then branch_type='beijing';
else branch_type='other';
if head_province='上海' then head_type='shanghai';
else if head_province='北京' then head_type='beijing';
else head_type='other';
startdate=mdy(input(substr(compress(F1_T0401M),5,2),6.),input(substr(compress(F1_T0401M),7,2),6.),input(substr(compress(F1_T0401M),1,4),6.));
enddate=mdy(input(substr(compress(F2_T0401M),5,2),6.),input(substr(compress(F2_T0401M),7,2),6.),input(substr(compress(F2_T0401M),1,4),6.));
format startdate mmddyy.;
format enddate mmddyy.;
drop F1_T0401M F2_T0401M F11_T0401M F13_T0401M;
run;

proc sql;
create table month as select distinct F3_T0401M,startdate,enddate from T_0401M_1
where startdate^=. and enddate^=.;
quit;

proc sort;
by F3_T0401M startdate enddate;
run;

data month;
set month;
by F3_T0401M startdate enddate;
if first.F3_T0401M then month=0;
month+1;
run;

proc sql;
create table T_0401M_2 as select distinct a.*,b.month from T_0401M_1 a left join month b
on a.F3_T0401M=b.F3_T0401M and a.startdate=b.startdate;
quit;

proc sql;
create table T_0401M_3 as select distinct F3_T0401M,F4_T0401M,head_province,head_city,head_type,startdate,enddate,month,F5_T0401M,F6_T0401M,F7_T0401M,F8_T0401M,F9_T0401M from T_0401M_2
where F9_T0401M>'2';
quit;

proc sql;
create table T_0401M_3_1 as select distinct F3_T0401M,F4_T0401M,head_province,head_city,startdate,enddate,month,F5_T0401M,F6_T0401M,F7_T0401M,F8_T0401M,F9_T0401M,branch_type,sum(F17_T0401M+F18_T0401M) as netBS from T_0401M_2
group by F3_T0401M,month,F9_T0401M,branch_type;
quit;

proc sql;
create table T_0401M_3 as select distinct a.*,b.netBS/a.F8_T0401M as home_province from T_0401M_3 a left join T_0401M_3_1 b
on a.F3_T0401M=b.F3_T0401M and a.month=b.month and a.F9_T0401M=b.F9_T0401M and branch_type='home_province';
quit;
proc sql;
create table T_0401M_3 as select distinct a.*,b.netBS/a.F8_T0401M as shanghai from T_0401M_3 a left join T_0401M_3_1 b
on a.F3_T0401M=b.F3_T0401M and a.month=b.month and a.F9_T0401M=b.F9_T0401M and branch_type='shanghai';
quit;
proc sql;
create table T_0401M_3 as select distinct a.*,b.netBS/a.F8_T0401M as beijing from T_0401M_3 a left join T_0401M_3_1 b
on a.F3_T0401M=b.F3_T0401M and a.month=b.month and a.F9_T0401M=b.F9_T0401M and branch_type='beijing';
quit;
proc sql;
create table T_0401M_3 as select distinct a.*,b.netBS/a.F8_T0401M as other from T_0401M_3 a left join T_0401M_3_1 b
on a.F3_T0401M=b.F3_T0401M and a.month=b.month and a.F9_T0401M=b.F9_T0401M and branch_type='other';
quit;
proc sql;
create table T_0401M_3 as select distinct a.*,b.netBS/a.F8_T0401M as fund from T_0401M_3 a left join T_0401M_3_1 b
on a.F3_T0401M=b.F3_T0401M and a.month=b.month and a.F9_T0401M=b.F9_T0401M and branch_type='fund';
quit;


data T_0401M_3;
set T_0401M_3;
if home_province=. then home_province=0;
if shanghai=. then shanghai=0;
if beijing=. then beijing=0;
if other=. then other=0;
if fund=. then fund=0;
run;

proc sort data=T_0401M_3 out=T_0401M_3;
by F3_T0401M F9_T0401M month;
run;


