%let pre=-10;
%let post=10;
%let size=5;

proc sql;
create table select0 as select distinct stock_code_1,event_date,time_trade,date from broker.all_eerbl_60d_imb
where time_trade>=&pre and time_trade<=&post;
quit;

proc sql;
create table select0 as select distinct a.*,b.F11_T0401D,b.F12_T0401D,b.F13_T0401D,b.F14_T0401D,b.branch_province,b.branch_city,b.head_province,b.head_city,b.branch_type,b.head_type,7-input(b.F9_T0401D,6.)*2 as BS,b.F17_T0401D+b.F18_T0401D as netBS
from select0 a left join broker.T_0401D_1 b
on a.stock_code_1=b.F3_T0401D and a.date=b.date and b.F9_T0401D>'2';
quit;

data select1;
set select0;
if branch_city^='';
if time_trade<0;
No_branch=F11_T0401D||F13_T0401D;
run;

proc sql;
create table select2 as select distinct stock_code_1,event_date,branch_province,branch_city,count(distinct No_branch) as count from select1
group by stock_code_1,event_date,branch_province,branch_city;
quit;

data select2;
set select2;
if count>=&size.;
run;

proc sql;
create table select3 as select distinct branch_city,count(stock_code_1) as count from select2
group by branch_city;
quit;

proc sort;
by descending count;
run;

proc sql;
create table select4 as select distinct a.* from select0 a,select2 b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.branch_province=b.branch_province and a.branch_city=b.branch_city;
quit;

proc sql;
create table temp1 as select distinct a.stock_code_1,a.event_date,a.date,a.time_trade,a.return_raw,a.abret_month,a.abret_index 
from broker.all_eerbl_60d_imb a,broker.all_eerbl b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.time_trade>=&pre and a.time_trade<=&post;
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
create table temp1_1 as select distinct a.*,b.F11_T0401D,b.F12_T0401D,b.F13_T0401D,b.F14_T0401D,b.BS,b.netBS,b.branch_province,b.branch_city,b.head_province,b.head_city,b.branch_type,b.head_type
from temp1 a,select4 b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.date=b.date;
quit;

proc sql;
create table temp1_1 as select distinct a.*,b.bbranch_city,b.bhead_city
from temp1_1 a left join broker.bankloan_bank b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sql;
create table temp1_1 as select distinct a.*,b.coparty_city as restructure_coparty
from temp1_1 a left join broker.restructure_coparty b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sql;
create table temp1_1 as select distinct a.*,b.coparty_city as governor_coparty
from temp1_1 a left join broker.governor_event_14 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

data temp1_1;
set temp1_1;
if (branch_city=bbranch_city or branch_city=bhead_city or branch_city=restructure_coparty or branch_city=governor_coparty) and branch_type^='home_city' then branch_type='coparty';
run;

proc sql;
create table temp1_1 as select distinct a.*,b.closeprc
from temp1_1 a left join broker.stock_daily_1 b
on a.stock_code_1=b.stock_code_1 and a.date=b.date;
quit;

proc sort data=temp1_1 out=temp2;
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
set temp1_1;
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
create table temp13 as select distinct a.*,b.date,b.CRR,b.CAR_index,b.CAR_month,b.closeprc from temp13 a left join temp1_1 b
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
create table temp15 as select distinct a.*,b.date,b.CRR as CRR_&post.,b.CAR_index as CAR_index_&post.,b.CAR_month as CAR_month_&post.,b.closeprc as closeprc_&post. from temp15 a left join temp1_1 b
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
create table temp30 as select distinct a.*,b.CRR0_&post.*sign(a.position_before) as CRR0_&post.,b.CAR_index0_&post.*sign(a.position_before) as CAR_index0_&post.,b.CAR_month0_&post.*sign(a.position_before) as CAR_month0_&post.,b.CAR_index0_&post. as index0_10 from temp30 a left join return0_&post b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

proc sort data=temp30;
by stock_code_1 event_date branch_province branch_city head_city branch_type;
run;

proc tabulate data=temp30 out=temp31;
by stock_code_1 event_date branch_province branch_city head_city branch_type;
var CAR_index&post. CAR_month&post.;
weight weight_position;
table (CAR_index&post. CAR_month&post.)*(mean stderr t n);
run;

data temp31;
set temp31;
if CAR_index&post._t^=.;
CAR_index&post._p=(1-probt(abs(CAR_index&post._t),CAR_index&post._N-1))*2;
run;

proc sql;
create table weight as select distinct stock_code_1,event_date,branch_province,branch_city,head_city,branch_type,sum(weight_imb) as weight_imb from temp30
group by stock_code_1,event_date,branch_province,branch_city;
quit;

proc sql;
create table temp31 as select distinct a.*,b.weight_imb from temp31 a left join weight b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and a.branch_province=b.branch_province and a.branch_city=b.branch_city;
quit;

AXIS1 LABEL=('Estimated p-values');
AXIS2 LABEL=('Density');

proc gchart data=temp31;
      vbar car_index&post._p/ type=pct midpoints=0.05 to 0.95 by 0.1 maxis=axis1 raxis=axis2;
run;
quit;

%let lambda=0.8;
%let gamma=0.01;

data temp31;
set temp31;
if CAR_index&post._p>=&lambda. then mark=1;
else mark=0;
if CAR_index&post._t>0 and CAR_index&post._p<=&gamma. then right_tail=1;
else right_tail=0;
if CAR_index&post._t<0 and CAR_index&post._p<=&gamma. then left_tail=1;
else left_tail=0;
if branch_type='home_city' then home_city=1;else home_city=0;
if branch_type='home_city' or branch_type='same_province' then home_province=1;else home_province=0;
if branch_type='fund' then fund=1;else fund=0;
if branch_type='beijing' or (branch_type='home_city' and head_city='北京')then beijing=1;else beijing=0;
if branch_type='shanghai' or (branch_type='home_city' and head_city='上海')then shanghai=1;else shanghai=0;
if branch_type='other' then other=1;else other=0;
run;

proc sql;
create table aaa as select sum(mark)/count(mark)/(1-&lambda.) as zeroCAR,sum(right_tail)/count(right_tail)-0.6*&gamma./2 as posCAR,(sum(right_tail)/count(right_tail)-0.6*&gamma./2)/(sum(right_tail)/count(right_tail)) as posCAR_right,sum(left_tail)/count(left_tail)-0.6*&gamma./2 as negCAR,(sum(left_tail)/count(left_tail)-0.6*&gamma./2)/(sum(left_tail)/count(left_tail)) as negCAR_left from temp31;
quit;

proc sql;
create table temp32_1 as select distinct branch_type,count(branch_type) as count_right,sum(weight_imb) as weight_imb_right from temp31
where right_tail=1
group by branch_type;
quit;

proc sql;
create table temp32_2 as select distinct branch_type,count(branch_type) as count,sum(weight_imb) as weight_imb from temp31
group by branch_type;
quit;

data fraction;
merge temp32_1 temp32_2;
by branch_type;
fraction_count=count_right/count;
fraction_weight_imb=weight_imb_right/weight_imb;
right_tail=&gamma.;
run;


