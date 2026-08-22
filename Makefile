AUX_DIR   := .aux
OUT_DIR   := outputs
TEX_FILES := $(wildcard figures/*.tex)
PDF_FILES := $(patsubst %.tex,$(OUT_DIR)/%.pdf,$(notdir $(TEX_FILES))) 
PDF_FILES := $(patsubst %.tex,$(OUT_DIR)/%.svg,$(notdir $(TEX_FILES))) 

# Utilities
LATEXMK  := latexmk
PDFCAIRO := pdftocairo


.PHONY: figures clean

figures: $(SVG_FILES) | $(PDF_FILES) 

$(AUX_DIR) $(OUT_DIR):
	@echo "Creating '$@' directory..."
	@mkdir -p $@

$(OUT_DIR)/%.pdf: figures/%.tex | $(AUX_DIR) $(OUT_DIR)
	@command -v $(LATEXMK) >/dev/null 2>&1 || \
		{ echo "Error: $(LATEXMK) not found."; exit 1; }
	$(LATEXMK) \
		-interaction=nonstopmode \
		-halt-on-error \
		-auxdir=$(AUX_DIR) \
		-outdir=$(OUT_DIR) \
		$<

$(OUT_DIR)/%.svg: $(OUT_DIR)/%.pdf | $(OUT_DIR)
	@command -v $(PDFCAIRO) >/dev/null 2>&1 || \
		{ echo "Error: $(PDFCAIRO) not found."; exit 1; }
	$(PDFCAIRO) -svg $< $@

clean:
	rm -rf $(AUX_DIR) $(OUT_DIR)