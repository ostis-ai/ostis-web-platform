#!/bin/bash
export LD_LIBRARY_PATH=../sc-machine/bin
if [ ! -d "../ims.ostis.kb_copy" ]; then
    mkdir ../ims.ostis.kb_copy
else
    rm -rf ../ims.ostis.kb_copy/*
fi

cd ../

cp -a ims.ostis.kb/ims/doc_technology_ostis/semantic_network_represent/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ims/doc_technology_ostis/unificated_models/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ims/doc_technology_ostis/semantic_networks_processing/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ims/doc_technology_ostis/library_OSTIS/components_interface/ui_menu/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ims/doc_technology_ostis/library_OSTIS/components_kpm/lib_c_agents/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ims/doc_technology_ostis/library_OSTIS/components_kpm/lib_scp_agents/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ims/doc_technology_ostis/library_OSTIS/components_kpm/programs_for_sc_text_processing/scp_program/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/to_check/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ui/ ims.ostis.kb_copy/
rm -rf ims.ostis.kb_copy/ui/menu

cd -



