//
// Copyright (C) 2019 kpango (Yusuke Kato)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// Package servers provides implementation of Go API for managing server flow
package servers

import (
	"context"
	"reflect"
	"testing"
	"time"

	"github.com/vdaas/vald/internal/errgroup"
	"github.com/vdaas/vald/internal/servers/server"
)

func TestNew(t *testing.T) {
	type args struct {
		opts []Option
	}
	tests := []struct {
		name string
		args args
		want Listener
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := New(tt.args.opts...); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("New() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_listener_ListenAndServe(t *testing.T) {
	type fields struct {
		servers map[string]server.Server
		eg      errgroup.Group
		sus     []string
		sds     []string
		cancel  context.CancelFunc
		ech     chan error
		sddur   time.Duration
	}
	type args struct {
		ctx context.Context
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   <-chan error
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			l := &listener{
				servers: tt.fields.servers,
				eg:      tt.fields.eg,
				sus:     tt.fields.sus,
				sds:     tt.fields.sds,
				cancel:  tt.fields.cancel,
				ech:     tt.fields.ech,
				sddur:   tt.fields.sddur,
			}
			if got := l.ListenAndServe(tt.args.ctx); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("listener.ListenAndServe() = %v, want %v", got, tt.want)
			}
		})
	}
}
