//
// Copyright (C) 2019-2021 vdaas.org vald team <vald@vdaas.org>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// Package file provides file I/O functionality
package file

import (
	"io/fs"
	"os"
	"reflect"
	"syscall"
	"testing"

	"github.com/vdaas/vald/internal/errors"
	"github.com/vdaas/vald/internal/test/goleak"
)

func TestOpen(t *testing.T) {
	type args struct {
		path string
		flg  int
		perm os.FileMode
	}
	type want struct {
		want *os.File
		err  error
	}
	type test struct {
		name       string
		args       args
		want       want
		checkFunc  func(want, *os.File, error) error
		beforeFunc func(*testing.T, args)
		afterFunc  func(*testing.T, args, *os.File)
	}

	defaultCheckFunc := func(w want, got *os.File, err error) error {
		if !errors.Is(err, w.err) {
			return errors.Errorf("got_error: \"%#v\",\n\t\t\t\twant: \"%#v\"", err, w.err)
		}

		if w.want == nil {
			if got != nil {
				return errors.New("got is not nil")
			}
		} else {
			if got, want := got.Name(), w.want.Name(); got != want {
				return errors.Errorf("got name = %s, want: %s")
			}
		}
		return nil
	}
	defaultAfterFunc := func(t *testing.T, args args, f *os.File) {
		t.Helper()

		if f != nil {
			if err := f.Close(); err != nil {
				t.Error(err)
			}
		}
	}
	tests := []test{
		{
			name: "returns *os.File when path is `test/data`",
			args: args{
				path: "test/data",
				flg:  os.O_CREATE,
				perm: os.ModePerm,
			},
			checkFunc: func(_ want, got *os.File, gotErr error) error {
				file, err := os.OpenFile("test/data", os.O_CREATE, os.ModePerm)
				if err != nil {
					return err
				}
				return defaultCheckFunc(want{
					want: file,
					err:  nil,
				}, got, gotErr)
			},
			afterFunc: func(t *testing.T, args args, f *os.File) {
				t.Helper()
				defaultAfterFunc(t, args, f)
				if err := os.RemoveAll("test"); err != nil {
					t.Fatal(err)
				}
			},
		},

		{
			name: "returns *os.File when path is `test/test/data`",
			args: args{
				path: "test/test/data",
				flg:  os.O_CREATE,
				perm: os.ModePerm,
			},
			checkFunc: func(_ want, got *os.File, gotErr error) error {
				file, err := os.OpenFile("test/test/data", os.O_CREATE, os.ModePerm)
				if err != nil {
					return err
				}
				return defaultCheckFunc(want{
					want: file,
					err:  nil,
				}, got, gotErr)
			},
			afterFunc: func(t *testing.T, args args, f *os.File) {
				t.Helper()
				defaultAfterFunc(t, args, f)
				if err := os.RemoveAll("test"); err != nil {
					t.Fatal(err)
				}
			},
		},

		{
			name: "returns *os.File when path is `file.go`",
			args: args{
				path: "file.go",
				flg:  os.O_RDONLY,
				perm: os.ModePerm,
			},
			want: want{
				want: func() *os.File {
					f, _ := os.OpenFile("file.go", os.O_RDONLY, os.ModePerm)
					return f
				}(),
				err: nil,
			},
		},

		{
			name: "returns (nil, error) when path is empty",
			args: args{
				flg:  os.O_CREATE,
				perm: os.ModeDir,
			},
			want: want{
				want: nil,
				err:  errors.ErrPathNotSpecified,
			},
		},

		{
			name: "returns (nil, error) when file does not exists and flag is not CREATE or APPEND",
			args: args{
				path: "dummy",
				flg:  os.O_RDONLY,
				perm: os.ModePerm,
			},
			want: want{
				want: nil,
				err: &os.PathError{
					Op:   "open",
					Path: "dummy",
					Err: func() error {
						_, err := syscall.Open("dummy", syscall.O_RDONLY|syscall.O_CLOEXEC, 0)
						return err
					}(),
				},
			},
		},

		{
			name: "returns (nil, error) when the folder does not exists and flag is not CREATE or APPEND",
			args: args{
				path: "dummy/dummy",
				flg:  os.O_RDONLY,
				perm: os.ModePerm,
			},
			want: want{
				want: nil,
				err: &os.PathError{
					Op:   "open",
					Path: "dummy/dummy",
					Err: func() error {
						_, err := syscall.Open("dummy/", syscall.O_RDONLY|syscall.O_CLOEXEC, 0)
						return err
					}(),
				},
			},
			afterFunc: func(t *testing.T, args args, f *os.File) {
				t.Helper()
				defaultAfterFunc(t, args, f)
				if err := os.RemoveAll("dummy"); err != nil {
					t.Fatal(err)
				}
			},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(tt *testing.T) {
			defer goleak.VerifyNone(tt)
			if test.beforeFunc != nil {
				test.beforeFunc(tt, test.args)
			}
			if test.checkFunc == nil {
				test.checkFunc = defaultCheckFunc
			}
			if test.afterFunc == nil {
				test.afterFunc = defaultAfterFunc
			}

			got, err := Open(test.args.path, test.args.flg, test.args.perm)
			defer test.afterFunc(tt, test.args, got)

			if err := test.checkFunc(test.want, got, err); err != nil {
				tt.Errorf("error = %v", err)
			}
		})
	}
}

