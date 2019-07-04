# Makefile automatic variables:
# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables
# https://www.gnu.org/software/make/manual/html_node/Pattern-Intro.html#Pattern-Intro
# https://www.gnu.org/software/make/manual/html_node/Text-Functions.html#Text-Functions
# https://www.gnu.org/software/make/manual/html_node/File-Name-Functions.html#File-Name-Functions
#
# http://web.mit.edu/gnu/doc/html/make_toc.html
# http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
# http://nuclear.mutantstargoat.com/articles/make/
# https://gist.github.com/mattrobenolt/2922132
# https://blog.jgc.org/2006/04/rebuilding-when-hash-has-changed-not.html
# https://www.cmcrossroads.com/article/makefile-optimization-eval-and-macro-caching
# https://www.cmcrossroads.com/article/rebuilding-when-files-checksum-changes
# https://www.cmcrossroads.com/article/makefile-optimization-eval-and-macro-caching
#
#
#
# https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html
# http://www.chiark.greenend.org.uk/doc/make-doc/make.html/Using-Variables.html

# %{_topdir} = %{getenv:HOME}/rpmbuild
# https://possiblelossofprecision.net/?p=1229

# .SECONDEXPANSION:
# .ONESHELL:
# .SILENT:

ISOS := $(wildcard ISO/*.iso)
SHAS := $(addsuffix .sha, $(ISOS))

centos6iso := ISO/CentOS-6.10-x86_64-minimal.iso
centos7iso := ISO/CentOS-7-x86_64-Minimal-1810.iso

# packer env vars: https://www.packer.io/docs/other/environment-variables.html
export PACKER_CACHE_DIR := packer_cache
export PACKER_LOG := 1
export PACKER_LOG_PATH := 'packerlog.txt'
export PACKERDIR := packer
export PACKERTEMPLATE := packer-vbox.json

# https://gist.github.com/prwhite/8168133
help:           ## Show this help.
	@echo Makefile targets:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


precheck: 		## Check for required binaries installed etc
	./pre-check.sh

# centos6: $(PACKERTEMPLATE) $(SHAS) $(PACKERDIR)/vars-centos6.json 		## Generates a CentOS 6 vbox
centos6: $(PACKERTEMPLATE) $(SHAS) $(PACKERDIR)/vars-centos6.json 		## Generates a CentOS 6 vbox
	rm -f $(PACKER_LOG_PATH) || :
	# Get isofile variable
	# jq -M -r '.iso' packer/vars-centos6.json
	$(eval SHAFILE := $($@iso).sha )
	$(eval ISOSHA := $(shell cut -f1 -d' ' $(SHAFILE)))
	# Update sha in packer json file
	jq ".sha = \"$(ISOSHA)\"" $(PACKERDIR)/vars-$@.json | sponge $(PACKERDIR)/vars-$@.json
	# packer buld --debug
	# packer build -on-error=ask
	# packer build -force
	#packer build --var 'sha=$(shell cat $(centos6iso).sha )' --var 'iso=$(centos6iso) packer-vbox.json
	#packer build --debug -on-error=ask -force --var-file=packer/vars-centos6.json packer-vbox.json
	packer build -force -on-error=ask --var-file=$(PACKERDIR)/vars-$@.json $(PACKERTEMPLATE)

centos7: ## Build CentOS v7
	rm -f $(PACKER_LOG_PATH) || :
	$(eval SHAFILE := $($@iso).sha )
	$(eval ISOSHA := $(shell cut -f1 -d' ' $(SHAFILE)))
	echo $(SHAFILE) $(ISOSHA)
	jq ".sha = \"$(ISOSHA)\"" $(PACKERDIR)/vars-$@.json | sponge $(PACKERDIR)/vars-$@.json
	packer build -on-error=ask -force --var-file=packer/vars-$@.json $(PACKERTEMPLATE)

validate: ## packer validate template
	packer $@ $(PACKERTEMPLATE)

inspect: ## packer inspect template
	packer $@ $(PACKERTEMPLATE)

# iso:
# 	http://isoredirect.centos.org/centos/7/isos/x86_64/
# 	wget http://mirrors.mit.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso

sha: $(SHAS) ## Generate sha256sum for iso files in ISO/*.iso

%.iso.sha: %.iso
#	$(if $(filter-out $(shell cat $@ 2>/dev/null),$(shell sha256sum $*)),sha256sum $* > $@)
	sha256sum $< > $@
