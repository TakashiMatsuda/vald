module github.com/vdaas/vald

go 1.17

replace (
	cloud.google.com/go => cloud.google.com/go v0.97.0
	cloud.google.com/go/monitoring => cloud.google.com/go/monitoring v1.1.1-0.20211027173432-dd9e982680aa
	cloud.google.com/go/profiler => cloud.google.com/go/profiler v0.1.2-0.20211027173432-dd9e982680aa
	cloud.google.com/go/storage => cloud.google.com/go/storage v1.18.3-0.20211027173432-dd9e982680aa
	cloud.google.com/go/trace => cloud.google.com/go/trace v1.0.1-0.20211027173432-dd9e982680aa
	github.com/Azure/go-autorest => github.com/Azure/go-autorest v14.2.1-0.20210910151046-492f94bc3a56+incompatible
	github.com/Azure/go-autorest/autorest => github.com/Azure/go-autorest/autorest v0.11.21
	github.com/Azure/go-autorest/autorest/adal => github.com/Azure/go-autorest/autorest/adal v0.9.17-0.20210910151046-492f94bc3a56
	github.com/aws/aws-sdk-go => github.com/aws/aws-sdk-go v1.41.12
	github.com/chzyer/logex => github.com/chzyer/logex v1.1.11-0.20170329064859-445be9e134b2
	github.com/coreos/etcd => go.etcd.io/etcd v3.3.27+incompatible
	github.com/docker/docker => github.com/moby/moby v20.10.10+incompatible
	github.com/envoyproxy/protoc-gen-validate => github.com/envoyproxy/protoc-gen-validate v0.6.2
	github.com/go-sql-driver/mysql => github.com/go-sql-driver/mysql v1.6.0
	github.com/gocql/gocql => github.com/gocql/gocql v0.0.0-20211015133455-b225f9b53fa1
	github.com/gogo/protobuf => github.com/gogo/protobuf v1.3.2
	github.com/golang/protobuf => github.com/golang/protobuf v1.5.2
	github.com/google/gnostic => github.com/google/gnostic v0.5.6
	github.com/google/go-cmp => github.com/google/go-cmp v0.5.6
	github.com/google/pprof => github.com/google/pprof v0.0.0-20211008130755-947d60d73cc0
	github.com/gophercloud/gophercloud => github.com/gophercloud/gophercloud v0.22.0
	github.com/gorilla/websocket => github.com/gorilla/websocket v1.4.2
	github.com/hailocab/go-hostpool => github.com/kpango/go-hostpool v0.0.0-20210303030322-aab80263dcd0
	github.com/klauspost/compress => github.com/klauspost/compress v1.13.7-0.20211011124647-94ad1f0bf03c
	github.com/kpango/glg => github.com/kpango/glg v1.6.4
	github.com/tensorflow/tensorflow => github.com/tensorflow/tensorflow v2.1.2+incompatible
	github.com/zeebo/xxh3 => github.com/zeebo/xxh3 v0.13.0
	go.uber.org/goleak => go.uber.org/goleak v1.1.12
	go.uber.org/multierr => go.uber.org/multierr v1.7.0
	go.uber.org/zap => go.uber.org/zap v1.19.1
	golang.org/x/crypto => golang.org/x/crypto v0.0.0-20210921155107-089bfa567519
	golang.org/x/exp => golang.org/x/exp v0.0.0-20211025140241-8418b01e8c3b
	golang.org/x/image => golang.org/x/image v0.0.0-20210628002857-a66eb6448b8d
	golang.org/x/lint => golang.org/x/lint v0.0.0-20210508222113-6edffad5e616
	golang.org/x/mobile => golang.org/x/mobile v0.0.0-20211027134744-eb3c0abee20a
	golang.org/x/mod => golang.org/x/mod v0.5.1
	golang.org/x/net => golang.org/x/net v0.0.0-20211020060615-d418f374d309
	golang.org/x/oauth2 => golang.org/x/oauth2 v0.0.0-20211005180243-6b3c2da341f1
	golang.org/x/sync => golang.org/x/sync v0.0.0-20210220032951-036812b2e83c
	golang.org/x/sys => golang.org/x/sys v0.0.0-20211025201205-69cdffdb9359
	golang.org/x/term => golang.org/x/term v0.0.0-20210927222741-03fcf44c2211
	golang.org/x/text => golang.org/x/text v0.3.7
	golang.org/x/time => golang.org/x/time v0.0.0-20210723032227-1f47c861a9ac
	golang.org/x/tools => golang.org/x/tools v0.1.7
	golang.org/x/xerrors => golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1
	google.golang.org/api => google.golang.org/api v0.59.0
	google.golang.org/appengine => google.golang.org/appengine v1.6.7
	google.golang.org/grpc => google.golang.org/grpc v1.41.0
	google.golang.org/grpc/cmd/protoc-gen-go-grpc => google.golang.org/grpc/cmd/protoc-gen-go-grpc v1.1.0
	google.golang.org/protobuf => google.golang.org/protobuf v1.27.1
	gopkg.in/check.v1 => gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c
	k8s.io/api => k8s.io/api v0.22.2
	k8s.io/apiextensions-apiserver => k8s.io/apiextensions-apiserver v0.22.2
	k8s.io/apimachinery => k8s.io/apimachinery v0.22.2
	k8s.io/apiserver => k8s.io/apiserver v0.22.2
	k8s.io/cli-runtime => k8s.io/cli-runtime v0.22.2
	k8s.io/client-go => k8s.io/client-go v0.22.2
	k8s.io/code-generator => k8s.io/code-generator v0.22.2
	k8s.io/component-base => k8s.io/component-base v0.22.2
	k8s.io/gengo => k8s.io/gengo v0.0.0-20210915205010-39e73c8a59cd
	k8s.io/klog/v2 => k8s.io/klog/v2 v2.10.0
	k8s.io/kube-openapi => k8s.io/kube-openapi v0.0.0-20211027214312-a3aade5e6f4b
	k8s.io/metrics => k8s.io/metrics v0.22.2
	k8s.io/utils => k8s.io/utils v0.0.0-20210930125809-cb0fa318a74b
	sigs.k8s.io/apiserver-network-proxy/konnectivity-client => sigs.k8s.io/apiserver-network-proxy/konnectivity-client v0.0.24
	sigs.k8s.io/controller-runtime => sigs.k8s.io/controller-runtime v0.10.2
	sigs.k8s.io/kustomize/api => sigs.k8s.io/kustomize/api v0.10.0
	sigs.k8s.io/kustomize/kyaml => sigs.k8s.io/kustomize/kyaml v0.12.0
	sigs.k8s.io/structured-merge-diff/v4 => sigs.k8s.io/structured-merge-diff/v4 v4.1.2
	sigs.k8s.io/yaml => sigs.k8s.io/yaml v1.3.0
)

