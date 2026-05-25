= Random Forest
<random-forest>
== Modello
<modello>
=== Logica dell\'Algoritmo
<logica-dellalgoritmo>
Un #strong[Random Forest] è un #strong[ensemble method] (metodo di
insieme) che combina #strong[molteplici decision trees] per ottenere una
previsione finale migliore rispetto a un singolo albero.

#strong[Idea fondamentale:] ridurre l\'overfitting e l\'instabilità
degli alberi singoli tramite:

+ #strong[Bootstrap Aggregating (Bagging):] addestrare ogni albero su un
  campione bootstrap diverso dei dati
+ #strong[Feature Randomness:] ad ogni split, considerare solo un subset
  casuale di feature
+ #strong[Averaging/Voting:] combinare le previsioni di tutti gli alberi
  (media per regressione, majority voting per classificazione)

=== Procedura di Training
<procedura-di-training>
+ #strong[Per ogni albero $t$ da 1 a $T$ (numero di alberi, solitamente
  100-1000):]

  a. Creare un #strong[dataset bootstrap] $D_t$ campionando $n$ istanze
  #strong[con reinserimento] dai dati originali

  b. Addestrare un #strong[decision tree] su $D_t$ con i seguenti
  vincoli:

  - Ad ogni nodo, considerare solo $m_(upright("try")) = sqrt(p)$
    feature (per classificazione) o $m_(upright("try")) = p \/ 3$ (per
    regressione)
  - Crescere l\'albero #strong[completamente] (senza potatura) fino a
    purezza (overfitting è OK, verrà mitigato dal bagging)

+ #strong[Per la previsione:]

  - #strong[Classificazione:] far votare tutti gli alberi → classe
    finale = moda (più frequente)
  - #strong[Regressione:] far predire tutti gli alberi → valore finale =
    media

=== Motivazione Teorica
<motivazione-teorica>
#strong[Perché il Bagging funziona?]

Se abbiamo un modello con varianza alta (come un albero singolo),
combinare molti modelli indipendenti (addestrati su dataset diversi)
#strong[riduce la varianza]:

$ upright("Var") \( macron(X) \) = frac(upright("Var") \( X \), N) $

Se gli alberi fossero completamente indipendenti, la varianza della
media calerebbe di un fattore di $T$ (numero di alberi). In pratica non
sono indipendenti (correlati perché addestrati sugli stessi dati),
quindi la riduzione è minore, ma comunque significativa.

#strong[Perché la Randomness nelle Feature?]

Il termine $m_(upright("try"))$ introduce #strong[de-correlazione] tra
gli alberi:

- Se usassero tutte le feature, tutti gli alberi farebbero gli stessi
  split iniziali (molto correlati)
- Considerando solo $sqrt(p)$ feature casuali, alberi diversi imparano
  dipendenze diverse → sono meno correlati
- Alberi meno correlati → riduzione della varianza nel voting



== Complessità Computazionale
<complessità-computazionale>
=== Training
<training>
$ O \( T dot.op n log \( n \) dot.op p \) $

Dove:

- $T$ = numero di alberi (solitamente 100-1000, quindi fattore
  significativo)
- $n$ = numero di osservazioni
- $log \( n \)$ = profondità media di un albero bilanciato (senza
  potatura)
- $p$ = numero di feature (ma con feature randomness, solo $sqrt(p)$
  considerate)

#strong[Spiegazione:]

- Per ogni albero ($T$ iterazioni):
  - Creare bootstrap: $O \( n \)$
  - Trainare albero: $O \( n log \( n \) dot.op m_(upright("try")) \)$
    dove $m_(upright("try")) = sqrt(p)$ →
    $O \( n log \( n \) sqrt(p) \)$
- #strong[Total:] $O \( T dot.op n log \( n \) sqrt(p) \)$

=== Parallelizzazione
<parallelizzazione>
Random Forest è #strong[intrinsecamente parallelizzabile]:

- Ogni albero è indipendente → addestrare su processori diversi
- Con $K$ processori, speedup ≈ $K$ (idealmente)
- Pratica standard: usare tutti i core disponibili