func TestExists(t *testing.T) {
	type args struct {
		path string
	}
	type want struct {
		want bool
	}
	type test struct {
		name       string
		args       args
		want       want
		checkFunc  func(want, bool) error
		beforeFunc func(*testing.T, args)
		afterFunc  func(*testing.T, args)
	}
	defaultCheckFunc := func(w want, got bool) error {
		if !reflect.DeepEqual(got, w.want) {
			return errors.Errorf("got: \"%#v\",\n\t\t\t\twant: \"%#v\"", got, w.want)
		}
		return nil
	}

	const (
		baseDir      = "./utiltest"
		testDirPath  = baseDir + "/index"
		testFilePath = baseDir + "/ngt-meta.kvsdb"
		testSym      = "sym"

		testFailsDirPath  = baseDir + "/fails-index"
		testFailsFilePath = baseDir + "/ngt-meta-fails.kvsdb"
	)

	defaultAfterFunc := func(t *testing.T, args args) {
		t.Helper()
		if err := os.RemoveAll(baseDir); err != nil {
			t.Error(err)
		}
		if err := os.RemoveAll(args.path); err != nil {
			t.Error(err)
		}
	}

	tests := []test{
		{
			name: "return true when the directory exists",
			args: args{
				path: testDirPath,
			},
			beforeFunc: func(t *testing.T, args args) {
				t.Helper()
				if err := os.MkdirAll(args.path, 0o750); err != nil {
					t.Fatal(err)
				}
			},
			want: want{
				want: true,
			},
		},
		{
			name: "return true when the directory exists and the type is symbolic link",
			args: args{
				path: testSym,
			},
			beforeFunc: func(t *testing.T, args args) {
				t.Helper()
				if err := os.MkdirAll(testDirPath, 0o750); err != nil {
					t.Fatal(err)
				}
				if err := os.Symlink(testDirPath, testSym); err != nil {
					t.Error(err)
				}
			},
			want: want{
				want: true,
			},
		},
		{
			name: "return true when the file exists",
			args: args{
				path: testFilePath,
			},
			beforeFunc: func(t *testing.T, args args) {
				t.Helper()
				if err := os.MkdirAll(baseDir, 0o750); err != nil {
					t.Fatal(err)
				}

				f, err := os.Create(args.path)
				if err != nil {
					t.Fatal(err)
				}
				defer func() {
					if err := f.Close(); err != nil {
						t.Error(err)
					}
				}()
			},
			want: want{
				want: true,
			},
		},
		{
			name: "return true when the file exists and the type is symbolic link",
			args: args{
				path: testSym,
			},
			beforeFunc: func(t *testing.T, args args) {
				t.Helper()
				if err := os.MkdirAll(baseDir, 0o750); err != nil {
					t.Fatal(err)
				}

				f, err := os.Create(testFilePath)
				if err != nil {
					t.Fatal(err)
				}
				defer func() {
					if err := f.Close(); err != nil {
						t.Error(err)
					}
				}()

				if err := os.Symlink(testFilePath, testSym); err != nil {
					t.Error(err)
				}
			},
			want: want{
				want: true,
			},
		},
		{
			name: "return false when the directory does not exist",
			args: args{
				path: testFailsDirPath,
			},
			want: want{
				want: false,
			},
		},
		{
			name: "return false when the file exists",
			args: args{
				path: testFailsFilePath,
			},
			want: want{
				want: false,
			},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(tt *testing.T) {
			defer goleak.VerifyNone(tt, goleak.IgnoreCurrent())
			if test.beforeFunc != nil {
				test.beforeFunc(tt, test.args)
			}
			if test.afterFunc == nil {
				test.afterFunc = defaultAfterFunc
			}
			defer test.afterFunc(tt, test.args)

			if test.checkFunc == nil {
				test.checkFunc = defaultCheckFunc
			}

			// TODO we have to check more patter about file or dir
			got := Exists(test.args.path)
			if err := test.checkFunc(test.want, got); err != nil {
				tt.Errorf("error = %v", err)
			}
		})
	}
}

