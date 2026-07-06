#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side

== Linear regression
<cap:linear-regression>

=== Mathematical model
<sub:model-lr>
The linear regression model is the simplest form of regression. It assumes a linear relationship between the input features and target variable. The mathematical representation of the linear regression model is:
$ y = beta_0 + sum_(j = 1)^p beta_j x_j $
Where $p$ is the number of features, $beta$ are the calculated weights for each of the features, and $y$ is the target variable.\
The goal of the linear regression is to find the optimal weights $beta$ that minimize the error between the predicted values and the actual target variable. This is typically done by minimizing the ordinary least squares loss function between the predicted values and the actual target variable. The optimization problem can be formulated as:
$ hat(beta) = "argmin"_(beta_0 . . . beta_p) sum_(i = 1)^n \( y^(\( i \)) - \( beta_0 + sum_(j = 1)^p beta_j x_j^(\( i \)) \) \)^2 $

=== Time complexity
<sub:time-complexity-lr>
There are two main approaches to solving this optimization problem: the analytical solution and iterative optimization methods (e.g., #gls("gradient descent")). The analytical solution is given by the normal equation:

$ hat(beta) = \( X^T X \)^(- 1) X^T y $

$X$ is an $n dot.op p$ matrix, where $n$ is the number of instances and $p$ is the number of features. The matrix $X$ is augmented with a column of 1s to account for the intercept term $beta_0$. The #gls("computational_complexity") of the analytical solution is dominated by matrix multiplication and inversion operations. In fact, the cost of multiplying the matrices is $O \( p^2 n \)$ and the cost of inverting the $p x p$ matrix is $O \( p^3 \)$. Therefore, the overall #gls("computational_complexity") of the analytical solution is $O \( p^2 n + p^3 \)$, which becomes prohibitive for vast datasets (e.g., over 10,000 records).\
The iterative methods, such as #gls("gradient descent"), calculate the gradient of the loss function with respect to the weights and update the weights iteratively until convergence. The #gls("computational_complexity") of the gradient calculation is $O \( p n \)$ per iteration, and the number of iterations required for convergence can vary depending on the learning rate and the specific dataset. However, in practice, iterative methods can be more efficient than the analytical solution for large datasets, as they do not require matrix inversion and can converge faster with appropriate hyperparameter tuning. Other methods like #gls("stochastic gradient descent") can further reduce the computational cost by approximating the gradient using a subset of the data at each iteration.\
On the other hand, for smaller datasets, the analytical solution offers convergence in a single step, without the need for hyperparameter tuning, and guarantees a globally optimal solution.

For *inference*, the time complexity is $O \( p \)$ per instance, as it involves a simple dot product between the feature vector and the weight vector.

=== Spatial complexity
<sub:spatial-complexity-lr>
The spatial complexity of the linear regression model is determined by the need to store the input data, the weight vector, and any intermediate matrices used in the analytical solution. Specifically, the analytical solution requires storing the $n dot.op p$ matrix $X$, the $p dot.op p$ matrix $X^T X$, and the $p$-dimensional weight vector $beta$. Therefore, the overall spatial complexity of the linear regression model is dominated by the storage of the input data and the intermediate matrices, resulting in a spatial complexity of $O \( n p + p^2 \)$.\
For the #gls("gradient descent") method, the spatial complexity is reduced to $O \( n p + p \)$, as it does not require storing the intermediate matrix $X^T X$.\
For *inference*, the spatial complexity is $O \( p \)$ per instance, as it only stores the weight vector and the feature vector.

=== Internal representation
<sub:internal-representation-lr>
Linear regression represents the resulting weight of the features as a vector of weights, $beta = \[ beta_0 \, beta_1 \, . . . \, beta_p \]$. \
Specific encoding is needed for #gls("categorical_features"), which are typically handled through one-hot encoding, where each category is represented as a binary feature. This can lead to an increase in the number of features and potential multicollinearity issues if not handled properly.\
In regard of #strong[interpretability], the internal representation of linear regression is straightforward and transparent, which makes it one of the most interpretable machine learning models. The weights directly indicate the strength and direction of the relationship between each feature and the target variable. This allows for a clear understanding of how each feature contributes to the prediction, making it easier to communicate insights to stakeholders and identify important predictors in the data.

=== Data assumptions
<sub:data-assumptions-lr>
As described by Molnar @interpretability_book, linear regression relies on several key assumptions about the data to ensure model validity and the reliability of its predictions:

+ #strong[Linear constraints:] the relationships between features and the target variable must be linear. Non-linear relationships must be manually modeled and cannot be captured automatically.

+ #strong[Residuals normality:] the residuals $epsilon.alt_i = y_i - hat(y)_i$ must follow a normal distribution. Major violations compromise statistical inference.

+ #strong[Homoscedasticity:] residuals must have a constant variance across all levels of the features. In practice, this assumption is frequently violated. For example, in real estate, the price of very large houses is extremely variable, whereas the price of small houses is highly concentrated.

+ #strong[Independence of measurements:] observations should not be correlated. Dependent data, such as time series, violate this assumption and should not be investigated using simple linear regression.

+ #strong[Fixed Features:] features should be fixed and measured without error. In practice, this assumption is often violated because features can be subject to measurement errors or can change over time, leading to biased estimates of the coefficients and reduced predictive performance (attenuation bias).

+ #strong[Absence of multicollinearity:] features should not be highly correlated. Multicollinearity causes numerical instability during the inversion of $X^T X$ and inflates the absolute value of weights. When using #gls("gradient descent"), it changes the geometric properties of the loss function, creating narrow valleys that require a significant reduction in the learning rate. 

==== Preprocessing
<sub:preprocessing-lr>
The data assumptions lead to specific preprocessing steps to determine the suitability of the data for linear regression and to improve the performance of the model. These steps include:
+ #strong[Multicollinearity identification:] calculation of the @corr_matrix:long between features using the Pearson's coefficient or VIF (Variance Inflation Factor) to identify highly correlated features.
 $ "VIF"_j = frac(1, 1 - R_j^2)$
Where $R_j^2$ is the coefficient of determination for the regression of feature $j$ against all other features. More on $R_j^2$ #link(<sub:r-square-coefficient-lr>)[here].

=== Predictive performance and limitations
<sub:predictive-performance-and-limitations-lr>
As discussed, linear regression imposes several constraints on the data and model performance. Excellent performance, in terms of both accuracy and efficiency, is achieved when linear relationships exist between the features and the target variable. \
However, in real-world scenarios, these conditions are often violated, leading to poor predictive performance. The model is particularly sensitive to #gls("outlier", plural:true), which can disproportionately influence the weights and lead to skewed predictions. Additionally, linear regression is *unsuitable for capturing complex, non-linear relationships* in the data, limiting its applicability in many real-world problems where such relationships are common. Finally, the model's performance can degrade significantly when the number of features is large relative to the number of observations, leading to overfitting and poor generalization to new data. This limitation is intensified by the presence of @categorical_features.

=== Metrics for prediction quality
<sub:metrics-lr>
What follows is a list of the most relevant metrics for evaluating the predictive performance of linear regression models, based on the task and the data assumptions.
For the general metrics see @cap:regression-metrics.

==== Feature Importance (t-statistic)
<sub:feature-importance-t-statistic-lr>
$ t_(hat(beta)_j)$ measures the statistical significance of each coefficient, calculated as the weight divided by its standard error:

$ t_(hat(beta)_j) = frac(hat(beta)_j, S E \( hat(beta)_j \)) $

Intuitively, a higher absolute value of the t-statistic indicates a more statistically significant feature. \
Similarly, the higher the variance of the coefficient estimate, the less statistically significant the feature is, as the model is more uncertain about the true value of the coefficient. \

==== p-value
<sub:p-value-lr>
$"p-value"$ is a measure of the probability of _"obtaining the observed data under the null hypothesis of a statistical test"_@p-value. In the context of linear regression, the null hypothesis is that the true coefficient $beta_j$ is equal to zero, meaning that the feature does not have a significant impact on the target variable. The p-value for each coefficient is calculated based on the t-statistic and indicates the probability of observing such an extreme value for $t_(hat(beta)_j)$ if the null hypothesis were true. A common convention is to consider a p-value less than 0.05 as statistically significant, suggesting that there is strong evidence against the null hypothesis and that the feature likely has a meaningful relationship with the target variable.

==== Mallows' Cp
<sub:mallows-cp-lr>
Mallows' Cp is a model selection metric that balances model fit and complexity, calculated as:

$ C p = frac(S S E, hat(sigma)^2) - n + 2 p $

Where $hat(sigma)^2$ is the estimate of the residual variance of the complete model. It is used to mitigate the problem of overfitting by penalizing the addition of unnecessary features.

=== Diagnostic plots
<sub:diagnostic-plots-lr>
The use of diagnostic plots is crucial to visually assess the assumptions of linear regression and to identify potential issues with the model fit.
==== Actual vs Predicted
<sub:actual-vs-predicted-lr>
Scatter plot with actual values $y_i$ on the $y$-axis and predicted values $hat(y)_i$ on the $x$-axis.
If the model fits well, the points should be concentrated around the diagonal line $y = hat(y)$. Deviations from this pattern can indicate various issues with the model fit. 

==== Histogram of residuals distribution
<sub:histogram-of-residuals-lr>
#side_by_side([
      Distribution of the residuals $epsilon.alt_i = y_i - hat(y)_i$.
      It is especially useful to identify violations of the normality assumption. A normal distribution of residuals is expected for valid inference, and deviations from this pattern can indicate issues with the model fit or the presence of outliers.],[
      #figure(
        image("../../images/plots/distribution_plot.png", alt: "Histogram of residuals distribution"),
        caption: "Histogram of residuals distribution example for linear regression."
      )
    ], proportions: (40%, 60%)
)