=== Inference (Previsione)
<inference-previsione>
$ O \( T dot.op d \) $

Dove $d$ è la #strong[profondità media di un albero].

Per alberi non potati, $d approx log \( n \)$, quindi:

$ O \( T log \( n \) \) $

#strong[Confronto con singolo albero:] $O \( log \( n \) \)$ vs
$O \( T log \( n \) \)$ --- inference è più lenta di un albero singolo,
ma comunemente accettabile.

=== Memoria
<memoria>
$ O \( T dot.op n dot.op d \) $

Memorizzare $T$ alberi, ognuno con $O \( n \)$ nodi nel peggiore
(completo):

Per alberi bilanciati: $O \( T dot.op n \)$ (lineare in $T$).

=== Scalabilità: Conclusioni
<scalabilità-conclusioni>
#strong[Vantaggi:]

- Training scala bene con $n$ (logaritmico) e $p$ (sqrt)
- Parallelizzazione è naturale e efficiente
- Può gestire dataset molto grandi (milioni di istanze)

#strong[Svantaggi:]

- fattore $T$ (numero di alberi) aggiunge overhead
- Memoria cresce linearmente con $T$
- Per interpretabilità, $T$ grande rende difficile ispezionare

#strong[Pratica:] Random Forest è considerato uno dei migliori
compromessi tra performance e scalabilità, secondo solo ai metodi
gradient-based (Gradient Boosting, LightGBM) per dataset molto grandi.



== Rappresentazione Interna
<rappresentazione-interna>
=== Struttura del Modello
<struttura-del-modello>
Un Random Forest è rappresentato come:

```
Forest = [Tree_1, Tree_2, ..., Tree_T]

Dove ogni Tree_i è un Decision Tree completo (no pruning)
```

Internamente:

- #strong[T alberi indipendenti], ognuno con una struttura ricorsiva
  (nodo → split → figli)
- #strong[Ogni albero ha:] feature indice, threshold, puntatori ai
  figli, predizioni nelle foglie

=== Implicazioni per la Spiegabilità
<implicazioni-per-la-spiegabilità>
#strong[Contro:]

- #strong[Molto opaco globalmente:] con T = 100-500 alberi, è
  impossibile ispezionare manualmente il modello completo
- #strong[Difficile tracciare ragionamento:] non puoi seguire una
  singola catena di decisioni (ci sono 100 catene parallele)
- #strong[Aggregazione nascosta:] il voting/averaging che determina la
  previsione finale non è facilmente interpretabile

#strong[Pro:]

- #strong[Interpretabile localmente:] puoi estrarre il singolo albero
  più importante (quello che spiega meglio una previsione)
- #strong[Feature importance naturale:] misurata dalla riduzione di
  impurità media su tutti gli alberi
- #strong[Out-of-Bag (OOB) error:] stima di generalizzazione gratuita,
  senza bisogno di validation set separato

#strong[Confronto con altri modelli:]

- #strong[DT singolo:] interpretabile globalmente, ma instabile
- #strong[Random Forest:] opaco globalmente, ma stabile;
  interpretabilità per feature
- #strong[SVM:] completamente opaco, nessuna feature importance naturale



== Vincoli sui Dati
<vincoli-sui-dati>
=== Nessuna Assunzione Strutturale
<nessuna-assunzione-strutturale>
Come Decision Trees singoli, Random Forest #strong[non ha assunzioni]
su:

- Linearità
- Normalità
- Omoschedasticità
- Indipendenza (relativa)

=== Bilanciamento delle Classi
<bilanciamento-delle-classi>
Random Forest eredita il problema dei Decision Trees per #strong[classi
sbilanciate]:

- Il voting del majority può favorire la classe maggioritaria
- Su dataset 95% negativi / 5% positivi, il modello potrebbe predire
  sempre negativo

#strong[Soluzioni:]

- #strong[Class weights:] pesi inversi alla frequenza per ogni albero
- #strong[Stratified bootstrap:] assicurare che ogni bootstrap mantenga
  la proporzione di classi
- #strong[Threshold tuning:] non usare 50% come confine, usare una
  soglia ottimale

