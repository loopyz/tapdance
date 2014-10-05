import numpy as np
import scipy
from sklearn import linear_model, preprocessing, metrics
import simplejson
import sys

data = np.loadtxt('velocity.csv', skiprows=1, delimiter=',')
data = data[:, 3:]

output = []

features = data[:, :-2]
features = np.c_[features, np.multiply(features, features)]
scaler = preprocessing.StandardScaler().fit(features)
klass = data[:, -1]
lr = linear_model.LogisticRegression()
#lr.fit(features, klass)
lr.fit(scaler.transform(features), klass)
predicted = lr.predict(scaler.transform(features))
print >> sys.stderr, metrics.classification_report(klass, predicted)

for start in [0, 1, 2, 3, 4]:
	rows = data[data[:, -2] == start, :]
	features = rows[:, :-2]
	#features = np.c_[features, np.multiply(features, features)]
	scaler = preprocessing.StandardScaler().fit(features)
	klass = rows[:, -1]
	lr = linear_model.LogisticRegression()
	#lr.fit(features, klass)
	lr.fit(scaler.transform(features), klass)
	predicted = lr.predict(scaler.transform(features))
	print >> sys.stderr, metrics.classification_report(klass, predicted)
	print lr.predict_proba(scaler.transform([[0.051572,-0.486934,2.221161,4.125000,364.000000,-115.437500,-3.134978,-1.041031,2.338640,-0.914137,0.235959,-0.329660,-0.804259,0.587325,0.090646]]))
	#print "start=", start, "coef=", lr.coef_, "intercept=", lr.intercept_
	output.append({'matrix': lr.coef_.tolist(), 'intercept': lr.intercept_.tolist(), 'mean': scaler.mean_.tolist(), 'std': scaler.std_.tolist()})

print simplejson.dumps({'parameters': output}, indent=2)