#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side

== Algorithmic comparison
<algorithmic-comparison>

=== Performance comparison
<performance-comparison>
To compare the different algorithms performance have been used the following metrics:
- For classification algorithms: accuracy, F1-Score, AUC, precision and recall.
- For regression: R^2, Adjusted R^2, MAE, MSE and RMSE. \
As dataset, in a first phase a syntethic dataset retrieved from Kaggle has been used (Student Placement & Salary Dataset@student-dataset) for both regression and classification tasks. 
Then, the same metrics have been used to compare the algorithms on the real datasets, used for the following evaluation.\
For all the algorithms, the best hyperparameters are automatically choosen using Optuna and its bayesian optimization approach, which allows to efficiently explore the hyperparameter space and find the optimal configuration for each algorithm for a sepcific dataset. \

#strong[Binary classification]
For the binary classification has been used the heart disease dataset@heart-dataset, which contains 12 features and a binary target variable indicating the presence or absence of heart disease. The performance comparison of the algorithms is shown in the following figures.
 #figure(
        image("../../images/algo-confront/heart_confront.png", alt: "Binary Classification performance comparison of the algorithms on the heart disease dataset."),
        caption: "Binary Classification performance comparison of the algorithms on the heart disease dataset."
      )
As shown inthe figure, the best performing algorithm is the SVM, achieving an F1-score of 0.8909, followed by XGBoost with an F1-score of 0.8695, and Random Forest with an F1-score of 0.8245. The Decision tree perform the worst respectively with an F1-score of 0.8060 and 0.7667.\
A similar trend is observed for the other metrics, with SVM consistently outperforming the other algorithms across all metrics, followed by XGBoost and Random Forest, while Decision Tree performs the worst. \
What emerges is that the ensemble methods (Random Forest and XGBoost) perform better than the single decision tree. This is expected, as the ensemble methods combine multiple trees to reduce overfitting and improve generalization, while a single decision tree can easily overfit the training data. \
THe logistic regression on the other hand performs worse than the others, again expected as it is a linear model and the dependencies between the features and the target variable are likely non-linear. \
Finally, it is interesting to notice that the SVM performs better than the other algorithms, even if it is a linear model. This can be explained by the fact that SVM can find a non-linear decision boundary using kernel functions, which allows it to capture complex relationships between the features and the target variable.

#strong[Regression]
For the regression task has been used the life expectancy dataset@life-expectancy-dataset, which contains 22 features and a continuous target variable representing life expectancy. The performance comparison of the algorithms is shown in the following figures.
 #figure(
        image("../../images/algo-confront/life_confront 1.png", width:80%, alt: "Regression performance comparison of the algorithms on the life expectancy dataset."),
        caption: "Regression performance comparison of the algorithms on the life expectancy dataset."
      )

 #figure(
        image("../../images/algo-confront/life_confront 2.png", width:80%, alt: "Regression performance comparison of the algorithms on the life expectancy dataset, focus on error metrics."),
        caption: "Regression performance comparison of the algorithms on the life expectancy dataset with focus on error metrics."
      )



