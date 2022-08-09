Program DIMENSIONAMENTO_CORREIAS_ANA_LUIZA_MATRICULA_120110082;

CONST
		MMAX = 50;
		NMAX = 50;
		PI = 3.1416;
		E = 2.71828;
	
TYPE
	MATRIZ = ARRAY[1..MMAX,1..NMAX] OF REAL;
	
	VETOR_STRING = ARRAY[1..MMAX] OF STRING;
	VETOR_INTEGER = ARRAY[1..MMAX] OF INTEGER;
	VETOR_REAL = ARRAY[1..MMAX] OF REAL;
	
			
VAR		
  ENTRADA, SAIDA:TEXT;
  ARQUIVOENTRADA, ARQUIVOSAIDA,PERFIL,REFERENCIA_A: STRING;
  N,M,I,J,K,Z,W,Z2,CZ,CT,SER,PE,ROTACAO,CV_MOTOR: INTEGER;
  RPM2,RPM1,Pmotor,C,ATRITO,FS,Pp,D1,D1_POL,D1_R,D2,D2_R,LL,LC,Fcc,
	RT,LA,D2_D1_LA,F_H,D2D1CA,CA,XINT,YINT,Fcac,ALFA,RPM1_R,
	Pb, Pa, Ppc, Nco, MT1, FT, IALFARAD, ARCO_C, F1_F2, F2, F1, FR: REAL;
  FS1,FS2,D_MINIMO,CV_BASICO, CV_ADICIONAL: MATRIZ;

  REF_PERFIL_A: VETOR_STRING;
  C_PADRAO : VETOR_INTEGER;
  F_CORRECAO,D2D1_LA, FATORH,D2D1_CA, FATOR_Fcac,X,y,L,ANGULO_GRAUS : VETOR_REAL;
  
 
 
PROCEDURE LEITURA_DE_DADOS;
	BEGIN      
     //LEITURA DOS VALORES, CRIA VARIAVEIS E ATRIBUI A CADA VARIAVEL O VALOR LIDO;
		 ASSIGN(ENTRADA,'DDADOS_ENUNCIADO.PAS');
     RESET (ENTRADA);
		 
		 READ (ENTRADA, RPM2, RPM1, Pmotor, C, ATRITO);
	
	//LEITURA DOS DADOS DO ARQUIVO - DFATOR_SERVICO.PAS
     ASSIGN (ENTRADA, 'DFATOR_SERVICO.PAS');
     RESET (ENTRADA);
  
	//DADOS DA TABELA 1 DO FATOR DE SERVICO
		 READ (ENTRADA, M,N);
		 FOR I:= 1 TO M DO
     		FOR J:= 1 TO N DO
     			READ (ENTRADA, FS1[I,J]);
  //DADOS DA TABELA 2 DO FATOR DE SERVICO    			
		 READ (ENTRADA, M,N);
		 FOR I:= 1 TO M DO
     		FOR J:= 1 TO N DO
     			READ (ENTRADA, FS2[I,J]); 
  END;

PROCEDURE LEITURA_REF_LC_FCORRECAO;
	BEGIN
		//"LINKAR O SUB_PROG_05 COM O ARQUIVO D_REF_LC_FATOR.PAS
		ASSIGN (ENTRADA,'D_REF_LC_FATOR.PAS');
		RESET (ENTRADA);   //ABRI O ARQUIVO;
		
		READLN (ENTRADA, M); //LER AS DIMENSOES DO VETOR
		
		//LEITURA DAS REFERENCIAS E ATRUBUI-LAS AO VETOR: REF_PERFIL_A[I]
		FOR I:= 1 TO M DO
			READ (ENTRADA, REF_PERFIL_A[I]);
			
	  //LEITURA DOS VALORES PADRAO E ATRIBUI-LOS AO VETOR:C_PADRAO[I];
		FOR I:= 1 TO M DO
			READ (ENTRADA, C_PADRAO[I]);

	  //LEITURA DOS VALORES DO FATOR DE CORRECAO
		// E ATRIBUI-LOS AO VETOR:F_CORRECAO[I];
		FOR I:= 1 TO M DO
			READ (ENTRADA, F_CORRECAO[I]);			
	END;  


