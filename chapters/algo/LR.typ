#import "../../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls

== Linear regression
<cap:linear-regression>

== Mathematical model
<sub:model-lr>
$ y = sum_(i = 0) beta_i x_i forall i in F $

Dove F è l\'insieme degli input per le feature. L\'obiettivo è vincolato
ai pesi $beta$:

$ hat(beta) = "argmin"_(beta_0 . . . beta_p) sum_(i = 1)^n \( y^(\( i \)) - \( beta_0 + sum_(j = 1)^p beta_j x_j \) \)^2 $

Viene minimizzato l\'errore quadratico tra la previsione e la $y$ reale
attraverso la soluzione analitica (forma chiusa):

$ hat(beta) = \( X^T X \)^(- 1) X^T y $

dove X è la matrice dei dati aumentata della colonna di 1 per
l\'intercetta.



== Complessità Computazionale
<complessità-computazionale>
=== Training
<training>
- #strong[Complessità principale:] $O \( p^2 n + p^3 \)$

  - $O \( p^2 n \)$ per il calcolo della matrice $X^T X$
  - $O \( p^3 \)$ per l\'inversione della matrice

- #strong[Memoria:] $O \( p^2 \)$ per memorizzare la matrice quadrata
  X^T X

=== Inference
<inference>
- #strong[Complessità:] $O \( p \)$ per istanza (moltiplicazione
  vettore-vettore)
- #strong[Memoria:] $O \( p \)$ per il vettore dei coefficienti

=== Considerazioni sulla Scalabilità
<considerazioni-sulla-scalabilità>
La dipendenza $O \( p^3 \)$ dall\'inversione matrice rende il modello
computazionalmente #strong[critico quando il numero di feature è
elevato] (p \>\> 1000 diventa problematico). In questi scenari è
preferibile usare metodi iterativi come Gradient Descent, che scalano
meglio a costo di maggiore tempo di training.

La soluzione analitica è comunque vantaggiosa per dataset di
#strong[piccolo-medio volume] (n, p moderati) poiché:

- Garantisce convergenza in un unico passo
- Non richiede tuning di parametri (es. learning rate)
- Fornisce una soluzione globale ottimale



== Rappresentazione Interna
<rappresentazione-interna>
La regressione lineare rappresenta internamente il modello come un
#strong[vettore di pesi]
$beta = \[ beta_0 \, beta_1 \, . . . \, beta_p \]$.

#strong[Implicazioni per la spiegabilità:]

- Rappresentazione #strong[estremamente compatta e trasparente]: ogni
  feature ha un coefficiente direttamente interpretabile
- La previsione per una singola istanza è una combinazione lineare
  esplicita
- Non esiste una \"scatola nera\": il calcolo della predizione è
  completamente tracciabile
- Ogni peso corrisponde direttamente all\'impatto della feature sulla
  predizione (impatto lineare e costante indipendentemente dal valore
  della feature)

#strong[Contrasto con altri modelli:] Un albero di decisione rappresenta
il modello come una struttura gerarchica complessa; un modello di
regressione logistica introduce una trasformazione non lineare
(logistica) dopo i pesi.



== Vincoli sui Dati
<vincoli-sui-dati>
La regressione lineare richiede il rispetto di #strong[6 assunzioni
fondamentali]:

+ #strong[Linearità dei vincoli:] le relazioni tra feature e target
  devono essere lineari. Interazioni o relazioni non lineari devono
  essere introdotte manualmente (es. termini quadratici $x^2$,
  interazioni $x_i dot.op x_j$)

+ #strong[Normalità dei residui:] i residui
  $epsilon.alt_i = y_i - hat(y)_i$ devono seguire una distribuzione
  normale. Violazioni gravi compromettono l\'inferenza statistica
  (p-value, intervalli di confidenza)

+ #strong[Omoschedasticità:] i residui devono avere varianza costante in
  tutti i livelli delle feature. In pratica, questa assunzione è
  #strong[frequentemente violata]. Esempio: nel real estate, il prezzo
  di case molto grandi è estremamente variabile, mentre quello di case
  piccole è concentrato

+ #strong[Indipendenza delle misure:] le osservazioni non devono essere
  correlate tra loro (es. non dati temporali consecutivi senza
  controllo). Dati dipendenti (come serie temporali) violano questa
  assunzione

+ #strong[Feature fisse:] le feature devono essere considerate come
  costanti, non soggette a errori di misurazione significativi. Se le
  feature contengono errore di misura, i coefficienti sono distorti
  (attenuation bias)

