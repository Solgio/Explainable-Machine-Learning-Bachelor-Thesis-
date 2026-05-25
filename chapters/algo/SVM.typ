= Support Vector Machine (SVM)
<support-vector-machine-svm>
== Modello
<modello>
=== Logica dell\'Algoritmo
<logica-dellalgoritmo>
Un Support Vector Machine è un classificatore che cerca
l\'#strong[iperpiano ottimale] che separa due classi massimizzando il
#strong[margine] (distanza tra l\'iperpiano e i punti più vicini di
ciascuna classe).

Per dati bidimensionali è una retta, per dati tridimensionali è un
piano, per dati p-dimensionali è un #strong[iperpiano] definito da:

$ beta_0 + beta_1 x_1 + beta_2 x_2 + dots.h + beta_p x_p = 0 $

Dove $beta = \[ beta_1 \, . . . \, beta_p \]$ è il #strong[vettore
normale all\'iperpiano] (perpendicolare ad esso).

=== Hard-Margin SVM (Dati Linearmente Separabili)
<hard-margin-svm-dati-linearmente-separabili>
Nel caso ideale dove i dati sono #strong[perfettamente separabili],
l\'obiettivo è trovare i coefficienti
$beta_0 \, beta_1 \, . . . \, beta_p$ che massimizzano il
#strong[margine].

La condizione di separazione è:

$ y_i \( beta_0 + beta_1 x_(i 1) + beta_2 x_(i 2) + dots.h + beta_p x_(i p) \) gt.eq 1 quad forall i $

Dove $y_i in { - 1 \, + 1 }$ è l\'etichetta della classe.

La distanza tra un punto e l\'iperpiano è data da:

$ r_i = frac(y_i \( beta_0 + sum_(j = 1)^p beta_j x_(i j) \), \| \| beta \| \|) $

Dove $\| \| beta \| \| = sqrt(sum_(j = 1)^p beta_j^2)$ è la
#strong[norma euclidea] del vettore dei coefficienti.

Il #strong[margine] è la distanza minima tra l\'iperpiano e il punto di
training più vicino:

$ M = frac(1, \| \| beta \| \|) $

Per massimizzare il margine, è equivalente #strong[minimizzare]
$\| \| beta \| \|$, il che si formula come un problema di ottimizzazione
quadratica:

$ min_(beta \, beta_0) 1 / 2 \| \| beta \| \|^2 $

Soggetto al vincolo:

$ y_i (beta_0 + sum_(j = 1)^p beta_j x_(i j)) gt.eq 1 quad forall i = 1 \, . . . \, n $

#strong[Motivazione:] perché massimizzare il margine? L\'intuizione è
che un iperpiano con margine grande è più #strong[robusto] a variazioni
nei dati e generalizza meglio su dati non visti.

=== Soft-Margin SVM (Dati Non Separabili)
<soft-margin-svm-dati-non-separabili>
Nel caso realistico dove i dati #strong[non sono linearmente
separabili], permettere che alcuni punti violino il margine:

Si introducono #strong[variabili di slack] $xi_i gt.eq 0$ che misurano
quanto un punto viola il margine:

$ y_i (beta_0 + sum_(j = 1)^p beta_j x_(i j)) gt.eq 1 - xi_i quad forall i $

Il problema di ottimizzazione diventa:

$ min_(beta \, beta_0 \, xi) [1 / 2 \| \| beta \| \|^2 + C sum_(i = 1)^n xi_i] $

Dove:

- #strong[Primo termine:] penalità per complessità (piccoli coefficienti
  \= iperpiano semplice)
- #strong[Secondo termine:] penalità per violazioni del margine (ogni
  violazione costa $C dot.op xi_i$)
- #strong[Parametro C:] #strong[iperparametro di regolarizzazione] che
  controlla il trade-off tra:
  - Margine grande (coefficienti piccoli)
  - Permettere violazioni (perdita di training bassa)

#strong[Interpretazione di C:]

- #strong[C grande:] il modello penalizza fortemente le violazioni →
  addattamento ai dati di training (rischio overfitting)
- #strong[C piccolo:] il modello tollera violazioni → priorità al
  margine grande (rischio underfitting)

