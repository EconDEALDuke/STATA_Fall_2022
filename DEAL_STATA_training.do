********************************************************************************
*** Introduction to STATA for Econ 104 and DEAL
*** Richard Lombardo
*** September 2022
********************************************************************************

* Note that lines starting with an asterix or slash are "comments", so STATA knows not to run them as code
* Comments allow you to explain what you're trying to do in words. Using them makes your code far easier to understand


* The first step of many Do Files is to tell STATA where your working directory is. 
* This is the path of folders in your computer that will take you to where your data is
* You change your directory using "cd FOLDERPATH" as shown below
cd /Users/richa/Downloads
* NOTE: Above line is my folder path, you have to change it to be your own for this do file to work


* With the right folder path, we can now "use" data. 
* Let's open the "expend.dta" dataset. Using ", clear" tells STATA to close any prior datasets it has open
use expend, clear


* For practice, let's save the dataset even though we haven't changed anything. 
* You need ", replace" to replace the existing expend.dta file in this folder
save expend, replace


* Descriptive commands:

* Shows variable name, label, and storage type
describe 
describe tot_exp
	
* List values of a certain variable
list tot_exp
list tot_exp in 1/10		// list first 10 observations
list tot_exp in 11/20 	    // list next 10 observations
	
* Give summary stats of a variable 
sum tot_exp
sum tot_exp, detail			// adding ", detail" gives us more summary stats
	
* Make oneway and twoway frequency tables
tabulate hhsize 
tab hhsize n_child 
	
	
* Help and search:

* New command that you're nut used to? Get documentation on it by typing "help COMMANDNAME"
help sum

* Not sure what the command name even is? Use "search"
search regression

* Google is also helpful!


* Relationship between variables:

* Make a scatter plot: 
twoway scatter food_exp tot_exp 

* Compute correlation or covariance
corr food_exp tot_exp
corr food_exp tot_exp, covariance

* Run regressions
reg food_exp tot_exp
reg food_exp tot_exp hhsize		 // STATA treats first variable as dependent variable, all others as independent


* Manipulating the data (part 1):

* Make a new variable by using the "gen" command
* Let's make a new variable equal to the logarithm of total expenditure
gen lnexp = ln(tot_exp)

* To change existing variables, use "replace" instead
replace lnexp = tot_exp


* Logical statements (part 1):

* Make a variable, hh_gt5, that is 1 if hhsize at least 5, and 0 otherwise:
gen hh_gt5 = 1 if hhsize >= 5
replace hh_gt5 = 0 if hhsize < 5
* Below line wold have worked too:
* replace hh_gt5 = 0 if hhsize == . 
* or, do this all in one line with:
* gen hh_gt5 = hhsize >= 5


* Manipulating the data (part 2):

* Rename the variable hhsize into householdsize
rename hhsize householdsize

* Make a new label for the variable for householdsize
label variable householdsize "Number of people in household"

* Drop the variable householdsize (make a copy first though!)
gen hhsize = householdsize
drop householdsize


* Logical statements (part 2):

* Make a variable, hh_big_and_rich, that is 1 if hhsize is at least 5 AND tot_exp at least 2500. Variable is 0 if first is not true OR second is not true.
gen hh_big_and_rich = 1 if hhsize >= 5 & tot_exp >= 2500
replace hh_big_and_rich = 0 if hhsize < 5 | tot_exp < 2500
