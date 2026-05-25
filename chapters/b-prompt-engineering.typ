#import "../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls

== Prompt Engineering and LLMs
<cap:prompt-engineering-and-llms>
The following sections will present the principles used in the design of the prompts for the #gls("large language model", plural:true) to generate human-readable explanations of the analyzed algorithms.

=== Expert Personas
<sub:expert-personas>
The expert personas techiniques consists in the design of prompts that describes the role that the #gls("large language model") should play in the task. This technique first  should guide the model in generating a more precize, coherent and relevant output.\
Though the expert personas seems to be linked to a loss of accuracy in multiple benchmarks in the recent studys by Zizhao Hu @expert_personas_zizhaohu, the principal use of the LLMs in this project is results evaluation and text generation. The data and metrics do not have to be generated and have only to be read directly from the prompt. The paper specifically talks about _"For tasks that depend on pretrained knowledge retrieval accuracy"_ @expert_personas_zizhaohu. It's reasonable to think that in such a context, loss of accuracy is not a critical issue. In the same paper, an alignment of behavior and style to the descripted personas is observed. This drift in behavior is critical in the task of describing the results of an algorithm in a human-readable way, as the style of the explanation is fundamental to make it accessible to non-expert stakeholders. 

=== Familiar formats
<sub:familiar-formats>
The extensive use of #gls("large language model", plural: true) have led to the emergence of some familiar formats that are widely used in the design of prompts. \
The principal features that this formats present, and that makes them particularly effective, are the following:
  - Widely use in training: the more a format is used in the training of the model, the more likely is to be effective in the interpretation of content in that format.
  - Clear structure: the format should have a clear and recognizable structure that allows the model to easily identify the different components of the prompt and their relationships.
  - Token efficiency: the format should be designed in a way that minimizes the number of tokens used, while still conveying all the necessary information. This is particularly important in the context of LLMs, as the number of tokens used can have a significant impact on the performance and cost of the model.\
  From the multitude of formats in existence, some emerged for their particular accuracy and efficiency. The most valueable one is *Markdown*, which has a clear and recognizable structure that allows the model to easily identify the different components of the prompt and their relationships. The use of markdown also allows to create a clear and organized structure for the generated explanations, making them more readable and accessible to non-expert stakeholders.\
  Another accurate format is YAML, which offers a more readable formatting than JSON and XML while still being well structured. \
  An alternative like CSV can be used, as it is a widely used format for tabular data and is likely to be well understood by the model. However, it's important to ensure that the CSV format is properly structured and that the necessary information is included in the prompt to allow the model to generate accurate and relevant explanations.\
  What follows is a summarizing image whe re the 11 formats taken in exam in the study@formats-llms are presented. The y-axis is a scale of Accuracy while the x-axis a token consumption scale. It's clear that in this particular case of study, only OpenAI's GPT-4.1 nano has been tested, Markdown emerges as the most accurate format, while mantaining good token usage.\

#figure(
    image("../images/formats_llms.png", alt: "SHAP logo"),
    caption: "Formats for prompting. Source: @formats-llms"
)
   

=== Chain-of-Thought
<sub:chain-of-thought>
Chain of Thought (CoT) prompting is a technique that consists in the design of prompts that guide the #gls("large language model", plural:true) to generate a step-by-step reasoning process to reach the final answer. This technique is particularly useful in the context of this project, as it allows to generate explanations that are more coherent and relevant to the analyzed algorithms. \
The additional value of th guided, step-by-step reasoning has been proven in multiple benchmarks@chain-of-thought, and it is particularly useful in the context of this project, as it allows to generate explanations that are more coherent and relevant to the analyzed algorithms. \
In the particular context of #gls("explainable ai") and non-technical audiences because it enhances the model's ability to provide detailed and understandable explanations. The generated answer is not just a final result, but a comprehensive explanation that breaks down the reasoning process into clear and logical steps.

=== Zero-Shot prompting
<sub:zero-shot-prompting>
This technique consists in the design of prompts that do not include any example of the expected output. It's the simplest kind of prompting because it erases the problem of having to provide training examples. Such method is particularly necessary in the context due to the fact that an example of datas and metrics for reference could be to specific and not generalized enought. An additional set of datas could also confuse the model and make it less accurate or biased on the actual result of the analysis.\
The zero-shot prompting also revealed to be quite effective with some additional techniques such as the use of #link(<sub:chain-of-thought>)[Chain of Thought] (CoT) prompting @llms-zero-shot.

=== Multimodal prompt
<sub:multimodal-prompt>
The multimodal prompting technique consists in the design of prompts that include multiple modalities, such as text, images, tables, etc. This technique is particularly useful in the context of this project, as it allows to provide the model with a richer and more comprehensive context for generating explanations.\
The use of multimodal prompts can enhance the model's ability to comprehend and analyze the results of the algorithms, as it can leverage the information provided in different formats to generate more accurate and relevant explanations. In fact, _"visual prompts effectively interact with the textual prompts, enhancing the alignment between modalities and thereby improving the model's performance on the zero-shot instruction learning"_ @multimodal-prompt.\