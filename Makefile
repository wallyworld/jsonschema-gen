PROJECT := github.com/juju/jsonschema-gen

.PHONY: check-go check

check: check-go
	go test $(PROJECT)/...

check-go:
	$(eval GOFMT := $(strip $(shell gofmt -l .| sed -e "s/^/ /g")))
	@(if [ x$(GOFMT) != x"" ]; then \
		echo go fmt is sad: $(GOFMT); \
		exit 1; \
	fi )
	@(go vet -all -composites=false -copylocks=false reflect.go)

# update Gopkg.lock (if needed), but do not update `vendor/`.
rebuild-dependencies:
	dep ensure -v -no-vendor $(dep-update)

$(GOPATH)/bin/dep:
	go get -u github.com/golang/dep/cmd/dep

# populate vendor/ from Gopkg.lock without updating it first (lock file is the single source of truth for machine).
dep: $(GOPATH)/bin/dep
	$(GOPATH)/bin/dep ensure -vendor-only $(verbose)
