
#set document(title: "Converted Document")


== 3. Design Patterns Implementation




*Key Benefits*:



  1. *Extensibility*: Add new algorithm by registering it, no code changes needed

  1. *Decoupling*: Orchestrator doesn't know about specific algorithm implementations

  1. *Centralized Logic*: All creation logic in one place

  1. *Error Handling*: Factory provides detailed error messages for missing algorithms


=== 3.5 Adapter Pattern


*Purpose*: Convert the interface of one class into another clients expect.


Where It's Applied
*Location*: SHAP explainer integration


*Problem It Solves*:


The base ML algorithms have a `model` attribute of various types (sklearn, xgboost, etc.), but SHAP expects a specific interface. Additionally, different model types need different SHAP strategies.


```
`# ❌ WRONG - Without Adapter (model type checking everywhere)
def explain_with_shap(self, x_sample, dependence_variable):
    model = self.model
    
    if isinstance(model, sklearn.tree.DecisionTreeClassifier):
        explainer = shap.TreeExplainer(model)
    elif isinstance(model, xgboost.XGBClassifier):
        explainer = shap.TreeExplainer(model)
    elif isinstance(model, sklearn.svm.SVC):
        explainer = shap.KernelExplainer(lambda x: model.predict(x), x_sample)
    elif isinstance(model, sklearn.linear_model.LogisticRegression):
        explainer = shap.KernelExplainer(lambda x: model.predict_proba(x)[:, 1], x_sample)
    # ... 10 more type checks scattered throughout
`
```


*Solution*: Adapter Pattern with Strategy


```
`# adapter.py - Adapter converts model to standard interface
class SHAPAnalyzerAdapter:
    """Adapter class to integrate SHAPAnalyzer with the Explainer interface."""
    _EXPLAINER_MAP = {
        ExplainerStrategy.TREE: SHAPTreeExplainer,
        ExplainerStrategy.KERNEL: SHAPKernelExplainer
    }
    _MODEL_ALIASES = {
        "LinearRegression": Algorithm.LINEAR_REGRESSION,
        "LogisticRegression": Algorithm.LOGISTIC_REGRESSION,
        "DecisionTreeClassifier": Algorithm.DECISION_TREE_CLASSIFIER,
        "DecisionTreeRegressor": Algorithm.DECISION_TREE_REGRESSOR,
        "RandomForestClassifier": Algorithm.RANDOM_FOREST_CLASSIFIER,
        "RandomForestRegressor": Algorithm.RANDOM_FOREST_REGRESSOR,
        "SVC": Algorithm.SVM,
        "SVR": Algorithm.SVM,
        "XGBClassifier": Algorithm.XGBOOST_CLASSIFIER,
        "XGBRegressor": Algorithm.XGBOOST_REGRESSOR,
        "SymbolicRegressor": Algorithm.SYMBOLIC_REGRESSOR,
    }
    
    def __init__(self, model, x_train: pd.DataFrame, plot_dir: str, task_type: TaskType):
        self.model = model
        self.x_train = x_train
        self.plot_dir = plot_dir
        self.task_type = task_type
    
    def explain(self, x_sample: pd.DataFrame, dependence_variable: str) -> ExplainerResult:
        """Generate SHAP explanations and associated plots for a given sample."""
        try: 
            # Step 1: Identify the underlying model type
            model_type = self._extract_model_type()
            
            # Step 2: Select appropriate strategy
            strategy = select_explainer_strategy(algorithm=model_type, task_type=self.task_type)
            
            # Step 3: Create appropriate explainer
            explainer = self._create_explainer(strategy)
            
            # Step 4: Validate input and run explanation
            if not hasattr(x_sample, 'shape') or not hasattr(x_sample, 'columns'):
                raise TypeError("x_sample must be a pandas DataFrame")
            
            max_rows = 2000
            if len(x_sample) > max_rows:
                logging.warning(f"x_sample too large; truncating to {max_rows}")
                x_sample = x_sample.iloc[:max_rows]
            
            # Step 5: Get result in standard format
            result = explainer.explain(x_sample, dependence_variable)
            return result
        except Exception as e:
            logging.exception(f"Error occurred while explaining sample: {e}")
            raise
