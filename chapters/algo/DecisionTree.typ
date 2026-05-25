= Decision Tree (Albero di Decisione)
<decision-tree-albero-di-decisione>
== Modello
<modello>
Un albero di decisione è un modello che divide ricorsivamente lo spazio
dei dati in regioni rettangolari, creando una #strong[struttura
gerarchica di nodi decisionali].

=== Logica dell\'Algoritmo
<logica-dellalgoritmo>
L\'algoritmo costruisce l\'albero utilizzando un approccio
#strong[greedy dall\'alto verso il basso] (top-down):

+ Inizio con tutte le osservazioni nel nodo radice
+ Ad ogni nodo, scegliere la feature e il threshold che
  #strong[massimizzano la purezza] (classificazione) o
  #strong[minimizzano la varianza] (regressione)
+ Dividere ricorsivamente i nodi figli fino a criteri di stop
  (profondità massima, numero minimo di campioni, purezza perfetta)

Il risultato è una #strong[struttura ad albero] dove:

- #strong[Nodi interni:] contengono regole decisionali (feature \<=
  threshold?)
- #strong[Foglie:] contengono predizioni (classe o valore numerico)

=== Criteri di Split
<criteri-di-split>
==== Gini Index (Classificazione)
<gini-index-classificazione>
Misura la #strong[purezza di un nodo] per la classificazione:

$ upright("Gini") \( D \) = 1 - sum_(i = 1)^K p_i^2 $

Dove $p_i$ è la proporzione di istanze appartenenti alla classe $i$ nel
nodo.

- #strong[Gini = 0:] nodo puro (tutte le istanze della stessa classe)
- #strong[Gini = 1 - 1/K:] nodo completamente impuro (distribuito
  uniformemente)
- #strong[Per K=2 (binario):] massimo = 0.5

#strong[Information Gain:] al fare uno split, il guadagno è misurato
come la riduzione di Gini media pesata:

$ upright("IG") = upright("Gini") \( upright("padre") \) - sum_(upright("figlio")) frac(\| D_(upright("figlio")) \|, \| D \|) upright("Gini") \( upright("figlio") \) $

==== Entropia (Classificazione)
<entropia-classificazione>
Misura l\'#strong[incertezza informativa] di un nodo:

$ upright("Entropia") \( D \) = - sum_(i = 1)^K p_i log_2 \( p_i \) $

- #strong[Entropia = 0:] nodo puro
- #strong[Entropia = $log_2 \( K \)$:] nodo completamente impuro
- #strong[Per K=2:] massimo = 1

#strong[Information Gain (con Entropia):] il guadagno è la riduzione di
entropia:

$ upright("IG") = upright("Entropia") \( upright("padre") \) - sum_(upright("figlio")) frac(\| D_(upright("figlio")) \|, \| D \|) upright("Entropia") \( upright("figlio") \) $

#strong[Nota:] Gini e Entropia producono risultati simili in pratica;
Gini è computazionalmente più efficiente. L'Information Gain è usato nelle prime implementazioni di Decision Tree (CART).

==== Mean Squared Error (MSE) - Regressione
<mean-squared-error-mse---regressione>
Misura la #strong[varianza all\'interno di un nodo] per problemi di
regressione:

$ upright("MSE") \( D \) = frac(1, \| D \|) sum_(i = 1)^(\| D \|) \( y_i - macron(y) \)^2 $

Dove $macron(y) = frac(1, \| D \|) sum_(i = 1)^(\| D \|) y_i$ è la media
dei target nel nodo.

Lo split è scelto per #strong[minimizzare la somma pesata di MSE] nei
nodi figli.



