cs_base=trdelniky.cs
cs_tex=${cs_base}.tex
cs_pdf=${cs_base}.pdf
cs_html=${cs_base}.html
cs_tex_sources=${cs_tex} $(wildcard cs/*.tex)
html_out_dir=../html
html_build_dir=build

cs_pdf: ${cs_tex_sources}
	latexmk -pdf -pdflatex="lualatex -interaction=nonstopmode" $<
	make4ht -a debug -lc web.cfg -b ${html_build_dir} -d ${html_out_dir} $<
	make4ht -m clean $<
