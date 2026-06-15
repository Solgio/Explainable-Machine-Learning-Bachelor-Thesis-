#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side

== Logistic regression
<cap:logistic-regression>
=== Mathematical model
<sub:model-logr>
Logistic regression is a model primarily used for binary classification problems where the response variable is dichotomous. Similar to linear regression(@cap:linear-regression) it uses a linear combination of the input features, but instead of directly outputting a continuous value, it applies a logistic function to map the output to a probability between 0 and 1.

$ sigma \( z \) = frac(1, 1 + exp \( - z \)) $

The output can consequently be interpreted as the probability that the input instance belongs to the positive class (y = 1). In particular, the probability that an instance belongs to the positive class is given by:

$ P \( y^(\( i \)) = 1 \| x^(\( i \)) \) = frac(1, 1 + exp \( - \( beta_0 + sum_(j = 1)^p beta_j x_j^(\( i \)) \) \)) $

And the probability of the negative class follows as 
$P \( y^(\( i \)) = 0 \) = 1 - P \( y^(\( i \)) = 1 \)$, consistent with the Bernoulli distribution.

The goal of the logistic regression is to find the parameters $beta$ that best fit the data, which is done by maximizing the *likelihood* of observing the data given the parameters.

$ L \( beta ; y \, X \) = product_(i = 1)^n P \( y^(\( i \)) = 1 \)^(y^(\( i \))) dot.op \( 1 - P \( y^(\( i \)) = 1 \) \)^(1 - y^(\( i \))) $

For numerical stability #strong[log-likelihood] is usually calculated:

$ ell \( beta \) = sum_(i = 1)^n [y^(\( i \)) log \( P \( y^(\( i \)) = 1 \) \) + \( 1 - y^(\( i \)) \) log \( 1 - P \( y^(\( i \)) = 1 \) \)] $
Differently from linear regression, the logistic regression does not have a closed-form solution for the parameters that maximize the likelihood so only iterative optimization algorithms like #gls("gradient descent") are available

=== Time complexity
<sub:time-complexity-logr>
As described in @sub:time-complexity-lr, the time complexity of #gls("gradient descent") is $O \( p n \)$ per iteration, and the number of iterations required for convergence can vary depending on the learning rate and the specific dataset. For *inference* the time complexity is again, $O(p)$ per instance. \
Since the optimization is iterative, the overall time complexity can be less predictable than linear regression, especially if the data has features that lead to slow convergence (e.g., highly correlated features or features that cause the decision boundary to be close to the data points). However, in practice, logistic regression is often computationally efficient for moderate-sized datasets and can be scaled to larger datasets using #gls("stochastic gradient descent") or mini-batch gradient descent.

=== Spatial complexity
<sub:spatial-complexity-logr>
The model stores a vector of coefficients $beta$ of size $p$, which requires $O \( p \)$ memory. During training, additional memory is needed to store the intermediate values for the optimization algorithm, which can be $O \( n \)$ for batch gradient descent due to the need to compute the predictions for all instances in each iteration. \
For inference, the memory complexity is $O \( p \)$ for storing the coefficients and $O \( 1 \)$ for the input instance, leading to an overall spatial complexity of $O \( p \)$.

=== Internal representation
<sub:internal-representation-logr>
The model internally rappresents the values as a vector of weights, $beta = \[ beta_0 \, beta_1 \, . . . \, beta_p \]$. The presence of #gls("categorical_features") is solved as standard through one-hot encoding just like in linear regression. \
For *explainability*, the model remains transparent since the coefficients still indicate the strength and direction of the relationship between each feature and the target variable, but the interpretation is less intuitive than in linear regression due to the non-linear transformation applied to the output by the logistic function. An increase in one feature in logistic regression leads to a multiplicative change in the odds of the positive class, rather than an additive change in the predicted value.

=== Data assumptions
<sub:data-assumptions-logr>
Before discussing the data assumptions we need to clarify the role of the $"odds"$. The $"odds"$ of an event is defined as the ratio of the probability of the event occurring to the probability of it not occurring:
$ upright("odds") = frac(P \( y = 1 \), P \( y = 0 \)) = exp (beta_0 + sum_(j = 1)^p beta_j x_j) $
This formulation more easily shows how the coefficients $beta_j$ affect the predictions.
$ upright("odds")_(x_j + 1) / upright("odds") = exp \( beta_j \) $
Just like in linear regression, the idea of maintaing the interpretability of the model through a linear combination of the features leads to several assumptions on the data and the model performance:

+ #strong[Linearity of the log-odds:]
  $log \( upright("odds") \) = beta_0 + sum_j beta_j x_j$. The relationship
  is linear in the #strong[log-odds space], not in the probability space.
  Nonlinear relationships remain uncaptured and must be added manually.

