#
# Copyright (C) 2019-2021 vdaas.org vald team <vald@vdaas.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ORG                             ?= vdaas
NAME                            = vald
GOPKG                           = github.com/$(ORG)/$(NAME)
GOPRIVATE                       = $(GOPKG),$(GOPKG)/apis
DATETIME                        = $(eval DATETIME := $(shell date -u +%Y/%m/%d_%H:%M:%S%z))$(DATETIME)
TAG                            ?= latest
CRORG                          ?= $(ORG)
# CRORG                           = ghcr.io/vdaas/vald
AGENT_IMAGE                     = $(NAME)-agent-ngt
AGENT_SIDECAR_IMAGE             = $(NAME)-agent-sidecar
CI_CONTAINER_IMAGE              = $(NAME)-ci-container
DEV_CONTAINER_IMAGE             = $(NAME)-dev-container
DISCOVERER_IMAGE                = $(NAME)-discoverer-k8s
FILTER_GATEWAY_IMAGE            = $(NAME)-filter-gateway
FILTER_INGRESS_TF_IMAGE         = $(NAME)-filter-ingress-tensorflow
HELM_OPERATOR_IMAGE             = $(NAME)-helm-operator
LB_GATEWAY_IMAGE                = $(NAME)-lb-gateway
LOADTEST_IMAGE                  = $(NAME)-loadtest
MANAGER_INDEX_IMAGE             = $(NAME)-manager-index
MAINTAINER                      = "$(ORG).org $(NAME) team <$(NAME)@$(ORG).org>"

VERSION ?= $(eval VERSION := $(shell cat versions/VALD_VERSION))$(VERSION)

NGT_VERSION := $(eval NGT_VERSION := $(shell cat versions/NGT_VERSION))$(NGT_VERSION)
NGT_REPO = github.com/yahoojapan/NGT

GOPROXY=direct
GO_VERSION := $(eval GO_VERSION := $(shell cat versions/GO_VERSION))$(GO_VERSION)
GOARCH := $(eval GOARCH := $(shell go env GOARCH))$(GOARCH)
GOBIN := $(eval GOBIN := $(shell go env GOBIN))$(GOBIN)
GOCACHE := $(eval GOCACHE := $(shell go env GOCACHE))$(GOCACHE)
GOOS := $(eval GOOS := $(shell go env GOOS))$(GOOS)
GOPATH := $(eval GOPATH := $(shell go env GOPATH))$(GOPATH)

TEMP_DIR := $(eval TEMP_DIR := $(shell mktemp -d))$(TEMP_DIR)

TENSORFLOW_C_VERSION := $(eval TENSORFLOW_C_VERSION := $(shell cat versions/TENSORFLOW_C_VERSION))$(TENSORFLOW_C_VERSION)

OPERATOR_SDK_VERSION := $(eval OPERATOR_SDK_VERSION := $(shell cat versions/OPERATOR_SDK_VERSION))$(OPERATOR_SDK_VERSION)

KIND_VERSION         ?= v0.11.1
HELM_VERSION         ?= v3.7.1
HELM_DOCS_VERSION    ?= 1.5.0
YQ_VERSION           ?= v4.13.5
VALDCLI_VERSION      ?= v1.3.0
TELEPRESENCE_VERSION ?= 2.4.5
KUBELINTER_VERSION   ?= 0.2.5
GOLANGCILINT_VERSION ?= v1.42.1
REVIEWDOG_VERSION    ?= v0.13.0
PROTOBUF_VERSION     ?= 3.19.0

SWAP_DEPLOYMENT_TYPE ?= deployment
SWAP_IMAGE           ?= ""
SWAP_TAG             ?= latest

BINDIR ?= /usr/local/bin

UNAME := $(eval UNAME := $(shell uname))$(UNAME)
PWD := $(eval PWD := $(shell pwd))$(PWD)