==== Q-Q Plot (Quantile-Quantile)
<sub:q-q-plot-quantile-quantile-lr>
#side_by_side([
      #figure(
        image("../../images/plots/q-qplot.png", alt: "Q-Q Plot"),
        caption: "Q-Q Plot of residuals example for linear regression."
      )
],[
  Another way to check the normality of residuals is through a Q-Q plot, which compares the quantiles of the residuals to the quantiles of a normal distribution. If the residuals are normally distributed, the points in the Q-Q plot should approximately follow a straight line. Deviations from this line, especially at the tails, can indicate non-normality of the residuals, which may affect the validity of statistical inference based on the model.
], proportions: (60%, 40%)
)

==== Residuals vs Fitted Values
<residuals-vs-fitted-values>
Scatter plot with fitted values $hat(y)_i$ on the $x$-axis and residuals $epsilon.alt_i = y_i - hat(y)_i$ on the $y$-axis. \
If the model fits well, the points should be randomly scattered around the horizontal line $epsilon.alt = 0$ without displaying any systematic pattern. This plot is used to identify violations of regression assumptions (@sub:data-assumptions-lr). For example, increasing dispersion (forming a funnel shape) shows heteroscedasticity, while systematic patterns (e.g., a curve) indicate non-linearity that the model cannot capture.

