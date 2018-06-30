%let wpre=-3;
%let wpost=5;
%let dpre=-15;
%let dpost=30;

data real_reverse;
length event $20.;
event='';
run;

%macro event(event);
proc sql;
create table &event._60d_imb_w as select distinct a.* from broker.&event._60d_imb_w a,broker.&event._important b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sql;
create table &event._60d_imb as select distinct a.* from broker.&event._60d_imb a,broker.&event._important b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

data temp1_b_w;
set &event._60d_imb_w;
if time_trade>=&wpre and time_trade<0;
keep stock_code_1 event_date startdate enddate time_trade return_raw abret_month abret_index;
run;

data temp1_b_d;
set &event._60d_imb;
if time_trade>=&dpre and time_trade<0;
keep stock_code_1 event_date date time_trade return_raw abret_month abret_index;
run;

proc sql;
create table temp1_b_w as select distinct a.*,b.F5_T0401w as closeprc,F11_T0401W as F11_T0401D,F12_T0401W as F12_T0401D,F13_T0401W as F13_T0401D,F14_T0401W as F14_T0401D,7-input(F9_T0401W,6.)*2 as BS,F17_T0401W+F18_T0401W as netBS,branch_province,branch_city,head_province,head_city,branch_type,head_type
from temp1_b_w a left join T_0401W_1 b
on a.stock_code_1=b.F3_T0401W and a.startdate=b.startdate and a.enddate=b.enddate and b.F9_T0401W>'2';
quit;

proc sql;
create table temp1_b_d as select distinct a.*,b.F5_T0401D as closeprc,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,7-input(F9_T0401D,6.)*2 as BS,F17_T0401D+F18_T0401D as netBS,branch_province,branch_city,head_province,head_city,branch_type,head_type
from temp1_b_d a left join T_0401D_1 b
on a.stock_code_1=b.F3_T0401D and a.date=b.date and b.F9_T0401D>'2';
quit;

data temp1_b_d;
set temp1_b_d;
if _n_=1 then No=0;
No+1;
run;

proc sql;
create table temp1_match as select distinct a.*,b.date,b.No from temp1_b_w a,temp1_b_d b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.F11_T0401D=b.F11_T0401D and a.F12_T0401D=b.F12_T0401D and a.F13_T0401D=b.F13_T0401D and a.F14_T0401D=b.F14_T0401D and a.startdate<=b.date and a.enddate>=b.date;
quit;

data temp1_b;
set temp1_b_w temp1_b_d;
if F11_T0401D^='';
run;

proc sql;
create table temp1_b as select distinct * from temp1_b
where No not in (select No from temp1_match);
quit;

data temp1_b;
set temp1_b;
if startdate=. then startdate=date;
if enddate=. then enddate=date;
before=1;
drop date No time_trade;
run;

data temp1_a_w;
set &event._60d_imb_w;
if time_trade<=&wpost and time_trade>=0;
keep stock_code_1 event_date startdate enddate time_trade return_raw abret_month abret_index;
run;

data temp1_a_d;
set &event._60d_imb;
if time_trade<=&dpost and time_trade>=0;
keep stock_code_1 event_date date time_trade return_raw abret_month abret_index;
run;

proc sql;
create table temp1_a_w as select distinct a.*,b.F5_T0401w as closeprc,F11_T0401W as F11_T0401D,F12_T0401W as F12_T0401D,F13_T0401W as F13_T0401D,F14_T0401W as F14_T0401D,7-input(F9_T0401W,6.)*2 as BS,F17_T0401W+F18_T0401W as netBS,branch_province,branch_city,head_province,head_city,branch_type,head_type
from temp1_a_w a left join T_0401W_1 b
on a.stock_code_1=b.F3_T0401W and a.startdate=b.startdate and a.enddate=b.enddate and b.F9_T0401W>'2';
quit;

proc sql;
create table temp1_a_d as select distinct a.*,b.F5_T0401D as closeprc,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,7-input(F9_T0401D,6.)*2 as BS,F17_T0401D+F18_T0401D as netBS,branch_province,branch_city,head_province,head_city,branch_type,head_type
from temp1_a_d a left join T_0401D_1 b
on a.stock_code_1=b.F3_T0401D and a.date=b.date and b.F9_T0401D>'2';
quit;

data temp1_a_d;
set temp1_a_d;
if _n_=1 then No=0;
No+1;
run;

proc sql;
create table temp1_match as select distinct a.*,b.date,b.No from temp1_a_w a,temp1_a_d b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.F11_T0401D=b.F11_T0401D and a.F12_T0401D=b.F12_T0401D and a.F13_T0401D=b.F13_T0401D and a.F14_T0401D=b.F14_T0401D and a.startdate<=b.date and a.enddate>=b.date;
quit;

