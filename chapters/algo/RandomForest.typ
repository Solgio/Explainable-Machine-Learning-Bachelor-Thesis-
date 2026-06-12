#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side


== Random forest
<random-forest>
=== Mathematical model
<sub:rand-for-model> 
Random forest is an ensamble method that combines multiple decision trees to improve better prediction performance compared to a single tree. In particular, the idea is to address the overfitting and instability problems discussed in @sub:dec-tree-predictive-performance-and-limitations. Exists multiple ways to achieve this. The most common are:

+ #strong[Bootstrap Aggregating (Bagging):] training every tree on a different sample of the dataset
+ #strong[Feature Randomness:] every split consider only a random subset of features
+ #strong[Averaging/Voting:] the single predictions are combined to extract a final prediction using mean (regression) or majority voting (classification)

This three techniques are backed by the idea of #strong[diversity] among the trees.\
A single tree is a high-variance model, so by combining many different trees, we can reduce the variance and improve the generalization performance.
$ upright("Var") \( macron(X) \) = frac(upright("Var") \( X \), T) $
If the trees were completely independent, the variance of the mean would decrease by a factor of $T$ (number of trees). In practice they are not independent because the features considered are the same, so the reduction is less, but still significant.\
The feature randomness further de-correlates the trees by forcing the trees to learn different dependencies between features. If they were all using the same features, even with different samples, they would still tend to choose the same splits.\
The resulting process is: 
```
1. For each tree t in 1 to T (number of trees, usually 100-1000):
   a. Create a bootstrap dataset D_t by sampling n instances with replacement from the original data
   b. Train a decision tree on D_t with the following constraints:
      - At each node, consider only m_try = sqrt(p) features (classification) or m_try = p / 3 (regression)
      - Grow the tree fully (no pruning) until purity (overfitting is OK, will be mitigated by bagging)

2. For prediction:
   - Classification: let all trees vote → final class == mode (most frequent)
   - Regression: let all trees predict → final value = mean of predictions
```
=== Time complexity
<sub:rand-for-time-complexity>
The time complexity of Random forest is obviously based on the time complexity of training and inference of a single decision tree, multiplied by the number of trees $T$ (@sub:dec-tree-time-complexity).
$ O \( T dot.op n log \( n \) dot.op p \) $

Where $n$ is the number of observation and $p$ is the number of features. Note that the feature randomness reduces the effective number of features considered.
If at first impact the time complexity seems high, it is important to consider that the training of multiple trees can be easily parallelized, cutting down effectively the training time.
For *inference*, the time complexity again depends on the time complexity of the single tree, multiplied by $T$:
$ O \( T dot.op d \) $
Where $d$ is the average depth of a tree which for unpruned trees, $d approx log \( n \)$ in the average case and n in the worst case (completely unbalanced tree). Usually what is preferred, is to have fast inference models but that can be trained for a long time, so the training time is not a big issue, while the inference time is more critical. In this case, Random forest is a good compromise, as it is slower than a single tree but still efficient enough for most applications.

=== Spacial complexity
<sub:rand-for-spacial-complexity>
The space complexity of Random forest takes in account the sapce needed to store the $m$ samples and $p$ feaures during training, for a total spacial complexity of $O(m dot.op p)$. Once the training is completed, the space complexity is determined by the number of trees and the size of each tree. 
$ O \( T dot.op n\) $

=== Internal representation
<sub:rand-for-internal-representation>
A Random forest is represented as a list of trees, each of which is a complete decision tree.
```
Forest == [Tree_1, Tree_2, ..., Tree_T]

Each tree is:
Node(feature=x1, threshold=5.5, left=Node(...), right=Node(...))
```
For *explainability*, the internal representation is a more complex and obscure structure compared to a single decision tree. It becomes difficult to understand the overall decision process of the forest, as it is an aggregation of many trees. Even the local explanation of a  signle prediction is much more opaque for the same reason. A single tree can still be visualized and interpreted, for example by choosing the one that better explains a specific prediction, but the overall model remains of little interpretability.
==== Implicazioni per la Spiegabilità
<implicazioni-per-la-spiegabilità>
#strong[Contro:]

- #strong[Molto opaco globalmente:] con T == 100-500 alberi, è
  impossibile ispezionare manualmente il modello completo
- #strong[Difficile tracciare ragionamento:] non puoi seguire una
  singola catena di decisioni (ci sono 100 catene parallele)
- #strong[Aggregazione nascosta:] il voting/averaging che determina la
  previsione finale non è facilmente interpretabile

#strong[Pro:]

- #strong[Interpretabile localmente:] puoi estrarre il singolo albero
  più importante (quello che spiega meglio una previsione)
- #strong[Feature importance naturale:] misurata dalla riduzione di
  impurità media su tutti gli alberi
- #strong[Out-of-Bag (OOB) error:] stima di generalizzazione gratuita,
  senza bisogno di validation set separato

#strong[Confronto con altri modelli:]

- #strong[DT singolo:] interpretabile globalmente, ma instabile
- #strong[Random Forest:] opaco globalmente, ma stabile;
  interpretabilità per feature
- #strong[SVM:] completamente opaco, nessuna feature importance naturale

=== Data assumptions
<sub:rand-for-data-assumptions>
As described in @sub:dec-tree-data-assumptions, Decision Trees make very few assumptions about the data, and Random Forest inherits this property. In particular, Random Forest only assumes that the data is representative of the underlying distribution and that the features have some predictive power.\ This is particularly important thinking about the bagging process, as the random sampling of the data must be representative to ensure that the trees learn meaningful patterns. Stratification in consequently needed to enable the trees to predict effectively.


