#import "../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls

== Explainability
<cap:explainability>
Interpretability and explainability of a #gls("ml") model are key concepts in understanding its behavior. Specifically, *interpretability* refers to the ability to show how the model works, while *explainability* refers to the ability to explain why a specific outcome occurred. \
Contrary to intuition, they are #strong[not binary attributes], but form a spectrum with multiple dimensions.


=== Interpretability and explainability dimensions
<cap:explainability-dimensions>
+ #strong[Intrinsic Transparency (Model-Level Interpretability)]\
  The model is inherently transparent and interpretable by design. The structure directly communicates how it works, such as regression coefficients or decision tree nodes. Each prediction is fully traceable, and parameters have tangible meanings. Explanations reflect human reasoning, making them coherent from a domain perspective. \
  It represents the best case scenario for interpretability but it is often in trade-off with performance, as more complex models tend to be less transparent but more powerful.
  It is generally organized in tiers: High, Medium and Low transparency.

+ #strong[Global Interpretability (Model-Level Interpretability):]\
  The model is comprehensible in its entirety, allowing to understand its overall behaviour and decision-making process. Such a level of understanding is hard to achieve, and it is usually reached indirectly by comprehending the individual components of the model instead of the model as a whole.

+ #strong[Modular Interpretability:]
  When global interpretability is not achievable, we can still understand the model by analyzing its components separately. Exploiting the model transparency, we can understand the role of each component in the decision-making process.\
  This concept is clear in the case of linear methods, where it is easy to understand the contribution of the single weights or in tree based models, where the splits and the structure of the tree can be analyzed separately.

+ #strong[Local Explainability (Instance-Level Explainability):]
  The model might be opaque and too complex to understand globally. However, for a specific prediction, we can generate an explanation that is locally explainable. SHAP could be used in this context to explain why a particular instance obtained a certain prediction.

=== Explanation properties and factors that facilitate understanding
<cap:explanation-properties-and-factors-that-facilitate-understanding>

For human explanations to be effective, they should have certain properties that facilitate understanding and usability. The following properties can be identified from Robnik-Sikonja and Bohanec 2018 and Molnar @interpretability_book:

- *Contrastive explanations*
<contrastive-explanations>
Comparative explanations that highlight the differences between instances can be more informative than absolute explanations. Comparing instances makes the explanation more impactful, providing a direct idea of how different factors contribute to different outcomes.

- *Cause selection*
<cause-selection>
Not all features are equally important; explanations should focus on the most influential factors rather than listing all contributing features. A small sample of the most relevant features provide a more clear explanation than a long list of all features preventing information overload.

- *Social and contextual factors*
<social-and-contextual-factors>
The social environment and the audience's expertise level should be considered when generating explanations to ensure they are appropriate and understandables.

- *Anomalies or abnormal predictions*
<anomalies-or-abnormal-predictions>
Highlighting anomalies or abnormal predictions can help users understand when the model is making an unusual decision, which can be crucial for trust and debugging. Features that are not largely relevant for the majority of the predictions but that have a great impact on specific predictions should be highlighted for their capability.

- *Fidelity*
<fidelity>
The explanation should accurately reflect the model's behavior and not introduce misleading information. A high-fidelity explanation ensures that users can trust the insights provided and make informed decisions based on them, provided that the model is accurate in its predictions.

- *General and probable*
<general-and-probable>
In the absence of anomalies of specific cases, a good explanation should rely on general and probable causes that are likely to be true for most instances. This parameter can be quantified by the feature support: 

$ upright("Feature Support")_i = frac(upright("#training instances with similar values to ") x_i, upright("#total training instances")) $

\ Generality can be misleading, as it may lead to explanations that are too broad and not specific enough to be useful. It's important to balance generality with the impact of the explanation, ensuring that it provides meaningful insights without being overly vague. This is why usually #link(<anomalies-or-abnormal-predictions>)[abnormal features] are highlighted, as they can provide more specific and impactful explanations.

=== SHAP analysis
<cap:shap-analysis>
SHAP (SHapley Additive exPlanations) is a method for explaining the output of machine learning models by attributing the prediction to each feature. It is based on the concept of Shapley values from cooperative game theory, which provide a way to fairly distribute the "payout" (in this case, the prediction) among the "players" (the features) based on their contribution to the prediction. SHAP values can be used to understand the importance of each feature for a specific prediction (local explainability) or for the model as a whole (global interpretability). SHAP provides a unified framework for interpreting various types of models and can be applied to both linear and non-linear models, making it a powerful tool for explainable AI.

#figure(
    image("../images/shap-logo.webp", width:75%, alt: "SHAP logo"),
    caption: "SHAP library logo."
)