`
```


*Strategy Selection Integration*


```
`# strategy.py - Strategy registry for explainers
def select_explainer_strategy(algorithm: Algorithm, task_type: TaskType) -> ExplainerStrategy:
    """Select the appropriate explainer strategy for the given algorithm and task."""
    if algorithm not in _ALGORITHM_STRATEGY_REGISTRY:
        raise ValueError(f"No explainer strategy registered for {algorithm}")
    
    allowed_tasks = _ALGORITHM_TASK_CONSTRAINTS.get(algorithm)
    if allowed_tasks is not None and task_type not in allowed_tasks:
        allowed_task_names = ", ".join(sorted(task.value for task in allowed_tasks))
        raise ValueError(
            f"{algorithm} is supported only for {allowed_task_names}, not for {task_type.value}"
        )
    
    strategy = _ALGORITHM_STRATEGY_REGISTRY[algorithm]
    logging.info("Selected SHAP strategy '%s' for algorithm '%s'", strategy, algorithm)
    return strategy

# Register default strategies
_ALGORITHM_STRATEGY_REGISTRY = {
    Algorithm.DECISION_TREE_CLASSIFIER: ExplainerStrategy.TREE,
    Algorithm.DECISION_TREE_REGRESSOR: ExplainerStrategy.TREE,
    Algorithm.RANDOM_FOREST_CLASSIFIER: ExplainerStrategy.TREE,
    Algorithm.RANDOM_FOREST_REGRESSOR: ExplainerStrategy.TREE,
    Algorithm.XGBOOST_REGRESSOR: ExplainerStrategy.TREE,
    Algorithm.XGBOOST_CLASSIFIER: ExplainerStrategy.TREE,
    Algorithm.LOGISTIC_REGRESSION: ExplainerStrategy.KERNEL,
    Algorithm.SVM: ExplainerStrategy.KERNEL,
    Algorithm.LINEAR_REGRESSION: ExplainerStrategy.KERNEL,
    Algorithm.SYMBOLIC_REGRESSOR: ExplainerStrategy.KERNEL,
}
`
```


*Concrete Explainer Implementations*


```
`# shap_tree_explainer.py - Tree-based strategy
class SHAPTreeExplainer(Explainer):
    """SHAP explainer optimized for tree-based models."""
    
    def _compute_shap_values(self, x_sample: pd.DataFrame):
        """Compute SHAP values using the TreeExplainer."""
        logging.info("Computing SHAP values using TreeExplainer...")
        model_to_explain = self._extract_base_model()
        explainer = shap.TreeExplainer(model_to_explain)
        shap_values = explainer(x_sample)
        return shap_values
    
    def _generate_plots(self, shap_values, x_sample: pd.DataFrame, dependence_variable: str) -> Dict[str, str]:
        """Generate SHAP plots and save them to disk."""
        logging.info("Generating standard SHAP plots via shared renderer...")
        renderer = SHAPPlotRenderer(self.plot_dir)
        return renderer.render(shap_values, x_sample, dependence_variable)

# shap_kernel_explainer.py - Kernel-based strategy
class SHAPKernelExplainer(Explainer):
    """SHAP explainer for models without native SHAP support."""
    
    def _compute_shap_values(self, x_sample: pd.DataFrame):
        """Compute SHAP values using the KernelExplainer."""
        logging.info("Computing SHAP values using KernelExplainer...")
        
        # Data cleaning
        x_sample_clean = clean_data(x_sample)
        x_train_clean = clean_data(self.x_train)
        
        # Prediction function
        pred_fn = self._create_prediction_function(self.model)
        
        # Background sample
        background_sample = shap.sample(x_train_clean, min(30, len(x_train_clean)))
        explainer = shap.Explainer(pred_fn, background_sample)
        
        # Compute
        shap_values = explainer(x_sample_clean)
        return shap_values
    
    def _create_prediction_function(self, model):
        """Create prediction function based on model's capabilities."""
        if hasattr(model, "predict_proba"):
            logging.info("Using 'predict_proba' for SHAP KernelExplainer")
            return lambda x: model.predict_proba(x)
        elif hasattr(model, "decision_function"):
            logging.info("Using 'decision_function' for SHAP KernelExplainer")
            return lambda x: model.decision_function(x)
        else:
            logging.debug("Using 'predict' for SHAP KernelExplainer")
            return lambda x: model.predict(x)
