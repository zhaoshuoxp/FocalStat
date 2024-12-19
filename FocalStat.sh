#!/bin/bash

if ! command -v exiftool &> /dev/null; then
    echo "Error: exiftool is not installed. Please install it first."
    exit 1
fi

if ! command -v gnuplot &> /dev/null; then
    echo "Error: gnuplot is not installed. Please install it first."
    exit 1
fi


TARGET_DIR="$1"
if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi


OUTPUT_FILE="focal_pixel_data.txt"
HISTOGRAM_DATA="histogram_data.txt"
PLOT_SCRIPT="plot_histogram.gp"

> "$OUTPUT_FILE"


find "$TARGET_DIR" -type f -iname "*.jpg" | while read -r FILE; do
    
    FOCAL_LENGTH=$(exiftool -s -s -s -FocalLength "$FILE" | sed 's/ mm//')
    IMAGE_WIDTH=$(exiftool -s -s -s -ImageWidth "$FILE")
    IMAGE_HEIGHT=$(exiftool -s -s -s -ImageHeight "$FILE")

    
    if [ -z "$FOCAL_LENGTH" ] || [ -z "$IMAGE_WIDTH" ] || [ -z "$IMAGE_HEIGHT" ]; then
        continue
    fi

    
    TOTAL_PIXELS=$((IMAGE_WIDTH * IMAGE_HEIGHT))
    COEFFICIENT=$(echo "scale=2; $TOTAL_PIXELS / 45441024" | bc)
    ADJUSTED_FOCAL=$(echo "scale=0; ($FOCAL_LENGTH/$COEFFICIENT) / 1" | bc)

    
    echo "$ADJUSTED_FOCAL" >> "$OUTPUT_FILE"

done


sort -n "$OUTPUT_FILE" | uniq -c | awk '{print $2, $1}' > "$HISTOGRAM_DATA"


cat > "$PLOT_SCRIPT" << EOF
set terminal png size 800,600 enhanced font 'Arial,10'  
set output 'histogram.png'
set title 'Histogram of Adjusted Focal Lengths'
set xlabel 'Adjusted Focal Length'
set ylabel 'Frequency'
set boxwidth 0.9 relative
set style fill solid 1.0

# Custom x-axis ticks
set xtics 10, 6, 200    # Ticks at 10, 16, 24, 35, 50, 85, 105, 120, 200
set xtics ("10" 10, "16" 16, "24" 24, "35" 35, "50" 50, "85" 85, "105" 105, "120" 120, "200" 200)

plot "$HISTOGRAM_DATA" using 1:2 with boxes title 'Frequency'
EOF

gnuplot "$PLOT_SCRIPT"


rm "$PLOT_SCRIPT"


echo "Histogram saved as histogram.png"