ifeq ($(UNAME),Linux)
CPU_INFO_FLAGS := $(eval CPU_INFO_FLAGS := $(shell cat /proc/cpuinfo | grep flags | cut -d " " -f 2- | head -1))$(CPU_INFO_FLAGS)
else
CPU_INFO_FLAGS := ""
endif

GIT_COMMIT := $(eval GIT_COMMIT := $(shell git rev-list -1 HEAD))$(GIT_COMMIT)

MAKELISTS := Makefile $(shell find Makefile.d -type f -regex ".*\.mk")

ROOTDIR = $(eval ROOTDIR := $(shell git rev-parse --show-toplevel))$(ROOTDIR)
PROTODIRS := $(eval PROTODIRS := $(shell find apis/proto -type d | sed -e "s%apis/proto/%%g" | grep -v "apis/proto"))$(PROTODIRS)
BENCH_DATASET_BASE_DIR = hack/benchmark/assets
BENCH_DATASET_MD5_DIR_NAME = checksum
BENCH_DATASET_HDF5_DIR_NAME = dataset
BENCH_DATASET_MD5_DIR = $(BENCH_DATASET_BASE_DIR)/$(BENCH_DATASET_MD5_DIR_NAME)
BENCH_DATASET_HDF5_DIR = $(BENCH_DATASET_BASE_DIR)/$(BENCH_DATASET_HDF5_DIR_NAME)

PROTOS := $(eval PROTOS := $(shell find apis/proto -type f -regex ".*\.proto"))$(PROTOS)
PROTOS_V1 := $(eval PROTOS_V1 := $(filter apis/proto/v1/%.proto,$(PROTOS)))$(PROTOS_V1)
PBGOS = $(PROTOS:apis/proto/%.proto=apis/grpc/%.pb.go)
SWAGGERS = $(PROTOS:apis/proto/%.proto=apis/swagger/%.swagger.json)
PBDOCS = apis/docs/v1/docs.md

ifeq ($(GOARCH),amd64)
CFLAGS ?= -mno-avx512f -mno-avx512dq -mno-avx512cd -mno-avx512bw -mno-avx512vl
CXXFLAGS ?= $(CFLAGS)
EXTLDFLAGS ?= -m64
else ifeq ($(GOARCH),arm64)
CFLAGS ?=
CXXFLAGS ?= $(CFLAGS)
EXTLDFLAGS ?= -march=armv8-a
else
CFLAGS ?=
CXXFLAGS ?= $(CFLAGS)
EXTLDFLAGS ?=
endif

BENCH_DATASET_MD5S := $(eval BENCH_DATASET_MD5S := $(shell find $(BENCH_DATASET_MD5_DIR) -type f -regex ".*\.md5"))$(BENCH_DATASET_MD5S)
BENCH_DATASETS = $(BENCH_DATASET_MD5S:$(BENCH_DATASET_MD5_DIR)/%.md5=$(BENCH_DATASET_HDF5_DIR)/%.hdf5)

BENCH_LARGE_DATASET_BASE_DIR = $(BENCH_DATASET_BASE_DIR)/large/dataset

SIFT1B_ROOT_DIR = $(BENCH_LARGE_DATASET_BASE_DIR)/sift1b

SIFT1B_BASE_FILE = $(SIFT1B_ROOT_DIR)/bigann_base.bvecs
SIFT1B_LEARN_FILE = $(SIFT1B_ROOT_DIR)/bigann_learn.bvecs
SIFT1B_QUERY_FILE = $(SIFT1B_ROOT_DIR)/bigann_query.bvecs
SIFT1B_GROUNDTRUTH_DIR = $(SIFT1B_ROOT_DIR)/gnd

SIFT1B_BASE_URL = ftp://ftp.irisa.fr/local/texmex/corpus/

DEEP1B_ROOT_DIR = $(BENCH_LARGE_DATASET_BASE_DIR)/deep1b

