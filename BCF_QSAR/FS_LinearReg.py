import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from xgboost import XGBRegressor
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.feature_selection import VarianceThreshold
from sklearn.metrics import r2_score
from sklearn.model_selection import LeaveOneOut, train_test_split
from sklearn.preprocessing import StandardScaler
from kennard_stone import train_test_split as ks_split
from jaqpotpy.descriptors import RDKitDescriptors
from jaqpotpy.datasets import JaqpotTabularDataset

bcf_data = pd.read_csv("data/dataset.csv")
smiles_list = pd.read_csv("data/SMILES_list.csv")
bcf_data = bcf_data[["PFAS", "logBCF_nlls"]]

summarised_data = bcf_data.groupby("PFAS", as_index=False)["logBCF_nlls"].mean()
summarised_data = pd.merge(
    summarised_data, smiles_list[["PFAS", "PubChem_SMILES"]], how="left", on="PFAS"
)
summarised_data = summarised_data[
    ~summarised_data["PFAS"].isin(["F-53B"])
]  # , "PFTrDA"])]

descriptors_df = JaqpotTabularDataset(
    df=summarised_data,
    y_cols=["logBCF_nlls"],
    smiles_cols=["PubChem_SMILES"],
    task="REGRESSION",
    featurizers=RDKitDescriptors(),
)

# ── Load descriptors into a DataFrame ────────────────────────────────────────
raw = descriptors_df.df
y = raw["logBCF_nlls"].values
X = raw.drop(columns=["logBCF_nlls"])

# ── Drop columns with any NaN ─────────────────────────────────────────────────
X = X.dropna(axis=1)

# ── Standard scaling per column ──────────────────────────────────────────────
scaler = StandardScaler()
X_scaled = pd.DataFrame(scaler.fit_transform(X), columns=X.columns)

# ── Variance threshold (remove zero-variance features) ───────────────────────
vt = VarianceThreshold(threshold=0.0)
vt.fit(X_scaled)
X_scaled = X_scaled.loc[:, vt.get_support()]

# ── Correlation filter (threshold = 1.0) ─────────────────────────────────────
corr_matrix = X_scaled.corr().abs()
mean_corr = corr_matrix.mean(axis=1)

to_drop = set()
cols = list(X_scaled.columns)
for i in range(len(cols)):
    for j in range(i + 1, len(cols)):
        if cols[i] in to_drop or cols[j] in to_drop:
            continue
        if corr_matrix.loc[cols[i], cols[j]] >= 0.99:
            if mean_corr[cols[i]] >= mean_corr[cols[j]]:
                to_drop.add(cols[i])
            else:
                to_drop.add(cols[j])

X_filtered = X_scaled.drop(columns=list(to_drop))
print(f"Features after correlation filter: {X_filtered.shape[1]}")

# ── Kennard-Stone train/test split (80/20) ────────────────────────────────────
pfas_names = summarised_data["PFAS"].reset_index(drop=True)

X_train, X_test, y_train, y_test, names_train, names_test = ks_split(
    X_filtered,
    y,
    pfas_names,
    test_size=0.4,
)
X_train = pd.DataFrame(X_train, columns=X_filtered.columns)
X_test = pd.DataFrame(X_test, columns=X_filtered.columns)
print(f"X_train size = {len(X_train)}")
print(f"X_test size  = {len(X_test)}")
print(f"Test set chemicals: {list(names_test)}")


# ── LOO R² helper ─────────────────────────────────────────────────────────────
def loo_r2(X_arr, y_arr):
    loo = LeaveOneOut()
    rf = LinearRegression()  # random_state=42)
    preds = np.empty(len(y_arr))
    for train_idx, test_idx in loo.split(X_arr):
        rf.fit(X_arr[train_idx], y_arr[train_idx])
        preds[test_idx] = rf.predict(X_arr[test_idx])
    return r2_score(y_arr, preds)


# ── Forward selection with LOO scoring ───────────────────────────────────────
# In each iteration: try adding each remaining feature, keep the one that
# gives the best LOO R², record history, continue until all features are added.
remaining = list(X_train.columns)
selected = []
fs_history = []  # (n_features, loo_r2)

MAX_FEATURES = 5

while remaining and len(selected) < MAX_FEATURES:
    scores = {}
    for feat in remaining:
        candidate = selected + [feat]
        scores[feat] = loo_r2(X_train[candidate].values, y_train)

    best_feat = max(scores, key=scores.get)
    selected.append(best_feat)
    remaining.remove(best_feat)
    fs_history.append((len(selected), scores[best_feat]))
    print(
        f"Added '{best_feat}' → {len(selected)} features, LOO R2: {scores[best_feat]:.4f}"
    )

fs_n, fs_scores = zip(*fs_history)

# ── Elbow plot ────────────────────────────────────────────────────────────────
plt.figure(figsize=(8, 5))
plt.plot(fs_n, fs_scores, marker="o")
plt.xlabel("Number of features")
plt.ylabel("LOO R²")
plt.title("Forward selection elbow plot")
plt.tight_layout()
plt.savefig("fs_elbow.png", dpi=150)
plt.show()

# ── Retrain on manually chosen number of features ────────────────────────────
N_FEATURES = int(
    input("\nEnter number of features to keep: ")
)  # set based on elbow plot

# selected list is already in addition order — take the first N_FEATURES
selected_features = selected[:N_FEATURES]
print(f"Selected features ({len(selected_features)}): {selected_features}")

X_final_train = X_train[selected_features].values
X_final_test = X_test[selected_features].values

final_model = LinearRegression()  # random_state=42)
final_model.fit(X_final_train, y_train)

train_r2 = r2_score(y_train, final_model.predict(X_final_train))
loo_r2_final = loo_r2(X_final_train, y_train)
test_r2 = r2_score(y_test, final_model.predict(X_final_test))

print(f"\nTrain R2:  {train_r2:.4f}")
print(f"LOO R2:    {loo_r2_final:.4f}")
print(f"Test R2:   {test_r2:.4f}")