`
```


*Key Benefits*:



  1. *Polymorphism*: Different model types use same interface

  1. *Decoupling*: Base algorithms don't know about SHAP details

  1. *Testability*: Can mock explainers independently

  1. *Extensibility*: Add new model types by extending aliases



=== 3.6 Facade Pattern


*Purpose*: Provide a unified interface to a set of complex subsystems.


Where It's Applied
*Location*: Main orchestrator


*Problem It Solves*:


```
`# ❌ WRONG - Without Facade (client must orchestrate complexity)
def main():
    # Client must know about every component
    initialize_model_registry()
    
    config = run_selector()
    
    dataset_name = config["dataset_name"]
    dataset_cfg = config["dataset_cfg"]
    test_size = config.get("test_size", 0.2)
    run_shap = config.get("run_shap", False)
    run_llm = config.get("run_llm", False)
    
    pipeline = DefaultPipeline()
    algorithms = config.get("algorithms", [config.get("algo_enum")])
    
    results_map = {}
    for algo in algorithms:
        local_config = config.copy()
        local_config["algo_enum"] = algo
        local_config["algo_info"] = ModelFactory.get_all_info(algo, config["dataset_cfg"]["task"])
        
        try:
            pipeline_output = pipeline.run(local_config)
            results_map[str(algo)] = pipeline_output
        except Exception as e:
            log.exception(f"Error for {algo}: {e}")
            continue
    
    # ... more complexity
    return results_map
`
```


*Solution*: Facade Pattern


```
`# orchestrator.py - Facade provides simple interface
def run_pipeline(config: dict) -> dict:
    """Backward-compatible wrapper that runs the default pipeline."""
    pipeline = DefaultPipeline()
    analysis_type = config.get("analysis_type", AnalysisType.SINGLE)
    results_map = {}
    
    algorithms = config.get("algorithms", [config.get("algo_enum")])
    
    print("\n" + "█" * 60)
    print(f"  AVVIO WORKFLOW: {analysis_type.value.upper()} su dataset '{config['dataset_name']}'")
    print("█" * 60)

    # Facade orchestrates complexity transparently
    for algo in algorithms:
        local_config = config.copy()
        local_config["algo_enum"] = algo
        local_config["algo_info"] = ModelFactory.get_all_info(algo, config["dataset_cfg"]["task"])
        
        try:
            pipeline_output = pipeline.run(local_config)
            results_map[str(algo)] = pipeline_output
        except Exception as e:
            log.exception(f"❌ Error for {algo}: {e}")
            traceback.print_exc()
            print("\n Proceeding to next algorithm...\n")
            continue
    
    # Handle comparative analysis summary
    if analysis_type == AnalysisType.COMPARATIVE and len(results_map) > 1:
        print("\n" + "═" * 60)
        print("   FINAL METRICS COMPARISON")
        print("═" * 60)
        for algo_name, out in results_map.items():
            metrics = out["export"].get("metrics", {})
            print(f"  > {algo_name}: {metrics}")
        print("═" * 60)

    return results_map

# Entry point - uses facade
if __name__ == "__main__":
    try:
        initialize_model_registry()
        from src.core.selector import run_selector
        config = run_selector()
        run_pipeline(config)  # Single call!
    except KeyboardInterrupt:
        print("\n\n  Interrupted by user.")
        sys.exit(0)
    except Exception:
        log.error("Critical error in pipeline:")
        traceback.print_exc()
        sys.exit(1)
