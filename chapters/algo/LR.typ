#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side

== Linear regression
<cap:linear-regression>

=== Mathematical model
<sub:model-lr>
The linear regression model is the simplest form of regression. It assumes a linear relationship between the input features and target variable. The mathematical representation of the linear regression model is:
$ y = sum_(i = 0) beta_i x_i forall i in F $
Where $F$ is the set of features, $beta$ are the calculated weights for each of the features, and $y$ is the target variable.\
The goal of the linear regression is to find the optimal weights $beta$ that minimize the error between the predicted values and the actual target variable. This is typically done by minimizing the ordinary least squares loss function between the predicted values and the actual target variable. The optimization problem can be formulated as:
$ hat(beta) = "argmin"_(beta_0 . . . beta_p) sum_(i = 1)^n \( y^(\( i \)) - \( beta_0 + sum_(j = 1)^p beta_j x_j \) \)^2 $

=== Time complexity
<sub:time-complexity-lr>
Mainly there are two approches to solve this optimization problem: the analytical solution and the iterative optimization methods (e.g. #gls("gradient descent")). The analytical solution is given by the normal equation:

$ hat(beta) = \( X^T X \)^(- 1) X^T y $

In this formulation, $X$ is an $n x p$ matrix where $n$ is the number of instances and $p$ is the number of features. The matrix $X$ is augmented with a column of 1s to account for the intercept term $beta_0$. The #gls("computational_complexity") of the analitical solution is dominated by the matrix multiplication and inversion operations. In fact, the cost for the moltiplication of matrixes is $O \( p^2 n \)$ and the cost for the inversion of a $p x p$ matrix is $O \( p^3 \)$. Therefore, the overall #gls("computational_complexity") of the analytical solution is $O \( p^2 n + p^3 \)=O \( p^3)$, which for vast datasets, over 10000 records, becomes prohibitive.\
The iterative methods, such as #gls("gradient descent"), calculate the gradient of the loss function with respect to the weights and update the weights iteratively until convergence. The #gls("computational_complexity") of the gradient calculation is $O \( p n \)$ per iteration, and the number of iterations required for convergence can vary depending on the learning rate and the specific dataset. However, in practice, iterative methods can be more efficient than the analytical solution for large datasets, as they do not require matrix inversion and can converge faster with appropriate hyperparameter tuning. Other methods like #gls("stochastic gradient descent") can further reduce the computational cost by approximating the gradient using a subset of the data at each iteration.\
On the other side, for smaller dataset, analytical solution offers convergence in a single step, without the need for hyperparameter tuning, and guarantees a global optimal solution.

For *inference*, the #gls("computational_complexity") is $O \( p \)$ per instance, as it involves a simple dot product between the feature vector and the weight vector.

=== Spacial complexity
<sub:spacial-complexity-lr>
The spacial complexity of the linear regression model is determined by the need to store the input data, the weight vector, and any intermediate matrices used in the analytical solution. Specifically, the analytical solution requires storing the $n x p$ matrix $X$, the $p x p$ matrix $X^T X$, and the $p$-dimensional weight vector $beta$. Therefore, the overall spacial complexity of the linear regression model is dominated by the storage of the input data and the intermediate matrices, resulting in a spacial complexity of $O \( n p + p^2 \)$.\
For the #gls("gradient descent") method, the spacial complexity is reduced to $O \( n p + p \)$, as it does not require storing the intermediate matrix $X^T X$.\
For *inference*, the #gls("computational_complexity") is $O \( p \)$ per instance, as it only stores the weight vector and the feature vector.

=== Internal representation
<sub:internal-representation-lr>
Linear regression represents the resulting weight of the features as a vector of weights, $beta = \[ beta_0 \, beta_1 \, . . . \, beta_p \]$. \
Specific encoding is needed for #gls("categorical_features"), which are typically handled through one-hot encoding, where each category is represented as a binary feature. This can lead to an increase in the number of features and potential multicollinearity issues if not handled properly.

\
In regard of #strong[explainability], the internal representation of linear regression is straightforward and transparent, which makes it one of the most interpretable machine learning models. The weights directly indicate the strength and direction of the relationship between each feature and the target variable. This allows for a clear understanding of how each feature contributes to the prediction, making it easier to communicate insights to stakeholders and identify important predictors in the data.

=== Data assumptions
<sub:data-assumptions-lr>
Linear regression relies on several key assumptions about the data to ensure the validity of the model and the reliability of its predictions. These assumptions include as described by Molnar @interpretability_book:

+ #strong[Linear constraints:] relationships between features and target must be linear. Other kind of relationships must be manually introduced and cannot be revealed automatically

+ #strong[Residuals normality:] the residuals
  $epsilon.alt_i = y_i - hat(y)_i$ must follow a normal distrubution. Violazioni gravi compromettono l\'inferenza statistica
  (p-value, intervalli di confidenza)

+ #strong[Homoscedasticity:] residuals must have constant variance across
  all levels of the features. In practice, this assumption is
  #strong[frequently violated]. Example: in real estate, the price
  of very large houses is extremely variable, while that of small
  houses is concentrated.

+ #strong[Indipendence of measurements:] instances don't have to be correlated. Dipendent datas, such as time series, violate 
  this assumption and as such should not be investigated with linear regression.

+ #strong[Feature fisse:] le feature devono essere considerate come
  costanti, non soggette a errori di misurazione significativi. Se le
  feature contengono errore di misura, i coefficienti sono distorti
  (attenuation bias)

+ #strong[Absence of multicollinearity:] Feature should not be highly correlated. Multicollinearity causes numerical instability during the inversion of $X^T X$ e weights inflation in absolute value. Using #gls("gradient descent") the geometrical properties of the loss function changes and leads to very slim vallies causing an important reduction of the learning rate. 

==== Preprocessing
<sub:preprocessing-lr>
The data assumption lead to specific preprocessing steps to determine the suitability of the data for linear regression and to improve the performance of the model. These steps include:
+ #strong[Multicollinearity identification:] calculation of the @corr_matrix:long between features using the Pearson's coefficient or VIF (Variance Inflation Factor) to identify highly correlated features.
 $ "VIF"_j = frac(1, 1 - R_j^2)$
Where $R_j^2$ is the coefficient of determination for the regression of feature $j$ against all other features. More on $R_j^2$ #link(<sub:r-square-coefficient-lr>)[here].

=== Predictive performance and limitations
<sub:predictive-performance-and-limitations-lr>
As discussed, the linear regression imposes several constraints on the data and model performance. Very good performances are achieved whenever linear relationships exist between features and target both in accuracy and efficiency. \
However, in real-world scenarios, these conditions are often violated, leading to poor predictive performance. The model is particularly sensitive to #gls("outlier", plural:true), which can disproportionately influence the weights and lead to skewed predictions. Additionally, linear regression is not suitable for capturing complex, non-linear relationships in the data, which limits its applicability in many real-world problems where such relationships are common. Finally, the model's performance can degrade significantly when the number of features is large relative to the number of observations, leading to overfitting and poor generalization to new data. This limitation is intensified by the presence of @categorical_features.


=== Pure metrics for prediction quality
<sub:pure-metrics-lr>
What follows is a list of most relevant metrics for evaluating the predictive performance of linear regression models, based on the task and the data assumptions.
==== $R^2$ (Determination Coefficient)
<sub:r-square-coefficient-lr>
$R^2$ quantifies how much the model explains the total variance of the data. Il ranges from 0 to 1, where 0 is a model that cannot explain the datas and 1 is a perfect adherance.

$ R^2 = 1 - frac(S S E, S S T) $

Where:
- $S S E = sum_(i = 1)^n \( y^(\( i \)) - hat(y)^(\( i \)) \)^2$ is the sum of squared residuals, quantifying the variance unexplained by the model
- $S S T = sum_(i = 1)^n \( y^(\( i \)) - macron(y) \)^2$ is the total variance

==== $macron(R)^2$ (Adjusted R²)
<sub:macron-r-square-lr>
$R^2$ tends to increase with the number of features, even if those features are not useful. Adjusted R² penalizes the addition of non-informative features.

$ macron(R)^2 = 1 - \( 1 - R^2 \) frac(n - 1, n - p - 1) $
Where $n$ is the number of instances and $p$ is the number of features.

==== Feature Importance (t-statistic)
<sub:feature-importance-t-statistic-lr>
$ t_(hat(beta)_j)$ measures the statistical significance of each coefficient, calculated as the weight scaled by its standard error:

$ t_(hat(beta)_j) = frac(hat(beta)_j, S E \( hat(beta)_j \)) $

Intuitively, the higher the absolute value of a coefficient is, the more the feature is statistically significant in predicting the target variable. \
As intuitively, the hgher the variance of the coefficient is, the less the feature is significant, as the model is more uncertain about the true value of the coefficient. \

==== p-value
<sub:p-value-lr>
p-value is a measure of the probability of "obtaining the observed data under the null hypothesis of a statistical test"@p-value. In the context of linear regression, the null hypothesis is that the true coefficient $beta_j$ is equal to zero, meaning that the feature does not have a significant impact on the target variable. The p-value for each coefficient is calculated based on the t-statistic and indicates the probability of observing such an extreme value for $t_(hat(beta)_j)$ if the null hypothesis were true. A common convention is to consider a p-value less than 0.05 as statistically significant, suggesting that there is strong evidence against the null hypothesis and that the feature likely has a meaningful relationship with the target variable.

==== Mallows\' Cp
<sub:mallows-cp-lr>
Mallows\' Cp is a model selection metric that balances model fit and complexity, calculated as:

$ C p = frac(S S E, hat(sigma)^2) - n + 2 p $

Where $hat(sigma)^2$ is the estimate of residuals variance of the complete model. It's used to reduce the problem of overfitting, reducing the number of features.

==== #gls("rmse", long: true)
<sub:rmse-root-mean-squared-error-lr>
$"RMSE"$ measures the magnitude of the errors, in the same scale as the
target variable:

$ "RMSE" = sqrt(frac(S S E, n)) $

==== #gls("mae", long: true)
<sub:mae-mean-absolute-error-lr>
$"MAE"$ measures the average magnitude of the errors, without considering their direction:

$ "MAE" = 1 / n sum_(i = 1)^n \| y_i - hat(y)_i \| $

==== Diagnostic plots
<sub:diagnostic-plots-lr>
The use of diagnostic plots is crucial to visually assess the assumptions of linear regression and to identify potential issues with the model fit.
===== Actual vs Predicted
<sub:actual-vs-predicted-lr>
Scatter plot with actual values $y_i$ on the y-axis and predicted values $hat(y)_i$ on the x-axis.
$hat(y)_i$.
If the model fits well, the points should be concentrated around the diagonal line $y = hat(y)$. Deviations from this pattern can indicate various issues with the model fit. 

===== Histogram of residuals distribution
<sub:histogram-of-residuals-lr>
#side_by_side([
      Distribution of the residuals $epsilon.alt_i = y_i - hat(y)_i$.
      It's especially useful to identify violations of the normality assumption. A normal distribution of residuals is expected for valid inference, and deviations from this pattern can indicate issues with the model fit or the presence of outliers.
    ],[
      #figure(
        image("../../images/plots/distribution_plot.png", alt: "Histogram of residuals distribution"),
        caption: "Histogram of residuals distribution example for linear regression."
      )
    ]
)

