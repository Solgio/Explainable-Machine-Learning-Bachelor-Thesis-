#pagebreak(to:"odd")
#show figure : set block(breakable: true)
#import "@preview/glossarium:0.5.9": gls
#import "../config/thesis-config.typ": side_by_side, vertical-timeline, horizontal-steps

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
        [RFN-7], [The system must allow the user to run multiple analyses to compare the performances of different algorithms and techniques],
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
#side_by_side(
    [
        #figure(
            image("../images/diagrams/layers.png", width: 100%, alt: "Diagram of the layered architecture of the system."),
            caption: "Diagram of the layered architecture of the system with the most relevant components.",
        )
    ]
    ,[
        The design of the entire pipeline was made with the goal of an extendable pipeline, providing the developer the possibility to easily add new algorithms, datasets, analysis techniques and #gls("large language model", plural: true). \
        For this reason, the design of the system is layered and modular, with each component of the pipeline being independent and interchangeable. \ The main components of the system are: \
    ], proporzioni: (55%, 45%)
)
+ #strong[Orchestrator]: coordinates the pipeline, invoking the different components in the correct order and passing the necessary data between them.
+ #strong[Selector]: allows the user to choose the analysis type (single algorithm or comparative), the dataset, the algorithm, the level of detail for the analysis and whether to execute the #gls("large language model") analysis or not.
+ #strong[Algorithm]: implements the machine learning algorithm and provides the necessary functionalities for training, prediction and evaluation. All the models are created using a factory pattern, allowing to easily add new algorithms without modifying the existing code.
+ #strong[Data Pipeline]: responsible for loading, preprocessing and splitting the data for the analysis. Every single responsibility is encapsulated in a specific class.
+ #strong[LLM Request Manager]: manages the requests to the #gls("large language model"), including the generation of prompts and the collection of responses.


=== Guiding principles
<sec:guiding-principles>
For the best possible design of the system have been used the principles of object-oriented programming and some design patterns. First of all the SOLID principles @design-patterns-martin, @clean-code. In particular:
+ #strong[Single Responsibility Principle]: each class has a single responsibility, making the code more modular and easier to maintain. A clear example is the modular structure cited just before. A concrete example is the management of the dataset. The `DataPipeline` interface describes the general structure of the data pipeline, while the `DatasetLoader` interface is responsible for loading the dataset, the `DataValidator` interface is responsible for validating the data, the `DataProcessor` interface is responsible for preprocessing the data and the `DataSplitter` interface is responsible for splitting the data into training and test sets.\ This separation allows to replace or modify each component without affecting the others, making the code more *flexible* and *maintainable*. \

+ #strong[Open/Closed Principle]: each implementation of the abstract `baseMLAlgo` can expand the possibility of the base class, adding new functionality without modifying the existing code.  All the implementations inherit the basic skeleton of the base class, wrapping the specific algorithm, usually a scikit-learn estimator. The algorithm implemetation only need to implement the specific methods for fitting and metrics/plot generation following the template defined by the base class. This allows to easily add new algorithms without modifying the existing code, making the system more *extensible* and *scalable*.\

+ #strong[Liskov Substitution Principle]: the implementation of the `baseMLAlgo` substitute the abstract class, applying their version of the functions and modifying the analysis. The `orchestrator` uses the abstract class, allowing to easily switch between different implementations of the algorithms without modifying the orchestrator. The same principle has been applied in the `DataPipeline`, providing a clear interface for the data loading, validation, processing and splitting, allowing to easily *switch between different implementations* of these components without affecting the rest of the system. \

+ #strong[Interface Segregation Principle]: the interfaces of the different components are designed to be specific to their functionality, avoiding unnecessary dependencies between them. For example, the `LLMRequestManager` has a specific interface for managing the requests to the #gls("large language model"), without depending on the implementation of the algorithms or the orchestrator. Same for the `DataPipeline` and the `Explainer` components, which are designed to be indipendent and modular, allowing to easily replace or modify each component without affecting the others. This design promotes *loose coupling* and *high cohesion* in the codebase, making it easier to maintain and extend. \

+ #strong[Dependency Inversion Principle]: the high-level modules (`orchestrator`) do not depend on low-level modules (algorithms, LLM request manager), but both depend on abstractions. For example, the orchestrator depends on the abstract `baseMLAlgo` and `LLMRequestManager`, allowing to easily switch between different implementations of the algorithms and the LLM request manager without modifying the orchestrator.

=== Applied design patterns
<sec:applied-design-patterns>
The design of the system also incorporates some design patterns to solve common problems and improve the structure of the code. In particular, the following design patterns were applied:

==== Strategy
The strategy pattern was applied to the implementation of the algorithms, allowing to easily switch between different algorithms without modifying the code of the `orchestrator`. Each algorithm implements the same interface defined by the abstract `baseMLAlgo`, selecting the appropriate strategy at runtime.\
#figure(
      image("../images/diagrams/StrategyS.png", width: 100%, alt: "Diagram of the strategy pattern applied to the implementation of the algorithms."),
      caption: "Diagram of the strategy pattern applied to the implementation of the algorithms with XGBoost, Logistic and linear regression as examples of the concrete algorithms.",
    )

