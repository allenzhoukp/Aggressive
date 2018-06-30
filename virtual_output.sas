data VR_car_BS_pos;
set
VR_earning_car_full_20  VR_earning_car_full_10  VR_earning_car_full_5
VR_earning_car_self_20  VR_earning_car_self_10  VR_earning_car_self_5
VR_restructure_car_full_20  VR_restructure_car_full_10  VR_restructure_car_full_5
VR_restructure_car_self_20  VR_restructure_car_self_10  VR_restructure_car_self_5
VR_infraction_car_full_20  VR_infraction_car_full_10  VR_infraction_car_full_5
VR_infraction_car_self_20  VR_infraction_car_self_10  VR_infraction_car_self_5
VR_lawsuit_car_full_20  VR_lawsuit_car_full_10  VR_lawsuit_car_full_5
VR_lawsuit_car_self_20  VR_lawsuit_car_self_10  VR_lawsuit_car_self_5;
length Type $30.;
if _n_=1 then Type='earning_full_20';
if _n_=2 then Type='earning_full_10';
if _n_=3 then Type='earning_full_5';
if _n_=4 then Type='earning_self_20';
if _n_=5 then Type='earning_self_10';
if _n_=6 then Type='earning_self_5';
if _n_=7 then Type='restructure_full_20';
if _n_=8 then Type='restructure_full_10';
if _n_=9 then Type='restructure_full_5';
if _n_=10 then Type='restructure_self_20';
if _n_=11 then Type='restructure_self_10';
if _n_=12 then Type='restructure_self_5';
if _n_=13 then Type='infraction_full_20';
if _n_=14 then Type='infraction_full_10';
if _n_=15 then Type='infraction_full_5';
if _n_=16 then Type='infraction_self_20';
if _n_=17 then Type='infraction_self_10';
if _n_=18 then Type='infraction_self_5';
if _n_=19 then Type='lawsuit_full_20';
if _n_=20 then Type='lawsuit_full_10';
if _n_=21 then Type='lawsuit_full_5';
if _n_=22 then Type='lawsuit_self_20';
if _n_=23 then Type='lawsuit_self_10';
if _n_=24 then Type='lawsuit_self_5';
drop _type_ _page_ _table_;
run;

data VR_CAR0_1_BS_pos;
set
VR_earning_CAR0_1_full_20  VR_earning_CAR0_1_full_10  VR_earning_CAR0_1_full_5
VR_earning_CAR0_1_self_20  VR_earning_CAR0_1_self_10  VR_earning_CAR0_1_self_5
VR_restructure_CAR0_1_full_20  VR_restructure_CAR0_1_full_10  VR_restructure_CAR0_1_full_5
VR_restructure_CAR0_1_self_20  VR_restructure_CAR0_1_self_10  VR_restructure_CAR0_1_self_5
VR_infraction_CAR0_1_full_20  VR_infraction_CAR0_1_full_10  VR_infraction_CAR0_1_full_5
VR_infraction_CAR0_1_self_20  VR_infraction_CAR0_1_self_10  VR_infraction_CAR0_1_self_5
VR_lawsuit_CAR0_1_full_20  VR_lawsuit_CAR0_1_full_10  VR_lawsuit_CAR0_1_full_5
VR_lawsuit_CAR0_1_self_20  VR_lawsuit_CAR0_1_self_10  VR_lawsuit_CAR0_1_self_5;
length Type $30.;
if _n_=1 then Type='earning_full_20';
if _n_=2 then Type='earning_full_10';
if _n_=3 then Type='earning_full_5';
if _n_=4 then Type='earning_self_20';
if _n_=5 then Type='earning_self_10';
if _n_=6 then Type='earning_self_5';
if _n_=7 then Type='restructure_full_20';
if _n_=8 then Type='restructure_full_10';
if _n_=9 then Type='restructure_full_5';
if _n_=10 then Type='restructure_self_20';
if _n_=11 then Type='restructure_self_10';
if _n_=12 then Type='restructure_self_5';
if _n_=13 then Type='infraction_full_20';
if _n_=14 then Type='infraction_full_10';
if _n_=15 then Type='infraction_full_5';
if _n_=16 then Type='infraction_self_20';
if _n_=17 then Type='infraction_self_10';
if _n_=18 then Type='infraction_self_5';
if _n_=19 then Type='lawsuit_full_20';
if _n_=20 then Type='lawsuit_full_10';
if _n_=21 then Type='lawsuit_full_5';
if _n_=22 then Type='lawsuit_self_20';
if _n_=23 then Type='lawsuit_self_10';
if _n_=24 then Type='lawsuit_self_5';
drop _type_ _page_ _table_;
run;

