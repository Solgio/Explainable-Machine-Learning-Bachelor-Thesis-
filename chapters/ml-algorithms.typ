#pagebreak(to:"odd")
#import "../appendix/glossarium/terms.typ": terms
#import "@preview/glossarium:0.5.9": gls

= ML algorithms analysis
<cap:ml-algorithms-analysis>

#v(1em)
#text(style: "italic", [
    In this chapter, we will analyze the machine learning algorithms used in the project, looking at the mathematical foundations, the data requirements, the predictive performance, and the interpretability of the results. \
    This initial analysis will guide the design and implementation of the pipeline as well as the creation of the specific prompts for the #gls("large language model", plural: true) to generate human-readable explanations of the results. \
])

#v(1em)

#include("./algo/LR.typ")
//#include("./algo/LogR.typ")
//#include("./algo/SVM.typ")
//#include("./algo/DecisionTree.typ")
//#include("./algo/RandomForest.typ")
//#include("./algo/XGBoost.typ")

== ...
