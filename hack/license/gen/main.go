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

package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"text/template"
	"time"

	"github.com/vdaas/vald/internal/errors"
	"github.com/vdaas/vald/internal/log"
)

var (
	apache = template.Must(template.New("Apache License").Parse(`{{.Escape}}
{{.Escape}} Copyright (C) 2019-{{.Year}} {{.Maintainer}}
{{.Escape}}
{{.Escape}} Licensed under the Apache License, Version 2.0 (the "License");
{{.Escape}} you may not use this file except in compliance with the License.
{{.Escape}} You may obtain a copy of the License at
{{.Escape}}
{{.Escape}}    https://www.apache.org/licenses/LICENSE-2.0
{{.Escape}}
{{.Escape}} Unless required by applicable law or agreed to in writing, software
{{.Escape}} distributed under the License is distributed on an "AS IS" BASIS,
{{.Escape}} WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
{{.Escape}} See the License for the specific language governing permissions and
{{.Escape}} limitations under the License.
{{.Escape}}
`))
	slushEscape = "//"
	sharpEscape = "#"
)

type Data struct {
	Escape     string
	Maintainer string
	Year       int
}

const (
	minimumArgumentLength = 2
	defaultMaintainer     = "vdaas.org vald team <vald@vdaas.org>"
	maintainerKey         = "MAINTAINER"
)

func main() {
	log.Init()
	if len(os.Args) < minimumArgumentLength {
		log.Fatal(errors.New("invalid argument"))
	}
	for _, path := range dirwalk(os.Args[1]) {
		fmt.Println(path)
		err := readAndRewrite(path)
		if err != nil {
			log.Fatal(err)
		}
	}
}

func dirwalk(dir string) []string {
	files, err := ioutil.ReadDir(dir)
	if err != nil {
		panic(err)
	}
	var paths []string
	for _, file := range files {
		if file.IsDir() {
			if !strings.Contains(file.Name(), "vendor") &&
				!strings.Contains(file.Name(), "versions") &&
				!strings.Contains(file.Name(), ".git") ||
				strings.HasPrefix(file.Name(), ".github") {
				paths = append(paths, dirwalk(filepath.Join(dir, file.Name()))...)
			}
			continue
		}
		switch filepath.Ext(file.Name()) {
		case
			".ai",
			".all-contributorsrc",
			".cfg",
			".crt",
			".default",
			".drawio",
			".git",
			".gitignore",
			".gitkeep",
			".gitmodules",
			".gotmpl",
			".hdf5",
			".helmignore",
			".html",
			".json",
			".key",
			".lock",
			".md",
			".md5",
			".mod",
			".pem",
			".png",
			".ssv",
			".sum",
			".svg",
			".tmpl",
			".tpl",
			".txt",
			".whitesource",
			"LICENSE",
			"Pipefile":
		default:
			switch file.Name() {
			case
				"AUTHORS",
				"CONTRIBUTORS",
				"GO_VERSION",
				"NGT_VERSION",
				"Pipefile",
				"TENSORFLOW_C_VERSION",
				"VALD_VERSION",
				"grp",
				"obj",
				"prf",
				"src",
				"tre":
			default:
				path, err := filepath.Abs(filepath.Join(dir, file.Name()))
				if err != nil {
					log.Fatal(err)
				}
				paths = append(paths, path)
			}
		}
	}
	return paths
}

func readAndRewrite(path string) error {
	f, err := os.OpenFile(path, os.O_RDWR|os.O_SYNC, os.ModePerm)
	if err != nil {
		return errors.Errorf("filepath %s, could not open", path)
	}
	fi, err := f.Stat()
	if err != nil {
		err = f.Close()
		if err != nil {
			log.Fatal(err)
		}
		return errors.Errorf("filepath %s, could not open", path)
	}
	buf := bytes.NewBuffer(make([]byte, 0, fi.Size()))
	maintainer := os.Getenv(maintainerKey)
	if len(maintainer) == 0 {
		maintainer = defaultMaintainer
	}
	d := Data{
		Maintainer: maintainer,
		Year:       time.Now().Year(),
		Escape:     sharpEscape,
	}
	if fi.Name() == "LICENSE" {
		err = license.Execute(buf, d)
		if err != nil {
			log.Fatal(err)
		}
	} else {
		switch filepath.Ext(path) {
		case ".go", ".proto":
			d.Escape = slushEscape
		}
		lf := true
		bf := false
		sc := bufio.NewScanner(f)
		once := sync.Once{}
		for sc.Scan() {
			line := sc.Text()
			if filepath.Ext(path) == ".go" && strings.HasPrefix(line, "// +build") ||
				filepath.Ext(path) == ".py" && strings.HasPrefix(line, "# -*-") {
				bf = true
				_, err = buf.WriteString(line)
				if err != nil {
					log.Fatal(err)
				}
				_, err = buf.WriteString("\n")
				if err != nil {
					log.Fatal(err)
				}
				_, err = buf.WriteString("\n")
				if err != nil {
					log.Fatal(err)
				}
				continue
			}
			if (filepath.Ext(path) == ".yaml" || filepath.Ext(path) == ".yml") && strings.HasPrefix(line, "---") {
				_, err = buf.WriteString(line)
				if err != nil {
					log.Fatal(err)
				}
				_, err = buf.WriteString("\n")
				if err != nil {
					log.Fatal(err)
				}
				continue
			}
			if lf && strings.HasPrefix(line, d.Escape) {
				continue
			} else if !bf {
				once.Do(func() {
					err = apache.Execute(buf, d)
					if err != nil {
						log.Fatal(err)
					}
				})
				lf = false
			}
			if !lf {
				_, err = buf.WriteString(line)
				if err != nil {
					log.Fatal(err)
				}
				_, err = buf.WriteString("\n")
				if err != nil {
					log.Fatal(err)
				}
			}
			bf = false
		}
	}
	err = f.Close()
	if err != nil {
		return errors.Errorf("filepath %s, could not close", path)
	}
	err = os.RemoveAll(path)
	if err != nil {
		return errors.Errorf("filepath %s, could not delete", path)
	}
	f, err = os.Create(path)
	if err != nil {
		err = f.Close()
		if err != nil {
			log.Fatal(err)
		}
		return errors.Errorf("filepath %s, could not open", path)
	}
	_, err = f.WriteString(strings.ReplaceAll(buf.String(), d.Escape+"\n\n\n", d.Escape+"\n\n"))
	if err != nil {
		log.Fatal(err)
	}
	err = f.Close()
	if err != nil {
		log.Fatal(err)
	}
	return nil
}

var license = template.Must(template.New("LICENSE").Parse(
	`                                 Apache License
                           Version 2.0, January 2004
                        https://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright (C) 2019-{{.Year}} {{.Maintainer}}

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       https://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.`))
