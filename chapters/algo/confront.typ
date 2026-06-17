#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side

== Algorithmic comparison
<algorithmic-comparison>

=== Performance comparison
<performance-comparison>
To compare the different algorithms performance have been used the following metrics:
- For classification algorithms: accuracy, F1-Score, AUC, precision and recall.
- For regression: $R^2$, Adjusted $R^2$, MAE, MSE and RMSE. \
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
The logistic regression on the other hand performs worse than the others, again expected as it is a linear model and the dependencies between the features and the target variable are likely non-linear. \
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
Similar results are observed for the regression task, with the XGBoost algorithm outperforming the other algorithms across all metrics, achieving an adjusted $R^2$ of 0.9089, followed by linear regression with 0.8939, Random Forest with 0.8730, and Decision Tree with 0.8143. The symbolic regression performs the worst with an adjusted $R^2$ of 0.6624. \
Again the ensamble methods perform significantly better than the single decision tree, which are known to underperform in regression tasks.\
Interestingly, a simple model such as the linear regression achives very good results with predictions close to the one provided by more complex models. This is due to the nature of the problem and the dataset but it is important to underline how a simple model can still achieve good performance in certain real world scenarios. \
The symbolic regression performs the worst, which is expected as it is a more complex model that can easily overfit the training data, especially when the dataset is small or noisy. \

=== Explainability vs perfomance comparison
<explainability-vs-performance-comparison>
An interesting yep intuitive pattern emerges when comparing the performance of the algorithms with their explainability. In general, more complex models tend to perform better than simpler models, but they are also less interpretable and harder to explain. \
Ensemble methods show a substantial boost in predictive performance compared to single tree models, but they also result in a more obscure decision-making process, making it difficult to understand how the model arrived at its predictions. \
For this exact reason, it is important to consider the context and specific requirements of the problem when choosing an algorithm. In some cases, a simpler model with lower performance may be preferred if interpretability and explainability are crucial, while in other cases, a more complex model with higher performance may be acceptable if accuracy is the primary concern. \
Post-hoc explainability techniques can support complex models, making them more interpretable in their decision making. However, this comes at an additional computational cost that can be significant. For example, when computing #gls("shap") values for SVM, the computational price is higher than tree-based models because it cannot leverage the internal structure of trees. The values are calculated by perturbing the input data and observing the change in the model's output, which can be computationally expensive, especially for large datasets. \
In conclusion, the choice of algorithm should be guided by a careful consideration of the trade-off between performance and explainability, as well as the specific requirements of the problem at hand, leveraging post-hoc explainability techniques when necessary to enhance the interpretability of complex models.