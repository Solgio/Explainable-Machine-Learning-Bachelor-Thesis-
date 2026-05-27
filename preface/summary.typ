#import "../config/constants.typ": abstract
#import "@preview/glossarium:0.5.9": gls
#import "../appendix/glossarium/terms.typ": terms
#set page(numbering: "i")
#counter(page).update(1)

#v(10em)

#text(24pt, weight: "semibold", abstract)

#v(2em)
#set par(first-line-indent: 0pt)
As #gls("ml") models become increasingly prevalent in business applications, ensuring their transparency and reliability through #gls("explainable ai") is critical. This project, conducted in collaboration with Zucchetti S.p.A., investigates the interpretability and comprehensibility of various machine learning algorithms.

The research systematically evaluates a spectrum of predictive models, ranging from fundamental @regression:long and @classification:long models—such as Linear Regression, Logistic Regression, Support Vector Machines, and Decision Trees—to complex ensemble methods, including Random Forest, XGBoost and Symbolic Regression. The analysis explores both intrinsic model transparency and post-hoc explainability techniques, utilizing metrics like #gls("shap") to interpret predictions and feature importance. Furthermore, the methodology encompasses the examination of mathematical foundations, internal knowledge representations, and the impact of ensemble techniques on both model performance and explainability. Real-world validation is performed using datasets such as Student Salary Prediction.

A primary objective of this work is bridging the gap between technical accuracy and human-understandable explanations for non-expert stakeholders. To achieve this, the project leverages advanced Prompt Engineering principles. Tailored prompts for #gls("large language model") are developed for each analyzed algorithm. These prompts are explicitly designed to automatically generate human-readable explanations of algorithmic behaviors and predictions. Ultimately, the project delivers production-ready implementations and #gls("large language model") integration adapters , demonstrating how the synthesis of traditional #gls("explainable ai") methodologies with modern language models can significantly enhance the transparency, trust, and responsible deployment of AI systems.

#v(1fr)