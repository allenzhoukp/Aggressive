data temp1;
set broker.T_0401D_1;
if F9_T0401D>'2';
*if date<='31dec2007'd;
run;

proc sql;
create table temp2_0 as select distinct F11_T0401D,F13_T0401D,branch_type from temp1;
quit;

proc sql;
create table temp2_1 as select count(distinct F11_T0401D) as count from temp2_0;
create table temp2_2 as select count(distinct F11_T0401D) as count from temp2_0 where branch_type^='fund';
create table temp2_3 as select count(distinct F11_T0401D) as count from temp2_0 where branch_type='fund';
quit;

data temp2;
set temp2_1 temp2_2 temp2_3;
if _n_=1 then sample='all';
if _n_=2 then sample='branch';
if _n_=3 then sample='fund';
run;

proc sql;
create table temp3 as select distinct F11_T0401D,F3_T0401D,branch_type,count(distinct date) as count from temp1
group by F11_T0401D,F3_T0401D;
quit;

proc sql;
create table temp3_1 as select distinct F3_T0401D,count(distinct date) as total from temp1
group by F3_T0401D;
create table temp3 as select distinct a.*,b.total,a.count/b.total as ratio from temp3 a left join temp3_1 b
on a.F3_T0401D=b.F3_T0401D;
quit;

proc sort;
by descending ratio;
run;

data temp3;
set temp3;
bin_ratio=round(ratio,0.01);
run;

data _null_;
       set temp3 nobs=t;
       call symput("size",t);
       stop;
run;

proc sql;
create table histo_3_1 as select distinct bin_ratio as number,count(bin_ratio)/&size as ratio from temp3
group by bin_ratio;
quit;

data histo_3;
input number;
cards;
0
0.01
0.02
0.03
0.04
0.05
0.06
0.07
0.08
0.09
0.1
0.11
0.12
0.13
0.14
0.15
0.16
0.17
0.18
0.19
0.2
0.21
0.22
0.23
0.24
0.25
0.26
0.27
0.28
0.29
0.3
0.31
0.32
0.33
0.34
0.35
0.36
0.37
0.38
0.39
0.4
0.41
0.42
0.43
0.44
0.45
0.46
0.47
0.48
0.49
0.5
0.51
0.52
0.53
0.54
0.55
0.56
0.57
0.58
0.59
0.6
0.61
0.62
0.63
0.64
0.65
0.66
0.67
0.68
0.69
0.7
0.71
0.72
0.73
0.74
0.75
0.76
0.77
0.78
0.79
0.8
0.81
0.82
0.83
0.84
0.85
0.86
0.87
0.88
0.89
0.9
;
run;

proc sql;
create table histo_3 as select distinct a.*,b.ratio from histo_3 a left join histo_3_1 b
on a.number=b.number;
quit;

data histo_3;
set histo_3;
if ratio=. then ratio=0;
run;

proc sql;
create table temp4 as select distinct F11_T0401D,count(date) as count from temp1
group by F11_T0401D;
quit;

proc sort;
by descending count;
run;

proc sql;
create table temp5_1 as select distinct F11_T0401D,mean(ratio) as average_appearing_rate from temp3
/*where F11_T0401D in (select F11_T0401D from aaa)*/
group by F11_T0401D;
create table temp5_2 as select distinct F3_T0401D,mean(ratio) as mean,sum(ratio*ratio) as Herfin from temp3
group by F3_T0401D;
quit;

ods graphics on;
   proc kde data=temp5_1;
      univar average_appearing_rate / plots=(density);
   run;   
ods graphics off;




