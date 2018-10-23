DOCMAKE ?= docmake

DOCMAKE_PARAMS = -v
DOCMAKE_WITH_PARAMS = $(DOCMAKE) $(DOCMAKE_PARAMS)

DOCMAKE_SGML_PATH = lib/sgml/shlomif-docbook

# DOCBOOK5_RELAXNG = http://www.docbook.org/xml/5.0/rng/docbook.rng
DOCBOOK5_RELAXNG = lib/sgml/relax-ng/docbook.rng

DOCBOOK5_BASE_DIR = lib/docbook/5
DOCBOOK5_ALL_IN_ONE_XHTML_DIR = $(DOCBOOK5_BASE_DIR)/essays
DOCBOOK5_SOURCES_DIR = $(DOCBOOK5_BASE_DIR)/xml
DOCBOOK5_FOR_OOO_XHTML_DIR = $(DOCBOOK5_BASE_DIR)/for-ooo-xhtml
DOCBOOK5_RENDERED_DIR = $(DOCBOOK5_BASE_DIR)/rendered

DOCBOOK5_XSL_STYLESHEETS_PATH := /usr/share/sgml/docbook/xsl-ns-stylesheets

DOCBOOK5_XSL_STYLESHEETS_XHTML_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/xhtml-1_1
DOCBOOK5_XSL_STYLESHEETS_ONECHUNK_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/onechunk
DOCBOOK5_XSL_STYLESHEETS_FO_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/fo

DOCBOOK5_XSL_CUSTOM_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-xhtml.xsl
DOCBOOK5_XSL_ONECHUNK_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-xhtml-onechunk.xsl
DOCBOOK5_XSL_FO_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-fo.xsl
include lib/make/docbook/sf-homepage-docbooks-generated.mak

DOCBOOK4_INSTALLED_CSS_DIRS = $(DOCBOOK4_DIRS_LIST:%=$(T2_POST_DEST)/%/docbook-css)

DOCBOOK4_BASE_DIR = lib/docbook/4
DOCBOOK4_RENDERED_DIR = $(DOCBOOK4_BASE_DIR)/rendered
DOCBOOK4_ALL_IN_ONE_XHTML_DIR = $(DOCBOOK4_BASE_DIR)/essays

docbook4_targets = $(patsubst %,$(1)/%$(2),$(DOCBOOK4_DOCS))
DOCBOOK4_TARGETS = $(call docbook4_targets,$(DOCBOOK4_RENDERED_DIR),.html)
DOCBOOK4_XMLS = $(call docbook4_targets,$(DOCBOOK4_XML_DIR),.xml)
DOCBOOK4_FOS = $(call docbook4_targets,$(DOCBOOK4_FO_DIR),.fo)
DOCBOOK4_PDFS = $(call docbook4_targets,$(DOCBOOK4_PDF_DIR),.pdf)
DOCBOOK4_RTFS = $(call docbook4_targets,$(DOCBOOK4_RTF_DIR),.rtf)
DOCBOOK4_INDIVIDUAL_XHTMLS = $(call docbook4_targets,$(DOCBOOK4_INDIVIDUAL_XHTML_DIR),)
DOCBOOK4_ALL_IN_ONE_XHTMLS = $(call docbook4_targets,$(DOCBOOK4_ALL_IN_ONE_XHTML_DIR),/all-in-one.html)

# We have our own style for human-hacking-field-guide so we get rid of it.
DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS = $(patsubst %/all-in-one.html,%/style.css,$(filter-out human-hacking-%,$(DOCBOOK4_ALL_IN_ONE_XHTMLS)))

DOCBOOK5_TARGETS = $(patsubst %,$(DOCBOOK5_RENDERED_DIR)/%.xhtml,$(DOCBOOK5_DOCS))
DOCBOOK5_XMLS = $(patsubst %,$(DOCBOOK5_XML_DIR)/%.xml,$(DOCBOOK5_DOCS))

DOCBOOK5_EPUBS = $(patsubst %,$(DOCBOOK5_EPUB_DIR)/%.epub,$(filter-out hebrew-html-tutorial ,$(DOCBOOK5_DOCS)))

DOCBOOK5_FOS = $(patsubst %,$(DOCBOOK5_FO_DIR)/%.fo,$(DOCBOOK5_DOCS))

DOCBOOK5_FOR_OOO_XHTMLS = $(patsubst %,$(DOCBOOK5_FOR_OOO_XHTML_DIR)/%.html,$(DOCBOOK5_DOCS))

DOCBOOK5_PDFS = $(patsubst %,$(DOCBOOK5_PDF_DIR)/%.pdf,$(DOCBOOK5_DOCS))

DOCBOOK5_RTFS = $(patsubst %,$(DOCBOOK5_RTF_DIR)/%.rtf,$(DOCBOOK5_DOCS))

DOCBOOK5_INDIVIDUAL_XHTMLS = $(addprefix $(DOCBOOK5_INDIVIDUAL_XHTML_DIR)/,$(DOCBOOK5_DOCS))