PROCEDURE LEITURA_CV_BASICO_ADICIONAL;
	BEGIN
	  //LEITURA DOS VALORES DO ARQUIVO EXTERNO (DCV_BAS_ADI.PAS) E ATRIBUI-LAS 
		//A VARIAVEL CV_BASICO[I,J]
		
		//LEITURA DAS DIMENSÕES DO VETOR BIDIMENSIONAL (M,N);
		//"LINKAR" O ARQUIVO EXTERNO AO PROGRAMA (SUB_PROGRAMA_8_CAPACIDADE.PAS)
		ASSIGN (ENTRADA, 'DCV_BAS_ADI.PAS');
		RESET (ENTRADA);
		
		READ(ENTRADA, M,N);
		FOR I:= 1 TO M DO
			FOR J:= 1 TO N DO
			   READ (ENTRADA, CV_BASICO[I,J]);

		READ(ENTRADA, M,N);
		FOR I:= 1 TO M DO
			FOR J:= 1 TO N DO
			   READ (ENTRADA, CV_ADICIONAL[I,J]);			   
	END;	

PROCEDURE MAQUINAS_CONDUZIDAS_CZ;
	BEGIN
	  WRITELN;
	  WRITELN ('**** MAQUINAS CONDUZIDAS *****');
		WRITELN ('1. AGITADORES PARA LIQUIDOS');
	  WRITELN ('	 COMPRESSORES');
	  WRITELN ('2. CORREIAS TRANSPORTADORAS PARA AREIA E CEREAIS');
		WRITELN ('	 PENEIRAS VIBRATORIAS ROTATIVAS');
		WRITELN ('3. MAQUINA PARA OLARIA');
		WRITELN ('	 MAQUINARIOS TEXTEIS');
		WRITELN ('   COMPRESSORES DE PISTAO');												
		WRITELN ('4. BRITADORES');
		WRITELN ('	 MISTURADORES, CALANDRAS...');
		WRITE ('DIGITE O VALOR REFERENTE A MAQUINA CONDUZIDA ');
		READ (CZ);
	END;
	
	
PROCEDURE MAQUINAS_CONDUTORAS_CT;
	BEGIN
	  WRITELN;
		WRITELN ('***** MAQUINAS CONDUTORAS ****');
	  WRITELN ('1. MOTORES AC: TORQUE NORMAL');
	  WRITELN ('   COMBUSTAO INTERNA DE MULTIPLOS CILINDROS ');
	  WRITELN ('2. MOTORES AC: ALTO TORQUE');
	  WRITELN ('   EMBREAGENS');
	  WRITE ('DIGITE O NUMERO CORRESPONDENTE AO TIPO DE MOTOR CONDUTOR = ');
	  READ (CT);
	END;
	
	
PROCEDURE TIPO_DE_SERVICO_SER;
	BEGIN
	    WRITELN;
	    WRITELN ('***** TIPOS DE SERVICOS *****');
	    WRITELN ('1. SERVICO INTERMITENTE');
	    WRITELN ('2. SERVICO NORMAL');
	    WRITELN ('3. SERVICO CONTINUO');
	    WRITE ('DIGITE O NUMERO CORRESPONDENTE AO TIPO DE SERVICO = ');
	    READ (SER);
	END;	  
	  
PROCEDURE OBTENCAO_FATOR_DE_SERVICO_FS;
	BEGIN
	  MAQUINAS_CONDUZIDAS_CZ;
    MAQUINAS_CONDUTORAS_CT;
    TIPO_DE_SERVICO_SER;
    
    IF CT = 1 THEN FS := FS1[CZ,SER];
    IF CT = 2 THEN FS := FS2[CZ,SER];
	END;
	
	
