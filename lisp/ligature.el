(after! ess-r-mode
  (appendq! +ligatures-extra-symbols
            '(
              :infix "▷"
              :assign "⟵"
              ;; :multiply "×"
              ;; greek
              :alpha   #X3B1
              :beta    #X3B2
              :chi     #X3C7
              :delta   #X3B4
              :epsilon #X3F5
              :eta     #X3B7
              :gamma   #X3B3
              :iota    #X3B9
              :kappa   #X3BA
              :lambda  #X3BB
              :mu      #X3BC
              :nu      #X3BD
              :omega   #X3C9
              :phi     #X3D5
              :pi      #X3C0
              :psi     #X3C8
              :rho     #X3C1
              :sigma   #X3C3
              :tau     #X3C4
              :theta   #X3B8
              :upsilon #X3C5
              :xi      #X3BE
              :zeta    #X3B6
              :Delta   #X394
              :Gamma   #X393
              :Lambda  #X39B
              :Omega   #X3A9
              :Phi     #X3A6
              :Pi      #X3A0
              :Psi     #X3A8
              :Sigma   #X3A3
              :Theta   #X398
              :Upsilon #X3D2
              :Xi      #X39E
              )
            )
  (set-ligatures! 'ess-r-mode
    ;;Functional
    :def         "function"
    ;;Types
    :null        "NULL"
    :true        "TRUE"
    :false       "FALSE"
    :int         "int"
    :floar       "float"
    :bool        "bool"
    ;;Flow
    ;; :not      "!"
    ;; :and      "&&"
    :for         "for"
    :in          "%in%"
    :infix       "%>%"
    :return      "return"
    ;;Other
    :assign      "<-"
    ;; :multiply "%*%"
    ;; greek
    :alpha       "alpha"
    :beta        "beta"
    :chi         "chi"
    :delta       "delta"
    :epsilon     "epsilon"
    :eta         "eta"
    :gamma       "gamma"
    :iota        "iota"
    :kappa       "kappa"
    :lambda      "lambda"
    :mu          "mu"
    :nu          "nu"
    :omega       "omega"
    :phi         "phi"
    :pi          "pi"
    :psi         "psi"
    :rho         "rho"
    :sigma       "sigma"
    :tau         "tau"
    :theta       "theta"
    :upsilon     "upsilon"
    :xi          "xi"
    :zeta        "zeta"
    :Delta       "Delta"
    :Gamma       "Gamma"
    :Lambda      "Lambda"
    :Omega       "Omega"
    :Phi         "Phi"
    :Pi          "Pi"
    :Psi         "Psi"
    :Sigma       "Sigma"
    :Theta       "Theta"
    :Upsilon     "Upsilon"
    :Xi          "Xi"
    )
  )

(appendq! +ligatures-extra-symbols
          `(
            :list_property "∷"
            :em_dash       "—"
            :ellipses      "…"
            :arrow_right   "→"
            :arrow_left    "←"
            :title         "𝙏"
            :subtitle      "𝙩"
            :author        "𝘼"
            :date          "𝘿"
            :property      ""
            ;;:header ""
            ;;:options       "⌥"
            :options       ""
            :latex_class   "🄲"
            ;; :latex_header  "⇥"
            :latex_header  "𝔏"
            ;; :beamer_header "↠"
            :beamer_header "𝔅"
            :setupfile     "𝔖"
            :html_head     ""
            :attr_latex    "🄛"
            :attr_html     "🄗"
            :begin_quote   "❝"
            :end_quote     "❞"
            :caption       "🄒"
            :header        "›"
            :results       "🠶"
            :begin_export  "⏩"
            :end_export    "⏪"
            ;; :properties    "🛈"
            :properties      ""
            :end           ""
            ))
(set-ligatures! 'org-mode
  :merge t
  :list_property "::"
  :em_dash       "---"
  :ellipsis      "..."
  :arrow_right   "->"
  :arrow_left    "<-"
  :title         "#+title:"
  :subtitle      "#+subtitle:"
  :author        "#+author:"
  :date          "#+date:"
  :property      "#+property:"
  :options       "#+options:"
  :latex_class   "#+latex_class:"
  :latex_header  "#+latex_header:"
  :beamer_header "#+beamer_header:"
  :html_head     "#+html_head:"
  :attr_latex    "#+attr_latex:"
  :attr_html     "#+attr_latex:"
  :begin_quote   "#+begin_quote"
  :end_quote     "#+end_quote"
  :caption       "#+caption:"
  :setupfile     "#+setupfile:"
  :header        "#+header:"
  :begin_export  "#+begin_export"
  :end_export    "#+end_export"
  :results       "#+RESULTS:"
  :property      ":PROPERTIES:"
  :end           ":END:"
  )
(plist-put +ligatures-extra-symbols :name "⁍")
