# adonis_loop

Background
------

This is a simple script that performs permutational multivariate analysis of variance (PERMANOVA) on a given OTU table to test the impact of a given metavariable (say exposure to drug) on the user-defined dissimilarity measure (such as Canberra) that summarizes the given OTU table.

The script is adjusted such that it can take in any OTU table file, generated via [QIIME 1.8.0 (stable public release)](http://qiime.org/), (in tab-delimited format) as input and standard mapping/metadata file compatible with QIIME.

Work is in progress to include UniFrac distance measures.

Required R packages
------

- [vegan](https://cran.r-project.org/web/packages/vegan/index.html)

Running the script
------

There is 1 script in the folder ```src```. It is called ```adonis_loop.R```. The script is run via command line using the Rscript command (in terminal). 

To run the script on example data provided, pass the command in following format:

```Rscript adonis_loop.R otu_table_rarefied.txt mapping_file.txt adnois_results.txt canberra```

As seen from the command, the script takes in 4 commands. They are as follows:

1) OTU table generated via QIIME (which is called **otu_table_rarefied.txt** in the above example)

2) QIIME compatible mapping file (which is called **mapping_file.txt** in the above example)

3) Name of the output file produced (which is called **adnois_results.txt** in the above example)

4) Name of the distance measured used (which is called **canberra** in the above example)

Input file format
------

Input of file format should be one compatabile with QIIME. However, please ensure that the sample IDs are not numeric. That is, the sample IDs should not be like: 1560.1, 1561.1, 1559.1, etc. If such is the case, please slightly modify the sample IDs in both the mapping file and OTU table by adding any alphabet. So, for example, sample ID 1560.1 will become p1560.1.

Also, please make sure that the mapping file has the same number of samples as the OTU tables, having the same sample IDs. If mapping file has more or less sample IDs than the samples in the OTU table, the script will crash.

Additional Information
------

There is an extra script in the folder ```src/from_distance_matrices``` called ```adonis_from_dm.R``` that can directly use distance matrices and give adonis output.
