#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side

== XGBoost: Extreme Gradient Boosting
<xgboost-extreme-gradient-boosting>

=== Mathematical model
<sub:xgboost-model>
The Extreme Gradient Boosting (XGBoost) is a ensemble method that uses the boosting technique to combine the predictions of multiple decision trees. The main idea behind XGBoost is that it builds trees sequentially, training each new tree to correct the errors made by the previous trees. \
The resulting prediction is formulated as:

$ hat(y)_i^(\( t \)) = hat(y)_i^(\( t - 1 \)) + f_t \( x_i \) $

Where $hat(y)_i^(\( t \))$ is the prediction for instance i after $t-1$ trees and $f_t \( x_i \)$ is the new tree that predicts the residuals of the previous iteration. \
The global @objective_function is defined as:
$ L \( phi.alt \) = sum_(i == 1)^n l \( hat(y)_i \, y_i \) + sum_(k == 1)^T Omega \( f_k \) $
Where the first term is the loss function that measures the error between the predicted and true values, and the second term is a regularization term that penalizes the complexity of the ensemble of trees. The regularization is needed to prevent overfitting of the model and it is defined as:
$ Omega \( f \) = gamma T + 1 / 2 lambda \|\| w \|\|^2 $ penalizing both the number of leaves ($T$) and the leaf weight magnitude($w$) using $gamma$ and $lambda$ respectively.

Considering the step $t$, the model is trained to minimize the following objective function:
$ L^(\( t \)) = sum_(i == 1)^n l \( y_i \, hat(y)_i^(\( t - 1 \)) + f_t \( x_i \) \) + Omega \( f_t \) $
This formulation is approximated using a #strong[second order Taylor expansion], resulting in a more efficient optimization process that considers both the first and second derivatives of the loss function. This also allows XGBoost to use a wider range of loss functions with the constraint of being twice differentiable.
$ L^(\( t \)) approx sum_(i == 1)^n [g_i f_t \( x_i \) + 1 / 2 h_i f_t^2 \( x_i \)] + gamma T+1/2 lambda sum_(j=1)^T \|\| w_j \|\|^2 $
As said before, the gradients are defined as:
- $g_i = frac(partial l, partial hat(y)^(\( t - 1 \))) l \( y_i \, hat(y)^(\( t - 1 \)) \)$
  as first-order gradient
- $h_i = frac(partial^2, partial^2 hat(y)^(\( t - 1 \))) l \( y_i \, hat(y)^(\( t - 1 \)) \)$
  as second-order gradient

For the creation of the trees, XGBoost uses a greedy algorithm that iteratively splits the data based on the feature that provides the best improvement in the objective function. The quality of a split is measured by the following score:
$ upright("Score") \( q \) = - 1 / 2 sum_(j == 1)^T frac(\( sum_(i in I_j) g_i \)^2, sum_(i in I_j) h_i + lambda) + gamma T $
Where $I_j$ is the set of instances in leaf $j$. This score measures how good a tree structure is, with more negative values indicating better trees.

=== Time complexity
<sub:xgboost-time-complexity>
The time complexity for the greedy algorithm directly depends on the number of trees ($T$), the depth of the trees ($d$) and the number of observations ($n$). The exact greedy algorithm has a time complexity of:
$ O \( T dot.op d dot.op n dot.op f log \( n \) \) $
Using on block structure, moving the sorting outside the tree construction without re-sorting at each iteration, the time complexity is reduced to:
$ O \( n dot.op f log \( n \) \) + O\( T dot.op d dot.op n dot.op f \)$ Where the first term is the cost of the initial sorting and the second term is the cost of building $T$ trees with depth $d$. \
In reality, the $n dot.op f$ in often reduced to the only data entries with non-missing entries thanks to the sparsity-aware algorithm, resulting in a significant speedup for sparse datasets that amounts to 50 times@xgboost.

For *inference*, the algorithm needs to traverse $T$ trees sequentially, following the path from the root to the leaf for each tree. The time complexity is therfore $ O \( T dot.op d \) $\


=== Spatial complexity
<sub:xgboost-spatial-complexity>
The total spatial complexity of XGBoost is the sum of the space needed to store the model (the ensemble of trees) and the space needed to store the data during training. The spatial complexity for storing $T$ trees with depth $d$ is:
$ O \( T dot.op 2^d + m dot.op n \) $\
If block structure is used, the spatial complexity should consider the additional space required to store the indexes for the columns. This results in a used of double space for the data, which does not effect $"Big" O$ notation but can be significant in practice. \

=== Internal representation
<sub:xgboost-internal-representation>
Beeing a tree based model, XGBoost internally represents the model similarly to a random forest, as a collection of decision trees. 

```
Ensemble == [Tree_1, Tree_2, ..., Tree_T]

Previsione == Σₖ f_k(x)
```
For every tree , XGBoost stores the structure of the tree (which feature is used for split, the threshold, and the default direction for missing values), the weights (the prediction value for each leaf) and the gradients (the accumulated gradients for each leaf during training). \
For *interpretability*, even if the number of trees is typically smaller than in Random Forest (100-500 vs 500-2000), the internal representation is still complex and not easily interpretable. The sequential nature of the trees also makes it difficult to trace which tree is responsible for a specific prediction, posing challenges for local explainability. \

