!------------------------------------------------------------------------------
! Program: solar_calc_for_a_day.f90
! Description: Solar Calculator for a given date and location
!              Espically, computes sunrise, sunset, solar duration,
!              and night duration
!------------------------------------------------------------------------------
! Background and Developer Note:
! This program was developed by Emre Çalıova during undergraduate studies at
! Istanbul Technical University (ITU) as part of a research project investigating
! the impacts of Turkey's permanent daylight saving time (DST) policy.
!
! In 2016, Turkey adopted permanent DST to make better use of daylight throughout
! the year. This policy shift raised public and academic interest, particularly
! regarding its implications on energy consumption, human circadian rhythms, and
! daily life schedules. Accurate computation of sunrise and sunset times became
! essential for these assessments.
!
! This tool was created to support such evaluations by offering precise solar
! position calculations based on geographic and temporal inputs. It has been used
! in geospatial studies and policy impact analysis.
!
! The solar position calculations are based on methods from:
! - U.S. NOAA Solar Calculator
! - Astronomical Algorithms by Jean Meeus
!
!------------------------------------------------------------------------------
! ... rest of the Fortran code goes here ...
!------------------------------------------------------------------------------
!
!> Input:
!- LAT: Latitude of the location (+ to North & - to South) as real number
!- LON: Longitude of the location (+ to East & - to West) as real number
!- TIMEZONE: Hour off-set by UTC of the location (+ to East & - to West) as integer
!- YEAR: Year value of date as integer
!- MONTH: Month value of date as integer
!- DAY: Day value of date as integer
!- PLMTHOUR: Hour value of time (past local midnight) as integer
!- PLMTMINUTE: Minute value of time (past local midnight) as integer
!- PLMTSECOND: Second value of time (past local midnight) as integer
!------------------------------------------------------------------------------
!> Variables:
!- PI: Number of Pi
!- DEG180: Real Number of 180 degree
!- DEGTORAD: Degree to radian conversion factor
!- RADTODEG: Radian to degree conversion factor
!- JD: Julian Day
!- JC: Julian Century
!- GMLS: Geometric mean longitude of the Sun in degree
!- GMAS: Geometric mean anomaly of the Sun in degree
!- EEO: Eccentricity earth orbit
!- SEC: Sun's equation of center
!- STGL: Sun's true geometric longitude in degree
!- STA: Sun's true anomaly in degree
!- SRV: Sun's radius vector (AU)s in radian
!- SAL: The apperent longitude of the Sun in degree
!- MOE: Mean obliquity of the ecliptic in degree
!- OC: Obliquity correction in degree
!- SRA: Right ascension of the apperent position of the Sun in degree
!- SD: Declination d of the apperent position of the Sun in degree
!- VARY: Variable of y calculated from obliquity correction
!- ET: Equation of time in minutes
!- HASR: Hour angle of sunrise in degree
!- HASS: Hour angle of sunset in degree
!- SN: Solar Noon at local solar time
!- SRT: Sunrise time at local solar time 
!- SST: Sunset time at local solar time
!- SLD: Sunlight duration in minutes
!- NTD: Nighttime duration in minutes
!- TST: True solar time in minutes
!- HA: Hour angle in degree
!- SZA: Solar zenith angle in degree
!- SEA: Solar elevation angle in degree
!- AAR: Approximately atmospheric refraction in degree
!- SECforAR: Solar elevation corrected for atmospheric refraction in degree
!- SAA: Solar azimuth angle in degree which is clockwise from north
!------------------------------------------------------------------------------
!> Output:
!- All calculated variables
!- Sunrise time as HH:MM:SS
!- Sunset time as HH:MM:SS
!- Sunlight duration as HH:MM:SS
!- Nighttime duration as HH:MM:SS

program SOLAR_CALC_FOR_A_DAY
implicit none

