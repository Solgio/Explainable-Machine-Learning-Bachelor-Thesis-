= XGBoost: Extreme Gradient Boosting
<xgboost-extreme-gradient-boosting>
== Modello
<modello>
=== Logica dell\'Algoritmo
<logica-dellalgoritmo>
#strong[XGBoost] (Extreme Gradient Boosting) è un #strong[ensemble
method sequenziale] che costruisce alberi decisionali uno dopo l\'altro,
dove ogni nuovo albero #strong[corregge gli errori del precedente].

A differenza di #strong[Random Forest] (alberi paralleli indipendenti),
XGBoost è un #strong[boosting algorithm] che combina predizioni tramite:

$ hat(y)_i^(\( t \)) = hat(y)_i^(\( t - 1 \)) + f_t \( x_i \) $

Dove:

- $hat(y)_i^(\( t - 1 \))$ è la previsione cumulativa dopo t-1 alberi
- $f_t \( x_i \)$ è il nuovo albero che predice i residui
  dell\'iterazione precedente

=== Obiettivo Regolarizzato
<obiettivo-regolarizzato>
XGBoost minimizza un obiettivo di loss regolarizzato:

$ L \( phi.alt \) = sum_(i = 1)^n l \( hat(y)_i \, y_i \) + sum_(k = 1)^K Omega \( f_k \) $

Dove:

- Primo termine: #strong[loss function] (errore tra previsione e realtà)
- Secondo termine: #strong[regolarizzazione] che penalizza la
  complessità dell\'insieme di alberi

La regolarizzazione è:

$ Omega \( f \) = gamma T + 1 / 2 lambda \| \| w \| \|^2 $

Dove:

- $gamma T$ penalizza il numero di foglie (T)
- $1 / 2 lambda \| \| w \| \|^2$ penalizza la magnitudine dei pesi delle
  foglie

#strong[Interpretazione:] il termine di regolarizzazione preferisce
alberi semplici e pesi piccoli, #strong[riducendo overfitting].

=== Gradient Tree Boosting (Secondo Ordine)
<gradient-tree-boosting-secondo-ordine>
Anziché minimizzare direttamente, XGBoost usa un #strong[secondo-ordine
approximation] della loss:

$ L^(\( t \)) approx sum_(i = 1)^n [g_i f_t \( x_i \) + 1 / 2 h_i f_t^2 \( x_i \)] + Omega \( f_t \) $

Dove:

- $g_i = frac(partial l, partial hat(y)^(\( t - 1 \))) l \( y_i \, hat(y)^(\( t - 1 \)) \)$
  è il #strong[primo-ordine gradiente] (come in GBM standard)
- $h_i = frac(partial^2, partial^2 hat(y)^(\( t - 1 \))) l \( y_i \, hat(y)^(\( t - 1 \)) \)$
  è il #strong[secondo-ordine gradiente] (novità di XGBoost)

L\'uso del secondo-ordine consente un\'#strong[ottimizzazione più
accurata] rispetto a metodi che usano solo il primo-ordine.

=== Scoring Function per Split
<scoring-function-per-split>
Per una struttura d\'albero fissa, il #strong[quality score] è:

$ upright("Score") \( q \) = - 1 / 2 sum_(j = 1)^T frac(\( sum_(i in I_j) g_i \)^2, sum_(i in I_j) h_i + lambda) + gamma T $

Dove:

- $I_j$ è l\'insieme di istanze nella foglia j
- Questo score misura quanto una struttura d\'albero è \"buona\"
- Valori negativi più grandi (più negativi) = alberi migliori



== Complessità Computazionale
<complessità-computazionale>
=== Training (Esatto)
<training-esatto>
$ O \( K dot.op d dot.op n log \( n \) \) $

Dove:

- $K$ = numero di alberi (iterazioni)
- $d$ = profondità massima dell\'albero
- $n$ = numero di osservazioni
- $log \( n \)$ = sorting dei dati per trovare gli split

Per ogni albero, l\'algoritmo \"exact greedy\":

- Ordina i dati per feature: $O \( n log n \)$ once per feature
- Enumera split con accumulo di gradienti: $O \( n \)$

=== Training (Approssimato - con Quantile Sketch)
<training-approssimato---con-quantile-sketch>
$ O \( K dot.op d dot.op n \) $

