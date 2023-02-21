
build_ami:
	cd packer && packer build jump_ami.json

build_image:
	./build_container.sh

tf_apply:
	cd tf && terraform apply --auto-approve
