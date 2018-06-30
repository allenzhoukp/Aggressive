%let pre=-3;
%let post=-1;

proc sql;
create table imb_b10 as select distinct stock_code_1,event_date
,sum(abret_index) as indexb10,sum(abret_month) as monthb10
,sum(all_imb_adj) as all_imbb10
,sum(beijing_imb_adj) as beijing_imbb10
,sum(shanghai_imb_adj) as shanghai_imbb10
,sum(other_imb_adj) as other_imbb10
,sum(home_city_imb_adj) as home_city_imbb10
,sum(home_province_imb_adj) as home_province_imbb10
,sum(fund_imb_adj) as fund_imbb10
from broker.all_eerbl_60d_imb
where time_trade<=&post and time_trade>=&pre
group by stock_code_1,event_date;
quit;

data imb_b10;
merge imb_b10 broker.all_eerbl;
by stock_code_1 event_date;
run;

data imb_b10;
set imb_b10;
if all_imbb10^=. and all_imbb10^=0 and first_half=1;
run;

proc sort;
by all_imbb10;
run;

data _null_;
       set imb_b10 nobs=t;
       call symput("size",t);
       stop;
run;


data imb_b10;
set imb_b10;
if _n_<=&size./5 then quintile=1;
if _n_>&size./5 and _n_<=&size./5*2 then quintile=2;
if _n_>&size./5*2 and _n_<= &size./5*3 then quintile=3;
if _n_>&size./5*3 and _n_<=&size./5*4 then quintile=4;
if _n_>&size./5*4 and _n_<=&size. then quintile=5;
run;

proc sql;
create table CAR0_1 as select distinct a.stock_code_1,a.event_date,sum(a.abret_index) as index0_1
from broker.all_eerbl_60d_imb a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.time_trade>=0 and a.time_trade<=3
group by a.stock_code_1,a.event_date;
quit;

data CAR0_1;
set CAR0_1;
if abs(index0_1)>-1;
run;

proc sql;
create table CAR0_1 as select distinct a.*,b.all_imbb10,b.home_city_imbb10,b.shanghai_imbb10 from CAR0_1 a,imb_b10 b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date; 
quit;

proc sql;
create table temp1 as select distinct a.stock_code_1,a.event_date,b.index0_1,b.all_imbb10,b.home_city_imbb10,b.shanghai_imbb10,a.date,a.time_trade from broker.all_eerbl_60d_imb a,CAR0_1 b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.time_trade>=&pre and a.time_trade<=&post;
quit;

proc sql;
create table temp1 as select distinct a.*,b.F11_T0401D,b.F12_T0401D,b.F13_T0401D,b.F14_T0401D,b.branch_province,b.branch_city,b.head_province,b.head_city,b.branch_type,b.head_type,7-input(b.F9_T0401D,6.)*2 as BS,b.F17_T0401D+b.F18_T0401D as netBS
from temp1 a left join broker.T_0401D_1 b
on a.stock_code_1=b.F3_T0401D and a.date=b.date and b.F9_T0401D>'2';
quit;

proc sql;
create table temp1_1 as select distinct stock_code_1,event_date,index0_1,all_imbb10,home_city_imbb10,shanghai_imbb10,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,branch_type,head_type,sum(BS*netBS) as position from temp1
group by stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D;
quit;

proc sql;
create table avg_vol as select distinct F3_T0401D as stock_code_1,mean(F8_T0401D) as avg_vol from broker.imb2
group by F3_T0401D;
quit;

data temp1_1;
merge temp1_1 avg_vol;
by stock_code_1;
run;

data temp1_1;
set temp1_1;
imb=position/avg_vol;
absolute_imb=abs(position/avg_vol);
if position^=.;
run;

proc sql;
create table temp1_1 as select distinct a.*,b.quintile as important from temp1_1 a left join imb_b10 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

data temp1_1;
set temp1_1;
if important=1 or important=5 then important=1;
else important=0;
run;

proc sql;
create table temp1_1_count as select distinct stock_code_1,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,count(distinct event_date) as count,sum(important) as count_important from temp1_1
group by stock_code_1,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D;
quit;