PROCEDURE POTENCIA_PROJETADA_Pp;
	BEGIN
	  Pp := FS * Pmotor;
	END;	



PROCEDURE IDENTIFICAR_PERFIL_CORREIA;
	Begin
   	WRITELN ('POTENCIA PROJETADA - Pp = ', Pp:5:2);
  	WRITELN ('A ROTAÇÃO DA POLIA DA MAQUINA CONDUTORA - RPM1= ',RPM1);
  	WRITELN ('SELECIONE O PERFIL DA CORREIA HI-POWER II - GRAFICO 2');
  	WRITELN ('1. SE O PERFIL A');
  	WRITELN ('2. SE O PERFIL B');
  	WRITELN ('3. SE O PERFIL C');
  	WRITELN ('4. SE O PERFIL D');
  	WRITELN ('5. SE O PERFIL E');
		READ (PE);
		
		IF PE = 1 THEN PERFIL := 'PERFIL_A';
		IF PE = 2 THEN PERFIL := 'PERFIL_B';		
		IF PE = 3 THEN PERFIL := 'PERFIL_C';		
		IF PE = 4 THEN PERFIL := 'PERFIL_D';		
		IF PE = 5 THEN PERFIL := 'PERFIL_E';						  	
	End;
	
	
PROCEDURE NORMALIZAR_DIAMETROS (VAR D1,D1_R: REAL; VAR Z:INTEGER);
	BEGIN		
		IF  D1 <= 65 									THEN BEGIN D1_R:= 65;  Z:= 1;END;
		IF (D1 > 65) 	AND (D1 <= 70) 	THEN BEGIN D1_R:= 70;  Z:= 2;END;
		IF (D1 > 70) 	AND (D1 <= 75) 	THEN BEGIN D1_R:= 75;  Z:= 3;END;				
		IF (D1 > 75) 	AND (D1 <= 80) 	THEN BEGIN D1_R:= 80;	 Z:= 4;END;  
		IF (D1 > 80) 	AND (D1 <= 85) 	THEN BEGIN D1_R:= 85;  Z:= 5;END;
		IF (D1 > 85)	AND (D1 <= 90) 	THEN BEGIN D1_R:= 90;	 Z:= 6;END;				
		IF (D1 > 90) 	AND (D1 <= 95) 	THEN BEGIN D1_R:= 95;	 Z:= 7;END;	
		IF (D1 > 95) 	AND (D1 <= 100) THEN BEGIN D1_R:= 100; Z:= 8;END;	
		IF (D1 > 100) AND (D1 <= 105) THEN BEGIN D1_R:= 105; Z:= 9;END;		
		IF (D1 > 105) AND (D1 <= 110) THEN BEGIN D1_R:= 110; Z:= 10;END;		
		IF (D1 > 110) AND (D1 <= 115) THEN BEGIN D1_R:= 115; Z:= 11;END;		
		IF (D1 > 115) AND (D1 <= 120) THEN BEGIN D1_R:= 120; Z:= 12;END;		
		IF (D1 > 120) AND (D1 <= 125) THEN BEGIN D1_R:= 125; Z:= 13;END;		
		IF (D1 > 125) AND (D1 <= 130) THEN BEGIN D1_R:= 130; Z:= 14;END;	
		IF (D1 > 130) AND (D1 <= 135) THEN BEGIN D1_R:= 135; Z:= 15;END;	
		IF (D1 > 135) AND (D1 <= 140) THEN BEGIN D1_R:= 140; Z:= 16;END;				
    IF (D1 > 140) AND (D1 <= 145) THEN BEGIN D1_R:= 145; Z:= 17;END;			
		IF (D1 > 145) AND (D1 <= 150) THEN BEGIN D1_R:= 150; Z:= 18;END;		
		IF (D1 > 150) AND (D1 <= 155) THEN BEGIN D1_R:= 155; Z:= 19;END;				
		IF (D1 > 155) AND (D1 <= 160) THEN BEGIN D1_R:= 160; Z:= 20;END;				
		IF (D1 > 160) AND (D1 <= 165) THEN BEGIN D1_R:= 165; Z:= 21;END;		
		IF (D1 > 165) AND (D1 <= 170) THEN BEGIN D1_R:= 170; Z:= 22;END;
    IF (D1 > 170) AND (D1 <= 175) THEN BEGIN D1_R:= 175; Z:= 23;END;		
		IF (D1 > 175) AND (D1 <= 180) THEN BEGIN D1_R:= 180; Z:= 24;END;
		IF (D1 > 180) AND (D1 <= 185) THEN BEGIN D1_R:= 185; Z:= 25;END;
		IF (D1 > 185) AND (D1 <= 190) THEN BEGIN D1_R:= 190; Z:= 26;END;
	END;			
	
	