=== Kernel SVM (Trasformazione Non Lineare)
<kernel-svm-trasformazione-non-lineare>
Il limite principale di SVM lineare è che funziona solo se i dati sono
(approssimativamente) #strong[linearmente separabili]. Per dati con
pattern non lineari, SVM usa il #strong[kernel trick].

#strong[Idea:] trasformare i dati in uno spazio di dimensionalità
superiore (possibilmente infinita) dove diventano linearmente
separabili. Tuttavia, computare esplicitamente la trasformazione è
costoso. Il #strong[kernel trick] consente di fare questo
implicitamente.

==== Kernel Trick
<kernel-trick>
Anziché trasformare i dati esplicitamente
$phi.alt \( x_i \) = \[ f_1 \( x_i \) \, f_2 \( x_i \) \, . . . \, f_m \( x_i \) \]$
e poi calcolare prodotti scalari
$phi.alt \( x_i \)^T phi.alt \( x_j \)$, usiamo una #strong[funzione
kernel] che calcola direttamente il prodotto scalare nello spazio
trasformato:

$ K \( x_i \, x_j \) = phi.alt \( x_i \)^T phi.alt \( x_j \) $

Senza dover esplicitamente calcolare $phi.alt$.

==== Kernel Comuni
<kernel-comuni>
#strong[\1. Kernel Lineare]

$ K \( x_i \, x_j \) = x_i^T x_j $

Nessuna trasformazione; ritorna alla SVM lineare.

#strong[\2. Kernel Polinomiale]

$ K \( x_i \, x_j \) = \( x_i^T x_j + 1 \)^d $

Trasforma i dati in uno spazio di polinomi di grado $d$. Utile per
pattern polinomiali.

#strong[\3. Kernel RBF (Radial Basis Function - Gaussian)]

$ K \( x_i \, x_j \) = exp (- gamma \| \| x_i - x_j \| \|^2) $

Trasforma in uno spazio di dimensionalità infinita. È il kernel
#strong[più comunemente usato] perché:

- Molto flessibile, adatto a pattern complessi
- Un solo iperparametro $gamma$ (gamma) da tuning
- Buon compromesso tra complessità e performance

#strong[Interpretazione di $gamma$:]

- #strong[$gamma$ grande:] il kernel focalizza su punti molto vicini
  (può causare overfitting)
- #strong[$gamma$ piccolo:] il kernel considera punti lontani (più
  generale, rischio underfitting)

#strong[\4. Kernel Sigmoid]

$ K \( x_i \, x_j \) = tanh \( alpha x_i^T x_j + c \) $

Simile al kernel di una rete neurale. Meno comune.

==== Rappresentazione della Soluzione
<rappresentazione-della-soluzione>
La soluzione di SVM è rappresentata come una #strong[combinazione
lineare di prodotti kernel]:

$ f \( x \) = beta_0 + sum_(i = 1)^n alpha_i y_i K \( x \, x_i \) $

Dove:

- $alpha_i$ sono i #strong[coefficienti duali] (non direttamente i
  $beta_j$)
- Solo una #strong[frazione dei punti di training ha $alpha_i > 0$] ---
  questi sono i #strong[Support Vectors]

I support vectors sono i punti più informativi per la classificazione; i
punti \"facili\" (ben separati) hanno $alpha_i = 0$ e vengono ignorati.



== Complessità Computazionale
<complessità-computazionale>
=== Training
<training>
La complessità di training di SVM dipende dal metodo di ottimizzazione
usato:

==== Hard-Margin SVM (Lineare)
<hard-margin-svm-lineare>
$ O \( n^2 p \) upright(" a ") O \( n^3 p \) $

- Metodo #strong[Quadratic Programming (QP):] tipicamente
  $O \( n^2 p \)$ o $O \( n^3 \)$ per il solver
- Con $n$ = numero di campioni, $p$ = numero di feature
- La matrice del kernel è $n times n$, quindi operazioni quadratiche su
  essa

==== Soft-Margin SVM (con variabili di slack)
<soft-margin-svm-con-variabili-di-slack>
$ O \( n^2 p \) upright(" a ") O \( n^3 p \) $

