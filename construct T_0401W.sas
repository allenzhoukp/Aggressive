proc sql;
create table investor as select distinct F12_T0401W,F14_T0401W from broker.T_0401W;
quit;

data nonfund;
set investor;
if F12_T0401W ne '基金';
run;

proc sql;
create table nonfund_1 as select a.*,b.province,b.branch_city from nonfund a,broker.city_2 b;
quit;

data nonfund_2;
set nonfund_1;
k=index(F12_T0401W,compress(branch_city));
if index(F12_T0401W,compress(branch_city))^=0;
m=index(F14_T0401W,compress(branch_city));
run;

data nonfund_2;
set nonfund_2;
if m^=0 and substr(F12_T0401W,k,8)=substr(F14_T0401W,m,8) then delete;
run;

proc sort;
by F12_T0401W F14_T0401W k;
run;

data nonfund_3;
set nonfund_2;
by F12_T0401W F14_T0401W k;
if first.F14_T0401W;
drop k m;
run;

proc sql;
create table nonfund_4 as select * from nonfund
where F12_T0401W not in (select F12_T0401W from Nonfund_3) ;
quit;

proc sql;
create table nonfund_5 as select a.*,b.province,b.branch_city from nonfund_4 a,broker.city_2 b;
quit;

data nonfund_5;
set nonfund_5;
if substr(F14_T0401W,1,4)=compress(branch_city);
run;

data nonfund_6;
set nonfund_3 nonfund_5;
run;

proc sql;
create table branch_location as select distinct * from nonfund_6;
quit;

proc sql;
create table T_0401W_1 as select distinct a.*,b.province as branch_province,b.branch_city from broker.T_0401W a left join branch_location b
on a.F12_T0401W=b.F12_T0401W and a.F14_T0401W=b.F14_T0401W;
quit;


data T_0401W_1;
set T_0401W_1;
format F3_T0401W $12.;
drop OID_T0401W OTIME_T0401W ;
run;

data address;
set broker.industry_address;
rename stock_code_1=F3_T0401W province=head_province city=head_city;
keep stock_code_1 province city;
run;

proc sort data=T_0401W_1 out=T_0401W_1;
by F3_T0401W;
run;

proc sort data=address out=address;
by F3_T0401W;
run;

data T_0401W_1;
merge T_0401W_1 address;
by F3_T0401W;
run;

data T_0401W_1;
set T_0401W_1;
length branch_type $20;
if F12_T0401W='基金' then branch_type='fund';
else if head_city=branch_city then branch_type='home_city';
else if head_province=branch_province then branch_type='same_province';
else if branch_province='上海' then branch_type='shanghai';
else if branch_province='北京' then branch_type='beijing';
else branch_type='other';
if head_province='上海' then head_type='shanghai';
else if head_province='北京' then head_type='beijing';
else head_type='other';
startdate=mdy(input(substr(compress(F1_T0401W),5,2),6.),input(substr(compress(F1_T0401W),7,2),6.),input(substr(compress(F1_T0401W),1,4),6.));
enddate=mdy(input(substr(compress(F2_T0401W),5,2),6.),input(substr(compress(F2_T0401W),7,2),6.),input(substr(compress(F2_T0401W),1,4),6.));
format startdate mmddyy.;
format enddate mmddyy.;
drop F1_T0401W F2_T0401W;
if F11_T0401w^='';
run;

proc sql;
create table week as select distinct F3_T0401W,startdate,enddate from T_0401W_1
where startdate^=. and enddate^=.;
quit;

proc sort;
by F3_T0401W startdate enddate;
run;

data week;
set week;
by F3_T0401W startdate enddate;
if first.F3_T0401W then week=0;
week+1;
run;

proc sql;
create table T_0401W_2 as select distinct a.*,b.week from T_0401W_1 a left join week b
on a.F3_T0401W=b.F3_T0401W and a.startdate=b.startdate;
quit;

proc sql;
create table T_0401W_3 as select distinct F3_T0401W,F4_T0401W,head_province,head_city,head_type,startdate,enddate,week,F5_T0401W,F6_T0401W,F7_T0401W,F8_T0401W,F9_T0401W from T_0401W_2
where F9_T0401W>'2';
quit;

proc sql;
create table T_0401W_3_1 as select distinct F3_T0401W,F4_T0401W,head_province,head_city,startdate,enddate,week,F5_T0401W,F6_T0401W,F7_T0401W,F8_T0401W,F9_T0401W,branch_type,sum(F17_T0401W+F18_T0401W) as netBS from T_0401W_2
group by F3_T0401W,week,F9_T0401W,branch_type;
quit;

proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as home_city from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.week=b.week and a.F9_T0401W=b.F9_T0401W and branch_type='home_city';
quit;
proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as same_province from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.week=b.week and a.F9_T0401W=b.F9_T0401W and branch_type='same_province';
quit;
proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as shanghai from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.week=b.week and a.F9_T0401W=b.F9_T0401W and branch_type='shanghai';
quit;
proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as beijing from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.week=b.week and a.F9_T0401W=b.F9_T0401W and branch_type='beijing';
quit;
proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as other from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.week=b.week and a.F9_T0401W=b.F9_T0401W and branch_type='other';
quit;
proc sql;
create table T_0401W_3 as select distinct a.*,b.netBS/a.F8_T0401W as fund from T_0401W_3 a left join T_0401W_3_1 b
on a.F3_T0401W=b.F3_T0401W and a.week=b.week and a.F9_T0401W=b.F9_T0401W and branch_type='fund';
quit;


data T_0401W_3;
set T_0401W_3;
if home_city=. then home_city=0;
if same_province=. then same_province=0;
if shanghai=. then shanghai=0;
if beijing=. then beijing=0;
if other=. then other=0;
if fund=. then fund=0;
home_province=home_city+same_province;
F9=input(F9_T0401W,6.);
drop F9_T0401W;
rename F9=F9_T0401W;
run;

data T_0401W_3;
set T_0401W_3;
if head_type='shanghai' then shanghai=home_province;
if head_type='beijing' then beijing=home_province;
run;

proc sort data=T_0401W_3 out=T_0401W_3;
by F3_T0401W F9_T0401W week;
run;