data VR_n_CAR0_1_BS_pos;
set
VR_earning_n_CAR0_1_full_20  VR_earning_n_CAR0_1_full_10  VR_earning_n_CAR0_1_full_5
VR_earning_n_CAR0_1_self_20  VR_earning_n_CAR0_1_self_10  VR_earning_n_CAR0_1_self_5
VR_restructure_n_CAR0_1_full_20  VR_restructure_n_CAR0_1_full_10  VR_restructure_n_CAR0_1_full_5
VR_restructure_n_CAR0_1_self_20  VR_restructure_n_CAR0_1_self_10  VR_restructure_n_CAR0_1_self_5
VR_infraction_n_CAR0_1_full_20  VR_infraction_n_CAR0_1_full_10  VR_infraction_n_CAR0_1_full_5
VR_infraction_n_CAR0_1_self_20  VR_infraction_n_CAR0_1_self_10  VR_infraction_n_CAR0_1_self_5
VR_lawsuit_n_CAR0_1_full_20  VR_lawsuit_n_CAR0_1_full_10  VR_lawsuit_n_CAR0_1_full_5
VR_lawsuit_n_CAR0_1_self_20  VR_lawsuit_n_CAR0_1_self_10  VR_lawsuit_n_CAR0_1_self_5;
length Type $30.;
if _n_=1 then Type='earning_full_20';
if _n_=2 then Type='earning_full_10';
if _n_=3 then Type='earning_full_5';
if _n_=4 then Type='earning_self_20';
if _n_=5 then Type='earning_self_10';
if _n_=6 then Type='earning_self_5';
if _n_=7 then Type='restructure_full_20';
if _n_=8 then Type='restructure_full_10';
if _n_=9 then Type='restructure_full_5';
if _n_=10 then Type='restructure_self_20';
if _n_=11 then Type='restructure_self_10';
if _n_=12 then Type='restructure_self_5';
if _n_=13 then Type='infraction_full_20';
if _n_=14 then Type='infraction_full_10';
if _n_=15 then Type='infraction_full_5';
if _n_=16 then Type='infraction_self_20';
if _n_=17 then Type='infraction_self_10';
if _n_=18 then Type='infraction_self_5';
if _n_=19 then Type='lawsuit_full_20';
if _n_=20 then Type='lawsuit_full_10';
if _n_=21 then Type='lawsuit_full_5';
if _n_=22 then Type='lawsuit_self_20';
if _n_=23 then Type='lawsuit_self_10';
if _n_=24 then Type='lawsuit_self_5';
drop _type_ _page_ _table_;
run;

data VR_fre_BS_pos;
set
VR_earning_fre_full_20  VR_earning_fre_full_10  VR_earning_fre_full_5
VR_earning_fre_self_20  VR_earning_fre_self_10  VR_earning_fre_self_5
VR_restructure_fre_full_20  VR_restructure_fre_full_10  VR_restructure_fre_full_5
VR_restructure_fre_self_20  VR_restructure_fre_self_10  VR_restructure_fre_self_5
VR_infraction_fre_full_20  VR_infraction_fre_full_10  VR_infraction_fre_full_5
VR_infraction_fre_self_20  VR_infraction_fre_self_10  VR_infraction_fre_self_5
VR_lawsuit_fre_full_20  VR_lawsuit_fre_full_10  VR_lawsuit_fre_full_5
VR_lawsuit_fre_self_20  VR_lawsuit_fre_self_10  VR_lawsuit_fre_self_5;
length Type $30.;
if _n_=1 then Type='earning_full_20';
if _n_=2 then Type='earning_full_10';
if _n_=3 then Type='earning_full_5';
if _n_=4 then Type='earning_self_20';
if _n_=5 then Type='earning_self_10';
if _n_=6 then Type='earning_self_5';
if _n_=7 then Type='restructure_full_20';
if _n_=8 then Type='restructure_full_10';
if _n_=9 then Type='restructure_full_5';
if _n_=10 then Type='restructure_self_20';
if _n_=11 then Type='restructure_self_10';
if _n_=12 then Type='restructure_self_5';
if _n_=13 then Type='infraction_full_20';
if _n_=14 then Type='infraction_full_10';
if _n_=15 then Type='infraction_full_5';
if _n_=16 then Type='infraction_self_20';
if _n_=17 then Type='infraction_self_10';
if _n_=18 then Type='infraction_self_5';
if _n_=19 then Type='lawsuit_full_20';
if _n_=20 then Type='lawsuit_full_10';
if _n_=21 then Type='lawsuit_full_5';
if _n_=22 then Type='lawsuit_self_20';
if _n_=23 then Type='lawsuit_self_10';
if _n_=24 then Type='lawsuit_self_5';
drop _type_ _page_ _table_;
run;

