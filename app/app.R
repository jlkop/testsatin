library(shiny)

# Définir l'interface utilisateur (UI)
ui <- fluidPage(
  titlePanel("Analyse des réponses au questionnaire SATIN"),

  # Onglets
  tabsetPanel(
    tabPanel("INTRODUCTION",
             sidebarLayout(
               sidebarPanel(
                 # Menu pour sélectionner le fichier
                 fileInput("file", "Choisir un fichier CSV")
               ),
               mainPanel(
                 # Contenu spécifique à l'onglet "Introduction "
                 tags$h2 ("A lire attentivement avant de commencer"),
                 tags$h4 ("Cette application permet de procéder de manière interactive à l'analyse des réponses au",
                          tags$a(href = "https://sites.google.com/view/questsatin/home", "questionnaire SATIN", target = "_blank")),
                 tags$h4("Il faut commencer par charger le fichier de données contenant les réponses en cliquant sur le bouton",
                         tags$em("'Browse'"), "ci-contre"),
                 tags$h4("Ce fichier de données doit être construit en respectant scrupuleusement les indications fournies dans le fichier suivant :",
                         tags$a(href = "https://drive.google.com/open?id=1DIJAW00_3itUZABasqdcM-15k2v06QBQ", "Procédure saisie satin v3.0", target = "_blank")),
                 tags$h4 ("Un fichier EXCEL pré-formaté pour la saisie est fourni :",
                          tags$a(href = "https://docs.google.com/spreadsheets/d/0By4lD-8bu4BSb3oxVHhLVmdqb1E/edit?usp=sharing&ouid=108771019823171332662&resourcekey=0-sv6yPwXfoY6pAKYXgElieA&rtpof=true&sd=true", "Fichier excel", target = "_blank")),
                 tags$h4("Pour tester l'application, il est possible de télécharger des fichiers de données fictives :"),
                 tags$ul(
                   tags$li(tags$p(tags$a(href = "https://drive.google.com/open?id=1NSsYHJ8LwkRX__p3YzU8pvo6js6Mqa6T", "fichier de données avec 21 répondants", target = "_blank"))),
                   tags$li(tags$p(tags$a(href = "https://drive.google.com/open?id=1wq8uKjHNz1VKVtpppuaHk_ZxOm6U-MPs", "fichier de données avec 147 répondants", target = "_blank"))),
                   tags$li(tags$p(tags$a(href = "https://drive.google.com/open?id=1sd7PO9Pf_l7xKNy9lqBzPiXQXZkpVMND", "fichier de données avec 250 répondants", target = "_blank"))),
                   tags$li(tags$p(tags$a(href = "https://drive.google.com/open?id=1j6InyZHFwhDGr-dZ3T7d2Z09PfrCia5L", "fichier de données avec 1323 répondants", target = "_blank")))
                 ),

                 tags$h4("L'application est divisée en 6 onglets (en plus de celui-ci) :"),
                 tags$ul(
                   tags$li(tags$b ("Onglet 1 : Les caractéristique des répondants."),
                           "Il permet d'obtenir les tableaux de fréquence des différentes caractéristiques des répondants (sexe, âge...) ainsi qu'un diagramme en barres pour chaque caractéristique"),
                   tags$li(tags$b ("Onglet 2 : Les réponses aux items."),
                           "Il permet d'obtenir les tableaux de fréquence des réponses à chaque item du questionnaire ainsi que le diagramme en barres correspondant"),
                   tags$li(tags$b ("Onglet 3 : Les scores avec les items." ),
                           "Pour chacun des scores (scores de santés, scores de perception de l'environnement de travail...), statistiques descriptives (moyenne, médiane...), représentations graphiques (histogramme, boite à moustaches [boxplot], tableaux de fréquences de tous les items composant le score et diagrammes en barres"),
                   tags$li(tags$b ("Onglet 4 : Corrélations entre les scores." ),
                           "Représentation graphique de la relation entre les scores deux à deux (nuage de points) et valeur de la corrélation"),
                   tags$li(tags$b ("Onglet 5 : Scores en fonction des caractéristiques des répondants."),
                           "Statistiques descriptives des scores en fonction des caractéristiques des répondants (sexe, âge, ...), représentation graphique de ces statistiques (boxplot) et pourcentage de variance expliquée"),
                   tags$li(tags$b ("Onglet 6 : Items en fonction des caractéristiques des répondants."),
                           "Statistiques descriptives aux items en fonction des caractéristiques des répondants (sexe, âge, ...), représentation graphique de ces statistiques (boxplot) et pourcentage de variance expliquée")
                 )


               )
             )

    ),

    tabPanel("Les CARACTERISTIQUES des REPONDANTS",
             sidebarLayout(
               sidebarPanel(
                 # Menu pour sélectionner les variables
                 selectInput("caract", "Choisir une caractéristique", "")
               ),
               mainPanel(
                 h1(textOutput("caractLabel")),
                 tableOutput("freqTableCaract"),
                 plotOutput("barPlotCaract")
               )
             )
    ),


    tabPanel("Les REPONSES aux ITEMS",
             sidebarLayout(
               sidebarPanel(
                 # Menu pour sélectionner les variables du fichier
                 selectInput("item", "Choisir un item", "")
               ),
               mainPanel(
                 h1(textOutput("itemLabel")),
                 tableOutput("freqTable"),
                 plotOutput("barPlot")
               )
             )
    ),

    tabPanel("Les SCORES avec les ITEMS",
             sidebarLayout(
               sidebarPanel(
                 # Menu pour sélectionner les variables créées
                 selectInput("varNew", "Choisir un score", "")
               ),
               mainPanel(
                 # Contenu spécifique à l'onglet
                 h1(textOutput("scoreLabel")),
                 br(), br(),
                 tags$h4 (tags$strong (tags$em (("Statistiques descriptives du score")))),
                 tableOutput("descScore"),
                 br(), br(),
                 tags$h4 (tags$strong (tags$em (("Histogramme et boite à moustaches du score")))),
                 plotOutput("plotScore"),
                 tags$h4 (tags$strong (tags$em (("Distributions des réponses aux items composant le score")))),
                 tableOutput("freqTableItemsScore"),
                 br(), br(),
                 tags$h4 (tags$strong (tags$em (("Diagrammes en barres des items composant le score")))),
                 plotOutput("barPlotItemsScore"),
                 plotOutput("legende")
               )
             )
    ),

    tabPanel("CORRELATIONS entre SCORES",
             sidebarLayout(
               sidebarPanel(
                 # Menu pour sélectionner le premier score
                 selectInput("score1", "Choisir le score sur l'axe des abscisses", ""),
                 # Menu pour sélectionner le second score
                 selectInput("score2", "Choisir le score sur l'axe des ordonnées", "")
               ),
               mainPanel(
                 # Contenu spécifique à l'onglet
                 h1(textOutput("titreCor")),
                 plotOutput("plotCor"),
                 h4(textOutput("valeurCor"))
               )
             )
    ),

    tabPanel("SCORES en fonction des CARACTERISTIQUES des REPONDANTS",
             sidebarLayout(
               sidebarPanel(
                 # Menu pour sélectionner le score
                 selectInput("score", "Choisir le score", ""),
                 # Menu pour sélectionner la variable indépendante
                 selectInput("vi", "Choisir la caractéristique personnelle", "")
               ),
               mainPanel(
                 # Contenu spécifique à l'onglet
                 h1(textOutput("titrediffScores")),
                 plotOutput("plotdiffScores"),
                 tags$h4 (tags$em ("Le trait noir central représente la médiane ; le rond rouge représente la moyenne")),
                 br(), br(), br(),
                 tableOutput("descdiffScores"),
                 h4 (textOutput ("etadiffScores"))
               )
             )
    ),

    tabPanel("ITEMS en fonction des CARACTERISTIQUES des REPONDANTS",
             sidebarLayout(
               sidebarPanel(
                 # Menu pour sélectionner le score
                 selectInput("item2", "Choisir un item", ""),
                 # Menu pour sélectionner la variable indépendante
                 selectInput("vi2", "Choisir la caractéristique personnelle", "")
               ),
               mainPanel(
                 # Contenu spécifique à l'onglet
                 h1(textOutput("titrediffItems")),
                 plotOutput("plotdiffItems"),
                 tags$h4 (tags$em ("Le trait noir central représente la médiane ; le rond rouge représente la moyenne")),
                 br(), br(), br(),
                 tableOutput("descdiffItems"),
                 h4 (textOutput ("etadiffItems"))
               )
             )
    ),



  )
)



# Packages et fonctions nécessaires ---------------------------------------
# Charger la bibliothèque Shiny
library(shiny)

# Fonction pour créer un tableau récapitulatif
modalites <- c(1, 2, 3, 4, 5, NA)
creer_tableau_recap <- function(data, variables, modalites) {
  tableau_recap <- matrix(0, nrow = length(variables), ncol = length(modalites))
  colnames(tableau_recap) <- as.character(modalites)
  rownames(tableau_recap) <- variables

  for (i in seq_along(variables)) {
    for (j in seq_along(modalites)) {
      if (is.na(modalites[j])) {
        tableau_recap[i, j] <- sum(is.na(data[[variables[i]]]))
      } else {
        tableau_recap[i, j] <- sum(data[[variables[i]]] == modalites[j], na.rm = TRUE)
      }
    }
  }

  # Renommer la colonne des NA
  colnames(tableau_recap)[colnames(tableau_recap) == "NA"] <- "NA_col"

  return(tableau_recap)
}





