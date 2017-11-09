# /bin/bash
echo "Building csv-generator"
swift build
echo "Generate symbolic link"
ln ./.build/x86_64-apple-macosx10.10/debug/csv-generator ../csv-gen
echo "Done!" 