Usando il #strong[weighted quantile sketch] (novità di XGBoost):

- Propone candidate split points in modo intelligent
- Non richiede sorting completo
- Ottimale per dataset out-of-core

=== Inference (Previsione)
<inference-previsione>
$ O \( K dot.op d \) $

Dove K è il numero di alberi, d la profondità media:

- Attraversare K alberi sequenzialmente
- Per ogni albero, seguire il cammino dalla radice alla foglia
  (profondità d)

=== Memoria
<memoria>
$ O \( K dot.op n dot.op d + upright("block structure") \) $

- Memorizzare K alberi: $O \( K dot.op n \)$ nel peggiore (tutte le
  istanze in ogni albero)
- Block structure per parallelizzazione: $O \( n \)$ aggiuntivo

=== Scalabilità: Conclusioni
<scalabilità-conclusioni>
#strong[Vantaggi rispetto a Random Forest:]

- #strong[Sequenziale è più efficiente:] ogni albero è costruito per
  correggere errori specifici
- #strong[Alberi più piccoli:] con boosting, alberi più shallow
  (tipicamente profondità 5-8) vs RF (profondità \<= n)
- #strong[Meno alberi necessari:] 100-500 alberi vs RF 1000+
- #strong[Out-of-core:] XGBoost supporta natively dati che non fit in
  memoria

#strong[Svantaggi:]

- #strong[Sequenziale:] training è sequenziale, non parallelizzabile
  come RF
- #strong[Sensibile ai parametri:] il tuning di learning rate, depth,
  regularization è critico

#strong[Trade-off:] XGBoost è \~10x più veloce di Random Forest per item
su dataset moderati (Chen & Guestrin, 2016).



== Rappresentazione Interna
<rappresentazione-interna>
=== Struttura del Modello
<struttura-del-modello>
XGBoost rappresenta internamente il modello come:

```
Ensemble = [Tree_1, Tree_2, ..., Tree_K]

Previsione = Σₖ f_k(x)

Dove ogni Tree_k è:
  - Struttura: split feature, threshold, default direction
  - Pesi: predizioni per ogni foglia
  - Gradienti: accumulati durante training
```

=== Differenze da Random Forest
<differenze-da-random-forest>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [Random Forest], [XGBoost],),
    table.hline(),
    [#strong[Alberi]], [Indipendenti, paralleli], [Sequenziali,
    dipendenti],
    [#strong[Costruzione]], [Campioni casuali (bootstrap)], [Su residui
    dell\'albero precedente],
    [#strong[Profondità]], [Spesso profonde (10-20)], [Solitamente basse
    (3-8)],
    [#strong[Numero]], [Tanti (500-2000)], [Meno (50-500)],
    [#strong[Pesi]], [Voting majority], [Somma pesata],
  )]
  , kind: table
  )

=== Implicazioni per la Spiegabilità
<implicazioni-per-la-spiegabilità>
#strong[Contro:]

- Ancora più opaca di RF (500 alberi è molto)
- L\'ordine degli alberi importa (sequenziale vs parallelo)
- Difficile tracciare quale albero ha causato una previsione

#strong[Pro:]

- Feature importance è più #strong[stabile] (alberi correlati meno che
  in RF)
- SHAP (sviluppato dagli stessi autori) è ottimizzato per XGBoost
- Ogni albero corrisponde a una \"correzione\" specifica di errori



== Vincoli sui Dati
<vincoli-sui-dati>
=== Nessuna Assunzione Strutturale
<nessuna-assunzione-strutturale>
Come Random Forest e Decision Trees, XGBoost #strong[non assume]:

- Linearità
- Normalità
- Omoschedasticità

=== Bilanciamento delle Classi
<bilanciamento-delle-classi>
XGBoost è #strong[più robusto] di DT singolo grazie alla
regolarizzazione, ma può comunque soffrire di classi sbilanciate:

#strong[Soluzioni:]

- #strong[Scale\_pos\_weight:] parametro che pesa la classe minoritaria
- #strong[Stratified k-fold:] durante cross-validation, mantenere
  proporzioni
- #strong[Threshold tuning:] non usare 0.5, usare soglia ottimale

=== Normalizzazione delle Feature
<normalizzazione-delle-feature>
A differenza di SVM, XGBoost #strong[non richiede] normalizzazione:

