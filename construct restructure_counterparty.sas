proc sql;
create table temp1 as select distinct stock_code_1,event_date,coparty_province,coparty_city from broker.restructure_coparty
where coparty_city^='';
quit;

data temp2;
set broker.restructure_event;
keep stock_code_1 event_date;
run;

proc sql;
create table temp3 as select distinct a.*,b.head_province,b.head_city,b.date,b.F8_T0401D,b.F12_T0401D,b.F14_T0401D,b.branch_province,b.branch_city,b.F9_T0401D,b.F17_T0401D+F18_T0401D as netBS
from temp2 a left join broker.T_0401D_1 b
on a.stock_code_1=b.F3_T0401D and b.F9_T0401D>'2';
quit;

proc sql;
create table temp4 as select distinct a.*,b.coparty_province,b.coparty_city from temp3 a left join temp1 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

data temp4;
set temp4;
if F12_T0401D='»ù½ð' then branch_type=0;
else if branch_city=head_city then branch_type=2;
else if branch_province=head_province then branch_type=1;
else branch_type=0;
if branch_city=coparty_city then coparty_type=2;
else if branch_province=coparty_province then coparty_type=1;
else coparty_type=0;
run;

proc sql;
create table temp5 as select distinct a.*,max(b.branch_type) as branch_type,max(b.coparty_type) as coparty_type from temp3 a left join temp4 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and a.F12_T0401D=b.F12_T0401D and a.F14_T0401D=b.F14_T0401D and a.F9_T0401D=b.F9_T0401D and a.netBS=b.netBS
group by b.stock_code_1,b.event_date,b.date,b.F12_T0401D,b.F14_T0401D,b.F9_T0401D,b.netBS;
quit;

proc sql;
drop table temp4,temp3;
quit;

data temp5;
set temp5;
if F9_T0401D='3' then BS=1;
if F9_T0401D='4' then BS=-1;
run;

proc sql;
create table temp6 as select distinct stock_code_1,event_date,head_province,head_city,date,F8_T0401D from temp5;
quit;

proc sql;
create table temp6 as select distinct a.*,sum(b.netBS*BS) as homecity from temp6 a left join temp5 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and b.branch_type=2
group by b.stock_code_1,b.event_date,b.date;
quit;

proc sql;
create table temp6 as select distinct a.*,sum(b.netBS*BS) as coparty_city from temp6 a left join temp5 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and b.coparty_type=2
group by b.stock_code_1,b.event_date,b.date;
quit;

proc sql;
create table temp6 as select distinct a.*,sum(b.netBS*BS) as coparty_outprovince from temp6 a left join temp5 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and b.coparty_type>0 and b.branch_type=0
group by b.stock_code_1,b.event_date,b.date;
quit;

proc sql;
create table temp6 as select distinct a.*,sum(b.netBS*BS) as outall from temp6 a left join temp5 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and b.coparty_type=0 and b.branch_type=0
group by b.stock_code_1,b.event_date,b.date;
quit;

data temp6;
set temp6;
if coparty_outprovince=. then coparty_outprovince=0;
if coparty_city=. then coparty_city=0;
if homecity=. then homecity=0;
if outall=. then outall=0;
run;

proc sql;
create table temp7 as select distinct stock_code_1,event_date,mean(F8_T0401D) as avg_vol from temp6
group by stock_code_1,event_date;
quit;

data temp6;
merge temp6 temp7;
by stock_code_1 event_date;
coparty_outprovince=coparty_outprovince/avg_vol;
coparty_city=coparty_city/avg_vol;
homecity=homecity/avg_vol;
outall=outall/avg_vol;
run;

proc sql;
create table temp8 as select distinct stock_code_1,event_date,mean(coparty_outprovince) as coparty_outprovince_avg,mean(coparty_city) as coparty_city_avg,mean(homecity) as homecity_avg,mean(outall) as outall_avg
from temp6
group by stock_code_1, event_date;
quit;

proc sql;
create table temp6 as select distinct a.*
,a.coparty_outprovince-b.coparty_outprovince_avg as coparty_outprovince_imb_adj
,a.coparty_city-b.coparty_city_avg as coparty_city_imb_adj
,a.homecity-b.homecity_avg as homecity_imb_adj
,a.outall-b.outall_avg as outall_imb_adj
from temp6 a left join temp8 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sql;
create table broker.all_eerbl_60d_imb_restructure as select distinct a.*,b.coparty_outprovince_imb_adj,b.coparty_city_imb_adj,b.homecity_imb_adj,b.outall_imb_adj from broker.all_eerbl_60d_imb a left join temp6 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date;
quit;