+ #strong[Assenza di multicollinearità:] le feature non devono essere
  fortemente correlate tra loro. Multicollinearità causa instabilità
  numerica durante l\'inversione di $X^T X$ e pesi inflazionati in
  valore assoluto ma con segni incerti

=== Preprocessing per i vincoli
<preprocessing-per-i-vincoli>
+ #strong[Identificazione multicollinearità:] calcolo della matrice di correlazione tra feature o VIF (Variance Inflation Factor) per identificare feature altamente correlate.
 $ "VIF"_j = frac(1, 1 - R_j^2)$
Dove $R_j^2$ è il coefficiente di determinazione del modello di regressione della feature $j$ sui restanti predictor.

+ #strong[Matrice di correlazione:] calcolo della matrice di correlazione per identificare coppie di feature altamente correlate con il coefficiente di Pearson  (correlazione > 0.8 o < -0.8).


== Capacità Predittive
<capacità-predittive>
#strong[Punti di forza:]

- Eccellente per relazioni #strong[linearmente separabili] tra feature e
  target
- Computazionalmente efficiente sia in training che in inference
- Soluzione #strong[esatta e garantita] (non iterativa, senza
  convergenza incerta)

#strong[Punti di debolezza:]

- #strong[Assolutamente inadatto a pattern non lineari]: la forma
  funzionale rigida è un vincolo, non una feature
- Fortemente semplificativo: impone una struttura di relazione che
  spesso non esiste nei dati reali
- Sensibile agli #strong[outlier]: errori grandi vengono quadrati nella
  loss function, amplificando l\'effetto

#strong[Limitazione strutturale:] Molti degli assunzioni su cui si basa
risultano #strong[non rispettati nella realtà]. L\'omoschedasticità, ad
esempio, è raramente verificata in problemi reali.



== Metriche per la Confidenza
<metriche-per-la-confidenza>
=== Metriche Pure
<metriche-pure>
==== $R^2$ (Coefficiente di determinazione)
<r2-coefficiente-di-determinazione>
Quantifica quanto il modello spiega la varianza totale dei dati (range:
0 → 1)

$ R^2 = 1 - frac(S S E, S S T) $

Dove:

- $S S E = sum_(i = 1)^n \( y^(\( i \)) - hat(y)^(\( i \)) \)^2$ è la
  somma dei quadrati dei residui (varianza non spiegata)
- $S S T = sum_(i = 1)^n \( y^(\( i \)) - macron(y) \)^2$ è la varianza
  totale

Interpretazione: $R^2 = 0.85$ significa che il modello spiega l\'85%
della variabilità totale.

==== $macron(R)^2$ (R² aggiustato)
#label("barr2-r²-aggiustato")
Variazione di $R^2$ che penalizza l\'aggiunta di feature non utili. A
differenza di $R^2$ che cresce sempre al crescere del numero di feature,
$macron(R)^2$ diminuisce se la feature aggiunta non compensa la
complessità:

$ macron(R)^2 = 1 - \( 1 - R^2 \) frac(n - 1, n - p - 1) $

