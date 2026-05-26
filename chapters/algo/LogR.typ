#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../../config/thesis-config.typ": side_by_side
== Logistic regression
<cap:logistic-regression>
=== Mathematical model
<sub:model-logr>
The logistic regression is a model mainly used for binary classification problems where the response variable is dichotomous. Similar to linear regression(@cap:linear-regression) it uses a linear combination of the input features, but instead of directly outputting a continuous value, it applies a logistic function to map the output to a probability between 0 and 1.

$ sigma \( z \) = frac(1, 1 + exp \( - z \)) $

The output can consequently be interpreted as the probability that the input instance belongs to the positive class (y = 1). In particular, the probability that an instance belongs to the positive class is given by:

$ P \( y^(\( i \)) = 1 \| x^(\( i \)) \) = frac(1, 1 + exp \( - \( beta_0 + sum_(j = 1)^p beta_j x_j^(\( i \)) \) \)) $

And the probability that it belongs to the negative class (y = 0) is 
$P \( y^(\( i \)) = 0 \) = 1 - P \( y^(\( i \)) = 1 \)$, following the Bernoulli distribution.

The goal of the logistic regression is to find the parameters $beta$ that best fit the data, which is done by maximizing the *likelihood* of observing the data given the parameters.

$ L \( beta ; y \, X \) = product_(i = 1)^n P \( y^(\( i \)) = 1 \)^(y^(\( i \))) dot.op \( 1 - P \( y^(\( i \)) = 1 \) \)^(1 - y^(\( i \))) $

For numerical stability #strong[log-likelihood] is usually calculated:

$ ell \( beta \) = sum_(i = 1)^n [y^(\( i \)) log \( P \( y^(\( i \)) = 1 \) \) + \( 1 - y^(\( i \)) \) log \( 1 - P \( y^(\( i \)) = 1 \) \)] $
Differently from linear regression, the logistic regression does not have a closed-form solution for the parameters that maximize the likelihood so only iterative optimization algorithms like #gls("gradient descent") are available

=== Time complexity
<sub:time-complexity-logr>
As described in @sub:time-complexity-lr, the time complexity of #gls("gradient descent") is $O \( p n \)$ per iteration, and the number of iterations required for convergence can vary depending on the learning rate and the specific dataset. For *inference* the time complexity is again, $O(p)$ per instance. \
Since the optimization is iterative, the overall time complexity can be less predictable than linear regression, especially if the data has features that lead to slow convergence (e.g., highly correlated features or features that cause the decision boundary to be close to the data points). However, in practice, logistic regression is often computationally efficient for moderate-sized datasets and can be scaled to larger datasets using #gls("stochastic gradient descent") or mini-batch gradient descent.

=== Spacial complexity
<sub:spacial-complexity-logr>
The model stores a vector of coefficients $beta$ of size $p$, which requires $O \( p \)$ memory. During training, additional memory is needed to store the intermediate values for the optimization algorithm, which can be $O \( n \)$ for batch gradient descent due to the need to compute the predictions for all instances in each iteration. \
For inference, the memory complexity is $O \( p \)$ for storing the coefficients and $O \( 1 \)$ for the input instance, leading to an overall spacial complexity of $O \( p \)$.

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
For identifying anomalys in the other assumptions, plot visualitation can be used. See @sub:diagnostic-plots-logr for more details.


=== Predictive performance and limitations
<sub:predictive-performance-and-limitations-logr>
The imposed assumptions of logistic regression can lead to good performance whenever this assumptions are met. The probabilistic interpretation gives insight on the confidence of the prediction, which is a significant advantage in many applications. \
When the relationships are more complex than basic linear combinations, the predictions become less accurate. In context of unbalanced classes the training process can be dominated by the majority class, leading to poor performance on the minority class. Additionally, logistic regression as the linear regression is highly influenced by outliers, leading to very unstable predictions. 
=== Punti di Forza
<punti-di-forza>
- #strong[Output probabilistico:] diversamente da un classificatore
  duro, fornisce una stima di confidenza della previsione
- #strong[Efficienza computazionale:] training veloce anche su dataset
  moderatamente grandi
- #strong[Interpretabilità:] i pesi, sebbene moltiplicativi, rimangono
  interpretabili
- #strong[Linearità decisionale:] il confine decisionale è una retta (in
  2D) o iperpiano (in p-D)