require (
	cloud.google.com/go/profiler v0.0.0-00010101000000-000000000000
	cloud.google.com/go/storage v1.16.1
	code.cloudfoundry.org/bytefmt v0.0.0-20211005130812-5bb3c17173e5
	contrib.go.opencensus.io/exporter/jaeger v0.2.1
	contrib.go.opencensus.io/exporter/prometheus v0.4.0
	contrib.go.opencensus.io/exporter/stackdriver v0.13.8
	github.com/aws/aws-sdk-go v1.40.34
	github.com/envoyproxy/protoc-gen-validate v0.1.0
	github.com/fsnotify/fsnotify v1.5.1
	github.com/go-redis/redis/v8 v8.11.4
	github.com/go-sql-driver/mysql v1.6.0
	github.com/gocql/gocql v0.0.0-20200131111108-92af2e088537
	github.com/gocraft/dbr/v2 v2.7.2
	github.com/google/go-cmp v0.5.6
	github.com/gorilla/mux v1.8.0
	github.com/hashicorp/go-version v1.3.0
	github.com/json-iterator/go v1.1.12
	github.com/klauspost/compress v1.13.5
	github.com/kpango/fastime v1.0.17
	github.com/kpango/fuid v0.0.0-20210407064122-2990e29e1ea5
	github.com/kpango/gache v1.2.6
	github.com/kpango/glg v1.6.2
	github.com/leanovate/gopter v0.2.9
	github.com/lucasb-eyer/go-colorful v1.2.0
	github.com/pierrec/lz4/v3 v3.3.3
	github.com/quasilyte/go-ruleguard v0.3.13
	github.com/quasilyte/go-ruleguard/dsl v0.3.10
	github.com/scylladb/gocqlx v1.5.0
	github.com/tensorflow/tensorflow v0.0.0-00010101000000-000000000000
	github.com/zeebo/xxh3 v0.12.0
	go.opencensus.io v0.23.0
	go.uber.org/automaxprocs v1.4.0
	go.uber.org/goleak v1.1.11-0.20210813005559-691160354723
	go.uber.org/zap v1.19.0
	gocloud.dev v0.24.0
	golang.org/x/net v0.0.0-20210825183410-e898025ed96a
	golang.org/x/oauth2 v0.0.0-20211005180243-6b3c2da341f1
	golang.org/x/sync v0.0.0-20210220032951-036812b2e83c
	golang.org/x/sys v0.0.0-20211007075335-d3039528d8ac
	golang.org/x/tools v0.1.8-0.20211022200916-316ba0b74098
	gonum.org/v1/hdf5 v0.0.0-20210714002203-8c5d23bc6946
	gonum.org/v1/plot v0.10.0
	google.golang.org/api v0.59.0
	google.golang.org/genproto v0.0.0-20211027162914-98a5263abeca
	google.golang.org/grpc v1.40.0
	google.golang.org/protobuf v1.27.1
	gopkg.in/yaml.v2 v2.4.0
	inet.af/netaddr v0.0.0-20211027220019-c74959edd3b6
	k8s.io/api v0.22.2
	k8s.io/apimachinery v0.22.2
	k8s.io/cli-runtime v0.0.0-00010101000000-000000000000
	k8s.io/client-go v0.22.2
	k8s.io/metrics v0.0.0-00010101000000-000000000000
	sigs.k8s.io/controller-runtime v0.0.0-00010101000000-000000000000
)