DEEP1B_BASE_FILE = $(DEEP1B_ROOT_DIR)/deep1B_base.fvecs
DEEP1B_LEARN_FILE = $(DEEP1B_ROOT_DIR)/deep1B_learn.fvecs
DEEP1B_QUERY_FILE = $(DEEP1B_ROOT_DIR)/deep1B_queries.fvecs
DEEP1B_GROUNDTRUTH_FILE = $(DEEP1B_ROOT_DIR)/deep1B_groundtruth.ivecs

DEEP1B_BASE_DIR = $(DEEP1B_ROOT_DIR)/base
DEEP1B_BASE_CHUNK_FILES = $(shell printf "$(DEEP1B_BASE_DIR)/base_%02d\n" {0..36})
DEEP1B_LEARN_DIR = $(DEEP1B_ROOT_DIR)/learn
DEEP1B_LEARN_CHUNK_FILES = $(shell printf "$(DEEP1B_LEARN_DIR)/learn_%02d\n" {0..13})

DEEP1B_API_URL = https://cloud-api.yandex.net/v1/disk/public/resources/download?public_key=https://yadi.sk/d/11eDCm7Dsn9GA&path=

DATASET_ARGS ?= identity-128
ADDRESS_ARGS ?= ""

HOST      ?= localhost
PORT      ?= 80
NUMBER    ?= 10
DIMENSION ?= 6
NUMPANES  ?= 4
MEAN      ?= 0.0
STDDEV    ?= 1.0

BODY = ""

PROTO_PATHS = \
	$(PWD) \
	$(GOPATH)/src \
	$(GOPATH)/src/$(GOPKG) \
	$(GOPATH)/src/$(GOPKG)/apis/proto/v1 \
	$(GOPATH)/src/github.com/envoyproxy/protoc-gen-validate \
	$(GOPATH)/src/github.com/googleapis/googleapis \
	$(GOPATH)/src/github.com/planetscale/vtprotobuf \
	$(GOPATH)/src/github.com/protocolbuffers/protobuf \
	$(GOPATH)/src/google.golang.org/genproto

# [Warning]
# The below packages have no original implementation.
# You should not add any features.
# - internal/copress/gob
# - internal/compress/gzip
# - internal/compress/lz4
# - internal/compress/zstd
# - internal/db/storage/blob/s3/sdk/s3
# - internal/db/rdb/mysql/dbr
# - internal/test/comparator
# - internal/test/mock
GO_SOURCES = $(eval GO_SOURCES := $(shell find \
		./cmd \
		./hack \
		./internal \
		./pkg \
		-not -path './cmd/cli/*' \
		-not -path './internal/core/algorithm/ngt/*' \
		-not -path './internal/compress/gob/*' \
		-not -path './internal/compress/gzip/*' \
		-not -path './internal/compress/lz4/*' \
		-not -path './internal/compress/zstd/*' \
		-not -path './internal/db/storage/blob/s3/sdk/s3/*' \
		-not -path './internal/db/rdb/mysql/dbr/*' \
		-not -path './internal/test/comparator/*' \
		-not -path './internal/test/mock/*' \
		-not -path './hack/benchmark/internal/client/ngtd/*' \
		-not -path './hack/benchmark/internal/starter/agent/*' \
		-not -path './hack/benchmark/internal/starter/external/*' \
		-not -path './hack/benchmark/internal/starter/gateway/*' \
		-not -path './hack/gorules/*' \
		-not -path './hack/license/*' \
		-not -path './hack/swagger/*' \
		-not -path './hack/tools/*' \
		-not -path './tests/*' \
		-type f \
		-name '*.go' \
		-not -regex '.*options?\.go' \
		-not -name '*_test.go' \
		-not -name '*_mock.go' \
		-not -name 'doc.go'))$(GO_SOURCES)
