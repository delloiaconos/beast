AUX_DIR   := .aux
OUT_DIR   := outputs

FIG_FILES:= $(wildcard figures/*.tex)
FIG_PDFS := $(patsubst %.tex,$(OUT_DIR)/%.pdf,$(notdir $(FIG_FILES))) 
FIG_SVGS := $(patsubst %.tex,$(OUT_DIR)/%.svg,$(notdir $(FIG_FILES))) 

UML_FILES:= $(wildcard architecture/*.puml)
UML_SVGS := $(addprefix $(OUT_DIR)/,$(addsuffix .svg, $(notdir $(basename $(UML_FILES))) ))
UML_PDFS := $(addprefix $(OUT_DIR)/,$(addsuffix .pdf, $(notdir $(basename $(UML_FILES))) ))
UML_PNGS := $(addprefix $(OUT_DIR)/,$(addsuffix .png, $(notdir $(basename $(UML_FILES))) ))

# Utilities
LATEXMK  ?= latexmk
PDFCAIRO ?= pdftocairo
PLANTUML ?= plantuml

.PHONY: figures umls clean

define check-command
	@command -v $(1) >/dev/null 2>&1 || \
		{ echo "Error: $(1) not found."; exit 1; }
endef

$(AUX_DIR) $(OUT_DIR):
	@echo "Creating '$@' directory..."
	@mkdir -p $@

# ------------------------------------------------------------
# LaTeX figures
# ------------------------------------------------------------

figures: $(FIG_SVGS) | $(FIG_PDFS) $(OUT_DIR)

$(FIG_PDFS): $(OUT_DIR)/%.pdf: figures/%.tex | $(AUX_DIR) $(OUT_DIR)
	$(call check-command,$(LATEXMK))
	$(LATEXMK) \
		-interaction=nonstopmode \
		-halt-on-error \
		-auxdir=$(AUX_DIR) \
		-outdir=$(OUT_DIR) \
		$<

$(FIG_SVGS): $(OUT_DIR)/%.svg: $(OUT_DIR)/%.pdf | $(OUT_DIR)
	$(call check-command,$(PDFCAIRO))
	$(PDFCAIRO) -svg $< $@

# ------------------------------------------------------------
# UML diagrams
# ------------------------------------------------------------

umls: $(UML_PDFS) $(UML_SVGS) | $(OUT_DIR)

$(UML_PDFS): $(OUT_DIR)/%.pdf: architecture/%.puml | $(OUT_DIR)
	$(call check-command,$(PLANTUML))
	$(PLANTUML) -tpdf -o "$(abspath $(OUT_DIR))" $<


$(UML_SVGS): $(OUT_DIR)/%.svg: architecture/%.puml | $(OUT_DIR)
	$(call check-command,$(PLANTUML))
	$(PLANTUML) -tsvg -o "$(abspath $(OUT_DIR))" $<

clean:
	rm -rf $(AUX_DIR) $(OUT_DIR)