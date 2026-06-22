#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side

== Decision Tree
<cap:decision-tree>
=== Mathematical model
<sub:dec-tree-model>
A decision tree is a model that recursively splits the data space into rectangular regions, creating a #strong[hierarchical structure of decision nodes].
The resulting tree is built using a greedy top-down approach, where at each node the best feature and threshold are chosen to maximize the purity of the resulting child nodes (for classification) or minimize the variance (for regression). \ 
The final predictions are made by traversing the tree from the root to a leaf, following the decision rules at each node. The leaf reached determines the predicted class (classification) or the predicted value (regression) while the internal nodes represent the decision rules based on feature thresholds.\

==== Splitting criteria
<sub:dec-tree-criteri-split>
A multitude of splitting criteria exist, the following are the most common, for a more complete list see @data_mining_with_decision_trees, @decomposition-knowledge-detection. These criteria are usually based on measures of impurity, measuring how mixed the classes are in a node. The goal is to find splits that create child nodes that are more pure than the parent node.

1. #strong[Gini Index (Classification):]
<sub:dec-tree-gini-index>
Measures based on #strong[impurity] for classification problems: 

$ upright("Gini") \( D \) = 1 - sum_(i = 1)^K p_i^2 $
Where $p_i$ is the proportion of instances belonging to class $i$ in the node. $K$ is the total number of classes.
A Gini index of 0 means that all instances in the node belong to the same class (pure node). A Gini index equal to $1 - 1/K$ means that the instances are uniformly distributed among the classes (completely impure node). For binary classification ($K=2$), the maximum Gini index is 0.5 when the classes are perfectly balanced.\
To measure the #strong[Gini Gain] of a split, we calculate the weighted average reduction in Gini impurity:

$ upright("IG") = upright("Gini") \( upright("parent") \) - sum_(upright("son")) frac(\| D_(upright("son")) \|, \| D \|) upright("Gini") \( upright("son") \) $

2. #strong[Entropy (Classification):]
<sub:dec-tree-entropy>
Another measure of impurity for classification problems, based on the concept of entropy from information theory:

$ upright("Entropy") \( D \) = - sum_(i = 1)^K p_i log_2 \( p_i \) $
The closer the entropy is to 0, the purer the node. The maximum entropy occurs when the classes are perfectly balanced, which is $log_2 \( K \)$ for $K$ classes. For binary classification ($K=2$), the maximum entropy is 1 when the classes are perfectly balanced.\
From the entropy we can derive the #strong[Information Gain] of a split, which measures how much the entropy is reduced by the split similarly to Gini Gain:

$ upright("IG") = upright("Entropy") \( upright("parent") \) - sum_(upright("son")) frac(\| D_(upright("son")) \|, \| D \|) upright("Entropy") \( upright("son") \) $

The measures Gini and Entropy often lead to similar splits, but Gini is computationally faster, which is why it is more commonly used in practice.

==== Mean Squared Error (MSE) (Regression):
<sub:dec-tree-mean-squared-error-mse>
Measures based on #strong[variance] for regression problems. The goal is to find splits that minimize the variance of the target variable in the child nodes. The MSE of a node is calculated as:
$ upright("MSE") \( D \) = frac(1, \| D \|) sum_(i = 1)^(\| D \|) \( y_i - macron(y) \)^2 $

Where $macron(y) = frac(1, \| D \|) sum_(i = 1)^(\| D \|) y_i$ is the mean of the target variable in the node.