require (
	cloud.google.com/go v0.97.0 // indirect
	cloud.google.com/go/monitoring v0.1.0 // indirect
	cloud.google.com/go/trace v0.1.0 // indirect
	github.com/PuerkitoBio/purell v1.1.1 // indirect
	github.com/PuerkitoBio/urlesc v0.0.0-20170810143723-de5bf2ad4578 // indirect
	github.com/ajstarks/svgo v0.0.0-20210923152817-c3b6e2f0c527 // indirect
	github.com/beorn7/perks v1.0.1 // indirect
	github.com/census-instrumentation/opencensus-proto v0.3.0 // indirect
	github.com/cespare/xxhash/v2 v2.1.2 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/dgryski/go-rendezvous v0.0.0-20200823014737-9f7001d12a5f // indirect
	github.com/evanphx/json-patch v4.11.0+incompatible // indirect
	github.com/fogleman/gg v1.3.0 // indirect
	github.com/go-errors/errors v1.0.1 // indirect
	github.com/go-fonts/liberation v0.2.0 // indirect
	github.com/go-kit/log v0.1.0 // indirect
	github.com/go-latex/latex v0.0.0-20210823091927-c0d11ff05a81 // indirect
	github.com/go-logfmt/logfmt v0.5.0 // indirect
	github.com/go-logr/logr v0.4.0 // indirect
	github.com/go-openapi/jsonpointer v0.19.5 // indirect
	github.com/go-openapi/jsonreference v0.19.5 // indirect
	github.com/go-openapi/swag v0.19.14 // indirect
	github.com/go-pdf/fpdf v0.5.0 // indirect
	github.com/go-toolsmith/astequal v1.0.1 // indirect
	github.com/goccy/go-json v0.7.4 // indirect
	github.com/gogo/protobuf v1.3.2 // indirect
	github.com/golang/freetype v0.0.0-20170609003504-e2365dfdc4a0 // indirect
	github.com/golang/groupcache v0.0.0-20210331224755-41bb18bfe9da // indirect
	github.com/golang/protobuf v1.5.2 // indirect
	github.com/golang/snappy v0.0.3 // indirect
	github.com/google/btree v1.0.1 // indirect
	github.com/google/gofuzz v1.1.0 // indirect
	github.com/google/pprof v0.0.0-20211008130755-947d60d73cc0 // indirect
	github.com/google/shlex v0.0.0-20191202100458-e7afc7fbc510 // indirect
	github.com/google/uuid v1.3.0 // indirect
	github.com/google/wire v0.5.0 // indirect
	github.com/googleapis/gax-go/v2 v2.1.1 // indirect
	github.com/googleapis/gnostic v0.5.5 // indirect
	github.com/gregjones/httpcache v0.0.0-20180305231024-9cad4c3443a7 // indirect
	github.com/hailocab/go-hostpool v0.0.0-20160125115350-e80d13ce29ed // indirect
	github.com/imdario/mergo v0.3.12 // indirect
	github.com/inconshreveable/mousetrap v1.0.0 // indirect
	github.com/jmespath/go-jmespath v0.4.0 // indirect
	github.com/josharian/intern v1.0.0 // indirect
	github.com/liggitt/tabwriter v0.0.0-20181228230101-89fcab3d43de // indirect
	github.com/mailru/easyjson v0.7.6 // indirect
	github.com/matttproud/golang_protobuf_extensions v1.0.2-0.20181231171920-c182affec369 // indirect
	github.com/moby/spdystream v0.2.0 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v1.0.2 // indirect
	github.com/monochromegane/go-gitignore v0.0.0-20200626010858-205db1a8cc00 // indirect
	github.com/peterbourgon/diskv v2.0.1+incompatible // indirect
	github.com/pkg/errors v0.9.1 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/prometheus/client_golang v1.11.0 // indirect
	github.com/prometheus/client_model v0.2.0 // indirect
	github.com/prometheus/common v0.28.0 // indirect
	github.com/prometheus/procfs v0.6.0 // indirect
	github.com/prometheus/statsd_exporter v0.21.0 // indirect
	github.com/scylladb/go-reflectx v1.0.1 // indirect
	github.com/spf13/cobra v1.1.3 // indirect
	github.com/spf13/pflag v1.0.5 // indirect
	github.com/stretchr/testify v1.7.0 // indirect
	github.com/uber/jaeger-client-go v2.25.0+incompatible // indirect
	github.com/xlab/treeprint v0.0.0-20181112141820-a009c3971eca // indirect
	go.starlark.net v0.0.0-20200306205701-8dd3e2ee1dd5 // indirect
	go.uber.org/atomic v1.9.0 // indirect
	go.uber.org/multierr v1.7.0 // indirect
	go4.org/intern v0.0.0-20211027215823-ae77deb06f29 // indirect
	go4.org/unsafe/assume-no-moving-gc v0.0.0-20211027215541-db492cf91b37 // indirect
	golang.org/x/image v0.0.0-20210628002857-a66eb6448b8d // indirect
	golang.org/x/mod v0.5.1-0.20210830214625-1b1db11ec8f4 // indirect
	golang.org/x/term v0.0.0-20210220032956-6a3ed077a48d // indirect
	golang.org/x/text v0.3.7 // indirect
	golang.org/x/time v0.0.0-20210723032227-1f47c861a9ac // indirect
	golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1 // indirect
	gomodules.xyz/jsonpatch/v2 v2.2.0 // indirect
	google.golang.org/appengine v1.6.7 // indirect
	gopkg.in/inf.v0 v0.9.1 // indirect
	gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b // indirect
	k8s.io/apiextensions-apiserver v0.22.2 // indirect
	k8s.io/component-base v0.22.2 // indirect
	k8s.io/klog/v2 v2.9.0 // indirect
	k8s.io/kube-openapi v0.0.0-20210421082810-95288971da7e // indirect
	k8s.io/utils v0.0.0-20210819203725-bdf08cb9a70a // indirect
	sigs.k8s.io/kustomize/api v0.8.11 // indirect
	sigs.k8s.io/kustomize/kyaml v0.12.0 // indirect
	sigs.k8s.io/structured-merge-diff/v4 v4.1.2 // indirect
	sigs.k8s.io/yaml v1.2.0 // indirect
)