Stessa complessità; la penalità $C$ non cambia la complessità
asintotica.

==== Kernel SVM
<kernel-svm>
$ O \( n^2 p \) upright(" a ") O \( n^3 \) $

Per kernel RBF, non è necessario calcolare esplicitamente $phi.alt$
(dimensioni potenzialmente infinite):

- Calcolo della matrice kernel: $O \( n^2 p \)$ (comparare ogni coppia
  di punti)
- Solver QP: $O \( n^3 \)$
- #strong[Total:] $O \( n^3 \)$ (dominato dal solver)

==== Ottimizzazioni Pratiche
<ottimizzazioni-pratiche>
Per dataset #strong[grandi] (n \>\> 10.000), i solver standard diventano
intractabili. Soluzioni:

+ #strong[Stochastic Gradient Descent (SGD) SVM:] O(n p) ma con più
  iterazioni
+ #strong[Online SVM:] aggiorna in streaming
+ #strong[Approximate solutions:] vincolamenti per ridurre n
+ #strong[Distributed training:] parallelizzazione su cluster

=== Inference (Previsione)
<inference-previsione>
$ O \( m dot.op p \) $

Dove $m$ è il #strong[numero di support vectors] ($m lt.eq n$).

La previsione richiede:

$ f \( x_(upright("new")) \) = beta_0 + sum_(i in S V) alpha_i y_i K \( x_(upright("new")) \, x_i \) $

Se il modello ha molti support vectors ($m approx n$), inference diventa
lenta. Se $m lt.double n$ (case ideale), inference è veloce.

=== Memoria
<memoria>
$ O \( n^2 + m dot.op p \) $

- Matrice kernel: $O \( n^2 \)$
- Coefficienti: $O \( m \)$ (support vectors) + $O \( p \)$ (per ogni
  kernel non lineare)

Per dataset molto grandi, la memoria della matrice kernel può essere
#strong[proibitiva].

=== Scalabilità: Conclusioni
<scalabilità-conclusioni>
- #strong[Training:] cubic in n --- #strong[critico per dataset grandi]

  - Per n \> 100.000, impraticabile senza approssimazioni
  - Per n \< 10.000, ragionevole

- #strong[Inference:] dipende da m (numero support vectors)

  - Se m è piccolo: veloce
  - Se m ≈ n: lento

- #strong[Memoria:] proibitiva per dataset enormi (n \> 1M)



== Rappresentazione Interna
<rappresentazione-interna>
=== Struttura del Modello
<struttura-del-modello>
La rappresentazione interna di SVM è:

```
Support Vectors: [x₁, x₂, ..., xₘ] (sottinsieme di n punti di training)
Coefficienti: [α₁, α₂, ..., αₘ] e β₀
Kernel: K(·, ·) (funzione)

Previsione: f(x) = β₀ + Σᵢ αᵢ yᵢ K(x, xᵢ)
```

=== Implicazioni per la Spiegabilità
<implicazioni-per-la-spiegabilità>
#strong[Contro:]

- La previsione dipende da un #strong[subset arbitrario] di punti di
  training (support vectors)
- Non è immediatamente chiaro #strong[perché] un particolare punto è un
  support vector
- Per kernel non lineari (es. RBF), la trasformazione $phi.alt$ è
  implícita e non visualizzabile (dimensioni infinite)
- L\'interpretazione di $alpha_i$ non è intuitiva: non corrisponde
  direttamente a \"importanza\" della feature

#strong[Pro:]

- Almeno i #strong[support vectors sono identità]: puoi elencare quali
  punti di training hanno influenzato la previsione
- Questo è meglio di una rete neurale dove la decisione è completamente
  dispersa nei parametri
- Puoi analizzare i support vectors localmente per capire il
  ragionamento

#strong[Contrasto con altri modelli:]

- #strong[LR/LogR:] coefficienti sono interpretabili per feature
  (spiegabilità per feature)
- #strong[DT:] cammino è tracciabile (spiegabilità per logica)
- #strong[SVM:] support vectors sono tracciabili (spiegabilità per
  precedenti)



