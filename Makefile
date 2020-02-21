IN ?= DESIGN.md
OUT ?= DESIGN.pdf

${OUT}: ${IN}
	pandoc --wrap=preserve --toc -V links-as-notes=true  -o ${OUT} ${IN}
