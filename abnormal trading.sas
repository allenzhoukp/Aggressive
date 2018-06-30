/* Create table imbalance [-10, -1] from all_eerbl_60days_imbalance.
   Sum up abnormal return for an index -> indexb10, abnormal return for a month -> monthb10 (guessed).
   Sum up adjusted imbalance for investors grouped in beijing, shanghai, other, homecity, homeprovince, and fund.
   All sums are through time horizons. (sum up all lines with same stock code and event date.)
*/
proc sql;
create table imb_b10 as select distinct stock_code_1,event_date /*distinct: no redunant lines*/
,sum(abret_index) as indexb10, sum(abret_month) as monthb10
,sum(all_imb_adj) as all_imbb10
,sum(beijing_imb_adj) as beijing_imbb10
,sum(shanghai_imb_adj) as shanghai_imbb10
,sum(other_imb_adj) as other_imbb10
,sum(home_city_imb_adj) as home_city_imbb10
,sum(home_province_imb_adj) as home_province_imbb10
,sum(fund_imb_adj) as fund_imbb10
from broker.all_eerbl_60d_imb
where time_trade<=-1 and time_trade>=-10
group by stock_code_1,event_date;
quit;

/* Create table abnormal_1 from all_eerbl_60days_imbalance
Simply choose stock code, event date, date, time_trade (days before event), raw return, abreturn_month, abreturn_index.
*/
proc sql;
create table abnormal_1 as select distinct a.stock_code_1,a.event_date,a.date,a.time_trade,a.return_raw,a.abret_month,a.abret_index
from broker.all_eerbl_60d_imb a;
quit;

* Looks like by default use the last dataset created.;
proc sort;
by stock_code_1 event_date time_trade;
run;

/* Left join T_0401D_1 (top 10 trading data) on stock_code == F3 and date.
See 前十名营业部数据/TopView数据词典——dep.docx for variables.
F11: 营业部代码 exchange_code
F12: 营业部名称 exchange_name
F13: 会员代码 broker/fund_code
F14: 会员名称 broker/fund_name (exact meaning?)
F9: 排名类型 rank_type 1-total buy amoount, 2-total sell amoount, 3-net buy amoount, 4-net sell amoount
    Here converted to BS = 1, -1 since original value controlled 3/4.
F17: 营业部净买入金额 exchange net buy (cannot be negative)
F18: 营业部净卖出金额 exchange net sell (cannot be negative)
    NetBS: Absolute value of net trade
Note: it takes like half an hour to run.
*/
proc sql;
create table abnormal_1 as select distinct a.*,b.F11_T0401D,b.F12_T0401D,b.F13_T0401D,b.F14_T0401D,7-input(b.F9_T0401D,6.)*2 as BS,b.F17_T0401D+b.F18_T0401D as netBS
,b.branch_province,b.branch_city,b.head_province,b.head_city,b.branch_type,b.head_type
from abnormal_1 a left join broker.T_0401D_1 b
on a.stock_code_1=b.F3_T0401D and a.date=b.date and b.F9_T0401D>'2';
quit;

/* select stock_code, event_date,exchange_code&name, fund_code&name, branch type, head_type, position (net buy allowing negative)
for time span [-10, 0) = [-10, -1]
*/
proc sql;
create table abnormal_2 as select distinct stock_code_1,event_date,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,branch_type,head_type,sum(BS*netBS) as position
from abnormal_1
where time_trade<0 and time_trade>=-10
group by stock_code_1,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,event_date;
quit;

/* Left_join imb_b10 and grab all_imbalance_b10. */
proc sql;
create table abnormal_2 as select distinct a.*,b.all_imbb10 from abnormal_2 a left join imb_b10 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

/* CAR0_1: sum up abnormal_return_index from all_eerbl_60d_imb within [-10, -1] as index0_1. */
proc sql;
create table CAR0_1 as select distinct stock_code_1,event_date,sum(abret_index) as index0_1
from broker.all_eerbl_60d_imb
where time_trade>=0 and time_trade<=10
group by stock_code_1,event_date;
quit;

