#!/usr/bin/env bash

# TODO Consider editing screenshots before processing with tesseract.
# https://github.com/tesseract-ocr/tessdoc/blob/main/ImproveQuality.md#binarisation

output=/tmp/temp_screenshot

spectacle -Cbrn --output $output && tesseract $output - --psm 6 --oem 2 | wl-copy