real LAT, LON, TIMEZONE
integer YEAR, MONTH, DAY, PLMTHOUR, PLMTMINUTE, PLMTSECOND
double precision PLMTFRACTION, PI, DEG180, DEGTORAD, RADTODEG
double precision JDD, JDY, JDM, A, B
double precision JD, JC, GMLS, GMAS, EEO, SEC, STGL, STA, SRV, SAL, MOE, OC
double precision SRA, SD, VARY, ET, HASR, HASS, SN, SRT, SST, SLD, NTD, TST, HA
double precision SZA, SEA, AAR, SECforAR, SAA
double precision SRT_TOT_SECs, SST_TOT_SECs, SLD_TOT_SECs, NTD_TOT_SECs
integer SRT_HH, SRT_MM, SRT_SS, SST_HH, SST_MM, SST_SS, SLD_HH, SLD_MM, SLD_SS, NTD_HH, NTD_MM, NTD_SS
character(len=8) :: FRAC_TO_HMS_FOR_SRT, FRAC_TO_HMS_FOR_SST, FRAC_TO_HMS_FOR_SLD, FRAC_TO_HMS_FOR_NTD

! Input variables to calculate sunrise and sunset of the location
LAT = 41.0
LON = 29.0
TIMEZONE = 2
YEAR = 2016
MONTH = 1
DAY = 1
PLMTHOUR = 12       !Default value is 12.
PLMTMINUTE = 0      !Default value is 0.
PLMTSECOND = 0      !Default value is 0.
PLMTFRACTION = (PLMTHOUR + PLMTMINUTE / 60.0 + PLMTSECOND / 3600.0) / 24.0


! Conversion between units of measurement for angles to use in trigonometric functions
PI = 3.14159265358979323846
DEG180=180.0
DEGTORAD = PI/DEG180
RADTODEG = DEG180/PI

! Calculation of Julian Day
JDY = YEAR
JDM = MONTH
JDD = real(DAY)
if (MONTH.le.2) then
    JDY = JDY - 1
    JDM = JDM + 12
endif
A = floor(JDY / 100)
B = 2 - A + floor(A / 4)
JD = floor(365.25 * (JDY + 4716)) + floor(30.6001 * (JDM + 1)) + JDD + B - 1524.5
print*, "Julian Day (JD): ", JD

! Calculation of Julian Century
JC = (JD - 2451545) / 36525
print*, "Julian Century (JC): ", JC

! Calculation of geometric mean longitude of the Sun in degree
GMLS = mod(280.46646 + JC * (36000.76983 + JC * 0.0003032), 360.0)
print*, "Geometric mean longitude of the Sun (GMLS): ", GMLS

! Calculation of geometric mean anomaly of the Sun in degree
GMAS = 357.52911 + JC * (35999.05029 - 0.0001537 * JC)
print*, "Geometric mean anomaly of the Sun (GMAS): ", GMAS

! Calculation of eccentricity earth orbit
EEO = 0.016708634 - JC * (0.000042037 + 0.0000001267 * JC)
print*, "Eccentricity earth orbit (EEO): ", EEO

! Determite of Sun's equation of center
SEC = sin(GMAS * DEGTORAD) * (1.914602 - JC * (0.004817 + 0.000014 * JC)) + &
sin(2.0 * GMAS * DEGTORAD) * (0.019993 - 0.000101 * JC) + &
sin(3.0 * GMAS * DEGTORAD) * 0.000289
print*, "Sun's equation of center (SEC): ", SEC

! Calcutale of Sun's True geometric longitude and Sun's true anomaly in degree
STGL = GMLS + SEC
STA = GMAS + SEC
print*, "Sun's true geometric longitude (STGL): ", STGL
print*, "Sun's true anomaly (STA): ", STA

! Calculation of Sun's radius vector (AU)s in radian
SRV = 1.000001018 * (1 - EEO * EEO) / (1 + EEO * cos(DEGTORAD * (STA)))
print*, "Sun's radius vector (SRV): ", SRV

! Calculation of the apperent longitude of the Sun in degree
SAL = STGL - 0.00569 - 0.00478 * sin(DEGTORAD * (125.04 - 1934.136 * JC))
print*, "The apperent longitude of the Sun (SAL): ", SAL

! Calculation of mean obliquity of the ecliptic in degree
MOE = 23 + (26 + ((21.448 - JC * (46.815 + JC * (0.00059 - JC * 0.001813)))) / 60) / 60
print*, "Mean obliquity of the ecliptic (MOE): ", MOE

! Calculation of obliquity correction in degree
OC = MOE + 0.00256 * cos(DEGTORAD * (125.04 - 1934.136 * JC))
print*, "Obliquity correction (OC): ", OC

! Calculation of right ascension of the apperent position of the Sun in degree
SRA = RADTODEG * atan2( cos(DEGTORAD * OC) * sin(DEGTORAD * SAL), cos(DEGTORAD * SAL))
print*, "Right ascension of the apperent position of the Sun (SRA): ", SRA

