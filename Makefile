# 
# pak144.Excentrique Makefile
# 

MAKEOBJ ?= ./makeobj

DESTDIR  ?= .
PAKDIR   ?= $(DESTDIR)/pak144.Excentrique
ADDONDIR ?= $(DESTDIR)/addons/pak144.Excentrique
PAKVERSION ?= 1
DESTFILE ?= pak144.Excentrique_v0$(PAKVERSION)
INSTALL ?= ../../simutrans/pak144.Excentrique

OUTSIDE :=
OUTSIDE += src/ground

DIRS144 :=
DIRS144 += src/city
DIRS144 += src/city/res
DIRS144 += src/city/com
DIRS144 += src/city/ind
DIRS144 += src/industry
DIRS144 += src/industry/music
DIRS144 += src/road
DIRS144 += src/rail
DIRS144 += src/rail/vehicles
DIRS144 += src/rail/vehicles/music
DIRS144 += src/tree
DIRS144 += src/misc

DIRS64 += src/skin

DIRS128 :=
DIRS128 += src/big_logo


DIRS := $(OUTSIDE) $(DIRS144) $(DIRS64) $(DIRS128)
ADDON_DIRS := $(ADDON_DIRS48)


.PHONY: $(DIRS) $(ADDON_DIRS48) copy tar zip

all: version copy $(DIRS) zip

archives: tar zip

tar: $(DESTFILE).tbz2
zip: $(DESTFILE).zip


release: clean copy $(DIRS)
	mkdir -p $(INSTALL)
	rm -rf $(INSTALL)/*
	cp index.png $(INSTALL)
	mv $(PAKDIR)/* $(INSTALL)


$(DESTFILE).tbz2: $(PAKDIR)
	@echo "===> TAR $@"
	@tar cjf $@ $(DESTDIR)

$(DESTFILE).zip: $(PAKDIR)
	@echo "===> ZIP $@"
	@zip -rq $@ $(PAKDIR)

copy:
	@echo "===> COPY"
	@mkdir -p $(PAKDIR)/sound $(PAKDIR)/text $(PAKDIR)/config $(PAKDIR)/scenario
	@cp -p src/config/* $(PAKDIR)/config
	@cp -p src/text/* $(PAKDIR)/text

$(DIRS144):
	@echo "===> PAK144 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK144 $(PAKDIR)/ $@/ > /dev/null

$(DIRS64):
	@echo "===> PAK64 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK64 $(PAKDIR)/ $@/ > /dev/null

$(DIRS128):
	@echo "===> PAK128 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK128 $(PAKDIR)/ $@/ > /dev/null

$(DIRS192):
	@echo "===> PAK192 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK192 $(PAKDIR)/ $@/ > /dev/null

version:
	@echo "===> Version"
	@mkdir -p $(PAKDIR)
	@rm -f src/ground/outside.dat
	@echo "Obj=ground" >src/ground/outside.dat
	@echo "Name=Outside" >>src/ground/outside.dat
	@echo "copyright=pak144.Excentrique v0.$(PAKVERSION)" >>src/ground/outside.dat
	@echo "Image[0][0]=hjm-starpatch.0.0" >>src/ground/outside.dat
	@echo "----------" >>src/ground/outside.dat

$(OUTSIDE):
	@$(MAKEOBJ) PAK144 $(PAKDIR)/ $@/ > /dev/null

clean:
	@echo "===> CLEAN"
	@rm -fr $(PAKDIR) $(DESTFILE).tbz2 $(DESTFILE).zip

addons: 	clean copy_addons $(ADDON_DIRS48)

copy_addons:
	@echo "===> COPY"
	@mkdir  -p $(ADDONDIR)

$(ADDON_DIRS48):
	@echo "===> PAK64 $@"
	@mkdir -p $(ADDONDIR)
	@$(MAKEOBJ) quiet PAK48 $(ADDONDIR)/ $@/ > /dev/null
