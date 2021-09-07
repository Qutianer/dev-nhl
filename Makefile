RELEASE_DIRS=control infrastructure
RELEASE_FILES=$(RELEASE_DIRS:=.tar.gz)
TAG=$(shell git tag | tail -n 1)

.ONESHELL:

release: $(RELEASE_FILES)
	gh release create $(TAG) -t "$(TAG)" --notes "" $(RELEASE_FILES)
$(RELEASE_FILES): 
	cd $(@:.tar.gz=)
	tar -caf ../$@ -X .gitignore --exclude-vcs --exclude-vcs-ignores *
	cd ..

clean:
	gh release delete $(TAG) -y
	rm -rf $(RELEASE_FILES)