data temp1_a;
set temp1_a_w temp1_a_d;
if F11_T0401D^='';
run;

proc sql;
create table temp1_a as select distinct * from temp1_a
where No not in (select No from temp1_match);
quit;

data temp1_a;
set temp1_a;
if startdate=. then startdate=date;
if enddate=. then enddate=date;
before=0;
drop date No time_trade;
run;

data temp1;
set temp1_b temp1_a;
run;

data temp1_3;
set &event._60d_imb;
if time_trade>=&dpre-10 and time_trade<=&dpost+10;
keep stock_code_1 event_date time_trade date return_raw abret_month abret_index;
run;

proc sort;
by stock_code_1 event_date time_trade;
run;

data temp1_3;
set temp1_3;
by stock_code_1 event_date time_trade;
if first.event_date then do;
CRR=0;CAR_index=0;CAR_month=0;
end;
CRR+return_raw;CAR_index+abret_index;CAR_month+abret_month;
run;

proc sql;
create table temp1 as select distinct a.*,b.CRR,b.CAR_index,b.CAR_month from temp1 a left join temp1_3 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.enddate=b.date;
quit;

proc sort;
by stock_code_1 event_date F11_T0401D startdate enddate;
run;

proc sql;
create table temp2_1 as select distinct stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,branch_province,branch_city,head_province,head_city,branch_type,head_type,sum(BS*netBS) as position_before from temp1
where before=1
group by stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D;
quit;

proc sql;
create table temp2_2 as select distinct stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,branch_province,branch_city,head_province,head_city,branch_type,head_type,sum(BS*netBS) as position_after from temp1
where before=0
group by stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D;
quit;

data temp2;
merge temp2_1 temp2_2;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D;
if position_before^=.;
if sign(position_before)*sign(position_after)=-1 then reverse_position=1;
else reverse_position=0;
run;

data temp3_1;
set temp1;
if before=0;
run;

proc sort;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D startdate enddate;
run;

data temp3_1;
set temp3_1;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D startdate enddate;
if first.F14_T0401D;
first_after=BS*netBS;
keep stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D branch_province branch_city head_province head_city branch_type head_type first_after;
run;

data temp3;
merge temp2 temp3_1;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D;
if position_before^=.;
if sign(position_before)*sign(first_after)=-1 then reverse_first=1;
else reverse_first=0;
run;

data temp3_2;
set temp1;
if before=0;
run;

proc sql;
create table temp3_2 as select distinct a.*,b.position_before from temp3_2 a left join temp3 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.F11_T0401D=b.F11_T0401D and a.F12_T0401D=b.F12_T0401D and a.F13_T0401D=b.F13_T0401D and a.F14_T0401D=b.F14_T0401D;
quit;

data temp3_2;
set temp3_2;
if sign(position_before)*BS=-1;
run;

proc sql;
create table temp3_2 as select distinct stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,before from temp3_2;
quit;

proc sql;
create table temp3 as select distinct a.*,b.before from temp3 a left join temp3_2 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.F11_T0401D=b.F11_T0401D and a.F12_T0401D=b.F12_T0401D and a.F13_T0401D=b.F13_T0401D and a.F14_T0401D=b.F14_T0401D;
quit;

data temp3;
set temp3;
if before^=. then reverse_exist=1;
else reverse_exist=0;
drop before;
run;

data temp3;
set temp3;
if branch_type='home_city' then home_city=1;else home_city=0;
if branch_type='home_city' or branch_type='same_province' then home_province=1;else home_province=0;
if branch_type='fund' then fund=1;else fund=0;
if branch_type='beijing' or (branch_type='home_city' and head_type='beijing')then beijing=1;else beijing=0;
if branch_type='shanghai' or (branch_type='home_city' and head_type='shanghai')then shanghai=1;else shanghai=0;
if branch_type='other' then other=1;else other=0;
run;

%macro reverse(inv);
proc sql;
create table temp4 as select distinct count(reverse_position) as No_total,sum(reverse_position) as No_position,mean(reverse_position) as Fraction_position
,sum(reverse_first) as No_first,mean(reverse_first) as Fraction_first 
,sum(reverse_exist) as No_exist,mean(reverse_exist) as Fraction_exist
from temp3
where &inv.=1;
quit;

data temp4;
set temp4;
investor="&inv.";
event="&event.";
run;

data reverse;
set reverse temp4;
run;
%mend reverse;

data reverse;
length investor $20.;
investor='';
run;

%reverse(home_province);
%reverse(home_city);
%reverse(fund);
%reverse(beijing);
%reverse(shanghai);
%reverse(other);

data real_reverse;
set real_reverse reverse;
if event^='';
run;


%mend event;

%event(all);
%event(earning);
%event(restructure);
%event(bankloan);
%event(lawsuit);