proc sort data=temp1_1;
by stock_code_1 F11_T0401D F12_T0401D F13_T0401D F14_T0401D event_date;
run;

data temp1_1;
merge temp1_1 temp1_1_count;
by stock_code_1 F11_T0401D F12_T0401D F13_T0401D F14_T0401D;
run;

proc sort;
by stock_code_1 F11_T0401D F12_T0401D F13_T0401D F14_T0401D event_date;
run;

data temp1_1;
set temp1_1;
by stock_code_1 F11_T0401D F12_T0401D F13_T0401D F14_T0401D event_date;
if first.F14_T0401D then No_important=0;
if important=1 then No_important+1;
if first.F14_T0401D then No=0;
No+1;
run;

data temp1_1;
set temp1_1;
if No_important<=(count_important+1000000)/2 then half=1;
else if No_important<=(count_important+1)*2/2 then half=2;
else half=3;
imb=position/avg_vol*all_imbb10;
run;

proc sql;
create table temp1_2 as select distinct F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,stock_code_1,branch_type,head_type,half,sum(sign(imb)) as count,sum(imb) as total_imb,mean(sign(imb)) as frequency from temp1_1
group by F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,stock_code_1,half;
quit;

proc sql;
create table event_appearance as select distinct F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,stock_code_1,branch_type,head_type from temp1_2;
quit;

%macro sort(k);
proc sql;
create table event_appearance as select distinct a.*,b.count as count_&k.,b.total_imb as total_imb_&k.,b.frequency as frequency_&k. from event_appearance a left join temp1_2 b
on b.half=&k and a.stock_code_1=b.stock_code_1 and a.F11_T0401D=b.F11_T0401D and a.F12_T0401D=b.F12_T0401D and a.F13_T0401D=b.F13_T0401D and a.F14_T0401D=b.F14_T0401D;
quit;

proc sort data=event_appearance out=total_imb_&k.;
where total_imb_&k.^=.;
by descending total_imb_&k.;
run;

data _null_;
       set total_imb_&k. nobs=t;
       call symput("size",t);
       stop;
run;

data total_imb_&k.;
set total_imb_&k.;
if _n_<=&size./10 then decile&k.=1;
if _n_>&size./10 and _n_<=&size./10*2 then decile&k.=2;
if _n_>&size./10*2 and _n_<= &size./10*3 then decile&k.=3;
if _n_>&size./10*3 and _n_<=&size./10*4 then decile&k.=4;
if _n_>&size./10*4 and _n_<=&size./10*5 then decile&k.=5;
if _n_>&size./10*5 and _n_<=&size./10*6 then decile&k.=6;
if _n_>&size./10*6 and _n_<=&size./10*7 then decile&k.=7;
if _n_>&size./10*7 and _n_<=&size./10*8 then decile&k.=8;
if _n_>&size./10*8 and _n_<=&size./10*9 then decile&k.=9;
if _n_>&size./10*9 and _n_<=&size./10*10 then decile&k.=10;
if _n_<&size./127 then log&k.=1;
if _n_>=&size./127 and _n_<&size.*3/127 then log&k.=2;
if _n_>=&size.*3/127 and _n_<&size.*7/127 then log&k.=3;
if _n_>=&size.*7/127 and _n_<&size.*15/127 then log&k.=4;
if _n_>=&size.*15/127 and _n_<&size.*31/127 then log&k.=5;
if _n_>=&size.*31/127 and _n_<&size.*63/127 then log&k.=6;
if _n_>=&size.*63/127 and _n_<=&size.*127/127 then log&k.=7;
run;

proc sql;
create table event_appearance as select distinct a.*,b.decile&k.,b.log&k. from event_appearance a left join total_imb_&k. b
on a.stock_code_1=b.stock_code_1 and a.F11_T0401D=b.F11_T0401D and a.F12_T0401D=b.F12_T0401D and a.F13_T0401D=b.F13_T0401D and a.F14_T0401D=b.F14_T0401D;
quit;

