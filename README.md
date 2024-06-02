# SAFOD-K-Ar-Dating-Analysis

A webapp for plotting isochrons and calculating authigenic illite ages of samples from the SAFOD (San Andreas Fault Observatory at Depth) core, particularly the regions 3188-3198 meters and 3304-3311 meters.

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

## GETTING STARTED