=== Feature di Tipi Diversi
<feature-di-tipi-diversi>
Random Forest gestisce #strong[feature categoriche e numeriche]
naturalmente:

- Non richiede encoding (come LR, LogR)
- Split su feature categoriche sono gestiti automaticamente
- Nessun vincolo di scala (a differenza di SVM)

=== Nessun Vincolo sulla Multicollinearità
<nessun-vincolo-sulla-multicollinearità>
A differenza di LR/LogR, Random Forest #strong[non è sensibile a
multicollinearità]:

- Se due feature sono correlate, l\'albero semplicemente ne usa una
- Non causa instabilità come nei modelli lineari



== Capacità Predittive
<capacità-predittive>
=== Punti di Forza
<punti-di-forza>
+ #strong[Eccellente Performance su Dati Reali]

  - Spesso outperform molti altri algoritmi su dataset variegati
  - Cattura pattern non lineari e interazioni naturalmente

+ #strong[Robusto a Outlier e Rumore]

  - Gli outlier influenzano alcuni alberi, non tutti
  - Voting/averaging mitiga l\'impatto

+ #strong[Gestisce Pattern Complessi]

  - Interazioni tra feature
  - Feature categoriche e numeriche miste
  - Relazioni non monotone

+ #strong[Riduce Overfitting dei Singoli Alberi]

  - Bagging + feature randomness mitiga fortemente l\'instabilità
  - Più stabile di un singolo albero

+ #strong[Feature Importance Nativa]

  - Misura diretta dell\'importanza di ogni feature
  - Utile per feature selection e interpretazione

+ #strong[Scalabilità]

  - Parallelizzabile
  - Gestisce dataset grandi

=== Punti di Debolezza
<punti-di-debolezza>
+ #strong[Interpretabilità Scarsa Globalmente]

  - Con 100-500 alberi, è impossibile ispezionare il modello
  - Black box dal punto di vista dell\'interpretazione globale

+ #strong[Sensibilità a Feature Dominanti]

  - Se una feature ha molte categorie, l\'albero può over-splitarvi
  - Bias verso feature ad alta cardinality (come DT singolo)

+ #strong[Memoria e Tempo di Inference]

  - Più lento di un singolo albero o di modelli lineari
  - Memoria proporzionale a T × dimensioni albero

+ #strong[Hyperparameter Tuning]

  - Parametri principali: T (numero alberi), max\_depth,
    min\_samples\_split, m\_try
  - Tuning male = performance ridotta

+ #strong[Predizione Non Probabilistica per Classificazione]

  - Output è probabilità (frazione di alberi che votano classe) --- non
    calibilata come LogR



== Metriche per la Confidenza
<metriche-per-la-confidenza>
=== Metriche di Classificazione Standard
<metriche-di-classificazione-standard>
Stesse metriche di altri classificatori:

- #strong[Confusion Matrix:] TP, TN, FP, FN
- #strong[Accuracy:] $\( T P + T N \) \/ \( T P + T N + F P + F N \)$
- #strong[Precision:] $T P \/ \( T P + F P \)$
- #strong[Recall/Sensitivity:] $T P \/ \( T P + F N \)$
- #strong[Specificity:] $T N \/ \( T N + F P \)$
- #strong[F1-Score:] media armonica di Precision e Recall
- #strong[ROC Curve e AUC:] trade-off tra TPR e FPR

=== Probabilità di Classe (Voting)
<probabilità-di-classe-voting>
Random Forest produce naturalmente #strong[probabilità della classe] per
classificazione:

$ P \( y = k \) = frac(upright("numero di alberi che votano classe ") k, T) $

#strong[Interpretazione:]

- Se 80 su 100 alberi votano \"Positivo\", $P \( y = 1 \) = 0.80$
- Questa è una #strong[stima di confidenza] della previsione

#strong[Caveat:] queste probabilità non sono ben calibrate (non
riflettono accuratezza vera come in LogR). Per probabilità calibrate,
usare Platt scaling o isotonic regression post-hoc.

=== Out-of-Bag (OOB) Error
<out-of-bag-oob-error>
Misura di validazione #strong[gratuita] senza validation set separato:

