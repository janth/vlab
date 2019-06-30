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

# %{_topdir} = %{getenv:HOME}/rpmbuild
# https://possiblelossofprecision.net/?p=1229


ISOS := $(wildcard ISO/*.iso)
SHAS := $(addsuffix .sha, $(ISOS))

cent6iso := ISO/CentOS-6.10-x86_64-minimal.iso
cent7iso := ISO/CentOS-7-x86_64-Minimal-1810.iso

packertemplate = packer-vbox.json

# https://gist.github.com/prwhite/8168133
help:           ## Show this help.
	@echo Makefile targets:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

# packer env vars: https://www.packer.io/docs/other/environment-variables.html


precheck: ## Check for required binaries installed etc
	./pre-check.sh

centos6: ## Build CentOS v6
	@# Get iso
	@# jq -M -r '.iso' packer/vars-centos6.json
	$(eval cent6sha = $(shell cut -f1 -d' ' $(cent6iso).sha))
	jq ".sha = \"$(cent6sha)\"" packer/vars-$@.json | sponge packer/vars-$@.json
	# packer buld --debug
	# packer build -on-error=ask
	# packer build -force
	#packer build --var 'sha=$(shell cat $(cent6iso).sha )' --var 'iso=$(cent6iso) packer-vbox.json
	#packer build --debug -on-error=ask -force --var-file=packer/vars-centos6.json packer-vbox.json
	packer build -force --var-file=packer/vars-$@.json $(packertemplate)

centos7: ## Build CentOS v7
	packer build -force --var-file=packer/vars-$@.json $(packertemplate)

validate: ## packer validate template
	packer $@ $(packertemplate)

inspect: ## packer inspect template
	packer $@ $(packertemplate)

# iso:
# 	http://isoredirect.centos.org/centos/7/isos/x86_64/
# 	wget http://mirrors.mit.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso

sha: $(SHAS) ## Generate sha256sum for iso files in ISO/*.iso

%.iso.sha: %.iso
#	$(if $(filter-out $(shell cat $@ 2>/dev/null),$(shell sha256sum $*)),sha256sum $* > $@)
	sha256sum $< > $@