- Usa split basati su percentili (invariante a scala)
- Gestisce naturalmente feature con range diversi

=== Gestione di Dati Sparsi
<gestione-di-dati-sparsi>
#strong[Novità importante di XGBoost:] #strong[algoritmo sparsity-aware]

Quando una feature ha valore mancante:

- L\'istanza viene instradataad una #strong[default direction] (sinistra
  o destra)
- La default direction è #strong[imparata dai dati], non fissa
- Computazione è #strong[lineare nel numero di non-missing entries] (50x
  più veloce su dati sparsi)

=== Dati Ponderati
<dati-ponderati>
XGBoost supporta #strong[instance weights] tramite #strong[weighted
quantile sketch]:

- Calcola percentili ponderati (non solo uniforme)
- Teoricamente garantito a mantenere accuracy nei candidate splits



== Capacità Predittive
<capacità-predittive>
=== Punti di Forza
<punti-di-forza>
+ #strong[Eccellente Performance Generale]

  - Ha vinto 17 di 29 Kaggle competitions nel 2015
  - Spesso outperform altri metodi anche ensemble
  - Performance quasi universalmente buona su dati reali

+ #strong[Flessibile per Problemi Diversi]

  - Classificazione binaria e multi-classe
  - Regressione
  - Learning to Rank
  - Ranking object detection
  - Supporta custom loss functions

+ #strong[Robusto a Dati Imperfetti]

  - Gestisce missing values
  - Dati sparsi (one-hot encoding, etc.)
  - Classe sbilanciate (con tuning)
  - Outlier (soft-margin mitiga)

+ #strong[Pattern Non-Lineari e Interazioni]

  - Cattura relazioni complesse
  - Interazioni automatiche tra feature
  - Nessun feature engineering necessario (spesso)

+ #strong[Regolarizzazione Incorporated]

  - Riduce overfitting intrinsecamente
  - Non serve validation set separato per early stopping
  - Generalizza bene con pochi dati

=== Punti di Debolezza
<punti-di-debolezza>
+ #strong[Tuning Complesso]

  - Molti hyperparameter (learning rate, depth, lambda, gamma, etc.)
  - Sensibile al tuning
  - Default non sempre ottimali per il problema

+ #strong[Interpretabilità Scarsa]

  - 100-500 alberi è difficile da ispezionare
  - Feature importance non è univoca (molti metodi differenti)

+ #strong[Non Probabilistico Nativo]

  - Output è predizione, non probabilità calibrate
  - Per probabilità, usare sigmoid transformation

+ #strong[Sequenziale = Lento a Trainare]

  - Alberi dipendono dal precedente (non parallelizzabili)
  - Più lento di RF puro per training

+ #strong[Curva di Apprendimento Steep]

  - Molti parametri da capire
  - Documentazione densa
  - Non intuitivo come Decision Tree o LR



== Metriche per la Confidenza
<metriche-per-la-confidenza>
=== Metriche Standard di Classificazione
<metriche-standard-di-classificazione>
Stesse metriche di altri classificatori:

- #strong[Confusion Matrix:] TP, TN, FP, FN
- #strong[Accuracy:] $\( T P + T N \) \/ \( T P + T N + F P + F N \)$
- #strong[Precision, Recall, F1-Score:] standard
- #strong[ROC Curve e AUC:] trade-off tra TPR e FPR

=== Margin/Distance Score
<margindistance-score>
XGBoost produce un #strong[margin score] (somma dei contributi degli
alberi):

$ upright("margin")_i = sum_(k = 1)^K f_k \( x_i \) $

#strong[Interpretazione:]

- Valori più alti = più confidenza nella classe positiva
- Valori più bassi = più confidenza nella classe negativa
- Valori vicini a 0 = incertezza

=== Probabilità Calibrate (Sigmoid Transform)
<probabilità-calibrate-sigmoid-transform>
Per ottenere probabilità da margin score:

$ P \( y = 1 \| x \) = frac(1, 1 + exp \( - upright("margin") \)) $

=== Early Stopping e Monitoring
<early-stopping-e-monitoring>
XGBoost supporta #strong[early stopping] usando metriche di validazione:

- Monitor AUC, log-loss, RMSE su validation set
- Stop quando metrica non migliora per N iterazioni
- Previene overfitting automaticamente

