*Version 1.0
*Author -- Jade Peng & Ricardo Miranda
*Date -- Oct 22, 2022
*Master dofile to analize ENIGH (Mexican National Income and Expenditures Survey) for the 2022 DEAL lectures at Duke University


*Initial commands
clear all
set more off
set maxvar 5000
pause on

*Set working directory for a folder that will be shared 
global User "Ricardo"
if "$User"=="Ricardo"{
    *Approach 1:
	cd "D:\DEAL\Lecture1"
	*Approach 2
	global Raw "D:\DEAL\Lectures2022\Raw"
	global Working "D:\DEAL\Lectures2022\Working"
	global Tables "D:\DEAL\Lectures2022\Tables"
	global Figures "D:\DEAL\Lectures2022\Figures"
	global Dos "D:\DEAL\Lectures2022\Dos"
}

if "$User"=="Jade"{
	global Raw "D:\DEAL\Lectures2022\Raw"
	global Working "D:\DEAL\Lectures2022\Working"
	global Tables "D:\DEAL\Lectures2022\Tables"
	global Figures "D:\DEAL\Lectures2022\Figures"
	global Dos "D:\DEAL\Lectures2022\Dos"
}

do "$Dos\01_CleanConcentradoHogares.do"
do "$Dos\02_CleanLivingPlaceCharacteristics.do"
do "$Dos\03_VariableConstruction.do"