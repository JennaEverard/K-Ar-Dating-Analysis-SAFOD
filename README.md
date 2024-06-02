# SAFOD-K-Ar-Dating-Analysis

A webapp for plotting york regressions and calculating authigenic illite ages of samples from the SAFOD (San Andreas Fault Observatory at Depth) core, particularly the regions 3188-3198 meters and 3304-3311 meters.

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

## USER INSTRUCTIONS

When you first open the webapp, you will be prompted to upload a csv file and enter a sample number. Either follow the csv format defined above, or download the template csv provided within the webapp. If your sample is one of the 8 previously analyzed, enter its number, otherwise enter an arbitrary number.

![Window for Data Input](https://github.com/JennaEverard/K-Ar-Dating-Analysis-SAFOD/blob/main/readme_images/data_input.png?raw=true)

The first diagram that pops up will be an image of the core showing the lithology. If your sample is one of those 8, the respective number will appear in color to indicate its position. Otherwise, you can locate your sample manually based on its depth.

![Graphic of Sample Position](https://github.com/JennaEverard/K-Ar-Dating-Analysis-SAFOD/blob/main/readme_images/sample_position.png?raw=true)

As you scroll, the next section will display the data as it was input via the csv file. If everything looks correct, you can continue.

![Visual of Data Input](https://github.com/JennaEverard/K-Ar-Dating-Analysis-SAFOD/blob/main/readme_images/data_input_readback.png?raw=true)

The next section calculates the detrital illite percentages and uncertainties from the raw data.

![Calculated Detrital Percentage Data](https://github.com/JennaEverard/K-Ar-Dating-Analysis-SAFOD/blob/main/readme_images/data_calculated.png?raw=true)

The final section displays the generated york regression diagram.

![York Regression Plot](https://github.com/JennaEverard/K-Ar-Dating-Analysis-SAFOD/blob/main/readme_images/regression.png?raw=true)

If, at the start, you selected to display the bulk data from Coffey et. al., this data will be displayed in pink.

![York Regression Plot with Bulk Data](https://github.com/JennaEverard/K-Ar-Dating-Analysis-SAFOD/blob/main/readme_images/regression_with_bulk.png?raw=true)

This section is concluded with a textbox that included both the authigenic age and the detrital age.

![Sample Age Dialog](https://github.com/JennaEverard/K-Ar-Dating-Analysis-SAFOD/blob/main/readme_images/age.png?raw=true)
