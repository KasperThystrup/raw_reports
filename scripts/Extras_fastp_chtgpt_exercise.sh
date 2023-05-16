#!/bin/bash

# Parse command-line arguments
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -s|--sample-dir)
      SAMPLE_DIR="$2"
      shift
      shift
      ;;
    -o|--output-dir)
      REPORT_DIR="$2"
      shift
      shift
      ;;
    *)
      echo "Error: invalid argument '$1'"
      exit 1
      ;;
  esac
done

# Check that sample and report directories are provided
if [[ -z "${SAMPLE_DIR}" || -z "${REPORT_DIR}" ]]
then
  echo "Error: sample directory and/or report directory not provided"
  exit 1
fi

# Create report directory if it doesn't exist
if [[ ! -d "${REPORT_DIR}" ]]
then
  mkdir -p "${REPORT_DIR}"
fi

# Loop through paired-end read files in sample directory
for mate1 in "${SAMPLE_DIR}"/*_R1*
do
  # Check if R1 file exists and is not a directory
  if [[ -f "${?X?1}" ]]
  then
    # Construct name of R2 file
    ?X?2="${mate1/_R1/_R2}"

    # Check if R2 file exists and is not a directory
    if [[ -f "${?X?2}" ]]
    then
      # Extract sample name from R1 file name
      sample="$(basename -- ${mate1%%_R1*})"

      # Run fastp on paired-end reads
      fastp -i "${?X?1}" -I "${?X?2}" -o "${SAMPLE_DIR}/${?Y?}_R1_trimmed.fastq.gz" \
        -O "${SAMPLE_DIR}/${?Y?}_R2_trimmed.fastq.gz" \
        --html "${REPORT_DIR}/${?Y?}.html" --json "${REPORT_DIR}/${?Y?}_fastp.json"
    fi
  fi
done

