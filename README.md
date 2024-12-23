# MindX-DL Helm Chart
MindX DL是由华为昇腾开发的集群调度组件，基于业界流行的集群调度系统Kubernetes，增加了对昇腾AI处理器(NPU)的支持，提供NPU资源管理、优化调度和分布式训练集合通信配置等基础功能。关于MindX DL的详细介绍请参考：

[MindX DL昇腾文档](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingsd/clusterschedulingsd/mxdlug_201.html)

## 前置要求
- Kubernetes 1.19+
- Helm 3.8.0+
- Docker 18.09.x+, Containerd 1.4.x+
- Ascend Docker Runtime: [安装MindX-DL配套版本](https://gitee.com/ascend/ascend-docker-runtime/releases)
- 节点型号和OS版本参考: [支持的产品形态和OS版本](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingig/clusterschedulingig/dlug_installation_002.html)
- 其他软件和OS版本要求请参阅: [MindX DL 环境依赖](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingig/clusterschedulingig/dlug_installation_004.html)

## 安装方式
添加`mindx-dl`仓库:

```shell
helm repo add mindx-dl https://nakroy.github.io/MindX-DL-Helm/
helm repo update
```

### 选择一
安装最新版本:
```shell
helm install mindx-dl mindx-dl/mindx-dl
```

### 选择二(推荐)
下载指定版本压缩包:
```shell
helm pull mindx-dl/mindx-dl --version xxx
```
解压后修改`values.yaml`文件内容，执行以下命令安装:
```shell
helm install mindx-dl ./ -f values.yaml
```

## 配置选项说明

### Global Parameter
| Name                     | Description                                                                                                                                                                                                                                                                                                                        | Value |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `global.npuType`         | 集群计算节点的NPU型号，允许多种NPU型号的节点并存                                                                                                                                                                                                                                                                                   | `[]`  |
| `global.containerMode`   | Kubernetes使用的容器运行时，有以下选项： <br> 1. `"docker"` : Kubernetes版本为1.19+ ~ 1.23+，且使用Docker作为容器运行时； <br> 2. `"cri-docker"` : Kubernetes版本为1.24+，且使用Docker作为容器运行时； <br> 3. `"containerd"` : Kubernetes使用Containerd作为容器运行时； <br> 4. `"isulad"` : Kubernetes使用iSulad作为容器运行时。 | `""`  |
| `global.imageTag`        | 全局镜像标签(若未单独指定组件的镜像标签，则使用全局镜像标签，不包括`volcano`组件)                                                                                                                                                                                                                                                  | `""`  |
| `global.imageRegistry`   | 全局镜像拉取地址(若未单独指定组件的镜像地址，则使用全局镜像地址)                                                                                                                                                                                                                                                                   | `""`  |
| `global.imagePullPolicy` | 全局镜像拉取策略(若未单独指定组件的镜像拉取策略，则使用全局镜像拉取策略)                                                                                                                                                                                                                                                           | `""`  |

<br>

### Ascend Device Plugin Parameter
| Name                                          | Description                                                                                  | Value  |
| --------------------------------------------- | -------------------------------------------------------------------------------------------- | ------ |
| `ascendDevicePlugin.enabled`                  | 是否启用`ascend-k8sdeviceplugin`组件                                                         | `true` |
| `ascendDevicePlugin.image.repostory`          | `ascend-k8sdeviceplugin`组件镜像下载仓库                                                     | `""`   |
| `ascendDevicePlugin.image.tag`                | `ascend-k8sdeviceplugin`镜像标签                                                             | `""`   |
| `ascendDevicePlugin.image.pullPolicy`         | `ascend-k8sdeviceplugin`镜像拉取策略                                                         | `""`   |
| `ascendDevicePlugin.args.logLevel`            | `ascend-k8sdeviceplugin`组件日志记录等级                                                     | `0`    |
| `ascendDevicePlugin.args.logFile`             | `ascend-k8sdeviceplugin`组件日志记录文件                                                     | `""`   |
| `ascendDevicePlugin.args.useAscendDocker`     | `ascend-k8sdeviceplugin`组件部署节点容器运行时是否使用`Ascend Docker Runtime`插件            | `true` |
| `ascendDevicePlugin.args.volcanoType`         | `ascend-k8sdeviceplugin`是否搭配使用`volcano`组件                                            | `true` |
| `ascendDevicePlugin.args.presetVirtualDevice` | `ascend-k8sdeviceplugin`组件使用静态/动态虚拟化，`true`使用静态虚拟化，`false`使用动态虚拟化 | `true` |
| `ascendDevicePlugin.args.hotReset`            | 节点NPU芯片热复位功能参数，`-1`表示关闭热复位功能                                            | `-1`   |
| `ascendDevicePlugin.extraVolumeMounts`        | `ascend-k8sdeviceplugin`容器额外挂载的卷目录                                                 | `[]`   |
| `ascendDevicePlugin.extraVolumes`              | `ascend-k8sdeviceplugin`容器额外挂载的卷                                                     | `[]`   |
> NOTE: `ascendDevicePlugin.args`完整参数设置请参考[Ascend Device Plugin参数说明](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingig/clusterschedulingig/dlug_installation_019.html)

<br>

### Ascend Operator Parameter
| Name                                                      | Description                                                 | Value                             |
| --------------------------------------------------------- | ----------------------------------------------------------- | --------------------------------- |
| `ascendOperator.enabled`                                  | 是否启用`ascend-operator`组件                               | `false`                           |
| `ascendOperator.replicas`                                 | `ascend-operator`组件副本数                                 | `1`                               |
| `ascendOperator.image.repostory`                          | `ascend-operator`组件镜像下载仓库                           | `""`                              |
| `ascendOperator.image.tag`                                | `ascend-operator`镜像标签                                   | `""`                              |
| `ascendOperator.image.pullPolicy`                         | `ascend-operator`镜像拉取策略                               | `""`                              |
| `ascendOperator.nodeSelector`                             | `ascend-operator`组件调度节点标签，必须调度至管理节点       | `masterselector: dls-master-node` |
| `ascendOperator.resources`                                | `ascend-operator`资源使用申请和限制                         | `{}`                              |
| `ascendOperator.args.logLevel`                            | `ascend-operator`组件日志记录等级                           | `0`                               |
| `ascendOperator.args.logFile`                             | `ascend-operator`组件日志记录文件                           | `""`                              |
| `ascendOperator.args.enableGangScheduling`                | `ascend-operator`组件是否使用"gang"策略调度                 | `true`                            |
| `ascendOperator.args.kubeApiQps`                          | `ascend-operator`组件与Kubernetes通信时的每秒请求率         | `800`                             |
| `ascendOperator.args.kubeApiBurst`                        | `ascend-operator`组件与Kubernetes通信时的突发流量           | `800`                             |
| `ascendOperator.securityContext.allowPrivilegeEscalation` | `ascend-operator`容器是否获得额外权限                       | `false`                           |
| `ascendOperator.securityContext.readOnlyRootFilesystem`   | `ascend-operator`容器root文件系统是否被挂载为只读           | `true`                            |
| `ascendOperator.securityContext.runAsUser`                | `ascend-operator`容器运行用户，默认使用hwMindX(uid: 9000)   | `9000`                            |
| `ascendOperator.securityContext.runAsGroup`               | `ascend-operator`容器运行用户组，默认使用hwMindX(gid: 9000) | `9000`                            |
| `ascendOperator.securityContext.capabilities`             | `ascend-operator`容器可用内核功能                           | `{}`                              |
| `ascendOperator.extraVolumeMounts`                        | `ascend-operator`容器额外挂载的卷目录                       | `[]`                              |
| `ascendOperator.extraVolumes`                              | `ascend-operator`容器额外挂载的卷                           | `[]`                              |
> NOTE: `ascendOperator.args`完整参数设置请参考[Ascend Operator参数说明](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingig/clusterschedulingig/dlug_installation_025.html)

<br>

### HCCL Controller Parameter
| Name                                                      | Description                                           | Value                             |
| --------------------------------------------------------- | ----------------------------------------------------- | --------------------------------- |
| `hcclController.enabled`                                  | 是否启用`hccl-controller`组件                         | `false`                           |
| `hcclController.replicas`                                 | `hccl-controller`组件副本数                           | `1`                               |
| `hcclController.image.repostory`                          | `hccl-controller`组件镜像下载仓库                     | `""`                              |
| `hcclController.image.tag`                                | `hccl-controller`镜像标签                             | `""`                              |
| `hcclController.image.pullPolicy`                         | `hccl-controller`镜像拉取策略                         | `""`                              |
| `hcclController.nodeSelector`                             | `hccl-controller`组件调度节点标签，必须调度至管理节点 | `masterselector: dls-master-node` |
| `hcclController.resources`                                | `hccl-controller`资源使用申请和限制                   | `{}`                              |
| `hcclController.args.logLevel`                            | `hccl-controller`组件日志记录等级                     | `0`                               |
| `hcclController.args.logFile`                             | `hccl-controller`组件日志记录文件                     | `""`                              |
| `hcclController.args.jobParallelism`                      | `hccl-controller`组件job任务并发数，范围为1~32        | `1`                               |
| `hcclController.args.podParallelism`                      | `hccl-controller`组件Pod任务并发数，范围为1~32        | `1`                               |
| `hcclController.args.kubeApiQps`                          | `hccl-controller`组件与Kubernetes通信时的每秒请求率   | `800`                             |
| `hcclController.args.kubeApiBurst`                        | `hccl-controller`组件与Kubernetes通信时的突发流量     | `800`                             |
| `hcclController.securityContext.allowPrivilegeEscalation` | `hccl-controller`容器是否获得额外权限                 | `false`                           |
| `hcclController.securityContext.readOnlyRootFilesystem`   | `hccl-controller`容器root文件系统是否被挂载为只读     | `true`                            |
| `hcclController.securityContext.capabilities`             | `hccl-controller`容器可用内核功能                     | `{}`                              |
| `hcclController.extraVolumeMounts`                        | `hccl-controller`容器额外挂载的卷目录                 | `[]`                              |
| `hcclController.extraVolumes`                              | `hccl-controller`容器额外挂载的卷                     | `[]`                              |
> NOTE: `hcclController.args`完整参数设置请参考[HCCL Controller参数说明](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingig/clusterschedulingig/dlug_installation_026.html)

<br>

### NPU Exporter Parameter
| Name                                                 | Description                                                          | Value                             |
| ---------------------------------------------------- | -------------------------------------------------------------------- | --------------------------------- |
| `npuExporter.enabled`                                | 是否启用`npu-exporter`组件                                           | `false`                           |
| `npuExporter.image.repostory`                        | `npu-exporter`组件镜像下载仓库                                       | `""`                              |
| `npuExporter.image.tag`                              | `npu-exporter`镜像标签                                               | `""`                              |
| `npuExporter.image.pullPolicy`                       | `npu-exporter`镜像拉取策略                                           | `""`                              |
| `npuExporter.nodeSelector`                           | `npu-exporter`组件调度节点标签，必须调度至计算节点                   | `masterselector: dls-worker-node` |
| `npuExporter.resources`                              | `npu-exporter`资源使用申请和限制                                     | `{}`                              |
| `npuExporter.args.logLevel`                          | `npu-exporter`组件日志记录等级                                       | `0`                               |
| `npuExporter.args.logFile`                           | `npu-exporter`组件日志记录文件                                       | `""`                              |
| `npuExporter.args.port`                              | `npu-exporter`服务监听端口                                           | `8082`                            |
| `npuExporter.args.ip`                                | `npu-exporter`服务监听IP地址                                         | `0.0.0.0`                         |
| `npuExporter.args.updateTime`                        | `npu-exporter`服务信息更新周期，范围为1~60s                          | `5`                               |
| `npuExporter.args.containerMode`                     | `npu-exporter`容器运行时类型，可选择`docker`, `containerd`或`isulad` | `""`                              |
| `npuExporter.securityContext.prvileged`              | `npu-exporter`容器是否设置为特权模式                                 | `true`                            |
| `npuExporter.securityContext.readOnlyRootFilesystem` | `npu-exporter`容器root文件系统是否被挂载为只读                       | `true`                            |
| `npuExporter.securityContext.runAsUser`              | `npu-exporter`容器运行用户，默认使用root(uid: 0)                     | `0`                               |
| `npuExporter.securityContext.runAsGroup`             | `npu-exporter`容器运行用户组，默认使用root(gid: 0)                   | `0`                               |
| `npuExporter.mountSock`                              | `npu-exporter`容器是否挂载sock目录                                   | `false`                           |
| `npuExporter.mountSockPath`                          | `npu-exporter`容器挂载的sock目录                                     | `""`                              |
| `npuExporter.extraVolumeMounts`                      | `npu-exporter`容器额外挂载的卷目录                                   | `[]`                              |
| `npuExporter.extraVolumes`                            | `npu-exporter`容器额外挂载的卷                                       | `[]`                              |
> NOTE: `npuExporter.args`完整参数设置请参考[NPU Exporter参数说明](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingig/clusterschedulingig/dlug_installation_018.html)

<br>

### NodeD Parameter
| Name                                           | Description                                     | Value                             |
| ---------------------------------------------- | ----------------------------------------------- | --------------------------------- |
| `noded.enabled`                                | 是否启用`noded`组件                             | `false`                           |
| `noded.image.repostory`                        | `noded`组件镜像下载仓库                         | `""`                              |
| `noded.image.tag`                              | `noded`镜像标签                                 | `""`                              |
| `noded.image.pullPolicy`                       | `noded`镜像拉取策略                             | `""`                              |
| `noded.nodeSelector`                           | `noded`组件调度节点标签，必须调度至计算节点     | `masterselector: dls-worker-node` |
| `noded.resources`                              | `noded`资源使用申请和限制                       | `{}`                              |
| `noded.args.logLevel`                          | `noded`组件日志记录等级                         | `0`                               |
| `noded.args.logFile`                           | `noded`组件日志记录文件                         | `""`                              |
| `noded.args.heartbeatInterval`                 | `noded`组件发送心跳的间隔时间，取值范围为1~300s | `""`                              |
| `noded.securityContext.prvileged`              | `noded`容器是否设置为特权模式                   | `true`                            |
| `noded.securityContext.readOnlyRootFilesystem` | `noded`容器root文件系统是否被挂载为只读         | `true`                            |
| `noded.extraVolumeMounts`                      | `noded`容器额外挂载的卷目录                     | `[]`                              |
| `noded.extraVolumes`                            | `noded`容器额外挂载的卷                         | `[]`                              |
> NOTE: `noded.args`完整参数设置请参考[NodeD参数说明](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingig/clusterschedulingig/dlug_installation_027.html)

<br>

### ClusterD Parameter
| Name                                              | Description                                    | Value                             |
| ------------------------------------------------- | ---------------------------------------------- | --------------------------------- |
| `clusterd.enabled`                                | 是否启用`clusterd`组件                         | `false`                           |
| `clusterd.replicas`                               | `clusterd`组件副本数                           | `1`                               |
| `clusterd.image.repostory`                        | `clusterd`组件镜像下载仓库                     | `""`                              |
| `clusterd.image.tag`                              | `clusterd`镜像标签                             | `""`                              |
| `clusterd.image.pullPolicy`                       | `clusterd`镜像拉取策略                         | `""`                              |
| `clusterd.nodeSelector`                           | `clusterd`组件调度节点标签，必须调度至管理节点 | `masterselector: dls-master-node` |
| `clusterd.resources`                              | `clusterd`资源使用申请和限制                   | `{}`                              |
| `clusterd.args.logLevel`                          | `clusterd`组件日志记录等级                     | `0`                               |
| `clusterd.args.logFile`                           | `clusterd`组件日志记录文件                     | `""`                              |
| `clusterd.securityContext.readOnlyRootFilesystem` | `clusterd`容器root文件系统是否被挂载为只读     | `true`                            |
| `clusterd.service.port`                           | `clusted`服务监听端口                          | `8899`                            |
| `clusterd.service.targetPort`                     | `clusterd`容器监听端口                         | `8899`                            |
| `clusterd.extraVolumeMounts`                      | `clusterd`容器额外挂载的卷目录                 | `[]`                              |
| `clusterd.extraVolumes`                            | `clusterd`容器额外挂载的卷                     | `[]`                              |
> NOTE: `clusterd.args`完整参数设置请参考[ClusterD参数说明](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingig/clusterschedulingig/dlug_installation_024.html)

<br>

### Resilience Controller Parameter
| Name                                                            | Description                                                                                                | Value                             |
| --------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `resilienceController.enabled`                                  | 是否启用`resilience-controller`组件                                                                        | `false`                           |
| `resilienceController.replicas`                                 | `resilience-controller`组件副本数                                                                          | `1`                               |
| `resilienceController.useServiceAccount`                        | `resilience-controller`是否创建ServiceAccount连接Kubernetes，若选择`false`则需要手动导入KubeConfig文件连接 | `true`                            |
| `resilienceController.image.repostory`                          | `resilience-controller`组件镜像下载仓库                                                                    | `""`                              |
| `resilienceController.image.tag`                                | `resilience-controller`镜像标签                                                                            | `""`                              |
| `resilienceController.image.pullPolicy`                         | `resilience-controller`镜像拉取策略                                                                        | `""`                              |
| `resilienceController.nodeSelector`                             | `resilience-controller`组件调度节点标签，必须调度至管理节点                                                | `masterselector: dls-master-node` |
| `resilienceController.resources`                                | `resilience-controller`资源使用申请和限制                                                                  | `{}`                              |
| `resilienceController.args.logLevel`                            | `resilience-controller`组件日志记录等级                                                                    | `0`                               |
| `resilienceController.args.logFile`                             | `resilience-controller`组件日志记录文件                                                                    | `""`                              |
| `resilienceController.securityContext.allowPrivilegeEscalation` | `resilience-controller`容器是否获得额外权限                                                                | `false`                           |
| `resilienceController.securityContext.readOnlyRootFilesystem`   | `resilience-controller`容器root文件系统是否被挂载为只读                                                    | `true`                            |
| `resilienceController.securityContext.capabilities`             | `resilience-controller`容器可用内核功能                                                                    | `{}`                              |
| `resilienceController.extraVolumeMounts`                        | `resilience-controller`容器额外挂载的卷目录                                                                | `[]`                              |
| `resilienceController.extraVolumes`                              | `resilience-controller`容器额外挂载的卷                                                                    | `[]`                              |
> NOTE: `resilienceController.args`完整参数设置请参考[Resilience Controller参数说明](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingig/clusterschedulingig/dlug_installation_029.html)

<br>

### Volcano Parameter
| Name                                                 | Description                                                          | Value                             |
| ---------------------------------------------------- | -------------------------------------------------------------------- | --------------------------------- |
| `volcano.enabled` | 是否启用`volcao`组件 | `false` |
| `volcano.version` | 使用的`volcano`版本，需要根据MindX DL版本选择配套的Volcano版本 | `""` |
| `volcano.arch` | `volcano`组件部署的节点CPU架构，根据要部署`volcano`组件的管理节点CPU架构可选择`x86_64`或`aarch64` | `""` |
| `volcano.scheduler.enableNodeOrder`                                | `volcano-scheduler`组件是否启用`nodeorder`插件                                          | `false`                           |
| `volcano.scheduler.enableMultiSchedule`                                | `volcano-scheduler`组件是否启用大规模并发调度优化                                          | `false`                           |
| `volcano.scheduler.replicas` | `volcano-scheduler`组件的副本数 | `1` |
| `volcano.scheduler.image.repostory`                        | `volcano-scheduler`组件镜像下载仓库                                       | `""`                              |
| `volcano.scheduler.image.tag`                              | `volcano-scheduler`镜像标签                                               | `""`                              |
| `volcano.scheduler.image.pullPolicy`                       | `volcano-scheduler`镜像拉取策略                                           | `""`                              |
| `volcano.scheduler.nodeSelector`                           | `volcano-scheduler`组件调度节点标签，必须调度至管理节点                   | `masterselector: dls-master-node` |
| `volcano.scheduler.resources`                              | `volcano-scheduler`资源使用申请和限制                                     | `{}`                              |
| `volcano.scheduler.args.grace-over-time`                          | `volcano-scheduler`组件重调度优雅删除模式下删除Pod所需最大时间，取值范围2~3600s                                      | `900`                               |
| `volcano.scheduler.args.presetVirtualDevice`                          | `volcano-scheduler`组件调度虚拟NPU的类型，`true`表示静态虚拟化，`false`表示动态虚拟化                                      | `true`                               |
| `volcano.scheduler.args.nslb-version`                          | `volcano-scheduler`组件交换机亲和ing调度的版本，可选择`1.0`或`2.0`                                     | `1.0`                               |
| `volcano.scheduler.args.shared-tor-num` | `volcano-scheduler`交换机亲和性调度2.0中单个任务可使用的最大共享交换机数量，可取值为1或2。仅在`nslb-version`取值为2.0时生效 | `2` |
| `volcano.scheduler.args.useClusterInfoManager` | `volcano-scheduler`组件获取集群信息的方式，`true`为读取ClusterD上报的ConfigMap，`false`为分别读取Ascend Device Plugin和NodeD上报的ConfigMap |
| `volcano.scheduler.args.super-pod-size` | `volcano-scheduler`组件调度的Super Pod最大可申请的NPU资源量 | `48` |
| `volcano.scheduler.args.reverse-nodes` | `volcano-scheduler`组件调度时反向选择节点数量 | `2` |
| `volcano.scheduler.logDir` | `volcano-scheduler`日志存储目录 | `""` |
| `volcano.scheduler.securityContext.allowPrivilegeEscalation` | `volcano-scheduler`容器是否获得额外权限                       | `false`                           |
| `volcano.scheduler.securityContext.readOnlyRootFilesystem`   | `volcano-scheduler`容器root文件系统是否被挂载为只读           | `true`                            |
| `volcano.scheduler.securityContext.runAsUser`                | `volcano-scheduler`容器运行用户，默认使用hwMindX(uid: 9000)   | `9000`                            |
| `volcano.scheduler.securityContext.runAsGroup`               | `volcano-scheduler`容器运行用户组，默认使用hwMindX(gid: 9000) | `9000`                            |
| `volcano.scheduler.securityContext.capabilities`             | `volcano-scheduler`容器可用内核功能                           | `{}`                              |
| `volcano.scheduler.service.enabled` | 是否开启`volcano-scheduler`性能指标监测服务(集成prometheus) | `false` |
| `volcano.scheduler.service.annotations` | `volcano-scheduler`性能指标监测服务使用的注解 | `{}` |
| `volcano.scheduler.service.port` | `volcano-scheduler`性能指标监测服务监听端口 | `8080` |
| `volcano.scheduler.service.targetPort` | `volcano-scheduler`性能指标服务容器监听端口 | `8080` |
| `volcano.scheduler.extraVolumeMounts`                      | `volcano-scheduler`容器额外挂载的卷目录                                   | `[]`                              |
| `volcano.scheduler.extraVolumes`                            | `volcano-scheduler`容器额外挂载的卷                                       | `[]`                              |
| `volcano.controller.replicas` | `volcano-controller`组件的副本数 | `1` |
| `volcano.controller.image.repostory`                        | `volcano-controller`组件镜像下载仓库                                       | `""`                              |
| `volcano.controller.image.tag`                              | `volcano-controller`镜像标签                                               | `""`                              |
| `volcano.controller.image.pullPolicy`                       | `volcano-controller`镜像拉取策略                                           | `""`                              |
| `volcano.controller.nodeSelector`                           | `volcano-controller`组件调度节点标签，必须调度至管理节点                   | `masterselector: dls-master-node` |
| `volcano.controller.resources`                              | `volcano-controller`资源使用申请和限制                                     | `{}`                              |
| `volcano.controller.args.kubeApiQps`                          | `volcano-controller`组件与Kubernetes通信时的每秒请求率 | `800` |
| `volcano.controller.args.kubeApiBurst`                          | `volcano-controller`组件与Kubernetes通信时使用的突发流量 | `800` |
| `volcano.controller.args.workerThreads`                          | `volcano-controller`组件工作线程数 | `6` |
| `volcano.controller.args.logDir` | `volcano-controller`日志存储目录 | `""` |
| `volcano.controller.securityContext.allowPrivilegeEscalation` | `volcano-controller`容器是否获得额外权限                       | `false`                           |
| `volcano.controller.securityContext.readOnlyRootFilesystem`   | `volcano-controller`容器root文件系统是否被挂载为只读           | `true`                            |
| `volcano.controller.securityContext.runAsUser`                | `volcano-controller`容器运行用户，默认使用hwMindX(uid: 9000)   | `9000`                            |
| `volcano.controller.securityContext.runAsGroup`               | `volcano-controller`容器运行用户组，默认使用hwMindX(gid: 9000) | `9000`                            |
| `volcano.controller.securityContext.capabilities`             | `volcano-controller`容器可用内核功能                           | `{}`                              |
| `volcano.controller.logRotate.path` | `volcano-controller`日志转存子目录 | `""` |
| `volcano.controller.logRotate.content` | `volcano-controller`日志转存配置内容 | `""` |
| `volcano.controller.extraVolumeMounts`                      | `volcano-controller`容器额外挂载的卷目录                                   | `[]`                              |
| `volcano.controller.extraVolumes`                            | `volcano-controller`容器额外挂载的卷                                       | `[]`                              |
> NOTE: `volcano.scheduler.args`和`volcano.controller.args`完整参数设置请参考[Volcano参数说明](https://www.hiascend.com/document/detail/zh/mindx-dl/60rc3/clusterscheduling/clusterschedulingig/clusterschedulingig/dlug_installation_021.html)












