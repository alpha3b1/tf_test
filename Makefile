
build_ami:
	cd packer && packer build jump_ami.json

build_container:
	./build_container.sh