Dove $p$ è il numero di feature (#emph[predittori]) e $n$ il numero di
istanze.

==== Feature Importance (t-statistic)
<feature-importance-t-statistic>
Misura la significatività statistica di ogni coefficiente, calcolata
come il peso scalato per il suo errore standard:

$ t_(hat(beta)_j) = frac(hat(beta)_j, S E \( hat(beta)_j \)) $

#strong[Interpretazione:]

- Valori assoluti grandi → la feature è statisticamente significativa
  nella previsione
- Cresce al crescere del peso, diminuisce all\'aumentare della varianza
- Associato a un #strong[p-value] che quantifica la probabilità che il
  coefficiente sia dovuto al caso

==== p-value
<p-value>
Per ogni coefficiente, il p-value risponde: \"Se il vero coefficiente
fosse 0, quale è la probabilità di osservare un valore così estremo per
$t_(hat(beta)_j)$?\". Convention: p \< 0.05 indica significatività.

==== Mallows\' Cp
<mallows-cp>
Criterio per la #strong[selezione del modello] che bilancia errore di
training con complessità:

$ C p = frac(S S E, hat(sigma)^2) - n + 2 p $

Dove $hat(sigma)^2$ è la stima della varianza dei residui del modello
completo. Un modello ideale ha $C p approx p + 1$.

==== RMSE (Root Mean Squared Error)
<rmse-root-mean-squared-error>
Misura la magnitudine media degli errori, nella stessa scala della
variabile target:

$ R M S E = sqrt(frac(S S E, n)) $

==== MAE (Mean Absolute Error)
<mae-mean-absolute-error>
Alternativa a RMSE, meno sensibile agli outlier:

$ "MAE" = 1 / n sum_(i = 1)^n \| y_i - hat(y)_i \| $

=== Analisi dei Plot
<analisi-dei-plot>
==== Actual vs Predicted
<actual-vs-predicted>
Grafico di dispersione (scatter plot) tra valori reali $y_i$ e predetti
$hat(y)_i$.

- #strong[Interpretazione corretta:] punti concentrati intorno alla
  diagonale $y = hat(y)$
- #strong[Anomalie:] dispersione crescente con il valore predetto
  (eteroschedasticità), o pattern sistematico (non linearità)

==== Istogramma dei Residui
<istogramma-dei-residui>
Distribuzione dei residui $epsilon.alt_i = y_i - hat(y)_i$.

- #strong[Interpretazione corretta:] distribuzione simmetrica e
  campanulare (normale)
- #strong[Anomalie:] asimmetria o code pesanti indicano violazione della
  normalità

==== Q-Q Plot (Quantile-Quantile)
<q-q-plot-quantile-quantile>
Rappresenta i quantili empirici dei residui vs i quantili di una
distribuzione normale.

- #strong[Interpretazione corretta:] punti seguono la retta diagonale
- #strong[Anomalie:] deviazioni sistematiche (specialmente alle code)
  indicano non normalità

==== Residuals vs Fitted Values
<residuals-vs-fitted-values>
Grafico di dispersione con asse x = valori predetti $hat(y)_i$, asse y =
residui $epsilon.alt_i$.

- #strong[Interpretazione corretta:] nuvola di punti senza pattern,
  orizzontale attorno a 0
- #strong[Anomalie:]
  - Pattern sistematico (curva) → non linearità
  - Varianza crescente con x → eteroschedasticità
  - Bande orizzontali → outlier o dati discreti



== Metriche per la Comprensione e Spiegabilità
<metriche-per-la-comprensione-e-spiegabilità>
=== Feature Effect
<feature-effect>
Rappresentazione dell\'impatto di ogni feature sulla previsione,
calcolato come:

$ e f f e c t_j^(\( i \)) = beta_j x_j^(\( i \)) $

#strong[Visualizzazione:] box plot per quartili (25%-75%) per ogni
feature

- #strong[Larghezza del box] = variabilità dell\'effetto nei dati reali
- Una feature con box ampio ha un impatto medio elevato sulla previsione
- Utile per identificare quali feature contano di più

=== Weight Plot
<weight-plot>
Rappresentazione grafica dei coefficienti $beta_j$ ordinati per valore
assoluto.

- Feature con barre lunghe hanno maggiore influenza sulla previsione
- Utile per comunicare rapidamente l\'importanza relativa delle feature

=== Interpretazione Diretta dei Coefficienti
<interpretazione-diretta-dei-coefficienti>
Ogni coefficiente $beta_j$ ha un\'interpretazione immediata:
\"aumentando la feature $x_j$ di 1 unità, la previsione cambia di
$beta_j$ unità\" (mantenendo le altre feature costanti).

Questa #strong[trasparenza è il vantaggio principale] della regressione
lineare per la spiegabilità rispetto a modelli più complessi.



== Limiti di Predizione
<limiti-di-predizione>
=== Sensibilità agli Outlier
<sensibilità-agli-outlier>
L\'errore quadratico nella loss function amplifica gli outlier: un
errore di 10 unità contribuisce 100 alla loss, quindi il modello tende a
distorcersi per minimizzare outlier singolari.

=== Problemi di Extrapolazione
<problemi-di-extrapolazione>
La regressione lineare assume che la relazione lineare continui al di
fuori dell\'intervallo osservato dei dati. Predizioni su valori di
feature molto diversi dal training set sono estremamente inaffidabili.

=== Instabilità Numerica in Caso di Multicollinearità
<instabilità-numerica-in-caso-di-multicollinearità>
Se le feature sono altamente correlate, la matrice $X^T X$ diventa
mal-condizionata (quasi singolare), rendendo l\'inversione numericamente
instabile e i coefficienti instabili.

=== Insufficienza su Pattern Non Lineari
<insufficienza-su-pattern-non-lineari>
Non esiste modifica parametrica che possa far adattare un modello
lineare a relazioni veramente non lineari senza inserire manualmente
termini non lineari (e questo richiede conoscenza a priori della forma
della relazione).

=== Collasso su Dati ad Alta Dimensionalità
<collasso-su-dati-ad-alta-dimensionalità>
Quando il numero di feature è prossimo o superiore al numero di
osservazioni ($p approx n$ o $p > n$), il modello tende a sovradattarsi,
con $R^2$ perfetto sul training e pessimo sul test.



== Limiti di Spiegabilità
<limiti-di-spiegabilità>
=== Non Linearità Nascosta nei Dati
<non-linearità-nascosta-nei-dati>
Se la vera relazione è non lineare ma viene forzata in un modello
lineare, i coefficienti rappresentano una \"media\" della relazione, non
la relazione vera. Un coefficiente positivo in media potrebbe mascherare
un effetto che è positivo per alcuni valori della feature e negativo per
altri.

=== Interazioni Non Modellate
<interazioni-non-modellate>
La regressione lineare base assume indipendenza degli effetti delle
feature: l\'effetto di $x_1$ non dipende da $x_2$. Se esistono
interazioni significative, il modello le ignora (a meno che non siano
aggiunte manualmente).

=== Sensibilità al Livello di Dettaglio
<sensibilità-al-livello-di-dettaglio>
La scelta di quante feature includere è delicata: troppe causano
overfitting e spiegabilità confusa, troppo poche rendono le spiegazioni
superficiali e imprecise.

=== Difficoltà con Feature Categoriche
<difficoltà-con-feature-categoriche>
Le feature categoriche devono essere codificate (es. one-hot encoding),
il che aumenta $p$ e complessità interpretativa (un concetto logico
diventa p variabili binarie).

=== Selettività
<selettività>
La capacità di identificare solo le feature veramente rilevanti può
essere raggiunta in due modi:

- #strong[Selezione manuale a priori:] affidamento a esperti di dominio
- #strong[Modelli sparse (Lasso):] introduzione di penalità L1 che
  forzano molti coefficienti a 0
- #strong[Metodi stepwise:] aggiunta/rimozione iterativa di feature



== Confronto con altri Algoritmi
<confronto-con-altri-algoritmi>
=== Vs. Regressione Logistica
<vs-regressione-logistica>
- #strong[LR:] per relazioni lineari #strong[continue]
- #strong[Logistica:] per classificazione binaria, produce probabilità
  dirette
- La logistica non è un\'estensione di LR, ma un modello distinto per un
  problema diverso

=== Vs. Decision Tree
<vs-decision-tree>
- #strong[LR:] trasparente, coefficienti interpreti, ma rigida (niente
  non linearità)
