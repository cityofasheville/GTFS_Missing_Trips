for file in *.csv
do
  mv "$file" "${file%.csv}.txt"
done
