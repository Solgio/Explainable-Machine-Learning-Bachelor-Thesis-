#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side

== Support Vector Machine (SVM)
<support-vector-machine-svm>
=== Mathematical model
<sub:model-svm>
A Support Vector Machine is a classifier that finds the optimal hyperplane that separates two classes by maximizing the distance (@margin:short) between the hyperplane and the closest points of each class.\
In the case of bidimensional data, the hyperplane is a line; for three-dimensional data, it is a plane; for p-dimensional data, it is a hyperplane defined by:
$ beta_0 + beta_1 x_1 + beta_2 x_2 + dots.h + beta_p x_p = 0 $
Where $beta = \[ beta_1 \, . . . \, beta_p \]$ is the normal vector to the hyperplane, and $beta_0$ is the intercept.

==== Hard-Margin SVM (Linearly Separable Data)
<sub:hard-margin-svm>
In the ideal case in which the data are perfectly and #strong[completely separable], the goal is to find the coefficients $beta_0 \, beta_1 \, . . . \, beta_p$ that maximize the #gls("margin"). The intuition, is that a hyperplane with a large margin is more #strong[robust] to variations in the data and generalizes better to unseen data.
The separation condition is then the following: 

$ y_i \( beta_0 + beta_1 x_(i 1) + beta_2 x_(i 2) + dots.h + beta_p x_(i p) \) gt.eq 1 quad forall i $

Where $y_i in { - 1 \, + 1 }$ is the class label.

The distance between a point in the training set and the hyperplane is given by:
$ r_i = frac(y_i \( beta_0 + sum_(j = 1)^p beta_j x_(i j) \), \|\| beta \|\|) $

Where $\|\| beta \|\| = sqrt(sum_(j = 1)^p beta_j^2)$ is the
#strong[euclidean norm] of the coefficient vector.

To maximize the @margin, defined as the distance between the hyperplane and the closest points, we can express it as:
$ M = frac(1, \|\| beta \|\|) $
is equivalent to minimizing
$\|\| beta \|\|$. This formulation leads to the following optimization problem:
$ min_(beta \, beta_0) 1 / 2 \|\| beta \|\|^2 $

Under the constraint that:

$ y_i (beta_0 + sum_(j = 1)^p beta_j x_(i j)) gt.eq 1 quad forall i = 1 \, . . . \, n $



==== Soft-Margin SVM (Non Linearly Separable Data)
<soft-margin-svm>
In the realistic case where the data are #strong[not linearly separable], for the presence of noise, outliers, or overlapping classes, we allow some points to violate the margin. This can be achieved by intruducing #strong[slack variables] $xi_i gt.eq 0$ that measure how much a point violates the margin:
$ y_i (beta_0 + sum_(j = 1)^p beta_j x_(i j)) gt.eq 1 - xi_i quad forall i $

Once we allow violations, we need to penalize them in the objective function to prevent the model from simply classifying all points as the majority class. This leads to the following optimization problem:

$ min_(beta \, beta_0 \, xi) [1 / 2 \|\| beta \|\|^2 + C sum_(i = 1)^n xi_i] $

The objective function shows the importance of two components of the model. Firstly the distance of the hyperplane (first term) and secondly the violations of the margin (second term). The parameter $C$ is a #strong[hyperparameter of regularization] that controls the trade-off between maximizing the margin and minimizing the violations. A high value of the parameter $C$ will prioritize minimizing the violations, approching the hard-margin SVM and potentially leading to a higher overfitting. A low value of $C$ will prioritize maximizing the margin, allowing more violations.

==== Kernel SVM
<kernel-svm>
The main limitation of linear SVM is that it only works if the data are approximately linearly separable. 
For data with non-linear patterns, SVM uses the #strong[kernel trick].
The idea is to transform the data into a higher-dimensional space where the initially non linearly-separable data become linearly separable. \
Computing the transformation explicitly is computationally expensive. The #strong[kernel trick] allows us to do this implicitly.

