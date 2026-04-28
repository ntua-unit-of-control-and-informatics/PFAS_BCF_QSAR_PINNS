# PFAS Bioconcentration Factor Predictor

## What does this tool do?

This tool predicts how much a PFAS (per- and polyfluoroalkyl substance) accumulates inside **zebrafish** (*Danio rerio*) compared to the surrounding water. This property is called the **Bioconcentration Factor (BCF)** and is expressed on a logarithmic scale (log BCF).

A higher log BCF value means the substance is more likely to accumulate in living organisms — which is an important indicator for environmental risk assessment.

---

## What are PFAS?

PFAS are a large family of man-made chemicals widely used in industrial and consumer products (non-stick coatings, firefighting foams, waterproof textiles, etc.). Due to their extreme chemical stability, they persist in the environment and can accumulate in the food chain, raising serious concerns for human and ecosystem health.

---

## Input

To use this tool, you need to provide the **SMILES string** of the PFAS molecule you want to evaluate. SMILES (Simplified Molecular Input Line Entry System) is a standard text notation that encodes the structure of a chemical compound. It can be retrieved from chemical databases such as [PubChem](https://pubchem.ncbi.nlm.nih.gov/).

**Example input:**
```
PFAS name: PFOA
SMILES: C(=O)(C(C(C(C(C(C(C(F)(F)F)(F)F)(F)F)(F)F)(F)F)(F)F)(F)F)O
```

---

## Data

The model was trained on experimental BCF measurements collected for a curated set of PFAS compounds. When multiple measurements were available for the same compound, the average value was used to ensure consistency.

The dataset was divided into a **training set** and an independent **test set** using the Kennard-Stone algorithm — a method that ensures the test set reflects the full diversity of the chemical space covered by the training data.

---

## Modelling approach

The model is a **Multiple Linear Regression (MLR)** model. It learns a mathematical relationship between molecular descriptors (numerical properties computed from the chemical structure) and the experimental log BCF values.

### Feature selection

Molecular structure descriptors were first computed using RDKit, a widely used cheminformatics toolkit. Before training, the descriptor space was systematically reduced through the following steps:

1. **Removal of uninformative descriptors** — descriptors with missing values or zero variance across compounds were discarded.
2. **Correlation filtering** — when two descriptors carry nearly identical information (correlation ≥ 0.99), the more redundant one was removed.
3. **Forward selection** — starting from an empty model, descriptors were added one at a time. At each step, the descriptor that most improved the model's predictive performance (measured by cross-validation) was selected. The process stopped after a maximum of 5 descriptors.

### Cross-validation

Model performance during feature selection was assessed by **Leave-One-Out Cross-Validation (LOO-CV)**. This means that each compound is temporarily removed from the training set, the model is retrained on the rest, and a prediction is made for the excluded compound. This is repeated for every compound, giving a robust estimate of how well the model generalises to unseen data.

---

## Selected descriptor

The final model uses a single molecular descriptor:

| Descriptor | Description |
|---|---|
| `SMR_VSA5` | A measure of the molecular surface area weighted by molar refractivity, capturing the size and polarisability of a specific region of the molecule. Computed with RDKit. |

---

## Performance

| Metric | Value |
|---|---|
| Training R² | 0.82 |
| LOO Cross-validation R² | 0.67 |
| Test set R² | 0.70 |

> R² (coefficient of determination) ranges from 0 to 1. A value of 1 means perfect prediction; a value closer to 0 means the model has limited predictive power.

---

## Limitations

- The model is trained exclusively on **PFAS compounds**. Predictions for non-PFAS chemicals are outside the model's applicability domain and should not be trusted.

---

## References

- RDKit: Open-source cheminformatics. https://www.rdkit.org
- Kennard, R.W. & Stone, L.A. (1969). Computer aided design of experiments. *Technometrics*, 11(1), 137–148.