proc sql;
create table stock_count as select stock_code_1,count(stock_code_1) as stock_count from event_appearance
group by stock_code_1;
quit;

proc sql;
create table event_appearance as select distinct a.*,b.stock_count from event_appearance a left join stock_count b
on a.stock_code_1=b.stock_code_1;
quit;

proc sort data=event_appearance;
where total_imb_&k.^=.;
by stock_code_1 descending total_imb_&k.;
run;

data event_appearance;
set event_appearance;
by stock_code_1 descending total_imb_&k.;
if first.stock_code_1 then No=0;
No+1;
run;

data event_appearance;
set event_appearance;
if No<stock_count/127 then slog&k.=1;
if No>=stock_count/127 and No<stock_count*3/127 then slog&k.=2;
if No>=stock_count*3/127 and No<stock_count*7/127 then slog&k.=3;
if No>=stock_count*7/127 and No<stock_count*15/127 then slog&k.=4;
if No>=stock_count*15/127 and No<stock_count*31/127 then slog&k.=5;
if No>=stock_count*31/127 and No<stock_count*63/127 then slog&k.=6;
if No>=stock_count*63/127 and No<=stock_count*127/127 then slog&k.=7;
run;
%mend sort;

%sort(1);

proc sort data=event_appearance;
by descending total_imb_1;
run;

%macro group(n);
data freq_appearance;
set event_appearance;
if log1=&n;
run;

proc sql;
create table T_0401D_1 as select distinct a.* from broker.T_0401D_1 a,Freq_appearance b
where a.F3_T0401D=b.stock_code_1 and a.F11_T0401D=b.F11_T0401D and a.F12_T0401D=b.F12_T0401D and a.F13_T0401D=b.F13_T0401D and a.F14_T0401D=b.F14_T0401D;
quit;

%let pre=-3;
%let post=3;

data real_ret;
length event $20.;
event='';
run;
data real_reverse;
length event $20.;
event='';
run;

%macro event(event);
proc sql;
create table temp1 as select distinct a.stock_code_1,a.event_date,a.date,a.time_trade,a.return_raw,a.abret_month,a.abret_index 
from broker.all_eerbl_60d_imb a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.&event.=1 and b.first_half=2 and a.time_trade>=&pre and a.time_trade<=&post;
quit;

proc sort;
by stock_code_1 event_date time_trade;
run;

data temp1;
set temp1;
by stock_code_1 event_date time_trade;
if first.event_date then do;
CRR=0;CAR_index=0;CAR_month=0;
end;
CRR+return_raw;CAR_index+abret_index;CAR_month+abret_month;
run;

proc sql;
create table temp1 as select distinct a.*,b.F11_T0401D,b.F12_T0401D,b.F13_T0401D,b.F14_T0401D,7-input(b.F9_T0401D,6.)*2 as BS,b.F17_T0401D+b.F18_T0401D as netBS,b.branch_province,b.branch_city,b.head_province,b.head_city,b.branch_type,b.head_type
from temp1 a left join T_0401D_1 b
on a.stock_code_1=b.F3_T0401D and a.date=b.date and b.F9_T0401D>'2';
quit;

proc sql;
create table temp1 as select distinct a.*,b.closeprc
from temp1 a left join broker.stock_daily_1 b
on a.stock_code_1=b.stock_code_1 and a.date=b.date;
quit;

proc sort data=temp1 out=temp2;
where time_trade<0;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D date;
run;

proc sql;
create table temp3 as select distinct stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,sum(netBS*BS) as position from temp2
group by stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D;
quit;

data temp4;
merge temp2 temp3;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D;
run;

data temp4;
set temp4;
if sign(position)=BS;
run;

proc sort;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D descending date;
run;

data temp4;
set temp4;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D descending date;
if first.F13_T0401D then residual=position;
residual+(-1*BS*netBS);
run;

data temp5;
set temp4;
if sign(residual)=sign(position) and abs(residual)>5;
weight=netBS;
run; 

data temp6;
set temp4;
if sign(residual)^=sign(position) or abs(residual)<=5;
run;

