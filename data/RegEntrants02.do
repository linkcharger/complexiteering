*RegEntrants
*in USE BIG
*version 02 - With more woker variables: File for Complexaton 
*Based on Embodied - Entrants08.do

clear all
capture log close
cd "U:\My Documents\Research\USE\Research Projects\Regional Flows\DBase\DataLog"
log using "RegEntrants05.log", replace
set more off

*REGIONAL FLOWS PROJECT
*RegEntrants
*in USE BIG
*version 02 - With more woker variables: File for Complexaton 
*Based on Embodied - Entrants08.do

*1 - Identify new molds, plastics, glass entrants at 3 year of activity
*2 - Identify founders and workers of third year
*4- Obtain the file with entrepreneurs and workers in year 3 
*5 - Join file with all entrepreneus and early workers
*6 - Create a short version of workers database for each year
*7 - Get files of relevant worker history
*8 - Join worker files 




*1 - Identify new molds entrants at 3 year of activity
use "U:\My Documents\Research\ServerIN+\Project2\Entry\Datalog\AllEntrants_86_09.dta", clear
keep if molds==1|plast==1|glass==1
codebook nuemp if molds==1
codebook nuemp if plast==1
codebook nuemp if glass==1
sort nuemp ano
save "MPGEntrants3y_87_09.dta", replace

*2 - Identify founders and workers of third year
foreach x in 87 88 89 91 92 93 94 95 96 97 98 99 00 02 03 04 05 06 07 08 09{
use "U:\My Documents\Research\ServerIN+\Project2\Entry\Datalog\trabshort_`x'.dta", clear
sort nuemp
merge m:m nuemp using "MPGEntrants3y_87_09.dta"
*file with all the entrants in the molds, plastics, glass industries in year 3
sort nuemp, stable
keep if _merge==3 
codebook nuemp if molds==1
codebook nuemp if plast==1
codebook nuemp if glass==1
gen entrepreneur=1 if stpro==1
gen noent=0 if fyear==ano & stpro==1
replace noent=1 if fyear==ano & stpro!=1
bysort nuemp: egen mnoent=mean(noent) if fyear==ano
replace noent=0 if mnoent!=1
drop mnoent
bysort nuemp: replace entrepreneur=1 if noent==1 & nqua1==1 & fyear==ano
recode entrepreneur .=0
gen worker=1 if entrepreneur==0
recode  worker .=0
keep if entrepreneur==1|worker==1
codebook nuemp 
codebook nuemp if stpro==1
sort ntrab, stable
drop _merge
keep if ano==entry+3
save "MPGEntrepWorkY3_`x'.dta", replace
}



*4- Obtain the file with entrepreneurs and workers in year 3 

foreach x in 87 88 89 91 92 93 94 95 96 97 98 99 00 02 03 04 05 06 07 08 09{
use "MPGEntrepWorkY3_`x'.dta", clear
drop molds1 molds2 plast1 plast2 glass1 glass2
rename ano ano_ent
rename nuemp nuemp_ent
rename indcae indcae_ent
rename cae cae_ent
rename fyear fyear_ent
rename modeanc modeanc_ent
rename entry entry_ent
rename lasty lasty_ent
rename cens cens_ent
rename surv surv_ent
rename lstat lstat_ent
rename molds molds_ent
rename glass glass_ent
rename plast plast_ent
rename lcae lcae_ent
rename lindcae lindcae_ent
drop if ntrab==.
sort ntrab ano
save "EntrepAno3y_`x'.dta", replace
}
use "EntrepAno3y_87.dta", clear
foreach x in 88 89 91 92 93 94 95 96 97 98 99 00 02 03 04 05 06 07 08 09{
append using "EntrepAno3y_`x'.dta"
}
save "EntrepAno3y_87_09a.dta", replace
duplicates drop
duplicates report ntrab nuemp_ent ano
duplicates drop ntrab nuemp_ent ano, force
codebook nuemp_ent if molds==1
codebook ntrab if molds==1
keep ano_ent nuemp_ent ntrab idade RecSame cae_ent indcae_ent lcae_ent lindcae_ent fyear_ent modeanc_ent entry_ent lasty_ent cens_ent surv_ent ldemp_ent dtemp_ent lstat_ent molds_ent glass_ent plast_ent pemp_f vvend_f entrepreneur worker
save "EntrepAno3y_86_09b.dta", replace
codebook nuemp if molds==1
codebook ntrab if molds==1
*we keep only the entrepreneurs/workers that show up in year 3
save "EntrepAno3y_86_09c.dta", replace
*make files with entrepreneurs/workers that show up as such, in the third year:
foreach x in 87 88 89 91 92 93 94 95 96 97 98 99 {
	use "EntrepAno3y_86_09c.dta", clear
	keep if entry==1900+`x'
	sort ntrab
	save "EntrepAno3y_`x'.dta", replace
}
foreach x in 00 02 03 04 05 06 07 08 09 {
	use "EntrepAno3y_86_09c.dta", clear
	keep if entry==2000+`x'
	sort ntrab
	save "EntrepAno3y_`x'.dta", replace
}


