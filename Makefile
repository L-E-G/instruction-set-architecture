IN ?= DESIGN.md
OUT ?= DESIGN.pdf

${OUT}: ${IN}
	pandoc \
		--wrap=preserve \
		--toc \
		--standalone \
		-V links-as-notes=true \
		-o ${OUT} \
		${IN}
