## Overview

This one-compartment kinetic model simulates PFAS bioconcentration in fish tissue over time. The model calculates tissue concentration based on uptake from water and elimination processes.

## Model Equation

The model follows a simple differential equation:

```
dC/dt = kup × Cw - kel × C
```

Where:
- **C**: Tissue concentration (μg/kg)
- **Cw**: Water concentration (μg/L)
- **kup**: Uptake rate constant (L/kg/day)
- **kel**: Elimination rate constant (1/day)

## Usage

The model will automatically assign the correct kinetic parameters (kup, kel) based on the PFAS and study combination.

## Parameters

The kinetic parameters used in this model are study-specific and derived from experimental data. Below is the complete list of available PFAS compounds, study numbers, and their corresponding uptake and elimination rates:

| Study | PFAS   | kup (L/kg/day)      | kel (1/day)         |
|-------|--------|---------------------|---------------------|
| 2     | F-53B  | 0.11                | 0.05                |
| 4     | F-53B  | 39.77               | 0.05                |
| 4     | OBS    | 62.53               | 0.24                |
| 5     | PFBA   | 1.75                | 1.61                |
| 6     | PFBA   | 0.61                | 1.06                |
| 9     | PFBA   | 1.66                | 0.08                |
| 4     | PFBS   | 0.85                | 0.34                |
| 5     | PFBS   | 1.59                | 1.38                |
| 6     | PFBS   | 1.8                 | 1.21                |
| 7     | PFBS   | 1.81                | 1.1                 |
| 8     | PFBS   | 1.725               | 0.82                |
| 9     | PFBS   | 4.23                | 0.185               |
| 5     | PFDA   | 20.4                | 0.17                |
| 6     | PFDA   | 41.9                | 0.03                |
| 7     | PFDA   | 38.1                | 0.03                |
| 8     | PFDA   | 39.8                | 0.04                |
| 9     | PFDA   | 433.5               | 0.01                |
| 5     | PFDoA  | 99.9                | 0.19                |
| 6     | PFDoA  | 162                 | 0.01                |
| 7     | PFDoA  | 179                 | 0.02                |
| 8     | PFDoA  | 179                 | 0.02                |
| 9     | PFDoA  | 698.5               | 0.01                |
| 9     | PFDPA  | 12.45               | 0.05                |
| 5     | PFHpA  | 5.03                | 0.88                |
| 6     | PFHpA  | 5.87                | 0.78                |
| 7     | PFHpA  | 5.38                | 0.76                |
| 8     | PFHpA  | 4.915               | 0.64                |
| 5     | PFHxA  | 2.39                | 1.37                |
| 6     | PFHxA  | 2.95                | 1.47                |
| 7     | PFHxA  | 2.59                | 1.41                |
| 8     | PFHxA  | 2.49                | 1.025               |
| 9     | PFHxA  | 1.285               | 0.13                |
| 9     | PFHxPA | 1.62                | 0.0025              |
| 4     | PFHxS  | 4.82                | 0.183               |
| 9     | PFHxS  | 18.35               | 0.075               |
| 5     | PFNA   | 28.1                | 0.33                |
| 6     | PFNA   | 18.9                | 0.05                |
| 7     | PFNA   | 15.2                | 0.05                |
| 8     | PFNA   | 19.3                | 0.1                 |
| 9     | PFNA   | 109.8               | 0.055               |
| 1     | PFOA   | 0.02                | 0.1                 |
| 3     | PFOA   | 3.67                | 0.12                |
| 6     | PFOA   | 7.56                | 0.15                |
| 7     | PFOA   | 7.41                | 0.15                |
| 8     | PFOA   | 9.33                | 0.26                |
| 9     | PFOA   | 16.05               | 0.205               |
| 9     | PFOPA  | 5.09                | 0.005005            |
| 4     | PFOS   | 32.43               | 0.05                |
| 6     | PFOS   | 37.6                | 0.02                |
| 7     | PFOS   | 40.2                | 0.02                |
| 8     | PFOS   | 41.3                | 0.03                |
| 9     | PFOS   | 141.1               | 0.02                |
| 5     | PFPeA  | 1.74                | 1.18                |
| 6     | PFPeA  | 1.45                | 1.72                |
| 7     | PFPeA  | 1.36                | 1.65                |
| 8     | PFPeA  | 1.12                | 1.12                |
| 9     | PFTeDA | 7865                | 0.011               |
| 9     | PFTrDA | 1509                | 0.01                |
| 5     | PFUnA  | 47                  | 0.16                |
| 6     | PFUnA  | 61.9                | 0.03                |
| 7     | PFUnA  | 62.9                | 0.03                |
| 8     | PFUnA  | 64.7                | 0.03                |
| 9     | PFUnA  | 454                 | 0.01                |

**Note:** Parameters vary across studies due to differences in experimental conditions, species, and methodologies. Select the appropriate study number based on your specific use case.

## Studies
1.	Bian Y, He MY, Ling Y, Wang XJ, Zhang F, Feng XS, et al. Tissue distribution study of perfluorooctanoic acid in exposed zebrafish using MALDI mass spectrometry imaging. Environmental Pollution. 2022 Jan 15;293. 
2.	Wu Y, Deng M, Jin Y, Liu X, Mai Z, You H, et al. Toxicokinetics and toxic effects of a Chinese PFOS alternative F-53B in adult zebrafish. Ecotoxicol Environ Saf. 2019 Apr;171:460–6. 
3.	Ulhaq M, Sundström M, Larsson P, Gabrielsson J, Bergman Å, Norrgren L, et al. Tissue uptake, distribution and elimination of 14C-PFOA in zebrafish (Danio rerio). Aquatic Toxicology. 2015 Jun;163:148–57. 
4.	Huang J, Liu Y, Wang Q, Yi J, Lai H, Sun L, et al. Concentration-dependent toxicokinetics of novel PFOS alternatives and their chronic combined toxicity in adult zebrafish. Science of The Total Environment. 2022 Sep;839:156388. 
5.	Wang H, Hu D, Wen W, Lin X, Xia X. Warming Affects Bioconcentration and Bioaccumulation of Per- and Polyfluoroalkyl Substances by Pelagic and Benthic Organisms in a Water–Sediment System. Environ Sci Technol. 2023 Mar 7;57(9):3612–22. 
6.	Wen W, Xiao L, Hu D, Zhang Z, Xiao Y, Jiang X, et al. Fractionation of perfluoroalkyl acids (PFAAs) along the aquatic food chain promoted by competitive effects between longer and shorter chain PFAAs. Chemosphere. 2023 Mar;318:137931. 
7.	Wen W, Xia X, Zhou D, Wang H, Zhai Y, Lin H, et al. Bioconcentration and tissue distribution of shorter and longer chain perfluoroalkyl acids (PFAAs) in zebrafish (Danio rerio): Effects of perfluorinated carbon chain length and zebrafish protein content. Environmental Pollution. 2019 Jun;249:277–85. 
8.	Wen W, Xia X, Hu D, Zhou D, Wang H, Zhai Y, et al. Long-Chain Perfluoroalkyl acids (PFAAs) Affect the Bioconcentration and Tissue Distribution of Short-Chain PFAAs in Zebrafish ( Danio rerio ). Environ Sci Technol. 2017 Nov 7;51(21):12358–68. 
9.	Chen F, Gong Z, Kelly BC. Bioavailability and bioconcentration potential of perfluoroalkyl-phosphinic and -phosphonic acids in zebrafish (Danio rerio): Comparison to perfluorocarboxylates and perfluorosulfonates. Science of The Total Environment. 2016 Oct;568:33–41. 
