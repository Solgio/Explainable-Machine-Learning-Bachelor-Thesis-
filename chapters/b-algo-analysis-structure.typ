#import "../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls

== Algorithmic analysis structure
<cap:algo-analysis-structure>

#v(1em)
The analysis of the algorithms is structured in a systematic way to ensure a comprehensive evaluation of their interpretability and comprehensibility as well as thir functioning. The structure includes the following components:

+ #strong[Mathematical foundations]:  detailed examination of the mathematical principles underlying each algorithm, including their assumptions and theoretical properties. The focus is on the understanding of the specific @objective_function:long that the algorithms optimize, the regularization techniques they use, and the mathematical properties that govern their behavior.

+ #strong[@computational_complexity:long]: analysis of the computational requirements of each algorithm, including time complexitys and scalability reguarding both training and inference.

+ #strong[Internal representation]: exploration of how each algorithm internally represents data and makes decisions, especially regarding @categorical_features:long.

+ #strong[Data assumptions]: investigation into the assumptions each algorithm makes about the data, such as linearity, independence of features, and distributional assumptions.

+ #strong[Predictive performance and limitations]: evaluation of the predictive performance of each algorithm on relevant datasets, considering the data assumptions and mathematical foundation of the model.

+ #strong[Metrics for prediction quality]: presentation of the most relevant metrics for evaluating the models performance, based on the task.

+ #strong[Metrics for interpretability]: presentation of the most relevant metrics for evaluating the models interpretability, based on the task.

+ #strong[Explainability limitations]: discussion of the limitations of explainability techniques for each algorithm, including potential pitfalls and challenges in interpreting their predictions.