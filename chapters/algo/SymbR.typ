#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side

== Symbolic regression
<symbolic-regression>

=== Mathematical model
<sub:symbolic-regression-model>

Symbolic Regression (SR) is a machine learning technique that aims to discover mathematical expressions that best fit a given dataset. Unlike traditional regression models which operate within a predefined functional form (e.g., linear or polynomial), Symbolic Regression searches over a space of mathematical expressions of varying complexity to find one that accurately describes the relationship between features and target variable.

The core idea is to represent potential solutions as expression trees, where each node represents an operation (arithmetic, trigonometric, exponential, etc.) or a feature. The goal is to evolve these expressions through a process inspired by genetic programming to minimize a loss function.

The general form of a discovered expression can be written as:

$ hat(y) = f(x_1, x_2, ..., x_p) $

where $f$ is an expression discovered by the algorithm, composed of elementary operations. For example:

$ hat(y) = x_1^2 + sin(x_2) - 3 x_3 / (x_4 + 1) $

PySR, the implementation used in this project, employs an evolutionary algorithm that maintains a population of candidate expressions and iteratively improves them through genetic operations (mutation, crossover) and selection, guided by both accuracy and complexity (measured by the number of nodes in the expression tree). The optimization problem can be formulated as:

$ hat(f) = "argmin"_f (L(f) + lambda "complexity"(f)) $

where $L(f)$ is the loss function (typically mean squared error for regression) and $lambda$ controls the trade-off between accuracy and simplicity, embodying Occam's Razor principle.

=== Time complexity
<sub:symbolic-regression-time-complexity>

The time complexity of Symbolic Regression is highly dependent on several factors: the population size $P$, the number of generations $G$, the complexity of the expressions (number of nodes $N$), and the dataset size $n$. 

For PySR specifically, each generation requires evaluating all expressions in the population on the entire dataset. Evaluating a single expression on a dataset requires traversing the expression tree for each instance, which takes $O(N)$ time per instance. Therefore, evaluating a population of size $P$ on a dataset of size $n$ takes:

$ O(P dot.op N dot.op n) $ per generation

Over $G$ generations, the total time complexity becomes:

$ O(G dot.op P dot.op N dot.op n) $

In practice, $N$ grows as the algorithm explores more complex expressions, making the complexity potentially very high for large populations and many generations. However, PySR implements several optimizations:

+ *Batching and Parallelization:* evaluations can be parallelized across multiple cores, reducing wall-clock time
+ *Expression Simplification:* automatic simplification of expressions reduces $N$ during evolution
+ *Early Stopping:* if no improvement is observed over several generations, the search can be terminated early
+ *Pareto Optimization:* PySR maintains a Pareto front of expressions balancing accuracy and complexity, allowing it to discard clearly inferior expressions

For inference, the time complexity is $O(N)$ where $N$ is the number of nodes in the final expression tree. Given that PySR favors simpler expressions, $N$ is typically small (often less than 20 nodes), making inference very fast.

=== Spatial complexity
<sub:symbolic-regression-spatial-complexity>

The spatial complexity of Symbolic Regression is dominated by the storage of the population of expressions and the dataset itself.

During evolution, PySR must store:

+ The dataset: $O(n dot.op p)$ where $n$ is the number of instances and $p$ is the number of features
+ The population of expressions: $O(P dot.op N_"avg")$ where $P$ is the population size and $N_"avg"$ is the average number of nodes per expression
+ The history of expressions evaluated (for tracking best solutions and complexity): $O(P dot.op G dot.op N_"avg")$ in the worst case

Therefore, the overall spatial complexity during training is:

$ O(n dot.op p + P dot.op G dot.op N_"avg") $

In practice, PySR optimizes this by not storing all historical expressions, resulting in a much lower actual memory footprint. The spatial complexity is further reduced by the fact that Pareto optimization allows discarding dominated solutions.

For inference, the spatial complexity is $O(N)$ for storing the final expression tree, which is typically very small (less than 100 bytes for most expressions).

=== Internal representation
<sub:symbolic-regression-internal-representation>

