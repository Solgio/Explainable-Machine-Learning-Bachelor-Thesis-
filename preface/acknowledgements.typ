#import "../config/variables.typ" : profTitle, myProf, myLocation, myTime, myName
#import "../config/constants.typ" : acknowledgements

#set par(first-line-indent: 0pt)
#set page(numbering: "i")

#v(10em)

#text(24pt, weight: "semibold", acknowledgements)

#v(3em)

#text(style: "italic", "Firstly, I would like to thank " + profTitle + " " + myProf + " for their guidance and support during the writing of this thesis and throughout the duration of the internship. I would also like to express my gratitude to the team at Zucchetti for the opportunity to work on this project and to gain this valuable experience.")

#linebreak()

#text(style: "italic", "Furthermore, I would like to thank my friends and family for their encouragement throughout my university years.")

#linebreak()

#text(style: "italic", "Special thanks to Filippo, Nicola, and Riccardo, who were always there to share the ups and downs, and to Alessia, for her love and constant support.")

#v(2em)

#text(style: "italic", myLocation + ", " + myTime + h(1fr) + myName)

#v(1fr)