! Calculation of declination d of the apperent position of the Sun in degree
SD = RADTODEG * (asin(sin(DEGTORAD * OC) * sin(DEGTORAD * SAL)))
print*, "Declination d of the apperent position of the Sun (SD): ", SD

! Calculation of variable of y
VARY = tan(DEGTORAD * (OC / 2)) * tan(DEGTORAD * (OC / 2))
print*, "Variable of y calculated from obliquity correction (VARY): ", VARY

! Calculation of equation of time in minutes
ET = 4 * RADTODEG * (VARY * sin(2 * DEGTORAD * GMLS) &
-2 * EEO * sin(DEGTORAD * GMAS) + 4 * EEO * VARY * sin(DEGTORAD * GMAS) &
* cos(2 * DEGTORAD * GMLS) - 0.5 * VARY * VARY * sin(4 * DEGTORAD * GMLS) &
-1.25 * EEO * EEO * sin(2 * DEGTORAD * GMAS))
print*, "Equation of time (ET): ", ET

! Calculation of hour angle of sunrise in degree
HASR = RADTODEG * (acos(cos(DEGTORAD * (90.833)) &
/ (cos(DEGTORAD * LAT) * cos(DEGTORAD * SD)) &
- tan(DEGTORAD * LAT) * tan(DEGTORAD * SD)))
print*, "Hour angle of sunrise (HASR): ", HASR

! Calculation of hour angle of sunset in degree
HASS = - RADTODEG * (acos(cos(DEGTORAD * (90.833)) &
/ (cos(DEGTORAD * LAT) * cos(DEGTORAD * SD)) &
- tan(DEGTORAD * LAT) * tan(DEGTORAD * SD)))
print*, "Hour angle of sunset (HASS): ", HASS

! Calculation of solar noon at local solar time
SN = (720 - 4 * LON - ET + TIMEZONE * 60) / 1440
print*, "Solar Noon at local solar time as fractional (SN): ", SN

! Calculation of sunrise time at local solar time
SRT = (SN * 1440 - HASR * 4) / 1440
print*, "Sunrise time at local solar time as fractional (SRT): ", SRT

! Calculation of sunset time at local solar time
SST = (SN * 1440 - HASS * 4) / 1440
print*, "Sunset time at local solar time as fractional (SST): ", SST

! Calculation of sunlight duration in minutes
SLD = 8 * HASR
print*, "Sunlight duration in minutes (SLD): ", SLD

! Calculation of nighttime duration in minutes
NTD = (24 * 60) - SLD
print*, "Nighttime duration in minutes (NTD): ", NTD

! Calculation of true solar time in minutes
TST = mod((PLMTFRACTION * 1440 + ET + 4 * LON - 60 * TIMEZONE), 1440.0)
print*, "True solar time (TST): ", TST

! Calculation of hour angle in degree
if (TST/4.0.lt.0) then
    HA = TST / 4.0 + 180.0
else
    HA = TST / 4.0 - 180.0
endif
print*, "Hour angle (HA): ", HA

! Calculation of solar zenith angle in degree
SZA = RADTODEG * (acos(sin(DEGTORAD * LAT) * sin(DEGTORAD * SD) &
+ cos(DEGTORAD * LAT) * cos(DEGTORAD * SD) * cos(DEGTORAD * HA)))
print*, "Solar zenith angle (SZA): ", SZA

! Calculation of solar elevation angle in degree
SEA = 90 - SZA
print*, "Solar elevation angle (SEA): ", SEA

! Calculation of approximately atmospheric refraction in degree
if (SEA.gt.85) then
    AAR = 0
elseif (SEA.gt.5) then
    AAR = (58.1 / tan(DEGTORAD * SEA) - 0.07 / tan(DEGTORAD * SEA)**3 &
    + 0.000086 / tan(DEGTORAD * SEA)**5) / 3600
elseif (SEA.gt.-0.575) then
    AAR = (1735 + SEA * (-518.2 + SEA * (103.4 + SEA * &
    (-1279 + SEA * 0.711)))) / 3600
else
    AAR = -20.772 / tan(DEGTORAD * SEA) / 3600
endif
print*, "Approximately atmospheric refraction (AAR): ", AAR

