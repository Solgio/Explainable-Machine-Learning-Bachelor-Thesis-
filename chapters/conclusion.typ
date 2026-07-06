#import "../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls
#import "../config/thesis-config.typ": side_by_side

#show figure : set block(breakable: true)
#pagebreak(to:"odd")

#show table.cell: it => {
  if it.body == [Achieved] {
    set align(center + horizon)
    text(fill: rgb("1b5e20"), weight: "bold", it.body)
  } else if it.body == [Partially Achieved] {
    set align(center + horizon)
    text(fill: rgb("e65100"), weight: "bold", it.body)
  } else if it.body == [Not Achieved] {
    set align(center + horizon)
    text(fill: rgb("b71c1c"), weight: "bold", it.body)
  } else {
    it
  }
}

= Conclusion
<cap:conclusion>

#v(1em)
#text(style: "italic", [
    In this final chapter, we will expose the final state of the project and the evaluation of its outcomes. \
])

#v(1em)

== Internship conclusion
<stage-conclusion>
The project reached a satisfactory final state. All planned stages were completed and project goals were achieved. \
#figure(
    table(
        block(breakable: true),
        table.header(repeat: true,[*Goal*], [*Description*], [*Status*]),
        columns: (auto, auto, auto),
        align: (center, center, center),
        [N-01], [ Complete and profound comprehension of the chosen algorithms, their mathematical foundations and their internal knowledge representation.],[Achieved],
        [N-02], [ Comprehension of interpretability and explainability techniques in machine learning.],[Achieved],
        [N-03], [ Comprehension of algorithms design techniques.],[Achieved],
        [N-04], [ Prompt generation for Large Language Models to generate human-readable explanations.],[Achieved],
        [N-05], [ Comprehension and application of Prompt Engineering principles in the context of XAI.],[Achieved],
        [D-01], [ Creation of a metric to evaluate the interpretability and explainability of the analyzed algorithms.],[Not Achieved],
        [D-02], [ Automatization of the analysis pipeline from dataset to LLM requests.],[Achieved],
        [O-01], [ Application in real-world scenarios of the interpretability and explainability of Machine Learning models.], [Partially Achieved],
        [O-02], [ Interpretability and explainability study of semi-supervised and unsupervised algorithms.], [Not Achieved],
    ),
    caption: "Table of project goals final state.",
)

The project has provided a comprehensive analysis of the interpretability and explainability of machine learning algorithms, with a practical implementation of an analysis system backed by a #gls("large language model") that is able to generate human-readable explanations of algorithmic behaviors and predictions. 
\ \
The details of the goal assessment are as follows:
- The goal D-01, which was to create a metric to evaluate the interpretability and explainability of the analyzed algorithms, was not achieved due to the nature of the task. It was not possible to create a metric that could be applied to all the algorithms analyzed, as the interpretability and explainability of each algorithm is highly dependent on the specific context and data used, making any single metric too generic to be useful. \
- The goal O-01, which was to apply the analysis system in real-world scenarios, was only partially achieved due to the limited availability of suitable datasets. More on that on @limitations-and-future-work. \
- The goal O-02, which was to study the interpretability and explainability of semi-supervised and unsupervised algorithms, was not achieved due to time constraints and preference in focusing on the supervised ones. \
Overall, the project has been successful in achieving its objectives and providing a valuable addition to the personal and professional growth of the author, as well as its possible applications in business contexts. \

