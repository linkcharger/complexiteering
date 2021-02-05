cd "D:\0_complexaton\Challenge4"



/*
Two things: there is no such a thing as "big one". There are two datasets (two big ones)
1- The first one



*/

use EntrepAno3y_87_09.dta, clear

***Some stats
tabout molds_ent plast_ent glass_ent entrepreneur worker using "D:\0_complexaton\other_docs\stats_ini.xls", oneway replace cells(freq col)

*tabout molds_ent using "D:\0_complexaton\other_docs\stats_ini_2.xls", replace c(mean nuemp_ent mean ntrab ) sum
tabout molds_ent using "D:\0_complexaton\other_docs\stats_ini_2.xls", replace c(count nuemp_ent count  ntrab ) sum
tabout plast_ent using "D:\0_complexaton\other_docs\stats_ini_2.xls", append c(count nuemp_ent count  ntrab ) sum
tabout glass_ent using "D:\0_complexaton\other_docs\stats_ini_2.xls", append c(count nuemp_ent count  ntrab ) sum


bys  nuemp_ent: gen id_company=_n

***

duplicates tag ntrab,gen(duplicado)
duplicates tag nuemp_ent ,gen(dupli_company)
bys nuemp_ent: gen first_comp=_n
keep if first_comp==1
rename nuemp_ent nuemp
save companies_financial.dta,replace

use companies_financial,clear
d

*** Second data base
use MoldsEntransWorkerEntrep_87_09.dta,clear

merge m:1 nuemp using companies_financial.dta
	
	*The molds database has 36148 data entry of workers history. This implies that 
	*one woker can have multiple entries, as he or she appears in different years
	*We saw that some workers appear in different years and same company, other cases
	*have same worker different years different companies. Other workers appear just once.
	*It is not clear yet, the case in which a worker seems to have not changed company, but appear repeteadly 
	*in different years. It could be because some change were registered i.e 
	*the worker has now a different position/occupation/salary ?? 
	*We didnt explore taht yet
	
	*We dropped non-merging companies. 
	*This means that after the merge, we will be analysing workers for which we have fianncial information
	*about the companies tehy were working for.
	*Why? because out of 36773 data entry of the history of molds-(plastic and glass) workers only for 3112 
	*there is companies financial entries
	
	drop if _merge!=3
	
	*At first, we wanted to keep only workers at the molds industry but we found that 
	*some have history at the plastic and glass industry. Besides, those companies
	*have information from the first database, which means that we have info about 
	*the companies' financial performance
	*keep if molds_ent==1

	*Some statistics
	histogram idade if idade>0, freq discrete  xlabel(10(5)70, valuelabel labsize(small)) ///
	ylabel(,nogrid) scheme(sj) normal
	*addlabels 
	graph box idade if idade>0, over(sexo) scheme(sj)
	graph box idade if idade>0, over(molds_ent) scheme(sj)
	graph box idade if idade>0, over(plast_ent) scheme(sj)
	graph box idade if idade>0, over(glass_ent) scheme(sj)

	tabout sexo using "D:\0_complexaton\other_docs\stats_ini_3.xls", replace c(count molds_ent ///
	count plast_ent count glass_ent ) sum
	** No info

	*Now, despite the merge and inicial cleanning of the merged database being clear
	*We still require to keep one unique data entry of the workers. Why?
	*because hat we can create a matrix with workers as rows and companies as columns
	*As an adjacency matrix...
	
	*To doing so, we first sort workers, companies and the years

	sort ntrab nuemp ano
	
	*And (at least for stata), we create and identification of such order
	bys ntrab nuemp : gen worker_year=_n

	histogram worker_year , freq discrete  xlabel(10(5)70, valuelabel labsize(small)) ///
	ylabel(,nogrid) scheme(sj) normal

	keep if worker_year==1

	bys nuemp: gen id_nuemp=_n
	sum id_nuemp
	histogram id_nuemp , freq discrete  xlabel(0(50)250, valuelabel labsize(small)) ///
	ylabel(,nogrid) scheme(sj) normal

	egen nuemp_year=concat(nuemp ano)
	keep ntrab nuemp ano

/*
reshape wide ano, i(nuemp) j(ntrab)
export delimited matrx_company_worker_3.txt,replace
egen nworkers=rownonmiss(ano30228 - ano320572099)
label var nworkers "Number of workers per company"
histogram nworkers, freq discrete  xlabel(, valuelabel labsize(small)) ylabel(,nogrid) scheme(sj) normal
save matrx_comp_worker.dta
*/

**********************
reshape wide ano, i(ntrab) j(nuemp)
save matrx_worcom.dta,replace
*export delimited matrx_worcom.txt,replace
export delimited matrx_worcom_2.txt,replace

use matrx_worcom.dta,clear
*Sanity check
egen ncompanies=rownonmiss(  ano107680  - ano1111810 )
label var ncompanies "Number of companies per worker"
histogram ncompanies, freq discrete  xlabel(, valuelabel labsize(small)) ylabel(,nogrid) scheme(sj) normal

sum 

*duplicates tag nuemp, gen(duplicado_company)