== Vincoli sui Dati
<vincoli-sui-dati>
=== Linearità (Hard-Margin SVM)
<linearità-hard-margin-svm>
Hard-margin SVM #strong[richiede separabilità lineare esatta]. Se i dati
non sono linearmente separabili, il problema di ottimizzazione
#strong[non ha soluzione fattibile].

#strong[Soluzione:] Soft-margin SVM, che tolera violazioni.

=== Linearità (Soft-Margin SVM)
<linearità-soft-margin-svm>
Soft-margin SVM è ancora lineare nello spazio dei dati (senza kernel).
Se i dati hanno pattern non lineari, si usa kernel SVM.

=== Scalabilità
<scalabilità>
Come discusso, #strong[training è $O \( n^3 \)$], quindi SVM non scala
bene a dataset enormi senza approssimazioni.

=== Bilanciamento delle Classi
<bilanciamento-delle-classi>
SVM può essere influenzato da #strong[classi sbilanciate]:

- L\'algoritmo massimizza il margine complessivo, il che potrebbe
  favorire la classe maggioritaria
- Se una classe è il 95% e l\'altra il 5%, il margine \"massimo\"
  potrebbe consistere nel classificare tutto come la classe
  maggioritaria

#strong[Soluzioni:]

- #strong[Pesi di classe:] assegnare peso inverso alla frequenza (classe
  rara = peso alto)
- #strong[Tuning di C:] aumentare C per la classe minoritaria
- #strong[Ricampionamento:] oversampling della classe rara,
  undersampling della maggioritaria

=== Normalizzazione delle Feature
<normalizzazione-delle-feature>
SVM usa la #strong[distanza euclidea] ($\| \| x_i - x_j \| \|$) nel
kernel, quindi è #strong[sensibile alla scala]:

- Se una feature va da 0-1 e un\'altra da 0-1.000.000, quest\'ultima
  domina
- #strong[Pratica standard:] normalizzare tutte le feature (es.
  standardizzazione z-score o min-max scaling)

=== Nessun\'altra Assunzione Strutturale
<nessunaltra-assunzione-strutturale>
A differenza di LR, SVM #strong[non ha assunzioni] su:

- Normalità delle distribuzioni
- Omoschedasticità
- Relazioni lineari (soprattutto con kernel)



== Capacità Predittive
<capacità-predittive>
=== Punti di Forza
<punti-di-forza>
+ #strong[Eccellente per Pattern Non Lineari (con Kernel)]

  - Kernel RBF può approssimare funzioni arbitrariamente complesse
  - Spesso outperform modelli lineari su dati reali

+ #strong[Robusto a Outlier]

  - Soft-margin SVM usa slack variables; outlier hanno impatto limitato
  - Il margine è costruito basandosi su support vectors, non su tutti i
    punti

+ #strong[Funziona Bene in Alte Dimensioni]

  - Efficace anche quando p \> n (numero di feature \> numero di
    campioni)
  - Modelli lineari tendono a overfitting in questi scenari

+ #strong[Principi Teorici Solidi]

  - Massimizzazione del margine ha fondamenti teorici (theory of VC
    dimension, generalization bounds)
  - Garantisce che la soluzione è #strong[globalmente ottimale]
    (problema convesso)

+ #strong[Versatile]

  - Funziona sia per classificazione che per regressione (SVR)
  - Multi-classe mediante one-vs-rest o one-vs-one

=== Punti di Debolezza
<punti-di-debolezza>
+ #strong[Scarsa Interpretabilità]

  - Specialmente con kernel non lineari, difficile spiegare il
    ragionamento

+ #strong[Sensibilità a Iperparametri]

  - Scelta di C (soft-margin) e $gamma$ (RBF kernel) critica
  - Tuning male = performance disastrose

+ #strong[Inefficienza su Dataset Grandi]

  - Complessità training $O \( n^3 \)$ --- impraticabile per n \>\>
    100.000
  - Anche inference può essere lenta se molti support vectors

+ #strong[Non Probabilistico]

  - Output è una classificazione hard (classe -1 o +1)
  - Per ottenere probabilità, è necessario post-processing (Platt
    scaling)

+ #strong[Multicollinearità Non Gestita]

  - Se feature sono fortemente correlate, performance può deteriorarsi
  - Richiede feature selection o regularizzazione



