# SAFOD-K-Ar-Dating-Analysis

## INPUT FILE FORMAT

Input file needs to be a csv with the following columns (named exactly the same):
1. **sf** - size fraction identifier (i.e. '0.8-1.4' or 'bulk')
2. **illite** - proportion of 1md illite provided by Profex
3. **illiteError** - esd provided by Profex
4. **Musc** - proportion of 2m1 muscovite provided by Profex
5. **MuscError** - esd provided by Profex
6. **age** - age based on disk run and K concentration estimate
7. **ageError** - error in age provided by disk run Excel file

The data for the bulk data (if applicable) should always be **the last row**

## SAMPLE INPUT FILE

sf | illite | illiteError | Musc | MuscError | age | ageError
--- | --- | --- | --- |--- |--- |--- 
0-0.2 | 0.9 | 0.02 | 0.04 | 0.01 | 4 | 1.2
0.2-0.5 | 0.5 | 0.02 | 0.04 | 0.005 | 5 | 0.1
bulk | 0.2 | 0.009 | 0.02 | 0.003 | 8 | 0.05
