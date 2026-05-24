// Non su primo capitolo
//#pagebreak(to:"odd")
#import "@preview/glossarium:0.5.9": gls
#import "../appendix/glossarium/terms.typ": terms

= Introduction

Introduction to the stage idea, goals, company and thesis organization. This chapter is meant to provide the necessary context for the reader to understand the motivation and the structure of the thesis.s

// TODO: aggiungere riferimenti a:
// Termine nel glossario
// Citazione in linea
// Citazione nel pie' di pagina


== Company

Zucchetti S.p.A. is a leading Italian software company specializing in providing comprehensive IT solutions for businesses. Founded in 1978, Zucchetti has grown to become one of the largest software providers in Italy, offering a wide range of products and services that cater to various industries, including manufacturing, retail, healthcare, and public administration. 

With a strong focus on innovation and customer satisfaction, Zucchetti is committed to helping organizations optimize their operations and achieve their business goals through cutting-edge technology. Exactly from this commit, the company has been actively involved in the development and implementation of #gls("ml") and #gls("ai") solutions, aiming to enhance the capabilities of their software offerings and provide more value to their clients.

#figure(
    image("../images/zucchetti-logo.webp", alt: "Zucchetti logo"),
    caption: "Zucchetti S.p.A. logo"
)

== Stage idea

The internship project is centered around the exploration of #gls("explainable ai") techniques, with a specific focus on the interpretability and comprehensibility of machine learning algorithms. The primary objective is to analyze a variety of predictive models, ranging from basic #gls("regression") and #gls("classification") algorithms to more complex ensemble methods, in order to evaluate their transparency and explainability. 
The idea is to increase the undestanding of the results of the models, and to make them more accessible to non-expert stakeholders, by leveraging advanced #gls("prompt engineering") principles to develop tailored prompts for #gls("large language model",plural:true) that can automatically generate human-readable explanations of algorithmic behaviors and predictions.
\ \
The timeline of the project is structured as follows:
#figure(
    table(
        columns: (auto, auto),
        align: (center, center),
        [*Week*], [*Task*],
        [1st], [ Analysis of Linear Regression, Logistic Regression, Support Vector Machines.],
        [2nd], [ Analysis of Decision Trees, Random Forests, XGBoost.],
        [3rd], [ Code implementation and Prompt Engineering for the analyzed algorithms.],
        [4th], [ Evaluation and documentation of the results.],
        [5th], [ Analysis of RuleFit and deep dive in Random Forests.],
        [6th], [ Analysis of Symbolic Regression.],
        [7th], [ Code implementation and Prompt Engineering for the analyzed algorithms.],
        [8th], [ Evaluation and documentation of the results, final report writing.]
    ),
    caption: "Table of the project timeline",
)

== Project goals
The goals follow a notation to distinguish between necessary (N), desirable (D) and optional (O) goals.
In the planning phase the goals were defined as follows:
#figure(
    table(
        columns: (auto, auto),
        align: (center, center),
        [*Goal*], [*Description*],
        [O-01], [ Complete and profound comprehension of the choosen algorithms, their mathematical foundations and their internal knowledge representation.],
        [O-02], [ Comprension of interpretability and explainability techniques in machine learning.],
        [O-03], [ Comprehension of algorithms design techniques.],
        [O-04], [ Prompt generation for Large Language Models to generate human-readable explanations.],
        [O-05], [ Comprehension and application of Prompt Engineering principles in the context of XAI.],
        [D-01], [ Creation of a metric to evaluate the explainability of the analyzed algorithms.],
        [D-02], [ Automatization of the analysis pipeline from dataset to LLM requests.],
        [F-01], [ Application in real-world scenarios of the interpretability and explainability of Machine Learning models.],
        [F-02], [ Explainability study of semi-supervised and unsupervised algorithms.]
    ),
    caption: "Table of project goals",
)

== Thesis structure

#set par(first-line-indent: 0pt)
/ #link(<cap:background>)[The second chapter]: describes the basic concepts that fuel the project. The concepts spread from the mathematical foundations of the analyzed algorithms, the basics of explainability, to the principles of Prompt Engineering and LLMs.
/ #link(<cap:ml-algorithms-analysis>)[The third chapter]: analyzes the ML algorithms, focusing on their capability, limitation and interpretability.
/ #link(<cap:code-implementation>)[The fourth chapter]: describes the design and implementation of the analysis pipeline from dataset to LLM requests.
/ #link(<cap:prompt-engineering>)[The fifth chapter]: discusses prompt engineering techniques and their application in the context of XAI.
/ #link(<cap:conclusion>)[The sixth chapter]: presents the conclusions of the study, the findings and the goals assessment.