== Metriche per la Confidenza
<metriche-per-la-confidenza>
=== Metriche di Classificazione Standard
<metriche-di-classificazione-standard>
Stesse metriche di LogR e DT:

- #strong[Confusion Matrix:] TP, TN, FP, FN
- #strong[Accuracy:] $\( T P + T N \) \/ \( T P + T N + F P + F N \)$
- #strong[Precision:] $T P \/ \( T P + F P \)$
- #strong[Recall/Sensitivity:] $T P \/ \( T P + F N \)$
- #strong[Specificity:] $T N \/ \( T N + F P \)$
- #strong[F1-Score:] media armonica di Precision e Recall
- #strong[ROC Curve e AUC:] trade-off tra TPR e FPR

=== Distanza dall\'Iperpiano
<distanza-dalliperpiano>
Misura della #strong[confidenza specifica di SVM]:

$ d_i = y_i (beta_0 + sum_(j = 1)^p beta_j x_(i j)) $

Questa è la #strong[distanza (segnata) del punto $x_i$ dall\'iperpiano],
normalizzata da $\| \| beta \| \|$:

$ upright("Distanza Normalizzata") = frac(d_i, \| \| beta \| \|) $

#strong[Interpretazione:]

- $d_i > 1$: punto ben classificato, lontano dall\'iperpiano (confidenza
  alta)
- $d_i approx 1$: punto sul margine (confine della decisione)
- $0 < d_i < 1$: punto nella regione di slack (violazione del margine)
- $d_i < 0$: punto classificato erroneamente

Questa distanza è un #strong[proxy per la confidenza della previsione]:
punti lontani dall\'iperpiano sono predetti con confidenza maggiore.

=== Platt Scaling (Probabilità Posteriori)
<platt-scaling-probabilità-posteriori>
SVM non produce probabilità di default. Per ottenere stime di
probabilità $P \( y = 1 \| x \)$, si usa #strong[Platt scaling]:

$ P \( y = 1 \) = frac(1, 1 + exp \( A dot.op d + B \)) $

Dove $A \, B$ sono parametri appresi su un validation set, calibrando la
distanza dell\'iperpiano a probabilità.

#strong[Limite:] aggiunge complessità e calibrazione; le probabilità
risultanti non hanno la stessa garanzia teorica della regressione
logistica.



== Metriche per la Comprensione e Spiegabilità
<metriche-per-la-comprensione-e-spiegabilità>
=== 1. Identificazione dei Support Vectors
<1-identificazione-dei-support-vectors>
Il set dei support vectors è la #strong[feature più interpretabile] di
SVM:

```
Support Vectors: [istanza_3, istanza_15, istanza_42, ...]
```

Rappresentano i punti di training che hanno #strong[influenzato
veramente la decisione]. Punti ben separati hanno $alpha_i = 0$ e sono
ignorati.

#strong[Utilizzo pratico:]

- Analizzare i support vectors per capire quali punti sono \"difficili\"
  (contorno decisionale)
- Visualizzare support vectors vs punti di background per ispezionare il
  modello
- Se molti support vectors = modello complesso; se pochi = modello
  semplice

=== 2. Pesi dei Support Vectors ($alpha_i$)
<2-pesi-dei-support-vectors-alpha_i>
I coefficienti $alpha_i > 0$ associati ai support vectors indicano il
loro \"peso\" nella decisione:

$ f \( x \) = beta_0 + sum_(i = 1)^n alpha_i y_i K \( x \, x_i \) $

#strong[Interpretazione:]

- $alpha_i$ grande = il support vector $x_i$ ha grande influenza
- $alpha_i$ piccolo = il support vector $x_i$ ha piccola influenza

#strong[Caveat:] interpretazione limitata per kernel non lineari, perché
non è immediatamente chiaro cosa stia facendo il kernel.

=== 3. Feature Importance (via Permutation o SHAP)
<3-feature-importance-via-permutation-o-shap>
SVM non produce naturalmente feature importance. Soluzioni:

#strong[Permutation Importance:]

- Permutare casualmente una feature nei dati di test
- Misurare il degrado in performance
- Grandi degradi = feature importante

