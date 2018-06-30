data temp1;
set broker.suspension_csmar;
if stkcd>'599999';
if resmdate>'2007-07-31' and resmdate<'2009-01-01';
event_date=mdy(input(substr(compress(resmdate),6,2),6.),input(substr(compress(resmdate),9,2),6.),input(substr(compress(resmdate),1,4),6.));
format event_date date.;
rename stkcd=stock_code_1;
run;

proc sql;
create table temp2 as select distinct a.* from temp1 a,broker.suspension_important b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

data temp2;
set temp2;
reason=compress(reason);
run;

proc sort;
by reason;
run;

data temp2;
set temp2;
noreport_meeting=index(reason,'未刊登');
run;

data temp2;
set temp2;
if noreport_meeting=0 then meeting=index(reason,'股东大会');
run;

data temp2;
set temp2;
if meeting=0 then meeting=index(reason,'股东年会');
run;

data temp2;
set temp2;
if meeting=0 then meeting=index(reason,'股东周年');
run;

data temp2;
set temp2;
if meeting=0 then fluctuation=index(reason,'异常波动');
run;

data temp2;
set temp2;
if fluctuation=0 then noreport=index(reason,'未公告');
run;

data temp2;
set temp2;
if noreport=0 then noreport=index(reason,'未及时');
run;

proc sort data=temp2 out=broker.suspension_text;
by descending noreport_meeting descending meeting descending fluctuation descending noreport;
run;









