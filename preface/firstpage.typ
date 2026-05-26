#let logo = "../images/unipd-logo-cropped.svg"
#import "../config/variables.typ": myUni, myDepartment, myFaculty, myTitle, myDegree, profTitle, myProf, myName, myMatricola, myAA
#import "../config/constants.typ": supervisor, undergraduate, academicYear, ID

#set page(numbering: none)

#grid(
    columns: (auto),
    rows: (130pt, 1fr , 10pt),
    // Intestazione
    [
        #align(center, text(18pt, weight: "semibold", myUni))
        #v(1em)
        #align(center, text(14pt, weight: "light", smallcaps(myDepartment)))
        #v(1em)
        #align(center, text(12pt, weight: "light", smallcaps(myFaculty)))
    ],
    // Corpo
    [
        // Logo
        #align(center, image(logo, width: 60%))
        #v(60pt)

        // Titolo
        #align(center, text(18pt, hyphenate: false, weight: "semibold", myTitle))
        #v(10pt)
        #align(center, text(12pt, weight: "light", style: "italic", myDegree))
        #v(30pt)

        // Relatore e laureando
        #grid(
            columns: (1fr, 1fr), // Divides the space into two equal columns
            align(left)[
                #text(12pt, weight: 400, style: "italic", supervisor)
                #v(5pt)
                #text(11pt, profTitle + " " + myProf)
            ],
            align(right)[
                #text(12pt, weight: 400, style: "italic", undergraduate)
                #v(5pt)
                #text(11pt, myName)
                #v(5pt)
                #text(11pt, [_ #ID _ ] + myMatricola)
            ]
        )
        #v(30pt)
    ],
    // Piè di pagina
    [
        // Anno accademico
        #line(length: 100%)
        #align(center, text(8pt, weight: 400, smallcaps(academicYear + " " + myAA)))
    ]

)