#strong[SHAP (SHapley Additive exPlanations):]

- Assegnare ogni output tra le feature usando valori Shapley
- Applicabile a qualsiasi modello (SVM, NN, etc.)
- Computazionalmente costoso pero produce spiegazioni teoricamente
  fondate

=== 4. Visualizzazione della Separazione (2D/3D)
<4-visualizzazione-della-separazione-2d3d>
Per dataset a bassa dimensionalità, visualizzare:

- Punti di training e loro classi
- Iperpiano di decisione (retta in 2D, piano in 3D)
- Margine (linee parallele a distanza $M = 1 \/ \| \| beta \| \|$)
- Support vectors (segnati diversamente)

#strong[Limite:] per p \> 3, non è possibile visualizzare direttamente.
Usare proiezione PCA per ridurre dimensioni e visualizzare.

=== 5. Analisi Locale: Contrastive Explanation
<5-analisi-locale-contrastive-explanation>
Per una previsione di istanza $x_(upright("new"))$:

- Trovare i support vectors più vicini (usando la metrica del kernel)
- Mostrare come differiscono da $x_(upright("new"))$

Esempio:

```
Istanza X è classificata come Positiva perché simile al Support Vector SV_5
(che è Positivo), diversa dal Support Vector SV_12 (che è Negativo).

Differenze principali:
  - X.Income > SV_5.Income (simile)
  - X.Age < SV_12.Age (dissimile)
```



== Limiti di Predizione
<limiti-di-predizione>
=== Non Probabilistico per Default
<non-probabilistico-per-default>
SVM output una classificazione hard (+1 o -1), non una probabilità:

- Non ottenere stime naturali di incertezza
- Platt scaling produce probabilità, ma richiede calibrazione aggiuntiva

#strong[Conseguenza:] per problemi dove la probabilità importa (es.
medicina), SVM deve essere post-processato.

=== Sensibilità al Tuning di Iperparametri
<sensibilità-al-tuning-di-iperparametri>
Performance di SVM è #strong[molto sensibile] a:

- #strong[C (soft-margin):] piccolo C = underfitting; grande C =
  overfitting
- #strong[$gamma$ (RBF kernel):] piccolo $gamma$ = generale; grande
  $gamma$ = specifico (overfitting)

#strong[Conseguenza:] il tuning di iperparametri (grid search, random
search, Bayesian optimization) è #strong[mandatorio], il che aggiunge
complessità.

=== Sensibilità alla Normalizzazione delle Feature
<sensibilità-alla-normalizzazione-delle-feature>
Senza normalizzazione, feature con scale grandi dominano. SVM è
#strong[molto sensibile] a questo.

#strong[Mitigazione:] normalizzare sempre le feature (standardizzazione
z-score è standard).

=== Performance su Dataset Sbilanciate
<performance-su-dataset-sbilanciate>
Come discusso, SVM tende a favorire la classe maggioritaria.

#strong[Mitigazione:] usare class weights (inversamente proporzionali
alla frequenza).

=== Inefficienza su Dataset Grandi
<inefficienza-su-dataset-grandi>
Complessità $O \( n^3 \)$ rende SVM #strong[impraticabile per n \>\>
100.000].

#strong[Mitigazioni possibili:]

- Usare approssimazioni (Nyström approximation, stochastic gradient
  descent)
- Sottocampionare per training, validare su full dataset
- Usare alternative scalabili (logistic regression, gradient boosting)



== Limiti di Spiegabilità
<limiti-di-spiegabilità>
=== Opacità della Trasformazione Non Lineare (Kernel)
<opacità-della-trasformazione-non-lineare-kernel>
Con kernel RBF, i dati sono trasformati in uno #strong[spazio di
dimensionalità infinita]:

$ K \( x \, x' \) = exp (- gamma \| \| x - x' \| \|^2) $

Questa trasformazione $phi.alt \( x \)$ è #strong[implicita e non
visualizzabile]. Conseguenze:

- Non puoi interpretare cosa stia facendo il modello nello spazio
  trasformato
- L\'effetto delle feature sulla previsione è #strong[nascosto dietro il
  kernel]