+ #strong[Complete separation:] if a feature perfectly separates the
  two classes , the model cannot identify a finite weight since the algorithm will tend to push the weight to $+ oo$ or $- oo$, diverging. Usually the solution is to eraze this separating feature, since it is probably just a proxy for the target variable.

+ #strong[Binomial distribution:] the response variable must
  follow a #strong[Bernoulli distribution]. 

+ #strong[Independence of measurements:] observations should not be
  correlated. This means that the model is not suitable for temporal data without proper control, as well as for data with strong dependencies between observations.

+ #strong[Fixed features:] features must be considered constants,
  without measurement error.

+ #strong[Absence of multicollinearity:] highly correlated features
  cause coefficient instability. This is particularly relevant due to the fact that the iterative methods begin to oscillate and need very small learning rates ($alpha$).

Homoscedasticity is no more a requirment because the response can only be 0 or 1.

==== Preprocessing
<sub:preprocessing-logr>
To verify the suitability of logistic regression in the classification task for a given dataset, some methods can be used.
The @corr_matrix can be used to identify highly correlated features, which can lead to multicollinearity issues. If such features are found, they can be removed or combined to reduce redundancy and improve model stability. \
For identifying anomalys in the other assumptions, plot visualitation can be used. See @sub:metrics-for-interpretability-logr for more details.

=== Predictive performance and limitations
<sub:predictive-performance-and-limitations-logr>
The imposed assumptions of logistic regression can lead to good performance whenever this assumptions are met. The probabilistic interpretation gives insight on the confidence of the prediction, which is a significant advantage in many applications. Computationally wise, achieves fast training thanks to the iterative methods to solve the loss function. \
However when the relationships are more complex than basic linear combinations, the predictions become less accurate. In context of unbalanced classes the training process can be dominated by the majority class, leading to poor performance on the minority class. Additionally, logistic regression as the linear regression is highly influenced by outliers, leading to very unstable predictions. There's then the limitation of the complete separation, which prevents the model to converge to a solution.

=== Metrics for prediction quality
<sub:metrics-logr>
The following is a list of metrics for evluating the predictive performances of the logistic regression in the context of the classification task. For the general metrics see @cap:classification-metrics.\

==== Z-Statistic e p-value
<sub:z-statistic-p-value-logr>
The specular t-statistic for logistic regression is the Z-statistic, which measures the statistical significance of each coefficient in the model. It is calculated as:
$ Z = frac(beta_j, "SE" \( beta_j \)) $

Where $"SE" \( beta_j \)$ is the standard error of the coefficient $beta_j$.
A coefficient with a large absolute value of Z indicates that the coefficient is significantly different from zero, suggesting that the corresponding feature has a significant impact on the predicted probabilities. \ 
The $"p-value"$ associated with the Z-statistic represents the probability of observing such an extreme Z value under the null hypothesis that $beta_j = 0$. For more details on the $"p-value"$, see @sub:p-value-lr.

=== Explainability and interpretability metrics
<sub:metrics-for-interpretability-logr>
Using plots to visualize the data and the model's predictions can help identify potential issues with the assumptions of logistic regression and provide insights into the model's performance.
==== Feature Effect
<sub:feature-effect-logr>
Similarly to Linear Regression, @sub:feature-effect-lr, the feature effect plot rappresent the impact of a feature on the prediction. In the logistic regression case, the effect is not on the predicted value but on the predicted probability, which is more intuitive to understand for most users. \

For every feature value, calculate:

$ P \( y = 1 \| x_j = v \, x_(upright("other")) = upright("media") \) $

==== Weight Plot
<sub:weight-plot-logr>
Likewise to linear regression, the weight plot shows the coefficients of the features. However, in logistic regression, the coefficients do not directly correspond to changes in the predicted probability, but rather to changes in the log-odds of the positive class. \

==== Odds Ratio
<sub:odds-ratio-logr>
Direct expression of the feature impact on the odds:
$ upright("OR")_j = exp \( beta_j \) $
It represents the multiplicative change in the odds of the positive class for a one-unit increase in the feature $x_j$, holding all other features constant. \


=== Explainability limitations
<sub:explainability-limitations-logr>
The logistic regression, while being more interpretable than many other machine learning models, has some limitations in terms of explainability. Firstly, the interpretation of the coefficients is less intuitive than in linear regression due to the non-linear transformation applied to the output by the logistic function. An increase in one feature in logistic regression leads to a multiplicative change in the odds of the positive class, rather than an additive change in the predicted value. \
This multiplicative effect is even less straightforward if we consider that the effect of a feature on the predicted probability depends on the values of all the other features, making it difficult to provide a simple explanation of the effect of a single feature without considering the context of the other features. \
