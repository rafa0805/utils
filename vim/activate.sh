#!/usr/bin/bash -eu 

src_files_array=(".vimrc" ".gvimrc")
target_base_path=~/

for file in ${src_files_array[@]}; do
    
    if [[ ! -f "${target_base_path}${file}" ]]; then
        echo "Exec: cp ${file} ${target_base_path}${file}"
        cp ${file} ${target_base_path}${file}
        echo "${target_base_path}${file} created successfully"
        ls -l ${target_base_path}${file}
                
    else
        echo "${target_base_path}${file} already exists..."
    fi

done

echo "Completed!!!"
