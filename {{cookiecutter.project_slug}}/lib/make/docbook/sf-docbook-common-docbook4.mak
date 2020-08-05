DOCBOOK4_INSTALLED_CSS_DIRS = $(DOCBOOK4_DIRS_LIST:%=$(SRC_POST_DEST)/%/docbook-css)

DOCBOOK4_BASE_DIR := lib/docbook/4
DOCBOOK4_RENDERED_DIR := $(DOCBOOK4_BASE_DIR)/rendered
DOCBOOK4_ALL_IN_ONE_XHTML_DIR := $(DOCBOOK4_BASE_DIR)/essays

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

install_docbook4_pdfs: $(DOCBOOK4_INSTALLED_PDFS)

install_docbook4_xmls: $(DOCBOOK4_INSTALLED_XMLS)

install_docbook4_rtfs: $(DOCBOOK4_INSTALLED_RTFS)

install_docbook_individual_xhtmls: $(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS) $(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS_CSS)

install_docbook_css_dirs: $(DOCBOOK4_INSTALLED_CSS_DIRS)

docbook_extended: $(DOCBOOK4_FOS) $(DOCBOOK4_PDFS) \
	install_docbook4_pdfs install_docbook4_rtfs

docbook_targets: docbook4_targets install_docbook4_xmls install_docbook_css_dirs

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

docbook4_targets: $(DOCBOOK4_TARGETS) $(DOCBOOK4_ALL_IN_ONE_XHTMLS) $(DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS)

docbook_indiv: $(DOCBOOK4_INDIVIDUAL_XHTMLS)