# Labels des variables et des modalités -----------------------------------
# Définir la correspondance entre les noms de variable et les étiquettes
labels_mapping <- c(secteur = "Secteur",
                    collectif = "Collectif",
                    q1 = "Sexe",
                    q2 = "Age",
                    q3 = "Catégorie socio-professionnelle",
                    q4 = "Horaires postés",
                    q5 = "Travail le week-end",
                    q6 = "Travail la nuit",
                    q7 = "Horaires de travail non réguliers",
                    q8 = "Horaires de travail non continus dans la journée",
                    q9 = "Ancienneté dans l'entreprise",
                    q10 = "Ancienneté dans le poste actuel",
                    q11 = "Je trouve que ma santé est globalement",
                    q12 = "Par rapport à l’année dernière, ma santé est",
                    q13 = "Je trouve que mon moral est globalement",
                    q14 = "Ma confiance en l’avenir est globalement",
                    q15 = "Dans 2 ans, ma santé devrait me permettre \n d’occuper le même poste qu’aujourd’hui",
                    q16 = "J’ai des douleurs dans le dos ou dans le cou",
                    q17 = "J’ai des douleurs dans les bras (épaule, \n coude, poignet,main)",
                    q18 = "J’ai des douleurs dans les jambes (hanche, \n genou,cheville, pied)",
                    q19 = "J'ai des douleurs quand je fais certains gestes \n ou dans certaines postures",
                    q20 = "J’ai des difficultés à dormir",
                    q21 = "J’ai des maux de tête",
                    q22 = "J’ai des problèmes de digestion (exemples : \n brûlures d’estomac, ballonnements, diarrhée)",
                    q23 = "J’ai des douleurs dans la poitrine",
                    q24 = "Je me sens stressé(e) par mon travail",
                    q25 = "Je sens que je craque à cause de mon travail",
                    q26 = "Je me sens lessivé(e) par mon travail",
                    q27 = "Concernant les efforts physiques que \n je dois fournir, mon travail est",
                    q28 = "Concernant les efforts de réflexion ou d’attention \n que je dois fournir, mon travail est",
                    q29 = "Concernant les efforts que je dois \n fournir pour contrôler mes émotions \n (ne pas m’énerver, ne pas “craquer”, \n m’entendre avec les autres, …), mon travail est",
                    q30 = "Concernant les connaissances ou compétences \n que je dois utiliser, mon travail est",
                    q31 = "Mes capacités physiques sont",
                    q32 = "Mes capacités de réflexion ou d’attention sont",
                    q33 = "Mes capacités à contrôler mes émotions sont",
                    q34 = "Mes connaissances ou compétences sont",
                    q35 = "Les caractéristiques physiques de mon \n environnement de travail (ambiance sonore, \n lumineuse, conditions climatiques…)",
                    q36 = "La prise en compte des risques liés à mon travail",
                    q37 = "L’aménagement des lieux où je travaille",
                    q38 = "L’aspect général des lieux où je travaille",
                    q39 = "Le matériel dont je dispose pour travailler \n (adapté, en bon état, quantité suffisante…)",
                    q40 = "Globalement, mon environnement \n physique de travail",
                    q41 = "L’intérêt que je trouve dans mon travail",
                    q42 = "La variété de ce que je fais dans mon travail",
                    q43 = "L’utilité de ce que je fais",
                    q44 = "Les responsabilités qui me sont données",
                    q45 = "La diversité des contacts que mon travail entraîne",
                    q46 = "La qualité des relations que j’ai avec les \n personnes extérieures à l’entreprise",
                    q47 = "Globalement, ce que je fais dans mon travail \n (exigences, variété, utilité, …)",
                    q48 = "La clarté des informations que l’on me donne \n pour réaliser mon travail",
                    q49 = "La cohérence des informations (consignes…)",
                    q50 = "La cohérence avec la définition de mon poste",
                    q51 = "La manière dont l’équipe est dirigée",
                    q52 = "Savoir si mon travail est de qualité ou non",
                    q53 = "La liberté dans la manière de réaliser mon travail",
                    q54 = "La liberté d’adapter mon rythme de travail",
                    q55 = "Les liens entre mon travail et celui des autres",
                    q56 = "L’aide que je reçois pour mener à bien mon travail",
                    q57 = "Le soutien moral que je peux recevoir au travail",
                    q58 = "Les interruptions qui ont lieu dans mon travail",
                    q59 = "Les délais dont je dispose pour faire mon travail",
                    q60 = "Globalement, le cadrage de mon activité",
                    q61 = "Mes horaires de travail",
                    q62 = "Le nombre d’heures que je consacre à mon travail",
                    q63 = "La manière dont je peux évoluer dans l’entreprise",
                    q64 = "Ma rémunération",
                    q65 = "Les possibilités de développer mes compétences",
                    q66 = "Les modalités d’évaluation de mon travail",
                    q67 = " La manière dont les personnes sont traitées",
                    q68 = "La manière dont les avis sont pris en compte",
                    q69 = "L’ambiance qui règne dans l’entreprise",
                    q70 = "La communication de l’entreprise",
                    q71 = "Le niveau de sécurité d’emploi dans l’entreprise",
                    q72 = "Les évolutions de l’entreprise et du secteur",
                    q73 = "Globalement, le contexte organisationnel",
                    q74 = "J’aime mon travail",
                    q75 = "Globalement, je me sens bien dans l’entreprise"
)

labels_mapping_items_n <- c(q11n = "Je trouve que ma santé est globalement",
                            q12n = "Par rapport à l’année dernière, ma santé est",
                            q13n = "Je trouve que mon moral est globalement",
                            q14n = "Ma confiance en l’avenir est globalement",
                            q15n = "Dans 2 ans, ma santé devrait me permettre \n d’occuper le même poste qu’aujourd’hui",
                            q16n = "J’ai des douleurs dans le dos ou dans le cou",
                            q17n = "J’ai des douleurs dans les bras (épaule, \n coude, poignet,main)",
                            q18n = "J’ai des douleurs dans les jambes (hanche, \n genou,cheville, pied)",
                            q19n = "J'ai des douleurs quand je fais certains gestes \n ou dans certaines postures",
                            q20n = "J’ai des difficultés à dormir",
                            q21n = "J’ai des maux de tête",
                            q22n = "J’ai des problèmes de digestion (exemples : \n brûlures d’estomac, ballonnements, diarrhée)",
                            q23n = "J’ai des douleurs dans la poitrine",
                            q24n = "Je me sens stressé(e) par mon travail",
                            q25n = "Je sens que je craque à cause de mon travail",
                            q26n = "Je me sens lessivé(e) par mon travail",
                            q27n = "Concernant les efforts physiques que \n je dois fournir, mon travail est",
                            q28n = "Concernant les efforts de réflexion ou d’attention \n que je dois fournir, mon travail est",
                            q29n = "Concernant les efforts que je dois \n fournir pour contrôler mes émotions \n (ne pas m’énerver, ne pas “craquer”, \n m’entendre avec les autres, …), mon travail est",
                            q30n = "Concernant les connaissances ou compétences \n que je dois utiliser, mon travail est",
                            q31n = "Mes capacités physiques sont",
                            q32n = "Mes capacités de réflexion ou d’attention sont",
                            q33n = "Mes capacités à contrôler mes émotions sont",
                            q34n = "Mes connaissances ou compétences sont",
                            q35n = "Les caractéristiques physiques de mon \n environnement de travail (ambiance sonore, \n lumineuse, conditions climatiques…)",
                            q36n = "La prise en compte des risques liés à mon travail",
                            q37n = "L’aménagement des lieux où je travaille",
                            q38n = "L’aspect général des lieux où je travaille",
                            q39n = "Le matériel dont je dispose pour travailler \n (adapté, en bon état, quantité suffisante…)",
                            q40n = "Globalement, mon environnement \n physique de travail",
                            q41n = "L’intérêt que je trouve dans mon travail",
                            q42n = "La variété de ce que je fais dans mon travail",
                            q43n = "L’utilité de ce que je fais",
                            q44n = "Les responsabilités qui me sont données",
                            q45n = "La diversité des contacts que mon travail entraîne",
                            q46n = "La qualité des relations que j’ai avec les \n personnes extérieures à l’entreprise",
                            q47n = "Globalement, ce que je fais dans mon travail \n (exigences, variété, utilité, …)",
                            q48n = "La clarté des informations que l’on me donne \n pour réaliser mon travail",
                            q49n = "La cohérence des informations (consignes…)",
                            q50n = "La cohérence avec la définition de mon poste",
                            q51n = "La manière dont l’équipe est dirigée",
                            q52n = "Savoir si mon travail est de qualité ou non",
                            q53n = "La liberté dans la manière de réaliser mon travail",
                            q54n = "La liberté d’adapter mon rythme de travail",
                            q55n = "Les liens entre mon travail et celui des autres",
                            q56n = "L’aide que je reçois pour mener à bien mon travail",
                            q57n = "Le soutien moral que je peux recevoir au travail",
                            q58n = "Les interruptions qui ont lieu dans mon travail",
                            q59n = "Les délais dont je dispose pour faire mon travail",
                            q60n = "Globalement, le cadrage de mon activité",
                            q61n = "Mes horaires de travail",
                            q62n = "Le nombre d’heures que je consacre à mon travail",
                            q63n = "La manière dont je peux évoluer dans l’entreprise",
                            q64n = "Ma rémunération",
                            q65n = "Les possibilités de développer mes compétences",
                            q66n = "Les modalités d’évaluation de mon travail",
                            q67n = " La manière dont les personnes sont traitées",
                            q68n = "La manière dont les avis sont pris en compte",
                            q69n = "L’ambiance qui règne dans l’entreprise",
                            q70n = "La communication de l’entreprise",
                            q71n = "Le niveau de sécurité d’emploi dans l’entreprise",
                            q72n = "Les évolutions de l’entreprise et du secteur",
                            q73n = "Globalement, le contexte organisationnel",
                            q74n = "J’aime mon travail",
                            q75n = "Globalement, je me sens bien dans l’entreprise"
)

