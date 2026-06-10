#pagebreak(to:"odd")
#import "../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../config/thesis-config.typ": side_by_side

= ML algorithms analysis
<cap:ml-algorithms-analysis>

#v(1em)
#text(style: "italic", [
    In this chapter, we will analyze the machine learning algorithms used in the project, looking at the mathematical foundations, the data requirements, the predictive performance, and the interpretability of the results. \
    This initial analysis will guide the design and implementation of the pipeline as well as the creation of the specific prompts for the #gls("large language model", plural: true) to generate human-readable explanations of the results. \
])
== Common metrics for algorithm evaluation
<common-metrics>
To evaluate the performance of the machine learning algorithms in the classification and regression tasks, we will use some common metrics paired with the algorithms' specific metrics.

=== Classification metrics
<cap:classification-metrics>
The following is a list of metrics for evluating the predictive performances of the logistic regression in the context of the classification task. \
Before presenting this metrics, it is important to define some terms, used later:
- #strong[#gls("true positives")]: instances correctly predicted as positive
- #strong[#gls("true negatives")]: instances correctly predicted as negative
- #strong[#gls("false positives")]: instances incorrectly predicted as positive
- #strong[#gls("false negatives")]: instances incorrectly predicted as negative

#strong[Confusion Matrix]\
<sub:confusion-matrix>
#side_by_side([
  The confusion matrix is a table that summarizes the results of a classification task by comparing the true class labels with the predicted class labels.\ 
  The 4 different categories are #gls("true positives"), #gls("true negatives"), #gls("false positives") and #gls("false negatives") as described before.
],[
    #figure(
      image("../images/plots/confusion-matrix.png", alt: "Confusion Matrix rappresentation with the 4 categories TP, TN, FP, FN"),
      caption: "Confusion matrix of a logistic regression model."
    )
])

#strong[Accuracy]\
<sub:accuracy>
Accuracy measures the ratio of correct predictions to the total predictions:
$ "ACC" = frac("TP" + "TN", "TP" + "TN" + "FP" + "FN") $
It is important ot notice that in the context of unbalanced classes, accuracy can be misleading, as a model that always predicts the majority class can achieve high accuracy while performing poorly on the minority class.

#strong[Sensitivity (Recall / True Positive Rate)]\
<sub:sensitivity-recall>
The sensitivity, also known as recall or true positive rate, measures the ratio of correctly predicted positive instances to all actual positive instances:
$ "SENS" = frac("TP", "TP" + "FN") $

#strong[Specificity (True Negative Rate)]\
<sub:specificity>
The specificity, also known as true negative rate, measures the ratio of correctly predicted negative instances to all actual negative instances:
$ "SPEC" = frac("TN", "TN" + "FP") $
Sensitivity and specificity are particularly important in contexts where the cost of false positives and false negatives is different, such as in medical diagnosis.

#strong[Precision]\
<sub:precision>
Precision measures the ratio of correctly predicted positive instances to all predicted positive instances:
$ "PREC" = frac("TP", "TP" + "FP") $
Precision is crucial in scenarios where the cost of false positives is high, such as in spam detection or fraud detection.

#strong[F1-Score]\
<sub:f1-score>
Out of the box, the precision and recall can be in tension, as improving one often leads to a decrease in the other. The F1-score is the harmonic mean of precision and recall, providing a single metric that balances both:
$ "F1" = 2 frac("PREC" dot.op "REC", "PREC" + "REC") $
It results particularly useful in unbalanced classification problems or in situations in which both false positive and false negative are costly.

#strong[ROC Curve and AUC]\
<sub:roc-curve-auc>
#side_by_side([
   #figure(
        image("../images/plots/roc-curve.png", alt: "ROC Curve rappresentation"),
        caption: "ROC curve of a logistic regression model."
      )
  ],[
    #strong[ROC Curve] is visual rappresentation of the True Positive Rate ()  - False Positive Rate trade-off
    Positive Rate as the threshold of classification varies. The Sensitivity sits on the y-axis and False Positive Rate on the x-axis.\
    A model with good performance will have a curve that bows towards the top-left corner of the plot, indicating high sensitivity and low false positive rate across different thresholds. A model that predicts randomly will have a curve that follows the diagonal line.
])

#strong[AUC (Area Under the Curve)] is exactly the area under the ROC curve, numerically quantifying the overall ability of the model to discriminate between the positive and negative classes. The AUC ranges from 0 to 1, with higher values indicating better performance and 0.5 representing random guessing. \
Can  be interpreted as the probability that the model will rank a randomly chosen positive instance higher than a randomly chosen negative instance.


=== Regression metrics
<cap:regression-metrics>
#strong[$R^2$ (Determination Coefficient)]\
<sub:r-square-coefficient-lr>
$R^2$ quantifies how much the model explains the total variance of the data. Il ranges from 0 to 1, where 0 is a model that cannot explain the datas and 1 is a perfect adherance.

$ R^2 = 1 - frac(S S E, S S T) $

Where:
- $S S E = sum_(i = 1)^n \( y^(\( i \)) - hat(y)^(\( i \)) \)^2$ is the sum of squared residuals, quantifying the variance unexplained by the model
- $S S T = sum_(i = 1)^n \( y^(\( i \)) - macron(y) \)^2$ is the total variance

#strong[$macron(R)^2$ (Adjusted R²)]\
<sub:macron-r-square-lr>
$R^2$ tends to increase with the number of features, even if those features are not useful. Adjusted R² penalizes the addition of non-informative features.

$ macron(R)^2 = 1 - \( 1 - R^2 \) frac(n - 1, n - p - 1) $
Where $n$ is the number of instances and $p$ is the number of features.

#strong[#gls("rmse", long: true)]\
<sub:rmse-root-mean-squared-error-lr>
$"RMSE"$ measures the magnitude of the errors, in the same scale as the
target variable:

$ "RMSE" = sqrt(frac(S S E, n)) $

#strong[#gls("mae", long: true)]\
<sub:mae-mean-absolute-error-lr>
$"MAE"$ measures the average magnitude of the errors, without considering their direction:

$ "MAE" = 1 / n sum_(i = 1)^n \| y_i - hat(y)_i \| $
#v(1em)

#include("./algo/LR.typ")
#include("./algo/LogR.typ")
#include("./algo/SVM.typ")
#include("./algo/DecisionTree.typ")
//#include("./algo/RandomForest.typ")
//#include("./algo/XGBoost.typ")
// #include("./algo/SymbR.typ")

== ...
