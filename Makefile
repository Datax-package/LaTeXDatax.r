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

clean :
	${RM} ${NAME}_*.tar.gz man/* test.tex NAMESPACE
	${RM} -R ${NAME}.Rcheck
