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
A multitude of splitting criteria exist, the following are the most common, for a more comprehensive list see @data_mining_with_decision_trees, @decomposition-knowledge-detection. These criteria are usually based on measures of impurity, measuring how mixed the classes are in a node. The goal is to find splits that create child nodes that are more pure than the parent node.

1. #strong[Gini Index (Classification):]
<sub:dec-tree-gini-index>
Measures based on #strong[impurity] for classification problems: 

$ upright("Gini") \( D \) = 1 - sum_(i = 1)^K p_i^2 $
Where $p_i$ is the proportion of instances belonging to class $i$ in the node. $K$ is the number of classes.
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
In fact, sorting the data for each feature takes $O \( n log \( n \) \)$, and this process is repeated for each of the $p$ features at each level of the tree. If the tree is grown to every leaf (no pruning), the number of nodes is in order of $O \( n \)$, giving the final complexity.
As descibed in the official Scikit-learn documentation @scikit-docs, the time complexity can the optimize to $O \( n dot.op p dot.op log \( n \) \)$ thanks to clever tracking of the general ordder of indices of the features, allowing to avoid sorting at each node.\
For *inference*, the time complexity is dependent on the depth of the tree, which in the worst case can be $O \( n \)$ (degenerate tree) and in the best case $O \( log \( n \) \)$ (balanced tree).\

=== Spacial complexity
<sub:dec-tree-spacial-complexity>
The spacial complexity is determined by the need to store the tree structure and the metrics for the evaluation of the splits. The spacial complexity is consequently $O\( n + n dot.op p \)$


=== Considerazioni sulla Scalabilità
<sub:dec-tree-considerazioni-sulla-scalabilità>
- #strong[Vantaggi:]

  - Training veloce per #strong[piccoli-medi dataset]
  - Inference molto veloce anche su dataset grandi
  - Parallelizzabile a livello di feature (considerare split in
    parallelo per ogni feature)

- #strong[Svantaggi:]

  - Man mano che $n$ cresce, il tempo quadratico $O \( n^2 \)$ nel caso
    degenerato diventa problematico
  - Per dataset enormi, tecniche di #strong[gradient-based tree]
    (XGBoost, LightGBM) sono preferibili, che usano binning per ridurre
    $O \( n log n \)$ a $O \( n \)$ per feature



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
This is a very weak assumption compared to linear models, which require linearity, normality, homoscedasticity, and independence of features. However, it not always possible to satisfy it and sometimes resampling or proportional weighting is needed to address it.


=== Predictive performance and limitations
<sub:dec-tree-predictive-performance-and-limitations>
Decision trees are powerful models in context of classification, especially when the relationship between features and target is complex and non-linear, for example in a context with multiple #gls("categorical_features"). Feature interactions are naturally captured by the tree structure without explicitly modeling them. As said previously, decision trees can handle #gls("categorical_features") without the need for encoding, which can be a significant advantage in many real-world datasets. Moreover, they do not require any assumptions about the distribution of the data or the linearity of relationships between features and target variable, making them versatile for a wide range of problems.\ All there advantages lead to a model that can capture automatically complex patterns in a vast variety of datasets.\
On the contrary, decision trees can be inaccurate on purely linear data, where a simple linear model would achieve better performance. In general, decision tree regressors tend to be inaccurate as they approximate the target variable with piecewise constant predictions, which can lead to high bias. Moreover, decision trees are prone to overfitting, especially when the tree is allowed to grow deep and capture noise in the training data and in high dimensionalities. This can lead to poor generalization performance on unseen data.\
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
Measures how often a fearure is used as a splitting criterion and how much it reduces the average impurity:

$ upright("Importance")_j = frac(sum_(upright("nodes with feature ") j) \( upright("IG")_(upright("node")) \) times \( upright("n nodes") \) \/ n, upright("sum of all the nodes")) $
The more a feature is used for splitting and the more it reduces impurity, the higher its importance score. This metric can help to identify not only which features are most influential in the model, but also to understand the relative importance of different features in the decision-making process of the tree. In fact, the most dividing features would appear at the top and could be identified easily with other methods, but the feature importance metric allows to identify also less important features that are used for splitting in deeper levels of the tree and that have been used frequently.