A Symbolic Regression model discovered by PySR is internally represented as an expression tree. Each node in the tree represents either:

+ *Operator nodes:* arithmetic operations (+, -, ×, ÷), trigonometric functions (sin, cos, tan), exponential/logarithmic functions (exp, log), power operations, etc.
+ *Leaf nodes:* features ($x_i$) or constants (real numbers)

For example, the expression $hat(y) = x_1^2 + sin(x_2)$ would be represented as:
#figure(
        image("../../images/plots/symbolic_rappr.png", width: 80%, alt: "Expression tree representation of a symbolic regression model."),
        caption: "Expression tree representation of a symbolic regression model."
      )

This representation has profound implications for #strong[explainability]. Unlike black-box models, the discovered expression is fully transparent and interpretable. A domain expert can directly read the mathematical relationship between features and the target variable, understand how features interact, and potentially derive new insights about the underlying system.

The explicit mathematical form also allows for analytical operations such as computing derivatives, identifying discontinuities, or analyzing asymptotic behavior.\
However, as expressions become more complex (more nodes in the tree), interpretability degrades. This is why PySR explicitly penalizes expression complexity during evolution, maintaining a trade-off between accuracy and interpretability (the Pareto front).

=== Data assumptions
<sub:symbolic-regression-data-assumptions>

Symbolic Regression makes very few structural assumptions about the data compared to traditional regression models. However, several practical considerations exist. \
While SR can discover non-smooth relationships, it performs best when the underlying relationship is relatively smooth. Highly discontinuous or noise-dominated relationships are difficult to capture.\
Then, features should ideally be scaled to similar ranges. Highly disparate scales can lead to numerical instability during expression evaluation and can bias the algorithm towards features with larger magnitudes.

+ #strong[Noise Sensitivity:] SR can be sensitive to noise in the data. High noise levels can lead to overfitting, where the discovered expression fits noise rather than the underlying pattern. This is mitigated by the complexity penalty in PySR.\
Another requirement is a reasonable amount of data is needed for reliable discovery. With very small datasets, the discovered expressions may not generalize well.

+ #strong[Feature Relevance:] irrelevant features in the input can mislead the algorithm. Feature selection or domain knowledge about relevant features improves results.

Unlike linear models, SR does not suffers from strong assumption such as linearity of relationships, homoscedacity, normal distribution of residuals, or independence of features. This flexibility makes SR applicable to a wide range of problems where traditional assumptions would be violated.

=== Predictive performance and limitations
<sub:symbolic-regression-predictive-performance-and-limitations>

Symbolic Regression offers several advantages in terms of predictive performance.\
It's an extremely flexible method that can discover complex non-linear relationships of arbitrary functional form. The feature transformations (polynomials, logarithms, trigonometric functions) are discovered automatically, without manual specification. Additionally, 
the complexity penalty encourages simpler models that often generalize better than complex black-box models. \
On the other hand, the Symbolic regression sufffers from sevveral important limitations. \
First of all, the seaerchc process is computationally expensive, especially for large datasets or high-dimensional feature spaces. Training can take minutes to hours even with parallelization. \
Second, the space of possible expressions is extremely large, and there is no guarantee of finding the global optimum. \
Third, discovered expressions may behave unexpectedly outside the range of training data, as they are not constrained by physical laws. \
Fourth, PySR has many hyperparameters (population size, generations, complexity penalty, mutation rates) that significantly affect results and require careful tuning. Fifth, discovering meaningful expressions requires high-quality, noise-free data. Poor data quality leads to spurious expressions. Finally, performance degrades significantly with very high-dimensional feature spaces, as the search space becomes prohibitively large.\
Consequently, is best suited for problems where the underlying relationship is suspected to have a relatively simple mathematical form, interpretability is important, computational resources are available, and data quality is good with a moderate dataset size. It's power has been directly demonstrated in scientific discovery, in particular in physics@applied-symbolic-regression.


=== Metrics for prediction quality
<sub:symbolic-regression-metrics>

