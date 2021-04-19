;;-*-coding: utf-8;-*-
(define-abbrev-table 'global-abbrev-table
  '(
    ("mon" "mon" nil :count 0)
   ))

(define-abbrev-table 'org-mode-abbrev-table
  '(
    ("adn" "and" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("ahve" "have" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("ang" "Å" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("apr" "Apr." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("april" "April" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("arent" "are not" nil :count 1 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("aug" "Aug." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("august" "August" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("cant" "can not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("couldnt" "could not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("dec" "Dec." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("december" "December" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("degC" "°C" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("degF" "°F" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("didnt" "did not" nil :count 1 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("doesnt" "does not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("dont" "do not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("feb" "Feb." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("february" "February" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("fi" "if" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("fo" "of" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("fri" "Fri." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("friday" "Friday" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("hadnt" "had not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("hasnt" "has not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("htat" "that" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("hte" "the" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("htem" "them" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("hwat" "what" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("isnt" "is not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("iwth" "with" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("jan" "Jan." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("january" "January" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("jul" "Jul." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("july" "July" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("jun" "Jun." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("june" "June" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("mar" "Mar." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("march" "March" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("mon" "Mon." nil :count 2 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("monday" "Monday" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("nov" "Nov." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("november" "November" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("nto" "not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("oct" "Oct." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("october" "October" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("sat" "Sat." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("saturday" "Saturday" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("sept" "Sept." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("september" "September" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("shouldnt" "should not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("sun" "Sun." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("sunday" "Sunday" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("teh" "the" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("thats" "that is" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("thur" "Thur." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("thursday" "Thursday" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("tm" "™" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("tue" "Tue." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("tuesday" "Tuesday" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("waht" "what" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("wasnt" "was not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("wed" "Wed." nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("wednesday" "Wednesday" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("wehn" "when" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("whos" "who is" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("wont" "will not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("wouldnt" "would not" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
    ("wouldve" "would have" nil :count 0 :enable-function (closure (t) nil (and (not (org-in-src-block-p)) (save-excursion (beginning-of-line) (not (looking-at "#\\+\\(name\\|tblname\\|latex_header\\)"))))))
   ))