proc sort;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D descending date;
run;

data temp6;
set temp6;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D descending date;
if first.F13_T0401D;
weight=abs(netBS*BS+residual);
run; 

data temp7;
set temp5 temp6;
run;

proc sort;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D descending date;
run;

proc sql;
create table temp8 as select distinct stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,branch_province,branch_city,head_province,head_city,branch_type,head_type,sum(BS*weight) as position_before,sum(closeprc*BS*weight)/sum(BS*weight) as price_before,sum(CRR*BS*weight)/sum(BS*weight) as CRR_before,sum(CAR_index*BS*weight)/sum(BS*weight) as CAR_index_before,sum(CAR_month*BS*weight)/sum(BS*weight) as CAR_month_before  
from temp7
group by stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D;
quit;

data temp9;
set temp1;
if time_trade>=0;
run;

proc sql;
create table temp9 as select distinct a.*,b.position_before from temp9 a left join temp8 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.F11_T0401D=b.F11_T0401D and a.F12_T0401D=b.F12_T0401D and a.F13_T0401D=b.F13_T0401D and a.F14_T0401D=b.F14_T0401D;
quit;

data temp9;
set temp9;
if BS^=sign(position_before);
if position_before^=.;
run;

proc sort;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D date;
run;

data temp9;
set temp9;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D date;
if first.F13_T0401D then residual=position_before;
residual+(BS*netBS);
run;

data temp10;
set temp9;
if sign(position_before)=sign(residual) and abs(residual)>5;
weight=netBS;
run;

data temp11;
set temp9;
if sign(residual)^=sign(position_before) or abs(residual)<=5;
run;

proc sort;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D date;
run;

data temp11;
set temp11;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D  date;
if first.F13_T0401D;
weight=abs(netBS*BS-residual);
run; 

data temp12;
set temp10 temp11;
run;

proc sort;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D date;
run;

data temp13;
set temp12;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D date;
if last.F14_T0401D;
if sign(position_before)=sign(residual);
drop date return_raw abret_month abret_index time_trade closeprc CRR CAR_index CAR_month;
run;

data temp13;
set temp13;
weight=abs(residual);
BS=-sign(residual);
netBS=0;
run;

proc sql;
create table temp13 as select distinct a.*,b.date,b.CRR,b.CAR_index,b.CAR_month,b.closeprc from temp13 a left join temp1 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.time_trade=&post;
quit;

data temp12;
set temp12 temp13;
run;

proc sql;
create table temp14 as select distinct stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,branch_province,branch_city,head_province,head_city,branch_type,head_type,sum(BS*weight) as position_after,sum(closeprc*BS*weight)/sum(BS*weight) as price_after,sum(CRR*BS*weight)/sum(BS*weight) as CRR_after,sum(CAR_index*BS*weight)/sum(BS*weight) as CAR_index_after,sum(CAR_month*BS*weight)/sum(BS*weight) as CAR_month_after  
from temp12
group by stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D;
quit;

data temp15;
merge temp8 temp14;
by stock_code_1 event_date F11_T0401D F12_T0401D F13_T0401D F14_T0401D;
run;

proc sql;
create table imb3 as select distinct F3_T0401D as stock_code_1,mean(F8_T0401D) as avg_vol from broker.imb2
group by F3_T0401D;
quit;

data temp15;
merge temp15 imb3;
by stock_code_1;
run;

data temp15;
set temp15;
imb_before=position_before/avg_vol;
imb_after=position_after/avg_vol;
all=1;
if branch_type='home_city' then home_city=1;else home_city=0;
if branch_type='home_city' or branch_type='same_province' then home_province=1;else home_province=0;
if branch_type='fund' then fund=1;else fund=0;
if branch_type='beijing' or (branch_type='home_city' and head_type='beijing')then beijing=1;else beijing=0;
if branch_type='shanghai' or (branch_type='home_city' and head_type='shanghai')then shanghai=1;else shanghai=0;
if branch_type='other' then other=1;else other=0;
run;

