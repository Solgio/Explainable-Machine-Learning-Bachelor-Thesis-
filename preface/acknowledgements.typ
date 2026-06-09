#import "../config/variables.typ" : profTitle, myProf, myLocation, myTime, myName
#import "../config/constants.typ" : acknowledgements

#set par(first-line-indent: 0pt)
#set page(numbering: "i")

#align(right, [
    #text(style: "italic", "TO DO")
    #v(6pt)
    #sym.dash#sym.dash#sym.dash TO DO
])

#v(10em)

#text(24pt, weight: "semibold", acknowledgements)

#v(3em)

#text(style: "italic", "Firstly, I would like to thank " + profTitle + " " +myProf + " for their guidance and support during the writing of this thesis and along all the duration of the stage.")

#linebreak()

#text(style: "italic", "Then, I would like to thank my friends and family for the encouragement during all my university years.")

#linebreak()

#text(style: "italic", "A special thanks to Filippo, Nicola and Riccardo, always there to share our ups and downs, and to my girlfriend, for the love and support.")

#v(2em)

#text(style: "italic", myLocation + ", " + myTime + h(1fr) + myName)

#v(1fr)