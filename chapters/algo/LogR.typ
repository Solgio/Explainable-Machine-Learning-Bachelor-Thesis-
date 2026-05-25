= Regressione Logistica (LogR)
<regressione-logistica-logr>
== Modello
<modello>
La regressione logistica è un modello utilizzato per problemi di
#strong[classificazione binaria], dove la variabile di risposta è
dicotomica (es. \"Sì/No\", \"Malato/Sano\", \"Default/Non-default\").

Il modello combina una #strong[combinazione lineare di feature] con una
#strong[funzione logistica (sigmoide)] per mantenere l\'output tra 0 e 1
(probabilità):

$ sigma \( z \) = frac(1, 1 + exp \( - z \)) $

Nel caso specifico, la probabilità che l\'istanza appartenga alla classe
positiva ($y = 1$) è:

$ P \( y^(\( i \)) = 1 \| x^(\( i \)) \) = frac(1, 1 + exp \( - \( beta_0 + sum_(j = 1)^p beta_j x_j^(\( i \)) \) \)) $

La probabilità della classe negativa è il complemento:
$P \( y^(\( i \)) = 0 \) = 1 - P \( y^(\( i \)) = 1 \)$.

In generale, la probabilità congiunta è descritta da una distribuzione
di Bernoulli:

$ P \( y^(\( i \)) \, x^(\( i \)) \) = cases(delim: "{", P \( y^(\( i \)) = 1 \)^(y^(\( i \))) dot.op \( 1 - P \( y^(\( i \)) = 1 \) \)^(1 - y^(\( i \))) & upright("Distribuzione Bernoulli")) $

=== Stima dei Coefficienti
<stima-dei-coefficienti>
A differenza della regressione lineare che minimizza l\'errore
quadratico, la regressione logistica #strong[massimizza la likelihood]
(probabilità osservare i dati dati i parametri):

$ L \( beta ; y \, X \) = product_(i = 1)^n P \( y^(\( i \)) = 1 \)^(y^(\( i \))) dot.op \( 1 - P \( y^(\( i \)) = 1 \) \)^(1 - y^(\( i \))) $

In pratica si massimizza il #strong[log-likelihood] per stabilità
numerica:

$ ell \( beta \) = sum_(i = 1)^n [y^(\( i \)) log \( P \( y^(\( i \)) = 1 \) \) + \( 1 - y^(\( i \)) \) log \( 1 - P \( y^(\( i \)) = 1 \) \)] $

La massimizzazione avviene tramite #strong[ottimizzazione iterativa]
(Gradient Descent, Newton-Raphson, IRLS) poiché non esiste una soluzione
analitica chiusa come nella regressione lineare.



== Complessità Computazionale
<complessità-computazionale>
=== Training
<training>
- #strong[Complessità principale:] $O \( p dot.op k dot.op n \)$

  - $k$ = numero di iterazioni dell\'algoritmo di ottimizzazione
    (solitamente 20-100)
  - $p$ = numero di feature
  - $n$ = numero di osservazioni
  - Dipende fortemente dal metodo di ottimizzazione scelto

- #strong[Memoria:] $O \( p \)$ per il vettore dei coefficienti +
  $O \( n \)$ per il batch

=== Inference
<inference>
- #strong[Complessità:] $O \( p \)$ per istanza (una moltiplicazione
  vettore + funzione sigmoid)
- #strong[Memoria:] $O \( p \)$ per il vettore dei coefficienti

=== Considerazioni sulla Scalabilità
<considerazioni-sulla-scalabilità>
La #strong[dipendenza iterativa] dalla convergenza rende la regressione
logistica #strong[meno prevedibile] della regressione lineare:

- Su dataset con feature altamente correlate, la convergenza può essere
  lenta (molte iterazioni)
- La separazione completa dei dati causa #strong[divergenza numerica]
  (coefficienti → ±∞)
- Per dataset #strong[very large] (n \>\> 1M), il training rimane
  trattabile grazie alla linearità della loss

Vantaggio rispetto a modelli come SVM o Neural Networks: rimane
computazionalmente efficiente anche su dataset di media grandezza senza
accelleratori GPU.



== Rappresentazione Interna
<rappresentazione-interna>
Come la regressione lineare, il modello rappresenta internamente il
modello come un #strong[vettore di pesi]
$beta = \[ beta_0 \, beta_1 \, . . . \, beta_p \]$.

#strong[Differenze rispetto a LR:]

+ I coefficienti #strong[non hanno interpretazione additiva diretta]
  (non è \"aumenta di $beta_j$\"), ma #strong[moltiplicativa] (vedi
  sezione Vincoli)
+ La #strong[trasformazione sigmoide] non è invertibile facilmente,
  quindi l\'effetto di una feature sulla probabilità #strong[dipende dal
  valore attuale] di tutte le altre feature (non è localmente lineare
  come in LR)

#strong[Implicazioni per la spiegabilità:]

- Rappresentazione #strong[ancora compatta e relativamente trasparente]
- L\'interpretazione è però #strong[meno intuitiva] di LR: i pesi non
  corrispondono direttamente a variazioni di probabilità
- La previsione è ancora completamente tracciabile (non è una scatola
  nera), ma il ragionamento richiede comprensione della trasformazione
  logistica
- Per istanze vicino a probabilità 0.5, piccole variazioni nei pesi
  causano grandi variazioni nella previsione (derivata della sigmoid è
  massima a 0.5)



== Vincoli sui Dati
<vincoli-sui-dati>
=== Interpretazione Moltiplicativa dei Pesi
<interpretazione-moltiplicativa-dei-pesi>
Dalla trasformazione della funzione logistica, gli #strong[odds]
(rapporto di probabilità) seguono una relazione #strong[lineare sui
log-odds]:

