IN ?= DESIGN.md
OUT ?= DESIGN.pdf

${OUT}: ${IN}
	pandoc --wrap=preserve --toc -o ${OUT} ${IN}
