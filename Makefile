deploy: PLAYBOOK := site.yml
deploy: venv
	echo Running $(PLAYBOOK) with production inventory..
	./venv/bin/ansible-playbook \
    -i hosts/production --ask-vault-pass --ask-become-pass \
     $(if $(tags),--tags='$(tags)',) \
     $(PLAYBOOK)

venv:
	python -m venv venv
	venv/bin/pip install --upgrade pip
	venv/bin/pip install --upgrade setuptools
	venv/bin/pip install --upgrade -r requirements.txt
	venv/bin/ansible-galaxy install -r requirements.yml

clean:
	rm -rf venv/ vendor/

.PHONY: clean

.SILENT:
