#! /bin/bash

project_dir=${PWD}

exe="dmfw_sim_service"

service="${exe}.service"

build_dir=${project_dir}/build

service_dir=/etc/systemd/system/${service}

conf_dir=${project_dir}/src/STSPlugin/ConfigMgr/STSConf.xml.lts

chmod +x ${project_dir}/tools/DEBIAN/*

mkdir -p ${build_dir}; rm -rf ${build_dir}/*

cd ${build_dir}

/usr/bin/cmake -DCMAKE_BUILD_TYPE=Release ${project_dir}

/usr/bin/cmake --build ${build_dir} --target clean -- -j 40

/usr/bin/cmake --build ${build_dir} --target gen_grpc_files -- -j 40

/usr/bin/cmake --build ${build_dir} --target gen_pb_files -- -j 40

/usr/bin/cmake --build ${build_dir} --target all -- -j 40

/usr/bin/cmake --build ${build_dir} --target package_exe 

#/usr/bin/cmake --build ${build_dir} --target package_src