*5 - Join file with all entrepreneus and early workers
use "EntrepAno3y_87.dta", clear
foreach x in 88 89 91 92 93 94 95 96 97 98 99 00 02 03 04 05 06 07 08 09{
append using "EntrepAno3y_`x'.dta"
}
duplicates tag ano_ent nuemp_ent ntrab, generate (dup) 
tab dup 
*should be all 0
drop dup
save "EntrepAno3y_87_09.dta", replace



*6 - Create a short version of workers database for each year

foreach x in 86 87 88 89 91 92 93{
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' nqua1_`x' habil1_`x'
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antig_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
save "trablong_`x'.dta", replace
}


foreach x in 94 {
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' nqua1_`x' habi1_`x' ircdt_`x' ctcont_ crtrab_
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antg_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
rename nacio_ nacio
rename dtnas_ dtnas
rename dtulp_ dtulp
rename rganh_ rganh
rename npnor_ npnor
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
label var nacio "Nationality"
label var dtnas "Date of birth"
label var dtulp "Date of the last promotion"
label var rganh "Salary received"
label var npnor "Normal weekly working time"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
save "trablong_`x'.dta", replace
}

foreach x in 95 97 98 99{
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' nqua1_`x' habi1_`x' ircdt_`x'
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antig_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
rename dtnas_ dtnas
rename dtulp_ dtulp
rename ganho_ rganh
rename npnor_ npnor
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
label var dtnas "Date of birth"
label var dtulp "Date of the last promotion"
label var rganh "Salary received"
label var npnor "Normal weekly working time"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
save "trablong_`x'.dta", replace
}


foreach x in 96{
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' nqua1_`x' habil1_`x' ircdt_`x'
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antig_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
rename dtnas_ dtnas
rename dtulp_ dtulp
rename ganho_ rganh
rename npnor_ npnor
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
label var dtnas "Date of birth"
label var dtulp "Date of the last promotion"
label var rganh "Salary received"
label var npnor "Normal weekly working time"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
save "trablong_`x'.dta", replace
}


foreach x in 00{
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' nqua1_`x' habil1_`x' ircdt_`x'
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antig_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
rename dtnas_ dtnas
rename dtulp_ dtulp
rename nacio_ nacio
rename ctcont_ ctcont
rename crtrab_ crtrab
*rename ganho_ rganh
rename npnor_ npnor
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
label var dtnas "Date of birth"
label var dtulp "Date of the last promotion"
label var ctcont "Type of contract "
label var crtrab "Work duration regime: 1-Permanent contract; 2-Term contract"
*label var rganh "Salary received"
label var npnor "Normal weekly working time"
label var nacio "Nationality"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
save "trablong_`x'.dta", replace
}


foreach x in 02 04 05 06 07 08 09{
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' nqua1_`x' habil1_`x' ircdt_`x'
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antig_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
*rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
rename dtnas_ dtnas
rename dtulp_ dtulp
rename nacio_ nacio
rename ctcont_ ctcont
rename crtrab_ crtrab
*rename ganho_ rganh
rename npnor_ npnor
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
*label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
label var dtnas "Date of birth"
label var dtulp "Date of the last promotion"
label var ctcont "Type of contract "
label var crtrab "Work duration regime: 1-Permanent contract; 2-Term contract"
*label var rganh "Salary received"
label var npnor "Normal weekly working time"
label var nacio "Nationality"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
save "trablong_`x'.dta", replace
}


