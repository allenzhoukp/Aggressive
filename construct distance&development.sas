data city_ordinate;
set broker.city_ordinate;
province=substr(_col0,1,4);
city=substr(_col2,1,4);
rename _col3=longtitude _col4=latitude;
keep province city _col3 _col4;
run;

proc sort;
by province city;
run;

data city_ordinate;
set city_ordinate;
by province city;
if first.city;
run;

proc sql;
create table city_ordinate as select distinct a.*,b.longtitude as E_Beijing,b.latitude as N_Beijing from city_ordinate a left join city_ordinate b
on b.city='北京';
create table city_ordinate as select distinct a.*,b.longtitude as E_Shanghai,b.latitude as N_Shanghai from city_ordinate a left join city_ordinate b
on b.city='上海';
quit;

%let C=arcos(-1)/180;

data city_ordinate;
set city_ordinate;
D_beijing=arcos(sin(latitude*&C)*sin(N_beijing*&C)+cos(latitude*&C)*cos(N_beijing*&C)*cos((longtitude-E_beijing)*&C))*6371.004;
D_shanghai=arcos(sin(latitude*&C)*sin(N_shanghai*&C)+cos(latitude*&C)*cos(N_shanghai*&C)*cos((longtitude-E_shanghai)*&C))*6371.004;
run;

data city_gdp;
set broker.city_gdp;
province=substr(compress(_col2),1,4);
city=substr(compress(_col1),1,4);
rename _col3=gdp_city;
keep province city _col3;
run;

data province_gdp;
set broker.province_gdp;
province=substr(compress(province),1,4);
rename _007=gdp_province;
keep province _007;
run;

proc sql;
create table distance_gdp as select distinct a.stock_code_1,a.province,a.city,b.D_beijing,b.D_shanghai from broker.industry_address a left join city_ordinate b
on a.province=b.province and a.city=b.city;
create table distance_gdp as select distinct a.*,b.gdp_city from distance_gdp a left join city_gdp b
on a.province=b.province and a.city=b.city;
create table distance_gdp as select distinct a.*,b.gdp_province from distance_gdp a left join province_gdp b
on a.province=b.province;
quit;

proc sql;
create table distance_gdp as select * from distance_gdp
where stock_code_1 in (select F3_T0401D from broker.T_0401D_3);
quit;

data _null_;
       set distance_gdp nobs=t;
       call symput("size",t);
       stop;
run;

proc sort data=distance_gdp out=distance_gdp;
by descending D_beijing;
run;

data distance_gdp;
set distance_gdp;
if _n_<=&size./10 then D_beijing=1;
if _n_>&size./10 and _n_<=&size./10*2 then D_beijing=1;
if _n_>&size./10*2 and _n_<= &size./10*3 then D_beijing=1;
if _n_>&size./10*3 and _n_<= &size./10*4 then D_beijing=1;
if _n_>&size./10*4 and _n_<= &size./10*5 then D_beijing=2;
if _n_>&size./10*5 and _n_<= &size./10*6 then D_beijing=2;
if _n_>&size./10*6 and _n_<= &size./10*7 then D_beijing=2;
if _n_>&size./10*7 and _n_<= &size./10*8 then D_beijing=3;
if _n_>&size./10*8 and _n_<= &size./10*9 then D_beijing=3;
if _n_>&size./10*9 and _n_<= &size./10*10 then D_beijing=3;
run;

proc sort data=distance_gdp out=distance_gdp;
by descending D_shanghai;
run;

data distance_gdp;
set distance_gdp;
if _n_<=&size./10 then D_shanghai=1;
if _n_>&size./10 and _n_<=&size./10*2 then D_shanghai=1;
if _n_>&size./10*2 and _n_<= &size./10*3 then D_shanghai=1;
if _n_>&size./10*3 and _n_<= &size./10*4 then D_shanghai=1;
if _n_>&size./10*4 and _n_<= &size./10*5 then D_shanghai=2;
if _n_>&size./10*5 and _n_<= &size./10*6 then D_shanghai=2;
if _n_>&size./10*6 and _n_<= &size./10*7 then D_shanghai=2;
if _n_>&size./10*7 and _n_<= &size./10*8 then D_shanghai=3;
if _n_>&size./10*8 and _n_<= &size./10*9 then D_shanghai=3;
if _n_>&size./10*9 and _n_<= &size./10*10 then D_shanghai=3;
run;

proc sort data=distance_gdp out=distance_gdp;
by gdp_city;
run;

data distance_gdp;
set distance_gdp;
if _n_<=&size./10 then gdp_city=1;
if _n_>&size./10 and _n_<=&size./10*2 then gdp_city=1;
if _n_>&size./10*2 and _n_<= &size./10*3 then gdp_city=1;
if _n_>&size./10*3 and _n_<= &size./10*4 then gdp_city=1;
if _n_>&size./10*4 and _n_<= &size./10*5 then gdp_city=2;
if _n_>&size./10*5 and _n_<= &size./10*6 then gdp_city=2;
if _n_>&size./10*6 and _n_<= &size./10*7 then gdp_city=2;
if _n_>&size./10*7 and _n_<= &size./10*8 then gdp_city=3;
if _n_>&size./10*8 and _n_<= &size./10*9 then gdp_city=3;
if _n_>&size./10*9 and _n_<= &size./10*10 then gdp_city=3;
run;

proc sort data=distance_gdp out=distance_gdp;
by gdp_province;
run;

data distance_gdp;
set distance_gdp;
if _n_<=&size./10 then gdp_province=1;
if _n_>&size./10 and _n_<=&size./10*2 then gdp_province=1;
if _n_>&size./10*2 and _n_<= &size./10*3 then gdp_province=1;
if _n_>&size./10*3 and _n_<= &size./10*4 then gdp_province=1;
if _n_>&size./10*4 and _n_<= &size./10*5 then gdp_province=2;
if _n_>&size./10*5 and _n_<= &size./10*6 then gdp_province=2;
if _n_>&size./10*6 and _n_<= &size./10*7 then gdp_province=2;
if _n_>&size./10*7 and _n_<= &size./10*8 then gdp_province=3;
if _n_>&size./10*8 and _n_<= &size./10*9 then gdp_province=3;
if _n_>&size./10*9 and _n_<= &size./10*10 then gdp_province=3;
run;

%macro group(event);
proc sql;
create table &event._important as select distinct a.*,b.D_beijing,b.D_shanghai,b.gdp_city,b.gdp_province from broker.&event._important a left join distance_gdp b
on a.stock_code_1=b.stock_code_1;
quit;
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