func TestExistsWithDetail(t *testing.T) {
	type args struct {
		path string
	}
	type want struct {
		wantE  bool
		wantFi fs.FileInfo
		err    error
	}
	type test struct {
		name       string
		args       args
		want       want
		checkFunc  func(want, bool, fs.FileInfo, error) error
		beforeFunc func(args)
		afterFunc  func(args)
	}
	defaultCheckFunc := func(w want, gotE bool, gotFi fs.FileInfo, err error) error {
		if !errors.Is(err, w.err) {
			return errors.Errorf("got_error: \"%#v\",\n\t\t\t\twant: \"%#v\"", err, w.err)
		}
		if !reflect.DeepEqual(gotE, w.wantE) {
			return errors.Errorf("got: \"%#v\",\n\t\t\t\twant: \"%#v\"", gotE, w.wantE)
		}
		if !reflect.DeepEqual(gotFi, w.wantFi) {
			return errors.Errorf("got: \"%#v\",\n\t\t\t\twant: \"%#v\"", gotFi, w.wantFi)
		}
		return nil
	}
	tests := []test{
		// TODO test cases
		/*
		   {
		       name: "test_case_1",
		       args: args {
		           path: "",
		       },
		       want: want{},
		       checkFunc: defaultCheckFunc,
		   },
		*/

		// TODO test cases
		/*
		   func() test {
		       return test {
		           name: "test_case_2",
		           args: args {
		           path: "",
		           },
		           want: want{},
		           checkFunc: defaultCheckFunc,
		       }
		   }(),
		*/
	}

	for _, tc := range tests {
		test := tc
		t.Run(test.name, func(tt *testing.T) {
			tt.Parallel()
			defer goleak.VerifyNone(tt, goleak.IgnoreCurrent())
			if test.beforeFunc != nil {
				test.beforeFunc(test.args)
			}
			if test.afterFunc != nil {
				defer test.afterFunc(test.args)
			}
			if test.checkFunc == nil {
				test.checkFunc = defaultCheckFunc
			}

			gotE, gotFi, err := ExistsWithDetail(test.args.path)
			if err := test.checkFunc(test.want, gotE, gotFi, err); err != nil {
				tt.Errorf("error = %v", err)
			}
		})
	}
}