data VR_vol_BS_pos;
set
VR_earning_vol_full_20  VR_earning_vol_full_10  VR_earning_vol_full_5
VR_earning_vol_self_20  VR_earning_vol_self_10  VR_earning_vol_self_5
VR_restructure_vol_full_20  VR_restructure_vol_full_10  VR_restructure_vol_full_5
VR_restructure_vol_self_20  VR_restructure_vol_self_10  VR_restructure_vol_self_5
VR_infraction_vol_full_20  VR_infraction_vol_full_10  VR_infraction_vol_full_5
VR_infraction_vol_self_20  VR_infraction_vol_self_10  VR_infraction_vol_self_5
VR_lawsuit_vol_full_20  VR_lawsuit_vol_full_10  VR_lawsuit_vol_full_5
VR_lawsuit_vol_self_20  VR_lawsuit_vol_self_10  VR_lawsuit_vol_self_5;
length Type $30.;
if _n_=1 then Type='earning_full_20';
if _n_=2 then Type='earning_full_10';
if _n_=3 then Type='earning_full_5';
if _n_=4 then Type='earning_self_20';
if _n_=5 then Type='earning_self_10';
if _n_=6 then Type='earning_self_5';
if _n_=7 then Type='restructure_full_20';
if _n_=8 then Type='restructure_full_10';
if _n_=9 then Type='restructure_full_5';
if _n_=10 then Type='restructure_self_20';
if _n_=11 then Type='restructure_self_10';
if _n_=12 then Type='restructure_self_5';
if _n_=13 then Type='infraction_full_20';
if _n_=14 then Type='infraction_full_10';
if _n_=15 then Type='infraction_full_5';
if _n_=16 then Type='infraction_self_20';
if _n_=17 then Type='infraction_self_10';
if _n_=18 then Type='infraction_self_5';
if _n_=19 then Type='lawsuit_full_20';
if _n_=20 then Type='lawsuit_full_10';
if _n_=21 then Type='lawsuit_full_5';
if _n_=22 then Type='lawsuit_self_20';
if _n_=23 then Type='lawsuit_self_10';
if _n_=24 then Type='lawsuit_self_5';
drop _type_ _page_ _table_;
run;

data Twosample_pos;
set
T_earning_20  T_earning_10  T_earning_5
wil_earning_20  wil_earning_10  wil_earning_5
T_restructure_20  T_restructure_10  T_restructure_5
wil_restructure_20  wil_restructure_10  wil_restructure_5
T_infraction_20  T_infraction_10  T_infraction_5
wil_infraction_20  wil_infraction_10  wil_infraction_5
T_lawsuit_20  T_lawsuit_10  T_lawsuit_5
wil_lawsuit_20  wil_lawsuit_10  wil_lawsuit_5;
length Type $20.;
if _n_=1 then Type='T_earning_20';
if _n_=2 then Type='T_earning_10';
if _n_=3 then Type='T_earning_5';
if _n_=4 then Type='Wil_earning_20';
if _n_=5 then Type='Wil_earning_10';
if _n_=6 then Type='Wil_earning_5';
if _n_=7 then Type='T_restructure_20';
if _n_=8 then Type='T_restructure_10';
if _n_=9 then Type='T_restructure_5';
if _n_=10 then Type='Wil_restructure_20';
if _n_=11 then Type='Wil_restructure_10';
if _n_=12 then Type='Wil_restructure_5';
if _n_=13 then Type='T_infraction_20';
if _n_=14 then Type='T_infraction_10';
if _n_=15 then Type='T_infraction_5';
if _n_=16 then Type='Wil_infraction_20';
if _n_=17 then Type='Wil_infraction_10';
if _n_=18 then Type='Wil_infraction_5';
if _n_=19 then Type='T_lawsuit_20';
if _n_=20 then Type='T_lawsuit_10';
if _n_=21 then Type='T_lawsuit_5';
if _n_=22 then Type='Wil_lawsuit_20';
if _n_=23 then Type='Wil_lawsuit_10';
if _n_=24 then Type='Wil_lawsuit_5';
drop _name_ _label_;
run;

proc export data=VR_n_CAR0_1_BS_pos
   outfile='F:\交易所数据\VR_nobss_unbalanced\VR_n_nobss_CAR0_1_BS_pos'
   dbms=excel
   replace;
 run;

proc export data=VR_CAR0_1_BS_pos
   outfile='F:\交易所数据\VR_nobss_unbalanced\VR_nobss_CAR0_1_BS_pos'
   dbms=excel
   replace;
 run;

proc export data=VR_car_BS_pos
   outfile='F:\交易所数据\VR_nobss_unbalanced\VR_nobss_car_BS_pos'
   dbms=excel
   replace;
 run;

 proc export data=VR_fre_BS_pos
   outfile='F:\交易所数据\VR_nobss_unbalanced\VR_nobss_fre_BS_pos'
   dbms=excel
   replace;
 run;

  proc export data=VR_vol_BS_pos
   outfile='F:\交易所数据\VR_nobss_unbalanced\VR_nobss_vol_BS_pos'
   dbms=excel
   replace;
 run;

 proc export data=Twosample_pos
   outfile='F:\交易所数据\VR_nobss_unbalanced\Twosample_pos'
   dbms=excel
   replace;
 run;