foreach x in 02 03{
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' nqua1_`x' habil1_`x' ircdt_`x'
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antig_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
*rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
rename dtnas_ dtnas
rename dtulp_ dtulp
rename nacio_ nacio
rename ctcont_ ctcont
rename crtrab_ crtrab
*rename ganho_ rganh
rename npnor_ npnor
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
*label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
label var dtnas "Date of birth"
label var dtulp "Date of the last promotion"
label var ctcont "Type of contract "
label var crtrab "Work duration regime: 1-Permanent contract; 2-Term contract"
*label var rganh "Salary received"
label var npnor "Normal weekly working time"
label var nacio "Nationality"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
save "trablong_`x'.dta", replace
}


foreach x in 04 05 {
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' nqua1_`x' habil1_`x' ircdt_`x'
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antg_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
*rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
rename dtnas_ dtnas
rename dtulp_ dtulp
rename nacio_ nacio
rename ctcont_ ctcont
rename crtrab_ crtrab
*rename ganho_ rganh
rename npnor_ npnor
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
*label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
label var dtnas "Date of birth"
label var dtulp "Date of the last promotion"
label var ctcont "Type of contract "
label var crtrab "Work duration regime: 1-Permanent contract; 2-Term contract"
*label var rganh "Salary received"
label var npnor "Normal weekly working time"
label var nacio "Nationality"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
destring ctcont, replace
destring crtrab, replace
save "trablong_`x'.dta", replace
}


foreach x in 06 {
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' nqua1_`x' habil1_`x' ircdt_`x' habil2_`x'
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antig_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
*rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
rename dtnas_ dtnas
rename dtulp_ dtulp
rename nacio_ nacio
rename ctcont_ ctcont
rename crtrab_ crtrab
*rename ganho_ rganh
rename npnor_ npnor
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
*label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
label var dtnas "Date of birth"
label var dtulp "Date of the last promotion"
label var ctcont "Type of contract "
label var crtrab "Work duration regime: 1-Permanent contract; 2-Term contract"
*label var rganh "Salary received"
label var npnor "Normal weekly working time"
label var nacio "Nationality"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
destring ctcont, replace
destring crtrab, replace
save "trablong_`x'.dta", replace
}


foreach x in 07 {
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' prof_4d`x' nqua1_`x' habil1_`x' ircdt_`x' habil2_`x'
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antig_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
*rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
rename dtnas_ dtnas
rename dtulp_ dtulp
rename nacio_ nacio
rename ctcont_ ctcont
rename crtrab_ crtrab
*rename ganho_ rganh
rename npnor_ npnor
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
*label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
label var dtnas "Date of birth"
label var dtulp "Date of the last promotion"
label var ctcont "Type of contract "
label var crtrab "Work duration regime: 1-Permanent contract; 2-Term contract"
*label var rganh "Salary received"
label var npnor "Normal weekly working time"
label var nacio "Nationality"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
save "trablong_`x'.dta", replace
}