GO_OPTION_SOURCES = $(eval GO_OPTION_SOURCES := $(shell find \
		./cmd \
		./hack \
		./internal \
		./pkg \
		-not -path './cmd/cli/*' \
		-not -path './internal/core/algorithm/ngt/*' \
		-not -path './internal/compress/gob/*' \
		-not -path './internal/compress/gzip/*' \
		-not -path './internal/compress/lz4/*' \
		-not -path './internal/compress/zstd/*' \
		-not -path './internal/db/storage/blob/s3/sdk/s3/*' \
		-not -path './internal/db/rdb/mysql/dbr/*' \
		-not -path './internal/test/comparator/*' \
		-not -path './internal/test/mock/*' \
		-not -path './hack/benchmark/internal/client/ngtd/*' \
		-not -path './hack/benchmark/internal/starter/agent/*' \
		-not -path './hack/benchmark/internal/starter/external/*' \
		-not -path './hack/benchmark/internal/starter/gateway/*' \
		-not -path './hack/gorules/*' \
		-not -path './hack/license/*' \
		-not -path './hack/swagger/*' \
		-not -path './hack/tools/*' \
		-not -path './tests/*' \
		-type f \
		-regex '.*options?\.go' \
		-not -name '*_test.go' \
		-not -name '*_mock.go' \
		-not -name 'doc.go'))$(GO_OPTION_SOURCES)

GO_SOURCES_INTERNAL = $(eval GO_SOURCES_INTERNAL := $(shell find \
		./internal \
		-type f \
		-name '*.go' \
		-not -name '*_test.go' \
		-not -name '*_mock.go' \
		-not -name 'doc.go'))$(GO_SOURCES_INTERNAL)

GO_TEST_SOURCES = $(GO_SOURCES:%.go=%_test.go)
GO_OPTION_TEST_SOURCES = $(GO_OPTION_SOURCES:%.go=%_test.go)

DOCKER           ?= docker
DOCKER_OPTS      ?=

DISTROLESS_IMAGE      ?= gcr.io/distroless/static
DISTROLESS_IMAGE_TAG  ?= nonroot
UPX_OPTIONS           ?= -9
GOLINES_MAX_WIDTH     ?= 200

K8S_EXTERNAL_SCYLLA_MANIFEST        ?= k8s/external/scylla/scyllacluster.yaml
K8S_SLEEP_DURATION_FOR_WAIT_COMMAND ?= 5

K8S_KUBECTL_VERSION ?= $(eval K8S_KUBECTL_VERSION := $(shell kubectl version --short))$(K8S_KUBECTL_VERSION)
K8S_SERVER_VERSION ?= $(eval K8S_SERVER_VERSION := $(shell echo "$(K8S_KUBECTL_VERSION)" | sed -e "s/.*Server.*\(v[0-9]\.[0-9]*\)\..*/\1/g"))$(K8S_SERVER_VERSION)

COMMA := ,
SHELL = bash

E2E_BIND_HOST                      ?= 127.0.0.1
E2E_BIND_PORT                      ?= 8082
E2E_TIMEOUT                        ?= 30m
E2E_DATASET_NAME                   ?= fashion-mnist-784-euclidean
E2E_INSERT_COUNT                   ?= 10000
E2E_SEARCH_COUNT                   ?= 1000
E2E_SEARCH_BY_ID_COUNT             ?= 100
E2E_GET_OBJECT_COUNT               ?= 10
E2E_UPDATE_COUNT                   ?= 10
E2E_UPSERT_COUNT                   ?= 10
E2E_REMOVE_COUNT                   ?= 3
E2E_WAIT_FOR_CREATE_INDEX_DURATION ?= 8m
E2E_TARGET_NAME                    ?= vald-lb-gateway
E2E_TARGET_POD_NAME                ?= $(eval E2E_TARGET_POD_NAME := $(shell kubectl get pods --selector=app=$(E2E_TARGET_NAME) | tail -1 | cut -f1 -d " "))$(E2E_TARGET_POD_NAME)
E2E_TARGET_NAMESPACE               ?= default
E2E_TARGET_PORT                    ?= 8081

include Makefile.d/functions.mk

.PHONY: maintainer
## print maintainer
maintainer:
	@echo $(MAINTAINER)

