#import "../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls

== Prompt Engineering and LLMs
<cap:prompt-engineering-and-llms>
The following sections will present the principles used in the design of the prompts for the #gls("large language model", plural:true) to generate human-readable explanations of the analyzed algorithms.

=== Expert Personas
The expert personas techiniques consists in the design of prompts that describes the role that the #gls("large language model") should play in the task. This technique first  should guide the model in generating a more precize, coherent and relevant output.\
Though the expert personas seems to be linked to a loss of accuracy in multiple benchmarks in the recent studys by Zizhao Hu @expert_personas_zizhaohu, the principal use of the LLMs in this project is results evaluation and text generation. The data and metrics do not have to be generated and have only to be read directly from the prompt. The paper specifically talks about _"For tasks that depend on pretrained knowledge retrieval accuracy"_ @expert_personas_zizhaohu. It's reasonable to think that in such a context, loss of accuracy is not a critical issue. In the same paper, an alignment of behavior and style to the descripted personas is observed. This drift in behavior is critical in the task of describing the results of an algorithm in a human-readable way, as the style of the explanation is fundamental to make it accessible to non-expert stakeholders. 

=== Multimodal 