#strong[Vantaggio:] non serve splitting train/val/test esplicito (uses
internal validation).



== Metriche per la Comprensione e Spiegabilità
<metriche-per-la-comprensione-e-spiegabilità>
=== 1. Feature Importance (Gain-Based)
<1-feature-importance-gain-based>
Misura la #strong[riduzione di loss media] dovuta a ogni feature:

$ upright("Importance")_j = 1 / K sum_(k = 1)^K upright("Gain")_j^(\( k \)) $

Dove $upright("Gain")_j^(\( k \))$ è la riduzione di loss totale quando
feature j fa split nell\'albero k.

#strong[Interpretazione:]

- Feature con gain alto sono \"importanti\" per il modello
- Somma a 100% (normalizzato)

#strong[Caveat:] misure gain possono essere biased verso feature ad alta
cardinality.

=== 2. Feature Importance (Split-Based)
<2-feature-importance-split-based>
Conta quante volte una feature è stata usata per split:

$ upright("Cover")_j = 1 / K sum_(k = 1)^K upright("# splits su feature ") j $

#strong[Interpretazione:] feature più frequenti sono considerate
\"importanti\".

=== 3. Feature Importance (SHAP)
<3-feature-importance-shap>
#strong[SHAP] (SHapley Additive exPlanations) è stato sviluppato
specificamente per XGBoost:

- Assegna ogni predizione tra le feature usando valori Shapley
- Teoricamente fondata (teoria dei giochi)
- Fornisce spiegazioni sia globali che locali
- XGBoost ha ottimizzazioni native per SHAP

#strong[Utilizzo:]

```
import shap
explainer = shap.TreeExplainer(xgboost_model)
shap_values = explainer.shap_values(data)
shap.summary_plot(shap_values, data)
```

=== 4. Partial Dependence Plot (PDP)
<4-partial-dependence-plot-pdp>
Mostra come la previsione media cambia al variare di una feature:

$ upright("PDP")_j \( x_j \) = 1 / n sum_(i = 1)^n hat(f) \( x_j \, x_(- j)^(\( i \)) \) $

#strong[Visualizzazione:] linea/curva che mostra relazione
feature-output.

=== 5. Individual Conditional Expectation (ICE)
<5-individual-conditional-expectation-ice>
Versione per-istanza di PDP:

- Linee separate per ogni campione
- Capire se l\'effetto è uniforme o varia

=== 6. Tree Visualization
<6-tree-visualization>
Per problemi specifici, è possibile visualizzare alberi individuali:

```python
import xgboost as xgb
xgb.plot_tree(model, num_trees=0)  # Plot primo albero
```

#strong[Limite:] con 500 alberi, visualizzare anche uno solo è
complesso.

=== 7. Explain Single Prediction (Contrastive)
<7-explain-single-prediction-contrastive>
Per una singola istanza, estrarre i contributi:

```python
import shap
explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X_instance)
shap.force_plot(explainer.expected_value, shap_values, X_instance)
```

Questo mostra:

- Valore base (expected value)
- Contributi positivi (push verso +)
- Contributi negativi (push verso -)



== Limiti di Predizione
<limiti-di-predizione>
=== Sensibilità al Tuning di Iperparametri
<sensibilità-al-tuning-di-iperparametri>
XGBoost ha #strong[molti iperparametri critici]:

+ #strong[learning\_rate] (eta): shrinkage dopo ogni albero

  - Piccolo (0.01-0.1) = più stabile, training più lungo
  - Grande (0.3-1.0) = convergenza veloce, rischio overfitting

+ #strong[max\_depth]: profondità massima alberi

  - 3-5: shallow, underfitting
  - 10-15: typical, balanced
  - 20+: deep, overfitting

+ #strong[min\_child\_weight]: istanze minime in foglia

  - Alto = underfitting, modello semplice
  - Basso = overfitting, modello complesso

+ #strong[gamma]: perdita minima per split

  - Alto = meno split (underfitting)
  - Basso = più split (overfitting)

+ #strong[lambda, alpha]: regolarizzazione L2, L1

  - Alto = coefficienti piccoli (underfitting)
  - Basso = coefficienti grandi (overfitting)

#strong[Problema:] combinazioni non-lineari. Tuning è un\'arte, non
scienza.

