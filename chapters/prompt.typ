#import "../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../config/thesis-config.typ": side_by_side

#pagebreak(to:"odd")

= Prompt Engineering
<cap:prompt-engineering>

#v(1em)
#text(style: "italic", [
    In this chapter, we will expose how the prompting principles are applied, how the prompt system is organized and the principal results obtained from this process. \
])

== Prompt structure
<prompt-structure>
The structure of the prompt is divided into tree main sections:
+ #strong[General instructions and guidelines]: this section contains the general instructions for the #gls("large language model"), including the task description, the expected output format, and any specific guidelines for generating explanations.
+ #strong[Algorithm specific instructions]: this section contains the instructions for the specific algorithm being used.
+ #strong[User query]: this section contains the user query, which is the specific question or request for explanation that the #gls("large language model") will respond to.
+ #strong[Payload]: this final section contains both the metrics, the coefficients and the base64 encoded images.

#v(1em)
