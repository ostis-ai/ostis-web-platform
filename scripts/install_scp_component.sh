cd ../sc-web/components
git clone https://github.com/belya/scp-debugger-interface scp
mkdir ../client/static/common/cytoscape
mv scp/cytoscape.js ../client/static/common/cytoscape/cytoscape.js
cd ../client/templates
echo '<script type="text/javascript" charset="utf-8" src="/static/common/cytoscape/cytoscape.js"></script>' >> common.html
echo '<link rel="stylesheet" type="text/css" href="/static/components/css/scp.css" /><script type="text/javascript" charset="utf-8" src="/static/components/js/scp/scp.js"></script>' >> components.html
cd ../../scripts
python build_components.py -i -a
cd ../../kb
echo 'ui_external_languages -> scp_debugger_view;; scp_debugger_view => nrel_main_idtf: [Отладчик SCP] (* <- lang_ru;;*);; format_scp_debugger => nrel_main_idtf: [Формат SCP отладчика] (* <- lang_ru;; *);;' > scp_debugger_view.scs