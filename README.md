# ensMAPDP 
This repository stores the code used in the PhD thesis:

M. Krzak, "Cell subpopulation detection through clustering single-cell RNAseq data"

Codes include the analysis of example scRNAseq dataset using newly developed ensMAPDP method. 
Please note that in order to run the codes you need proper versions of R and Matlab mentioned in the thesis.
There is no guarantee that the results will be generated properly if any other versions will be used.  

## Package installation
Prior to running the main code of our analysis install required R packages by executing the install_packages.R script.

"install_packages.R" - installs R package dependcies required to run ensMAPDP functions

## Running the ensMAPDP Workflow 
The example analysis workflow is stored in vignette/Workflow.R script. The following script will execute a sequence of analysis steps and functions of ensMAPDP.
Note that the method is stochastic (due to tSNE and UMAP dimension reduction used) and require to setup the seed for reproducibility of the results.

## Minimum system requirements
The method has been tested on the Ubuntu system and machine with specifications - Intel Core i7, 4.00 GHz x 8 and 24 GB RAM which are the minimum system requirements. The algorithm has been developed using R version 3.5.1 and Matlab version r2018a. At the current developmental stage of the method, the other specifications of the system, R and Matlab, cannot guarantee the correct execution of the algorithm scripts.

## Contact

Please report any bugs or issues you will encounter when using this repository. Feel free to contact monika.sonia.krzak@gmail.com for any other queries. 

### Copyright
This repository was fully created by: Monika Krzak, on 2019. All rights reserved.
