== Explainability
<explainability>
Explainability (or interpretability) of a ML model is the ability to communicate #strong[how and why] the model made a prediction. \
Contrary to intuition, explainbility it's #strong[not a binary attribute], but a spectrum with multiple dimensions.


=== Explainbility dimensions
<explainability-dimensions>
+ #strong[Intrinsic Transparency (Model-Level Interpretability)]

The model is inherently transparent and interpretable by design. The structure directly communicates how it works, such as regression coefficients or decision tree nodes. Each prediction is fully traceable, and parameters have tangible meanings. Explanations reflect human reasoning, making them coherent from a domain perspective. \
It rappresents the best case scenario forr explainability but it is often in trade-off with performance, as more complex models tend to be less transparent but more powerful.

+ #strong[Local Interpretability (Instance-Level Explainability)]

  The model might be opaque and to complex to understand globally. However, for a specific prediction, we can generate an explanation that is locally interpretable. LIME or SHAP could be used in this context to explain a particular instance obtained a certain prediction.

+ #strong[Interpretabilità dei Parametri]

  - I parametri del modello hanno un significato tangibile e
    interpretabile
  - Es.: il coefficiente $beta_j$ in LR significa \"aumentare $x_j$ di 1
    causa aumento di $y$ di $beta_j$\"
  - #strong[Proprietà:] la relazione tra parametri e comportamento è
    evidente

+ #strong[Fedeltà alla Logica Umana]

  - Le spiegazioni riflettono il ragionamento che un umano avrebbe fatto
  - Es.: \"il cliente ha defaultato perché: reddito basso (decisione
    umana plausibile) + punteggio di credito basso\"
  - #strong[Proprietà:] le spiegazioni suonano coerenti dal punto di
    vista del dominio



=== Framework di Lipton (2016)
<framework-di-lipton-2016>
Il lavoro fondamentale \"The Mythos of Model Interpretability\" di
#strong[Ribeiro et al. (2016)] identifica due categorie orthogonali di
spiegabilità:

==== 1. Transparency (Trasparenza del Modello)
<1-transparency-trasparenza-del-modello>
Quanto trasparente è il #strong[modello stesso], indipendentemente dalle
predizioni:

- #strong[High:] Linear Regression, Logistic Regression, Decision Trees
  (piccoli)
- #strong[Medium:] Generalized Additive Models, Ensemble Methods (Random
  Forests)
- #strong[Low:] Neural Networks, SVM, Gradient Boosting complesso

==== 2. Post-hoc Explainability (Spiegabilità Post-Hoc)
<2-post-hoc-explainability-spiegabilità-post-hoc>
Tecniche applicate #strong[dopo il training] per spiegare previsioni di
modelli opachi:

- #strong[LIME (Local Interpretable Model-agnostic Explanations):]
  approssima il modello localmente con un modello lineare semplice
- #strong[SHAP (SHapley Additive exPlanations):] assegna ogni output tra
  le feature usando valori Shapley dalla teoria dei giochi
- #strong[Feature Importance:] quale feature ha più influenzato la
  previsione

==== Interazione tra le due:
<interazione-tra-le-due>
- Un modello #strong[altamente trasparente] non ha bisogno di post-hoc
  (spiegazione è diretta)
- Un modello #strong[opaco] usa post-hoc per compensare
- Ideale: trasparenza intrinseca + capacità predittiva



=== Fattori che Facilitano la Comprensione
<fattori-che-facilitano-la-comprensione>
Sulla base di ricerca in interpretabilità (Lipton, Molnar, etc.), ci
sono #strong[molteplici aspetti] che facilitano la comprensione di una
spiegazione:

==== 1. Semplicità e Brevità
<1-semplicità-e-brevità>
- Spiegazioni corte sono preferite a quelle lunghe
- Un numero limitato di cause spieganti (es. 3-5 feature) è più
  memorizzabile di 10-20