.PHONY: help
## print all available commands
help:
	@awk '/^[a-zA-Z_0-9%:\\\/-]+:/ { \
	  helpMessage = match(lastLine, /^## (.*)/); \
	  if (helpMessage) { \
	    helpCommand = $$1; \
	    helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
      gsub("\\\\", "", helpCommand); \
      gsub(":+$$", "", helpCommand); \
	    printf "  \x1b[32;01m%-38s\x1b[0m %s\n", helpCommand, helpMessage; \
	  } \
	} \
	{ lastLine = $$0 }' $(MAKELISTS) | sort -u
	@printf "\n"

.PHONY: all
## execute clean and deps
all: clean deps

.PHONY: clean
## clean
clean:
	rm -rf vendor
	go clean -cache -modcache -testcache -i -r
	mv ./apis/grpc/v1/vald/vald.go $(TEMP_DIR)/vald.go
	mv ./apis/grpc/v1/payload/interface.go $(TEMP_DIR)/interface.go
	rm -rf \
		/go/pkg \
		./*.log \
		./*.svg \
		./apis/docs \
		./apis/swagger \
		./apis/grpc \
		./bench \
		./pprof \
		./libs \
		$(GOCACHE) \
		./go.sum \
		./go.mod
	mkdir -p ./apis/grpc/v1/vald
	mv $(TEMP_DIR)/vald.go ./apis/grpc/v1/vald/vald.go
	mkdir -p ./apis/grpc/v1/payload
	mv $(TEMP_DIR)/interface.go ./apis/grpc/v1/payload/interface.go
	cp ./hack/go.mod.default ./go.mod

.PHONY: license
## add license to files
license:
	GOPRIVATE=$(GOPRIVATE) \
	MAINTAINER=$(MAINTAINER) \
	go run -mod=readonly hack/license/gen/main.go ./

.PHONY: init
## initialize development environment
init: \
	git/config/init \
	git/hooks/init \
	deps \
	ngt/install \
	tensorflow/install

.PHONY: tools/install
## install development tools
tools/install: \
	helm/install \
	kind/install \
	valdcli/install \
	telepresence/install

.PHONY: update
## update deps, license, and run golines, gofumpt, goimports
update: \
	clean \
	proto/all \
	deps \
	format \
	go/deps

.PHONY: format
## format go codes
format: \
	license \
	format/go \
	format/yaml

.PHONY: format/go
## run golines, gofumpt, goimports for all go files
format/go:
	find ./ -type d -name .git -prune -o -type f -regex '.*[^\.pb]\.go' -print | xargs $(GOPATH)/bin/golines -w -m $(GOLINES_MAX_WIDTH)
	find ./ -type d -name .git -prune -o -type f -regex '.*[^\.pb]\.go' -print | xargs $(GOPATH)/bin/gofumpt -w
	find ./ -type d -name .git -prune -o -type f -regex '.*\.go' -print | xargs $(GOPATH)/bin/goimports -w

.PHONY: format/yaml
format/yaml:
	prettier --write \
	    ".github/**/*.yaml" \
	    ".github/**/*.yml" \
	    "cmd/**/*.yaml" \
	    "k8s/**/*.yaml"

.PHONY: deps
## resolve dependencies
deps: \
	proto/deps \
	deps/install

.PHONY: deps/install
## install dependencies
deps/install: \
	golines/install \
	gofumpt/install \
	goimports/install \
	prettier/install \
	go/deps

.PHONY: go/deps
## install Go package dependencies
go/deps:
	go clean -cache -modcache -testcache -i -r
	rm -rf \
		/go/pkg \
		$(GOCACHE) \
		./go.sum \
		./go.mod
	cp ./hack/go.mod.default ./go.mod
	GOPRIVATE=$(GOPRIVATE) go mod tidy
	go get -u all 2>/dev/null || true


.PHONY: goimports/install
goimports/install:
	go install golang.org/x/tools/cmd/goimports@latest

.PHONY: gofumpt/install
gofumpt/install:
	go install mvdan.cc/gofumpt@latest