==== Template method  
The skeleton of the pipeline is defined in `BasePipeline` describing the overall structure of the analysis process. The concrete `DefaultPipeline` implements the template method, providing specific implementations for each step. The same pattern has been used in the `DataPipeline` and `Explainer` components as they share the same necessity for defined structure with possibility for customization of the specific steps.\

#figure(
      image("../images/diagrams/TemplateS.png", width: 100%, alt: "Diagram of the template method pattern applied to the implementation of the pipeline."),
      caption: "Diagram of the template method pattern applied to the implementation of the pipeline.",
    )

==== Factory
The factory pattern was applied in the algorithms instantiation via a `ModelFactory`, allowing to easily create instances of the algorithms without exposing the instantiation logic to the client code. This allows to easily add new algorithms without modifying the existing code and dynamically loading them, making the system more *extensible* and *scalable*.\

#figure(
      image("../images/diagrams/FactoryS.png", width: 100%, alt: "Diagram of the factory pattern applied to the implementation of the algorithms and ModelFactory."),
      caption: "Diagram of the factory pattern applied to the implementation of the algorithms and ModelFactory.",
    )

==== Registry
To centrally manage the registered algorithms, a registry pattern was applied, improved by a masisve use of value objects to manage the informations about the algorithms. The validity of the registered algorithms is consequently guaranteed and it simplifies the process of adding new algorithms to the system, as it only requires to create a new class that implements the `baseMLAlgo` interface and register it in the `ModelFactory` without modifying the existing code. This design promotes *extensibility* and *maintainability* of the codebase.\

#figure(
      image("../images/diagrams/RegistryS.png", width: 100%, alt: "Diagram of the registry pattern applied to the implementation of the algorithms and its use in the context of the system."),
      caption: "Diagram of the registry pattern applied to the implementation of the algorithms and its use in the context of the system.",
    )

==== Adapter
To compute the SHAP values for the algorithms, some adapting is needed to fit the specific requirements of the SHAP library. For this reason, an adapter pattern was applied to the `Explainer`, allowing to easily adapt the algorithms to the requirements of the SHAP library without modifying the existing code while maintaining a consistent interface. This design promotes *flexibility* and *reusability* of the codebase.\

#figure(
      image("../images/diagrams/AdapterS.png", width: 110%, alt: "Diagram of the adapter pattern applied to the implementation of the algorithms and its use in the context of the system."),
      caption: "Diagram of the adapter pattern applied to the implementation of the algorithms and its use in the context of the system.",
    )

==== Facade
The facade pattern was applied to the `orchestrator`, providing a single entrance `run_pipeline()` for algorithm initialization, result aggregation and management of the entire process of generating prompts, sending requests to the #gls("large language model") and collecting responses, hiding the complexity of the underlying implementation from the rest of the system.\

== Code implementation
<sec:code-implementation>
The resulting product of the design process is consequently structured in a modular and layered way, with clear interfaces and separation of concerns between the different components. The implementation of the system follows the design principles and patterns described in the previous sections, resulting in a codebase that is *extensible*, *maintainable* and *scalable*. \

=== Extension of the system
The process of extending the system with new algorithms, datasets and analysis techniques follows a clear and structured process, which allows to easily add new components to the system without modifying the existing code. The process is as follows:
1. #strong[New algorithm]
#let algorithm-steps = (
    (title:"NewAlgo.py", desc:"Describe the new model following \"baseMLAlgo\" interface and its template method using the abstact classes as guidelines."),
    (title:"registryInitializer.py", desc:"Register the new algorithm in the \"RegistryInitializer\" to make it available in the system."),
    (title:"Explainer.py", desc:"Add an entry in the \"Explainer\" strategy using the updated registry for type safety."),
)
#horizontal-steps(algorithm-steps)

2. #strong[New dataset manipulation]
#let dataset-steps = (
    (title:"dataset_config.py", desc:"If what is being added is a new dataset, create a new entry in the \"dataset_config\", describing the dataset, the task, the objective and other relevant information for the analysis."),
    (title:"dataLoader.py", desc:"If what is being added is a new dataset source, create a new class that implements the \"DataLoader\" interface, providing the necessary methods for loading the new dataset."),
    (title:"dataValidator.py", desc:"If what is being added is a validation rule, create a new class that implements the \"DataValidator\" interface, providing the necessary methods for validating the new dataset."),
    (title:"dataProcessor.py", desc:"If what is being added is a new preprocessing step, create a new class that implements the \"DataProcessor\" interface, providing the necessary methods for preprocessing the new dataset."),

)
#vertical-timeline(dataset-steps)

3. #strong[New SHAP analysis technique]
#let shap-steps = (
    (title:"NewSHAP.py", desc:"Create a new class that implements the \"SHAPExplainer\" interface, providing the necessary methods for computing the SHAP values using the new technique."),
    (title:"strategy.py", desc:"Define in the \"strategy\" which algorithm can use the new SHAP technique, using the algorithms registry for type safety."),
    (title:"plot_renderer.py", desc:"Add eventually new methods for rendering the SHAP values.")
)
#horizontal-steps(shap-steps)

=== Flow of the system
For a understanding of how the system works, the flow of the pipeline is described in the following diagram, showing the main steps of the process and how the different components interact with each other.
#figure(
      image("../images/diagrams/Flow.png", width: 100%, alt: "Diagram of the flow of the system."),
      caption: "Diagram of the flow of the system, showing the main steps of the process and how the different components interact with each other.",
    )