#! /bin/bash

CONSOLE_COLOR_NONE="\033[m"
CONSOLE_COLOR_YELLOW="\033[0;33m"
CONSOLE_COLOR_GREEN="\033[0;32;32m"
CONSOLE_COLOR_LIGHT_BLUE="\033[1;32;34m"

size_total=0
lines_total=0
lines_total_valid=0

ignore_dir="./src/proto/generated/*"
dir_list=("./src/STSPlugin/" "./src/proto/" "../doc")
file_list=("*.h" "*.c" "*-*.md" "*.hpp" "*.cpp" "*.xml" "STSgRPC.proto" "CMakeLists.txt")

printf "${CONSOLE_COLOR_LIGHT_BLUE}+----------------+-------------+-------------+-------------+"
printf "${CONSOLE_COLOR_NONE}\n"

printf "${CONSOLE_COLOR_LIGHT_BLUE}| %-14s | %-11s | %-11s | %-11s |" "Filename" "All Lines" "Valid Lines" "Size (kb)"
printf "${CONSOLE_COLOR_NONE}\n"

printf "${CONSOLE_COLOR_LIGHT_BLUE}+----------------+-------------+-------------+-------------+"
printf "${CONSOLE_COLOR_NONE}\n"

for file in ${file_list[@]}; do
    # count file size
    size=0
    for dir in ${dir_list[@]}; do
        size=$(( ${size} + (`find ${dir} -name "${file}" ! -path "${ignore_dir}" | xargs cat | wc -c`) ))
    done
    size_total=$(( ${size_total} + ${size} ))

    # count file lines
    lines=0
    for dir in ${dir_list[@]}; do
        lines=$(( ${lines} + (`find ${dir} -name "${file}" ! -path "${ignore_dir}" | xargs cat | wc -l`) ))
    done
    lines_total=$(( ${lines_total} + ${lines} ))

    # count valid files lines
    lines_valid=0
    for dir in ${dir_list[@]}; do
        lines_valid=$(( ${lines_valid} + (`find ${dir} -name "${file}" ! -path "${ignore_dir}" | xargs cat | grep -v ^$ | wc -l`) ))
    done
    lines_total_valid=$(( ${lines_total_valid} + ${lines_valid} ))

    printf "${CONSOLE_COLOR_YELLOW}| %-14s | %-11s | %-11s | %-11.3f |" ${file} ${lines} ${lines_valid} "$(( ${size} ))e-3"
    printf "${CONSOLE_COLOR_NONE}\n"
done

printf "${CONSOLE_COLOR_GREEN}| %-14s | %-11s | %-11s | %-11.3f |" "total" ${lines_total} ${lines_total_valid} "$(( ${size_total} ))e-3"
printf "${CONSOLE_COLOR_NONE}\n"
printf "${CONSOLE_COLOR_GREEN}+----------------+-------------+-------------+-------------+"
printf "${CONSOLE_COLOR_NONE}\n"