=== Time complexity
<sub:dec-tree-time-complexity>
The time complexity of the decision tree is bounded by the process of evaluating the best split at each node, which involves scanning through the data and calculating the splitting criterion for each feature.
$ O \( n^2 dot.op p dot.op log \( n \) \) $
Where $n$ is the number of observations and $p$ the number of features.\
In fact, sorting the data for each feature takes $O \( n log \( n \) \)$, and this process is repeated for each of the $p$ features at each level of the tree. If the tree is grown to every leaf (no pruning), the number of nodes is in order of $O \( n \)$, giving the final complexity. The quadratic term in the worst case can represent a bottleneck for large datasets, especially when the tree is allowed to grow deep and capture noise in the data. In this case, gradient-based tree algorithms (@xgboost-extreme-gradient-boosting) could be preferred, not only for their better time complexity but also for their improved predictive performance and regularization capabilities.\
On the other side, as descibed in the official Scikit-learn documentation @scikit-docs, the time complexity can the optimize to $O \( n dot.op p dot.op log \( n \) \)$ thanks to clever tracking of the general order of indices of the features, allowing to avoid sorting at each node. A feature level parallelization can be achieved by evaluating the splits to additionally improve performance.\
For *inference*, the time complexity is dependent on the depth of the tree, which in the worst case can be $O \( n \)$ (degenerate tree) and in the best case $O \( log \( n \) \)$ (balanced tree).\

=== Spatial complexity
<sub:dec-tree-spatial-complexity>
The spatial complexity is determined by the need to store the tree structure and the metrics for the evaluation of the splits. The spatial complexity is consequently $O\(n dot.op p \)$ during training but drops to $O\(n \)$ during inference as we only need to store the tree structure and the thresholds for the splits, which is proportional to the number of nodes in the tree.

=== Internal representation
<sub:dec-tree-internal-representation>
A decision tree is represented internally as a recursive tree structure, as suggested by the name. Each node:

```
Node(feature=x1, threshold=5.5, left=Node(...), right=Node(...))
```
contains the feature used for splitting, the threshold value for the split and the reference to the left and right child nodes while a leaf only contains the predicted class or value and the number of samples in that leaf.\
This structure not only allows for efficient traversal during inference but for *explainability*, provides a clear and interpretable representation of the decision-making process. Each path from the root to a leaf corresponds to a specific set of conditions on the features.\
Still, with deep trees, understanding the global structure can become difficult, even if the local decision paths remain interpretable.\
An advantage of the decision tree structure is the natural handling of #gls("categorical_features") without need for encoding.


=== Data assumptions
<sub:dec-tree-data-assumptions>
The only assumption of decision trees is that the data can be split based on feature thresholds to create *homogeneous* groups. Unbalanced classes can affect the predictive performance regarding the minority class in favour of a deep tree for the majoritary class.\
This is a very weak assumption compared to linear models, which require linearity, normality, homoscedasticity, and independence of features. However, it not always possible to satisfy it and sometimes resampling or proportional weighting is needed to address it. Similarly to linear models, decision trees can be affected by multicollinearity, as they tend to prefer one feature over another when they are highly correlated, which can lead to instability in the tree structure and potentially affect the interpretability of the model.\

=== Predictive performance and limitations
<sub:dec-tree-predictive-performance-and-limitations>
Decision trees are powerful models in context of classification, especially when the relationship between features and target is complex and non-linear, for example in a context with multiple #gls("categorical_features"). Feature interactions are naturally captured by the tree structure without explicitly modeling them. As said previously, decision trees can handle #gls("categorical_features") without the need for encoding, which can be a significant advantage in many real-world datasets. Moreover, they do not require any assumptions about the distribution of the data or the linearity of relationships between features and target variable, making them versatile for a wide range of problems.\ All there advantages lead to a model that can capture automatically complex patterns in a vast variety of datasets.\
On the contrary, decision trees can be inaccurate on purely linear data, where a simple linear model would achieve better performance. In general, decision tree regressors tend to be inaccurate as they approximate the target variable with piecewise constant predictions, which can lead to high bias. \
Decision trees are even prone to overfitting, especially when the tree is allowed to grow deep and capture noise in the training data and in high dimensionalities. This can lead to poor generalization performance on unseen data.\
In addition, they can also be biased towards features with more levels, which can lead to misleading interpretations of feature importance.\
Finally, decision trees can be unstable, meaning that small changes in the training data can lead to significantly different tree structures and predictions. This is because the tree-building process is greedy and makes locally optimal decisions at each node, which can be sensitive to variations in the data.

=== Metrics for prediction quality
<sub:dec-tree-metrics>
To evaluate the predictive performance of decision trees, we can use both general metrics for classification and regression, as well as specific metrics that take advantage of the tree structure. For the common metrics, see @cap:classification-metrics(Classification) and @cap:regression-metrics(Regression).\