- Spiegare una previsione richiede capire il kernel, che è non intuitivo
  per i non-esperti

=== Interpretazione Limitata di $alpha_i$
<interpretazione-limitata-di-alpha_i>
I pesi $alpha_i$ dei support vectors non hanno interpretazione diretta:

- Non significano \"questa feature è importante\"
- Non significano \"questo support vector cambia la probabilità del
  10%\"
- Sono artefatti dell\'ottimizzazione quadratica, non quantità
  interpretabili

=== Dipendenza da Support Vectors Arbitrari
<dipendenza-da-support-vectors-arbitrari>
Quali punti diventano support vectors dipende dalla #strong[geometria
dello spazio e dall\'iperparametro C]:

- Cambiar C → diversi support vectors
- Cambiar dataset leggermente → diversi support vectors
- Non è evidente #strong[perché] un punto è un support vector (è dovuto
  alla posizione geometrica, ma questa non è facilmente comunicabile)

=== Scarsa Tracciabilità Globale
<scarsa-tracciabilità-globale>
Mentre puoi identificare i support vectors, #strong[tracciare il
ragionamento globale è difficile]:

- Non puoi dire \"la feature X è il driver principale della
  classificazione\" (come in LR)
- Non puoi tracciare una sequenza logica (come in DT)
- Rimane una \"scatola nera\" anche dopo aver visto i support vectors

=== Nessuna Spiegazione Naturale per Feature Importanza
<nessuna-spiegazione-naturale-per-feature-importanza>
A differenza di:

- #strong[LR:] coefficienti diretti
- #strong[DT:] feature importance dai split

SVM non produce feature importance naturale. Devi usare tecniche esterne
(SHAP, permutation importance).



== Confronto con altri Algoritmi
<confronto-con-altri-algoritmi>
=== Vs. Logistic Regression
<vs-logistic-regression>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [LogR], [SVM],),
    table.hline(),
    [#strong[Output]], [Probabilità], [Classe (distanza)],
    [#strong[Interpretabilità]], [⭐⭐⭐⭐ Alta], [⭐⭐ Bassa],
    [#strong[Pattern Non-Lineare]], [⭐ (no kernel)], [⭐⭐⭐⭐⭐ (con
    kernel RBF)],
    [#strong[Scalabilità]], [⭐⭐⭐⭐ O(n p k)], [⭐⭐ O(n³)],
    [#strong[Teoria]], [Probabilistica], [Geometrica (margine)],
    [#strong[Quando usare]], [Interpretabilità critica], [Pattern
    non-lineare complesso],
  )]
  , kind: table
  )

=== Vs. Decision Tree
<vs-decision-tree>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [DT], [SVM],),
    table.hline(),
    [#strong[Interpretabilità]], [⭐⭐⭐⭐⭐ Altissima], [⭐⭐ Bassa],
    [#strong[Pattern Non-Lineare]], [⭐⭐⭐⭐⭐ Naturale], [⭐⭐⭐⭐⭐
    Con kernel],
    [#strong[Scalabilità]], [⭐⭐⭐⭐ O(n p log n)], [⭐⭐ O(n³)],
    [#strong[Robustezza Outlier]], [⭐⭐ (sensibile)], [⭐⭐⭐⭐
    (robusto)],
    [#strong[Stabilità]], [⭐⭐ (instabile)], [⭐⭐⭐⭐ (stabile)],
    [#strong[Quando usare]], [Massima interpretabilità], [Pattern
    complessi + stabilità],
  )]
  , kind: table
  )

=== Vs. Neural Networks
<vs-neural-networks>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [NN], [SVM],),
    table.hline(),
    [#strong[Capacità]], [⭐⭐⭐⭐⭐ Illimitata], [⭐⭐⭐⭐ Molto
    buona],
    [#strong[Interpretabilità]], [⭐ Scatola nera], [⭐⭐ Leggermente
    migliore],
    [#strong[Scalabilità]], [⭐⭐⭐⭐⭐ Eccellente], [⭐⭐ Scarsa],
    [#strong[Data Requirement]], [⭐ (molto dati)], [⭐⭐⭐⭐ (meno
    dati)],
    [#strong[Training]], [Lungo, GPU-friendly], [Veloce ma O(n³)],
    [#strong[Teoria]], [Inesistente], [Solida],
    [#strong[Quando usare]], [Big data + capacità illimitata], [Data
    medio + interpretabilità],
  )]
  , kind: table
  )

