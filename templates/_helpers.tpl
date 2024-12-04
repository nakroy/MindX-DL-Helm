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
Example output:
- -key1=value1 
- -key2=value2
*/}}
{{- define "extraArgs" -}}
{{- range $key, $value := . }}
- -{{ $key }}={{ $value }}
{{- end -}}
{{- end -}}

{{/*
Convert a map of key-value pairs into a formatted string of args.
Example output: -key1=value1 -key2=value2
*/}}
{{- define "extraArgs.line" -}}
{{- $args := "" -}}
{{- range $key, $value := . -}}
{{- if $args }}{{ $args = printf "%s " $args }}{{ end -}}
{{- $args = printf "%s-%s=%v" $args $key $value -}}
{{- end -}}
{{- $args -}}
{{- end -}}

{{/*
Check if a specific npu type exists in the npuType list
*/}}
{{- define "hasNpuType2" -}}
{{- $target := index . 0 -}}
{{- $list := index . 1 -}}
{{- range $list -}}
  {{- if eq . $target -}}
    {{- printf "true" -}}
    {{- break -}}
  {{- end -}}
{{- printf "false" -}}
{{- end -}}
{{- end -}}

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
  image: busybox:1.37.0
  command:
    - /bin/sh
    - -c
    - |
      mkdir -p -m 750 {{ .path }} && \
      chown {{ .owner }} {{ .path }}
  volumeMounts:
    - name: mindx-dl-log
      mountPath: {{ .mountPath }}
{{- end -}}