=== Data assumptions
<sub:xgboost-data-assumptions>
The main assumption of the XGBoost is that the data are divided homogeneously in the classes. If this is not the case, the model would not be able to learn meaningful patterns for the minority class, resulting in poor performance. To address this issue, XGBoost provides a parameter called `scale_pos_weight` that allows to assign a higher weight to the minority class during training. \
XGBoost even handles missing values and sparse data natively, making it robust to real-world datasets that often contain missing or incomplete information. \

=== Predictive performance and limitations
<sub:xgboost-predictive-performance-and-limitations>
XGBoost is known for its excellent predictive performance, often outperforming other machine learning algorithms in various tasks. Other advantages include the robustness to missing values, the ability to handle non-linear relationships and interactions between features, and the incorporation of regularization techniques that help prevent overfitting. Its mathematical foundation provides a way to use custom loss functions in case of special necessities. \
However, it is not without limitations. The model can be sensitive to hyperparameter tuning, and it may struggle with extrapolation beyond the range of the training data. Additionally, while XGBoost can handle non-linear relationships and interactions between features, it may not perform as well on datasets with a high noise-to-signal ratio or when the underlying relationship is primarily linear. Finally, his sequential makes it more computationally expensive especially during training as it cannot be parallelized. \ 
Nontheless, XGBoost remains a very powerful algorithm, especially if paired with a careful hyperparameter tuning for example using Optuna (@sec:optuna).

=== Metrics for prediction quality
<sub:xgboost-metrics>
To evaluate the predictive performance of XGBoost, we can use both general metrics for classification and regression, as well as specific metrics. For the common metrics, see @cap:classification-metrics(Classification) and @cap:regression-metrics(Regression).\

==== Sigmoid transformation for probabilities
<sub:xgboost-probabilities>
To obtain a calibrated probability from the margin score (the raw output of the model), we can apply the sigmoid function:
$ P \( y == 1 \| x \) = frac(1, 1 + exp \( - upright("margin") \)) $
Even if the margin score is not a true probability, this transformation allows us to interpret it as such, which can be useful for decision-making processes that require probabilities.

=== Explainability and interpretability metrics
<sub:xgboost-metrics-for-interpretability>
XGBoost's intrinsic interpretability is limited, but there are some metrics that can be used to understand the importance of features (interpretability) and the contribution of each tree to predictions (explainability).

==== Feature Importance (Gain-Based)
<sub:xgboost-feature-importance-gain-based>
Measures the average loss reduction due to each feature:
$ upright("Importance")_j = 1 / T sum_(k == 1)^T upright("Gain")_j^(\( k \)) $
Where $ upright("Gain")_j^(\( k \)) $ is the total loss reduction when feature $j$ splits the tree $k$.
A feature with an higher gain is considered more important but is important to note that gain measure could be biased towards features with high cardinality. \

==== Feature Importance (Split-Based)
<sub:xgboost-feature-importance-split-based>
Counts how many times a feature is considered for a split:
$ upright("Cover")_j = 1 / T sum_(k == 1)^T upright("# splits on feature ") j $

==== Partial Dependence Plot (PDP)
<sub:xgboost-partial-dependence-plot-pdp>
Shows how the predicted outcome changes as a single feature varies, while averaging out the effects of other features:
$ upright("PDP")_j \( x_j \) = 1 / n sum_(i == 1)^n hat(f) \( x_j \, x_(- j)^(\( i \)) \) $
The presence of particular patterns such as curves or monotonic lines shows the existence of interactions between the chosen feature and the outcome. If a flat line is observed, it suggests that the feature has little impact on the prediction. \

==== Tree Visualization
<sub:xgboost-tree-visualization>
It's possible to visualize individual trees in the ensemble, but the interpretability is limited. The scale for XGBoost is typically 100-500 trees, and visualizing all of them is impractical. Even visualizing a single tree can be complex due to the depth and number of splits, making it difficult to extract meaningful insights from the structure. \

=== Interpretability and explainability limitations
<sub:xgboost-explainability-limitations>
As other ensemble methods, XGBoost trades off interpretability for predictive performance. The main limitations are due to the sequential nature of the trees. A single tree cannot fully explain the prediction, and it is difficult to trace the reasoning process step by step. Even if the basic concept is easy to grasp, it is difficult to understand its application. \
Additionally, the feature importance metrics can give different rankings depending on the method used (gain, cover, frequency), and there is no single universally "correct" way to interpret them but are context-dependent. Feature impoortance also suffers from instability for a variaty of reasons. Firstly, correlated features can be selected alternatively and changes in data can affect the corresponding importance scores.\
Finally, while #gls("shap") values can provide insights into feature contributions, they are computationally expensive to calculate, especially for large datasets with many features. \
To summarize, while XGBoost provides some tools for explainability, it is not designed to be an interpretable model, and its complexity can make it challenging to understand the underlying decision-making process.