=== Difficoltà su Dati Lineari
<difficoltà-su-dati-lineari>
Se la vera relazione è lineare e semplice:

- LR è più efficiente (pochi parametri)
- XGBoost \"forza\" una soluzione tree-based (molti alberi per una
  retta)

=== Scarsa Generalizzazione con Molto Rumore
<scarsa-generalizzazione-con-molto-rumore>
Se il dataset ha very high noise-to-signal ratio:

- XGBoost potrebbe overfitting nonostante regolarizzazione
- Mitigare con higher lambda, lower learning rate

=== Extrapolazione Debole
<extrapolazione-debole>
Come Random Forest, XGBoost #strong[non extrapola:]

- Predizioni rimangono nel range osservato
- Non adatto per forecast trends



== Limiti di Spiegabilità
<limiti-di-spiegabilità>
=== Opacità della Struttura Sequenziale
<opacità-della-struttura-sequenziale>
Il fatto che ogni albero dipende dal precedente rende:

- Non chiaro quale albero \"causa\" una previsione
- Difficile tracciare il ragionamento passo per passo
- Un albero da solo potrebbe dare previsione completamente diversa

=== Interpretazione di Feature Importance Ambigua
<interpretazione-di-feature-importance-ambigua>
XGBoost ha #strong[tre metodi diversi] per feature importance (Gain,
Cover, Frequency):

- Possono dare ranking #strong[completamente diversi]
- Quale è \"giusto\"? Dipende dal caso d\'uso
- Nessuno è intrinsecamente \"corretto\"

=== Difficoltà di Comunicazione
<difficoltà-di-comunicazione>
Spiegare una previsione di XGBoost a non-esperti è difficile:

- \"Il modello è fatto di 200 alberi che si sommano\"
- Non è intuitive come \"se Feature A \> X allora Y\" (DT)
- Non è semplice come \"il coefficiente di A è 0.5\" (LR)

=== SHAP è Computazionalmente Costoso
<shap-è-computazionalmente-costoso>
SHAP è il metodo migliore per spiegare XGBoost, ma:

- Calcolo è O(K · 2^p) nel peggiore (exponential in \# features)
- Per 100+ features, diventa prohibitively slow
- TreeSHAP (ottimizzato) è più veloce ma comunque caro

=== Instabilità di Feature Importance
<instabilità-di-feature-importance>
Se parametri cambiano leggermente:

- Feature importance può cambiare drasticamente
- Spiegazioni non sono \"robuste\"



== Confronto con altri Algoritmi
<confronto-con-altri-algoritmi>
=== Vs. Random Forest
<vs-random-forest>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [Random Forest], [XGBoost],),
    table.hline(),
    [#strong[Velocità Training]], [Veloce (parallelo)], [Lento
    (sequenziale)],
    [#strong[Velocità Inference]], [Veloce], [Veloce],
    [#strong[Performance]], [⭐⭐⭐⭐ Buona], [⭐⭐⭐⭐⭐ Eccellente],
    [#strong[Overfitting]], [⭐⭐ Basso], [⭐ Basso ma sensibile
    tuning],
    [#strong[Interpretabilità]], [⭐⭐ Media], [⭐⭐ Media (ma con
    SHAP)],
    [#strong[Tuning]], [⭐⭐⭐ Semplice], [⭐ Complesso],
    [#strong[Quando usare]], [Velocità + buona performance], [Massima
    performance],
  )]
  , kind: table
  )

=== Vs. Logistic Regression
<vs-logistic-regression>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [LogR], [XGBoost],),
    table.hline(),
    [#strong[Interpretabilità]], [⭐⭐⭐⭐ Alta], [⭐⭐ Bassa],
    [#strong[Pattern Non-Lineare]], [⭐ Scarso], [⭐⭐⭐⭐⭐
    Eccellente],
    [#strong[Tuning]], [⭐⭐⭐ Semplice], [⭐ Complesso],
    [#strong[Scalabilità]], [⭐⭐⭐⭐ Buona], [⭐⭐⭐ Media],
    [#strong[Dati Rari]], [⭐⭐⭐⭐ Buono], [⭐⭐⭐ Buono (needs
    tuning)],
    [#strong[Quando usare]], [Interpretabilità + baseline], [Performance
    è prioritario],
  )]
  , kind: table
  )

