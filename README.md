# CRAN R Sports Packages

Martí Casals<sup>1</sup>, José Fernández<sup>2</sup>, Víctor Martínez<sup>3</sup>, Michael López<sup>4</sup>, Klaus Langohr<sup>3</sup>, Jordi Cortés<sup>3</sup>

<sup>1</sup> <span style="font-size:4em;">National Institute of Physical Education of Catalonia (INEFC), University of Barcelona (UB), Barcelona, Spain</span>
<sup>2</sup> Faculty of Health Sciences, School of Behavioral and Health Sciences, Australian Catholic University, Fitzroy, Victoria, Australia
<sup>3</sup> Statistics and Operations Research Department, Universitat Politècnica de Catalunya, Barcelona, Spain
<sup>4</sup> National Football League, New York, NY, USA

</br>

You can find an interactive version of the data in this [*shiny* app](https://shiny-eio.upc.edu/pubs/sport-R-packages/).

You can find the related paper [here](https://journals.sagepub.com/doi/abs/10.1177/17479541221136238).

## Data

List and description of R Sports Packages in CRAN repository. See *Data* folder. Information available are:

|     Variable              | Description                                                                                                                       |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| Package                   | Name of the package
| Description               | Brief explanation of the package
| Tutorial                  | (Yes/No). If the   package contains a vignette/tutorial                                                                           |
| Creation   date           | Date of the   first version                                                                                                       |
| Initial   version         | Number of the   initial version                                                                                                   |
| Last   version date       | Date of the last   version of the package                                                                                         |
| Current   version         | Number of the   current version                                                                                                   |
| R   journal               | (Yes/No) the   package has a paper related in R Journal                                                                           |
| Citation                  | Package citation                                                                                                                  |
| Creation   Year           | Year the package   was launched                                                                                                   |
| Current   Year            | Year of the last   version                                                                                                        |
| Creator's   Country       | Country of the   creator or the first contributor of the package                                                                  |
| Creator's   Gender        | Male/Female                                                                                                                       |
| Sport                     | The sport which   the package is focused on                                                                                       |
| Gender                    | Gender which is   the package is focused on (Male, Female o Both)                                                                 |
| Category                  | Professional   category (Professional, Amateur o Both)                                                                            |
| JQAS                      | (No/Yes) If the   package is mentioned in the Journal of Quantitative   Analysis in Sport                                         |
| Category   classification | Five categories:   1) Sports Performance Analysis;   2) Sports technology; 3) Movement integration; 4) Athlete health; 5) eSports |
| Data                      | (Yes/No) If the   package contains any dataset                                                                                    |
| Data   analysis           | (Yes/No) If the   purpose of the package is the data analysis                                                                     |
| Methodology   type        | The main type of   statistical techniques used                                                                                    |

## Scripts 

The script *automatic_search* performs an automatic search of the sports related packages using the
`findFn` function from package [sos](https://cran.r-project.org/web/packages/sos/index.html). However, 
the result of this search was not enough specific and the final list of packages related to sports
was manually obtained by reviewing one by one.
