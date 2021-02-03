cd "C:\Users\ASUS\Dropbox\UU_master\2nd_year\Complexaton\Challenge4"

use EntrepAno3y_87_09.dta, clear

duplicates tag ntrab,gen(duplicado)
duplicates tag nuemp_ent ,gen(dupli_company)
bys nuemp_ent: gen first_comp=_n
keep if first_comp==1
rename nuemp_ent nuemp
save companies_financial.dta,replace


*
use MoldsEntransWorkerEntrep_87_09.dta,clear

merge m:1 nuemp using companies_financial.dta

drop if _merge!=3
*keep if molds_ent==1

sort ntrab nuemp ano
bys ntrab nuemp : gen worker_year=_n
keep if worker_year==1

egen nuemp_year=concat(nuemp ano)
keep ntrab nuemp ano
reshape wide ano, i(ntrab) j(nuemp)

*save matrx_worcom.dta
*export delimited matrx_worcom.txt,replace
export delimited matrx_worcom_2.txt,replace


*Sanity check
egen ncompanies=rownonmiss(  ano107680  - ano1111810 )

*duplicates tag nuemp, gen(duplicado_company)