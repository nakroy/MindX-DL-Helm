{{/*
Extract the directory path from a full file path using regexSplit.
*/}}
{{- define "extractPath" -}}
{{- if . -}}
{{- $parts := regexSplit "/" . -1 -}}
{{- $dirParts := $parts | initial -}}
{{- $dir := $dirParts | join "/" -}}
{{- $dir -}}
{{- else -}}
"/var/log/mindx-dl/noded"
{{- end -}}
{{- end -}}

{{/*
Convert a map of key-value pairs into a formatted string of args.
Example output: -key1=value1 -key2=value2
*/}}
{{- define "extraArgs" -}}
{{- $args := "" -}}
{{- range $key, $value := . -}}
{{- if $args }}{{ $args = printf "%s " $args }}{{ end -}}
{{- $args = printf "%s-%s=%v" $args $key $value -}}
{{- end -}}
{{- $args -}}
{{- end -}}

{{/*
Convert a map of key-value pairs into a formatted string of args.
Example output:
- -key1=value1 
- -key2=value2
*/}}
{{- define "extraArgs.array" -}}
{{- range $key, $value := . }}
- -{{ $key }}={{ $value }}
{{- end -}}
{{- end -}}

{{/*
Convert a map of key-value pairs into a formatted string of args.
Example output:
- --key1=value1 
- --key2=value2
*/}}
{{- define "extraArgs.double" -}}
{{- range $key, $value := . }}
- --{{ $key }}={{ $value }}
{{- end -}}
{{- end -}}

{{/*
Convert a map of key-value pairs into a formatted string of args.
Example output: {"key1":"value1","key2":"value2"}
*/}}
{{- define "extraArgs.dict" -}}
{ {{- $len := len . -}}
{{- $i := 0 -}}
{{- range $key, $value := . -}}
"{{ $key }}":"{{ $value }}"{{- if lt $i (sub $len 1) -}},{{- end -}}
{{- $i = add $i 1 -}}
{{- end -}}
}
{{- end -}}


{{/*
Check if a specific npu type exists in the npuType list
*/}}
{{- define "hasNpuType" -}}
{{- $target := index . 0 -}}
{{- $list := index . 1 -}}
{{- $found := false -}}
{{- range $list -}}
  {{- if eq . $target -}}
    {{- $found = true -}}
  {{- end -}}
{{- end -}}
{{- $found -}}
{{- end -}}

{{/*
Generate an initContainer for creating a directory and setting permissions.
*/}}
{{- define "initContainer.createDir" -}}
- name: init-container
  image: ubuntu:22.04
  command:
    - /bin/bash
    - -c
    - |
    {{- if eq .owner "hwMindX:hwMindX" }}
      groupadd -g 1000 HwHiAiUser && \
      useradd -g HwHiAiUser -u 1000 -d /home/HwHiAiUser -m HwHiAiUser -s /bin/bash && \
      useradd -d /home/hwMindX -u 9000 -m -s /usr/sbin/nologin hwMindX && \
      usermod -a -G HwHiAiUser hwMindX && \
    {{- end }}
      mkdir -p -m 750 {{ .path }} && \
      chown {{ .owner }} {{ .path }}
  volumeMounts:
    - name: mindx-dl-log
      mountPath: {{ .mountPath }}
{{- end -}}

{{/*
Generate an initContainer for creating a directory, setting permissions, and managing logrotate configuration.
*/}}
{{- define "initContainer.logrotateCreateDir" -}}
- name: init-container
  image: ubuntu:22.04
  command:
    - /bin/bash
    - -c
    - |
      groupadd -g 1000 HwHiAiUser && \
      useradd -g HwHiAiUser -u 1000 -d /home/HwHiAiUser -m HwHiAiUser -s /bin/bash && \
      useradd -d /home/hwMindX -u 9000 -m -s /usr/sbin/nologin hwMindX && \
      usermod -a -G HwHiAiUser hwMindX && \
      mkdir -p -m 750 {{ .path }} && \
      mkdir -p -m 750 {{ .path }} && \
      chown {{ .owner }} {{ .path }} && \
      echo "{{ .logrotateContent | nindent 6 }}" > /etc/logrotate.d/{{ .logrotatePath }} && \
      chmod 640 /etc/logrotate.d/{{ .logrotatePath }} && \
      chown root /etc/logrotate.d/{{ .logrotatePath }}
  volumeMounts:
    - name: mindx-dl-log
      mountPath: {{ .mountPath }}
    - name: logrotate
      mountPath: /etc/logrotate.d
{{- end -}}

{{/*
Generate an initContainer for creating a directory and setting permissions, and managing resilience controller configuration
*/}}
{{- define "initContainer.resilienceCreateDir" -}}
- name: init-container
  image: ubuntu:22.04
  command:
    - /bin/bash
    - -c
    - |
      groupadd -g 1000 HwHiAiUser && \
      useradd -g HwHiAiUser -u 1000 -d /home/HwHiAiUser -m HwHiAiUser -s /bin/bash && \
      useradd -d /home/hwMindX -u 9000 -m -s /usr/sbin/nologin hwMindX && \
      usermod -a -G HwHiAiUser hwMindX && \
    {{- if not .useServiceAccount }}
      mkdir -p /etc/mindx-dl/kmc_primary_store && \
      chown {{ .owner }} /etc/mindx-dl/kmc_primary_store && \
      mkdir -p /etc/mindx-dl/.config && \
      chown {{ .owner }} /etc/mindx-dl/.config && \
      mkdir -p /etc/mindx-dl/resilience-controller && \
      chown {{ .owner }} /etc/mindx-dl/resilience-controller && \
    {{- end }}
      mkdir -p -m 750 {{ .path }} && \
      chown {{ .owner }} {{ .path }}
  volumeMounts:
    - name: mindx-dl-log
      mountPath: {{ .mountPath }}
  {{- if not .useServiceAccount }}
    - name: etc-mindx-dl
      mountPath: /etc/mindx-dl
  {{- end }}
{{- end -}}