=== Predictive performance and limitations
<sub:rand-for-predictive-performance-and-limitations>
The ensamble nature of Random Forest allows it to achieve excellent predictive performance, tackling the overfitting and instability problems of a single tree.
At the same time it inherits the ability to capture complex patterns and interaction between features, as well as naturally handling both numerical and #gls("categorical_features").\
However, it has its own limitations. It is still sensitive to feature dominance especially for categorical features with many categories. Moreover, it is not a good choice for purely linear data, where a simple linear model would achieve better performance.\
The use of many trees also makes it more computationally and memory intensive. This is paired with a higher number of hyperparameters, for example the number of trees, the dimension of the random feature subset, in addition to the tree depth and minimum samples per split. If not tuned properly, the performance can be significantly reduced.\
Finally, the output of a Random Forest is a probability (fraction of trees that vote for a class), which is not well calibrated as in Logistic Regression, so it may not reflect true confidence in the prediction.
To summarize, the main improvements of Random forest, better stability and lower variance, come at the cost of computational complexity and still maintains some limitation with linear data, feature dominance and class imbalance.

=== Metrics for prediction quality
<sub:rand-for-metrics>
To evaluate the predictive performance of Random forest, we can use both general metrics for classification and regression, as well as specific metrics that take advantage of the tree structure and ensemble nature. For the common metrics, see @cap:classification-metrics(Classification) and @cap:regression-metrics(Regression).\

==== Class probability (Voting)
<sub:rand-for-class-probability-voting>
Random forest naturally produces a class probability for classification, based on the fraction of trees that vote for each class:
$ P \( y == k \) = frac(upright("number of trees that vote for class") k, T) $
This probability can be used to evaluate the confidence of the prediction, but as mentioned before, it is not well calibrated, so it should be used with caution. For calibrated probabilities, post-hoc methods like Platt scaling or isotonic regression can be applied.

==== Out-of-Bag (OOB) Error
<sub:rand-for-out-of-bag-oob-error>
OOB error is a unique metric for Random Forest that provides an estimate of the generalization error without the need for a separate validation set. During training, each tree is trained on a bootstrap sample of the data, which means that some instances are left out (out-of-bag). These OOB instances can be used to test the performance of the tree on unseen data. The OOB error is calculated as the average error of the predictions made by the trees on their respective OOB instances:

$ upright("OOB Error") == 1 / n sum_(i == 1)^n bb(1) \[ upright("OOB")_i eq.not y_i \] $
#strong[Vantaggi:]

=== Explainability and interpretability metrics
<sub:rand-for-metrics-for-interpretability>
The use of plots and explainability oriented metrics can help to understand the behaviour of the ensamble, provinding a better insight on how the prediction are made.

==== Feature importance (Average impurity)
<sub:rand-for-feature-importance-average-impurity>
Random Forest provides a natural way to measure feature importance based on the reduction of impurity (Information Gain) across all trees. The importance of a feature is calculated as the average reduction in impurity that it provides when it is used for splitting, averaged over all trees in the forest:
$ upright("Importance")_j == 1 / T sum_(t == 1)^T sum_(upright("nodes in which the feature ") j upright("plits")) upright("IG")_(t \, upright("node")) $
Where $upright("IG")$ is the information gain (reduction in impurity) provided by the split on that feature at that node. This metric allows us to identify which features are most important for the predictions made by the Random Forest, and can be used for feature selection or for communicating the importance of features to non-experts, especially if visualized using bar plots.\

#figure(
        image("../../images/plots/feature-importance-impurity.png", alt: "Feature importance plot"),
        caption: "Feature importance plot of a random forest model."
      )


==== Feature Importance (Permutation-Based)
<sub:rand-for-feature-importance-permutation-based>
An alternative to the impurity based method is the permutation. The idea is to randomly permute the value of a feature in the test data, measuring the degradation in performance. If the performance degrades significantly, it means that the feature is important for the model.\

==== Partial Dependence Plot (PDP)
<sub:rand-for-partial-dependence-plot-pdp>
Shows the marginal effect of a feature on the predicted outcome, averaging out the effects of all other features. It helps to understand how the model's predictions change as a specific feature varies, while keeping other features constant.
Mostra come la previsione media varia al variare di una feature:

$ upright("PDP")_j \( x_j \) == 1 / n sum_(i == 1)^n hat(f) \( x_j \, x_(- j)^(\( i \)) \) $

Where $x_(- j)^(\( i \))$ are the values of the other features from instance $i$, keeping $x_j$ fixed.
Notice that if the features are correlated the effect could be misleading.

==== Individual Conditional Expectation (ICE) Plot
<sub:rand-for-individual-conditional-expectation-ice-plot>
ICE plot is a variant of PDP that shows the effect of a feature on the predicted outcome for individual instances, rather than averaging over all instances. It allows us to see how the prediction changes for each instance as the feature varies, which can reveal heterogeneity in the effect of the feature across different instances.\

=== Explainability limitations
<sub:rand-for-explainability-limitations-dec-tree>
For its ensamble nature, Random forest presents some limitations in terms of explainability, especially when compared to a single decision tree. The main issue is related to the path that leads to a specific prediction. In a single tree, it is straightforward to follow the path from the root to the leaf node that makes the prediction, understanding which features and thresholds were used at each split. In a Random Forest, there are multiple trees, and each tree may use different features and thresholds for splitting, making it difficult to trace a single path for a specific prediction.\ 
The problem is not only local, but also global, as the overall decision process is based on averaging the predictions, disrupting the interpretability of the model.\
This leads to a more opaque model, even if with higher performance. The feature importance can help to understand which features are generally important for the model, but it does not provide a clear explanation of how the features interact to produce a specific prediction and it can be misleading in case of correlated features. \
In summary, Random FOrest is yet another example of how the trade-off between performance and explainability is not always clear-cut, and it is important to consider the specific context and requirements of the problem when choosing a model.