/* Left_join CAR0_1 to grab sum of abnormal_return_index. */
proc sql;
create table abnormal_2 as select distinct a.*,b.index0_1 from abnormal_2 a left join CAR0_1 b
on a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

/* average volume from broker.imb2.
F3: stock code
F8: 期间内总成交额 total volume for a day. */
proc sql;
create table avg_vol as select distinct F3_T0401D as stock_code_1,mean(F8_T0401D) as avg_vol from broker.imb2
group by F3_T0401D;
quit;

/* merge abnormal_2 and avg_vol. (outer join?) */
data abnormal_2;
merge abnormal_2 avg_vol;
by stock_code_1;
run;

/* imb is aggressive imbalance def in pg 14.
imb_allimb?
return = sign of imb * car? (so the return is negative when there is net sell?)*/
data abnormal_2;
set abnormal_2;
imb=position/avg_vol;
absolute_imb=abs(position/avg_vol);
imb_allimb=imb*all_imbb10;
return=index0_1*sign(imb);
if position^=.;
run;

proc sort data=abnormal_2;
by stock_code_1 F11_T0401D F12_T0401D F13_T0401D F14_T0401D;
run;

/* grab mean and variance of absolute imbalance and merge into abmormal 2. */
proc sql;
create table abnormal_3 as select distinct stock_code_1,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,mean(absolute_imb) as mean_imb,std(absolute_imb) as std_imb
from abnormal_2
group by stock_code_1,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D;
quit;

data abnormal_2;
merge abnormal_2 abnormal_3;
by stock_code_1 F11_T0401D F12_T0401D F13_T0401D F14_T0401D;
run;

/* delete all rows that standardized absolute imbalance < 1 in abnormal_4. */
data abnormal_4;
set abnormal_2;
if std_imb=. then delete;
else if (absolute_imb-mean_imb)/std_imb<1 then delete;
run;

/* Count the number for each event and delete all count==0 ones in abnormal_4_count. */
proc sql;
create table abnormal_4_count as select distinct stock_code_1,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D,count(distinct event_date) as count from abnormal_4
group by stock_code_1,F11_T0401D,F12_T0401D,F13_T0401D,F14_T0401D;
quit;

data abnormal_4_count;
set abnormal_4_count;
if count>1;
run;

/* Abnormal_5 is abnormal_4 w/o any standardized imbalance < 1 trading activity. */
proc sql;
create table abnormal_5 as select distinct a.* from abnormal_4 a,abnormal_4_count b
where a.stock_code_1=b.stock_code_1 and a.F11_T0401D=b.F11_T0401D and a.F12_T0401D=b.F12_T0401D and a.F13_T0401D=b.F13_T0401D and a.F14_T0401D=b.F14_T0401D;
quit;


/* sort by imb_allimb */
/* This is a list of decile-return table, containing mean and t. */
/* (As far as I know ther is no table containing DEciles. So it might be a deprecated version of code? ) */
proc sort data=abnormal_4;
by descending imb_allimb;
run;

data _null_;
       set abnormal_4 nobs=t;
       call symput("size",t);
       stop;
run;

data abnormal_4;
set abnormal_4;
if _n_<=&size./100 then decile=1;
if _n_>&size./100 and _n_<=&size./100*5 then decile=2;
if _n_>&size./100*5 and _n_<= &size./100*10 then decile=3;
if _n_>&size./100*10 and _n_<=&size./100*20 then decile=4;
if _n_>&size./100*20 and _n_<=&size./100*30 then decile=5;
if _n_>&size./100*30 and _n_<=&size./100*50 then decile=6;
if _n_>&size./100*50 and _n_<=&size./100*70 then decile=7;
if _n_>&size./100*70 and _n_<=&size./10*8 then decile=8;
if _n_>&size./10*8 and _n_<=&size./10*9 then decile=9;
if _n_>&size./10*9 and _n_<=&size./10*10 then decile=10;
run;

proc tabulate data=abnormal_4 out=aaa;
by decile;
var return;
weight absolute_imb;
table (return)*(mean t);
run;
