#!/usr/bin/bash -eu
#文字化け防止用#あいうえお#京都の雀の往来#

src_base_dir=/home/vagrant/rafa_utils/bash
src_files_array=(".ryk")
target_base_dir=~
overwrite=1

# House made functions
function copy_file(){
    echo "Exec: cp ${src_base_dir}/${file} ${target_base_dir}"
    cp -r ${src_base_dir}/${file} ${target_base_dir}
    echo "[OK] ${target_base_dir}/${file} created successfully"
    ls -l ${target_base_dir}/${file}
}

for file in ${src_files_array[@]}; do
    
    # ファイルを配置
    if [[ ! -f "${target_base_dir}/${file}" ]]; then
        copy_file        
    else
        if [[ ${overwrite} = 1  ]]; then
            cp -r ${target_base_dir}/${file} ${target_base_dir}/${file}_`date +'%Y%m%d'`
            echo "[OK] Backup created for ${target_base_dir}/${file}..."
            copy_file
        else
            echo "[OK] ${target_base_dir}/${file} already exists..."
        fi
    fi

    # .bashrcにインポートして再読み込みを実行
    if [[ `grep "source ~/${file}" ~/.bashrc` == ""  ]]; then
        echo "source ~/${file}" >> ~/.bashrc
        echo "[OK] \"source ~/${file}\" was added to ~/.bashrc"
    else
        echo "[OK] Already imported in bashrc"
    fi
    
    echo "[OK] Restarting bashrc"
    source ~/.bashrc
    echo $?

done

echo "Completed!!!"
