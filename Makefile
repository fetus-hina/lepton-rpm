SOURCE_ARCHIVE := 1.0.tar.gz
TARGZ_FILE := lepton.tar.gz
IMAGE_NAME := lepton-package
centos7: IMAGE_NAME := $(IMAGE_NAME)-ce7

.PHONY: all clean centos7

all: centos7
centos7: centos7.build

rpmbuild/SOURCES/$(SOURCE_ARCHIVE):
	curl -SL https://github.com/dropbox/lepton/archive/$(SOURCE_ARCHIVE) -o $@

%.build: rpmbuild/SPECS/lepton.spec rpmbuild/SOURCES/$(SOURCE_ARCHIVE)
	[ -d $@.bak ] && rm -rf $@.bak || :
	[ -d $@ ] && mv $@ $@.bak || :
	cp Dockerfile.$* Dockerfile
	tar -czf - Dockerfile rpmbuild | docker build -t $(IMAGE_NAME) -
	docker run --name $(IMAGE_NAME)-tmp $(IMAGE_NAME)
	mkdir -p tmp
	docker wait $(IMAGE_NAME)-tmp
	docker cp $(IMAGE_NAME)-tmp:/tmp/$(TARGZ_FILE) tmp
	docker rm $(IMAGE_NAME)-tmp
	mkdir $@
	tar -xzf tmp/$(TARGZ_FILE) -C $@
	rm -rf tmp Dockerfile
	docker images | grep -q $(IMAGE_NAME) && docker rmi $(IMAGE_NAME) || true

clean:
	rm -rf *.build.bak *.build tmp Dockerfile
	docker images | grep -q $(IMAGE_NAME)-ce6 && docker rmi $(IMAGE_NAME)-ce6 || true
	docker images | grep -q $(IMAGE_NAME)-ce7 && docker rmi $(IMAGE_NAME)-ce7 || true