==== Path to prediction 
<sub:dec-tree-path-to-prediction>
For a single instance is possible to trace the complete path from root to leaf and list all the comparisons (feature \<= threshold) that led to the prediction. This is a #strong[huge advantage for explainability] compared to #gls("black box") models. Every prediction is completely traceable locally.\
```
Istanza X predetta come "Sì" perché:
  - Age <= 35 ✓
  - Income > 50000 ✓
  - CreditScore <= 700 ✓
  → Foglia: Sì (95 istanze, 85 positive)
```

Questo è un #strong[vantaggio enorme per la spiegabilità] rispetto a
modelli \"scatola nera\". Ogni previsione è completamente tracciabile.




=== Explainability limitations
<sub:explainability-limitations-dec-tree>
=== Overfitting
<overfitting>
Il limite #strong[principale] degli alberi di decisione. Senza
controllo:

- L\'albero continua a dividersi fino a quando ogni foglia è pura (una
  sola classe)
- Su dataset piccoli, ogni campione potrebbe trovarsi in una foglia
  propria
- #strong[Risultato:] R² = 1.0 sul training set, ma pessimo su test set

#strong[Soluzioni:]

- #strong[Pruning:] rimuovere nodi che non migliorano significativamente
  la generalizzazione
- #strong[Limiti sulla crescita:] profondità massima, numero minimo di
  campioni per split, impurità minima per split
- #strong[Ensemble methods:] Random Forests e Gradient Boosting riducono
  l\'overfitting combinando più alberi

=== Instabilità
<instabilità>
Piccoli cambiamenti nei dati di training possono causare #strong[grandi
cambiamenti nella struttura dell\'albero]:

- Cambiare 1-2 campioni può portare a split completamente diversi
- L\'ordine dei campioni non importa, ma la composizione sì (alta
  varianza)

#strong[Conseguenza:] il modello è difficile da fidarsi se nuovi dati
sono appena diversi dal training

#strong[Soluzione:] ensemble methods mitigano questo problema

=== Relazioni Lineari
<relazioni-lineari>
Su pattern puramente lineari, gli alberi sono #strong[inefficienti]:

Esempio: $y = 2 x_1 + 3 x_2 + 1$

Un albero dovrà creare molti split ortogonali per approssimare la retta:

```
If x1 <= 5: ...
  If x2 <= 3: ...
    If x1 <= 4.5: ...
      ...
```

Mentre un modello lineare cattura la relazione con due coefficienti.

#strong[Risultato:] errore più alto, overfitting per compensare

=== Multicollinearità
<multicollinearità>
I decision tree sono #strong[meno sensibili] della regressione lineare a
feature correlate, ma non immuni:

- Tendono a #strong[scegliere una feature] del gruppo correlato (la
  \"prima\" a ridurre impurità)
- Ignor le altre, perdendo potenzialmente informazione complementare
- Se il dataset cambia leggermente, un\'altra feature potrebbe essere
  scelta, causando instabilità

#strong[Conseguenza:] modelli potenzialmente diversi su dataset simili



=== Limiti di Spiegabilità
<limiti-di-spiegabilità>
=== Alberi Complessi
<alberi-complessi>
Un albero con molti nodi (es. 100+ nodi) diventa #strong[difficile da
interpretare visualmente]:

- Non riesci più a tenere in mente l\'intero modello
- Le interazioni tra feature, sebbene catturate, non sono evidenti
- È ancora tracciabile per una singola istanza, ma difficile capire il
  \"ragionamento globale\" del modello

=== Interazioni tra Feature
<interazioni-tra-feature>
L\'albero cattura le interazioni (feature A influenza l\'effetto di
feature B), ma #strong[non le rende esplicite]:

- Una foglia raggiunta dopo split \[A \<= 5\] → \[B \> 10\] implica
  un\'interazione
- Ma non è ovvio dal grafico che A e B interagiscono
- Per modelli lineari, le interazioni sono esplicite se aggiunte
  manualmente

=== Bias verso Feature con Più Livelli
<bias-verso-feature-con-più-livelli>
I decision tree #strong[tendono a preferire feature categoriche con
molti valori unici], perché hanno più opportunità di split e quindi di
ridurre impurità:

Esempio: su dataset con una feature \"Città\" (100 città), l\'albero
potrebbe scegliere molteplici split su Città, mentre feature numeriche
continueranno a usare threshold.

#strong[Conseguenza:] un modello che sembra dipendere dalla Città,
quando in realtà potrebbe essere meno importante di un\'altra feature
meno \"versatile\".

#strong[Mitigation:] limitare la profondità e usare feature importance
ponderata.

=== Difficoltà nel Comunicare Probabilità Bassa
<difficoltà-nel-comunicare-probabilità-bassa>
Se una foglia predice \"Sì\" ma il 60% dei campioni sono \"No\", la
confidenza è 0.4.

Comunicare \"il modello dice Sì, ma con confidenza 0.6\" è meno
intuitivo che dire \"la probabilità stimata è 60%\" (come fa la
logistica).



=== Confronto con altri Algoritmi
<confronto-con-altri-algoritmi>
=== Vs. Modelli Lineari (LR, Logistica)
<vs-modelli-lineari-lr-logistica>
- #strong[Alberi:] catturano non linearità e interazioni, ma complessi e
  instabili
- #strong[Lineari:] trasparenti e stabili, ma rigidi
- #strong[Scelta:] dati con pattern complessi → alberi; dati lineari o
  quando interpretabilità è critica → modelli lineari

=== Vs. Ensemble Methods (Random Forests, Gradient Boosting)
<vs-ensemble-methods-random-forests-gradient-boosting>
- #strong[Singolo albero:] interpretabile, veloce, ma prone a
  overfitting
- #strong[Ensemble:] combina più alberi, miglior predizione e stabilità,
  ma meno interpretabile
- #strong[Trade-off:] interpretabilità vs accuratezza
- #strong[Quando usare:] per problemi critici dove performance conta più
  di interpretabilità → ensemble

=== Vs. SVM (Support Vector Machine)
<vs-svm-support-vector-machine>
- #strong[Alberi:] output naturale di classe/probabilità, tracciamento
  facile
- #strong[SVM:] output geometrico (margine), \"scatola nera\" per
  l\'interpretazione
- #strong[Trade-off:] SVM spesso migliore accuratezza su dati complessi,
  alberi più interpretabili

=== Vs. Neural Networks
<vs-neural-networks>
- #strong[Alberi:] interpretabili, nessun tuning di hyperparameter
  complicato
- #strong[Neural Networks:] capacità superiore su dati ad alta
  dimensionalità, ma \"scatola nera\"
- #strong[Trade-off:] alberi per dataset piccoli-medi e interpretabilità
  richiesta; NN per big data e quando l\'interpretabilità non è critica

=== Varianti Specializzate
<varianti-specializzate>
==== Alberi Potati
<alberi-potati>
Rimozione iterativa di nodi per ridurre overfitting:

- #strong[Cost-Complexity Pruning:] elimina nodi che non riducono
  significativamente l\'errore
- #strong[Reduced Error Pruning:] rimuove nodi usando un validation set

==== Extra Trees (Extremely Randomized Trees)
<extra-trees-extremely-randomized-trees>
Simile ai Decision Tree, ma sceglie split #strong[casualmente] invece di
deterministicamente. Veloce su dataset grandi, introduce varianza che
riduce overfitting su alcuni dataset.

==== Conditional Inference Trees
<conditional-inference-trees>
Alberi che utilizzano test statistici per la selezione di split, meno
biased verso feature con più livelli.