$ upright("odds") = frac(P \( y = 1 \), P \( y = 0 \)) = exp (beta_0 + sum_(j = 1)^p beta_j x_j) $

Aumentando di 1 unità una feature $j$, l\'effetto moltiplicativo sugli
odds è:

$ upright("odds")_(x_j + 1) / upright("odds") = exp \( beta_j \) $

#strong[Interpretazione pratica:] Se $beta_j = 0.5$, aumentare $x_j$ di
1 unità #strong[moltiplica gli odds per $e^0.5 approx 1.65$], cioè
aumenta del 65%. (Non aggiunge 0.5 come in LR!)

=== Assunzioni Fondamentali
<assunzioni-fondamentali>
+ #strong[Linearità del log-odds:]
  $log \( upright("odds") \) = beta_0 + sum_j beta_j x_j$. La relazione
  è lineare nello #strong[log-spazio degli odds], non nello spazio della
  probabilità. Relazioni non lineari rimangono non catturate

+ #strong[Linearità nei vincoli:] come LR, le feature si combinano
  linearmente nel log-odds. Interazioni devono essere aggiunte
  manualmente

+ #strong[Separazione completa:] se una feature separa perfettamente le
  due classi (tutti i valori di una classe da un lato, tutti dell\'altra
  dall\'altro), il modello non può identificare un peso finito.
  L\'algoritmo #strong[diverge] (coefficiente → $+ oo$ o $- oo$)

+ #strong[Distribuzione binomiale:] la variabile di risposta deve
  seguire una #strong[distribuzione di Bernoulli] (ogni osservazione è
  indipendente e ha probabilità fissa)

+ #strong[Indipendenza delle misure:] le osservazioni non devono essere
  correlate (no dati temporali consecutivi senza controllo)

+ #strong[Feature fisse:] le feature devono essere considerate costanti,
  senza errore di misurazione

+ #strong[Assenza di multicollinearità:] feature fortemente correlate
  causano instabilità dei coefficienti (come in LR, ma peggio perché
  l\'ottimizzazione iterativa può oscillare)

#strong[Nota importante:] L\'omoschedasticità #strong[non è un vincolo]
come in LR, poiché i valori della risposta possono assumere solo 0 o 1
(non una distribuzione continua)



== Capacità Predittive
<capacità-predittive>
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



== Confronto con altri Algoritmi
<confronto-con-altri-algoritmi>
=== Vs. Regressione Lineare su Risposta 0/1
<vs-regressione-lineare-su-risposta-01>
- #strong[LR su dati binari:] produce previsioni fuori da \[0,1\], ha
  issue di interpretazione, non è concepita per classificazione
- #strong[Logistica:] mantiene output in \[0,1\], fornisce probabilità
  direttamente interpretabili
- #strong[Conclusione:] Logistica è sempre preferibile per problemi di
  classificazione binaria

=== Vs. Linear Discriminant Analysis (LDA)
<vs-linear-discriminant-analysis-lda>
Entrambi creano confini decisionali #strong[lineari]. Tuttavia:

- #strong[Logistica:] modella direttamente $P \( y = 1 \| x \)$
  (approccio discriminativo)
- #strong[LDA:] modella la distribuzione congiunta di $x$ e $y$
  (approccio generativo), assumendo normalità multivariata di $x$ per
  ogni classe

#strong[Comparazione empirica:] spesso producono risultati simili, ma
logistica è #strong[preferibile se]:

- Le assunzioni gaussiane sono violate (dati non normali)
- Le classi hanno covariance molto diverse

=== Vs. Logistic Regression Multinomiale
<vs-logistic-regression-multinomiale>
- #strong[Binaria:] classifica in due classi
- #strong[Multinomiale:] estende a K \> 2 classi
- Usa l\'approccio #strong[softmax]: per ogni classe $k$, stima
  $P \( y = k \)$ come funzione softmax dei pesi specifici di quella
  classe

=== Vs. Lasso/Ridge per Logistica
<vs-lassoridge-per-logistica>
Come per LR:

- #strong[Logistica pura:] minimizza log-likelihood senza penalità
- #strong[Ridge logistica:] aggiunge penalità L2, riduce coefficienti,
  mantiene tutte le feature
- #strong[Lasso logistica:] aggiunge penalità L1, azzeramento selettivo
  di coefficienti (feature selection)
- #strong[Quando usare:] multicollinearità o separazione completa →
  Ridge/Lasso

=== Vs. Generalized Additive Models (GAM) Logistici
<vs-generalized-additive-models-gam-logistici>
- #strong[Logistica base:] log-odds lineari
  $log \( upright("odds") \) = beta_0 + sum beta_j x_j$
- #strong[GAM logistica:] log-odds additivi ma non lineari
  $log \( upright("odds") \) = beta_0 + sum f_j \( x_j \)$ dove $f_j$
  sono funzioni non lineari (es. splines)
- #strong[Vantaggio:] preserva linearità nel log-odds (additività) ma
  cattura non linearità
- #strong[Svantaggio:] la rappresentazione interna è più complessa
  (curve invece di rette)

=== Vs. Support Vector Machines (SVM)
<vs-support-vector-machines-svm>
- #strong[Logistica:] output probabilistico, interpretazione diretta
- #strong[SVM:] output hard (classe) o soft (margine), è un
  classificatore geometrico
- #strong[Trade-off:] SVM ha spesso migliore capacità predittiva su dati
  complessi; Logistica è più interpretabile



== Prompt
<prompt>