PROCEDURE OBTENCAO_DIAMETRO_MINIMO;
	BEGIN
	  //TABELA 5 - ABRIR E LER OS VALORES DO ARQUIVO - D_DIAMETRO_MINIMO;
	  ASSIGN (ENTRADA, 'DMOTOR.PAS');
	  RESET (ENTRADA);
	  
		READ (ENTRADA,M,N);
	  FOR I:= 1 TO M DO
	  	FOR J:= 1 TO N DO
	  	READ (ENTRADA, D_MINIMO[I,J]);

		WRITELN;
		WRITELN ('***** VALORES DAS ROTACOES ****');
		WRITELN ('1. ROTACAO = 575 ');
		WRITELN ('2. ROTACAO = 690 ');	
		WRITELN ('3. ROTACAO = 870 ');	
		WRITELN ('4. ROTACAO = 1160 ');	
		WRITELN ('5. ROTACAO = 1750 ');	
		WRITELN ('6. ROTACAO = 3450 ');	
		WRITE ('DIGITE O VALOR DA ROTACAO - IGUAL OU O MAIS PROXIMO = ');
		READ (ROTACAO);
	
		WRITELN;
		WRITELN ('***** CV DO MOTOR *****');
		WRITELN ('1. CV = 1/2');	
		WRITELN ('2. CV = 3/4');		
		WRITELN ('3. CV = 1');		
		WRITELN ('4. CV = 1.1/2');
		WRITE ('DIGITE O NUMERO CORRESPONDENTE AO CV = ');
		READ (CV_MOTOR);
	
	//COM VALORES DE ROTACAO E CV_MOTOR OBTEM-SE O DIAMETRO_MINIMO
	D1_POL := D_MINIMO[CV_MOTOR,ROTACAO];
	D1  := D1_POL * 25.4;
   
	 //NORMALIZACAO DO DIAMETRO D1 === D1_R
		NORMALIZAR_DIAMETROS (D1,D1_R,Z);

		//CALCULO DE D2
		RT := RPM1/RPM2;
	  D2 := D1_R * RT;
	  
	  //NORMALIZACAO DO DIAMETRO D2 === D2_R
	  NORMALIZAR_DIAMETROS (D2,D2_R,Z2);
   
	END;	


PROCEDURE OBTENCAO_LC_REF_FATOR;
	BEGIN
	  FOR I:= 1 TO M DO
		  IF (LL = C_PADRAO[I]) THEN
		  												BEGIN
		  												    LC := C_PADRAO[I];
		  												    REFERENCIA_A := REF_PERFIL_A[I];
		  												    Fcc := F_CORRECAO[I];
		  												END
													 ELSE
			 IF (LL>C_PADRAO[I]) AND (LL<C_PADRAO[I+1])
		  										THEN		
															BEGIN
		  												    LC := C_PADRAO[I+1];
		  												    REFERENCIA_A := REF_PERFIL_A[I+1];
		  												    Fcc := F_CORRECAO[I+1];
		  												END;													     
													 		    
	END;


PROCEDURE COMPRIMENTO_DA_CORREIA_LL;
	BEGIN
	   LL := 2*C + 1.57*(D2_R + D1_R) + SQR(D2_R - D1_R)/(4*C);
	END;
	
	

