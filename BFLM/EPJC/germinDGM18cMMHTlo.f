	program germinDGM18cMMHTlo
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c O FATOR DE FORMA NÃO ESTÁ SENDO CONSIDERADO NA RDD!!!
c
c ImXsh é obtida via s->-is
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c Gera St e Rh
c
c Obs1: Os fatores de forma K3(x) estão sendo obtidos via integração
c por Regra de Simpson modificada
c
c Obs2: Utiliza os novos conjuntos de dados do LHC
c
c Obs3: TOTEM + ATLAS
c
c Obs4: Usa uma parametrização para SigQCD com 10 parâmetros livres
c
c Obs5: PDF: MMHTlo
c
c Obs6: Usa a estrutura do Durand & Pi
c
c Obs7: SigQCD(s) foi parametrizada por uma função real
c
c Obs8: A parte soft da eiconal é composta por termos Xqq e Xqg, conforme
c o DGM antigo, só que com um log2(s/s0).
c
c Obs9: mu^{-}=0.5 está fixo.
c
c--------------------------------------------
c Importante: s_{0}=25 GeV^{2} !4*m^{2}_{p} GeV^{2}
c             mg=0.4d0 !GeV -> mg=500+/-200 MeV for lmb=300 MeV
c (MSTW) lbd=0.318920 GeV lambda equivale a alfa_LO(Mz^2)=0.13939~0.139 fazendo o match; m_b=4.18 GeV
c (MMHT) lbd=0.267471 GeV lambda equivale a alfa_LO(Mz^2)=0.13499~0.135 fazendo o match; m_b=4.18 GeV
c (CTEQ6L) lbd=0.3260 GeV lambda equivale a alfa_NLO(Mz^2)=0.118 para 4 sabores
c (CT14)   lbd=0.3260 GeV lambda equivale a alfa_NLO(Mz^2)=0.118 para 4 sabores
c--------------------------------------------
c
c------------------------------------
c chi2/gl=FCN/(Dados-Livres)=200.7587/(173-7)=1.20939
c------------------------------------
c
	implicit none
	double precision dgauss,bmin,bmax,epsabs
	double precision mbfactor,pi,pi2,pi4,aa0,mp,mp2
	double precision nf,lbd,lbd2,Bz,alfa0,alfa02,SIGMA
	double precision y1,y2,y3,y4,y5,y6,y7,y8,y9
	double precision b1,b2,b3,b4,b5,b6,b7,b8,b9,b10
	double precision argImFpp,ImFpp,argImFpa,ImFpa
	double precision argReFpp,ReFpp,argReFpa,ReFpa
	double precision Stpp,Stpa,Rhpp,Rhpa
	double precision ss,ss0,ssroot,ssroot0,deltas,passo,s
	double complex ii,iss,is
	integer iesse,npts
	external argImFpp,argImFpa,argReFpp,argReFpa
	common/cte/pi,pi2,pi4,aa0
	common/imag/ii
	common/par/y1,y2,y3,y4,y5,y6,y7,y8,y9
	common/sig/b1,b2,b3,b4,b5,b6,b7,b8,b9,b10
	common/ener/ss,iss,ss0,s,is
c
	open(unit=1,file='Stpp_minDGM18cMMHTlo.dat')
	open(unit=2,file='Stpa_minDGM18cMMHTlo.dat')
	open(unit=3,file='Rhpp_minDGM18cMMHTlo.dat')
	open(unit=4,file='Rhpa_minDGM18cMMHTlo.dat')
c
c--------------------------------------------
c Definição das constantes comuns:
c
	mbfactor=0.389379d0
	pi=4.d0*datan(1.d0)
	pi2=pi/2.d0
	pi4=pi/4.d0
	ii=dcmplx(0.d0,1.d0)
cc	mp=0.938272046d0!massa do próton em GeV
cc	mp2=mp*mp
	ss0=25.d0!4.d0*mp2
	aa0=1.d0
