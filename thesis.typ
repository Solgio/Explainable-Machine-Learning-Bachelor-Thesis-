#import "./config/variables.typ": *
#import "./config/thesis-config.typ": *
#import "@preview/glossarium:0.5.9": make-glossary, register-glossary
#import "./appendix/glossarium/terms.typ": terms

#show: config.with(
  myAuthor: myName,
  myTitle: myTitle,
  myNumbering: "1.1",
  myLang: myLang
)

#include "structure.typ"
