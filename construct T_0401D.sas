proc sql;
create table investor as select distinct F12_T0401D,F14_T0401D from broker.T_0401D;
quit;

data investor;
set investor;
F12_T0401D=compress(F12_T0401D);
F14_T0401D=compress(F14_T0401D);
run;

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
by F12_T0401D F14_T0401D k;
run;

data nonfund_3;
set nonfund_2;
by F12_T0401D F14_T0401D k;
if first.F14_T0401D;
drop k m;
run;

proc sql;
create table nonfund_4 as select * from nonfund
where F12_T0401D not in (select F12_T0401D from Nonfund_3) ;
quit;

proc sql;
create table nonfund_5 as select a.*,b.province,b.branch_city from nonfund_4 a,broker.city_2 b;
quit;

data nonfund_5;
set nonfund_5;
if substr(F14_T0401D,1,4)=compress(branch_city);
run;

data nonfund_6;
set nonfund_3 nonfund_5;
run;

proc sql;
create table branch_location as select distinct * from nonfund_6;
quit;

proc sql;
create table T_0401D_1 as select distinct a.*,b.province as branch_province,b.branch_city from broker.T_0401D a left join branch_location b
on a.F12_T0401D=b.F12_T0401D and a.F14_T0401D=b.F14_T0401D;
quit;


data T_0401D_1;
set T_0401D_1;
format F3_T0401D $12.;
drop OID_T0401D OTIME_T0401D ;
run;

data address;
set broker.industry_address;
rename stock_code_1=F3_T0401D province=head_province city=head_city;
keep stock_code_1 province city;
run;

proc sort data=T_0401D_1 out=T_0401D_1;
by F3_T0401D;
run;

proc sort data=address out=address;
by F3_T0401D;
run;

data T_0401D_1;
merge T_0401D_1 address;
by F3_T0401D;
run;

data T_0401D_1;
set T_0401D_1;
length branch_type $13.;
informat branch_type $13.;
format branch_type $13.;
if F12_T0401D='基金' then branch_type='fund';
else if head_city=branch_city then branch_type='home_city';
else if head_province=branch_province then branch_type='same_province';
else if branch_province='上海' then branch_type='shanghai';
else if branch_province='北京' then branch_type='beijing';
else branch_type='other';
if head_province='上海' then head_type='shanghai';
else if head_province='北京' then head_type='beijing';
else head_type='other';
date=mdy(input(substr(compress(F1_T0401D),5,2),6.),input(substr(compress(F1_T0401D),7,2),6.),input(substr(compress(F1_T0401D),1,4),6.));
format date mmddyy.;
drop F1_T0401D F2_T0401D;
run;

proc sql;
create table T_0401D_3 as select distinct F3_T0401D,F4_T0401D,head_province,head_city,head_type,date,F5_T0401D,F6_T0401D,F7_T0401D,F8_T0401D,F9_T0401D from T_0401D_1
where F9_T0401D>'2';
quit;

proc sql;
create table T_0401D_3_1 as select distinct F3_T0401D,F4_T0401D,head_province,head_city,date,F5_T0401D,F6_T0401D,F7_T0401D,F8_T0401D,F9_T0401D,branch_type,sum(F17_T0401D+F18_T0401D) as netBS from T_0401D_1
group by F3_T0401D,date,F9_T0401D,branch_type;
quit;

proc sql;
create table T_0401D_3 as select distinct a.*,b.netBS/a.F8_T0401D as home_city from T_0401D_3 a left join T_0401D_3_1 b
on a.F3_T0401D=b.F3_T0401D and a.date=b.date and a.F9_T0401D=b.F9_T0401D and branch_type='home_city';
quit;
proc sql;
create table T_0401D_3 as select distinct a.*,b.netBS/a.F8_T0401D as same_province from T_0401D_3 a left join T_0401D_3_1 b
on a.F3_T0401D=b.F3_T0401D and a.date=b.date and a.F9_T0401D=b.F9_T0401D and branch_type='same_province';
quit;
proc sql;
create table T_0401D_3 as select distinct a.*,b.netBS/a.F8_T0401D as shanghai from T_0401D_3 a left join T_0401D_3_1 b
on a.F3_T0401D=b.F3_T0401D and a.date=b.date and a.F9_T0401D=b.F9_T0401D and branch_type='shanghai';
quit;
proc sql;
create table T_0401D_3 as select distinct a.*,b.netBS/a.F8_T0401D as beijing from T_0401D_3 a left join T_0401D_3_1 b
on a.F3_T0401D=b.F3_T0401D and a.date=b.date and a.F9_T0401D=b.F9_T0401D and branch_type='beijing';
quit;
proc sql;
create table T_0401D_3 as select distinct a.*,b.netBS/a.F8_T0401D as other from T_0401D_3 a left join T_0401D_3_1 b
on a.F3_T0401D=b.F3_T0401D and a.date=b.date and a.F9_T0401D=b.F9_T0401D and branch_type='other';
quit;
proc sql;
create table T_0401D_3 as select distinct a.*,b.netBS/a.F8_T0401D as fund from T_0401D_3 a left join T_0401D_3_1 b
on a.F3_T0401D=b.F3_T0401D and a.date=b.date and a.F9_T0401D=b.F9_T0401D and branch_type='fund';
quit;


data T_0401D_3;
set T_0401D_3;
if home_city=. then home_city=0;
if same_province=. then same_province=0;
if shanghai=. then shanghai=0;
if beijing=. then beijing=0;
if other=. then other=0;
if fund=. then fund=0;
F9=input(F9_T0401D,6.);
drop F9_T0401D;
rename F9=F9_T0401D;
run;

data T_0401D_3;
set T_0401D_3;
all=home_city+same_province+shanghai+beijing+fund+other;
home_province=home_city+same_province;
run;

data T_0401D_3;
set T_0401D_3;
if head_type='shanghai' then shanghai=home_province;
if head_type='beijing' then beijing=home_province;
run;

proc sort data=T_0401D_3 out=T_0401D_3;
by F3_T0401D F9_T0401D date;
run;

