//Manually Imput Table

scatter W A, xtitle("Hours Worked") title("Person A")
graph export "/home/ian/economics/maclem/econ8050/pset1/A.pdf", as(pdf) name("Graph")

scatter W B, xtitle("Hours Worked") title("Person B")
graph export "/home/ian/economics/maclem/econ8050/pset1/B.pdf", as(pdf) name("Graph")

scatter W C, xtitle("Hours Worked") title("Person C")
graph export "/home/ian/economics/maclem/econ8050/pset1/C.pdf", as(pdf) name("Graph")

scatter W D, xtitle("Hours Worked") title("Person D")
graph export "/home/ian/economics/maclem/econ8050/pset1/D.pdf", as(pdf) name("Graph")

scatter W E, xtitle("Hours Worked") title("Person E")
graph export "/home/ian/economics/maclem/econ8050/pset1/E.pdf", as(pdf) name("Graph")

scatter W Agg, xtitle("Hours Worked") title("Aggregate")
graph export "/home/ian/economics/maclem/econ8050/pset1/Agg.pdf", as(pdf) name("Graph")

drop if W > 45
scatter W Agg, xtitle("Hours Worked") title("Restricted Aggregate")
graph export "/home/ian/economics/maclem/econ8050/pset1/restAgg.pdf", as(pdf) name("Graph")