`
```


*Encapsulated Complexity*


The facade hides:



  1. Pipeline creation and initialization

  1. Algorithm iteration and configuration

  1. Error handling and recovery

  1. Result aggregation and comparison

  1. Logging and output formatting


*Client Code Simplicity*


```
`# From the user's perspective - extremely simple
config = run_selector()          # Get user preferences
results = run_pipeline(config)   # That's it!
`
```



== 4. Modularity Analysis


=== 4.1 Component Independence


The system achieves modularity through *vertical slicing* - each component operates independently:


```
`SELECTOR (UI) 
    ↓ produces config
ORCHESTRATOR (Coordinator)
    ├─ depends on Factory (not algorithms)
    ├─ depends on Pipeline (not data loaders)
    └─ depends on Explainers (abstraction, not concrete)

ALGORITHM FACTORY
    ├─ loads modules dynamically
    ├─ doesn't hardcode algorithm locations
    └─ instantiates from registry

INDIVIDUAL ALGORITHMS
    ├─ inherit from BaseMLAlgo (contract)
    ├─ implement fit(), generate_plots(), etc.
    ├─ don't know about other algorithms
    └─ don't know about orchestrator

DATA PIPELINE
    ├─ contains Loader, Validator, Processor, Splitter
    ├─ each component is independent
    ├─ components are interchangeable
    └─ doesn't know about algorithms

EXPLAINERS
    ├─ depend on Adapter (interface)
    ├─ depend on Strategy (algorithm selection)
    ├─ don't know about specific models
    └─ isolated from training logic
`
```


=== 4.2 Dependency Graph


```
`Low Coupling, High Cohesion:

orchestrator.py ────────┐
                        │
selector.py ────────────┼──→ model_factory.py ────→ [dynamic imports]
                        │
registry_init.py ───────┘
                        │
                        ├──→ baseMLAlgo.py ◄────── [algorithm implementations]
                        │
                        ├──→ Pipeline.py ◄────── [data components]
                        │
                        └──→ adapter.py ◄────── [explainers]

NO CIRCULAR DEPENDENCIES
NO TIGHT COUPLING
NO GOD OBJECTS
`
```


=== 4.3 Extension Points


Adding new functionality requires NO modifications to existing code:


#table(
  columns: 3,
  "Extension Point", "How to Add", "Example",
  "New Algorithm", "Register in registry", "ModelFactory.register(AlgorithmRegistry(...))",
  "New Data Source", "Create DataLoader subclass", "class ParquetDataLoader(DataLoader)",
  "New Validation Rule", "Create DataValidator subclass", "class DistributionValidator(DataValidator)",
  "New Preprocessing Step", "Create DataProcessor subclass", "class NormalizationProcessor(DataProcessor)",
  "New SHAP Strategy", "Create Explainer subclass", "class SHAPGradientExplainer(Explainer)",
  "New Pipeline Step", "Extend BasePipeline", "class AdvancedPipeline(BasePipeline)",
)



== 5. Design Decisions and Rationale


=== 5.1 Why Registry Pattern for Algorithms?


*Decision*: Use `ModelFactory` with a registry instead of hardcoding algorithm imports


*Rationale*:



  1. *Decoupling*: Orchestrator doesn't need to know about 12 algorithm implementations

  1. *Dynamic Loading*: Algorithms are loaded at runtime via `importlib`

  1. *Metadata Storage*: Descriptions, prompts, hyperparameter grids stored centrally

  1. *UI Integration*: Selector can query registry to display available options

  1. *Testability*: Can mock registry for unit testing


*Tradeoff*: Slightly more complex initialization vs. massive flexibility



=== 5.2 Why Template Method + Strategy?


*Decision*: Use both Template Method (in `BasePipeline`) and Strategy Pattern (algorithm selection)