DOCBOOK5_ALL_IN_ONE_XHTMLS__DIRS = $(patsubst %,$(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%,$(DOCBOOK5_DOCS))
DOCBOOK5_ALL_IN_ONE_XHTMLS = $(patsubst %,$(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml,$(DOCBOOK5_DOCS))

install_docbook5_epubs: make-dirs $(DOCBOOK5_INSTALLED_EPUBS)
install_docbook5_htmls: make-dirs $(DOCBOOK5_INSTALLED_HTMLS)

install_docbook4_pdfs: make-dirs $(DOCBOOK4_INSTALLED_PDFS)
install_docbook5_pdfs: make-dirs $(DOCBOOK5_INSTALLED_PDFS)

install_docbook4_xmls: make-dirs $(DOCBOOK4_INSTALLED_XMLS)
install_docbook5_xmls: make-dirs $(DOCBOOK5_INSTALLED_XMLS)

install_docbook4_rtfs: make-dirs  $(DOCBOOK4_INSTALLED_RTFS)
install_docbook5_rtfs: make-dirs  $(DOCBOOK5_INSTALLED_RTFS)

install_docbook_individual_xhtmls: make-dirs $(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS) $(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS_CSS) $(DOCBOOK5_INSTALLED_INDIVIDUAL_XHTMLS) $(DOCBOOK5_INSTALLED_INDIVIDUAL_XHTMLS_CSS)

install_docbook_css_dirs: make-dirs $(DOCBOOK4_INSTALLED_CSS_DIRS)

docbook_extended: $(DOCBOOK4_FOS) $(DOCBOOK4_PDFS) \
	$(DOCBOOK5_FOS) $(DOCBOOK5_PDFS) \
	install_docbook4_pdfs install_docbook4_rtfs \
	install_docbook5_pdfs install_docbook5_rtfs

docbook_targets: docbook4_targets docbook5_targets \
	install_docbook5_epubs \
	install_docbook5_htmls \
	install_docbook4_xmls install_docbook_individual_xhtmls \
	install_docbook_css_dirs install_docbook5_xmls \

$(DOCBOOK5_RTF_DIR)/%.rtf: $(DOCBOOK5_FO_DIR)/%.fo
	fop -fo $< -rtf $@

$(DOCBOOK5_FOR_OOO_XHTML_DIR)/%.html: $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml
	cat $< | $(PERL) -lne 's{(</title>)}{$${1}<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />}; print unless m{\A<\?xml}' > $@

EPUB_SCRIPT = $(DOCBOOK5_XSL_STYLESHEETS_PATH)/epub/bin/dbtoepub
EPUB_XSLT = lib/sgml/shlomif-docbook/docbook-epub-preproc.xslt
DBTOEPUB = ruby $(EPUB_SCRIPT)

$(DOCBOOK5_EPUBS): $(DOCBOOK5_EPUB_DIR)/%.epub: $(DOCBOOK5_XML_DIR)/%.xml
	$(DBTOEPUB) -s $(EPUB_XSLT) -o $@ $<

$(DOCBOOK5_PDF_DIR)/%.pdf: $(DOCBOOK5_FO_DIR)/%.fo
	fop -fo $< -pdf $@

$(DOCBOOK4_RENDERED_DIR)/%.html: $(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html
	./bin/clean-up-docbook-xsl-xhtml.pl -o $@ $<

$(DOCBOOK4_FO_DIR)/%.fo: $(DOCBOOK4_XML_DIR)/%.xml
	$(DOCMAKE_WITH_PARAMS) -o $@ --stringparam "docmake.output.format=fo" -x $(FO_XSLT_SS) fo $<
	$(PERL) -lpi -e 's/[ \t]+\z//' $@

$(DOCBOOK4_PDF_DIR)/%.pdf: $(DOCBOOK4_FO_DIR)/%.fo
	fop -fo $< -pdf $@

$(DOCBOOK4_RTF_DIR)/%.rtf: $(DOCBOOK4_FO_DIR)/%.fo
	fop -fo $< -rtf $@

$(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html: $(DOCBOOK4_XML_DIR)/%.xml
	$(DOCMAKE) --stringparam "docmake.output.format=xhtml" -x $(XHTML_ONE_CHUNK_XSLT_SS) -o $(patsubst $(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html,$(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%,$@) xhtml $<
	mv $(@:%/all-in-one.html=%/index.html) $@
	$(PERL) -lpi -e 's/[ \t]+\z//' $@

$(DOCBOOK5_ALL_IN_ONE_XHTMLS): $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml: $(DOCBOOK5_SOURCES_DIR)/%.xml
	# jing $(DOCBOOK5_RELAXNG) $<
	$(DOCMAKE) --stringparam "docbook.css.source=" --stringparam "root.filename=$@.temp.xml" --basepath $(DOCBOOK5_XSL_STYLESHEETS_PATH) -x $(DOCBOOK5_XSL_ONECHUNK_XSLT_STYLESHEET) xhtml5 $<
	xsltproc --output $@ ./bin/clean-up-docbook-xhtml-1.1.xslt $@.temp.xml.xhtml
	rm -f $@.temp.xml.xhtml
	$(PERL) -I./lib -MShlomif::DocBookClean -lpi -0777 -e 's/[ \t]+$$//gms; Shlomif::DocBookClean::cleanup_docbook(\$$_);' $@

$(DOCBOOK5_RENDERED_DIR)/%.xhtml: $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml
	./bin/clean-up-docbook-5-xsl-xhtml-1_1.pl -o $@ $<

$(DOCBOOK5_FO_DIR)/%.fo: $(DOCBOOK5_SOURCES_DIR)/%.xml
	$(DOCMAKE_WITH_PARAMS) --basepath $(DOCBOOK5_XSL_STYLESHEETS_PATH) -o $@ -x $(DOCBOOK5_XSL_FO_XSLT_STYLESHEET) fo $<
	$(PERL) -lpi -e 's/[ \t]+\z//' $@

docbook4_targets: $(DOCBOOK4_TARGETS) $(DOCBOOK4_ALL_IN_ONE_XHTMLS) $(DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS)

docbook5_targets: $(DOCBOOK5_TARGETS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS_CSS) $(DOCBOOK5_RENDERED_HTMLS) $(DOCBOOK5_FOS) $(DOCBOOK5_FOR_OOO_XHTMLS)