func Test_exists(t *testing.T) {
	type args struct {
		path string
	}
	type want struct {
		wantExists bool
		wantFi     fs.FileInfo
		err        error
	}
	type test struct {
		name       string
		args       args
		want       want
		checkFunc  func(want, bool, fs.FileInfo, error) error
		beforeFunc func(args)
		afterFunc  func(args)
	}
	defaultCheckFunc := func(w want, gotExists bool, gotFi fs.FileInfo, err error) error {
		if !errors.Is(err, w.err) {
			return errors.Errorf("got_error: \"%#v\",\n\t\t\t\twant: \"%#v\"", err, w.err)
		}
		if !reflect.DeepEqual(gotExists, w.wantExists) {
			return errors.Errorf("got: \"%#v\",\n\t\t\t\twant: \"%#v\"", gotExists, w.wantExists)
		}
		if !reflect.DeepEqual(gotFi, w.wantFi) {
			return errors.Errorf("got: \"%#v\",\n\t\t\t\twant: \"%#v\"", gotFi, w.wantFi)
		}
		return nil
	}
	tests := []test{
		// TODO test cases
		/*
		   {
		       name: "test_case_1",
		       args: args {
		           path: "",
		       },
		       want: want{},
		       checkFunc: defaultCheckFunc,
		   },
		*/

		// TODO test cases
		/*
		   func() test {
		       return test {
		           name: "test_case_2",
		           args: args {
		           path: "",
		           },
		           want: want{},
		           checkFunc: defaultCheckFunc,
		       }
		   }(),
		*/
	}

	for _, tc := range tests {
		test := tc
		t.Run(test.name, func(tt *testing.T) {
			tt.Parallel()
			defer goleak.VerifyNone(tt, goleak.IgnoreCurrent())
			if test.beforeFunc != nil {
				test.beforeFunc(test.args)
			}
			if test.afterFunc != nil {
				defer test.afterFunc(test.args)
			}
			if test.checkFunc == nil {
				test.checkFunc = defaultCheckFunc
			}

			gotExists, gotFi, err := exists(test.args.path)
			if err := test.checkFunc(test.want, gotExists, gotFi, err); err != nil {
				tt.Errorf("error = %v", err)
			}
		})
	}
}

func TestListInDir(t *testing.T) {
	type args struct {
		path string
	}
	type want struct {
		want []string
		err  error
	}
	type test struct {
		name       string
		args       args
		want       want
		checkFunc  func(want, []string, error) error
		beforeFunc func(args)
		afterFunc  func(args)
	}
	defaultCheckFunc := func(w want, got []string, err error) error {
		if !errors.Is(err, w.err) {
			return errors.Errorf("got_error: \"%#v\",\n\t\t\t\twant: \"%#v\"", err, w.err)
		}
		if !reflect.DeepEqual(got, w.want) {
			return errors.Errorf("got: \"%#v\",\n\t\t\t\twant: \"%#v\"", got, w.want)
		}
		return nil
	}
	tests := []test{
		// TODO test cases
		/*
		   {
		       name: "test_case_1",
		       args: args {
		           path: "",
		       },
		       want: want{},
		       checkFunc: defaultCheckFunc,
		   },
		*/

		// TODO test cases
		/*
		   func() test {
		       return test {
		           name: "test_case_2",
		           args: args {
		           path: "",
		           },
		           want: want{},
		           checkFunc: defaultCheckFunc,
		       }
		   }(),
		*/
	}

	for _, tc := range tests {
		test := tc
		t.Run(test.name, func(tt *testing.T) {
			tt.Parallel()
			defer goleak.VerifyNone(tt, goleak.IgnoreCurrent())
			if test.beforeFunc != nil {
				test.beforeFunc(test.args)
			}
			if test.afterFunc != nil {
				defer test.afterFunc(test.args)
			}
			if test.checkFunc == nil {
				test.checkFunc = defaultCheckFunc
			}

			got, err := ListInDir(test.args.path)
			if err := test.checkFunc(test.want, got, err); err != nil {
				tt.Errorf("error = %v", err)
			}
		})
	}
}