== Product final state
<product-final-state>
The results are satisfactory; the system aligns with the initial goal of making a flexible and adaptable system that can be applied to a wide range of algorithms and datasets, providing business users valuable insights. \
#figure(
   table(
        block(breakable: true),
        table.header(repeat: true,[*Requirement*],[*Description*], [*Status*]),
        columns: (auto, auto, auto),
        align: (center, center, center),
        [RFN-1], [The system must allow the user to choose the dataset to analyse], [Achieved],
        [RFN-2], [The system must allow the user to choose the algorithm for the analysis], [Achieved],
        [RFN-3], [The system must allow the user to choose the level of detail for the analysis (example SHAP/No-SHAP)], [Achieved],
        [RFN-4], [The system must allow the user to choose whether to execute the LLM analysis or not], [Achieved],
        [RFN-5], [The system must allow the user to access the result of the analysis in a clear and organized way], [Achieved],
        [RFN-6], [The system must allow the user to know the reason in case of an error during the execution of the analysis], [Achieved],
        [RFN-7], [The system must allow the user to run multiple analyses to compare the performances of different algorithms and techniques], [Achieved],
        [RFO-1], [The system should be accessible via graphical user interface (No-CLI)], [Achieved],
        [RQN-1], [The system should be open to the use of different datasets, algorithms], [Achieved],
        [RQN-2], [The system should be open to the use of different explainability and analysis techniques], [Achieved],
        [RQN-3], [The system should be open to the use of different LLMs for the analysis], [Achieved],
        [RQD-1], [The system should process the data and execute the analysis in a reasonable time frame, including the LLM analysis the pipeline should not take more than 15 minutes to execute], [Partially Achieved],
    ),
    caption: "Table of requirements state for the analysis pipeline.",
)
As shown in the table, the system is able to satisfy all the functional requirements. The only partially achieved requirement is RQD-1, which is related to the execution time of the analysis pipeline. The execution time is highly dependent on the #gls("large language model"), as the infrastructure used for the model is not under the control of the developer and is not currently optimized for running multiple models in parallel. \

For complete tracking of the requirements, a requirements traceability matrix has been created.
#figure(
   table(
        block(breakable: true),
        table.header(repeat: true,[*Requirement*],[*Module*], [*Function*]),
        columns: (auto, auto, auto),
        align: (center, center, center),
        [RFN-1], [`selector.py`], [_select_dataset()_],
        [RFN-2], [`selector.py`], [ _select_algorithm(task_type:TaskType)_],
        [RFN-3], [`selector.py`], [_select_options()_],
        [RFN-4], [`selector.py`], [_select_options()_],
        [RFN-5], [`orchestrator.py`], [_export(self, model)_],
        [RFN-6], [Every module], [Exception handling and logging],
        [RFN-7], [`selector.py`], [_select_analysis_type()_],
        [RFO-1], [`app.py`], [],
    ),
    caption: "Table of requirements traceability for the analysis pipeline.",
)

== Results
<results>
The analysis of the algorithms has provided valuable insights about their limitations and strengths, enabling a better understanding of how to improve their performance and interpretability. A comprehensive comparison of the algorithms is available in @algorithmic-comparison. \ 
The integration of mathematical results, dataset context, and the analysis provided by the #gls("large language model") enabled a more complete understanding of algorithmic behaviors. This justification closed the gap between the complexity of the algorithms and business users, providing clear and simple explanations and enabling informed decisions based on the results. \
The results are generally satisfactory. This project provided an opportunity to explore the potential of #gls("large language model", plural: true) in the context of explainable machine learning and to provide a practical implementation of a system, applying the knowledge built during the academic experience. \
Moreover, the project offered a glimpse into the working world, exploring advanced technical aspects in a productive and professional environment. 

== Limitations and future work
<limitations-and-future-work>
The main limitation of the project is the limited impact of images. The pure mathematical nature of the plots and the complexity of the algorithms make it difficult to extract valuable insights from them, especially for business users. Researching techniques for better utilization of images is surely an aspect to improve. A first idea is the integration of a more precise description of the images, or perhaps supporting them with raw data. This is especially important for better identifying patterns and insights. This would require a deep study of how to extract the most relevant information from the images, if this is possible @mirage.\
An important improvement would be to enhance efficiency as mentioned in @stage-conclusion, reducing the execution time. In the current version, the pipeline has two different ways to request the #gls("large language model"): an LLM-wise and an algorithm-wise method. However, more sophisticated ways to navigate the technical limitations of the infrastructure could be explored.\

