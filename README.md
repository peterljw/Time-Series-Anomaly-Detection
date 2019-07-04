# Time-Series-Anomaly-Detection

 A demonstration of time-series anomaly detection utilizing various anomaly detection algorithms and packages such as RandomCutForest(AWS SageMaker), Isolation Forest, K-Means, One Class SVM, STL decomposition, etc with testing data from [The Numenta Anomaly Benchmark](https://github.com/numenta/NAB) dataset.

## Algorithms Overview

* [RandomCutForest](https://docs.aws.amazon.com/sagemaker/latest/dg/randomcutforest.html)/[Isolation Forest](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.IsolationForest.html)

A tree ensemble method that aims to detect anomalies through data space partitioning. For example, a random sample of the input data is first determined. The random sample is then partitioned according to the number of trees in the forest. Each tree is given such a partition and organizes that subset of points into a k-d tree. The anomaly score assigned to a data point by the tree is defined as the expected change in complexity of the tree as a result adding that point to the tree; which, in approximation, is inversely proportional to the resulting depth of the point in the tree. Anomalies are then determined based on a desired level of threshold for anomaly score.

* [K-Means](https://scikit-learn.org/stable/modules/generated/sklearn.cluster.KMeans.html)

With K-means, we form a proper number of the cluster among the data and aim to detect the anomalies by investigating data points which fall outside of cluster groups. Thus, the method has a significant underlying assumption: normal data will fall within major clusters while anomalies will fall far away from any cluster centroids. The method calculates the distances between each point to its cluster centroid and determines a distance threshold based on the minimum distance among the `n` largest distances, where n is the number of anomalies determined by `outliers_fraction`. At the end, data points associated with distances that are greater than the determined threshold will be considered as anomalies.

* [One Class SVM](https://scikit-learn.org/stable/modules/generated/sklearn.svm.OneClassSVM.html)

This method aims to find a function that is positive for regions with high density of points, and negative for small densities. The method aims to classify rare occurances in data patterns as anomalies. The variable `outliers_fraction`, which gets passed into the `nu` parameter of the `OneClassSVM` function. The `nu` parameter denotes an upper bound on the fraction of training errors and a lower bound of the fraction of support vectors.

* [Anomalize w/ STL and Twitter Decomposition](https://business-science.github.io/anomalize/index.html)

The method utilizes time series decomposition. The measured value or the numerical value on which detection needs to be performed for a particular group is decomposed into four columns that are observed, season, trend, and remainder. The default method used for decomposition is STL, which is a seasonal decomposition utilizing a Loess smoother, and an alternative to it is Twitter. Twitter is identical to STL for removing the seasonal component. The difference is in removing the trend is that it uses piece-wise median of the data(one or several median split at specified intervals) rather than fitting a smoother. This method works well where seasonality dominates the trend in time series.

## Authors

* **Jiawei Long** - [peterljw](https://github.com/peterljw)

## Acknowledgments
* Inspired by Susan Li