=== Vs. Neural Networks
<vs-neural-networks>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [Neural Networks], [XGBoost],),
    table.hline(),
    [#strong[Capacità]], [⭐⭐⭐⭐⭐ Illimitata], [⭐⭐⭐⭐ Molto
    buona],
    [#strong[Dati Necessari]], [⭐ Molti (milioni)], [⭐⭐⭐⭐ Meno
    (migliaia)],
    [#strong[Training]], [⭐⭐ Lungo], [⭐⭐⭐ Veloce],
    [#strong[Interpretabilità]], [⭐ Nessuna], [⭐⭐ SHAP disponibile],
    [#strong[Quando usare]], [Big data + pattern visivo], [Structured
    data + performance],
  )]
  , kind: table
  )

=== Vs. LightGBM / CatBoost
<vs-lightgbm--catboost>
#strong[LightGBM] (Light Gradient Boosting Machine):

- Simile a XGBoost ma con #strong[histogram-based split] finding
- \~2x più veloce di XGBoost
- Più basso memoria
- Meno maturo (comunità più piccola)

#strong[CatBoost] (Categorical Boosting):

- Specializzato in dati categorici
- Gestisce nativamente categorie senza encoding
- Meno tuning necessario (default migliori)
- Performance leggermente superiore a XGBoost su dati categorici

#strong[Confronto:]

