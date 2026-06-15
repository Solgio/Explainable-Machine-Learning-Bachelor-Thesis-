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
```python
prompt_text = (
        f"Analysis context:\n\n"
        f"# ALGORITHM: {algo_name}\n"
        f"## Algorithm type: {algo_type}\n"
        f"## Dataset description: {dataset_description}\n"
        f"## User expectations: {user_prompt}\n\n"
        f"# NUMERICAL DATA:\n{raw_metrics}\n\n"
        f"# COEFFICIENTS: \n{raw_coefficients}\n\n"
        f"# SPECIFIC INSTRUCTIONS: {algo_prompt}\n"
        f"{general_prompt}\n"
    )
```
== General instructions and guidelines
<general-instructions>
This section of the prompt is designed to describe the guidelines for the analysis. This do not only include the instruction of the task and the style of the output but also the principles of explainability that the #gls("large language model") should follow when generating the explaination, as described in @cap:explainability.\
```python

general_prompt = (
        "# STRICT EXPLAINABILITY RULES (Rigorous guidelines):\n"
        "1. Simplicity and Brevity: Focus only on a limited number of determining causes (maximum 3-5 features). Ignore marginal or non-causal variables.\n"
        "2. Fidelity to Human Logic: Use human language consistent with the business domain, adapting the explanation to the audience.\n"
        "3. Causality vs Correlation: Always clarify that the features identified by the model indicate statistical correlations but do not necessarily imply direct causality.\n"
        "4. Anomaly Management and Feature Support: If you notice extreme values (outliers) or if the prediction seems to be based on unusual data, report that the reliability (support) could be low as it deviates from average cases.\n"
        "5. Contrastive Explanation: If the data and image allow, try to explain differences contrastively (e.g., 'why the instance is positive compared to the negative one').\n\n"
        "# GENERAL INSTRUCTIONS:\n"
        "1. Summarize the overall reliability of the model in a few steps, based on the data but without going into technical details.\n"
        "2. Intuitively explain the main factors (features) driving decisions.\n"
        "3. Analyze the data and attached graphs to confirm if the model's decisions are in line with business common sense."
        "4. If the data contradicts user expectations or if anomalies emerge, highlight these discrepancies and suggest possible interpretations or corrective actions.\n"
        "# CONSTRAINTS:\n"
        "- Avoid excessive technical jargon, aim for clear and accessible language.\n"
        "- Do not just repeat the data, but provide an interpretation that makes them understandable and useful for strategic decisions."
        "- No explicit mathematical formulas."
        )
```
The direct inclusion of the explainability enforces the model to follow patterns proved to be effective for human understanding, avoiding the use of technical jargon and the inclusion of irrelevant features, which are in contrast with the context of the final user, who is a business user with limited technical knowledge. It is important to notice that there is a direct numeric indication of the number of features considered. This prevents the model from taking too much freedom in the choice of the level of detail of the explanation. \
Another important aspect is the inclusion of the point 4. _"If the data contradicts user expectations or if anomalies emerge, highlight these discrepancies and suggest possible interpretations or corrective actions."_. This forces the model to provide objective explanations, controlling the so called *"temperature"* of the model. This is a crucial point, as it prevents the model from providing explanations that are in line with user expectations but not supported by the data. \

== Dataset integration
<dataset-integration>
The dataset is integrated in the prompt not only through the raw coefficients and metrics but also through the description of the dataset. This provides the necessary context to link the metrics, the coefficients, the user expectations and the images to a pragmatic business context. \
The principal worry is that the model could be too focused on technical and mathematical aspects of the data, providing explanations that are not understandable by a business user. The dataset tackles this exact problem grounding the explanation in pragsmatic advice and coherent with the final user.

== Multi modal approach
<multi-modal-approach>
For a better understanding of the model's dehavior and to provide a more complete explanation along with the metrics, the prompt includes the base64 encoded images generated by the algorithm during the analysis. This is particularly useful to find eventual data assumptions. For example, using the linear regression model, the images of the residuals can be used to find eventual non linear patterns in the data, which could be a sign of a poor model fit. The inclusion of the images in the prompt allows the model to provide a more complete explanation, taking into account not only the numerical data but also the visual information provided by the images. \

== Results
<prompt-results>
The results obtained from the prompt engineering process are quite satisfactory. The model, following the instructions provided in the prompt, is able to generate explanations that are coherent with the data and manage to provide insights that are in line with business common sense.\
The explanations are concise and focused on the most relevant features, avoiding the inclusion of irrelevant information. The model is also able to highlight any discrepancies between the data and user expectations, providing possible interpretations and corrective actions. Overall, the prompt engineering process has been successful in guiding the model to generate explanations that are useful and understandable for business users.\
In some occasions, the model has shown contradictory behaviour, or example saying that a certain feature is relevant in a first part and then saying the opposite. This is probably due to the fact that the model used for the analysis are quite small, and the task is quite complex.\
However, the overall quality of the explanations is quite good, and the model is able to provide useful insights for the user.\
#v(1em)