Instead of calculating the transformation 
$phi.alt \( x_i \) = \[ f_1 \( x_i \) \, f_2 \( x_i \) \, . . . \, f_m \( x_i \) \]$
and then calculating the product scalar
$phi.alt \( x_i \)^T phi.alt \( x_j \)$, using a kernel function returns the same result directly from the original data:

$ K \( x_i \, x_j \) = phi.alt \( x_i \)^T phi.alt \( x_j \) $ without the need to explicitly calculate $phi.alt$.\

The most common kernerls are @svm-kernels: 

#strong[\1. Linear Kernel]

$ K \( x_i \, x_j \) = x_i^T x_j $
This is the default kernel and corresponds to the original linear SVM. It does not perform any transformation and is suitable for linearly separable data.

#strong[\2. Polinomial Kernel]

$ K \( x_i \, x_j \) = \( x_i^T x_j + 1 \)^d $
Transforms the data into a space of polynomials of degree $d$. Useful for polynomial patterns and especially precise in describing curved boundaries.

#strong[\3. RBF Kernel (Radial Basis Function - Gaussian)]

$ K \( x_i \, x_j \) = exp (- gamma \|\| x_i - x_j \|\|^2) $
Transforms the data into a space of infinite dimensionality. It is the #strong[most commonly used kernel] thanks to its flexibility which makes it suitable for describing complex patterns. Also has only a single hyperparameter $gamma$ (gamma) to tune, making it easy to use.\
This hyperparameter controls the influence of a single training example. The #strong[larger] the value of $gamma$, the #strong[closer] other examples must be to be affected, leading to a higher risk of overfitting. Conversely, a #strong[smaller] value of $gamma$ means that even points #strong[far] from the decision boundary can influence it. In this case, a too small value of $gamma$ can lead to underfitting, as the model may not capture the complexity of the data.

#strong[\4. Sigmoid Kernel]

$ K \( x_i \, x_j \) = tanh \( alpha x_i^T x_j + c \) $
The sigmoid kernel resembles the activation function of a neural network and can be used in datasets where the relationship between features is expected to be _"threshold-like"_ @sigmoid-kernel-medium, splitted in to hard decision regions. However, it is less commonly used than the RBF kernel and can be more difficult to tune but sometimes can be useful instead of using a full neural network.



=== Time complexity
<sub:time-complexity-svm>
The time complexity for SVM training is heavily dependent on the different variants of the algorithm and the size of the dataset. In general, the training time complexity is between $O \( n^2 p \)$ and $O \( n^3 p \)$, where $n$ is the number of training samples and $p$ is the number of features. This is because SVM training involves solving a quadratic optimization problem, which can be computationally expensive, especially for large datasets. To make up to the cost bottleneck of kernel use in SVM, various optimizations can be employed. Approximate kernel methods, such as the #gls("nystrom method") method or #gls("random fourier features"), can reduce the computational cost of kernel SVMs by approximating the kernel matrix by sampling a subset of the data or using random Fourier transformations. Additionally, #gls("sequential minimal optimization") breaks down the optimization problem into smaller subproblems that can be solved analytically. 
Even with this efficient optimization algorithms, using sophisticated kernels leads to higher computational costs, balancing the better predictive performances.\
On the other hand, linear SVMs with proper optimization, like #gls("linear programming") or #gls("stochastic gradient descent"), lowers its time complexity to $O \( n p \)$, where $p$ is the number of features. This makes linear SVMs more scalable for large datasets, but limited to linear patterns.\
For *inference*, the time complexity is again releted to the kernel function and the number of support vectors, which usually grows with the size of the training set. Generally it is between $O \( m p \)$ and $O \( m n \)$, where $m$ is the number of support vectors, while for linear SVMs the inference time complexity is $O \( p \)$, as the prediction is a simple dot product between the input features and the coefficients of the hyperplane.

