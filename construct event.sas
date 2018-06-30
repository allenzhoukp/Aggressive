data infraction_resset1;
set broker.infraction_resset;
stock_code_1=_col1;
event_date=_col3;
if event_date ne .;
format stock_code_1 $6.; 
format event_date yymmdd.;
keep stock_code_1 event_date;
run;

data infraction_csmar1;
set broker.infraction_csmar;
stock_code_1=_col1;
event_date=mdy(input(substr(_col3,6,2),6.),input(substr(_col3,9,2),6.),input(substr(_col3,1,4),6.));
if event_date ne .;
format stock_code_1 $6.; 
format event_date yymmdd.;
keep stock_code_1 event_date;
run;

data infraction_wind1;
set broker.infraction_wind;
stock_code_1=substr(_col0,1,6);
event_date=_col2;
if event_date ne .;
format stock_code_1 $6.; 
format event_date yymmdd.;
keep stock_code_1 event_date;
run;

data infraction;
set infraction_resset1 infraction_csmar1 infraction_wind1;
if stock_code_1>='600000';
if event_date>'30jun2007'd;
if event_date<'01jan2009'd;
run;

proc sql;
create table broker.infraction_event as select distinct * from infraction;
quit;

data broker.infraction_important;
set broker.infraction_event;
run;

data lawsuit_resset1;
set broker.lawsuit_resset;
stock_code_1=_col1;
event_date=_col3;
if event_date ne .;
format stock_code_1 $6.; 
format event_date yymmdd.;
keep stock_code_1 event_date;
run;

data lawsuit_wind1;
set broker.lawsuit_wind;
stock_code_1=substr(_col0,1,6);
event_date=_col2;
if event_date ne .;
format stock_code_1 $6.; 
format event_date yymmdd.;
keep stock_code_1 event_date;
run;

data lawsuit;
set lawsuit_resset1 lawsuit_wind1;
if stock_code_1>='600000';
if event_date>'30jun2007'd;
if event_date<'01jan2009'd;
run;

proc sql;
create table broker.lawsuit_event as select distinct * from lawsuit;
quit;

data broker.lawsuit_important;
set broker.lawsuit_event;
run;

data bankloan_event1;
set broker.bankloan_csmar;
if stock_code_1>'599999';
if event_date>'2007-07-31' and event_date<'2009-01-01';
date=mdy(input(substr(compress(event_date),6,2),6.),input(substr(compress(event_date),9,2),6.),input(substr(compress(event_date),1,4),6.));
amount=input(_col6,20.);
format date date.;
rename date=event_date;
keep stock_code_1 date;
run;

data bankloan_event2;
set broker.bankloan_resset;
if stock_code_1>'599999';
if event_date>'31jul07'd and event_date<'01jan09'd;
keep stock_code_1 event_date;
run;

data broker.bankloan_event;
set bankloan_event1 bankloan_event2;
run;

proc sql;
create table broker.bankloan_event as select distinct stock_code_1,event_date from broker.bankloan_event;
quit;

data broker.bankloan_important;
set broker.bankloan_event;
run;

data broker.seo_event;
set broker.seo_csmar;
if stkcd>'599999';
if ailtadt>'2007-07-31' and ailtadt<'2009-01-01';
event_date=mdy(input(substr(compress(ailtadt),6,2),6.),input(substr(compress(ailtadt),9,2),6.),input(substr(compress(ailtadt),1,4),6.));
keep stkcd aitype event_date;
format event_date date.;
rename stkcd=stock_code_1 aitype=type;
run;

data broker.seo_important;
set broker.seo_event;
run;

data broker.spectreat_event;
set broker.spectreat_csmar;
if stkcd>'599999';
if annoudt>'2007-07-31' and annoudt<'2009-01-01';
event_date=mdy(input(substr(compress(annoudt),6,2),6.),input(substr(compress(annoudt),9,2),6.),input(substr(compress(annoudt),1,4),6.));
keep stkcd chgtype event_date;
format event_date date.;
rename stkcd=stock_code_1 chgtype=type;
run;

data broker.spectreat_important;
set broker.spectreat_event;
run;

data broker.dividend_event;
set broker.dividend_csmar;
if _col0>'599999';
if _col4>'2007-07-31' and _col4<'2009-01-01';
event_date=mdy(input(substr(compress(_col4),6,2),6.),input(substr(compress(_col4),9,2),6.),input(substr(compress(_col4),1,4),6.));
keep _col0 event_date;
format event_date date.;
rename _col0=stock_code_1;
run;

data broker.dividend_important;
set broker.dividend_event;
run;

data broker.suspension_event;
set broker.suspension_csmar;
if stkcd>'599999';
if resmdate>'2007-07-31' and resmdate<'2009-01-01';
event_date=mdy(input(substr(compress(resmdate),6,2),6.),input(substr(compress(resmdate),9,2),6.),input(substr(compress(resmdate),1,4),6.));
keep stkcd event_date;
format event_date date.;
rename stkcd=stock_code_1;
run;

data events;
set broker.earning_60d_imb broker.restructure_60d_imb broker.infraction_60d_imb broker.lawsuit_60d_imb broker.bankloan_60d_imb broker.seo_60d_imb broker.spectreat_60d_imb;
if time_trade=0;
run;

data suspension;
set broker.suspension_60d_imb;
if time_trade=0;
run;

proc sql;
create table aaa as select distinct a.stock_code_1,a.event_date,b.stock_code_1 as stock_code_2,b.event_date as event_date_1 from suspension a left join events b
on a.stock_code_1=b.stock_code_1 and a.date=b.date;
quit;

data aaa;
set aaa;
if event_date_1=.;
run;

proc sql;
create table broker.suspension_important as select distinct a.* from broker.suspension_event a, aaa b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date;
quit;

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

proc sql;
create table broker.suspension_important as select distinct a.* from broker.suspension_important a,broker.suspension_text b
where a.stock_code_1=b.stock_code_1 and a.event_date=b.event_date and b.noreport=0;
quit;

data broker.all_event;
set broker.earning_important broker.restructure_important broker.bankloan_important broker.lawsuit_important broker.SEO_important broker.infraction_important broker.spectreat_important broker.suspension_important;
keep stock_code_1 event_date;
run;

proc sql;
create table broker.all_event as select distinct stock_code_1,event_date from broker.all_event;
quit;

data broker.all_important;
set broker.all_event;
run;

data broker.noevent_event;
set broker.T_0401D_4;
rename F3_T0401D=stock_code_1 date=event_date;
keep F3_T0401D date;
run;

data broker.noevent_important;
set broker.noevent_event;
run;