Per ogni istanza di training, gli alberi addestrati su bootstrap che
#strong[non contengono] quell\'istanza (out-of-bag) la predicono. OOB
error = errore medio su queste predizioni.

$ upright("OOB Error") = 1 / n sum_(i = 1)^n bb(1) \[ upright("predizione OOB")_i eq.not y_i \] $

#strong[Vantaggi:]

- Stima di generalizzazione senza bisogno di validation set
- Correlato con test error (anche se non identico)
- Utile per tuning di hyperparameter

=== Metriche di Regressione
<metriche-di-regressione>
Per regressione:

- #strong[Mean Squared Error (MSE):] $1 / n sum \( y_i - hat(y)_i \)^2$
- #strong[Root Mean Squared Error (RMSE):] $sqrt(M S E)$
- #strong[Mean Absolute Error (MAE):] $1 / n sum \| y_i - hat(y)_i \|$
- #strong[R²:] frazione di varianza spiegata
- #strong[OOB RMSE:] alternativa a cross-validation



== Metriche per la Comprensione e Spiegabilità
<metriche-per-la-comprensione-e-spiegabilità>
=== 1. Feature Importance (Impurità Media)
<1-feature-importance-impurità-media>
La metrica più importante di Random Forest per l\'interpretazione:

$ upright("Importance")_j = 1 / T sum_(t = 1)^T sum_(upright("nodi dove feature ") j upright(" fa split")) upright("IG")_(t \, upright("nodo")) $

Dove $upright("IG")$ è l\'#strong[information gain] (riduzione di
impurità).

#strong[Interpretazione:]

- Feature con importanza alta contribuiscono molto alle decisioni
- Ordinare per importanza identifica le feature più rilevanti
- Utile per feature selection e comunicazione ai non-esperti

#strong[Visualizzazione:] bar plot di feature ordinate per importanza.

=== 2. Feature Importance (Permutation-Based)
<2-feature-importance-permutation-based>
Alternativa al metodo di impurità:

- Permutare casualmente una feature nei dati di test
- Misurare il degrado in performance
- Grandi degradi = feature importante

#strong[Vantaggio:] meno biased verso feature ad alta cardinality (come
il metodo di impurità).

=== 3. Partial Dependence Plot (PDP)
<3-partial-dependence-plot-pdp>
Mostra come la previsione media varia al variare di una feature:

$ upright("PDP")_j \( x_j \) = 1 / n sum_(i = 1)^n hat(f) \( x_j \, x_(- j)^(\( i \)) \) $

Dove $x_(- j)^(\( i \))$ sono i valori di altre feature dall\'istanza i,
mantenendo $x_j$ fisso.

#strong[Visualizzazione:] linea o curva che mostra l\'effetto della
feature sulla previsione.

#strong[Caveat:] se la feature è correlata con altre, l\'effetto può
essere spurio.

=== 4. Individual Conditional Expectation (ICE) Plot
<4-individual-conditional-expectation-ice-plot>
Versione per-istanza di PDP:

- Mostrare come la previsione cambia al variare di una feature per
  singoli campioni
- Linee per campione (invece che media su tutti)

#strong[Utilità:] capire se l\'effetto di una feature è uniforme o varia
tra istanze.

=== 5. SHAP (SHapley Additive exPlanations)
<5-shap-shapley-additive-explanations>
Metodo avanzato per spiegabilità:

- Assegnare ogni output tra le feature usando valori Shapley dalla
  teoria dei giochi
- Applicabile a qualsiasi modello
- Produce spiegazioni teoricamente fondate

#strong[Vantaggio:] considerare interazioni e correlazioni tra feature.

=== 6. Single Tree Extraction
<6-single-tree-extraction>
Per una previsione specifica:

- Estrarre il singolo albero che ha la maggiore \"responsabilità\" della
  previsione
- Mostrare il cammino dalla radice alla foglia di quell\'albero
- Comunicare il ragionamento tramite quello specifico albero

#strong[Limite:] può essere fuorviante perché ignora il contributo degli
altri alberi.



