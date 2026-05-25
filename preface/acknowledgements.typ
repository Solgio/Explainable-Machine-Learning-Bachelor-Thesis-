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

#text(style: "italic", "TO DO " + profTitle + myProf + " .")

#linebreak()

#text(style: "italic", "TO DO")

#linebreak()

#text(style: "italic", "TO DO")

#v(2em)

#text(style: "italic", myLocation + ", " + myTime + h(1fr) + myName)

#v(1fr)