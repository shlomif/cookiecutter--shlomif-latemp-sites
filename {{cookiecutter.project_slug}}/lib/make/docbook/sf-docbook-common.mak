
DOCBOOK5_BASE_DIR = lib/docbook/5
DOCBOOK5_ALL_IN_ONE_XHTML_DIR = $(DOCBOOK5_BASE_DIR)/essays
DOCBOOK5_SOURCES_DIR = $(DOCBOOK5_BASE_DIR)/xml
DOCBOOK5_FOR_OOO_XHTML_DIR = $(DOCBOOK5_BASE_DIR)/for-ooo-xhtml
DOCBOOK5_RENDERED_DIR = $(DOCBOOK5_BASE_DIR)/rendered

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