== Limiti di Predizione
<limiti-di-predizione>
=== Sensibilità a Feature Dominanti
<sensibilità-a-feature-dominanti>
Come Decision Trees, Random Forest tende a preferire feature con
#strong[molte categorie o valori unici]:

- Feature categoriche con 100 valori vs feature numerica continua
- Questo bias persiste anche con feature randomness

#strong[Mitigazione:] usare permutation-based feature importance, che è
meno biased.

=== Difficoltà con Dati Molto Sbilanciati
<difficoltà-con-dati-molto-sbilanciati>
Se le classi sono estremamente sbilanciate (99% vs 1%):

- Il majority voting favorisce la classe maggioritaria
- Accuratezza può essere alta ma recall sulla classe rara bassa

#strong[Mitigazione:] usare class weights, stratified bootstrap, o
threshold tuning.

=== Scarsa Extrapolazione
<scarsa-extrapolazione>
Random Forest è un #strong[interpolatore locale]:

- Non può predire valori significativamente fuori dal range di training
- Per regressione, le predizioni rimangono nel range dei dati di
  training
- Non adatto per trend/trend extrapolation

=== Performance su Feature Numeriche Pure
<performance-su-feature-numeriche-pure>
Su dataset con solo feature numeriche e pattern lineare, modelli lineari
(LR) superano spesso Random Forest:

- RF \"impara\" la linearità tramite molti split ortogonali →
  inefficiente
- LR cattura la linearità con pochi parametri

=== Sensibilità a Iperparametri
<sensibilità-a-iperparametri>
Sebbene meno sensibile di SVM, Random Forest ha iperparametri critici:

- #strong[T (numero alberi):] troppo pochi = underfitting; non ha limite
  superiore strict
- #strong[max\_depth:] alberi troppo profondi = overfitting; troppo poco
  profondi = underfitting
- #strong[min\_samples\_split:] controlla quando smettere di splittare
- #strong[m\_try (feature per split):] influenza la diversità tra alberi



== Limiti di Spiegabilità
<limiti-di-spiegabilità>
=== Opacità Globale
<opacità-globale>
Con T = 100-500 alberi:

- #strong[Impossibile ispezionare manualmente] il modello completo
- Non puoi tracciare una singola sequenza di decisioni (ce ne sono T
  parallele)
- Il modello rimane una #strong[\"scatola nera\"] per la maggior parte
  degli utenti

#strong[Contrasto con DT singolo:] un albero piccolo è completamente
trasparente; un RF non lo è.

=== Interpretazione di Feature Importance Ambigua
<interpretazione-di-feature-importance-ambigua>
Feature importance (impurità) conta quante volte una feature fa split,
non necessariamente quanto sia causale:

- Una feature correlata ad un\'altra può avere bassa importanza se
  l\'altra è splittata per prima
- Importanza non implica causalità

#strong[Soluzione:] usare permutation-based importance (meno biased) o
SHAP.

=== Interazioni Non Esplicite
<interazioni-non-esplicite>
Random Forest cattura interazioni automaticamente (feature A influenza
come feature B splitta), ma:

- Le interazioni rimangono implicite nella struttura dell\'albero
- Difficile comunicare \"feature A e B interagiscono così\"

#strong[Soluzione:] usare SHAP per analizzare interazioni specifiche.

=== Dipendenza da Iperparametri
<dipendenza-da-iperparametri>
La spiegazione fornita da feature importance dipende da:

- max\_depth (alberi più profondi = più split su feature rare)
- m\_try (feature randomness influenza quali feature sono considerate)
- T (più alberi = più stabile, meno varianza)

Se si cambia iperparametri, feature importance cambia → spiegazione non
è robusta.

=== Difficoltà di Spiegazione per Non-Esperti
<difficoltà-di-spiegazione-per-non-esperti>
Comunicare il risultato di RF a un non-esperto richiede:

- Tradurre \"feature importance\" in linguaggio intuitivo
- Evitare di mostrare 100 alberi
- Usare visualizzazioni (SHAP, PDP) per semplificare