.PHONY: golines/install
golines/install:
	go install github.com/segmentio/golines@latest

.PHONY: prettier/install
prettier/install:
	type prettier || npm install -g prettier

.PHONY: version
## print vald version
version: \
	version/vald

.PHONY: version/vald
## print vald version
version/vald:
	@echo $(VERSION)

.PHONY: version/go
## print go version
version/go:
	@echo $(GO_VERSION)

.PHONY: version/ngt
## print NGT version
version/ngt:
	@echo $(NGT_VERSION)

.PHONY: version/kind
version/kind:
	@echo $(KIND_VERSION)

.PHONY: version/helm
version/helm:
	@echo $(HELM_VERSION)

.PHONY: version/valdcli
version/valdcli:
	@echo $(VALDCLI_VERSION)

.PHONY: version/telepresence
version/telepresence:
	@echo $(TELEPRESENCE_VERSION)

.PHONY: ngt/install
## install NGT
ngt/install: /usr/local/include/NGT/Capi.h
/usr/local/include/NGT/Capi.h:
	curl -LO https://github.com/yahoojapan/NGT/archive/v$(NGT_VERSION).tar.gz
	tar zxf v$(NGT_VERSION).tar.gz -C $(TEMP_DIR)/
	cd $(TEMP_DIR)/NGT-$(NGT_VERSION) && \
		cmake -DCMAKE_C_FLAGS="$(CFLAGS)" -DCMAKE_CXX_FLAGS="$(CXXFLAGS)" .
	make -j -C $(TEMP_DIR)/NGT-$(NGT_VERSION)
	make install -C $(TEMP_DIR)/NGT-$(NGT_VERSION)
	rm -rf v$(NGT_VERSION).tar.gz
	rm -rf $(TEMP_DIR)/NGT-$(NGT_VERSION)
	ldconfig

.PHONY: tensorflow/install
## install TensorFlow for C
tensorflow/install: /usr/local/lib/libtensorflow.so
ifeq ($(UNAME),Darwin)
/usr/local/lib/libtensorflow.so:
	brew install libtensorflow@1
else
/usr/local/lib/libtensorflow.so:
	curl -LO https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-$(TENSORFLOW_C_VERSION).tar.gz
	tar -C /usr/local -xzf libtensorflow-cpu-linux-x86_64-$(TENSORFLOW_C_VERSION).tar.gz
	rm -f libtensorflow-cpu-linux-x86_64-$(TENSORFLOW_C_VERSION).tar.gz
	ldconfig
endif

.PHONY: lint
## run lints
lint: vet
	$(call go-lint)

.PHONY: vet
## run go vet
vet:
	$(call go-vet)

.PHONY: changelog/update
## update changelog
changelog/update:
	echo "# CHANGELOG" > $(TEMP_DIR)/CHANGELOG.md
	echo "" >> $(TEMP_DIR)/CHANGELOG.md
	$(MAKE) -s changelog/next/print >> $(TEMP_DIR)/CHANGELOG.md
	echo "" >> $(TEMP_DIR)/CHANGELOG.md
	tail -n +2 CHANGELOG.md >> $(TEMP_DIR)/CHANGELOG.md
	mv -f $(TEMP_DIR)/CHANGELOG.md CHANGELOG.md

.PHONY: changelog/next/print
## print next changelog entry
changelog/next/print:
	@cat hack/CHANGELOG.template.md | \
	    sed -e 's/{{ version }}/$(VERSION)/g'
	@echo "$$BODY"

include Makefile.d/bench.mk
include Makefile.d/build.mk
include Makefile.d/docker.mk
include Makefile.d/git.mk
include Makefile.d/helm.mk
include Makefile.d/proto.mk
include Makefile.d/k3d.mk
include Makefile.d/k8s.mk
include Makefile.d/kind.mk
include Makefile.d/client.mk
include Makefile.d/ml.mk
include Makefile.d/test.mk
include Makefile.d/tools.mk
include Makefile.d/e2e.mk