== Complessità Computazionale
<complessità-computazionale>
=== Training (Costruzione dell\'Albero)
<training-costruzione-dellalbero>
La complessità dipende dalla #strong[profondità massima] dell\'albero e
dal numero di feature:

==== Nel caso generale:
<nel-caso-generale>
$ O \( n dot.op p dot.op log \( n \) dot.op d \) $

Dove:

- $n$ = numero di osservazioni
- $p$ = numero di feature
- $log \( n \)$ ≈ profondità dell\'albero (se bilanciato)
- $d$ = profondità effettiva (\<= $log \( n \)$ per albero bilanciato)

==== Nella pratica:
<nella-pratica>
- Per ogni nodo, scansionare tutte le $p$ feature
- Per ogni feature, ordinare i dati (o usare binning per velocizzare) →
  $O \( n log \( n \) \)$
- Questo accade ad ogni profondità dell\'albero
- Se l\'albero è bilanciato, profondità ≈ $log \( n \)$

==== Semplificazione:
<semplificazione>
Un albero completamente bilanciato ha complessità
#strong[$O \( n dot.op p dot.op log^2 \( n \) \)$]

#strong[Nota importante:] Un albero #strong[completamente sviluppato]
(no pruning) su n campioni può avere profondità fino a n (albero
degenerato a lista), con complessità $O \( n^2 dot.op p \)$ --- questo è
un limite teorico, ma dimostra il rischio di overfitting.

=== Inference (Previsione)
<inference-previsione>
$ O \( d \) $

Dove $d$ è la #strong[profondità dell\'albero]. Basta attraversare il
cammino dalla radice alla foglia.

- Per alberi bilanciati: $O \( log \( n \) \)$
- Per alberi degenerati: $O \( n \)$

=== Memoria
<memoria>
$ O \( n dot.op d + p \) $

- Memorizzazione dell\'albero stesso: proporzionale al numero di nodi
- In un albero bilanciato: $O \( n \)$ nodi nel peggiore,
  $O \( 2^d \) = O \( n \)$ nel medio
- Spazio per i dati di training: $O \( n dot.op p \)$

=== Considerazioni sulla Scalabilità
<considerazioni-sulla-scalabilità>
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



== Rappresentazione Interna
<rappresentazione-interna>
Un decision tree è rappresentato internamente come una #strong[struttura
ad albero ricorsiva]:

```
Nodo(feature=x1, threshold=5.5, left=Nodo(...), right=Nodo(...))
```

Ogni nodo contiene:

- #strong[Condizione:] quale feature e quale threshold
- #strong[Puntatori ai figli:] rami sinistro e destro
- #strong[Informazioni di predizione:] classe modale (classificazione) o
  valore medio (regressione)

=== Implicazioni per la Spiegabilità
<implicazioni-per-la-spiegabilità>
#strong[Vantaggi:]

- La struttura è #strong[completamente esplicita e navigabile]
- Ogni previsione ha un #strong[tracciamento completo]: seguire il
  cammino dalla radice alla foglia spiega perfettamente come è stata
  raggiunta
- Non esiste ambiguità o \"magia\": è una sequenza di confronti

#strong[Svantaggi:]

- #strong[Alberi profondi o complessi] diventano difficili da
  interpretare (decine o centinaia di nodi)
- Le interazioni tra feature sono #strong[implicite nella struttura]: se
  feature A e B interagiscono, l\'albero le cattura tramite split in
  serie, ma questo non è ovvio dal grafico
- #strong[Instabilità:] piccoli cambiamenti nei dati possono portare a
  strutture completamente diverse (vedi sezione Limiti)

Rispetto a modelli lineari (LR, logistica), la rappresentazione è
#strong[meno compatta ma più complessa].



== Vincoli sui Dati
<vincoli-sui-dati>
=== Dataset Bilanciato
<dataset-bilanciato>
I decision tree possono essere #strong[influenzati da classi
sbilanciate]:

- L\'algoritmo greedy tende a favorire split che massimizzano il puro
  della classe #strong[maggioritaria]
- Su un dataset con 95% negativi e 5% positivi, un albero potrebbe
  diventare molto profondo per catturare i pochi positivi
- #strong[Conseguenza:] scarsa capacità di classificazione sulla classe
  minoritaria (FN altissimi)

#strong[Soluzioni:]

- Assegnare #strong[pesi di classe] inversi alla frequenza
- Ricampionare (oversampling della classe rara, undersampling della
  maggioritaria)
- Usare metriche di valutazione appropriate (F1, non Accuracy)

=== Nessun Ulteriore Vincolo Strutturale
<nessun-ulteriore-vincolo-strutturale>
A differenza della regressione lineare e logistica, gli alberi di
decisione #strong[non hanno assunzioni] su:

- Linearità
- Normalità di distribuzioni
- Omoschedasticità
- Indipendenza di feature

Questo è un vantaggio (flessibilità), ma anche un rischio (overfitting
senza controllo).



== Capacità Predittive
<capacità-predittive>
=== Punti di Forza
<punti-di-forza>
- #strong[Pattern non lineari:] cattura relazioni complesse e non
  lineari che modelli lineari non vedono