PROCEDURE OBTENCAO_FATOR_H;	
	BEGIN
		
		//COMPRIMENTO DE AJUSTE DA CORREIA - LA
	   LA := LC - 1.57*(D2_R + D1_R);
	  
		//(D2-D1)/LA = D2_D1_LA
		D2_D1_LA := (D2_R - D1_R)/LA;
	  
	  //TABELA 6 - FATOR H (FATOR DE CORRECAO)
		ASSIGN(ENTRADA, 'DFATOR_H.PAS');
	 	RESET (ENTRADA);
	 	
	 	//VARIAVEIS DA TABELA 6: (D2-D1)/LA = D2D1_LA[]; FATOR H = FATORH[]
		READ (ENTRADA, M);
 		FOR I:= 1 TO M DO
 			READ (ENTRADA, D2D1_LA[I]);
    FOR J:= 1 TO M DO
 			READ (ENTRADA, FATORH[J]);

		
		//F_H VALOR RESULTANTE DO FATOR H - TABELA 6
		FOR I:= 1 TO M DO
 		   BEGIN
				 IF (D2_D1_LA = D2D1_LA[I]) 
				 		THEN 
						  BEGIN
							  F_H := FATORH[I];
							END  
				 		ELSE 
				 IF (D2_D1_LA > D2D1_LA[I]) AND (D2_D1_LA<D2D1_LA[I+1]) 
						THEN 
						  BEGIN
								F_H := FATORH[I+1];
							END;	
			 END;
		
		//DISTANCIA ENTRE CENTROS AJUSTADA - CA	 
				CA := (LA - F_H*(D2_R - D1_R))/2;
	END;


PROCEDURE INTERPOLACAO_LAGRANGE (VAR XINT,YINT:REAL; VAR X,Y:VETOR_REAL);
BEGIN
 FOR K:= 1 TO M DO
  BEGIN
   L[K]:= 1;
   FOR I:=1 to M DO
       IF I<>K THEN
         BEGIN
           L[K] := L[K]*((XINT-X[I])/(X[K]-X[I]));
         END;
  END;  	
      
     YINT := 0;
       FOR I := 1 TO M DO
          BEGIN
			YINT := YINT + Y[I]*L[I];
          END;       
END; 

//TABELA 17; fator de correcao do arco de contato
PROCEDURE OBTENCAO_DO_ARCO_CONTATO_Fcac_ANGULO_GRAUS;
	BEGIN
	  D2D1CA := (D2_R-D1_R)/CA;
		//     := (D-d)/Ca
		IF (D2D1CA >= 0.00) AND (D2D1CA < 0.10) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D1ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 0.10) AND (D2D1CA < 0.20) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D2ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 0.20) AND (D2D1CA < 0.30) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D3ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;																								                                            
		IF (D2D1CA >= 0.30) AND (D2D1CA < 0.40) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D4ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 0.40) AND (D2D1CA < 0.50) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D5ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;	                                            
		IF (D2D1CA >= 0.50) AND (D2D1CA < 0.60) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D6ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;	                                            
		IF (D2D1CA >= 0.60) AND (D2D1CA < 0.70) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D7ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 0.70) AND (D2D1CA < 0.80) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D8ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 0.80) AND (D2D1CA < 0.90) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D9ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 0.90) AND (D2D1CA < 1.00) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D10ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 1.00) AND (D2D1CA < 1.10) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D11ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 1.10) AND (D2D1CA < 1.20) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D12ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 1.20) AND (D2D1CA < 1.30) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D13ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 1.30) AND (D2D1CA < 1.40) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D14ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;
		IF (D2D1CA >= 1.40) AND (D2D1CA <= 1.50) THEN 
																							BEGIN 
																									ASSIGN (ENTRADA,'D15ARCO_CONTATO.PAS'); 
			                                            RESET (ENTRADA);
	                                            END;																									
																							
		READ (ENTRADA, M);
		FOR I:= 1 TO M DO
			READ (ENTRADA,D2D1_CA[I]);
			
		FOR I:= 1 TO M DO	
			READ (ENTRADA, FATOR_Fcac[I]);
			
		FOR I:= 1 TO M DO
		   READ (ENTRADA, ANGULO_GRAUS[I]);	
		
		  interpolacao_lagrange (D2D1CA,Fcac,D2D1_CA,FATOR_Fcac);
		  interpolacao_lagrange (D2D1CA,ALFA,D2D1_CA,ANGULO_GRAUS);		  
	END;


