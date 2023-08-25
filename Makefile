build:
	@packer build -except=vagrant-cloud -timestamp-ui packer.pkr.hcl

clean:
	@rm -rf builds || true

release:
	@standard-version
	@packer build -timestamp-ui -var-file=variables.pkrvars.hcl \
	-var version=$$(git describe --tags `git rev-list --tags --max-count=1` | tr -d 'v') \
	packer.pkr.hcl