c
c--------------------------------------------	
c Parâmetros ajustados:
c
c minDGM18cMMHTlo.min
c
ccc 1 sigma:
c
c MIGRAD MINIMIZATION HAS CONVERGED.
c
c FCN=   200.7587     FROM MIGRAD    STATUS=CONVERGED     31 CALLS     1175 TOTAL
c                     EDM=  0.79E-09  STRATEGY=1  ERROR MATRIX UNCERTAINTY= 13.6%
c
c  EXT PARAMETER                                   STEP         FIRST   
c  NO.   NAME        VALUE          ERROR          SIZE      DERIVATIVE 
c   1      A1        2.2702       0.60677       0.28773E-04   0.55546E-03
c   2      A2       0.40067E-01   0.35182E-01   0.13373E-05  -0.70010E-02
c   3      A3        113.58        20.590      -0.15568E-02  -0.15221E-04
c   4      A4        34.321        20.916      -0.14580E-02   0.23709E-05
c   5      A5       0.36587       0.63385      -0.46164E-04  -0.85999E-03
c   6      A6       0.74712       0.16796      -0.35970E-03   0.22705E-03
c   7      A7        23.498        2.4813      -0.15668E-03  -0.19389E-04
c                               ERR DEF=  8.18    
c
c EXTERNAL ERROR MATRIX.    NDIM=  50    NPAR=  7    ERR DEF=  8.18    
c  0.368E+00
c  0.210E-01 0.124E-02
c -0.748E+01-0.339E+00 0.424E+03
c -0.459E+01-0.177E+00 0.391E+03 0.437E+03
c -0.157E+00-0.619E-02 0.125E+02 0.130E+02 0.402E+00
c -0.134E+00-0.593E-02 0.825E+01 0.795E+01 0.250E+00 0.162E+00
c -0.716E+00-0.320E-01 0.426E+02 0.396E+02 0.127E+01 0.829E+00 0.616E+01
c
c
	y1=2.2702d0 !nu1
	y2=0.40067d-1 !nu2
	y3=113.58d0 !A
	y4=34.321d0 !B
	y5=0.36587d0 !C
	y6=0.74712d0!mu^{+}_{soft}
	y7=23.498d0 !D
	y8=1.d0  !K_{f} ! ### fixado em 1.0 ###
	y9=0.5d0 !mu^{-} ! ### Pode ser fixado em 0.5 ###	
c	
ccc 2 sigmas:
c

c

c
c Parâmetros ajustados na parametrização complexa de SigQCD:
c
	b1=95.284d0
	b2=0.37224d0
	b3=0.59990d0
	b4=2.4959d0
	b5=-0.25543d-5
	b6=14.281d0
	b7=0.28071d0
	b8=0.90856d-1
	b9=4.2904d0
	b10=0.67342d0
c
c--------------------------------------------
c
	epsabs=1.d-8
	bmin=0.d0
	bmax=30.d0
	passo=5.d0
	npts=149!0
c
	do iesse=0,npts
	ssroot0=8.d0!1960.d0!14000.d0!8.d0
	deltas=iesse*iesse*passo/100.d0
	ssroot=ssroot0+iesse*deltas
	ss=ssroot*ssroot
	iss=-ii*ss
	s=ss/ss0
	is=-ii*s
c
	ImFpp=dgauss(argImFpp,bmin,bmax,epsabs)
	Stpp=4.d0*pi*ImFpp*mbfactor
c
	ImFpa=dgauss(argImFpa,bmin,bmax,epsabs)
	Stpa=4.d0*pi*ImFpa*mbfactor
c
	ReFpp=dgauss(argReFpp,bmin,bmax,epsabs)
	Rhpp=-ReFpp/ImFpp
c
	ReFpa=dgauss(argReFpa,bmin,bmax,epsabs)
	Rhpa=-ReFpa/ImFpa
c
	write(*,*)ssroot,Stpp,Stpa,Rhpp,Rhpa
	write(1,*)ssroot,Stpp
	write(2,*)ssroot,Stpa
	write(3,*)ssroot,Rhpp
	write(4,*)ssroot,Rhpa	
c
	end do! ss
	stop
	end
c
c
c
	function argImFpp(bb)
	implicit none
	double precision argImFpp,bb
	double precision Wdip
	double complex SigQCD
	double precision nu
	double complex chie,chio,chipp
	double complex Xsoft,Xsh
	double precision pi,pi2,pi4,aa0
	double precision y1,y2,y3,y4,y5,y6,y7,y8,y9
	double precision ss,ss0,s
	double complex ii,iss,is
	external Wdip,SigQCD
	common/cte/pi,pi2,pi4,aa0
	common/imag/ii
	common/par/y1,y2,y3,y4,y5,y6,y7,y8,y9
	common/ener/ss,iss,ss0,s,is
c
	nu=y1-y2*dlog(s)
c
	Xsoft=0.5d0*(y3+y4*cdexp(ii*pi4)/dsqrt(s)
     & +y5*(dlog(s)-ii*pi2)**2.d0)*Wdip(bb,y6)
c
	Xsh=0.5d0*(y8*Wdip(bb,nu)*SigQCD(aa0))
c
	chie=Xsoft+Xsh
c
	chio=0.5d0*y7*cdexp(-ii*pi4)/dsqrt(s)*Wdip(bb,y9)
c
	chipp=(chie-chio) !pp
c
	argImFpp=bb*(1.d0-dexp(-dreal(chipp))*dcos(dimag(chipp)))
c
	return
	end
c
c
c
	function argImFpa(bb)
	implicit none
	double precision argImFpa,bb
	double precision Wdip
	double complex SigQCD
	double precision nu
	double complex chie,chio,chipa
	double complex Xsoft,Xsh
	double precision pi,pi2,pi4,aa0
	double precision y1,y2,y3,y4,y5,y6,y7,y8,y9
	double precision ss,ss0,s
	double complex ii,iss,is
	external Wdip,SigQCD
	common/cte/pi,pi2,pi4,aa0
	common/imag/ii
	common/par/y1,y2,y3,y4,y5,y6,y7,y8,y9
	common/ener/ss,iss,ss0,s,is
c
	nu=y1-y2*dlog(s)
c
	Xsoft=0.5d0*(y3+y4*cdexp(ii*pi4)/dsqrt(s)
     & +y5*(dlog(s)-ii*pi2)**2.d0)*Wdip(bb,y6)
c
	Xsh=0.5d0*(y8*Wdip(bb,nu)*SigQCD(aa0))
c
	chie=Xsoft+Xsh
c
	chio=0.5d0*y7*cdexp(-ii*pi4)/dsqrt(s)*Wdip(bb,y9)
c
	chipa=(chie+chio) !pa
c
	argImFpa=bb*(1.d0-dexp(-dreal(chipa))*dcos(dimag(chipa)))
c
	return
	end
c
c
c
	function argReFpp(bb)
	implicit none
	double precision argReFpp,bb
	double precision Wdip
	double complex SigQCD
	double precision nu
	double complex chie,chio,chipp
	double complex Xsoft,Xsh
	double precision pi,pi2,pi4,aa0
	double precision y1,y2,y3,y4,y5,y6,y7,y8,y9
	double precision ss,ss0,s
	double complex ii,iss,is
	external Wdip,SigQCD
	common/cte/pi,pi2,pi4,aa0
	common/imag/ii
	common/par/y1,y2,y3,y4,y5,y6,y7,y8,y9
	common/ener/ss,iss,ss0,s,is
c
	nu=y1-y2*dlog(s)
c
	Xsoft=0.5d0*(y3+y4*cdexp(ii*pi4)/dsqrt(s)
     & +y5*(dlog(s)-ii*pi2)**2.d0)*Wdip(bb,y6)
c
	Xsh=0.5d0*(y8*Wdip(bb,nu)*SigQCD(aa0))
c
	chie=Xsoft+Xsh
c
	chio=0.5d0*y7*cdexp(-ii*pi4)/dsqrt(s)*Wdip(bb,y9)
c
	chipp=(chie-chio) !pp
c
	argReFpp=bb*(dexp(-dreal(chipp))*dsin(dimag(chipp)))
c
	return
	end