proc sql;
create table temp15 as select distinct a.*,b.date,b.CRR as CRR_&post.,b.CAR_index as CAR_index_&post.,b.CAR_month as CAR_month_&post.,b.closeprc as closeprc_&post. from temp15 a left join temp1 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.time_trade=&post;
quit;

data temp16;
set temp15;
if position_after=. then do;
price_after=closeprc_&post.;
CRR_after=CRR_&post.;
CAR_index_after=CAR_index_&post.;
CAR_month_after=CAR_month_&post.;
end;
if F11_T0401D^='';
run;

proc sort data=temp16 out=temp16;
by imb_before;
run;

data _null_;
       set temp16 nobs=t;
       call symput("size",t);
       stop;
run;

data temp16;
set temp16;
if _n_<=&size./5 then quintile=1;
if _n_>&size./5 and _n_<=&size./5*2 then quintile=2;
if _n_>&size./5*2 and _n_<= &size./5*3 then quintile=3;
if _n_>&size./5*3 and _n_<=&size./5*4 then quintile=4;
if _n_>&size./5*4 and _n_<=&size. then quintile=5;
run;

data temp30;
set temp16;
price=(price_after/price_before-1)*sign(position_before);
CRR=(CRR_after-CRR_before)*sign(position_before);
CAR_index=(CAR_index_after-CAR_index_before)*sign(position_before);
CAR_month=(CAR_month_after-CAR_month_before)*sign(position_before);
price&post.=(closeprc_&post./price_before-1)*sign(position_before);
CRR&post.=(CRR_&post.-CRR_before)*sign(position_before);
CAR_index&post.=(CAR_index_&post.-CAR_index_before)*sign(position_before);
CAR_month&post.=(CAR_month_&post.-CAR_month_before)*sign(position_before);
weight_position=abs(position_before);
weight_imb=abs(imb_before);
if position_after^=. then reverse=1;
else reverse=0;
run;

proc sql;
create table return0_&post as select distinct stock_code_1,event_date,sum(return_raw) as CRR0_&post,sum(abret_index) as CAR_index0_&post,sum(abret_month) as CAR_month0_&post from temp1 
where time_trade>=0 and time_trade<=&post
group by stock_code_1,event_date;
quit;

proc sql;
create table temp30 as select distinct a.*,b.CRR0_&post.*sign(a.position_before) as CRR0_&post.,b.CAR_index0_&post.*sign(a.position_before) as CAR_index0_&post.,b.CAR_month0_&post.*sign(a.position_before) as CAR_month0_&post. from temp30 a left join return0_&post b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;
/*
proc sql;
create table temp30 as select distinct a.* from temp30 a,temp1_1 b
where b.half=2 and a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.F11_T0401D=b.F11_T0401D and a.F12_T0401D=b.F12_T0401D and a.F13_T0401D=b.F13_T0401D and a.F14_T0401D=b.F14_T0401D;
quit;
*/
data event_ret_&n;
set temp30;
run;

proc sql;
create table investor_ret_&n as select distinct stock_code_1,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,branch_province,branch_city,head_province,head_city,branch_type,head_type,all,home_city,home_province,fund,beijing,shanghai,other,
sum(weight_imb) as weight_imb,sum(weight_position) as weight_position,sum(price*weight_imb)/sum(weight_imb) as price,sum(CRR*weight_imb)/sum(weight_imb) as CRR,sum(CAR_index*weight_imb)/sum(weight_imb) as CAR_index,sum(CAR_month*weight_imb)/sum(weight_imb) as CAR_month,sum(price&post.*weight_imb)/sum(weight_imb) as price&post.,sum(CRR&post.*weight_imb)/sum(weight_imb) as CRR&post.,sum(CAR_index&post.*weight_imb)/sum(weight_imb) as CAR_index&post.,sum(CAR_month&post.*weight_imb) as CAR_month&post.,sum(CRR0_&post.*weight_imb)/sum(weight_imb) as CRR0_&post.,sum(CAR_index0_&post.*weight_imb)/sum(weight_imb) as CAR_index0_&post.,sum(CAR_month0_&post.*weight_imb)/sum(weight_imb) as CAR_month0_&post.
from temp30
group by stock_code_1,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D;
quit;