- #strong[Interazioni automatiche:] le interazioni tra feature sono
  catturate naturalmente dalla struttura
- #strong[Feature categoriche:] gestisce feature categoriche senza
  necessità di encoding
- #strong[Nessuna assunzione:] nessun prerequisito su distribuzione o
  linearità dei dati

=== Punti di Debolezza
<punti-di-debolezza>
- #strong[Pattern lineari:] su dati puramente lineari, gli alberi sono
  #strong[inefficienti e imprecisi]

  - Avanzano tramite split ortogonali, creando funzioni a gradini
  - La predizione cambia bruscamente al passaggio di un threshold
  - Un modello lineare semplice avrebbe R² più alto con meno parametri

- #strong[Dati sparsi ad alta dimensionalità:] con molte feature e pochi
  campioni, il rischio di overfitting è massimo



== Metriche per la Confidenza
<metriche-per-la-confidenza>
=== Metriche di Classificazione
<metriche-di-classificazione>
Utilizza le stesse metriche della #strong[Regressione Logistica]:

- #strong[Confusion Matrix:] TP, TN, FP, FN
- #strong[Accuracy:] $\( T P + T N \) \/ \( T P + T N + F P + F N \)$
- #strong[Sensitivity / Recall:] $T P \/ \( T P + F N \)$
- #strong[Specificity:] $T N \/ \( T N + F P \)$
- #strong[Precision:] $T P \/ \( T P + F P \)$
- #strong[F1-Score:] media armonica di Precision e Recall
- #strong[ROC Curve e AUC:] trade-off tra TPR e FPR

=== Metriche di Regressione
<metriche-di-regressione>
Per alberi di regressione:

- #strong[MSE:] errore quadratico medio
- #strong[RMSE:] radice quadrata di MSE
- #strong[MAE:] errore assoluto medio
- #strong[R²:] frazione di varianza spiegata

=== Probabilità di Foglia (Confidence Score)
<probabilità-di-foglia-confidence-score>
Un vantaggio specifico degli alberi è che forniscono naturalmente una
#strong[stima di confidenza della previsione]:

$ upright("Confidence") = frac(\# upright("istanze della classe predetta nella foglia"), \# upright("istanze totali nella foglia")) $

Se una foglia contiene 100 campioni e 95 appartengono alla classe
positiva, la confidenza della previsione \"positivo\" è 0.95.

#strong[Utilizzo:] si può filtrare le predizioni per accuratezza:
accettare solo previsioni con confidenza \> 0.8.



== Metriche per la Comprensione e Spiegabilità
<metriche-per-la-comprensione-e-spiegabilità>
=== Visualizzazione dell\'Albero
<visualizzazione-dellalbero>
Il principale strumento è la #strong[visualizzazione grafica
dell\'albero]:

- Ogni nodo mostra la condizione di split e la distribuzione delle
  classi
- Foglie mostrano la previsione e il numero di campioni

#strong[Limite:] su alberi profondi (\>5-6 livelli), la visualizzazione
diventa illeggibile

=== Feature Importance
<feature-importance>
Misura quante volte una feature viene utilizzata come criterio di split
e quanto riduce l\'impurità media:

$ upright("Importance")_j = frac(sum_(upright("nodi con feature ") j) \( upright("IG")_(upright("nodo")) \) times \( upright("n campioni nodo") \) \/ n, upright("somma su tutti i nodi")) $

#strong[Interpretazione:] feature con importanza alta sono state
cruciali per le decisioni dell\'albero.

=== Spiegazione Locale (Path to Prediction)
<spiegazione-locale-path-to-prediction>
Per una singola istanza:

+ Tracciare il cammino dalla radice alla foglia
+ Elencare tutti i confronti (feature \<= threshold) che hanno
  determinato la previsione

#strong[Esempio:]

```
Istanza X predetta come "Sì" perché:
  - Age <= 35 ✓
  - Income > 50000 ✓
  - CreditScore <= 700 ✓
  → Foglia: Sì (95 istanze, 85 positive)
```

Questo è un #strong[vantaggio enorme per la spiegabilità] rispetto a
modelli \"scatola nera\". Ogni previsione è completamente tracciabile.



== Limiti di Predizione
<limiti-di-predizione>
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



== Limiti di Spiegabilità
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



== Confronto con altri Algoritmi
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



== Prompt
<prompt>