foreach x in 08 09 {
use "U:\My Documents\Research\USE\DATA\trab_`x'.dta", clear
drop prof_3d`x' prof_2d`x' prof_1d`x' prof_4d`x' nqua1_`x' habil1_`x' ircdt_`x' habil2_`x'
rename ano_ ano
rename nuemp_ nuemp
rename nuest_ nuest
rename irc_ irc
rename ntrab_ ntrab
rename sexo_ sexo
rename antg_ antig
rename dtadm_ dtadm
rename ctpro_ ctpro
rename stpro_ stpro
rename prof_ prof
rename habil_ habil
rename nqual_ nqual
rename idade_ idade
rename ctrem_ ctrem
rename rbase_ rbase
rename rprg_ rprg
rename rpirg_ rpirg
rename rextr_ rextr
*rename diut_ diut
rename nhnor_ nhnor
rename nhext_ nhext
rename dtnas_ dtnas
rename dtulp_ dtulp
rename nacio_ nacio
rename ctcont_ ctcont
rename crtrab_ crtrab
*rename ganho_ rganh
rename npnor_ npnor
label var ano "Year of observation"
label var nuemp "Company identifier number"
label var nuest "Establishmet number"
label var irc "Collective work agreement"
label var ntrab "Worker identifier number"
label var sexo "Gender: m/f"
label var idade "Age"
label var antig "Years of work in the company"
label var dtadm "Date of admission to company"
label var ctpro "Professional category"
label var prof "National Professions Classification - see list"
label var stpro "Professional situation: 1-Employer; 2-Family (no salary); 3-Employee; 4-Cooperative member; 8-Other"
label var nqual "Level of hierarchical qualification"
label var habil "Schooling level"
label var ctrem "Salary situation:0-Complete base salary;1-Incomplete base salary;2-No base salary or other;3-No base salary but with other;4-No base salary owed;7-Complete base salary(fisheries);8-Incomplete base salary(fisheries);9-No base salary or other(fisheries)"
label var rbase "Base salary amount"
label var rprg "Periodic payments amount"
label var rpirg "Occasional payments amount"
label var rext "Payment for extra hours amount"
*label var diut "Seniority-related payment amount"
label var nhnor "Montlhy paid hours - normal"
label var nhext "Montlhy paid hours - extra"
label var dtnas "Date of birth"
label var dtulp "Date of the last promotion"
label var crtrab "Work duration regime: 1-Permanent contract; 2-Term contract"
label var crtrab "Work duration regime "
*label var rganh "Salary received"
label var npnor "Normal weekly working time"
label var nacio "Nationality"
codebook nuemp
codebook ntrab
duplicates drop
duplicates tag ntrab nuemp, gen(dup) 
tab dup
gen duprem=.
replace duprem=1 if dup>0
* mark to remove people that show up more than once in the same company
duplicates tag ntrab, gen(dupnt)
tab dupnt
gen ent=1 if stpro==1
sort ntrab stpro
bysort ntrab: replace ent=ent[_n-1] if ent==.
replace duprem=1 if dupnt>5 & ent==1
replace duprem=1 if dupnt>3 & ent==.
* mark to remove people with 3 jobs or more or entrepreneurs in more than 5 companies
codebook nuemp
codebook ntrab
sort nuemp, stable
drop dup dupnt
*remove mistake ntrab==0
drop if ntrab==0
*recode companies that changed number
replace nuemp=230560 if nuemp==988068
replace nuemp=384164 if nuemp==1041942
replace nuemp=925883 if nuemp==991757
replace nuemp=80648 if nuemp==487282
replace nuemp=177246 if nuemp==1099816
gen RecSame=0
replace RecSame=1 if nuemp==230560|nuemp==384164|nuemp==925883|nuemp==80648|nuemp==177246
label variable RecSame "Companies codes recoded because company transferred to another code"
save "trablong_`x'.dta", replace
}




*7 - Get files of relevant worker history
foreach x in 87 88 89 91 92 93 94 95 96 97 98 99 00 02 03 04 05 06 07 08 09{
use "trablong_`x'.dta", clear
sort ntrab
save "trablong_`x'.dta", replace
}

foreach x in 87 88 89 91 92 93 94 95 96 97 98 99 00 02 03 04 05 06 07 08 09{
use "EntrepAno3y_87_09.dta", clear	
keep ano_ent nuemp_ent ntrab entry_ent
merge m:m ntrab using "trablong_`x'.dta", keep (3)
keep if ano<=entry_ent
drop _merge
save "EntEmp_`x'.dta", replace
}

*8 - Join worker files 

use "EntEmp_87.dta", clear
foreach x in 88 89 91 92 93 94 95 96 97 98 99 00 02 03 04 05 06 07 08 09{
append using "EntEmp_`x'.dta"
}
drop ano_ent nuemp_ent RecSame
save "MoldsEntransWorkerEntrep_87_09.dta", replace
*file with all the workers and entrepreneurs of molds entrants with their previous jobs



log close