- #strong[Trade-off:] brevità vs completezza; spesso un compromesso è
  necessario

==== 2. Confronto tra Istanze (Contrastive Explanations)
<2-confronto-tra-istanze-contrastive-explanations>
- \"Perché è stata predetta come positiva #emph[questa] istanza rispetto
  a #emph[quella]?\"
- Spiegazione contrastiva è spesso più illuminante che assoluta
- Es.: \"il cliente A ha defaultato ma il cliente B no; la differenza
  principale è il reddito\" è più utile che \"il cliente A ha reddito
  basso\"
- #strong[Applicazione:] usare nearest neighbors di classe diversa per
  confronto

==== 3. Selezione di Cause Determinanti
<3-selezione-di-cause-determinanti>
- Non tutte le feature sono uguali; alcune causano la predizione, altre
  sono correlate ma non causali
- Una spiegazione dovrebbe identificare i #strong[fattori determinanti],
  non tutti i fattori

==== 4. Adattamento al Contesto e all\'Audience
<4-adattamento-al-contesto-e-allaudience>
- La spiegazione deve essere #strong[appropriata al livello di
  expertise] dell\'audience
- Spiegazione a un medico non è la stessa di quella a un paziente
- Spiegazione a un regolatore non è la stessa di quella a un cliente
- #strong[Proprietà:] la qualità di una spiegazione è relativa al
  contesto

==== 5. Gestione di Feature Anomali o Outlier
<5-gestione-di-feature-anomali-o-outlier>
- Se una feature ha un valore inusuale, dovrebbe essere segnalato
- Es.: \"il cliente ha un\'età di 250 anni (anomalia nei dati), quindi
  la predizione è inaffidabile\"
- #strong[Proprietà:] la spiegazione dovrebbe indicare quando il modello
  è #strong[al di fuori del dominio] di applicazione

==== 6. Feature Support (Copertura Applicativa)
<6-feature-support-copertura-applicativa>
La #strong[generalità] di una previsione può essere quantificata dal
#strong[feature support]:

$ upright("Feature Support")_i = frac(upright("#istanze nel training con valori simili a ") x_i, upright("#istanze totali nel training")) $

Es.: se stiamo predendo per un cliente di 35 anni, e il 70% del training
set era tra 30-40 anni, il support è alto (predizione affidabile). Se
era il 5%, il support è basso (predizione in zona extrapolazione).

#strong[Implicazione:] una spiegazione dovrebbe menzionare il support:
\"questa predizione è affidabile (support = 0.7)\" vs \"questa
predizione è incerta (support = 0.1)\"

==== 7. Causalità vs Correlazione
<7-causalità-vs-correlazione>
- Una feature può essere #strong[correlata] alla predizione ma non
  #strong[causale]
- Es.: \"il modello predice default perché il cliente è ricco\" potrebbe
  essere spurio se la ricchezza è correlata al credito score, che è il
  vero driver
- #strong[Proprietà:] la spiegazione ideale identifica la
  #strong[relazione causale], non solo quella correlativa
- #strong[Limite:] senza esperimento (es. A/B test), è difficile provare
  causalità dai dati osservazionali



=== Applicabilità vs Generalità
<applicabilità-vs-generalità>
==== Non è il Parametro Più Importante
<non-è-il-parametro-più-importante>
Una spiegazione che è #strong[applicabile a molti casi] (alta copertura)
non è necessariamente la #strong[migliore] spiegazione:

- Una spiegazione generale (\"tutti i clienti giovani sono rischiosi\")
  ha alta applicabilità ma è imprecisa
- Una spiegazione specifica (\"questo cliente è rischioso a causa della
  combinazione unica di reddito basso + punteggio di credito basso +
  storia lavorativa instabile\") ha bassa applicabilità ma è molto più
  informativa

#strong[Principio:] la qualità di una spiegazione non si misura dalla
sua generalità, ma dalla sua #strong[utilità nel contesto specifico].