c
c
c
	function argReFpa(bb)
	implicit none
	double precision argReFpa,bb
	double precision Wdip
	double complex SigQCD
	double precision nu
	double complex chie,chio,chipa
	double complex Xsoft,Xsh
	double precision pi,pi2,pi4,aa0
	double precision y1,y2,y3,y4,y5,y6,y7,y8,y9
	double precision ss,ss0,s
	double complex ii,iss,is
	external Wdip,SigQCD
	common/cte/pi,pi2,pi4,aa0
	common/imag/ii
	common/par/y1,y2,y3,y4,y5,y6,y7,y8,y9
	common/ener/ss,iss,ss0,s,is
c
	nu=y1-y2*dlog(s)
c
	Xsoft=0.5d0*(y3+y4*cdexp(ii*pi4)/dsqrt(s)
     & +y5*(dlog(s)-ii*pi2)**2.d0)*Wdip(bb,y6)
c
	Xsh=0.5d0*(y8*Wdip(bb,nu)*SigQCD(aa0))
c
	chie=Xsoft+Xsh
c
	chio=0.5d0*y7*cdexp(-ii*pi4)/dsqrt(s)*Wdip(bb,y9)
c
	chipa=(chie+chio) !pa
c
	argReFpa=bb*(dexp(-dreal(chipa))*dsin(dimag(chipa)))
c
	return
	end	
c
c
c
c----------------------------------------------------------------------
c Calcula a seção de choque de QCD com a PDF: MMHTlo ij -> ij
c----------------------------------------------------------------------
c
c
c
	function SigQCD(aa)
	implicit none
	double complex SigQCD
	double precision aa
	double precision b1,b2,b3,b4,b5,b6,b7,b8,b9,b10
	double complex ww,w0,w1,w2,w3,w4
	double precision ss,ss0,ssroot,s
	double complex iss,is,Xp
	common/sig/b1,b2,b3,b4,b5,b6,b7,b8,b9,b10
	common/ener/ss,iss,ss0,s,is
c
	Xp=cdlog(cdlog(iss))
c 
	w1=b1
	w2=b2*cdexp(b3*(Xp**(1.01d0*b4)))
	w3=b5*cdexp(b6*(Xp**(1.05d0*b7)))
	w4=b8*cdexp(b9*(Xp**(1.09d0*b10)))
c
	w0=w1+w2+w3+w4
	ww=(w0-100.d0)
	SigQCD=aa*ww
c
	return
	end
c
c
c
c-----------------------------------------------------------------------
c Fator de forma do tipo dipolo
c-----------------------------------------------------------------------
c
c
c
	function Wdip(b,mu)
	implicit none
	double precision Wdip,b,mu
	double precision zz,zz3,xx1,xx2,xx3,nn3
	double precision ff,H,U
	double precision BesselK3w1,BesselK3w2,BesselK3w3
	double precision funcK3,IntK3,BesselK3
	double precision pi,pi2,pi4,aa0
	integer N,Ndiv
	common/cte/pi,pi2,pi4,aa0
c
	zz=mu*b
	zz3=zz**3.d0
c
	nn3=3.0
	ff=60.d0 !limite superior de integração
	Ndiv=200
c
	do N=1,Ndiv
	 H=ff/(6.d0*Ndiv)
	 U=ff/Ndiv
	 xx1=(N-1.d0)*U !xx's são as variáveis de integração
	 xx2=((N-1.d0)*U+N*U)/2.d0
	 xx3=N*U
c
	 BesselK3w1=dexp(-zz*dcosh(xx1))*dcosh(nn3*xx1)
	 BesselK3w2=dexp(-zz*dcosh(xx2))*dcosh(nn3*xx2)
	 BesselK3w3=dexp(-zz*dcosh(xx3))*dcosh(nn3*xx3)
c
	 funcK3=H*(BesselK3w1+4.d0*BesselK3w2+BesselK3w3)
	 IntK3=IntK3+funcK3
	end do !N
c
	BesselK3=IntK3
	Wdip=(mu**2.d0)*zz3*BesselK3/(96.d0*pi)
	IntK3=0.d0
c
	return
	end

