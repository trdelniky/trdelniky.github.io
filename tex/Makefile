cs_base=trdelniky.cs
cs_tex=${cs_base}.tex
cs_pdf=${cs_base}.pdf
html_out_dir=../html
html_build_dir=build
cs_html=${html_build_dir}/${cs_base}.html
cs_tex_sources=${cs_tex} $(wildcard cs/*.tex)
html_inputs=web.cfg $(wildcard css/*.css) $(wildcard html/*.html) $(wildcard js/*.js)

.PHONY: all 

all: vimwiki_import ${cs_pdf} ${cs_html} 

vimwiki_import:
	lua vimwiki_import.lua 

${cs_pdf}: ${cs_tex_sources}
	latexmk -pdf -pdflatex="lualatex -interaction=nonstopmode" $<

${cs_html}: ${cs_tex_sources} ${html_inputs}
	mkdir -p ${html_build_dir}
	make4ht -a debug -lc web.cfg -B ${html_build_dir} -d ${html_out_dir} ${cs_tex} "mathjax"