== Confronto con altri Algoritmi
<confronto-con-altri-algoritmi>
=== Vs. Decision Tree Singolo
<vs-decision-tree-singolo>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [DT Singolo], [Random Forest],),
    table.hline(),
    [#strong[Interpretabilità]], [⭐⭐⭐⭐⭐ Altissima], [⭐⭐ Bassa],
    [#strong[Overfitting]], [⭐⭐⭐⭐⭐ (alto)], [⭐ (basso, mitigato)],
    [#strong[Stabilità]], [⭐ (instabile)], [⭐⭐⭐⭐⭐ (stabile)],
    [#strong[Performance]], [⭐⭐⭐ Media], [⭐⭐⭐⭐⭐ Eccellente],
    [#strong[Scalabilità]], [⭐⭐⭐⭐ Buona], [⭐⭐⭐⭐ Buona
    (parallelizzabile)],
    [#strong[Quando usare]], [Max interpretabilità], [Quando performance
    conta],
  )]
  , kind: table
  )

=== Vs. Logistic Regression
<vs-logistic-regression>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [LogR], [Random Forest],),
    table.hline(),
    [#strong[Interpretabilità]], [⭐⭐⭐⭐ Alta], [⭐⭐ Bassa],
    [#strong[Performance Dati Lineari]], [⭐⭐⭐⭐⭐ Eccellente], [⭐⭐
    Inefficiente],
    [#strong[Performance Dati Non-Lineari]], [⭐ Scarsa], [⭐⭐⭐⭐⭐
    Eccellente],
    [#strong[Feature Categoriche]], [⭐ (richiede
    encoding)], [⭐⭐⭐⭐⭐ Naturale],
    [#strong[Quando usare]], [Pattern lineare +
    interpretabilità], [Pattern complesso, features miste],
  )]
  , kind: table
  )

=== Vs. SVM
<vs-svm>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [SVM], [Random Forest],),
    table.hline(),
    [#strong[Scalabilità]], [⭐⭐ Scarsa O(n³)], [⭐⭐⭐⭐ Buona],
    [#strong[Performance]], [⭐⭐⭐⭐ Buona], [⭐⭐⭐⭐⭐ Spesso
    migliore],
    [#strong[Interpretabilità]], [⭐⭐ Scarsa], [⭐⭐ Scarsa],
    [#strong[Hyperparameter Tuning]], [⭐⭐ Sensibile], [⭐⭐⭐ Meno
    sensibile],
    [#strong[Feature Importance]], [❌ No naturale], [✅ Sì, nativo],
    [#strong[Quando usare]], [Dati piccoli/medi stabili], [Dati grandi,
    performance critica],
  )]
  , kind: table
  )

=== Vs. Gradient Boosting
<vs-gradient-boosting>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [Gradient Boosting], [Random Forest],),
    table.hline(),
    [#strong[Performance]], [⭐⭐⭐⭐⭐ Spesso migliore], [⭐⭐⭐⭐
    Buona],
    [#strong[Velocità Training]], [⭐⭐ Lenta (sequenziale)], [⭐⭐⭐⭐
    Veloce (parallela)],
    [#strong[Hyperparameter Tuning]], [⭐ Difficile (molti
    parametri)], [⭐⭐⭐ Più semplice],
    [#strong[Risk Overfitting]], [⭐⭐ Alto], [⭐ Basso],
    [#strong[Quando usare]], [Massima performance (con
    tuning)], [Performance buona, implementazione semplice],
  )]
  , kind: table
  )

=== Vs. Neural Networks
<vs-neural-networks>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [Neural Networks], [Random Forest],),
    table.hline(),
    [#strong[Capacità]], [⭐⭐⭐⭐⭐ Illimitata], [⭐⭐⭐⭐ Molto
    buona],
    [#strong[Dati Necessari]], [⭐ Molto (milioni)], [⭐⭐⭐⭐ Meno
    (migliaia)],
    [#strong[Feature Importance]], [❌ Molto difficile], [✅ Nativa],
    [#strong[Interpretabilità]], [⭐ Nessuna], [⭐⭐ Poca],
    [#strong[Training]], [⭐⭐ Lungo, GPU-friendly], [⭐⭐⭐ Veloce,
    CPU],
    [#strong[Quando usare]], [Big data, no interpretabilità], [Medium
    data, need feature importance],
  )]
  , kind: table
  )