- #strong[DT:] flessibile, cattura non linearità e interazioni, ma
  rappresentazione complessa e instabile
- #strong[Scelta:] dati lineari → LR; pattern complessi non lineari → DT

=== Vs. Lasso / Ridge
<vs-lasso--ridge>
- #strong[LR standard:] minimizza SSE senza penalità
- #strong[Ridge:] aggiunge penalità L2 $lambda \| \| beta \| \|_2^2$,
  riducendo i pesi ma mantenendo tutte le feature
- #strong[Lasso:] aggiunge penalità L1 $lambda \| \| beta \| \|_1$,
  azzerando pesi (selezione automatica di feature)
- #strong[Quando usare:] multicollinearità o alta dimensionalità →
  Ridge/Lasso

=== Vs. Selezione Manuale di Feature
<vs-selezione-manuale-di-feature>
- #strong[Selezione Lasso/Ridge:] automatica, basata sui dati
- #strong[Selezione manuale:] richiede expertise di dominio, ma può
  catturare conoscenza esterna
- #strong[Metodi stepwise (Forward/Backward):] compromesso automatico ma
  interpretabile

==== Forward Selection
<forward-selection>
Aggiunta passo-passo di feature: at ogni passo, aggiungere la feature
che massimizza una metrica di controllo (es. $R^2$). Stop quando non
c\'è miglioramento significativo.

==== Backward Selection
<backward-selection>
Opposto: partire da tutte le feature, rimuovere iterativamente quella
con contributo minore.

=== Vs. Generalized Additive Models (GAM)
<vs-generalized-additive-models-gam>
- #strong[LR:] effetti lineari e additivi
- #strong[GAM:] combina LR con funzioni non lineari flessibili (splines)
  per ogni feature
- Il modello rimane #strong[additivo] (effetti indipendenti) ma
  #strong[non lineare] (curve invece di rette)

