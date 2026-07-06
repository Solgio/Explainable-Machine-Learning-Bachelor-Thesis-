#import "../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls

== Prompt Engineering and LLMs
<cap:prompt-engineering-and-llms>
The following sections present the principles used in the design of prompts to guide #gls("large language model", plural:true) in generating human-readable explanations of the analyzed algorithms.

=== Expert Personas
<sub:expert-personas>
The expert persona technique consists of designing prompts that describe the role the #gls("large language model") should play in the task. This technique is intended to guide the model in generating a more precise, coherent, and relevant output.\
Though using expert personas has been linked to a loss of accuracy in multiple benchmarks in recent studies by Zizhao Hu @expert_personas_zizhaohu, the primary use of the #gls("large language model", plural:true) in this project is results evaluation and text generation. The data and metrics do not need to be generated; they only need to be read directly from the prompt. The paper specifically addresses tasks that depend on pretrained knowledge retrieval accuracy @expert_personas_zizhaohu. Therefore, it is reasonable to conclude that in this context, the potential loss of accuracy is not a critical issue. In the same paper, an alignment of behavior and style to the described personas is observed. This drift in behavior is highly beneficial for describing algorithmic results in a human-readable way, as the style of the explanation is fundamental to making it accessible to non-expert stakeholders. 

=== Familiar formats
<sub:familiar-formats>
The extensive use of #gls("large language model", plural: true) has led to the emergence of some familiar formats that are widely used in prompt design. \
The principal features that make these formats particularly effective are:
  - Wide use in training: the more a format is represented in the training data of the model, the more likely the model is to effectively interpret content in that format.
  - Clear structure: the format should have a clear and recognizable structure that enables the model to easily identify the different components of the prompt and their relationships.
  - Token efficiency: the format should be designed to minimize the number of tokens used while still conveying all necessary information. This is particularly important because token usage directly affects the performance and cost of the model.\
  Among the many formats available, several have stood out for their accuracy and efficiency. The most valuable of these is *Markdown*, which has a clear, hierarchical structure that allows the model to easily parse the prompt. Using Markdown also enables the creation of a clear and organized structure for the generated explanations, making them more readable and accessible to non-expert stakeholders.\
  Another accurate format is YAML, which offers a more readable formatting than JSON and XML while still being well-structured. \
  An alternative like CSV can be used for tabular data, as it is a widely recognized format and is well understood by the model. However, it is important to ensure that the CSV data is properly structured to enable the model to generate accurate and relevant explanations.\
  Figure 2.5 presents a summary of the eleven formats examined in the study @formats-llms. The y-axis represents accuracy, while the x-axis represents token consumption. It is clear that Markdown emerges as the most accurate format while maintaining good token efficiency.\

#figure(
    image("../images/formats_llms.png", alt: "Comparison of prompting formats showing accuracy vs token consumption."),
    caption: "Formats for prompting. Source: '@formats-llms.'"
)
   

=== Chain-of-Thought
<sub:chain-of-thought>
Chain of Thought (CoT) prompting is a technique that consists of designing prompts that guide the #gls("large language model", plural:true) to generate a step-by-step reasoning process before reaching the final answer. \
The value of this guided, step-by-step reasoning has been proven in multiple benchmarks @chain-of-thought. This technique is especially valuable in the context of #gls("explainable ai") and for non-technical audiences, as it enhances the model's ability to provide detailed and understandable explanations. The generated answer is not just a final result, but an interpretable explanation that breaks down the reasoning process into clear, logical steps.

=== Zero-Shot prompting
<sub:zero-shot-prompting>
This technique consists of designing prompts that do not include any examples of the expected output. It is the simplest approach to prompting because it eliminates the need to provide training examples. Such a method is necessary in this context because providing specific examples of data and metrics for reference could make the prompt too narrow and prevent generalization. An additional set of data could also confuse the model and bias its output on the actual results of the analysis.\
Zero-shot prompting has also been shown to be highly effective when paired with other techniques, such as #link(<sub:chain-of-thought>)[Chain of Thought] (CoT) prompting @llms-zero-shot.

=== Multimodal prompt
<sub:multimodal-prompt>
The multimodal prompting technique consists of designing prompts that include multiple modalities, such as text, images, and tables. This technique is particularly useful in this project, as it enables providing the model with a richer and more interpretable context for generating explanations.\
The use of multimodal prompts can enhance the model's ability to comprehend and analyze the results of the algorithms by leveraging information provided in different formats. In fact, visual prompts interact effectively with textual prompts, enhancing alignment between modalities and thereby improving the model's performance on zero-shot instruction learning @multimodal-prompt.\