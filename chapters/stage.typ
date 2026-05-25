#pagebreak(to:"odd")

= Stage description
<cap:stage-description>

#v(1em)
#text(style: "italic", [
    Breve introduzione al capitolo
])

#v(1em)



== Tracciamento dei requisiti

Da un'attenta analisi dei requisiti e degli use case effettuata sul progetto è stata stilata la tabella che traccia i requisiti in rapporto agli use case.

Sono stati individuati diversi tipi di requisiti e si è quindi fatto utilizzo di un codice identificativo per distinguerli.

Il codice dei requisiti è così strutturato R(F/Q/V)(N/D/O) dove:

#set list(marker: none)
- R = requisito
- F = funzionale
- Q = qualitativo
- V = di vincolo
- N = obbligatorio (necessario)
- D = desiderabile
- Z = opzionale

Nelle tabelle @tab:requisiti-funzionali, @tab:requisiti-qualitativi e @tab:requisiti-vincolo sono riassunti i requisiti e il loro tracciamento con gli use case delineati in fase di analisi.

#figure(
    table(
        columns: (auto, auto, auto),
        align: (center, left, center),
        [*Requisito*], [*Descrizione*], [*Use Case*],
        [RFN-1], [L'interfaccia permette di configurare il tipo di sonde del test], [UC1],
    ),
    caption: "Tabella del tracciamento dei requisti funzionali",
)
<tab:requisiti-funzionali>

#figure(
    table(
        columns: (auto, auto, auto),
        align: (center, left, center),
        [*Requisito*], [*Descrizione*], [*Use Case*],
        [RQD-1], [Le prestazioni del simulatore hardware deve garantire la giusta esecuzione dei test e non la generazione di falsi negativi], [#sym.dash],
    ),
    caption: "Tabella del tracciamento dei requisti funzionali",
)
<tab:requisiti-qualitativi>

#figure(
    table(
        columns: (auto, auto, auto),
        align: (center, left, center),
        [*Requisito*], [*Descrizione*], [*Use Case*],
        [RVQ-1], [La libreria per l'esecuzione dei test automatici deve essere riutilizzabil], [#sym.dash],
    ),
    caption: "Tabella del tracciamento dei requisti funzionali",
)
<tab:requisiti-vincolo>
