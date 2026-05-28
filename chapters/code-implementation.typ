#pagebreak(to:"odd")
#show figure : set block(breakable: true)
#import "@preview/glossarium:0.5.9": gls
#import "../config/thesis-config.typ": side_by_side

= Design and code \ implementation
<cap:code-implementation>

#v(1em)
#text(style: "italic", [
    In this chapter we will describe the design and the implementation of the system, starting from the requirements and the technologies used, to the design and coding of the system.
])

#v(1em)
== Requirements
<sec:requirements>
Before implementing the system, it is crucial to define what the goals and the requirements of the project are. For a more precise description this requirements are categorized in functional (F), qualitative (Q) and constraint (V) requirements, and each of them is classified as necessary (N), desirable (D) or optional (O).
#figure(
   table(
        block(breakable: true),
        table.header(repeat: true,[*Requirement*],[*Description*]),
        columns: (auto, auto),
        align: (center, center),
        [RFN-1], [The system must allow the user to choose the dataset to analyse],
        [RFN-2], [The system must allow the user to choose the algorithm for the analysis],
        [RFN-3], [The system must allow the user to choose the level of detail for the analysis (example SHAP/No-SHAP)],
        [RFN-4], [The system must allow the user to choose whether to execute the LLM analysis or not],
        [RFN-5], [The system must allow the user to access the result of the analysis in a clear and organized way],
        [RFN-6], [The system must allow the user to know the reason in case of an error during the execution of the analysis],
        [RFO-1], [The system should be accessible via graphical user interface (No-CLI)],
        [RQN-1], [The system should be open to the use of different datasets, algorithms],
        [RQN-2], [The system should be open to the use of different explainability and analysis techniques],
        [RQN-3], [The system should be open to the use of different LLMs for the analysis],
        [RQD-1], [The system should process the data and execute the analysis in a reasonable time frame, including the LLM analysis the pipeline should not take more than 15 minutes to execute],
    ),
    caption: "Table of requirements for the analysis pipeline.",
)


== Technologies and tools
<sec:technologies-tools>
Considering the requirements defined in the previous section and the context of the project, the following technologies and tools were chosen for the implementation of the system:

=== Python
Python has been chosen as the main programming language for the implementation of the system due to its versatility, ease of use, and the wide range of libraries and frameworks available for data analysis, machine learning, and natural language processing.

=== Markdown
Markdown has been chosen for the collection of the LLM responses to generate the final report. It was chosen for its simplicity and readability, as well as its compatibility with various tools and platforms for documentation and reporting.

=== Pandas, Matplotlib, Seaborn, Numpy, SHAP
These Python libraries have been chosen for the vast range of functionalities. Pandas for data manipulation and analysis, Matplotlib and Seaborn for data visualization, Numpy for numerical computations, and SHAP for explainability analysis (@cap:shap-analysis).

=== Scikit-learn
Scikit-learn provides implementations of most of the algorithms in exam, without the need to implement them from scratch, allowing to focus on the analysis and explainability aspects of the project. \ Moreover, it provides a variaty of metrics for evaluating the performance of the models, which is crucial for the analysis.\
The models that were not offered by scikit-learn were implemented using the original implementations provided by the authors of the algorithms, for example for XGBoost@xgboost.

=== Optuna
Since a lot of algorithms benefits from hyperparameter tuning, Optuna was chosen for its efficiency and ease of use in automatically optimizing the hyperparameters of machine learning models.

=== Streamlit
Streamlit was chosen for the implementation of the #gls("gui") of the system. It allows to quickly and easily create interactive web applications for data analysis and machine learning, which is essential for providing a user-friendly interface for the system.

=== GitHub
GitHub was chosen for the version control of the project, for an effective codebase management.

=== Typst
Typst was chosen as principal tool for the notes and documentation. Thanks to its flexibility, modern design, powerful features, effective rendering of the PDFs, Typst 

== Design
<sec:design>
The design of the entire pipeline was made with the goal of an extendable pipeline, providing the developer the possibility to easily add new algorithms, datasets, analysis techniques and #gls("large language model", plural: true). \
For this reason, the design of the system is modular, with each component of the pipeline being independent and interchangeable. \ The main components of the system are: \

IMMAGINE DA INSERIRE CON STARUML

+ #strong[Orchestrator]: coordinates the pipeline, invoking the different components in the correct order and passing the necessary data between them.
+ #strong[Selector]: allows the user to choose the dataset, the algorithm, the level of detail for the analysis and whether to execute the #gls("large language model") analysis or not.
+ #strong[Algorithm]: implements the machine learning algorithm and provides the necessary functionalities for training, prediction and evaluation.
+ #strong[LLM Request Manager]: manages the requests to the #gls("large language model"), including the generation of prompts and the collection of responses.

=== Guiding principles
<sec:guiding-principles>
For the best possible design of the system have been used the principles of object-oriented programming and some design patterns. First of all the SOLID principles @design-patterns-martin, @clean-code. In particular:
+ #strong[Single Responsibility Principle]: each class has a single responsibility, making the code more modular and easier to maintain. A clear example is the modular structure cited just before. 
+ #strong[Open/Closed Principle]: each implementation of the abstract `baseMLAlgo` can expand the possibility of the base class, adding new functionality without modifying the existing code. \
+ #strong[Liskov Substitution Principle]: the implementation of the `baseMLAlgo` substitute the abstract class, applying their version of the functions and modifying the analysis.
+ #strong[Interface Segregation Principle]: the interfaces of the different components are designed to be specific to their functionality, avoiding unnecessary dependencies between them. For example, the `LLMRequestManager` has a specific interface for managing the requests to the #gls("large language model"), without depending on the implementation of the algorithms or the orchestrator.
+ #strong[Dependency Inversion Principle]: the high-level modules (`orchestrator`) do not depend on low-level modules (algorithms, LLM request manager), but both depend on abstractions. For example, the orchestrator depends on the abstract `baseMLAlgo` and `LLMRequestManager`, allowing to easily switch between different implementations of the algorithms and the LLM request manager without modifying the orchestrator.

=== Applied design patterns
<sec:applied-design-patterns>
The design of the system also incorporates some design patterns to solve common problems and improve the structure of the code. In particular, the following design patterns were applied:

==== Strategy
The strategy pattern was applied to the implementation of the algorithms, allowing to easily switch between different algorithms without modifying the code of the `orchestrator`. Each algorithm implements the same interface defined by the abstract `baseMLAlgo`, allowing to use them interchangeably in the orchestrator.\

IMMAGINE DA INSERIRE CON STARUML

==== Template method 
The base class `baseMLAlgo` defines the template method `run_analysis()`, which outlines the steps of the analysis process, while the concrete implementations of the algorithms provide their specific implementation of each step. This allows to have a consistent structure for the analysis while allowing for flexibility in the implementation of each algorithm.\

IMMAGINE O SNIPPET DI CONFRONTO TRA BASEMLALGO E UNA IMPLEMENTAZIONE CONCRETA

==== Facade
The facade pattern was applied to the `orchestrator`, providing a single entrance `run_pipeline()` for managing the entire process of generating prompts, sending requests to the #gls("large language model") and collecting responses, hiding the complexity of the underlying implementation from the rest of the system.\


== Code implementation
<sec:code-implementation>

