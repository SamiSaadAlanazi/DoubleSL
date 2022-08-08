#'Student's Math and Portuguese Scores Dataset
#'
#'Contains statistics for 382 students.
#'
#'@format A dataset for low-dimensional example with 382 rows and 36 variable to perform the DML and DSL methods:
#' \describe{
#'	\item{school}{student's school (binary: "0" - Gabriel Pereira or "1" - Mousinho da Silveira)}
#'	\item{sex}{student's sex (binary: "0" - female or "1" - male)}
#'	\item{age}{student's age (numeric: from 15 to 22)}
#'	\item{address}{student's home address type (binary: "0" - urban or "1" - rural)}
#'	\item{famsize}{family size (binary: "0" - less or equal to 3 or "1" - greater than 3)}
#'	\item{Pstatus}{parent's cohabitation status (binary: "0" - living together or "A" - apart)}
#'	\item{Medu}{mother's education (numeric: 0 - none,  1 - primary education (4th grade), 2 – 5th to 9th grade, 3 – secondary education or 4 – higher education)}
#'	\item{Fedu}{father's education (numeric: 0 - none,  1 - primary education (4th grade), 2 – 5th to 9th grade, 3 – secondary education or 4 – higher education)}
#'	\item{Mjob}{mother's job (numeric: "1" teacher, "2" health care related, "3" civil services (e.g. administrative or police), "4" at home or "5" other)}
#'	\item{Fjob}{father's job (numeric: "1" teacher, "2" health care related, "3" civil services (e.g. administrative or police), "4" at home or "5" other)}
#'	\item{reason}{reason to choose this school (numeric: "1" close to home, "2" school reputation, "3" course  preference or "4" other)}
#'	\item{nursery}{attended nursery school (binary: "1" yes or "0"no)}
#'	\item{internet}{Internet access at home (binary: "1" yes or "0"no)}
#'	\item{guardian}{student's guardian (numeric: "1" mother, "2" father or "3" other)}
#'	\item{traveltime}{home to school travel time (numeric: 1 - <15 min., 2 - 15 to 30 min., 3 - 30 min. to 1 hour, or 4 - >1 hour)}
#'	\item{studytime}{weekly study time (numeric: 1 - <2 hours, 2 - 2 to 5 hours, 3 - 5 to 10 hours, or 4 - >10 hours)}
#'	\item{failures}{number of past class failures (numeric: n if 1<=n<3, else 4)}
#'	\item{schoolsup}{extra educational support  (binary: "1" yes or "0"no)}
#'	\item{famsup}{family educational support  (binary: "1" yes or "0"no)}
#'	\item{paid}{extra paid classes within the course subject (Math or Portuguese) (binary: yes or no)}
#'	\item{activities}{extra-curricular activities  (binary: "1" yes or "0"no)}
#'	\item{higher}{wants to take higher education  (binary: "1" yes or "0"no)}
#'	\item{romantic}{with a romantic relationship  (binary: "1" yes or "0"no)}
#'	\item{famrel}{quality of family relationships (numeric: from 1 - very bad to 5 - excellent)}
#'	\item{freetime}{ free time after school (numeric: from 1 - very low to 5 - very high)}
#'	\item{goout}{going out with friends (numeric: from 1 - very low to 5 - very high)}
#'	\item{Dalc}{workday alcohol consumption (numeric: from 1 - very low to 5 - very high)}
#'	\item{Walc}{weekend alcohol consumption (numeric: from 1 - very low to 5 - very high)}
#'	\item{health}{current health status (numeric: from 1 - very bad to 5 - very good)}
#'	\item{absences}{number of school absences (numeric: from 0 to 93)}
#'	\item{G1.x}{first period grade in math (numeric: from 0 to 20)}
#'	\item{G2.x}{second period grade in math (numeric: from 0 to 20)}
#'	\item{G3.x}{final grade in math (numeric: from 0 to 20)}
#'	\item{G1.y}{first period grade in Portuguese (numeric: from 0 to 20)}
#'	\item{G2.y}{second period grade in Portuguese (numeric: from 0 to 20)}
#'	\item{G3.y}{final grade in Portuguese (numeric: from 0 to 20)}
#'	}
#'
#'@source {P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7.}
#'
#'@examples
#'data(Example1)
"Example1"