PROCEDURE OBTENCAO_Pb_Pa_Ppc;
	BEGIN
	  //OBTENCAO DO RPM MAIS RÁPIDO - RPM1
	  WRITELN ('**** OBTENCAO DA RPM1 ****');
	  IF (RPM1 = 950) THEN 
	                   BEGIN
	                     RPM1_R := 950;
	                     W := 1;
	                   END;  
	                   
	  IF (RPM1>950) AND (RPM1<= 1160)
	                   THEN
											BEGIN
											  RPM1_R := 1160;
											  W := 2;
											END; 
	  IF (RPM1>1160) AND (RPM1<= 1425)
										THEN	
											BEGIN
											  RPM1_R := 1425;
											  W := 3;
											END; 
	  IF (RPM1>1425) AND (RPM1<= 1750)
										THEN	
											BEGIN
											  RPM1_R := 1750;
											  W := 4;
											END; 																						
	  IF (RPM1>1750) AND (RPM1<= 2850)
										THEN	
											BEGIN
											  RPM1_R := 2850;
											  W := 5;
											END; 											
		//OBTENCAO DO VALOR DO CV BASICO_Pp
		
		Pb := CV_BASICO[W,Z];	
		
		//OBTENCAO POTENCIA ADICIONAL - Pa
		//Pa É FUNCAO DO RPM1 E DA RELACAO DE TRANSMISSAO
		//RELACAO DE TRANSMISSAO (RT := D2_R/D1R = RPM1/RPM2								               
	 	  
	  IF (RT>=1)    AND (RT<=1.01) THEN K := 1;
		IF (RT>=1.02) AND (RT<=1.03) THEN K := 2;
		IF (RT>=1.04) AND (RT<=1.05) THEN K := 3;
		IF (RT>=1.06) AND (RT<=1.08) THEN K := 4;		
		IF (RT>=1.09) AND (RT<=1.12) THEN K := 5;
		IF (RT>=1.13) AND (RT<=1.16) THEN K := 6;
		IF (RT>=1.17) AND (RT<=1.22) THEN K := 7;
		IF (RT>=1.23) AND (RT<=1.30) THEN K := 8;		
		IF (RT>=1.31) AND (RT<=1.48) THEN K := 9;		
		IF (RT>=1.49) 							 THEN K := 10;			
		
		Pa := CV_ADICIONAL[W,K];
											
		Ppc := (Pb + Pa) * Fcc * Fcac;
	END;	
	
PROCEDURE NUMERO_DE_CORREIA_PARA_TRANSMISSAO;
	BEGIN
	   Nco := Pp/Ppc;
	END;

PROCEDURE ESFORCOS_DE_TRANSMISSAO_TORQUE_FORCA_TANGENCIAL_MT1_FT;
	BEGIN
	
		//TRANSFORMAR P[CV] EM P[W] 
		MT1:= (30*Pmotor*0.7355*1000)/(PI*RPM1);
		
		//TRANSFORMAR D1[MM] EM D1[M] === FT[N]
		FT := (2*MT1)/(D1_R/1000);
		
		//TRANSFORMAR GRAUS EM RADIANOS
		IALFARAD := (PI*ARCO_C)/180;
		
		//F1/F2 === F1_F2
		F1_F2 :=  EXP(ATRITO*IALFARAD)*LN(E);
		F2 := FT/(F1_F2-1);
		F1 := (F1_F2)*F2;
		
		//CARGA RESULTANTE - F
		FR :=  SQRT(SQR(F1) + SQR(F2) + ABS(2*F1*F2*COS(ARCO_C)));
	END;
	