=== Punti di Debolezza
<punti-di-debolezza>
- #strong[Non cattura non linearità:] come LR, pattern non lineari
  complessi rimangono invisibili al modello
- #strong[Sensibile a separazione completa:] diverge numericamente se
  esiste una feature \"perfetta\"
- #strong[Interazioni nascoste:] effetti di feature che dipendono l\'uno
  dall\'altro rimangono invisibili



== Metriche per la Confidenza
<metriche-per-la-confidenza>
=== Metriche Pure
<metriche-pure>
==== Confusion Matrix (Matrice di Confusione)
<confusion-matrix-matrice-di-confusione>
Confronta le classi reali con quelle predette, generando 4 categorie:

- #strong[TP (True Positives):] previsione positiva corretta
- #strong[TN (True Negatives):] previsione negativa corretta
- #strong[FP (False Positives):] errore di tipo I, previsione positiva
  errata
- #strong[FN (False Negatives):] errore di tipo II, previsione negativa
  errata

==== Accuracy
<accuracy>
Frazione di previsioni corrette:

$ A C C = frac(T P + T N, T P + T N + F P + F N) $

#strong[Limite:] metrica misleading se le classi sono sbilanciate. Un
classificatore che sempre predice la classe maggioritaria avrà accuracy
alta

==== Sensitivity (Recall / True Positive Rate)
<sensitivity-recall--true-positive-rate>
Frazione di positivi correttamente identificati:

$ S e n s = frac(T P, T P + F N) $

Risponde: \"Su tutti i veri positivi, quanti abbiamo identificato?\"

==== Specificity (True Negative Rate)
<specificity-true-negative-rate>
Frazione di negativi correttamente identificati:

$ S p e c = frac(T N, T N + F P) $

Risponde: \"Su tutti i veri negativi, quanti abbiamo identificato?\"

==== Precision
<precision>
Frazione di previsioni positive corrette:

$ P R E C = frac(T P, T P + F P) $

Risponde: \"Tra tutte le istanze che abbiamo predetto come positive,
quante sono veramente positive?\"

==== Recall
<recall>
Alias per Sensitivity:

$ R E C = frac(T P, T P + F N) $

==== F1-Score
<f1-score>
Media armonica tra Precision e Recall, utile quando si vuole bilanciare
i due:

$ F 1 = 2 frac(P R E C dot.op R E C, P R E C + R E C) $

#strong[Quando usarlo:] quando le classi sono sbilanciate e sia falsi
positivi che falsi negativi hanno costo significativo

==== ROC Curve e AUC
<roc-curve-e-auc>
#strong[ROC Curve:] rappresentazione grafica del trade-off tra True
Positive Rate (Sensitivity) sull\'asse y e False Positive Rate (1 -
Specificity) sull\'asse x, al variare del threshold di classificazione.

- #strong[Modello ideale:] curva passa per il punto (0,1) in alto a
  sinistra
- #strong[Modello casuale:] curva segue la diagonale (AUC = 0.5)

#strong[AUC (Area Under the Curve):] area sotto la ROC curve, quantifica
la capacità globale del modello di discriminare tra le classi

- #strong[AUC = 1.0:] discriminazione perfetta
- #strong[AUC = 0.5:] modello casuale
- #strong[AUC \< 0.5:] peggio del caso

AUC è #strong[invariante al threshold], quindi è preferibile ad Accuracy
per valutazioni comparative.

==== Z-Statistic e p-value
<z-statistic-e-p-value>
Analogo della t-statistic in LR, misura la significatività statistica di
ogni coefficiente:

$ Z = frac(beta_j, S E \( beta_j \)) $

Dove $S E \( beta_j \)$ è l\'errore standard del coefficiente.

- #strong[Valori assoluti grandi di Z] → forte evidenza che il
  coefficiente è significativamente diverso da 0
- #strong[p-value associato] → probabilità di osservare Z così estremo
  sotto l\'ipotesi nulla ($beta_j = 0$)
- #strong[Convention:] p \< 0.05 indica significatività

==== Diagnostic plots
<sub:diagnostic-plots-logr>


== Metriche per la Comprensione e Spiegabilità
<metriche-per-la-comprensione-e-spiegabilità>
=== Effect Plot
<effect-plot>
Simile a LR, rappresenta l\'effetto di una feature sulla
#strong[probabilità predetta] (non sugli odds, che è più difficile da
interpretare).