#figure(
  align(center)[#table(
    columns: 4,
    align: (auto,auto,auto,auto,),
    table.header([Aspetto], [XGBoost], [LightGBM], [CatBoost],),
    table.hline(),
    [#strong[Velocità]], [⭐⭐⭐⭐], [⭐⭐⭐⭐⭐], [⭐⭐⭐⭐],
    [#strong[Performance]], [⭐⭐⭐⭐⭐], [⭐⭐⭐⭐⭐], [⭐⭐⭐⭐⭐],
    [#strong[Tuning Facile]], [⭐⭐], [⭐⭐⭐], [⭐⭐⭐⭐],
    [#strong[Dati Categorici]], [⭐⭐], [⭐⭐⭐], [⭐⭐⭐⭐⭐],
    [#strong[Comunità]], [⭐⭐⭐⭐⭐], [⭐⭐⭐⭐], [⭐⭐⭐],
    [#strong[Stabilità]], [⭐⭐⭐⭐⭐], [⭐⭐⭐⭐], [⭐⭐⭐],
  )]
  , kind: table
  )



== Varianti e Estensioni
<varianti-e-estensioni>
=== 1. XGBoost Rank (Learning to Rank)
<1-xgboost-rank-learning-to-rank>
Specializzato per problemi di ranking:

- Ottimizza NDCG, MAP, ecc.
- Usato in search engines, ad ranking
- Gestisce query groups

=== 2. XGBoost GPU
<2-xgboost-gpu>
Supporto nativo per GPU NVIDIA (CUDA):

- \~10x più veloce di CPU
- Per dataset molto grandi
- Richiede GPU con memoria sufficiente

=== 3. XGBoost per Distributed Training
<3-xgboost-per-distributed-training>
- #strong[Spark integration:] XGBoost su Spark cluster
- #strong[Hadoop/MPI:] per distributed environments
- #strong[Dask:] per parallel computing su CPU

=== 4. Dart (Dropouts Meet Multiple Additive Regression Trees)
<4-dart-dropouts-meet-multiple-additive-regression-trees>
Variante di XGBoost che usa #strong[dropout] (come neural networks):

- Droppa (scarta) alberi randomicamente durante training
- Riduce correlazione tra alberi
- Spesso migliore performance, specialmente su dataset piccoli

=== 5. Linear Booster
<5-linear-booster>
Anziché tree boosting, usa #strong[regressione lineare] a ogni step:

- Più semplice e interpretabile
- Più veloce
- Per pattern principalmente lineari



== Raccomandazioni Pratiche
<raccomandazioni-pratiche>
=== Quando Usare XGBoost
<quando-usare-xgboost>
✅ #strong[Ottime scelte:]

- Competizioni di ML (Kaggle, ecc.)
- Strutured tabular data (no immagini/testo)
- Necessità di performance massima
- Dataset da migliaia a milioni di righe
- Mix di feature categoriche e numeriche
- Dati sparsi (one-hot encoding, ecc.)

❌ #strong[Cattive scelte:]

- Testo/immagini (usare Deep Learning)
- Massima interpretabilità richiesta (usare LR o DT)
- Real-time inference su edge devices (slow inference)
- Dataset piccolissimi (\< 1000 righe, rischio overfitting)
- Dati molto rumorosi (difficile tunare)

=== Workflow Consigliato
<workflow-consigliato>
```
1. BASELINE: Train LR o DT semplice
   ↓
2. PARAMETER TUNING: Grid search / Random search / Bayesian
   - Iniziare con default: learning_rate=0.1, max_depth=6, lambda=1
   - Tuning in ordine: learning_rate → max_depth → lambda/alpha
   ↓
3. VALIDATION: Usare 5-10 fold cross-validation
   ↓
4. MONITORING: Watch AUC/RMSE su validation set
   - Early stopping quando validation metric plateaus
   ↓
5. INTERPRETATION: Usare SHAP per understand feature importance
```

=== Hyperparameter Tuning Dettagliato
<hyperparameter-tuning-dettagliato>
==== Step 1: Learning Rate e Number of Rounds
<step-1-learning-rate-e-number-of-rounds>
```python
# First: find good number of trees with default learning rate
xgb_params = {
    'eta': 0.1,
    'max_depth': 6,
    'min_child_weight': 1,
    'gamma': 0,
    'lambda': 1,
    'alpha': 0
}
# Train con early stopping, find best num_rounds
```

==== Step 2: Tree Depth e Min Child Weight
<step-2-tree-depth-e-min-child-weight>
```python
# Grid search over depth e min_child_weight
depths = [3, 5, 7, 9]
min_child_weights = [1, 3, 5, 7]
# Risultato: profondità tipicamente 5-8, min_child 1-3
```

==== Step 3: Regolarizzazione (Lambda, Alpha)
<step-3-regolarizzazione-lambda-alpha>
```python
# Una volta trovati depth e learning_rate
# Tuare lambda (L2) e alpha (L1)
lambdas = [0.1, 1, 10, 100]
alphas = [0, 0.1, 1, 10]
```

==== Step 4: Column Subsampling
<step-4-column-subsampling>
```python
# Ridurre numero di feature per split
# Aiuta con overfitting
colsample_bytree = [0.5, 0.7, 1.0]
colsample_bylevel = [0.5, 0.7, 1.0]
```

=== Feature Engineering Minimo Necessario
<feature-engineering-minimo-necessario>
XGBoost è #strong[robusto a feature engineering scadente], ma alcuni
trucchi aiutano:

+ #strong[One-hot Encoding] per categoriche (XGBoost le gestisce, ma
  sparsity-aware accelera)
+ #strong[Log Transform] per feature long-tailed (es. income)
+ #strong[Interaction Features] (a volte aiuta): $x_1 times x_2$
+ #strong[Polynomial Features] (raramente necessario)

#strong[In generale:] meno feature engineering, meglio è. Lasciar
decidere a XGBoost.

=== Debugging Overfitting
<debugging-overfitting>
Se il modello overfits (validation error cresce):

```
→ Aumentare lambda (L2 regolarizzazione)
→ Diminuire learning_rate
→ Ridurre max_depth
→ Aumentare min_child_weight
→ Aggiungere column/row subsampling
→ Aumentare gamma
→ Usare early stopping più aggressivo
```

=== Debugging Underfitting
<debugging-underfitting>
Se il modello underfits (training error alto):

```
→ Diminuire lambda
→ Aumentare learning_rate
→ Aumentare max_depth
→ Diminuire min_child_weight
→ Aumentare numero di rounds
→ Disabilitare early stopping (train longer)
```



== Considerazioni Etiche e Normative
<considerazioni-etiche-e-normative>
=== GDPR Right to Explanation
<gdpr-right-to-explanation>
XGBoost è un #strong[black-box model] in contesti sensibili (credito,
assicurazione):

- Necessaria spiegabilità per ogni decisione
- Usare SHAP per soddisfare requisiti GDPR
- Documentare feature importance

=== Fairness e Bias
<fairness-e-bias>
Controllare per bias rispetto a protected attributes:

- Gender, Race, Age, etc.
- Usare fairness metrics (disparate impact ratio, etc.)
- Monitor SHAP values per protected groups



== Prompt
<prompt>