== Varianti e Estensioni
<varianti-e-estensioni>
=== 1. Extra Trees (Extremely Randomized Trees)
<1-extra-trees-extremely-randomized-trees>
Simile a Random Forest, ma con maggiore randomness:

- Split threshold è #strong[casuale] (non cerca il miglior threshold)
- Meno computazionalmente costoso (no search del threshold)
- Spesso produce alberi meno profondi e più generali
- Trade-off: performance leggermente minore, ma velocità molto maggiore

=== 2. Gradient Boosting (XGBoost, LightGBM, CatBoost)
<2-gradient-boosting-xgboost-lightgbm-catboost>
Evoluzione sequenziale di Random Forest:

- Anziché addestrare alberi in parallelo (indipendenti), li addestra in
  #strong[sequenza]
- Ogni albero corregge gli errori del precedente
- Spesso outperform RF, ma richiede tuning più accurato
- Più lento per training ma spesso migliore in performance

=== 3. Isolation Forest
<3-isolation-forest>
Specializzato per #strong[anomaly detection]:

- Alberi costruiti per isolare anomalie (non per classificazione
  regolare)
- Anomalie sono isolate in meno split rispetto a punti normali
- Veloce e efficiente per alta dimensionalità

=== 4. Random Forest per Regressione
<4-random-forest-per-regressione>
Applica la stessa logica ma:

- Predizione finale è #strong[media] (non voting)
- Feature importance basata su riduzione MSE (non impurità)
- Output naturalmente continuo



== Raccomandazioni Pratiche
<raccomandazioni-pratiche>
=== Quando Usare Random Forest
<quando-usare-random-forest>
✅ #strong[Ottime scelte:]

- Dataset di qualsiasi taglia (piccolo a medio)
- Pattern non lineari e complessi
- Necessità di feature importance
- Features miste (categoriche e numeriche)
- Quando interpretabilità non è critica ma performance sì

❌ #strong[Cattive scelte:]

- Massima interpretabilità richiesta (es. medicina regolata, finanza)
- Dati puramente lineari (LR è più efficiente)
- Inferenza in real-time su devices con risorse limitate (T alberi è
  lento)
- Quando è critico capire il \"perché\" di ogni singola previsione

=== Hyperparameter Tuning Consigliato
<hyperparameter-tuning-consigliato>
+ #strong[Numero di alberi (n\_estimators):]

  - Iniziare con 100-200
  - Aumentare fino a quando OOB error non migliora
  - Diminishing returns dopo 500-1000

+ #strong[Profondità massima (max\_depth):]

  - Iniziare senza limite (None), poi ridurre se overfitting
  - Tipicamente: 10-20 per dataset di taglia media

+ #strong[Min samples per split (min\_samples\_split):]

  - Default: 2 (troppo aggressivo)
  - Provare: 5, 10, 20
  - Aumentare per ridurre overfitting

+ #strong[Feature per split (max\_features):]

  - Classification: sqrt(p) (default, di solito ottimale)
  - Regressione: p/3 (default)
  - Provare: \'auto\', \'sqrt\', \'log2\'

+ #strong[Class weights (se classi sbilanciate):]

  - \'balanced\' per pesi automatici (inversi alla frequenza)

=== Miglior Pratica di Validazione
<miglior-pratica-di-validazione>
```
1. Dividere in train (70-80%), test (20-30%)
2. Training su train set con OOB error per validazione interna
3. Validare su test set separato
4. Cross-validation (5-10 fold) per più stabilità
```

=== Feature Engineering
<feature-engineering>
Random Forest è #strong[resistente a feature engineering scadente]:

- Non richiede scaling
- Gestisce feature categoriche automaticamente
- Non sensibile a feature correlate

Quindi focus su:

- Feature relevance (sono importanti per il problema?)
- Feature nuove (es. interazioni derivate manualmente) se performance
  non è suffisiente



== Prompt
<prompt>