Per ogni valore della feature, calcolare:

$ P \( y = 1 \| x_j = v \, x_(upright("other")) = upright("media") \) $

Il grafico mostra come la probabilità predetta varia col valore della
feature, mantenendo le altre feature ai loro valori medi.

#strong[Vantaggio rispetto a LR:] la trasformazione sigmoide rende
visibile se l\'effetto è principalmente presso certi valori della
feature (grafico non è una retta, è una curva).

=== Weight Plot (Coefficienti)
<weight-plot-coefficienti>
Analogo a LR, rappresenta graficamente i coefficienti $beta_j$ ordinati
per valore assoluto.

#strong[Caveat:] il valore di $beta_j$ non corrisponde direttamente a
una variazione di probabilità (è moltiplicativo sugli odds, non additivo
sulla probabilità). Quindi il grafico ha #strong[minore valore
interpretativo] che in LR.

=== Odds Ratio
<odds-ratio>
Espressione diretta dell\'impatto di una feature sugli odds:

$ upright("OR")_j = exp \( beta_j \) $

#strong[Interpretazione:] \"Aumentare feature $j$ di 1 unità moltiplica
gli odds per $upright("OR")_j$\"

Esempio: se $beta_j = 0.5$ e $upright("OR")_j = 1.65$, aumentare la
feature del 65% gli odds di appartenenza alla classe positiva.



== Limiti di Predizione
<limiti-di-predizione>
=== Non Linearità
<non-linearità>
Come LR, il modello non cattura pattern non lineari. La sigmoide è una
trasformazione \"accessoria\" che non supera questo limite.

=== Separazione Completa
<separazione-completa>
Se una feature separa perfettamente le classi, l\'algoritmo di
ottimizzazione #strong[diverge numericamente]: il coefficiente tende a
$+ oo$ o $- oo$. Soluzioni:

- Penalizzare i pesi (Ridge o Lasso logistica)
- Rimuovere la feature (ma significa perdere informazione)
- Usare Firth\'s bias-reduced logistic regression (metodo specializzato)

=== Overfitting
<overfitting>
Con un numero elevato di feature rispetto al numero di osservazioni
($p > > n$), il modello può facilmente sovradattarsi al training set.
Ridge o Lasso logistica riducono il rischio.

=== Sensibilità al Classe Sbilanciate
<sensibilità-al-classe-sbilanciate>
Il modello di default è addestrato minimizzando il likelihood globale.
Se una classe è molto rara (es. 1% positivi, 99% negativi), il modello
tenderà a predire sempre la classe maggioritaria. Soluzioni:

- Usare pesi di classe inversi alla frequenza (class weights)
- Ricampionare (oversampling della classe rara o undersampling della
  classe maggioritaria)
- Regolare il threshold di classificazione (non usare 0.5 di default)



== Limiti di Spiegabilità
<limiti-di-spiegabilità>
=== Interpretazione Moltiplicativa Complessa
<interpretazione-moltiplicativa-complessa>
A differenza di LR dove un coefficiente corrisponde a una variazione
additiva, qui $exp \( beta_j \)$ è moltiplicativo e non intuitivo per la
maggior parte degli utenti. Una feature che aumenta gli odds del 65% non
è semplice da comunicare rispetto a \"la previsione aumenta di 10
unità\".

=== Dipendenza dal Contesto
<dipendenza-dal-contesto>
L\'effetto di una feature sulla probabilità predetta #strong[dipende dai
valori di tutte le altre feature]. Per una feature, l\'aumento della
probabilità è maggiore quando le altre feature sono tali che la
probabilità predetta è intorno a 0.5 (dove la sigmoid è più ripida).
Questo rende difficile fornire una spiegazione \"universale\"
dell\'effetto di una feature.

=== Piccoli Coefficienti Difficili da Valutare
<piccoli-coefficienti-difficili-da-valutare>
Se $beta_j$ è piccolo (es. 0.01), l\'effetto
$exp \( 0.01 \) approx 1.01$ (aumento del 1%) è difficile da discernere
dalla variabilità naturale. Questo crea incertezza sull\'importanza
reale della feature.

=== Interazioni Nascoste
<interazioni-nascoste>
Se due feature hanno un effetto congiunto non additivo, il modello base
non lo cattura. Le interazioni devono essere introdotte manualmente, il
che aggiunge complessità nel comunicare i risultati.

== Prompt
<prompt>
