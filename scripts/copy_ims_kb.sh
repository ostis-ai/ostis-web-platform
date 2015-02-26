#!/bin/bash
export LD_LIBRARY_PATH=../sc-machine/bin
if [ ! -d "../ims.ostis.kb_copy" ]; then
    mkdir ../ims.ostis.kb_copy
else
    rm -rf ../ims.ostis.kb_copy/*
fi

cd ../

cp -a ims.ostis.kb/knowledge_base_IMS/doc_technology_ostis/section_unificated_semantic_network_and_representation/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/knowledge_base_IMS/doc_technology_ostis/section_unificated_models/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/knowledge_base_IMS/doc_technology_ostis/section_basic_model_of_the_unified_processing_of_semantic_networks/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/knowledge_base_IMS/doc_technology_ostis/section_library_OSTIS/section_library_of_reusable_components_interfaces/lib_ui_menu/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/knowledge_base_IMS/doc_technology_ostis/section_library_OSTIS/section_library_of_reusable_components_processing_machinery_knowledge/lib_c_agents/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/knowledge_base_IMS/doc_technology_ostis/section_library_OSTIS/section_library_of_reusable_components_processing_machinery_knowledge/lib_scp_agents/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/knowledge_base_IMS/doc_technology_ostis/section_library_OSTIS/section_library_of_reusable_components_processing_machinery_knowledge/section_library_of_reusable_programs_for_sc_text_processing/lib_scp_program/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/to_check/ ims.ostis.kb_copy/
cp -a ims.ostis.kb/ui/ ims.ostis.kb_copy/
rm -rf ims.ostis.kb_copy/ui/menu

cd -