proc sort;
by descending CAR_index;
run;

data real_ret_equal;
length type $20.;
length investor $20.;
type='';
investor='';
run;
data real_ret_wimb;
length type $20.;
length investor $20.;
type='';
investor='';
run;
data real_ret_wposi;
length type $20.;
length investor $20.;
type='';
investor='';
run;data reverse;
length investor $20.;
investor='';
run;


%macro ret(inv);

proc tabulate data=temp30 out=temp31;
where price^=. and &inv.=1;
var price CRR CAR_index CAR_month price&post. CRR&post. CAR_index&post. CAR_month&post. CRR0_&post CAR_index0_&post CAR_month0_&post;
table (price CRR CAR_index CAR_month price&post. CRR&post. CAR_index&post. CAR_month&post. CRR0_&post CAR_index0_&post CAR_month0_&post)*(mean t);
run;

data temp31;
set temp31;
investor="&inv.";
type='equal_weighted';
event="&event.";
drop _type_ _page_ _table_;
run;

proc tabulate data=temp30 out=temp32;
where price^=. and &inv.=1;
var price CRR CAR_index CAR_month price&post. CRR&post. CAR_index&post. CAR_month&post. CRR0_&post CAR_index0_&post CAR_month0_&post;
weight weight_imb;
table (price CRR CAR_index CAR_month price&post. CRR&post. CAR_index&post. CAR_month&post. CRR0_&post CAR_index0_&post CAR_month0_&post)*(mean t);
run;

data temp32;
set temp32;
investor="&inv.";
type='imb_weighted';
event="&event.";
drop _type_ _page_ _table_;
run;

proc tabulate data=temp30 out=temp33;
where price^=. and &inv.=1;
var price CRR CAR_index CAR_month price&post. CRR&post. CAR_index&post. CAR_month&post. CRR0_&post CAR_index0_&post CAR_month0_&post;
weight weight_position;
table (price CRR CAR_index CAR_month price&post. CRR&post. CAR_index&post. CAR_month&post. CRR0_&post CAR_index0_&post CAR_month0_&post)*(mean t);
run;

data temp33;
set temp33;
investor="&inv.";
type='position_weighted';
event="&event.";
drop _type_ _page_ _table_;
run;

proc sql;
create table temp34 as select distinct count(reverse) as No_total,sum(reverse) as No_reverse,mean(reverse) as Fraction from temp30
where &inv.=1;
quit;

data temp34;
set temp34;
investor="&inv.";
event="&event.";
run;

data real_ret_equal;
set real_ret_equal temp31;
run;
data real_ret_wimb;
set real_ret_wimb temp32;
run;
data real_ret_wposi;
set real_ret_wposi temp33;
run;
data reverse;
set reverse temp34;
run;
%mend ret;

%ret(all);
%ret(home_province);
%ret(home_city);
%ret(fund);
%ret(beijing);
%ret(shanghai);
%ret(other);

data real_ret_predict_&n;
set real_ret real_ret_wimb;
if type^='';
run;

data real_reverse;
set real_reverse reverse;
if event^='';
run;

proc sql;
create table positive_&n as select mean(sign(CAR_index))/2+0.5 as positive from investor_ret_&n;
quit;

%mend event;


%event(all);


%mend group;

%macro loop;
%do n=1 %to 7;
%group(&n);
%end;
%mend;

%loop;

data real_ret_predict;
set real_ret_predict_1 real_ret_predict_2 real_ret_predict_3 real_ret_predict_4 real_ret_predict_5 real_ret_predict_6 real_ret_predict_7;
if investor='all';
run;

data real_ret_predict;
set real_ret_predict;
No=_n_;
run;

data real_ret_positive;
set positive_1 positive_2 positive_3 positive_4 positive_5 positive_6 positive_7;
No=_n_;
run;

data real_fullsample_allimb;
merge real_ret_predict real_ret_positive;
by No;
run;




