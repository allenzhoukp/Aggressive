proc sort data=broker.analyst_coverage out=analyst_coverage;
by stock_code_1;
run;

data analyst_coverage;
set analyst_coverage;
if EPS_2007=. then EPS_2007=0;
if EPS_2008=. then EPS_2008=0;
run;

data analyst_coverage;
set analyst_coverage;
EPS_count=EPS_2007+EPS_2008;
run;

proc sql;
create table analyst_coverage as select * from analyst_coverage
where stock_code_1 in (select F3_T0401D from broker.T_0401D_3);
quit;

proc sql;
create table Marcap as select distinct stock_code_1,mean(_col8) as Marcap_osd,mean(_col9) as Marcap_total from broker.stock_performance_1
where date>='28jun07'd
group by stock_code_1;
quit;

proc sort data=Marcap out=Marcap;
by Marcap_total;
run;

data _null_;
       set Marcap nobs=t;
       call symput("size",t);
       stop;
run;

data Marcap;
set Marcap;
if _n_<=&size./10 then size=1;
if _n_>&size./10 and _n_<=&size./10*2 then size=1;
if _n_>&size./10*2 and _n_<= &size./10*3 then size=1;
if _n_>&size./10*3 and _n_<= &size./10*4 then size=1;
if _n_>&size./10*4 and _n_<= &size./10*5 then size=2;
if _n_>&size./10*5 and _n_<= &size./10*6 then size=2;
if _n_>&size./10*6 and _n_<= &size./10*7 then size=2;
if _n_>&size./10*7 and _n_<= &size./10*8 then size=3;
if _n_>&size./10*8 and _n_<= &size./10*9 then size=3;
if _n_>&size./10*9 and _n_<= &size./10*10 then size=3;
run;

proc sql;
create table analyst_coverage as select distinct a.*,b.marcap_osd,b.marcap_total,b.size from analyst_coverage a left join marcap b
on a.stock_code_1=b.stock_code_1;
quit;

proc sql;
select median(marcap_total) into:size1 from analyst_coverage
where EPS_count=2;
quit;

data analyst_coverage1;
set analyst_coverage;
if EPS_count=0 and Marcap_total>&size1 then delete;
run;

proc sort;
by EPS_count;
run;

data _null_;
       set analyst_coverage1 nobs=t;
       call symput("size",t);
       stop;
run;

proc sql;
select median(EPS_count) into:median from analyst_coverage1;
quit;

data analyst_coverage1;
set analyst_coverage1;
if EPS_count<=&median then Analyst=1;
if EPS_count>&median then Analyst=2;
run;

proc sql;
create table analyst_coverage as select distinct a.*,b.analyst from analyst_coverage a left join analyst_coverage1 b
on a.stock_code_1=b.stock_code_1;
quit;

proc glm data=etc;
 class hydd province_name ownership;
 model etc = hydd province_name ownership share_state log_age sales_to_government sales_to_soe / solution; 
 lsmeans province_name /out=aaa;
run;
quit;

proc sql;
create table analyst_coverage as select distinct a.*,b.LSmean as province_etc from broker.analyst_coverage a left join aaa b
on a.province=b.province_name;
quit;

proc sql;
select median(province_etc) into:median from analyst_coverage;
quit;

data analyst_coverage;
set analyst_coverage;
if province_etc>&median then group_etc=2;
else if province_etc>0 then group_etc=1;
run;
/*
data analyst_coverage;
set analyst_coverage;
logEPS_count=log(1+EPS_count);
logMarcap=log(Marcap_total);
run;

proc reg data=analyst_coverage outest=residual_analyst tableout;
model EPS_count=logMarcap;
run;
quit;

proc sql;
select logMarcap,intercept into:beta, :alpha from residual_analyst
where _type_='PARMS';
quit;

data analyst_coverage;
set analyst_coverage;
residual=EPS_count-&alpha.-&beta.*logMarcap;
run;

proc sort;
by residual;
run;

data _null_;
       set analyst_coverage nobs=t;
       call symput("size",t);
       stop;
run;

proc sql;
select median(residual) into:median from analyst_coverage;
quit;

data analyst_coverage;
set analyst_coverage;
if residual<=&median then Analyst=1;
if residual>&median then Analyst=2;
run;
*/

%macro group(event);
proc sql;
create table &event._important as select distinct a.*,b.Analyst from broker.&event._important a left join analyst_coverage1 b
on a.stock_code_1=b.stock_code_1;
create table &event._important as select distinct a.*,b.size from &event._important a left join analyst_coverage b
on a.stock_code_1=b.stock_code_1;
quit;

proc sort;
by size;
run;
%mend group;

%group(earning);
%group(restructure);
%group(infraction);
%group(lawsuit);
%group(bankloan);
%group(seo);
%group(suspension);
%group(spectreat);
%group(all);
%group(noevent);
%group(stimulus);

