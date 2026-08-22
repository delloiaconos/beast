BUILD_DIR := .build
TEX_FILES := $(wildcard figures/*.tex)
PDF_FILES := $(patsubst %.tex,$(BUILD_DIR)/%.pdf,$(TEX_FILES))

PDFLATEX  := pdflatex

.PHONY: figures clean

figures: $(PDF_FILES)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.pdf: %.tex | $(BUILD_DIR)
	$(PDFLATEX) \
		-interaction=nonstopmode \
		-halt-on-error \
		-output-directory=$(BUILD_DIR) \
		$<