=== Spatial complexity
<sub:spatial-complexity-svm>
For the memory complexity, the main bottleneck is the storage of the kernel matrix, which has a size of $O \( n^2 \)$, making it impractical for large datasets. For linear SVMs, the memory complexity is much lower, at $O \( p \)$, as it only needs to store the coefficients of the hyperplane. The number of support vectors also affects the memory complexity, as each support vector requires storing its corresponding coefficient and features. In general, the memory complexity can be between $O \( n^2 + m p \)$ and $O \( m p \)$, where $m$ is the number of support vectors.\ To mitigate the memory issues that for large datasets mean impracticality, the same approximations used for time complexity can be applied, reducing the complexity of the problem in more limited and manageable subproblems.

=== Internal representation
<sub:internal-representation-svm>
The model rappresents the solution as a #strong[linear combination of kernel products] of the form
$ f \( x \) = beta_0 + sum_(i = 1)^n alpha_i y_i K \( x \, x_i \) $
Where:
- $alpha_i$ are the dual coefficients (not directly the $beta_j$)
- Only a fraction of the training points have $alpha_i > 0$, these are the support vectors

For *interpretability*, this representation leads to a series of disadvantages. Firstly, it is not immediately clear why a particular point is a support vector, as it depends on the complex interactions of the data and the kernel. Secondly, for non-linear kernels, the transformation $phi.alt$ is implicit and not visualizable, making it difficult to understand how the model is making decisions. Lastly, the interpretation of $alpha_i$ is *not intuitive*, as it does not directly correspond to feature importance but rather to the influence of support vectors in the decision boundary. So, while SVM can be powerful for prediction, its internal representation poses significant challenges for interpretability. This is especially true for non-linear kernels, giving less insight into the decision-making process compared to more interpretable models like linear regression or decision trees.

=== Data assumptions
<sub:data-assumptions-svm>
As discussed, the different variants of SVM have different characteristics, which extends to data assumptions too. \
For the linear SVM, as the name suggests, the main assumption is that the data are approximately linearly separable by an hyperplane. If the assumption is not met, predictive performance decay significantly, and the model may not be able to capture the underlying patterns in the data.\
Some general assumptions do exists for both linear and kernel SVMs. These include:

+ #strong[Class balance:] SVM can be sensitive to imbalanced classes, as it focuses on maximizing the margin between classes. If one class is significantly more frequent than the other, the decision boundary may be biased towards the majority class.

+ #strong[Feature scaling:] SVM is sensitive to the scale of the features, as it relies on the distance between data points. If features are on different scales, the model may give more weight to those with larger ranges. Therefore, it is important to standardize or normalize the features before training an SVM.
No other structural assumption emerges from the mathematical formulation giving the SVM a certain flexibility in modeling different types of data, as long as the kernel is chosen appropriately to capture the underlying patterns. 

=== Predictive performance and limitations
<sub:predictive-performance-and-limitations-svm>
The SVM is a powerful and versatile algorithm that is able to achieve high predictive performance, especially when the data have non-linear patterns. The Soft-margin SVM decrese the impact of #gls("outlier", plural: true) and a higher number of features are an improvement over the linear models, which can easily overfit in these scenarios.\
However, in real-world application, with massive amount of data, the computational cost of training and inference for the kernel SVM can become prohibitive.
The ideal scenario of use is consequently for medium-sized datasets (up to tens of thousands of samples) with complex patterns that require non-linear modeling. For larger datasets, linear SVMs can be used, but they are limited to linear patterns and may not capture the complexity of the data, leading to lower predictive performance. Additionally, SVMs can be sensitive to the choice of hyperparameters which can further affect their performance. Finally, there is no direct probabilistic interpretation of the SVM outputs such as in logistic regression. \
Therefore, while SVMs can be powerful for prediction, they may not always be the best choice for every problem, especially when scalability and interpretability are important considerations.