*Rationale*:



  - *Template Method*: Defines the ORCHESTRATION structure (7 steps: load, fit, plot, shap, export, llm, return)

  - *Strategy Pattern*: Allows DIFFERENT IMPLEMENTATIONS of the same skeleton


This is a classic combination:


```
`# Template: The SEQUENCE is fixed
run() → load_model() → load_data() → fit() → plots() → shap() → export() → llm()

# Strategy: Each step has MULTIPLE IMPLEMENTATIONS
    ├─ load_model: XGBoost, SVM, LR, DecTree, ...
    ├─ fit: XGBoost-specific, SVM-specific, ...
    ├─ plots: XGBoost plots, SVM plots, ...
    └─ ... etc
`
```



=== 5.3 Why Data Pipeline Composition?


*Decision*: Use composition (`DataPipeline` contains Loader, Validator, Processor, Splitter) instead of inheritance


*Rationale*:



  1. *Flexibility*: Can swap any component independently

  1. *Testability*: Each component can be mocked/tested in isolation

  1. *Reusability*: Same components used across different algorithms

  1. *Clarity*: Data flow is explicit and easy to understand


*Vs. Inheritance Anti-pattern*:


```
`# ❌ WRONG - Tight coupling through inheritance
class CSVRegressionDataLoader(PandasDataProcessor):
    def process_regression(self):
        ...

class ParquetClassificationDataLoader(PandasDataProcessor):
    def process_classification(self):
        ...

# Exponential complexity: N loaders × M processors × K validators
`
```



=== 5.4 Why Adapter for SHAP?


*Decision*: Use `SHAPAnalyzerAdapter` to bridge ML models and SHAP explainers


*Rationale*:



  1. *Model Agnosticity*: Adapter extracts model type automatically

  1. *Strategy Selection*: Routes to appropriate SHAP strategy (Tree vs. Kernel)

  1. *Decoupling*: Algorithms don't need to know about SHAP

  1. *Extensibility*: Add new model types by extending `_MODEL_ALIASES`



=== 5.5 Why Facade Pattern for Orchestrator?


*Decision*: `run_pipeline()` acts as a facade to hide complexity


*Rationale*:



  1. *Simplicity*: Users call ONE function to run entire workflow

  1. *Error Handling*: All exception handling centralized

  1. *Logging*: Consistent logging format across pipeline

  1. *Comparative Analysis*: Facade handles both SINGLE and COMPARATIVE modes

  1. *Extensibility*: Future enhancements (e.g., parallel execution) happen transparently



== 6. Error Handling Architecture


=== 6.1 Exception Hierarchy


```
`# exceptions.py - Clear exception hierarchy
ModelError (Base)
    ├─ ModelNotFoundError      # Algorithm not in registry
    ├─ ModelCreationError      # Instantiation failed
    └─ ModelRegistrationError  # Registration validation failed

DataError (Base)               # Data loading failures
`
```


=== 6.2 Error Propagation Strategy


```
`# model_factory.py - Factory provides detailed error context
@classmethod
def create(cls, algorithm: Algorithm, task_type: TaskType, ...):
    key = (algorithm, task_type)
    if key not in cls._registry:
        available_algorithms = [f"{alg} ({tt})" for (alg, tt) in cls._registry.keys()]
        raise ModelNotFoundError(algorithm, task_type, available_algorithms)
        # ↑ Provides helpful list of available options
    
    try:
        module = importlib.import_module(registry_entry.module_path)
    except ModuleNotFoundError as e:
        raise ModelCreationError(str(algorithm), f"module import failed", e)
        # ↑ Wrapped exception with context
`
```



== 7. Data Flow Architecture


=== 7.1 Complete Flow Diagram