! Calculation of solar elevation corrected for atmospheric refraction in degree
SECforAR = SEA + AAR
print*, "Solar elevation corrected for atmospheric refraction (SECforAR): ", SECforAR

! Calculation of solar azimuth angle in degree which is clockwise from north
if (HA.gt.0.0) then
    SAA = mod((RADTODEG * acos( &
        (sin(DEGTORAD * LAT) * cos(DEGTORAD * SZA) - sin(DEGTORAD * SD)) / &
        (cos(DEGTORAD * LAT) * sin(DEGTORAD * SZA)) )) + 180.0, 360.0)
else
    SAA = mod(540.0 - (RADTODEG * acos( &
        (sin(DEGTORAD * LAT) * cos(DEGTORAD * SZA) - sin(DEGTORAD * SD)) / &
        (cos(DEGTORAD * LAT) * sin(DEGTORAD * SZA)) )), 360.0)
end if
print*, "Solar azimuth angle in degree which is clockwise from north (SAA): ", SAA


write(*, '(A)') "============================================="
write(*, '(A)') "     Solar Calculations      "
write(*, '(A)') "============================================="
write(*, '(A,F8.3)') " Latitude               :  ", LAT
write(*, '(A,F8.3)') " Longitude              :  ", LON
write(*, '(A,I4,A,I2.2,A,I2.2)') " Date                   :  ", YEAR, "-", MONTH, "-", DAY
write(*, '(A,I2.2,A,I2.2,A,I2.2)') " Past Local Midnight    :   ", PLMTHOUR, ":", PLMTMINUTE, ":", PLMTSECOND
write(*, '(A)') "============================================="

! Conversion sunrise time from day to HH:MM:SS format
SRT_TOT_SECs = SRT * 24.0d0 * 3600.0d0
SRT_HH = int(SRT_TOT_SECs / 3600)
SRT_MM = int(mod(SRT_TOT_SECs, 3600.0d0) / 60)
SRT_SS = int(mod(SRT_TOT_SECs, 60.0d0) + 0.5)  !Rounded
write(FRAC_TO_HMS_FOR_SRT, '(I2.2, ":", I2.2, ":", I2.2)') SRT_HH, SRT_MM, SRT_SS
print*, "Sunrise Time: ", FRAC_TO_HMS_FOR_SRT

write(*, '(A)') "--------------------------------------------"
! Conversion sunset time from day to HH:MM:SS format
SST_TOT_SECs = SST * 24.0d0 * 3600.0d0
SST_HH = int(SST_TOT_SECs / 3600)
SST_MM = int(mod(SST_TOT_SECs, 3600.0d0) / 60)
SST_SS = int(mod(SST_TOT_SECs, 60.0d0) + 0.5)  !Rounded
write(FRAC_TO_HMS_FOR_SST, '(I2.2, ":", I2.2, ":", I2.2)') SST_HH, SST_MM, SST_SS
print*, "Sunset Time: ", FRAC_TO_HMS_FOR_SST

write(*, '(A)') "--------------------------------------------"
! Conversion sunlight duration from minutes to HH:MM:SS format
SLD_TOT_SECs = SLD * 60.0d0
SLD_HH = int(SLD_TOT_SECs / 3600)
SLD_MM = int(mod(SLD_TOT_SECs, 3600.0d0) / 60)
SLD_SS = int(mod(SLD_TOT_SECs, 60.0d0) + 0.5)  !Rounded
write(FRAC_TO_HMS_FOR_SLD, '(I2.2, ":", I2.2, ":", I2.2)') SLD_HH, SLD_MM, SLD_SS
print*, "Sunlight Duration: ", FRAC_TO_HMS_FOR_SLD

write(*, '(A)') "--------------------------------------------"
! Conversion sunlight duration from minutes to HH:MM:SS format
NTD_TOT_SECs = NTD * 60.0d0
NTD_HH = int(NTD_TOT_SECs / 3600)
NTD_MM = int(mod(NTD_TOT_SECs, 3600.0d0) / 60)
NTD_SS = int(mod(NTD_TOT_SECs, 60.0d0) + 0.5)  !Rounded
write(FRAC_TO_HMS_FOR_NTD, '(I2.2, ":", I2.2, ":", I2.2)') NTD_HH, NTD_MM, NTD_SS
print*, "Nighttime Duration: ", FRAC_TO_HMS_FOR_NTD

write(*, '(A)') "============================================="

end program SOLAR_CALC_FOR_A_DAY