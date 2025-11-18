import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Import the dataset
data = pd.read_csv("data/dataset.csv")
# Import list of smiles strings
smiles_list = pd.read_csv("data/SMILES_list.csv")

# Validate that all SMILES strings are derived from PubChem
not_matching = []
for i, pfas in enumerate(smiles_list.PFAS):
    if not smiles_list.SMILES[i] == smiles_list.PubChem_SMILES[i]:
        not_matching.append(pfas)
        print(
            f"SMILES string for {pfas} does not match PubChem SMILES string."
            f" {smiles_list.SMILES[i]} != {smiles_list.PubChem_SMILES[i]}"
        )

# Display the first few rows of the dataset
print(data.head())

# Drop not needed columns
data = data.drop(
    columns=["kup_nlls", "kel_nlls", "kup_pinns", "kel_pinns", "logBCD_pinns"]
)

print(f"Unique PFAS in dataset: {data['PFAS'].nunique()}")

# Map PFAS to SMILES strings in data DataFrame
smiles_dict = pd.Series(smiles_list.SMILES.values, index=smiles_list.PFAS).to_dict()

data["SMILES"] = data["PFAS"].map(smiles_dict)

# Estimate mean and sd (when applicable) LogBCF for each PFAS
grouped = data.groupby("PFAS")["logBCF_nlls"]
mean_logBCF = grouped.mean()
std_logBCF = grouped.std()
summary_df = pd.DataFrame(
    {"Mean_LogBCF": mean_logBCF, "SD_LogBCF": std_logBCF}
).reset_index()

print(f"Summary statistics for LogBCF:")
print(summary_df)