```
`┌─────────────────────────────────────────────────────────┐
│ START: User runs orchestrator                           │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
        ┌──────────────────────────┐
        │  initialize_model_registry()                  
        │  - Registers 10 algorithms
        └────────────┬─────────────┘
                     │
                     ▼
        ┌──────────────────────────┐
        │  run_selector()                               
        │  - get analysis_type
        │  - get dataset + config
        │  - get algorithm(s)
        │  - get options (test_size, SHAP, LLM)
        └────────────┬─────────────┘
                     │
                     ▼
        ┌──────────────────────────┐
        │  run_pipeline(config)                         
        │  - Facade entry point
        └────────────┬─────────────┘
                     │
        ╔════════════╩════════════╗
        ║   For each algorithm    ║
        ╚════════════╤════════════╝
                     │
                     ▼
        ┌──────────────────────────┐
        │  BasePipeline.run()                           
        │  - Template method
        └──────────┬───────┬──────┘
                   │       │
        ┌──────────┘       └──────────┐
        │                             │
        ▼                             ▼
    STEP 1:                       STEP 2:
    load_model()                  load_data()
        │                             │
        ├─ ModelFactory.create()     ├─ DataPipeline.process()
        │  ├─ Registry lookup        │  ├─ DataLoader.load_data()
        │  ├─ Dynamic import         │  ├─ DataValidator.validate()
        │  └─ Instantiate            │  ├─ DataProcessor.encode()
        │                            │  └─ DataSplitter.split()
        │                             │
        ▼                             ▼
    BaseMLAlgo instance           Tuple[X_train, X_test, y_train, y_test]
        │
        ├─ STEP 3: fit()
        │  └─ Algorithm-specific training + hyperparameter optimization
        │
        ├─ STEP 4: plots()
        │  └─ Algorithm-specific visualizations
        │
        ├─ STEP 5: shap() [if enabled]
        │  ├─ SHAPAnalyzerAdapter.explain()
        │  │  ├─ _extract_model_type()
        │  │  ├─ select_explainer_strategy()
        │  │  └─ _create_explainer()
        │  │     ├─ SHAPTreeExplainer (for tree models)
        │  │     └─ SHAPKernelExplainer (for non-tree models)
        │  └─ ExplainerResult (with plot_paths)
        │
        ├─ STEP 6: export()
        │  ├─ calculate_metrics()
        │  ├─ Save metrics.json
        │  ├─ Save coefficients.csv
        │  └─ Return export_results
        │
        └─ STEP 7: llm() [if enabled]
           ├─ Load metrics from JSON
           ├─ Load coefficients from CSV
           ├─ Encode plot images to base64
           ├─ LLMRequestManager.analyze_statistics()
           │  ├─ Generate prompt with context
           │  ├─ Parallel API calls to multiple LLMs
           │  └─ Collect responses
           └─ Save LLM_Analysis_Report.md

                     │
        ╔════════════╩════════════╗
        ║   Aggregate results     ║
        ╚════════════╤════════════╝
                     │
                     ▼
        ┌──────────────────────────┐
        │  Results aggregation     │
        │  - Single: return results
        │  - Comparative: print metrics comparison
        └────────────┬─────────────┘
                     │
                     ▼
        ┌──────────────────────────┐
        │  END: Return results_map │
        │  {algo_name: output}     │
        └──────────────────────────┘
`
```



== 8. Testing Architecture


=== 8.1 Unit Testing Strategy


```
`# ✓ Each component testable in isolation

# Test DataLoader
def test_csv_loader():
    loader = CSVDataLoader("test_data.csv")
    df = loader.load_data()
    assert df.shape == (100, 10)

# Test DataValidator
def test_schema_validator():
    validator = SchemaValidator(min_rows=10)
    df = pd.DataFrame(...)
    assert validator.validate(df, "target_col") == True

# Test Algorithm
def test_xgboost_classifier():
    model = XGBoostC(dataset="test", dataset_path="path")
    model.import_data([...], "target")
    model.fit(X_train, y_train, X_test, y_test)
    metrics = model.calculate_metrics()
    assert "Accuracy" in metrics

# Test Adapter
def test_shap_adapter():
    adapter = SHAPAnalyzerAdapter(model, x_train, "plot_dir", TaskType.CLASSIFICATION)
    result = adapter.explain(x_sample, "feature_name")
    assert isinstance(result, ExplainerResult)
