function [C, CEQ] = NonLinCon(X, OTA, specs,nch,pch)
cc=[1.1,1,0.9];
%% add lines  here relating OTA variables to  X
for i =1:3
OTA.M1.L=X(1);
OTA.M3.L=X(2);
OTA.M5.L=X(3);
OTA.M1.gm_ID=X(4);
OTA.M3.gm_ID=X(5);
OTA.M5.gm_ID=X(6);
OTA.M5.ID=X(7).*cc(i);
OTA.M1.ID=OTA.M5.ID/2 ;
OTA.M3.ID=OTA.M1.ID ;
OTA.M1.gm = OTA.M1.ID*OTA.M1.gm_ID;
OTA.M3.gm = OTA.M1.ID*OTA.M3.gm_ID
OTA.M1.gm_gds=look_up(nch, 'GM_GDS', 'GM_ID', OTA.M1.gm_ID, 'VDS', OTA.M1.VDS, 'L', OTA.M1.L);
OTA.M1.gds = OTA.M1.gm / OTA.M1.gm_gds;
OTA.M3.gm_gds=look_up(pch, 'GM_GDS', 'GM_ID', OTA.M3.gm_ID, 'VDS', OTA.M3.VDS, 'L', OTA.M3.L);
OTA.M3.gds = OTA.M3.gm / OTA.M3.gm_gds;
OTA.M1.gm_cdd = look_up(nch, 'GM_CDD', 'GM_ID', OTA.M1.gm_ID, 'VDS', OTA.M1.VDS, 'L',OTA.M1.L);
OTA.M3.gm_cdd = look_up(pch, 'GM_CDD', 'GM_ID', OTA.M3.gm_ID, 'VDS', OTA.M3.VDS, 'L',OTA.M3.L);
OTA.M1.cdd=OTA.M1.gm/OTA.M1.gm_cdd;
OTA.M3.cdd=OTA.M3.gm/OTA.M3.gm_cdd;
C_total = OTA.M1.cdd+OTA.M3.cdd+specs.CL ;
%% add lines here to calculate specs AVDC_OUT , GBW_OUT
GBW_OUT=( OTA.M1.gm ./(2.*pi.*C_total) );
AVDC_OUT=(OTA.M1.gm /(OTA.M1.gds+OTA.M3.gds)) ;
CEQ = [];
C(2*i) =  10^(specs.AVDC / 20)/ double(AVDC_OUT) - 1;
C(2*i-1) = specs.GBW / double(GBW_OUT) - 1;
end
