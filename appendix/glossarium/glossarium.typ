#import "@preview/glossarium:0.5.1": make-glossary, register-glossary, print-glossary, gls
#show: make-glossary

#let terms = (
  (
    key:"explainable ai",
    short: "XAI",
    long:"Explainable Artificial Intelligence"),
  (
    key: "large language model",
    short: "LLM",
    long: "Large Language Model"),
  (
    key: "prompt engineering",
    short: "PE",
    long: "Prompt Engineering",
    desc: "The process of designing and optimizing prompts to effectively communicate with language models and elicit desired responses."
  ),
  (
    key: "lime",
    short: "LIME",
    long: "Local Interpretable Model-agnostic Explanations"),
  (
    key: "shap",
    short: "SHAP",
    long: "SHapley Additive exPlanations"
  ),
  (
    key: "ai",
    short: "AI",
    long: "Artificial Intelligence"
  )
)

#print-glossary("glossarium")