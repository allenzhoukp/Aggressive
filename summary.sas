data T_0401d;
set broker.T_0401D_1;
if F9_T0401D>'2';
drop F9_T0401D F10_T0401d;
if F17_T0401D>0 then buy=1;
else buy=0;
run;

proc sql;
create table T_0401d as select distinct * from T_0401d;
quit;

proc sql;
create table temp1 as select distinct F3_T0401D,date,F8_T0401D,buy,sum(F17_T0401D+F18_T0401D) as netvol,sum(F17_T0401D+F18_T0401D)/F8_T0401D as netfrac from T_0401D
group by F3_T0401D,date,buy;
quit;

proc tabulate data=temp3 out=temp1_1;
class buy;
var netfrac;
table buy,netfrac*(mean max p95 median p5 min);
run;

proc sql;
create table temp3 as select distinct a.F3_T0401D,a.date,a.F8_T0401D,a.buy,b.netfrac from temp1 a left join temp2 b
on a.F3_T0401D=b.F3_T0401D and a.date=b.date and a.buy=b.buy;
quit;

data temp3;
set temp3;
if netfrac=. then netfrac=0;
run;


proc sql;
create table temp1 as select distinct F3_T0401D,date,F8_T0401D,head_type,buy,branch_type,sum(F17_T0401D+F18_T0401D) as netvol,sum(F17_T0401D+F18_T0401D)/F8_T0401D as netfrac from T_0401D
group by F3_T0401D,date,buy,branch_type;
quit;

proc sql;
create table temp2_1 as select distinct F3_T0401D,date,head_type,buy from T_0401D;
quit;

proc sql;
create table temp2_2 as select distinct branch_type from T_0401D;
quit;

proc sql;
create table temp2 as select distinct a.*,b.* from temp2_1 a full join temp2_2 b
on a.date^=.;
quit;

proc sql;
create table temp1 as select distinct a.*,b.netfrac from temp2 a left join temp1 b
on a.F3_T0401D=b.F3_T0401D and a.date=b.date and a.buy=b.buy and a.branch_type=b.branch_type;
quit;

data temp1;
set temp1;
if netfrac=. then netfrac=0;
run;

proc tabulate data=temp1 out=temp1_1;
class buy head_type branch_type;
var netfrac;
table buy,head_type,branch_type*netfrac*mean;
run;

proc transpose data=temp1_1 out=temp1_1 let;
ID branch_type head_type buy;
run;


proc sql;
create table temp1 as select distinct month,sum(earning) as earning,sum(earning_forecast) as earning_forecast,sum(restructure) as restructure,sum(bankloan) as bankloan,sum(lawsuit) as lawsuit,sum(suspension) as suspension,sum(governor) as governor,count(event_date) as count
from broker.all_eerbl
group by month;
quit;

proc sql;
create table temp1 as select distinct stock_code_1,count(distinct event_date) as count from broker.all_eerbl
group by stock_code_1;
quit;

data temp1;
set temp1;
if count>=20 then group=2;
else if count>=10 then group=1;
else group=0;
run;

proc tabulate data=temp1 out=temp1_1;
class group;
var count;
table group,count*(n mean max p95 median p5 min);
run;