===== Q-Q Plot (Quantile-Quantile)
<sub:q-q-plot-quantile-quantile-lr>
#side_by_side([
      #figure(
        image("../../images/plots/q-qplot.png", alt: "Q-Q Plot"),
        caption: "Q-Q Plot of residuals example for linear regression."
      )
],[
  Another way to check the normality of residuals is through a Q-Q plot, which compares the quantiles of the residuals to the quantiles of a normal distribution. If the residuals are normally distributed, the points in the Q-Q plot should approximately follow a straight line. Deviations from this line, especially at the tails, can indicate non-normality of the residuals, which may affect the validity of statistical inference based on the model.
])

===== Residuals vs Fitted Values
<residuals-vs-fitted-values>
Scatter plot with fitted values $hat(y)_i$ on the y-axis and residuals $epsilon.alt_i = y_i - hat(y)_i$ on the x-axis.
$hat(y)_i$. \
If the model fits well, the points should be concentrated around the diagonal line $y = hat(y)$. This plot can be used to identify violation in regression assumptions (@sub:data-assumptions-lr). Increasing dispersion for example, show heteroschedasticity, while systematic patterns (e.g. a curve) indicate non-linearity that the model cannot capture.

=== Explainability and interpretability metrics
<sub:metrics-for-interpretability-lr>
==== Feature Effect
<feature-effect>
Linear regression naturally provides a direct measure of the feature effect on the target variable through the coefficients $beta_j$. The effect of a feature $x_j$ on the prediction for an instance $i$ can be calculated as:

$ "effect"_j^(\( i \)) = beta_j x_j^(\( i \)) $

The standard visualization shows a box plot of the calculated effect in the quantiles 25, 50 and 75 for each feature. This allows to quickly identify the features with the most significant effect on the predictions, as well as the distribution of the effects across the dataset.\
This plot results not useful if the datas are normalized, as the effect is calculated as the product of the coefficient and the feature value, and normalization can obscure the true impact of the features on the predictions.

==== Weight Plot
<weight-plot>

  For a direct visualization of the importance of each feature, a weight plot can be used, which shows the coefficients $beta_j$ for each feature. The coefficients indicate the strength and direction of the relationship between each feature and the target variable.

  #figure(
      image("../../images/plots/weight-plot.png", alt: "Weight Plot"),
      caption: "Weight Plot of coefficients example for linear regression."
    )

=== Explainability limitations
<sub:explainability-limitations-lr>
As emerged until now, linear regression is one of the most interpretable machine learning models due to its transparent internal representation and the direct relationship between features and predictions. The impact of each feature on the prediction can be easily understood through the coefficients, which indicate how much the prediction changes with a one-unit change in the feature, holding all other features constant. \
What makes the model extremely interpretable make it limited in its predictive ability. Linearity of the relationships is as understandable as restrictive.