PROCEDURE RESULTADOS;
	BEGIN
		WRITELN;
		WRITELN ('O VALOR DO FATOR DE SERVICO - FS = ',FS:4:1);
		writeln ('POTENCIA PROJETADA - Pp = ', Pp:5:2);
		WRITELN ('O PERFIL DA CORREIA HI POWER II = ', PERFIL);
	  WRITELN ('O DIAMETRO MINIMO EM POL = ',D1_POL:5:2);
	  WRITELN ('O DIAMETRO MINIMO EM CM = ',D1:5:2);
    WRITELN ('O DIAMETRO CALCULADO D2 = ',D2:5:2);	  
	  WRITELN ('O DIAMETRO NORMALIZADO D1_R = ',D1_R:5:2);
	  WRITELN ('O DIAMETRO NORMALIZADO D2_R = ',D2_R:5:2);
		WRITELN ('O COMPRIMENTO CALCULADO DA CORREIA - LL = ',LL:5:2);
		WRITELN ('O COMPRIMENTO PADRAO - LC = ', LC:5:2);
		WRITELN ('A REFERENCIA DO PERFIL A = ', REFERENCIA_A);
		WRITELN ('O FATOR DE CORRECAO DO COMPRIMENTO DA CORREIA = ', Fcc:4:2);
		WRITELN ('O VALOR DE D2_D1_LA (sem a precisao centesimal) = ',D2_D1_LA); 
		WRITELN ('O D2_D1_LA = ',D2_D1_LA:4:2); 
    WRITELN ('O FATOR H - F_H = ',F_H:4:2);	
		WRITELN ('O COMPRIMENTO DA DISTANCIA ENTRE CENTROS AJUSTADA - CA = ',CA:4:2);		  
	  WRITELN ('FATOR DE CORRECAO - Fcac = ',Fcac:4:4);
	  WRITELN ('ARCO DE CONTATO DA POLIA MENOS (GRAUS) - ALFA = ',ALFA:4:2);
	  WRITELN ('O VALOR DA POTENCIA BASICA - Pb = ', Pb:4:4);
	  WRITELN ('O VALOR DA POTENCIA ADICIONAL - Pa = ', Pa:4:4);
	  WRITELN ('O VALOR DA POTENCIA BASICA - Ppc = ', ROUND(Ppc));
	  WRITELN ('O NUMERO DE CORREIAS NECESSÁRIAS PARA TRANSMISSÃO - Nco = ',ROUND (Nco));
	  WRITELN ('F1 = ',F1:5:2);
 	  WRITELN ('F2 = ',F2:5:2);
	  WRITELN ('FT = ',FT:5:2);
	  WRITELN ('MT1 = ',MT1:5:2);
	  WRITELN ('FR = ',FR:5:2);
	END;	
		

	
//PROGRAMA PRINCIPAL
	BEGIN
	  LEITURA_DE_DADOS;
	  LEITURA_REF_LC_FCORRECAO;
	  LEITURA_CV_BASICO_ADICIONAL;
    OBTENCAO_FATOR_DE_SERVICO_FS;
    POTENCIA_PROJETADA_Pp;
    IDENTIFICAR_PERFIL_CORREIA;
	  OBTENCAO_DIAMETRO_MINIMO;
	  COMPRIMENTO_DA_CORREIA_LL;
		OBTENCAO_LC_REF_FATOR;
		OBTENCAO_FATOR_H;
		OBTENCAO_DO_ARCO_CONTATO_Fcac_ANGULO_GRAUS;
		OBTENCAO_Pb_Pa_Ppc;
		NUMERO_DE_CORREIA_PARA_TRANSMISSAO;	
		ESFORCOS_DE_TRANSMISSAO_TORQUE_FORCA_TANGENCIAL_MT1_FT;
    RESULTADOS;
  READKEY;  
	END.