## Edit PDFs (remove fonts, RGB to CMYK, etc)

pdfcmyk() {
    # Convert a PDF from RGB to CMYK
    # Call it as: pdfcmyk INPUT.pdf OUTPUT.pdf
    # Based on http://zeroset.mnim.org/2014/07/14/save-a-pdf-to-cmyk-with-inkscape/
    gs -dSAFER -dBATCH -dNOPAUSE -dNOCACHE -sDEVICE=pdfwrite \
       -sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK \
       -sOutputFile=$2 $1
}

pdfcompress() {
read -r -d '' PDFCOMPRESS_HELP <<-'EOF'
Usage: pdfcompress [LEVEL] INPUT OUTPUT

Use Ghostscript to lower the DPI of images in a PDF.

LEVEL should be one of: screen [default], default, ebook, printer, prepress

EOF
    if [[ $# -le 1 ]]; then
        echo "$PDFCOMPRESS_HELP";
        return 1;
    fi
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen \
       -dNOPAUSE -dQUIET -dBATCH -dDetectDuplicateImages \
       -dCompressFonts=true -sOutputFile=$2 $1
}

