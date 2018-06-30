proc sql;
create table temp1 as select distinct stock_code_1,event_date,bbranch_city,bbranch_province,bhead_province,bhead_city from broker.bankloan_bank;
quit;

data temp2;
set broker.bankloan_event;
keep stock_code_1 event_date;
run;

proc sql;
create table temp3 as select distinct a.*,b.head_province,b.head_city,b.date,b.F8_T0401D,b.F12_T0401D,b.F14_T0401D,b.branch_province,b.branch_city,b.F9_T0401D,b.F17_T0401D+F18_T0401D as netBS
from temp2 a left join broker.T_0401D_1 b
on a.stock_code_1=b.F3_T0401D and b.F9_T0401D>'2';
quit;

proc sql;
create table temp4 as select distinct a.*,b.bbranch_city,b.bbranch_province,b.bhead_province,b.bhead_city from temp3 a left join temp1 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

data temp4;
set temp4;
if branch_city=head_city then branch_type=2;
else if branch_province=head_province then branch_type=1;
else branch_type=0;
if branch_city=bbranch_city then bbranch_type=2;
else if branch_province=bbranch_province then bbranch_type=1;
else bbranch_type=0;
if branch_city=bhead_city then bhead_type=2;
else if branch_province=bhead_province then bhead_type=1;
else bhead_type=0;
run;

proc sql;
create table temp5 as select distinct a.*,max(b.branch_type) as branch_type,max(b.bbranch_type) as bbranch_type,max(b.bhead_type) as bhead_type from temp3 a left join temp4 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and a.F12_T0401D=b.F12_T0401D and a.F14_T0401D=b.F14_T0401D and a.F9_T0401D=b.F9_T0401D and a.netBS=b.netBS
group by b.stock_code_1,b.event_date,b.date,b.F12_T0401D,b.F14_T0401D,b.F9_T0401D,b.netBS;
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
create table temp6 as select distinct a.*,sum(b.netBS*BS) as bbranch_city from temp6 a left join temp5 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and b.bbranch_type=2
group by b.stock_code_1,b.event_date,b.date;
quit;

proc sql;
create table temp6 as select distinct a.*,sum(b.netBS*BS) as bbranch_outprovince from temp6 a left join temp5 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and b.bbranch_type=2 and b.branch_type=0
group by b.stock_code_1,b.event_date,b.date;
quit;

proc sql;
create table temp6 as select distinct a.*,sum(b.netBS*BS) as bhead_city from temp6 a left join temp5 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and b.bhead_type=2 
group by b.stock_code_1,b.event_date,b.date;
quit;

proc sql;
create table temp6 as select distinct a.*,sum(b.netBS*BS) as bhead_outprovince from temp6 a left join temp5 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and b.bhead_type=2 and b.branch_type=0
group by b.stock_code_1,b.event_date,b.date;
quit;

proc sql;
create table temp6 as select distinct a.*,sum(b.netBS*BS) as outall from temp6 a left join temp5 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and b.bhead_type=0 and b.bbranch_type=0 and b.branch_type=0
group by b.stock_code_1,b.event_date,b.date;
quit;

data temp6;
set temp6;
if bbranch_outprovince=. then bbranch_outprovince=0;
if bbranch_city=. then bbranch_city=0;
if homecity=. then homecity=0;
if bhead_city=. then bhead_city=0;
if bhead_outprovince=. then bhead_outprovince=0;
if outall=. then outall=0;
run;

proc sql;
create table temp7 as select distinct stock_code_1,event_date,mean(F8_T0401D) as avg_vol from temp6
group by stock_code_1,event_date;
quit;

data temp6;
merge temp6 temp7;
by stock_code_1 event_date;
bbranch_outprovince=bbranch_outprovince/avg_vol;
bbranch_city=bbranch_city/avg_vol;
homecity=homecity/avg_vol;
bhead_city=bhead_city/avg_vol;
bhead_outprovince=bhead_outprovince/avg_vol;
outall=outall/avg_vol;
run;

proc sql;
create table temp8 as select distinct stock_code_1,event_date,mean(bbranch_outprovince) as bbranch_outprovince_avg,mean(bbranch_city) as bbranch_city_avg,mean(homecity) as homecity_avg,mean(bhead_city) as bhead_city_avg,mean(bhead_outprovince) as bhead_outprovince_avg,mean(outall) as outall_avg
from temp6
group by stock_code_1, event_date;
quit;

proc sql;
create table temp6 as select distinct a.*
,a.bbranch_outprovince-b.bbranch_outprovince_avg as bbranch_outprovince_imb_adj
,a.bbranch_city-b.bbranch_city_avg as bbranch_city_imb_adj
,a.homecity-b.homecity_avg as homecity_imb_adj
,a.bhead_city-b.bhead_city_avg as bhead_city_imb_adj
,a.bhead_outprovince-b.bhead_outprovince_avg as bhead_outprovince_imb_adj
,a.outall-b.outall_avg as outall_imb_adj
from temp6 a left join temp8 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sql;
create table broker.all_eerbl_60d_imb_bankloan as select distinct a.*,b.bbranch_outprovince_imb_adj,b.bbranch_city_imb_adj,b.homecity_imb_adj,b.bhead_city_imb_adj,b.bhead_outprovince_imb_adj,b.outall_imb_adj from broker.all_eerbl_60d_imb a left join temp6 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date and a.event='bankloan';
quit;



