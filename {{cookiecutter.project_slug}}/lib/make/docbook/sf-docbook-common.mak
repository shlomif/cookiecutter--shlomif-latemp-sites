DOCMAKE ?= docmake

DOCMAKE_PARAMS = -v
DOCMAKE_WITH_PARAMS = $(DOCMAKE) $(DOCMAKE_PARAMS)

DOCMAKE_SGML_PATH := lib/sgml/shlomif-docbook

# DOCBOOK5_RELAXNG := http://www.docbook.org/xml/5.0/rng/docbook.rng
DOCBOOK5_RELAXNG := lib/sgml/relax-ng/docbook.rng

DOCBOOK5_BASE_DIR := lib/docbook/5
DOCBOOK5_ALL_IN_ONE_XHTML_DIR := $(DOCBOOK5_BASE_DIR)/essays
DOCBOOK5_SOURCES_DIR := $(DOCBOOK5_BASE_DIR)/xml
DOCBOOK5_RENDERED_DIR := $(DOCBOOK5_BASE_DIR)/rendered

DOCBOOK5_XSL_STYLESHEETS_PATH := /usr/share/sgml/docbook/xsl-ns-stylesheets

DOCBOOK5_XSL_STYLESHEETS_XHTML_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/xhtml-1_1
DOCBOOK5_XSL_STYLESHEETS_ONECHUNK_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/onechunk
DOCBOOK5_XSL_STYLESHEETS_FO_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/fo

DOCBOOK5_XSL_CUSTOM_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-xhtml.xsl
DOCBOOK5_XSL_ONECHUNK_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-xhtml-onechunk.xsl
DOCBOOK5_XSL_FO_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-fo.xsl

include lib/make/docbook/sf-homepage-docbooks-generated.mak

DOCBOOK5_TARGETS = $(patsubst %,$(DOCBOOK5_RENDERED_DIR)/%.xhtml,$(DOCBOOK5_DOCS))
DOCBOOK5_XMLS = $(patsubst %,$(DOCBOOK5_XML_DIR)/%.xml,$(DOCBOOK5_DOCS))
DOCBOOK5_EPUBS = $(patsubst %,$(DOCBOOK5_EPUB_DIR)/%.epub,$(filter-out hebrew-html-tutorial ,$(DOCBOOK5_DOCS)))
DOCBOOK5_FOS = $(patsubst %,$(DOCBOOK5_FO_DIR)/%.fo,$(DOCBOOK5_DOCS))
DOCBOOK5_PDFS = $(patsubst %,$(DOCBOOK5_PDF_DIR)/%.pdf,$(DOCBOOK5_DOCS))
DOCBOOK5_RTFS = $(patsubst %,$(DOCBOOK5_RTF_DIR)/%.rtf,$(DOCBOOK5_DOCS))

DOCBOOK5_INDIVIDUAL_XHTMLS = $(addprefix $(DOCBOOK5_INDIVIDUAL_XHTML_DIR)/,$(DOCBOOK5_DOCS))

DOCBOOK5_ALL_IN_ONE_XHTMLS__DIRS = $(patsubst %,$(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%,$(DOCBOOK5_DOCS))
DOCBOOK5_ALL_IN_ONE_XHTMLS = $(patsubst %,$(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml,$(DOCBOOK5_DOCS))

install_docbook5_epubs: make-dirs $(DOCBOOK5_INSTALLED_EPUBS)
install_docbook5_htmls: make-dirs $(DOCBOOK5_INSTALLED_HTMLS)

install_docbook5_pdfs: make-dirs $(DOCBOOK5_INSTALLED_PDFS)

install_docbook5_xmls: make-dirs $(DOCBOOK5_INSTALLED_XMLS)

install_docbook5_rtfs: make-dirs  $(DOCBOOK5_INSTALLED_RTFS)

install_docbook_individual_xhtmls: make-dirs $(DOCBOOK5_INSTALLED_INDIVIDUAL_XHTMLS) $(DOCBOOK5_INSTALLED_INDIVIDUAL_XHTMLS_CSS)

docbook_extended: install_docbook5_pdfs install_docbook5_rtfs

docbook_targets: docbook5_targets \
	install_docbook5_epubs \
	install_docbook5_htmls \
	install_docbook_individual_xhtmls \
	install_docbook5_xmls

dbtortf_func = fop -fo $< -rtf $@

$(DOCBOOK5_RTF_DIR)/%.rtf: $(DOCBOOK5_FO_DIR)/%.fo
	$(call dbtortf_func)

EPUB_SCRIPT = $(DOCBOOK5_XSL_STYLESHEETS_PATH)/epub/bin/dbtoepub
EPUB_XSLT = lib/sgml/shlomif-docbook/docbook-epub-preproc.xslt
DBTOEPUB = ruby $(EPUB_SCRIPT)
dbtoepub_func = $(DBTOEPUB) -s $(EPUB_XSLT) -o $@ $<

$(DOCBOOK5_EPUBS): $(DOCBOOK5_EPUB_DIR)/%.epub: $(DOCBOOK5_XML_DIR)/%.xml
	$(call dbtoepub_func)

dbtopdf_func = fop -fo $< -pdf $@

$(DOCBOOK5_PDF_DIR)/%.pdf: $(DOCBOOK5_FO_DIR)/%.fo
	$(call dbtopdf_func)

$(DOCBOOK5_ALL_IN_ONE_XHTMLS): $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml: $(DOCBOOK5_SOURCES_DIR)/%.xml
	$(DOCMAKE) --stringparam "docbook.css.source=" --stringparam "root.filename=$(patsubst %.xhtml,%,$@)" --basepath $(DOCBOOK5_XSL_STYLESHEETS_PATH) -x $(DOCBOOK5_XSL_ONECHUNK_XSLT_STYLESHEET) xhtml5 $<
	$(PERL) -I./lib -C -MShlomif::DocBookClean -lpi -0777 -e 'Shlomif::DocBookClean::cleanup_docbook(\$$_);' $@

$(DOCBOOK5_RENDERED_DIR)/%.xhtml: $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml
	./bin/clean-up-docbook-5-xsl-xhtml-1_1.pl -o $@ $<

$(DOCBOOK5_FO_DIR)/%.fo: $(DOCBOOK5_SOURCES_DIR)/%.xml
	$(DOCMAKE_WITH_PARAMS) --basepath $(DOCBOOK5_XSL_STYLESHEETS_PATH) -o $@ -x $(DOCBOOK5_XSL_FO_XSLT_STYLESHEET) fo $<
	$(PERL) -lpi -e 's/[ \t]+\z//' $@

docbook5_targets: $(DOCBOOK5_TARGETS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS_CSS) $(DOCBOOK5_RENDERED_HTMLS)
