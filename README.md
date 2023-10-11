# Climate Change Video Comments Analysis (climate-change-comments-youtube)

## Overview
This repository contains the R scripts used for the analysis of comments from the 10 most viewed climate change videos on YouTube as part of a master's thesis conducted at TU Ilmenau. The methodology taken as an example was described by Shapiro and Park (2015), and for the purpose of future replicability, the main scripts were prepared in R language, including data collection, data cleaning, and preparation of co-occurrence matrices for each dataset. These resulting matrices were used to conduct the CONCOR analysis, short for convergence of iterated correlations, is a method that categorizes words into positions based on their structural equivalence, as described by Wasserman and Faust (1994), to cluster the 50 most used keywords. CONCOR analysis was conducted in UCINET 6 software (Borgatti et al., 2002).

## Contents
This repository contains the following main components:

- `data/`: This directory holds the data files used for the analysis.
- `scripts/`: All R scripts used for data collection, cleaning, and matrix preparation are stored here.
- `results/`: This directory may contain the co-occurrence matrices and any other intermediate or final analysis results.
- `LICENSE`: A license file that specifies the terms of use for the code and data.

## Getting Started
If you wish to replicate the analysis, follow these steps:

1. Clone this repository to your local machine using `git clone`.

2. Review the scripts in the `scripts/` directory for detailed descriptions and comments explaining the workflow.

3. Execute the R scripts in the order specified to reproduce the data collection, data cleaning, and matrix preparation steps.

4. For the CONCOR analysis, use UCINET 6 software as described in the methodology section.

## Data Sources
The datasets used for this analysis are included in this repository. You can find the data sources in the `data/` directory and instructions for data collection in the respective R scripts in the `scripts/` directory.

## Dependencies
Make sure you have R and any required R packages installed. Dependencies are listed within the R scripts themselves.

## License
This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

## Acknowledgments
- Shapiro, M. D., & Park, H. W. (2015). More than entertainment: YouTube and public responses to the science of global warming and climate change. Social Science Information, 54(1), 115–145. [DOI: 10.1177/0539018414554730](https://doi.org/10.1177/0539018414554730).

- Wasserman, S., & Faust, K. (1994). Social network analysis: Methods and applications. Cambridge University Press.

- Borgatti, S. P., Everett, M. G., & Freeman, L. C. (2002). UCINET 6 for Windows: Software for social network analysis. Analytic Technologies.


