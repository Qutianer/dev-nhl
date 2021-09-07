RELEASE_DIRS=control infrastructure
RELEASE_FILES=$(RELEASE_DIRS:=.tar.gz)

.ONESHELL:

release: $(RELEASE_FILES)
	gh release create `git tag` -t "`git tag`" --notes "" $(RELEASE_FILES)
$(RELEASE_FILES): 
	cd $(@:.tar.gz=)
	tar -caf ../$@ -X .gitignore --exclude-vcs --exclude-vcs-ignores *
	cd ..

clean:
	gh release delete `git tag` -y
	rm -rf $(RELEASE_FILES)
