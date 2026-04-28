import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.feature_selection import VarianceThreshold
from sklearn.metrics import r2_score
from sklearn.model_selection import LeaveOneOut
from sklearn.preprocessing import StandardScaler
from kennard_stone import train_test_split as ks_split
from jaqpotpy.descriptors import RDKitDescriptors
from jaqpotpy.datasets import JaqpotTabularDataset
from jaqpotpy.models import SklearnModel

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

test_pfas = ["PFTrDA", "PFDoA", "PFDA", "PFNA", "PFHpA", "PFPeA", "PFOPA", "PFOS"]

train_dataset = summarised_data[~summarised_data["PFAS"].isin(test_pfas)]
test_dataset = summarised_data[summarised_data["PFAS"].isin(test_pfas)]

train_jq = JaqpotTabularDataset(
    df=train_dataset,
    y_cols=["logBCF_nlls"],
    smiles_cols=["PubChem_SMILES"],
    task="REGRESSION",
    featurizers=RDKitDescriptors(),
)

test_jq = JaqpotTabularDataset(
    df=test_dataset,
    y_cols=["logBCF_nlls"],
    smiles_cols=["PubChem_SMILES"],
    task="REGRESSION",
    featurizers=RDKitDescriptors(),
)

selected_features = ["SMR_VSA5"]
train_jq.select_features(SelectColumns=selected_features)
test_jq.select_features(SelectColumns=selected_features)

jaqpot_model = SklearnModel(
    dataset=train_jq,
    model=LinearRegression(),
    preprocess_x=[StandardScaler()],
)
jaqpot_model.fit()
# jaqpot_model.cross_validate(train_jq, n_splits=3)#train_jq.df.shape[0])
jaqpot_model.evaluate(test_jq)

from jaqpotpy import Jaqpot

# Upload the pretrained model on Jaqpot
jaqpot = Jaqpot()
jaqpot.login()
jaqpot_model.deploy_on_jaqpot(
    jaqpot=jaqpot,
    name="My first Jaqpot Model",
    description="This is my first attempt to train and upload a Jaqpot model.",
    visibility="PUBLIC",
)