`
```


=== 8.2 Integration Testing Strategy


```
`# ✓ Test component interactions

# Test Data Pipeline
def test_data_pipeline():
    loader = CSVDataLoader("test.csv")
    validator = SchemaValidator()
    processor = PandasDataProcessor()
    splitter = StratifiedDataSplitter(DataSplitConfig())
    
    pipeline = DataPipeline(loader, validator, processor, splitter)
    X_train, X_test, y_train, y_test, X = pipeline.process(...)
    
    assert len(X_train) > 0
    assert len(X_test) > 0

# Test Algorithm with Pipeline
def test_algorithm_full_workflow():
    algo = XGBoostC("Student Salary Dataset", "path/to/data.csv")
    X_train, X_test, y_train, y_test = algo.import_data([...], "salary")
    algo.fit(X_train, y_train, X_test, y_test)
    metrics = algo.calculate_metrics()
    plots = algo.generate_plots()
    results = algo.export_results()
    
    assert len(metrics) > 0
    assert len(plots) > 0
`
```



== 9. Performance Considerations


=== 9.1 Dynamic Imports


```
`# model_factory.py - Dynamic loading defers imports until needed
module = importlib.import_module(registry_entry.module_path)  # Only when creating
model_class = getattr(module, registry_entry.class_name)
`
```


*Benefit*: Application starts fast; modules loaded only when used


=== 9.2 Lazy Strategy Selection


```
`# adapter.py - Strategy selected at runtime
strategy = select_explainer_strategy(algorithm, task_type)  # After model is known
explainer = self._create_explainer(strategy)  # Only one strategy instantiated
`
```


*Benefit*: Memory efficient; doesn't load unnecessary explainers


=== 9.3 Parallel LLM Requests


```
`# LLMRequestManager.py - Concurrent API calls
with concurrent.futures.ThreadPoolExecutor(max_workers=1) as executor:
    futures = {
        executor.submit(fetch_model_response, m, ...): m 
        for m in model_list_img_supp
    }
    for future in concurrent.futures.as_completed(futures):
        ...
`
```


*Benefit*: Multiple LLM models queried in parallel



== 10. Summary: Key Architectural Strengths


#table(
  columns: 3,
  "Strength", "Mechanism", "Benefit",
  "Modularity", "Component independence via abstraction", "Easy to test, modify, extend",
  "Extensibility", "Open/Closed Principle + Registry", "Add algorithms without modifying existing code",
  "Flexibility", "Strategy + Template Method patterns", "Runtime algorithm selection with fixed workflow",
  "Decoupling", "Dependency Inversion", "High-level code independent of low-level details",
  "Reusability", "Composition over inheritance", "Same components across different algorithms",
  "Maintainability", "Single Responsibility", "Each class has one reason to change",
  "Testability", "Interface-driven design", "Easy to mock and isolate components",
  "Error Handling", "Exception hierarchy + context", "Clear error messages aid debugging",
  "Scalability", "Facade + Registry patterns", "Easy to add new algorithms/data sources",
  "Clarity", "Clear separation of concerns", "Code intent obvious from structure",
)



== 11. Conclusion


The ML Pipeline architecture exemplifies *professional software engineering* through:



  1. *SOLID Principles*: Applied consistently across codebase

  1. *Design Patterns*: Used judiciously to solve specific problems

  1. *Modularity*: Components can evolve independently

  1. *Extensibility*: New features added without modifying existing code

  1. *Maintainability*: Clear structure makes long-term evolution easier

  1. *Testability*: Components easily tested in isolation and integration


The system demonstrates that *good architecture* isn't about complexity—it's about *clarity, flexibility, and maintainability*.


Every design decision is justified, every pattern serves a purpose, and every component has a single, well-defined responsibility. This is a blueprint for building scalable, maintainable ML systems.



*Document Generated*: June 2026
*Architecture Version*: 1.0
*System*: ML Pipeline with Interpretability Analysis