=== Vs. Random Forest / Gradient Boosting
<vs-random-forest--gradient-boosting>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Aspetto], [Ensemble], [SVM],),
    table.hline(),
    [#strong[Performance]], [⭐⭐⭐⭐⭐ Spesso migliore], [⭐⭐⭐⭐
    Buona],
    [#strong[Interpretabilità]], [⭐⭐ (migliore di NN)], [⭐⭐ Simile],
    [#strong[Scalabilità]], [⭐⭐⭐⭐ (meglio di SVM)], [⭐⭐],
    [#strong[Robustezza Iperparametri]], [⭐⭐⭐ Meno sensibile], [⭐⭐
    Molto sensibile],
    [#strong[Implementazione]], [Easy (sklearn)], [Easy (sklearn)],
    [#strong[Quando usare]], [Predizione è priorità \#1], [Stabilità,
    spiegabilità, dati piccoli],
  )]
  , kind: table
  )



== Varianti e Estensioni
<varianti-e-estensioni>
=== 1. Multi-Class SVM
<1-multi-class-svm>
SVM è originariamente binario. Per multi-classe:

#strong[One-vs-Rest (OvR):]

- Creare K classificatori binari (K = numero di classi)
- Ogni classificatore separa una classe dal resto
- Classe finale = massima confidenza

#strong[One-vs-One (OvO):]

- Creare K(K-1)/2 classificatori binari (uno per coppia di classi)
- Voting: conta quante volte ogni classe è predetta
- Più computazionalmente costoso, spesso più accurato

=== 2. Support Vector Regression (SVR)
<2-support-vector-regression-svr>
Estensione di SVM per #strong[regressione] (output continuo):

- Anziché maximizzare il margine di classificazione, minimizzare
  l\'errore di predizione
- Introduce un\'#strong[epsilon-insensitive loss]: errori piccoli \<
  $epsilon.alt$ sono tollerati
- Utile per predizione continua con gestione robusta di outlier

=== 3. Uno-Classe SVM (One-Class SVM)
<3-uno-classe-svm-one-class-svm>
Per problemi di #strong[anomaly detection] / #strong[outlier detection]:

- Imparare un \"confine\" intorno ai dati normali
- Punti fuori da questo confine sono anomalie
- Usa soft-margin con una frazione $nu$ di campioni come support vectors

=== 4. Relevance Vector Machine (RVM)
<4-relevance-vector-machine-rvm>
Variante Bayesiana di SVM:

- Produce probabilità di output come LogR
- Spesso meno support vectors (più sparso)
- Trade-off: meno efficienza di SVM, più interpretabilità



== Raccomandazioni Pratiche
<raccomandazioni-pratiche>
=== Quando Usare SVM
<quando-usare-svm>
✅ #strong[Ottime scelte:]

- Dataset di piccolo-medio volume (n \< 100.000)
- Pattern non lineari complessi
- Necessità di stabilità e robustezza
- Dati ad alta dimensionalità (p \> n)
- Outlier presenti nel dataset

❌ #strong[Cattive scelte:]

- Dataset molto grandi (n \> 1.000.000)
- Interpretabilità è critica per decisioni (es. medicina, finanza
  regolata)
- Tuning di iperparametri non è possibile
- Output probabilistico naturale necessario

=== Tuning Consigliate
<tuning-consigliate>
+ #strong[Normalizzare sempre le feature] (z-score o min-max)
+ #strong[Griglia di ricerca per C e $gamma$:]
  - C: \[0.1, 1, 10, 100, 1000\]
  - $gamma$: \[0.001, 0.01, 0.1, 1, \'auto\'\]
+ #strong[Cross-validation:] 5-10 fold per valutare
+ #strong[Class weights:] se classi sbilanciate, usare pesi inversi
+ #strong[Kernel:] iniziare con RBF; provare polinomiale se pattern
  sospetto



== Prompt
<prompt>