For evaluating the predictive performance of Symbolic Regression, standard regression metrics apply. See @cap:regression-metrics for general metrics such as #gls("rmse"), #gls("mae"), and $R^2$.

Additionally, SR-specific metrics are valuable:

==== Complexity
<sub:complexity-metric-sr>

The complexity of an expression is typically measured as the number of nodes in the expression tree $N$. PySR uses this metric as part of its fitness function to prefer simpler expressions:

$ "Complexity" = N $

A smaller complexity indicates a simpler, more interpretable expression. The trade-off between complexity and accuracy is explicitly managed through the complexity penalty parameter in PySR.

==== Pareto Front Analysis
<sub:pareto-front-sr>
#side_by_side([
PySR maintains a Pareto front of non-dominated expressions, expressions where no other expression is simultaneously simpler and more accurate. This provides the user with a set of candidates to choose from based on their specific accuracy-interpretability trade-off preference. 
],[
#figure(
        image("../../images/plots/pareto_frontier.png", width: 100%, alt: "Pareto front of discovered expressions showing the trade-off between loss and complexity."),
        caption: "Pareto front of discovered expressions showing the trade-off between loss and complexity."
      )
], proportions: (30%, 70%))

==== Expression Stability
<sub:expression-stability-sr>

Measures how similar the discovered expressions are across multiple runs with different random seeds. More stable expressions (discovered consistently) are generally more trustworthy than those that appear by chance.

=== Explainability and interpretability metrics
<sub:symbolic-regression-metrics-for-interpretability>

The primary advantage of Symbolic Regression is that the model itself is an explanation. However, several metrics help quantify and visualize feature importance and expression behavior.

==== Feature Importance from Expression Analysis
<sub:feature-importance-expression-sr>

Since the discovered expression is explicit, feature importance can be computed directly by analyzing the structure:

+ #strong[Frequency Analysis:] count how often each feature appears in the expression tree. Features appearing multiple times or in critical positions (e.g., as the argument to exponential functions) are more important.

+ #strong[Sensitivity Analysis:] for a given instance, compute the partial derivative of the expression with respect to each feature:

$ "Importance"_j^(\(i\)) = | frac(partial f, partial x_j) | $

This measures how much the prediction would change with a small change in each feature, providing an instance-level feature importance.

+ #strong[Feature Interaction Identification:] inspect the expression structure to identify which features interact multiplicatively, additively, or through other operations, providing insight into feature relationships that the model has discovered.

==== Sensitivity and Derivative Analysis
<sub:sensitivity-analysis-sr>
Since the discovered expression is differentiable (except at discontinuities), one can perform sensitivity analysis by computing derivatives with respect to each feature. This allows for understanding how small changes in input features affect the output prediction and model behavior.

==== Expression Complexity Visualization
<sub:expression-tree-visualization-sr>
As shown in @sub:symbolic-regression-internal-representation, the discovered expression can be visualized as an expression tree. This visualization provides insight into the structure of the model and how it was constructed.
#figure(
        image("../../images/plots/pysr_tree.png", width: 100%, alt: "Expression tree representation of a symbolic regression model using the life expectancy dataset."),
        caption: "Expression tree representation of a symbolic regression model using the life expectancy dataset."
      )

=== Explainability limitations
<sub:symbolic-regression-explainability-limitations>

While Symbolic Regression provides superior interpretability compared to black-box models, it has specific limitations.
Even with the complexity penalty, discovered expressions can become quite complex (50+ nodes), at which point they become difficult for humans to understand and may represent overfitting rather than true underlying relationships. \
While one can understand the entire equation globally, understanding *why* specific feature interactions emerge can be difficult without domain expertise.
Multiple mathematically equivalent expressions can exist (e.g., $x^2 + 2x + 1$ vs $(x+1)^2$), and the algorithm may discover one that is less intuitive than another.\
Expressions involving operations like absolute value or maximum can contain *discontinuities*, making them difficult to analyze and potentially problematic for certain applications.\
Despite these limitations, Symbolic Regression remains one of the most interpretable machine learning approaches available, making the discovered *explicit mathematical relationships* valuable for scientific discovery and understanding of complex systems.