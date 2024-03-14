# Get the BibTex from a DOI
doi2bib() {
    if [[ $# -le 0 ]]; then
        echo "Usage: doi2bib DOI"
        echo ""
        echo "The BibTex entry will be printed to STDOUT."
    else
        doi=$1
        curl -LH "Accept: application/x-bibtex" https://doi.org/$doi
    fi
}