==== Confidence score or Probability on the leaf
<sub:dec-tree-confidence-score>
To estimate the confidence of a prediction, we can use the distribution of classes in the leaf node reached by the instance. The confidence score for a predicted class can be calculated as the proportion of instances of that class in the leaf compared to the total number of instances in that leaf:

$ upright("Confidence") = frac(\# upright("instances of the predicted class in the leaf"), \# upright("total instances in the leaf")) $

This metric could be used to filter predictions based on the level of confidence, for example by accepting only predictions with a confidence score above a certain threshold (e.g., 0.8). This can be particularly useful in applications where the cost of false positives or false negatives is high, allowing us to focus on predictions that the model is more certain about.

=== Explainability and interpretability metrics
<sub:dec-tree-metrics-for-interpretability>
Visualize via plots and feature importance can improve the interpretability of decision trees. The following plots and metrics are specifically chosen to extrapolate insights from the decision trees and to understand the decision-making process of the model, rather than just evaluating its predictive performance.

==== Tree visualization
<sub:dec-tree-tree-visualization>
The first and most intuitive way to understand a decision tree is to visualize it. The node show the feature and its threshold while the leafs show the predicted class. This way it is easily traceable the decision path and which features are the most important, dividing, features. 
#figure(
  image("../../images/plots/tree-structure.png", alt: "Visualization of a decision tree with the feature and threshold for each node and the predicted class for each leaf"),
  caption: "Visualization of a decision tree."
)

For deep trees, the complete visualization can become cluttered and difficult to interpret. In such cases it can still be useful to visualize only the top levels of the tree, which capture the most important splits.

==== Feature importance
<sub:dec-tree-feature-importance>
Measures how often a feature is used as a splitting criterion and how much it reduces the average impurity:

$ upright("Importance")_j = frac(sum_(upright("nodes with feature ") j) \( upright("IG")_(upright("node")) \) times \( upright("n nodes") \) \/ n, upright("sum of all the nodes")) $
The more a feature is used for splitting and the more it reduces impurity, the higher its importance score. This metric can help to identify not only which features are most influential in the model, but also to understand the relative importance of different features in the decision-making process of the tree. In fact, the most dividing features would appear at the top and could be identified easily with other methods, but the feature importance metric allows to identify also less important features that are used for splitting in deeper levels of the tree and that have been used frequently.

==== Path to prediction 
<sub:dec-tree-path-to-prediction>
For a single instance is possible to trace the complete path from root to leaf and list all the comparisons (feature \<= threshold) that led to the prediction. This is a #strong[huge advantage for explainability] compared to @black_box models. Every prediction is completely traceable locally.\
```
Instance: (x1=3.2, x2=1.5, x3=A)

Path to prediction:
- Node 1: x1 <= 5.5 (True)
- Node 2: x2 <= 2.0 (True)
- Node 3: x3 == B (False)
- Node 4: x3 == A (True)

Prediction: Class 1 (Confidence: 0.8)
```
This is especially useful in contexts where understanding the reasoning behind a specific prediction is crucial, such as in medical diagnosis or credit scoring. By examining the path to prediction, we can identify which features and thresholds were most influential in the decision-making process for that particular instance, providing insights into the model's behavior and potentially uncovering any biases or issues in the data.


=== Explainability limitations
<sub:dec-tree-explainability-limitations-dec-tree>
The decision trees are generally considered interpretable models, but they have some limitations in terms of explainability too. \ 
One of the main limitations is that as the tree grows deeper and more *complex*, it can become difficult to understand the global structure of the model and how different features interact with each other across the entire tree. While it is possible to trace the decision path for a single instance, understanding the overall reasoning process of the model can be challenging when there are many nodes and interactions between features. \
In the context of correlated features, decision trees can mask the importance of one feature in favor of another, losing valuable insights about the data.
Finally for regression tasks, the piecewise constant predictions can make it difficult to understand the relationship between features and the target variable, especially when the tree is deep and captures complex interactions.\
Even with these limitations decision trees still remain _white boxes_ and of easy understanding. 
