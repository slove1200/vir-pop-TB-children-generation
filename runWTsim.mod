
$SIZES      MAXIDS=200000 NO=500
$PROBLEM    dose 100 BDQ
;$INPUT      ID GENDER AGEM PMA ZSCORE BW ACTYPE RAND CL DRUG DV ONEDV
$INPUT      ID DV
$DATA       WT_base.csv IGNORE=@ 
$PRED
;--- Simulations to define study participants

IF(ICALL.EQ.4.AND.NEWIND.NE.2) THEN

	;Assign sex, probability 50/50
	CALL RANDOM (2, R)						
	SEXSIM = 1
	IF(R.GE.0.5) THEN 
	SEXSIM = 2
	ENDIF

	;Assign z-score, normal distribution with mean 0 and variance 1
	CALL RANDOM (3, R)
	ZSCORESIM = R
	
	;Assign age, uniform distribution within each cohort
	CALL RANDOM (4, R)
	;Simulate age <= 15 yrs (i.e. 180 months)
	AGESIM = 0.01 + 180*R		
	AGEY = AGESIM/12
	
	
	;--- Calculate WT from approximated LMS formula, R script LMS_approximations.R  
	;male, SEX=1
	L1_1 = 0.2473
	L1_2 = -0.01914
	L1_3 = 0.0004106
	L1_4 = -0.000003433
	L1_5 = 0
	L1_6 = 0

	L2_1 = 0.0379
	L2_2 = 0.006517
	L2_3 = -0.0002416
	L2_4 = 0.00000114

	L3_1 = 37.76
	L3_2 = -1.039
	L3_3 = 0.01001
	L3_4 = -0.00004116
	L3_5 = 0.00000006124

	S1_1 = 0.1462
	S1_2 = -0.01461
	S1_3 = 0.001932
	S1_4 = -0.00008632

	S2_1 = 0.1114
	S2_2 = -0.0007144
	S2_3 = 0.00005574
	S2_4 = -0.000001045
	S2_5 = 0.000000007091

	S3_1 = 0.1001
	S3_2 = 0.001006
	S3_3 = -0.00001287
	S3_4 = 0.00000007423

	S4_1 = 0.03601
	S4_2 = -0.004196
	S4_3 = 0.0001062
	S4_4 = -0.0000006664
	S4_5 = 0.000000001284

	M_1= 4.904809
	M_2= 0.4209516
	M_3= -0.005652092
	M_4= 0.0000459995
	M_5= -0.00000010448529

	IF(SEXSIM.EQ.2) THEN
		L1_1 = 0.2894
		L1_2 = -0.08659
		L1_3 = 0.005358
		L1_4 = -0.0001654
		L1_5 = 0.00000245
		L1_6 = -0.00000001386

		L2_1 = -0.1719
		L2_2 = -0.006149
		L2_3 = 0.00002171
		L2_4 = 0

		L3_1 = 21.71
		L3_2 = -0.6754
		L3_3 = 0.007321
		L3_4 = -0.00003391
		L3_5 = 0.00000005628

		S1_1 = 0.1424
		S1_2 = -0.007525
		S1_3 = 0.0008634
		S1_4 = -0.00003018

		S2_1 = 0.1191
		S2_2 = 0.0006519
		S2_3 = -0.00004486
		S2_4 = 0.000001349
		S2_5 = -0.00000001082

		S3_1 = 0.1012
		S3_2 = 0.0007674
		S3_3 = -0.000001416
		S3_4 = 0

		S4_1 = -0.2138
		S4_2 = 0.004139
		S4_3 = 0.00001957
		S4_4 = -0.0000003040
		S4_5 = 0.0000000007493

		M_1= 4.832
		M_2= 0.3743
		M_3= -0.004874
		M_4= 0.00004466
		M_5= -0.0000001167
	ENDIF
	
	; L - piece-wise polynomial

	IF(AGESIM.LE.60) THEN
		L = L1_1  + L1_2*AGESIM  + L1_3*(AGESIM**2) + L1_4*(AGESIM**3) + L1_5*(AGESIM**4) + L1_6*(AGESIM**5)
	ELSEIF(AGESIM.GT.60.AND.AGESIM.LE.120) THEN 
		L = L2_1  + L2_2*AGESIM  + L2_3*(AGESIM**2) + L2_4*(AGESIM**3) 
	ELSE
		L = L3_1  + L3_2*AGESIM  + L3_3*(AGESIM**2) + L3_4*(AGESIM**3) + L3_5*(AGESIM**4) 
	ENDIF

	
	; S - piece-wise polynomial

	IF(AGESIM.LE.8) THEN
		SX = S1_1  + S1_2*AGESIM  + S1_3*(AGESIM**2) + S1_4*(AGESIM**3) 
	ELSEIF(AGESIM.GT.8.AND.AGESIM.LE.60) THEN
		SX = S2_1  + S2_2*AGESIM  + S2_3*(AGESIM**2) + S2_4*(AGESIM**3) + S2_5*(AGESIM**4) 
	ELSEIF(AGESIM.GT.60.AND.AGESIM.LE.120) THEN 
		SX = S3_1  + S3_2*AGESIM  + S3_3*(AGESIM**2) + S3_4*(AGESIM**3) 
	ELSE
		SX = S4_1  + S4_2*AGESIM  + S4_3*(AGESIM**2) + S4_4*(AGESIM**3) + S4_5*(AGESIM**4) 
	ENDIF
	
	; M - 4th degree polynomial function
	M = M_1  + M_2*AGESIM  + M_3*(AGESIM**2) + M_4*(AGESIM**3) + M_5*(AGESIM**4)

	; corrected for TB 
	CORR_MM = 0.95 - 0.30/(1+EXP(-0.4*(AGESIM/12-6)))

	; --- Calculate wt from predicted L,M and S values
	WTSIM = M*CORR_MM*((ZSCORESIM*L*SX)+1)**(1/L)
	
	; Safety to prevent calculations with WT=0
	IF(WTSIM.LE.0) WTSIM = 0.1
	
ENDIF

; -- Assign the simulated values to the right variable
IF(ICALL.EQ.4) THEN
	SEX =SEXSIM
	ZSCORE =ZSCORESIM
	WT =WTSIM
	AGE =AGESIM
ENDIF


Y=WT

$SIMULATION (1498428) (2345 UNIFORM) (3456) (4567 UNIFORM) ONLYSIM 
$TABLE ID SEX AGE WT ZSCORE DV NOPRINT NOAPPEND ONEHEADER NOTITLE FORMAT=s1PE13.7 FILE=simtab_WT_15.tab