# Définir la correspondance entre les codes de modalité et les étiquettes
modality_labels_mapping <- list(q1 = c("1" = "masculin", "2" = "féminin"),
                                q2 = c("1" = "moins de 25 ans", "2" = "entre 25 et 34 ans", "3" = "entre 35 et 44 ans",
                                       "4" = "entre 45 et 54 ans", "5" = "55 et plus"),
                                q3 = c("1" = "employé(e) de bureau", "2" = "technicien(ne)", "3" = "ouvrier(e)",
                                       "4" = "assimilé(e) cadre", "5" = "agent de maîtrise", "6" = "cadre"),
                                q4 = c("1" = "non", "2" = "en 3x8", "3" = "en 2x8", "4" = "autre type de poste"),
                                q5 = c("1" = "jamais", "2" = "exceptionnellement", "3" = "régulièrement", "4" = "presque toujours"),
                                q6 = c("1" = "jamais", "2" = "exceptionnellement", "3" = "régulièrement", "4" = "presque toujours"),
                                q7 = c("1" = "jamais", "2" = "exceptionnellement", "3" = "régulièrement", "4" = "presque toujours"),
                                q8 = c("1" = "jamais", "2" = "exceptionnellement", "3" = "régulièrement", "4" = "presque toujours"),
                                q9 = c("1" = "moins d'un an", "2" = "entre 1 et 5 ans", "3" = "entre 6 et 15 ans",
                                       "4" = "entre 16 et 25 ans", "5" = "26 ans et plus"),
                                q10 = c("1" = "moins d'un an", "2" = "entre 1 et 5 ans", "3" = "entre 6 et 15 ans",
                                        "4" = "entre 16 et 25 ans", "5" = "26 ans et plus"),
                                q11 = c("1" = "très mauvaise", "2" = "mauvaise", "3" = "ni bonne, ni mauvaise",
                                        "4" = "bonne", "5" = "très bonne"),
                                q12 = c("1" = "très mauvaise", "2" = "mauvaise", "3" = "ni bonne, ni mauvaise",
                                        "4" = "bonne", "5" = "très bonne"),
                                q13 = c("1" = "très mauvais", "2" = "mauvais", "3" = "ni bon, ni mauvais",
                                        "4" = "bon", "5" = "très bon"),
                                q14 = c("1" = "très mauvaise", "2" = "mauvaise", "3" = "ni bonne, ni mauvaise",
                                        "4" = "bonne", "5" = "très bonne"),
                                q15 = c("1" = "non, pas du tout", "2" = "plutôt non", "3" = "ni oui, ni non",
                                        "4" = "plutôt oui", "5" = "oui, tout à fait"),
                                q16 = c("1" = "tous les jours ou presque", "2" = "1 ou 2 fois par semaine", "3" = "1 ou 2 fois par mois",
                                        "4" = "1 ou 2 fois depuis 6 mois", "5" = "jamais depuis 6 mois"),
                                q17 = c("1" = "tous les jours ou presque", "2" = "1 ou 2 fois par semaine", "3" = "1 ou 2 fois par mois",
                                        "4" = "1 ou 2 fois depuis 6 mois", "5" = "jamais depuis 6 mois"),
                                q18 = c("1" = "tous les jours ou presque", "2" = "1 ou 2 fois par semaine", "3" = "1 ou 2 fois par mois",
                                        "4" = "1 ou 2 fois depuis 6 mois", "5" = "jamais depuis 6 mois"),
                                q19 = c("1" = "tous les jours ou presque", "2" = "1 ou 2 fois par semaine", "3" = "1 ou 2 fois par mois",
                                        "4" = "1 ou 2 fois depuis 6 mois", "5" = "jamais depuis 6 mois"),
                                q20 = c("1" = "tous les jours ou presque", "2" = "1 ou 2 fois par semaine", "3" = "1 ou 2 fois par mois",
                                        "4" = "1 ou 2 fois depuis 6 mois", "5" = "jamais depuis 6 mois"),
                                q21 = c("1" = "tous les jours ou presque", "2" = "1 ou 2 fois par semaine", "3" = "1 ou 2 fois par mois",
                                        "4" = "1 ou 2 fois depuis 6 mois", "5" = "jamais depuis 6 mois"),
                                q22 = c("1" = "tous les jours ou presque", "2" = "1 ou 2 fois par semaine", "3" = "1 ou 2 fois par mois",
                                        "4" = "1 ou 2 fois depuis 6 mois", "5" = "jamais depuis 6 mois"),
                                q23 = c("1" = "tous les jours ou presque", "2" = "1 ou 2 fois par semaine", "3" = "1 ou 2 fois par mois",
                                        "4" = "1 ou 2 fois depuis 6 mois", "5" = "jamais depuis 6 mois"),
                                q24 = c("1" = "en permanence", "2" = "souvent", "3" = "parfois", "4" = "rarement", "5" = "jamais"),
                                q25 = c("1" = "en permanence", "2" = "souvent", "3" = "parfois", "4" = "rarement", "5" = "jamais"),
                                q26 = c("1" = "en permanence", "2" = "souvent", "3" = "parfois", "4" = "rarement", "5" = "jamais"),
                                q27 = c("1" = "très dur", "2" = "dur", "3" = "ni facile, ni dur", "4" = "facile", "5" = "très facile"),
                                q28 = c("1" = "très dur", "2" = "dur", "3" = "ni facile, ni dur", "4" = "facile", "5" = "très facile"),
                                q29 = c("1" = "très dur", "2" = "dur", "3" = "ni facile, ni dur", "4" = "facile", "5" = "très facile"),
                                q30 = c("1" = "très dur", "2" = "dur", "3" = "ni facile, ni dur", "4" = "facile", "5" = "très facile"),
                                q31 = c("1" = "largement insuffisantes", "2" = "plutôt insuffisantes", "3" = "adaptées",
                                        "4" = "plus importantes \n que nécessaire", "5" = "largement plus importantes \n que nécessaire"),
                                q32 = c("1" = "largement insuffisantes", "2" = "plutôt insuffisantes", "3" = "adaptées",
                                        "4" = "plus importantes \n que nécessaire", "5" = "largement plus importantes \n que nécessaire"),
                                q33 = c("1" = "largement insuffisantes", "2" = "plutôt insuffisantes", "3" = "adaptées",
                                        "4" = "plus importantes \n que nécessaire", "5" = "largement plus importantes \n que nécessaire"),
                                q34 = c("1" = "largement insuffisantes", "2" = "plutôt insuffisantes", "3" = "adaptées",
                                        "4" = "plus importantes \n que nécessaire", "5" = "largement plus importantes \n que nécessaire"),
                                q35 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q36 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q37 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q38 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q39 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q40 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q41 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),                                 q35 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q42 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q43 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q44 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q45 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q46 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q48 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q49 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q50 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q51 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q52 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q53 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q54 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q55 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q56 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q57 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q58 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q59 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q60 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q61 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q62 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q63 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q64 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q65 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q66 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q67 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q68 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q69 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q70 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q71 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q72 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q73 = c("1" = "me contrarie fortement", "2" = "ne me convient pas", "3" = "je fais avec", "4" = "me convient", "5" = "contribue à mon \n épanouissement"),
                                q74 = c("1" = "non, pas du tout", "2" = "plutôt non", "3" = "ni oui, ni non", "4" = "plutôt oui", "5" = "oui, tout à fait"),
                                q75 = c("1" = "non, pas du tout", "2" = "plutôt non", "3" = "ni oui, ni non", "4" = "plutôt oui", "5" = "oui, tout à fait")
)


# labels_vi = c("Secteur", "Collectif", "Sexe", "Age", "Catégorie socio-professionnelle", "Horaires postés", "Travail le week-end",
#               "Travail la nuit", "Horaires de travail non réguliers", "Horaires de travail non continus dans la journée",
#               "Ancienneté dans l'entreprise", "Ancienneté dans le poste actuel")






