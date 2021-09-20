.PHONY: dist

BUILD_OS ?= linux darwin
BUILD_ARCH ?= amd64 386 arm64

dist:
	mkdir -p dist
	@for os in $(BUILD_OS) ; do \
		for arch in $(BUILD_ARCH); do \
			echo "Buidling" $$arch $$os; \
			binpath="dist/pcstat-$$os-$$arch/"; \
			docker run --rm -it -w /app -v $(PWD):/app -e GOOS=$$os -e GOARCH=$$arch golang:1.17-alpine go build -o $$binpath ./pcstat; \
			cp LICENSE $$binpath/; \
			tar -czf dist/pcstat-$$os-$$arch.tar.gz -C $$binpath .; \
			rm -r $$binpath; \
		done \
	done
	(cd dist; shasum -a 256 *.tar.gz > sha256sums.txt)