#!/bin/sh

# Debian packages needed:
# apt install pandoc wkhtmltopdf 
# 
#
# PDF output via PDFLaTeX requires the package texlive-latex-recommended.
#  * XeLaTeX additionally requires texlive-xetex
#  * LuaTeX additionally requires texlive-luatex
#  * content with YAML metadata additionally requires
#    texlive-latex-extra.
# 
#


_md2pdf()
{
    local mdfile="$1"
    #local tmphtml=$(mktemp -t pdftohtml.tmp.XXXXXXXXXX.html)
    local tmphtml="${mdfile%.md}.html"
    # could also use --include-in-header=pandoc.css to embed it in html file
    pandoc --from=markdown_github --to=html \
        --standalone --css=pandoc.css --output=$tmphtml $mdfile 

    local pdfout="${mdfile%.md}.pdf"
    wkhtmltopdf $tmphtml $pdfout
    rm -f $tmphtml
}

for mdfile in "$@"; do
    _md2pdf "$mdfile" 
    #echo "$mdfile"
done
