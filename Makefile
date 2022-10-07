.PHONY : clean check install

NAME=$(shell sed -n 's/Package: \(.*\)/\1/p' DESCRIPTION)
VERSION=$(shell sed -n 's/Version: \(.*\)/\1/p' DESCRIPTION)

ARCHIVE=${NAME}_${VERSION}.tar.gz

${ARCHIVE} : man/datax.Rd DESCRIPTION
	R CMD build .

man/datax.Rd : R/LaTeXDatax.r
	Rscript -e "library(roxygen2);roxygenize('.')"

check : ${ARCHIVE}
	R CMD check $<

install : ${ARCHIVE}
	R CMD install $<

test : tests/show.pdf

tests/show.pdf : tests/show.tex tests/data.tex
	latexmk --xelatex --output-directory=tests $<

tests/data.tex : tests/test.r R/LaTeXDatax.r
	Rscript $<

clean :
	${RM} ${NAME}_*.tar.gz man/* NAMESPACE
	${RM} -R ${NAME}.Rcheck
	${RM} -R tests/*.pdf tests/data.tex tests/*.log tests/*.aux tests/*.fls tests/*.fdb_latexmk tests/*.xdv
