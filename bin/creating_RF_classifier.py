import pandas as pd
import os
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.datasets import make_classification
from sklearn import metrics
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report

os.chdir('/projects/ciwars/jamesm22/TestData_Hybrids/')
path = "."
dir_list = os.listdir(path)

##### Load input files and convert MGE classes to integers #####
workingtable=pd.read_csv("RF_testing_training_data.csv")
workingtable= workingtable.replace('plasmid','0', regex=True)
workingtable= workingtable.replace('phage','1', regex=True)
workingtable= workingtable.replace('Hybrid','2', regex=True)
workingtable=workingtable.drop(columns=['Specific Contig','Unnamed: 0'])

##### Obtain test and training data #####
Test=workingtable.sample(frac=0.2,random_state=57)
#Test=workingtable.sample(frac=0.3)
Training=workingtable[~workingtable.isin(Test)].dropna()

X1 = Training.drop("MGE Element Type", axis=1)
X=np.array(X1)
y=np.array(Training['MGE Element Type'])

##### Run Classifier #####
RF_classifier = RandomForestClassifier(max_depth=8,criterion="entropy",random_state=0,max_features="sqrt",class_weight="balanced_subsample")
RF_classifier.fit(X,y)

##### Classifier was saved a pickle file for future use #####
filename = 'finalized_model.sav'
pickle.dump(RF_classifier, open(filename, 'wb'))

##### Obtaining Confusion Matrix Results #####
X2 = Test.drop("MGE Element Type", axis=1)
ya=np.array(Test['MGE Element Type'])
Xa=np.array(X2)
y_pred=RF_classifier.predict(Xa)
y_final=classification_report(ya, y_pred, output_dict=True)
DF=pd.DataFrame(y_final)
df = pd.DataFrame(y_final).transpose()

confusion_matrix(ya, y_pred)
print(classification_report(ya, y_pred))