# Définir le serveur ------------------------------------------------------
server <- function(input, output, session) {


  # PANNEAU 1 ---------------------------------------------------------------
  # texte_intro <- "
  # <h2>Bienvenue dans l'application Shiny</h2>
  #   <p>Voici quelques informations préliminaires :</p>
  #   <ul>
  #     <li><strong>Point 1 :</strong> Ceci est le premier point.</li>
  #     <li><strong>Point 2 :</strong> Ceci est le deuxième point.</li>
  #   </ul>
  # "
  #
  # output$texte_intro <- renderUI({
  #   HTML(texte_intro)
  # })
  #

  # Charger les données à partir du fichier CSV
  data <- reactiveVal(NULL)

  observeEvent(input$file, {
    req(input$file)
    raw_data <- read.csv2(input$file$datapath, stringsAsFactors = FALSE, fileEncoding = "LATIN1")

    # Supprimer les lignes vides
    raw_data <- na.omit(raw_data)

    # Convertir les valeurs "-9" en NA pour toutes les variables
    for (col in colnames(raw_data)) {
      raw_data[[col]][raw_data[[col]] == -9] <- NA
    }

    # Recoder les valeurs entre deux par une valeur soit juste inférieure soit juste supérieure pour toutes les variables
    for (col in colnames(raw_data)) {
      raw_data[[col]] <- ifelse(raw_data[[col]] == 1.5, sample(c(1, 2), length(raw_data[[col]]), replace = TRUE), raw_data[[col]])
      raw_data[[col]] <- ifelse(raw_data[[col]] == 2.5, sample(c(2, 3), length(raw_data[[col]]), replace = TRUE), raw_data[[col]])
      raw_data[[col]] <- ifelse(raw_data[[col]] == 3.5, sample(c(3, 4), length(raw_data[[col]]), replace = TRUE), raw_data[[col]])
      raw_data[[col]] <- ifelse(raw_data[[col]] == 4.5, sample(c(4, 5), length(raw_data[[col]]), replace = TRUE), raw_data[[col]])
    }

    # Définir les items comme des facteurs
    raw_data [, "q1"] <- factor (raw_data [, "q1"], levels = 1:2)
    raw_data [, "q2"] <- factor (raw_data [, "q2"], levels = 1:5)
    raw_data [, "q3"] <- factor (raw_data [, "q3"], levels = 1:6)
    raw_data [, c("q4","q5","q6","q7","q8")] <- lapply(raw_data [, c("q4","q5","q6","q7","q8")],
                                                       function (x) factor (x, levels = 1:4))
    raw_data [, c("q9","q10","q11","q12","q13","q14","q15","q16","q17","q18","q19","q20","q21","q22","q23","q24","q25")] <-
      lapply(raw_data [, c("q9","q10","q11","q12","q13","q14","q15","q16","q17","q18","q19","q20","q21","q22","q23","q24","q25")],
             function (x) factor (x, levels = 1:5))
    raw_data [, c("q26","q27","q28","q29","q30","q31","q32","q33","q34","q35","q36","q37","q38","q39","q40","q41","q42")] <-
      lapply(raw_data [, c("q26","q27","q28","q29","q30","q31","q32","q33","q34","q35","q36","q37","q38","q39","q40","q41","q42")],
             function (x) factor (x, levels = 1:5))
    raw_data [, c("q43","q44","q45","q46","q47","q48","q49","q50","q51","q52","q53","q54","q55","q56","q57","q58","q59")] <-
      lapply(raw_data [, c("q43","q44","q45","q46","q47","q48","q49","q50","q51","q52","q53","q54","q55","q56","q57","q58","q59")],
             function (x) factor (x, levels = 1:5))
    raw_data [, c("q60","q61","q62","q63","q64","q65","q66","q67","q68","q69","q70","q71","q72","q73","q74","q75")] <-
      lapply(raw_data [, c("q60","q61","q62","q63","q64","q65","q66","q67","q68","q69","q70","q71","q72","q73","q74","q75")],
             function (x) factor (x, levels = 1:5))

    # Créer des nouveaux items numériques pour calculer les scores
    raw_data [, c("q11n","q12n","q13n","q14n","q15n","q16n","q17n","q18n","q19n","q20n","q21n","q22n","q23n","q24n","q25n")] <-
      lapply(raw_data [, c("q11","q12","q13","q14","q15","q16","q17","q18","q19","q20","q21","q22","q23","q24","q25")],
             as.numeric)
    raw_data [, c("q26n","q27n","q28n","q29n","q30n","q31n","q32n","q33n","q34n","q35n","q36n","q37n","q38n","q39n","q40n","q41n","q42n")] <-
      lapply(raw_data [, c("q26","q27","q28","q29","q30","q31","q32","q33","q34","q35","q36","q37","q38","q39","q40","q41","q42")],
             as.numeric)
    raw_data [, c("q43n","q44n","q45n","q46n","q47n","q48n","q49n","q50n","q51n","q52n","q53n","q54n","q55n","q56n","q57n","q58n","q59n")] <-
      lapply(raw_data [, c("q43","q44","q45","q46","q47","q48","q49","q50","q51","q52","q53","q54","q55","q56","q57","q58","q59")],
             as.numeric)
    raw_data [, c("q60n","q61n","q62n","q63n","q64n","q65n","q66n","q67n","q68n","q69n","q70n","q71n","q72n","q73n","q74n","q75n")] <-
      lapply(raw_data [, c("q60","q61","q62","q63","q64","q65","q66","q67","q68","q69","q70","q71","q72","q73","q74","q75")],
             as.numeric)

    # calcul des scores
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q11n", "q12n")]))
    raw_data [, "santé physique"]  <- rowMeans(raw_data[, c("q11n", "q12n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 1, "santé physique"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q13n", "q14n")]))
    raw_data [, "santé psychique"]  <- rowMeans(raw_data[, c("q13n", "q14n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 1, "santé psychique"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q16n", "q17n", "q18n", "q19n")]))
    raw_data [, "symptômes physiques"]  <- rowMeans(raw_data[, c("q16n", "q17n", "q18n", "q19n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 2, "symptômes physiques"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q20n", "q21n", "q22n", "q23n")]))
    raw_data [, "symptômes psychosomatiques"]  <- rowMeans(raw_data[, c("q20n", "q21n", "q22n", "q23n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 2, "symptômes psychosomatiques"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q24n", "q25n", "q26n")]))
    raw_data [, "stress"]  <- rowMeans(raw_data[, c("q24n", "q25n", "q26n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 1, "symptômes psychosomatiques"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("santé physique", "santé psychique", "symptômes physiques", "symptômes psychosomatiques", "stress")]))
    raw_data [, "santé générale"]  <- rowMeans(raw_data[, c("santé physique", "santé psychique", "symptômes physiques", "symptômes psychosomatiques", "stress")], na.rm = TRUE)
    raw_data [raw_data$ndm > 2, "santé générale"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q27n", "q28n", "q29n", "q30n")]))
    raw_data [, "exigences"]  <- rowMeans(raw_data[, c("q27n", "q28n", "q29n", "q30n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 2, "exigences"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q31n", "q32n", "q33n", "q34n")]))
    raw_data [, "capacités"]  <- rowMeans(raw_data[, c("q31n", "q32n", "q33n", "q34n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 2, "capacités"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q35n", "q36n", "q37n", "q38n", "q39n", "q40n")]))
    raw_data [, "environnement physique"]  <- rowMeans(raw_data[, c("q35n", "q36n", "q37n", "q38n", "q39n", "q40n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 3, "environnement physique"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q41n", "q42n", "q43n", "q44n", "q45n", "q46n", "q47n")]))
    raw_data [, "activité"]  <- rowMeans(raw_data[, c("q41n", "q42n", "q43n", "q44n", "q45n", "q46n", "q47n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 3, "activité"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q48n", "q49n", "q50n", "q51n", "q52n", "q53n", "q54n", "q55n", "q56n", "q57n", "q58n", "q59n", "q60n")]))
    raw_data [, "cadrage de l'activité"]  <- rowMeans(raw_data[, c("q48n", "q49n", "q50n", "q51n", "q52n", "q53n", "q54n", "q55n", "q56n", "q57n", "q58n", "q59n", "q60n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 6, "cadrage de l'activité"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q61n", "q62n", "q63n", "q64n", "q65n", "q66n", "q67n", "q68n", "q69n", "q70n", "q71n", "q72n", "q73n")]))
    raw_data [, "contexte organisationnel"]  <- rowMeans(raw_data[, c("q61n", "q62n", "q63n", "q64n", "q65n", "q66n", "q67n", "q68n", "q69n", "q70n", "q71n", "q72n", "q73n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 6, "contexte organisationnel"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("environnement physique", "activité", "cadrage de l'activité", "contexte organisationnel")]))
    raw_data [, "environnement de travail général"]  <- rowMeans(raw_data[, c("environnement physique", "activité", "cadrage de l'activité", "contexte organisationnel")], na.rm = TRUE)
    raw_data [raw_data$ndm > 2, "environnement de travail général"] <- NA
    raw_data[, "ndm"] <- rowSums(is.na (raw_data[, c("q74n", "q75n")]))
    raw_data [, "appréciation générale du travail"]  <- rowMeans(raw_data[, c("q74n", "q75n")], na.rm = TRUE)
    raw_data [raw_data$ndm > 3, "appréciation générale du travail"] <- NA


    data(raw_data)

    # Menu déroulant pour le choix des items
    # updateSelectInput(session, "item", choices = names(data())[4:80], selected = names(data())[1])

    updateSelectInput(session, "caract", choices = c("secteur" = "secteur", "collectif" = "collectif", "q1 (sexe)" = "q1", "q2 (age)" = "q2",
                                                     "q3 (CSP)"= "q3", "q4 (Horaires postés)" = "q4", "q5 (Travail le week-end)" = "q5",
                                                     "q6 (Travail la nuit)" = "q6", "q7 (Horaires non réguliers)" = "q7",
                                                     "q8 (Horaires non continus)" = "q8", "q9 (Ancienneté entreprise)" = "q9",
                                                     "q10 (Ancienneté poste)" = "q10"
    ), selected = "q1")


    updateSelectInput(session, "item", choices = c("q11 (ma santé globalement)" = "q11",
                                                   "q12 (santé par rapport à année dernière)" = "q12",
                                                   "q13 (moral globalement)" = "q13",
                                                   "q14 (confiance en l’avenir)" = "q14",
                                                   "q15 (Dans 2 ans, même poste / santé)" = "q15",
                                                   "q16 (douleurs dos / cou)" = "q16",
                                                   "q17 (douleurs dans les bras)" = "q17",
                                                   "q18 (douleurs dans les jambes)" = "q18",
                                                   "q19 (douleurs gestes / postures)" = "q19",
                                                   "q20 (difficultés à dormir)" = "q20",
                                                   "q21 (maux de tête)" = "q21",
                                                   "q22 (problèmes de digestion)" = "q22",
                                                   "q23 (douleurs dans la poitrine)" = "q23",
                                                   "q24 (stressé(e) par travail)" = "q24",
                                                   "q25 (je craque à cause de mon travail)" = "q25",
                                                   "q26 (lessivé(e) par travail)" = "q26",
                                                   "q27 (efforts physiques de mon travail)" = "q27",
                                                   "q28 (efforts de réflexion de mon travail)" = "q28",
                                                   "q29 (efforts de contrôler des émotions de mon travail)" = "q29",
                                                   "q30 (connaissances ou compétences à utiliser)" = "q30",
                                                   "q31 (mes capacités physiques)" = "q31",
                                                   "q32 (mes capacités de réflexion)" = "q32",
                                                   "q33 (mes capacités à contrôler mes émotions)" = "q33",
                                                   "q34 (mes connaissances ou compétences)" = "q34",
                                                   "q35 (caractéristiques physiques de mon environnement)" = "q35",
                                                   "q36 (prise en compte des risques liés à mon travail)" = "q36",
                                                   "q37 (aménagement des lieux)" = "q37",
                                                   "q38 (aspect général des lieux)" = "q38",
                                                   "q39 (matériel dont je dispose)" = "q39",
                                                   "q40 (environnement physique globalement)" = "q40",
                                                   "q41 (intérêt dans travail)" = "q41",
                                                   "q42 (variété travail)" = "q42",
                                                   "q43 (utilité de ce que je fais)" = "q43",
                                                   "q44 (responsabilités données)" = "q44",
                                                   "q45 (diversité des contacts)" = "q45",
                                                   "q46 (qualité des relations personnes extérieures)" = "q46",
                                                   "q47 (ce que je fais globalement)" = "q47",
                                                   "q48 (clarté des informations)" = "q48",
                                                   "q49 (cohérence des informations)" = "q49",
                                                   "q50 (cohérence avec définition poste)" = "q50",
                                                   "q51 (manière dont équipe est dirigée)" = "q51",
                                                   "q52 (savoir si mon travail est de qualité)" = "q52",
                                                   "q53 (liberté de réalisation)" = "q53",
                                                   "q54 (liberté de rythme)" = "q54",
                                                   "q55 (liens avec travail des autres)" = "q55",
                                                   "q56 (aide que je reçois)" = "q56",
                                                   "q57 (soutien moral que je peux recevoir)" = "q57",
                                                   "q58 (interruptions)" = "q58",
                                                   "q59 (délais dont je dispose)" = "q59",
                                                   "q60 (cadrage activité globalement)" = "q60",
                                                   "q61 (horaires de travail)" = "q61",
                                                   "q62 (nombre d’heures)" = "q62",
                                                   "q63 (évolution dans entreprise)" = "q63",
                                                   "q64 (rémunération)" = "q64",
                                                   "q65 (développement de compétences)" = "q65",
                                                   "q66 (évaluation de mon travail)" = "q66",
                                                   "q67 (traitement des personnes)" = "q67",
                                                   "q68 (prise en compte des avis)" = "q68",
                                                   "q69 (ambiance dans entreprise)" = "q69",
                                                   "q70 (communication de l’entreprise)" = "q70",
                                                   "q71 (sécurité d’emploi dans l’entreprise)" = "q71",
                                                   "q72 (évolutions de l’entreprise et du secteur)" = "q72",
                                                   "q73 (contexte organisationnel globalement)" = "q73",
                                                   "q74 (j'aime mon travail)" = "q74",
                                                   "q75 (je me sens bien dans entreprise)" = "q75"
    ), selected = "q11")

    # Mettre à jour le menu déroulant pour les scores
    updateSelectInput(session, "varNew", choices = c("santé physique", "santé psychique", "symptômes physiques",
                                                     "symptômes psychosomatiques", "stress", "santé générale",
                                                     "exigences", "capacités", "environnement physique", "activité",
                                                     "cadrage de l'activité", "contexte organisationnel", "environnement de travail général",
                                                     "appréciation générale du travail", selected = ""))

    updateSelectInput(session, "score1", choices = c("santé physique", "santé psychique", "symptômes physiques",
                                                     "symptômes psychosomatiques", "stress", "santé générale",
                                                     "exigences", "capacités", "environnement physique", "activité",
                                                     "cadrage de l'activité", "contexte organisationnel", "environnement de travail général",
                                                     "appréciation générale du travail", selected = ""))

    updateSelectInput(session, "score2", choices = c("santé physique", "santé psychique", "symptômes physiques",
                                                     "symptômes psychosomatiques", "stress", "santé générale",
                                                     "exigences", "capacités", "environnement physique", "activité",
                                                     "cadrage de l'activité", "contexte organisationnel", "environnement de travail général",
                                                     "appréciation générale du travail", selected = ""))

    updateSelectInput(session, "score", choices = c("santé physique", "santé psychique", "symptômes physiques",
                                                    "symptômes psychosomatiques", "stress", "santé générale",
                                                    "exigences", "capacités", "environnement physique", "activité",
                                                    "cadrage de l'activité", "contexte organisationnel", "environnement de travail général",
                                                    "appréciation générale du travail", selected = ""))

    # updateSelectInput(session, "vi", choices = labels_vi)

    updateSelectInput(session, "vi", choices = c("secteur" = "secteur", "collectif" = "collectif", "q1 (sexe)" = "q1", "q2 (age)" = "q2",
                                                 "q3 (CSP)"= "q3", "q4 (Horaires postés)" = "q4", "q5 (Travail le week-end)" = "q5",
                                                 "q6 (Travail la nuit)" = "q6", "q7 (Horaires non réguliers)" = "q7",
                                                 "q8 (Horaires non continus)" = "q8", "q9 (Ancienneté entreprise)" = "q9",
                                                 "q10 (Ancienneté poste)" = "q10"
    ), selected = "q1")

    updateSelectInput(session, "item2", choices = c("q11 (ma santé globalement)" = "q11n",
                                                    "q12 (santé par rapport à année dernière)" = "q12n",
                                                    "q13 (moral globalement)" = "q13n",
                                                    "q14 (confiance en l’avenir)" = "q14n",
                                                    "q15 (Dans 2 ans, même poste / santé)" = "q15n",
                                                    "q16 (douleurs dos / cou)" = "q16n",
                                                    "q17 (douleurs dans les bras)" = "q17n",
                                                    "q18 (douleurs dans les jambes)" = "q18n",
                                                    "q19 (douleurs gestes / postures)" = "q19n",
                                                    "q20 (difficultés à dormir)" = "q20n",
                                                    "q21 (maux de tête)" = "q21n",
                                                    "q22 (problèmes de digestion)" = "q22n",
                                                    "q23 (douleurs dans la poitrine)" = "q23n",
                                                    "q24 (stressé(e) par travail)" = "q24n",
                                                    "q25 (je craque à cause de mon travail)" = "q25n",
                                                    "q26 (lessivé(e) par travail)" = "q26n",
                                                    "q27 (efforts physiques de mon travail)" = "q27n",
                                                    "q28 (efforts de réflexion de mon travail)" = "q28n",
                                                    "q29 (efforts de contrôler des émotions de mon travail)" = "q29n",
                                                    "q30 (connaissances ou compétences à utiliser)" = "q30n",
                                                    "q31 (mes capacités physiques)" = "q31n",
                                                    "q32 (mes capacités de réflexion)" = "q32n",
                                                    "q33 (mes capacités à contrôler mes émotions)" = "q33n",
                                                    "q34 (mes connaissances ou compétences)" = "q34n",
                                                    "q35 (caractéristiques physiques de mon environnement)" = "q35n",
                                                    "q36 (prise en compte des risques liés à mon travail)" = "q36n",
                                                    "q37 (aménagement des lieux)" = "q37n",
                                                    "q38 (aspect général des lieux)" = "q38n",
                                                    "q39 (matériel dont je dispose)" = "q39n",
                                                    "q40 (environnement physique globalement)" = "q40n",
                                                    "q41 (intérêt dans travail)" = "q41n",
                                                    "q42 (variété travail)" = "q42n",
                                                    "q43 (utilité de ce que je fais)" = "q43n",
                                                    "q44 (responsabilités données)" = "q44n",
                                                    "q45 (diversité des contacts)" = "q45n",
                                                    "q46 (qualité des relations personnes extérieures)" = "q46n",
                                                    "q47 (ce que je fais globalement)" = "q47n",
                                                    "q48 (clarté des informations)" = "q48n",
                                                    "q49 (cohérence des informations)" = "q49n",
                                                    "q50 (cohérence avec définition poste)" = "q50n",
                                                    "q51 (manière dont équipe est dirigée)" = "q51n",
                                                    "q52 (savoir si mon travail est de qualité)" = "q52n",
                                                    "q53 (liberté de réalisation)" = "q53n",
                                                    "q54 (liberté de rythme)" = "q54n",
                                                    "q55 (liens avec travail des autres)" = "q55n",
                                                    "q56 (aide que je reçois)" = "q56n",
                                                    "q57 (soutien moral que je peux recevoir)" = "q57n",
                                                    "q58 (interruptions)" = "q58n",
                                                    "q59 (délais dont je dispose)" = "q59n",
                                                    "q60 (cadrage activité globalement)" = "q60n",
                                                    "q61 (horaires de travail)" = "q61n",
                                                    "q62 (nombre d’heures)" = "q62n",
                                                    "q63 (évolution dans entreprise)" = "q63n",
                                                    "q64 (rémunération)" = "q64n",
                                                    "q65 (développement de compétences)" = "q65n",
                                                    "q66 (évaluation de mon travail)" = "q66n",
                                                    "q67 (traitement des personnes)" = "q67n",
                                                    "q68 (prise en compte des avis)" = "q68n",
                                                    "q69 (ambiance dans entreprise)" = "q69n",
                                                    "q70 (communication de l’entreprise)" = "q70n",
                                                    "q71 (sécurité d’emploi dans l’entreprise)" = "q71n",
                                                    "q72 (évolutions de l’entreprise et du secteur)" = "q72n",
                                                    "q73 (contexte organisationnel globalement)" = "q73n",
                                                    "q74 (j'aime mon travail)" = "q74n",
                                                    "q75 (je me sens bien dans entreprise)" = "q75n"
    ), selected = "q11n")

    updateSelectInput(session, "vi2", choices = c("secteur" = "secteur", "collectif" = "collectif", "q1 (sexe)" = "q1", "q2 (age)" = "q2",
                                                  "q3 (CSP)"= "q3", "q4 (Horaires postés)" = "q4", "q5 (Travail le week-end)" = "q5",
                                                  "q6 (Travail la nuit)" = "q6", "q7 (Horaires non réguliers)" = "q7",
                                                  "q8 (Horaires non continus)" = "q8", "q9 (Ancienneté entreprise)" = "q9",
                                                  "q10 (Ancienneté poste)" = "q10"
    ), selected = "q1")


  })

  # PANNEAU 2 Caractéristiques des répondants ---------------------------------------------------------------

  # Générer le titre de la variable sélectionnée
  output$caractLabel <- renderText({
    var <- input$caract
    label <- labels_mapping[var]
    if (is.null(label)) {
      label <- var  # Utilisez le nom de la variable s'il n'y a pas de correspondance dans labels_mapping
    }
    label
  })

  # Générer le tableau de fréquence en fonction de la variable sélectionnée
  output$freqTableCaract <- renderTable({
    var <- input$caract
    if (var != "") {
      # Copie locale des données
      local_data <- data()

      modality_labels <- modality_labels_mapping[[var]]

      # Traduire les codes de modalités en labels
      if (!is.null(modality_labels)) {
        local_data[[var]] <- factor(local_data[[var]], levels = names(modality_labels), labels = modality_labels)
      }

      if (var == "collectif" | var == "secteur") {
        modality_labels <- levels (factor (local_data[[var]]))
        local_data[[var]] <- factor(local_data[[var]])
      }

      tableN <- round (table(data()[[var]], useNA = "always"), 0)
      tableP <- round (table (data()[[var]], useNA = "always") / sum (table (data()[[var]], useNA = "always")) * 100, 2)
      tablePV <- round (table (data()[[var]]) / sum (table (data()[[var]])) * 100, 2)
      data.frame(Réponse = c(as.character (modality_labels), "NA"), Effectif = as.numeric(tableN), Pourcentages = as.numeric (tableP),
                 'Pourcentages valides' = c(as.numeric (tablePV), ""), check.names = F)

    }
  })

  # Générer le diagramme en barres en fonction de la variable sélectionnée
  output$barPlotCaract <- renderPlot({
    var <- input$caract
    if (var != "") {
      # Copie locale des données
      local_data <- data()

      # Traduire les codes de modalité en labels
      modality_labels <- modality_labels_mapping[[var]]
      if (!is.null(modality_labels)) {
        local_data[[var]] <- factor(local_data[[var]], levels = names(modality_labels), labels = modality_labels)
      }

      # N'afficher le diagramme en barres que si toutes les données ne sont pas manquantes
      if (sum (!is.na (local_data[[var]] != 0)))  {

        # Diagrammme en barres
        par(mar = c(5, 12, 4, 2))
        barplot(rev (100 * prop.table (table(local_data[[var]]))), main = labels_mapping[var], col = "gold1",
                xlab = "%", las = 1, axis.lty=1, horiz = T)
      }
    }
  })


  # PANNEAU 3 Réponses aux items ---------------------------------------------------------------

  # Générer le titre de la variable sélectionnée
  output$itemLabel <- renderText({
    var <- input$item
    label <- labels_mapping[var]
    if (is.null(label)) {
      label <- var  # Utilisez le nom de la variable s'il n'y a pas de correspondance dans labels_mapping
    }
    label
  })

  # Générer le tableau de fréquence en fonction de la variable sélectionnée
  output$freqTable <- renderTable({
    var <- input$item
    if (var != "") {
      # Copie locale des données
      local_data <- data()

      modality_labels <- modality_labels_mapping[[var]]

      # Traduire les codes de modalités en labels
      if (!is.null(modality_labels)) {
        local_data[[var]] <- factor(local_data[[var]], levels = names(modality_labels), labels = modality_labels)
      }

      tableN <- round (table(data()[[var]], useNA = "always"), 0)
      tableP <- round (table (data()[[var]], useNA = "always") / sum (table (data()[[var]], useNA = "always")) * 100, 2)
      tablePV <- round (table (data()[[var]]) / sum (table (data()[[var]])) * 100, 2)
      data.frame(Réponse = c(as.character (modality_labels), "NA"), Effectif = as.numeric(tableN), Pourcentages = as.numeric (tableP),
                 'Pourcentages valides' = c(as.numeric (tablePV), ""), check.names = F)

    }
  })

  # Générer le diagramme en barres en fonction de la variable sélectionnée
  output$barPlot <- renderPlot({
    var <- input$item
    if (var != "") {
      # Copie locale des données
      local_data <- data()

      # Traduire les codes de modalité en labels
      modality_labels <- modality_labels_mapping[[var]]
      if (!is.null(modality_labels)) {
        local_data[[var]] <- factor(local_data[[var]], levels = names(modality_labels), labels = modality_labels)
      }

      # N'afficher le diagramme en barres que si toutes les données ne sont pas manquantes
      if (sum (!is.na (local_data[[var]] != 0)))  {

        # Diagrammme en barres
        par(mar = c(5, 12, 4, 2))
        barplot(rev (100 * prop.table (table(local_data[[var]]))), main = labels_mapping[var], col = c("forestgreen", "green3", "yellow", "orange", "red"),
                xlab = "%", las = 1, axis.lty=1, horiz = T)
      }
    }
  })







  # PANNEAU 4 Les scores avec les items  ---------------------------------------------------------------
  # Générer le titre
  output$scoreLabel <- renderText({
    input$varNew
  })

  # Tableau de statistiques descriptives du score
  output$descScore <- renderTable({
    var <- input$varNew
    if (var != "") {
      # Copie locale des données
      local_data <- data()

      data.frame (moyenne = round (mean (local_data[[var]], na.rm = T), 2),
                  médiane =  round (median (local_data[[var]], na.rm = T), 2),
                  "écart type" =  round (sd (local_data[[var]], na.rm = T), 2),
                  minimum =  round (min (local_data[[var]], na.rm = T), 2),
                  maximum =  round (max (local_data[[var]], na.rm = T), 2)
      )

    }
  })

  # Graphiques (histogramme et boite à moustaches) des scores
  output$plotScore <- renderPlot({
    var <- input$varNew
    if (var != "") {
      # Copie locale des données
      local_data <- data()

      par(mfrow = c(1, 2))
      hist(local_data[[var]], breaks = c(1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5), col = c("red", "red", "red", "yellow", "yellow", "green", "green", "green"),
           main = "", xlab = "", ylab = "effectif")
      boxplot(local_data[[var]], horizontal = T, ylim = c(1,5), col = "gold1", frame.plot = F, outline = F)

    }
  })

  # Tableau de fréquence pour tous les items composant le score
  output$freqTableItemsScore <- renderTable({
    var <- input$varNew
    if (var != "") {
      # Copie locale des données
      local_data <- data()

      source_vars <- switch(var,
                            "santé physique" = c("q11", "q12"),
                            "santé psychique"  = c("q13", "q14"),
                            "symptômes physiques" = c("q16", "q17", "q18", "q19"),
                            "symptômes psychosomatiques" = c("q20", "q21", "q22", "q23"),
                            "stress" = c("q24", "q25", "q26"),
                            "santé générale" = c("q11", "q12", "q13", "q14", "q16", "q17", "q18", "q19", "q20", "q21", "q22", "q23", "q24", "q25", "q26"),
                            "exigences" = c("q27", "q28", "q29", "q30"),
                            "capacités" = c("q31", "q32", "q33", "q34"),
                            "environnement physique" = c("q35", "q36", "q37", "q38", "q39", "q40"),
                            "activité" = c("q41", "q42", "q43", "q44", "q45", "q46", "q47"),
                            "cadrage de l'activité" = c("q48", "q49", "q50", "q51", "q52", "q53", "q54", "q55", "q56", "q57", "q58", "q59", "q60"),
                            "contexte organisationnel" = c("q61", "q62", "q63", "q64", "q65", "q66", "q67", "q68", "q69", "q70", "q71", "q72", "q73"),
                            "environnement de travail général" = c("q35", "q36", "q37", "q38", "q39", "q40", "q41", "q42", "q43", "q44", "q45", "q46", "q47",
                                                                   "q48", "q49", "q50", "q51", "q52", "q53", "q54", "q55", "q56", "q57", "q58", "q59", "q60",
                                                                   "q61", "q62", "q63", "q64", "q65", "q66", "q67", "q68", "q69", "q70", "q71", "q72", "q73"),
                            "appréciation générale du travail" = c("q74", "q75"),
                            NULL)

      label_modalites <- switch(var,
                                "santé physique" = c("très mauvaise", "mauvaise", "ni bonne \n ni mauvaise", "bonne", "très bonne", "non réponse"),
                                "santé psychique" = c("très mauvais(e)", "mauvais(e)", "ni bon(ne) \n ni mauvais(e)", "bon(ne)", "très bon(ne)", "non réponse"),
                                "symptômes physiques" = c("tous les jours \n ou presque", "1 ou 2 fois \n par semaine", "1 ou 2 fois \ par mois", "1 ou 2 fois \ depuis 6 mois", "jamais depuis \ 6 mois", "non réponse"),
                                "symptômes psychosomatiques" = c("tous les jours \n ou presque", "1 ou 2 fois \n par semaine", "1 ou 2 fois \ par mois", "1 ou 2 fois \ depuis 6 mois", "jamais depuis \ 6 mois", "non réponse"),
                                "stress" = c("en permanence", "souvent", "parfois", "rarement", "jamais", "non réponse"),
                                "santé générale" = c("[très négatif]", "[négatif]", "[intermédiaire]", "[positif]", "[très positif]", "non réponse"),
                                "exigences" = c("très dur", "dur", "ni facile, ni dur", "facile", "très facile", "non réponse"),
                                "capacités" = c("largement insuffisantes", "plutôt insuffisantes", "adaptées", "plus importantes \n que nécessaires", "largement plus importantes \n que nécessaire", "non réponse"),
                                "environnement physique" = c("me contrarie fortement", "ne me convient pas", "je fais avec", "me convient", "contribue à mon épanouissement"),
                                "activité" = c("me contrarie fortement", "ne me convient pas", "je fais avec", "me convient", "contribue à mon épanouissement"),
                                "cadrage de l'activité" = c("me contrarie fortement", "ne me convient pas", "je fais avec", "me convient", "contribue à mon épanouissement"),
                                "contexte organisationnel" = c("me contrarie fortement", "ne me convient pas", "je fais avec", "me convient", "contribue à mon épanouissement"),
                                "environnement de travail général" = c("me contrarie fortement", "ne me convient pas", "je fais avec", "me convient", "contribue à mon épanouissement"),
                                "appréciation générale du travail" = c("non, pas du tout", "plutôt non", "ni oui, ni non", "plutôt oui", "oui, tout à fait"),
                                NULL)

      # Création du tableau récapitulatif
      tableau_recap <- creer_tableau_recap(local_data, source_vars, modalites)
      tableau_recap <- data.frame (labels_mapping[source_vars], tableau_recap)
      colnames (tableau_recap) <- c ("item", label_modalites)

      # Affichage du tableau récapitulatif
      tableau_recap

    }
  },
  digits = 0
  )

  # Générer le diagramme en barre de tous les items du score
  output$barPlotItemsScore <- renderPlot({
    var <- input$varNew
    # Copie locale des données
    local_data <- data()

    source_vars <- switch(var,
                          "santé physique" = c("q11", "q12"),
                          "santé psychique"  = c("q13", "q14"),
                          "symptômes physiques" = c("q16", "q17", "q18", "q19"),
                          "symptômes psychosomatiques" = c("q20", "q21", "q22", "q23"),
                          "stress" = c("q24", "q25", "q26"),
                          "santé générale" = c("q11", "q12", "q13", "q14", "q16", "q17", "q18", "q19", "q20", "q21", "q22", "q23", "q24", "q25", "q26"),
                          "exigences" = c("q27", "q28", "q29", "q30"),
                          "capacités" = c("q31", "q32", "q33", "q34"),
                          "environnement physique" = c("q35", "q36", "q37", "q38", "q39", "q40"),
                          "activité" = c("q41", "q42", "q43", "q44", "q45", "q46", "q47"),
                          "cadrage de l'activité" = c("q48", "q49", "q50", "q51", "q52", "q53", "q54", "q55", "q56", "q57", "q58", "q59", "q60"),
                          "contexte organisationnel" = c("q61", "q62", "q63", "q64", "q65", "q66", "q67", "q68", "q69", "q70", "q71", "q72", "q73"),
                          "environnement de travail général" = c("q35", "q36", "q37", "q38", "q39", "q40", "q41", "q42", "q43", "q44", "q45", "q46", "q47",
                                                                 "q48", "q49", "q50", "q51", "q52", "q53", "q54", "q55", "q56", "q57", "q58", "q59", "q60",
                                                                 "q61", "q62", "q63", "q64", "q65", "q66", "q67", "q68", "q69", "q70", "q71", "q72", "q73"),
                          "appréciation générale du travail" = c("q74", "q75"),
                          NULL)

    # Création du tableau récapitulatif
    tableau_recap <- creer_tableau_recap(local_data, source_vars, modalites)
    colnames (tableau_recap) <- c ("aa", "bb", "cc", "dd", "ee", "non réponse")
    rownames (tableau_recap) <- labels_mapping[source_vars]
    tableau_recap <- tableau_recap [,1:5]
    tableau_recap <- round (tableau_recap / rowSums(tableau_recap) * 100, 2)
    tableau_recap <- t(tableau_recap)
    ordre <- order (tableau_recap[1,] + tableau_recap[2,], tableau_recap[1,],-(tableau_recap[4,] + tableau_recap[5,]))
    tableau_recap <- tableau_recap [,ordre]

    # Graphique
    taille <- 1
    if (var == "santé générale" | var == "environnement de travail général") taille <- 0.6

    par(mar = c(5, 20, 0, 0))
    barplot(tableau_recap, col = c("red","orange","yellow","green3","forestgreen"),
            axis.lty=1, horiz = T, xlab="%",
            names.arg = colnames (tableau_recap), las = T, cex.names = taille)


    # }
  },
  )

  # Générer la légende
  output$legende <- renderPlot({
    var <- input$varNew
    if (var != "" & var != "santé générale" & var != "environnement de travail général") {
      # Copie locale des données
      # local_data <- data()
      #
      # source_vars <- switch(var,
      #                       VAR1 = c("q2", "q4", "q5"),
      #                       VAR2 = c("q6", "q7", "q8", "q9", "q10"),
      #                       VAR3 = c("q11", "q12", "q13", "q14"),
      #                       NULL)

      label_modalites <- switch(var,
                                "santé physique" = c("très mauvaise", "mauvaise", "ni bonne \n ni mauvaise", "bonne", "très bonne", "non réponse"),
                                "santé psychique" = c("très mauvais(e)", "mauvais(e)", "ni bon(ne) \n ni mauvais(e)", "bon(ne)", "très bon(ne)", "non réponse"),
                                "symptômes physiques" = c("tous les jours \n ou presque", "1 ou 2 fois \n par semaine", "1 ou 2 fois \ par mois", "1 ou 2 fois \ depuis 6 mois", "jamais depuis \ 6 mois", "non réponse"),
                                "symptômes psychosomatiques" = c("tous les jours \n ou presque", "1 ou 2 fois \n par semaine", "1 ou 2 fois \ par mois", "1 ou 2 fois \ depuis 6 mois", "jamais depuis \ 6 mois", "non réponse"),
                                "stress" = c("en permanence", "souvent", "parfois", "rarement", "jamais", "non réponse"),
                                "santé générale" = c("[très négatif]", "[négatif]", "[intermédiaire]", "[positif]", "[très positif]", "non réponse"),
                                "exigences" = c("très dur", "dur", "ni facile, ni dur", "facile", "très facile", "non réponse"),
                                "capacités" = c("largement insuffisantes", "plutôt insuffisantes", "adaptées", "plus importantes \n que nécessaires", "largement plus importantes \n que nécessaire", "non réponse"),
                                "environnement physique" = c("me contrarie fortement", "ne me convient pas", "je fais avec", "me convient", "contribue à mon épanouissement"),
                                "activité" = c("me contrarie fortement", "ne me convient pas", "je fais avec", "me convient", "contribue à mon épanouissement"),
                                "cadrage de l'activité" = c("me contrarie fortement", "ne me convient pas", "je fais avec", "me convient", "contribue à mon épanouissement"),
                                "contexte organisationnel" = c("me contrarie fortement", "ne me convient pas", "je fais avec", "me convient", "contribue à mon épanouissement"),
                                "environnement de travail général" = c("me contrarie fortement", "ne me convient pas", "je fais avec", "me convient", "contribue à mon épanouissement"),
                                "appréciation générale du travail" = c("non, pas du tout", "plutôt non", "ni oui, ni non", "plutôt oui", "oui, tout à fait"),
                                NULL)
      # Graphique
      # par(bg = "grey")
      plot(0, type = "n", xlim = c(0, 5), ylim = c(0, 1), axes = FALSE, ann = FALSE, bg = "black")
      rect(0, 0.8, 0.5, 0.9, col = "red", border = "black")
      rect(0, 0.6, 0.5, 0.7, col = "orange", border = "black")
      rect(0, 0.4, 0.5, 0.5, col = "yellow", border = "black")
      rect(0, 0.2, 0.5, 0.3, col = "green3", border = "black")
      rect(0, 0.0, 0.5, 0.1, col = "forestgreen", border = "black")
      text (0.5, 0.85, label_modalites [1], font = 2, pos = 4, col = "black")
      text (0.5, 0.65, label_modalites [2], font = 2, pos = 4, col = "black")
      text (0.5, 0.45, label_modalites [3], font = 2, pos = 4, col = "black")
      text (0.5, 0.25, label_modalites [4], font = 2, pos = 4, col = "black")
      text (0.5, 0.05, label_modalites [5], font = 2, pos = 4, col = "black")


    }
  },
  )

  # PANNEAU 5 Corrélations entre les scores ---------------------------------------------------------------

  observe({
    # Empêcher la sélection de la même variable dans les deux menus
    choix_variable2 <- setdiff(c("santé physique", "santé psychique", "symptômes physiques",
                                 "symptômes psychosomatiques", "stress", "santé générale",
                                 "exigences", "capacités", "environnement physique", "activité",
                                 "cadrage de l'activité", "contexte organisationnel", "environnement de travail général",
                                 "appréciation générale du travail"),
                               input$score1)
    updateSelectInput(session, "score2", choices = choix_variable2)
  })

  # Générer le titre
  output$titreCor <- renderText({
    var1 <- input$score1
    var2 <- input$score2
    paste ("Corrélation entre ", "'", var1, "'", " et ", "'", var2, "'", sep = "")
  })

  # Nuage de points
  output$plotCor <- renderPlot({
    # Copie locale des données
    local_data <- data()
    v1 <- input$score1
    v2 <- input$score2
    couleurs <- rep (NA, nrow (local_data))
    couleurs [which (local_data[,v1] >= 1 & local_data[,v1] < 2 & local_data[,v2] >= 1 & local_data[,v2] < 2)] <- "red"
    couleurs [which (local_data[,v1] >= 2 & local_data[,v1] < 3 & local_data[,v2] >= 1 & local_data[,v2] < 2)] <- "red"
    couleurs [which (local_data[,v1] >= 3 & local_data[,v1] < 4 & local_data[,v2] >= 1 & local_data[,v2] < 2)] <- "orange"
    couleurs [which (local_data[,v1] >= 4 & local_data[,v1] < 5 & local_data[,v2] >= 1 & local_data[,v2] < 2)] <- "orange"
    couleurs [which (local_data[,v1] >= 1 & local_data[,v1] < 2 & local_data[,v2] >= 2 & local_data[,v2] < 3)] <- "red"
    couleurs [which (local_data[,v1] >= 2 & local_data[,v1] < 3 & local_data[,v2] >= 2 & local_data[,v2] < 3)] <- "orange"
    couleurs [which (local_data[,v1] >= 3 & local_data[,v1] < 4 & local_data[,v2] >= 2 & local_data[,v2] < 3)] <- "orange"
    couleurs [which (local_data[,v1] >= 4 & local_data[,v1] < 5 & local_data[,v2] >= 2 & local_data[,v2] < 3)] <- "orange"
    couleurs [which (local_data[,v1] >= 1 & local_data[,v1] < 2 & local_data[,v2] >= 3 & local_data[,v2] < 4)] <- "orange"
    couleurs [which (local_data[,v1] >= 2 & local_data[,v1] < 3 & local_data[,v2] >= 3 & local_data[,v2] < 4)] <- "orange"
    couleurs [which (local_data[,v1] >= 3 & local_data[,v1] < 4 & local_data[,v2] >= 3 & local_data[,v2] < 4)] <- "green"
    couleurs [which (local_data[,v1] >= 4 & local_data[,v1] < 5.1 & local_data[,v2] >= 3 & local_data[,v2] < 4)] <- "green"
    couleurs [which (local_data[,v1] >= 1 & local_data[,v1] < 2 & local_data[,v2] >= 4 & local_data[,v2] < 5.1)] <- "orange"
    couleurs [which (local_data[,v1] >= 2 & local_data[,v1] < 3 & local_data[,v2] >= 4 & local_data[,v2] < 5.1)] <- "orange"
    couleurs [which (local_data[,v1] >= 3 & local_data[,v1] < 4 & local_data[,v2] >= 4 & local_data[,v2] < 5.1)] <- "green"
    couleurs [which (local_data[,v1] >= 4 & local_data[,v1] < 5.1 & local_data[,v2] >= 4 & local_data[,v2] < 5.1)] <- "green"

    plot (jitter (local_data[,v1], 3), jitter (local_data[,v2], 3), xlim = c(1,5), ylim = c(1,5), col = couleurs, pch = 16,
          xlab = v1, ylab = v2)
    reg <- lm (local_data[,v2] ~ local_data[,v1])
    abline (reg, col = "grey", lwd = 5)

  })


  # Afficher la corrélation
  output$valeurCor <- renderText({
    # Copie locale des données
    local_data <- data()
    var1 <- input$score1
    var2 <- input$score2
    paste ("La corrélation entre", var1, "et", var2, "est égale à", round (cor (local_data[,var1], local_data[,var2], use = "complete.obs"), 2))
  })


  # PANNEAU 6 Scores en fonction des caractéristiques des répondants ---------------------------------------------------------------

  # Générer le titre
  output$titrediffScores <- renderText({
    vd <- input$score
    vi <- input$vi
    paste ("Score de ", "'", vd, "'", " en fonction de ", "'", labels_mapping [vi], "'")
  })

  # Boxplot
  output$plotdiffScores <- renderPlot({
    # Copie locale des données
    local_data <- data()
    vd <- input$score
    vi <- input$vi

    if (input$vi != "secteur" & input$vi != "collectif") {
      vif <- factor (local_data[[vi]], levels = 1:length (unlist (modality_labels_mapping [vi])), labels = unlist (modality_labels_mapping [vi]))
      means <- aggregate (local_data[[vd]] ~ vif, FUN = mean)
      means$VI_numeric <- as.numeric(factor(means$vif))
      par(mar = c(12, 4, 4, 2))
      boxplot (local_data[[vd]] ~ vif, ylim = c(1,5), xlab = "", ylab = "", axes = F)
      # title(main = paste (vd, "en fonction de", "\n", labels_mapping[vi]), line = 2, cex.main = 1)
      axis(1, at = seq_along (unique (unlist (modality_labels_mapping [vi]))), labels = unlist (modality_labels_mapping [vi]), las = 2, cex.axis = 1.1)
      axis(2, at = 1:5)
      points(means$VI_numeric, means[,2], col = "red", pch = 16, cex = 1.5)
    }

    if (input$vi == "secteur" | input$vi == "collectif") {
      vif <- factor (local_data[[vi]])
      means <- aggregate (local_data[[vd]] ~ vif, FUN = mean)
      means$VI_numeric <- as.numeric(factor(means$vif))
      par(mar = c(12, 4, 4, 2))
      boxplot (local_data[[vd]] ~ vif, ylim = c(1,5), xlab = "", ylab = "", axes = F)
      # title(main = paste (vd, "en fonction de", "\n", labels_mapping[vi]), line = 2, cex.main = 1)
      axis(1, at = seq_along (levels (vif)), labels = levels (vif), las = 2, cex.axis = 1.1)
      axis(2, at = 1:5)
      points(means$VI_numeric, means[,2], col = "red", pch = 16, cex = 1.5)
    }

  })

  # Tableau des statistiques descriptives
  output$descdiffScores <- renderTable({
    vd <- input$score
    vi <- input$vi

    # Copie locale des données
    local_data <- data()
    if (input$vi != "secteur" & input$vi != "collectif") {
      vif <- factor (local_data[[vi]], levels = 1:length (unlist (modality_labels_mapping [vi])), labels = unlist (modality_labels_mapping [vi]))
    }

    if (input$vi == "secteur" | input$vi == "collectif") {
      vif <- factor (local_data[[vi]])
    }
    # aggregate (local_data[[vd]] ~ vif, FUN = function (x) c(moyenne = mean (x), médiane = median(x)))
    moy <- aggregate (local_data[[vd]] ~ vif, FUN = mean)
    med <- aggregate (local_data[[vd]] ~ vif, FUN = median)
    mini <- aggregate (local_data[[vd]] ~ vif, FUN = min)
    maxi <- aggregate (local_data[[vd]] ~ vif, FUN = max)
    et <- aggregate (local_data[[vd]] ~ vif, FUN = sd)
    N <- aggregate (local_data[[vd]] ~ vif, FUN = length)
    res <- data.frame (moy [, 1], moyenne = moy [,2], médiane = med [,2], minimum = mini [,2], maximum = maxi [,2], "écart type" = et [,2], effectif = N [,2])
    names (res) [1] <- labels_mapping [vi]
    res
  })

  # Valeur du R²
  output$etadiffScores <- renderText({
    vd <- input$score
    vi <- input$vi

    # Copie locale des données
    local_data <- data()
    res <- summary (lm (local_data[[vd]] ~ factor (local_data[[vi]])))
    paste ("R² = ", round (res$r.squared, 3), "soit", round (res$r.squared, 3) * 100, "% de variance expliquée au sens statistique du terme")

  })

  # PANNEAU 7 Items en fonction des caractéristiques des répondants ---------------------------------------------------------------

  # Générer le titre
  output$titrediffItems <- renderText({
    vd <- input$item2
    vi <- input$vi2
    paste ("Item ", "'", labels_mapping_items_n [vd], "'", " en fonction de ", "'", labels_mapping [vi], "'")
  })

  # Boxplot
  output$plotdiffItems <- renderPlot({
    # Copie locale des données
    local_data <- data()
    vd <- input$item2
    vi <- input$vi2

    if (input$vi != "secteur" & input$vi != "collectif") {
      vif <- factor (local_data[[vi]], levels = 1:length (unlist (modality_labels_mapping [vi])), labels = unlist (modality_labels_mapping [vi]))
      means <- aggregate (local_data[[vd]] ~ vif, FUN = mean)
      means$VI_numeric <- as.numeric(factor(means$vif))
      par(mar = c(12, 4, 4, 2))
      boxplot (local_data[[vd]] ~ vif, ylim = c(1,5), xlab = "", ylab = "", axes = F)
      # title(main = paste (vd, "en fonction de", "\n", labels_mapping[vi]), line = 2, cex.main = 1)
      axis(1, at = seq_along (unique (unlist (modality_labels_mapping [vi]))), labels = unlist (modality_labels_mapping [vi]), las = 2, cex.axis = 1.1)
      axis(2, at = 1:5)
      points(means$VI_numeric, means[,2], col = "red", pch = 16, cex = 1.5)
    }

    if (input$vi == "secteur" | input$vi == "collectif") {
      vif <- factor (local_data[[vi]])
      means <- aggregate (local_data[[vd]] ~ vif, FUN = mean)
      means$VI_numeric <- as.numeric(factor(means$vif))
      par(mar = c(12, 4, 4, 2))
      boxplot (local_data[[vd]] ~ vif, ylim = c(1,5), xlab = "", ylab = "", axes = F)
      # title(main = paste (vd, "en fonction de", "\n", labels_mapping[vi]), line = 2, cex.main = 1)
      axis(1, at = seq_along (levels (vif)), labels = levels (vif), las = 2, cex.axis = 1.1)
      axis(2, at = 1:5)
      points(means$VI_numeric, means[,2], col = "red", pch = 16, cex = 1.5)
    }

  })

  # Tableau des statistiques descriptives
  output$descdiffItems <- renderTable({
    vd <- input$item2
    vi <- input$vi2

    # Copie locale des données
    local_data <- data()
    if (input$vi != "secteur" & input$vi != "collectif") {
      vif <- factor (local_data[[vi]], levels = 1:length (unlist (modality_labels_mapping [vi])), labels = unlist (modality_labels_mapping [vi]))
    }

    if (input$vi == "secteur" | input$vi == "collectif") {
      vif <- factor (local_data[[vi]])
    }
    # aggregate (local_data[[vd]] ~ vif, FUN = function (x) c(moyenne = mean (x), médiane = median(x)))
    moy <- aggregate (local_data[[vd]] ~ vif, FUN = mean)
    med <- aggregate (local_data[[vd]] ~ vif, FUN = median)
    mini <- aggregate (local_data[[vd]] ~ vif, FUN = min)
    maxi <- aggregate (local_data[[vd]] ~ vif, FUN = max)
    et <- aggregate (local_data[[vd]] ~ vif, FUN = sd)
    N <- aggregate (local_data[[vd]] ~ vif, FUN = length)
    res <- data.frame (moy [, 1], moyenne = moy [,2], médiane = med [,2], minimum = mini [,2], maximum = maxi [,2], "écart type" = et [,2], effectif = N [,2])
    names (res) [1] <- labels_mapping [vi]
    res
  })

  # Valeur du R²
  output$etadiffItems <- renderText({
    vd <- input$item2
    vi <- input$vi2

    # Copie locale des données
    local_data <- data()
    res <- summary (lm (local_data[[vd]] ~ factor (local_data[[vi]])))
    paste ("R² = ", round (res$r.squared, 3), "soit", round (res$r.squared, 3) * 100, "% de variance expliquée au sens statistique du terme")

  })



}


# Run the application
shinyApp(ui = ui, server = server)