=== Explainability and interpretability metrics
<sub:metrics-for-interpretability-lr>
==== Feature Effect
<sub:feature-effect-lr>
Linear regression naturally provides a direct measure of the feature effect on the target variable through the coefficients $beta_j$. The effect of a feature $x_j$ on the prediction for an instance $i$ can be calculated as:

$ "effect"_j^(\( i \)) = beta_j x_j^(\( i \)) $

The standard visualization shows a box plot of the calculated effect in the 25th, 50th, and 75th percentiles (quantiles) for each feature. This enables users to quickly identify the features with the most significant effect on the predictions, as well as the distribution of the effects across the dataset.\
This plot is not useful if the data are normalized, as the effect is calculated as the product of the coefficient and the feature value, and normalization can obscure the true impact of the features on the predictions.

==== Weight Plot
<sub:weight-plot-lr>

  For a direct visualization of the importance of each feature, a weight plot can be used, which shows the coefficients $beta_j$ for each feature. The coefficients indicate the strength and direction of the relationship between each feature and the target variable.

  #figure(
      image("../../images/plots/weight-plot.png", alt: "Weight Plot"),
      caption: "Weight Plot of coefficients example for linear regression."
    )

=== Interpretability and explainability limitations
<sub:explainability-limitations-lr>
As discussed, linear regression is one of the most interpretable machine learning models due to its transparent internal representation and the direct relationship between features and predictions. The impact of each feature on the prediction can be easily understood through the coefficients, which indicate how much the prediction changes with a one-unit change in the feature, holding all other features constant. \
What makes the model highly interpretable also limits its predictive capacity; the assumption of linearity is as restrictive as it is understandable.