=== Metrics for prediction quality
<sub:metrics-svm>
The following is a list of SVM specific metrics for evaluating the predictive performance of the model. For the general metrics see @cap:classification-metrics.
==== Distance from hyperplane
<sub:distance-hyperplane-svm>
This rappresent the most direct measurement of the confidence of the SVM prediction. The distance of a point $x_i$ from the hyperplane is given by:
$ d_i = y_i (beta_0 + sum_(j = 1)^p beta_j x_(i j)) $
To make this distance comparable across different models and datasets, it is common to normalize it by the norm of the coefficient vector $beta$:
$d_i = frac(d_i, \|\| beta \|\|) $

The closer the point is to the hyperplane (i.e., $d_i$ close to 0), the less confident the prediction is, while points far from the hyperplane (i.e., $d_i$ with large absolute value) are predicted with higher confidence.\

=== Explainability and interpretability metrics
<sub:metrics-for-interpretability-svm>
==== Platt Scaling
<sub:platt-scaling-svm>
Out of the box SVM does not produce a measure of the uncertainty of its predictions, as it outputs a hard classification (+1 or -1) rather than a probability. To obtain estimates of the probability $P \( y = 1 \| x \)$, a common approach is to use #strong[Platt scaling], which fits a logistic regression model to the SVM outputs (the distances from the hyperplane) on a validation set. The formula for Platt scaling is:
$ P \( y = 1 \) = frac(1, 1 + exp \( A dot.op d + B \)) $

Where $A \, B$ are parameters learned on a validation set, calibrating the distance of the hyperplane to probabilities.
Although Platt scaling can provide a way to obtain probabilistic outputs from SVMs, it is important to note that the probabilities obtained through this method may not be well-calibrated, especially if the validation set used for calibration is not representative of the test set. Therefore, while Platt scaling can be useful for certain applications, it should be used with caution and its outputs should be interpreted carefully.

==== Support vectors and their weights ($alpha_i$)
<sub:support-vectors-weights-svm>
Analysing the support vectors and their corresponding coefficients $alpha_i$ can provide insights into the decision-making process of the SVM. Support vectors are the data points that lie closest to the decision boundary and have a direct influence on its position. 
$ f \( x \) = beta_0 + sum_(i = 1)^n alpha_i y_i K \( x \, x_i \) $
The weights $alpha_i$ associated with these support vectors indicate their importance in determining the decision boundary, the higher the value of $alpha_i$, the more influence the corresponding support vector has on the decision boundary. In kernel based SVMs, their interpretation is less intuitive.

==== Feature importance
<sub:feature-importance-svm>
To assess the importance of individual features in the SVM model, we can use techniques that are model-agnostic, as SHAP values, since the SVM does not provide feature importance scores directly. The main idea is to measure how the model\'s predictions change when we perturb or remove a feature, which can give us insights into the importance of that feature for the model\'s decision-making process.

==== Decision boundary visualization
<sub:decision-boundary-visualization-svm>
For low-dimensional datasets (2D or 3D), visualizing the decision boundary can provide insights into how the SVM is separating the classes. This can be done by plotting the training points, the decision boundary (the hyperplane), and the margin (the area around the hyperplane where support vectors lie). Support vectors can be highlighted to show their influence on the decision boundary. \
For higher dimensional datasets, techniques like #gls("pca") can be used to reduce the dimensionality and visualize the decision boundary in a lower-dimensional space, although this may not capture all the complexities of the original feature space.

=== Interpretability and explainability limitations
<sub:explainability-limitations-svm>
SVM as a model has several limitations in terms of interpretability, which can make it challenging to understand the decisions made by the model. These limitations are particularly pronounced when using non-linear kernels, which transform the data into a higher-dimensional space where the decision boundary is not easily visualizable. The interpretation of the weights $alpha_i$ of the support vectors is *not straightforward*, as they do not directly correspond to feature importance but rather to the influence of the support vectors on the decision boundary.\\ Additionally, there is no natural way to assess feature importance directly nor to trace the reasoning process of the model, as the decision boundary is determined by a complex combination of support vectors and their corresponding weights, which can be difficult to communicate and understand, especially for non-experts. \ Therefore, while SVM can be powerful for prediction, its interpretability limitations should be carefully considered when choosing it for a particular application, especially when interpretability is a key requirement.
