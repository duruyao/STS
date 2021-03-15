# 模拟训练软件接口

## Index

- [1. Protocol Buffers Structure](#1-protocol-buffers-structure)
    - [1.1. Basic Structure](#11-basic-structure)
        - [1.1.1. STError](#111-sterror)
        - [1.1.2. STFile](#112-stfile)
        - [1.1.3. STPlanType](#113-stplantype)
    - [1.2. STPlan](#12-stplan)
    - [1.3. STEvalPlan](#13-stevalplan)
    - [1.4. STTask](#14-sttask)
    - [1.5. STSql](#15-stsql)
    - [1.6. STDev](#16-stdev)
    - [1.7. STDevActList](#17-stdevactlist)
    - [1.8. STSituInfo](#18-stsituinfo)
- [2. gRPC Service Interface](#2-grpc-service-interface)
    - [2.1. STFile-related Interface](#21-stfile-related-interface)
        - [2.1.1. storeRemoteFile（存储文件到远端）](#211-storeremotefile)
        - [2.1.2. getRemoteFile（读取文件从远端）](#212-getremotefile)
    - [2.2. STPlan-related Interface](#22-stplan-related-interface)
        - [2.2.1. getNewPlanID（获取新训练方案编号）](#221-getnewplanid)
        - [2.2.2. storePlan（存储训练方案）](#222-storeplan)
        - [2.2.3. getPlan（获取训练方案）](#223-getplan)
        - [2.2.4. getAllPlan（获取所有训练方案）](#224-getallplan)
        - [2.2.5. removePlan（移除训练方案）](#225-removeplan)
    - [2.3. STEvalPlan-related Interface](#22-stevalplan-related-interface)
        - [2.3.1. getNewEvalPlanID（获取新评估方案编号）](#231-getnewevalplanid)
        - [2.3.2. storeEvalPlan（存储评估方案）](#232-storeevalplan)
        - [2.3.3. getEvalPlan（获取评估方案）](#233-getevalplan)
        - [2.3.4. getAllEvalPlan（获取所有评估方案）](#234-getallevalplan)
        - [2.3.5. removeEvalPlan（移除评估方案）](#235-removeevalplan)
    - [2.4. STTask-related Interface](#24-sttask-related-interface)
        - [2.4.1. getNewTaskID（获取新训练任务编号）](#241-getnewtaskid)
        - [2.4.2. storeTask（存储训练任务）](#242-storetask)
        - [2.4.3. getTask（获取训练任务）](#243-gettask)
        - [2.4.4. getAllTask（获取所有训练任务）](#244-getalltask)
        - [2.4.5. removeTask（移除训练任务）](#245-removetask)
        - [2.4.6. startTask（启动训练任务）](#246-starttask)
        - [2.4.7. pauseTask（暂停训练任务）](#247-pausetask)
        - [2.4.8. resumeTask（恢复训练任务）](#248-resumetask)
        - [2.4.9. endTask（结束训练任务）](#249-endtask)
        - [2.4.10. evalTask（评估训练任务）](#2410-evaltask)
    - [2.5. STSql-related Interface](#25-stsql-related-interface)
        - [2.5.1. exeRemoteSql（执行SQL命令）](#251-exeremotesql)
    - [2.6. STDev-related Interface](#26-stdev-related-interface)
        - [2.6.1. getAllDevInfo（获取所有装备信息）](#261-getalldevinfo)
    - [2.7. STDevActList-related Interface](#27-stdevactlist-related-interface)
        - [2.7.1. getDevActList（获取装备动作清单）](#271-getdevactlist)

## 1. Protocol Buffers Structure

优先参考[STSgRPC.proto](../sts-server/src/proto/STSgRPC.proto)

### 1.1. Basic Structure

本节阐述了模拟训练软件gRPC服务中的基本数据类型

#### 1.1.1 STError

下列数据结构用于描述**错误信息**

```proto
message STError {
    string code = 1;    // 错误码
    string note = 2;    // 提示
    string time = 3;    // 时间
}
```

#### 1.1.2. STFile

下列数据结构用于描述**文件信息**

```proto
message STFile {
    string  URL     = 1;    // 文件远端地址
    string  type    = 2;    // 文件类型 {txt, json, xml, md, ...}
    bytes   stream  = 3;    // 文件二进制流
    STError error   = 4;
}
```

参考：

- [1.1.1. STError](#111-sterror)

#### 1.1.3. STPlanType

下列数据结构用于描述**模拟训练方案类型**

```proto
enum STPlanType {
    MULTI_POST_REAL_TARGET          = 0;    // 多哨所真实目标
    SINGLE_POST_REAL_TARGET         = 1;    // 单哨所真实目标
    SINGLE_POST_VIRTUAL_RAND_TARGET = 2;    // 单哨所虚拟随机目标
    SINGLE_POST_VIRTUAL_GENE_TARGET = 3;    // 单哨所虚拟生成目标
}
```

### 1.2. STPlan

下列数据结构用于描述**模拟训练方案**

```proto
message STPlan {
    uint64      ID          = 1;    // 训练方案编号
    string      creatorID   = 2;    // 创建者编号
    string      name        = 3;    // 名称
    string      goal        = 4;    // 目标
    STPlanType  type        = 5;    // 类型
    string      source      = 6;    // 来源 {CMD_CENTER_<id>: 指挥中心编号, POST_<id>: 哨所编号}
    string      fileURL     = 7;    // 文件地址
    string      createTime  = 8;    // 创建时间
    STError     error       = 9;
}
```

参考：

- [1.1.1. STError](#111-sterror)

### 1.3 STEvalPlan

下列数据结构用于描述**模拟训练评估方案**

```proto
message STEvalPlan {
    uint64  ID          = 1;    // 评估方案编号
    string  creatorID   = 2;    // 创建者编号
    string  name        = 3;    // 名称
    string  desc        = 4;    // 描述
    string  source      = 5;    // 来源 {CMD_CENTER_<id>: 指挥中心编号, POST_<id>: 哨所编号}
    string  fileURL     = 6;    // 文件地址
    string  createTime  = 7;    // 创建时间
    STError error       = 8;
}
```

参考：

- [1.1.1. STError](#111-sterror)

### 1.4. STTask

下列数据结构用于描述**模拟训练任务**

```proto
message STTask {
    uint64  ID              = 1;    // 任务编号
    string  creatorID       = 2;    // 创建者编号
    uint64  planID          = 3;    // 训练方案编号
    uint64  evalPlanID      = 4;    // 评估方案编号
    string  evalUserID      = 5;    // 评估者编号
    string  evalResult      = 6;    // 评估结果
    string  name            = 7;    // 名称
    string  createTime      = 8;    // 创建时间
    string  startTime       = 9;    // 启动时间
    string  endTime         = 10;   // 终止时间
    uint64  maxDuration     = 11;   // 最大时长
    string  processFileURL  = 12;   // 过程记录文件地址
    STError error           = 13;
}
```

参考：

- [1.1.1. STError](#111-sterror)

### 1.5. STSql

下列数据结构用于描述**模拟训练SQL命令**

```proto
message STSql {
    string      sql      = 1;   // sql命令
    STTask      task     = 2;   // sql执行结果（1）
    STPlan      plan     = 3;   // sql执行结果（2）
    STEvalPlan  evalPlan = 4;   // sql执行结果（3）
    STError     error    = 5;
}
```

参考：

- [1.4. STTask](#14-sttask)
- [1.2. STPlan](#12-stplan)
- [1.3. STEvalPlan](#13-stevalplan)
- [1.1.1. STError](#111-sterror)

### 1.6. STDev

下列数据结构用于描述**模拟训练装备**

```proto
message STDev {
    uint32  postID = 1;
    DevMsg  devMsg = 2;
    STError error  = 3;
}
```

其中`DevMsg`在[STSgRPC.proto](../sts-server/src/proto/STSgRPC.proto)中有如下定义

```proto
message DevMsg  {
    string      devID                   = 1;    // 设备编号
    int32       devType                 = 2;    // 设备类型 {1: 雷达, 2: 戈壁一型光电, 3: 戈壁二型光电, 4: 山区型光电, 5: 无人车}
    int32       devPostID               = 3;    // 哨所编号
    int32       devStatus               = 4;    // 设备状态 {1: 在线, 2: 离线}
    int32       devWorkStatus           = 5;    // 工作状态 {1: ZZ, 2: 单机训练, 3: 联机训练, 4: 单机测试维护, 5: 联机测试维护, 6: 其他}
    int32       devWorkMode             = 6;    // 工作模式 雷达: {1: 雷达扫描TWS, 2: 雷达跟踪TWS, 3: 雷达其他}
                                                //         光电：{1: 搜索警戒, 2: 目标跟踪, 3: 手动远程控制, 4: 预置点巡检(G2), 5: 自动扫描监视(G2), 6: 自动跟踪(G2), 7: 待机}
                                                //         无人车：{1: 自主巡逻模式, 2: 抵进侦察模式, 3: 无人值守模式, 4: 物资转运模式, 5: 遥控模式, 6: 待机, 7: 一键返回}
    string      devName                 = 7;    // 设备名称
    string      devIp                   = 8;     
    int32       devPort                 = 9;
    int32       lng                     = 10;   // 设备经度
    int32       lat                     = 11;   // 设备纬度
    int32       height                  = 12;   // 设备海拔
    int32       disAccuracy             = 14;   // 距离精度
    int32       orientationAccuracy     = 15;   // 方位精度
    int32       pitchAccuracy           = 16;   // 俯仰精度
    int32       workDisMan              = 17;   // 最大作用距离(人)
    int32       workDisCar              = 18;   // 最大作用距离(车)
    int32       workMinDis              = 19;   // 最小作用距离
    int32       orientationBng          = 20;   // 方位覆盖起始
    int32       orientationEnd          = 21;   // 方位覆盖终止
    int32       pitchBng                = 22;   // 俯仰覆盖起始
    int32       pitchEnd                = 23;   // 俯仰覆盖终止
    int32       tower                   = 24;   // 装备所属塔
    repeated    subDevInfo subDevMsg    = 25;   // 子设备信息
    string      errDescription          = 26;   // 错误描述
    string      description             = 27;   // 描述
    string      loginName               = 28;   // 登录名
    string      loginPwd                = 29;   // 登录密码
    int32       priority                = 30;   // 设备优先级
    int32       takeOver                = 31;   // 是否被接管 {1: 正常, 2: 被接管}
    int32       deviceNo                = 32;   // 设备序列号

    int32       errTimes                = 33;   // 故障次数
    repeated    string errInfo          = 34;   // 故障原因
    repeated    string adviceInfo       = 35;   // 处理建议
    int32       healthStatus            = 36;   // 整体健康状态 {1: 关机, 2: 正常, 3: 预警, 4: 降级, 5: 故障}
}

message subDevInfo {
    int32       id                      = 1;    // 子设备编号
    string      subDevName              = 2;    // 子设备名称
    int32       channelNo               = 3;    // 子设备通道号
    int32       subDevType              = 4;    // 子设备类型 {1: 光电-可见光视频, 2: 光电-红外视频, 3: 光电-图片, 4: 无人车-光电视频, 5: 无人车-行车视频}
    int32       connectType             = 5;    // 链接类型
    string      url                     = 6;    // 取流地址
    string      ip                      = 7;    // ip地址
    int32       port                    = 8;    // 端口
}
```

参考：

- [1.1.1. STError](#111-sterror)

### 1.7. STDevActList

下列数据结构用于描述**模拟训练装备动作清单**

```proto
message STDevAct {
    string      URI                     = 1;    // 装备动作标识
    string      desc                    = 2;    // 装备动作描述（中文简体）
}

message STDevActList {
    repeated STDevAct radarActs         = 1;    // 雷达动作事件
    repeated STDevAct camera1Acts       = 2;    // 戈壁Ⅰ型光电动作事件
    repeated STDevAct camera2Acts       = 3;    // 戈壁Ⅱ型光电动作事件
    repeated STDevAct camera3Acts       = 4;    // 山区型光电动作事件
    repeated STDevAct vehicleActs       = 5;    // 无人车动作事件
}
```

### 1.8. STSituInfo

下列数据结构用于描述**模拟训练态势信息**

```proto
message STSituInfo {
    STRadarInfo     radarInfo           = 1;    // 雷达上报信息
    STCameraInfo    cameraInfo          = 2;    // 光电上报信息
    STVehicleInfo   vehicleInfo         = 3;    // 无人车上报信息
}

message STRadarInfo {
    int32                devType        = 1;    // 装备类型 {100: 雷达, 101: 光电, 102: 无人车}
    int32                postId         = 2;    // 哨所编号
    string               devId          = 3;    // 装备编号
    string               time           = 4;    // 消息上报时间 (yyyy-mm-dd h:m:s.ms)
    STRadarPointInfo     pointInfo      = 5;    // 雷达点迹信息
    STRadarTrackInfo     trackInfo      = 6;    // 雷达航迹信息
    STRadarTargetInfo    targetInfo     = 7;    // 雷达目标信息
    STRadarInterfereInfo interfereInfo  = 8;    // 雷达干扰侦察信息
}

message STRadarPointInfo {
    int32     bandAngle                 = 1;    // 波束方位指向
    int32     scanCycle                 = 2;    // 扫描周期
    int32     tagNum                    = 3;    // 目标个数

    message   tag {
        string  time                        = 1;    // 目标时间
        int32   dis                         = 2;    // 目标距离 (单位 0.1米)
        int32   orientation                 = 3;    // 目标方位 (单位 0.01度)
        int32   pitch                       = 4;    // 目标俯仰 (单位 0.01度)
        int32   longitude                   = 5;    // 目标经度 (单位 0.0000001度)
        int32   latitude                    = 6;    // 目标纬度 (单位 0.0000001度)
        int32   height                      = 7;    // 目标高度 (单位 0.1米)
        int32   strength                    = 8;    // 目标强度
        int32   speed                       = 9;    // 目标速度 (单位 0.1米/秒)
    }
    repeated tag    tagInfo             = 4;    // 目标信息
}

message STRadarTrackInfo {
    int32     scanCycle                 = 1;    // 扫描周期
    int32     tagNum                    = 2;    // 目标个数

    message   tag {
        int32   tagId                       = 1;    // 目标批号
        int32   guidanceBatch               = 2;    // 目标引导批号
        string  time                        = 3;    // 目标时间 (yyyy-mm-dd h:m:s.ms)
        int32   dis                         = 4;    // 目标距离 (单位 0.1米)
        int32   orientation                 = 5;    // 目标方位 (单位 0.01度)
        int32   pitch                       = 6;    // 目标俯仰 (单位 0.01度)
        int32   longitude                   = 7;    // 目标经度 (单位 0.0000001度)
        int32   latitude                    = 8;    // 目标纬度 (单位 0.0000001度)
        int32   height                      = 9;    // 目标高度 (单位 0.1米)
        int32   strength                    = 10;   // 目标强度
        int32   speed                       = 11;   // 目标速度 (单位 0.1米/秒)
        int32   course                      = 12;   // 目标航向 (单位 0.01度)
        int32   tagType                     = 13;   // 目标类型 {1: 车, 2: 人, 3: 低慢小}
        int32   threat                      = 14;   // 目标威胁等级
    }
    repeated tag    tagInfo             = 3;    // 目标信息
}

message STRadarTargetInfo {
    int32     scanCycle                 = 1;    // 扫描周期
    int32     tagNum                    = 2;    // 目标个数

    message   tag {
        int32   tagId                       = 1;    // 目标批号
        int32   guidanceBatch               = 2;    // 目标引导批号
        string  time                        = 3;    // 目标时间 (yyyy-mm-dd h:m:s.ms)
        int32   dis                         = 4;    // 目标距离 (单位 0.1米)
        int32   orientation                 = 5;    // 目标方位 (单位 0.01度)
        int32   pitch                       = 6;    // 目标俯仰 (单位 0.01度)
        int32   longitude                   = 7;    // 目标经度 (单位 0.0000001度)
        int32   latitude                    = 8;    // 目标纬度 (单位 0.0000001度)
        int32   height                      = 9;    // 目标高度 (单位 0.1米)
        int32   strength                    = 10;   // 目标强度
        int32   speed                       = 11;   // 目标速度 (单位 0.1米/秒)
        int32   course                      = 12;   // 目标航向 (单位 0.01度)
        int32   tagType                     = 13;   // 目标类型 {1: 车, 2: 人, 3: 低慢小}
        int32   threat                      = 14;   // 目标威胁等级
    }
    repeated tag    tagInfo             = 3;    // 目标信息
}

message STRadarInterfereInfo {
    int32     interfereNum              = 1;    // 干扰个数

    message   interfere {
        string  time                        = 1;    // 干扰时间 (yyyy-mm-dd h:m:s.ms)
        int32   orientation                 = 2;    // 干扰方位 (单位 0.01度)
        int32   frequencyPoint              = 3;    // 干扰频点 (单位 1MHz)
        int32   band                        = 4;    // 干扰带宽 (单位 1MHz)
        int32   style                       = 5;    // 干扰样式
        int32   frequency                   = 6;    // 干扰频率 (单位 1MHz)
    }
    repeated interfere  interfereInfo   = 2;    // 目标信息
}

message STCameraInfo {
    int32               devType         = 1;    // 装备类型 {100: 雷达, 101: 光电, 102: 无人车}
    int32               postId          = 2;    // 哨所编号
    string              devId           = 3;    // 装备编号
    string              time            = 4;    // 消息上报时间 (yyyy-mm-dd h:m:s.ms)
    STCameraStatusInfo  statusInfo      = 5;    // 光电工作状态信息
    STCameraTargetInfo  targetInfo      = 6;    // 光电目标信息
    STCameraPictureInfo pictureInfo     = 7;    // 光电图像信息
    STCameraSeekData    seekData        = 8;    // 光电搜索数据
}

message STCameraStatusInfo {
    int32   longitude                   = 1;    // 目标经度 (单位 0.0000001度)
    int32   latitude                    = 2;    // 目标纬度 (单位 0.0000001度)
    int32   height                      = 3;    // 目标高度 (单位 0.1米)
    int32   deflection                  = 4;    // 偏北角 (单位 0.01度)
    int32   infraredState               = 5;    // 红外探测器状态 {0: 正常}
    int32   visibleState                = 6;    // 可见光相机状态 {0: 正常}    TODO: `viseble` is an invalid word
    int32   servoState                  = 7;    // 伺服控制状态 {0: 正常}
    int32   disState                    = 8;    // 测距机状态 {0: 正常}
    int32   picHandleState              = 9;    // 图像处理状态 {0: 正常}
    int32   tagHandleState              = 10;   // 目标分类状态 {0: 正常}
    int32   lockState                   = 11;   // 机械锁状态状态 {0: 正常}
    int32   frgState                    = 12;   // 红外制冷机状态 {0: 正常}
    int32   workMode                    = 13;   // 光电工作模式 {0x01: 搜索JJ, 0x02: 目标跟踪, 0x03: 手动远程控制, 0x04: 预置点巡检(G2), 0x05: 自动扫描监视(G2), 0x06: 自动跟踪(G2), 0x07: 待机, 其他:无效}
    int32   workState                   = 14;   // 光电工作状态 {0x01: zz, 0x02: 单机训练, 0x03: 联网训练, 0x04: 单机测试维护, 0x05: 联机测试维护, 其他: 无效}
    int32   orientation                 = 15;   // 光电目标方位 (单位 0.01度)
    int32   pitch                       = 16;   // 光电目标俯仰 (单位 0.01度)
    int32   redFocal                    = 17;   // 光电红外焦距 (单位 1毫米)
    int32   redFocusing                 = 18;   // 光电红外对焦   TODO: ask Mao Li Quan
    int32   focal                       = 19;   // 光电可见光焦距 (单位 0.01度)
    int32   focusing                    = 20;   // 光电可见光对焦  TODO: ask Mao Li Quan
}

message STCameraTargetInfo {
    int32   tagId                       = 1;    // 目标批号
    int32   guidanceBatch               = 2;    // 目标引导批号
    int32   orientation                 = 3;    // 目标方位 (单位 0.01度)
    int32   pitch                       = 4;    // 目标俯仰 (单位 0.01度)
    int32   slopeDis                    = 5;    // 目标斜距 (单位 0.1米)
    int32   speed                       = 6;    // 目标速度 (单位 0.1米/秒)
    int32   longitude                   = 7;    // 目标经度 (单位 0.0000001度)
    int32   latitude                    = 8;    // 目标纬度 (单位 0.0000001度)
    int32   height                      = 9;    // 目标高度 (单位 0.1米)
    int32   tagType                     = 10;   // 目标类型 {1: 车, 2: 人, 3: 低慢小}
    int32   threat                      = 11;   // 目标威胁等级
    int32   abnormalBehavior            = 12;   // 目标异常行为   TODO: `dystropic` is an invalid word
    int32   traceState                  = 13;   // 目标跟踪状态 {0x01: 稳定跟踪, 其他: 目标丢失}
    string  time                        = 14;   // 目标时间 (yyyy-mm-dd h:m:s.ms)
}

message STCameraPictureInfo {
    int32   sChId                       = 1;    // 通道号
    int32   iOrientation                = 2;    // 方位 (单位 0.0001度)
    int32   sFocal                      = 3;    // 焦距 (单位 1毫米)
    int32   iPitch                      = 4;    // 俯仰 (单位 0.0001度)
    int32   sPix                        = 5;    // 像元尺寸 (单位 1微米)
    int32   sPicId                      = 6;    // 图像流水号
    string  originPicUrl                = 7;    // 原始图像URL
    string  thumbnailPicUrl             = 8;    // 缩略图URL
}

message STCameraSeekData {
    int32   picId                       = 1;    // 图像流水号
    int32   chId                        = 2;    // 通道号
    int32   tagNum                      = 3;    // 目标个数

    message tag {
        int32   tagId                       = 1;    // 目标批号
        int32   orientation                 = 2;    // 目标方位 (单位 0.01度)
        int32   pitch                       = 3;    // 目标俯仰 (单位 0.01度)
        int32   slopeDis                    = 4;    // 目标斜距 (单位 0.1米)
        int32   speed                       = 5;    // 目标速度 (单位 0.1米/秒)
        int32   threat                      = 6;    // 目标威胁等级
        int32   abnormalBehavior            = 7;    // 目标异常行为   TODO: `dystropic` is an invalid word
        string  time                        = 8;    // 目标时间 (yyyy-mm-dd h:m:s.ms)
    }
    repeated tag tagInfo                = 4;    // 目标信息
}

message STVehicleInfo {
    int32                devType        = 1;    // 装备类型 {100: 雷达, 101: 光电, 102: 无人车}
    int32                postId         = 2;    // 哨所编号
    string               devId          = 3;    // 装备编号
    string               time           = 4;    // 消息上报时间 (yyyy-mm-dd h:m:s.ms)
}
```

## 2. gRPC Service Interface

### 2.1. STFile-related Interface

#### 2.1.1. storeRemoteFile

存储（更新）文件到远端（双端流式RPC服务，可存储（更新）多个文件）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * write file(s) to remote
     *
     * REQ DATA FIELDS:     STFile->stream          NOT NULL
     *                      STFile->type
     *
     * REP DATA FIELDS:     STFile->URL
     *                      STFile->error
     */

    rpc storeRemoteFile(stream STFile) returns (stream STFile) {}
}
```

参考：

- [1.1.2. STFile](#112-stfile)

用法：

```cpp
#include "Base.h"
#include <fstream>
#include <grpc/grpc.h>
#include <grpcpp/channel.h>
#include <grpcpp/client_context.h>
#include <grpcpp/create_channel.h>
#include <grpcpp/security/credentials.h>

#include "STSgRPC.grpc.pb.h"

using namespace grpc;
using namespace srpc;

class STSRPCClient final {
public:
    STSRPCClient() = delete;

    ~STSRPCClient() noexcept = default;

    explicit STSRPCClient(const std::string &addr) : channel(CreateChannel(addr, InsecureChannelCredentials())), stub(STSgRPC::NewStub(channel)) {
        if (!channel || !stub)
            LOG_ERR("error creating channel or stub");
    }

    inline std::unique_ptr<srpc::STSgRPC::Stub> &getStub() { return stub; }

private:
    std::shared_ptr<grpc::Channel> channel;
    std::unique_ptr<srpc::STSgRPC::Stub> stub;
};

void createRemoteFileByRPC() {
    Status status;
    ClientContext ctx;

    STFile reqFile;
    STFile repFile;
    
    const std::string type = "xml";
    const std::string addr = "192.168.10.131:50051";
    const std::vector<std::string> filenames = {"/home/dry/test/sts10.xml"};

    STSRPCCLient rpcClient(addr);

    std::shared_ptr<ClientReaderWriter<STFile, STFile>> stream(rpcClient.getStub()->storeRemoteFile(&ctx));

    for (const auto & filename : filenames) {
        /* read binary file stream */
        ifstream ifs(filename, std::ios::in | std::ios::binary);
        std::string fileStream((std::istreambuf_iterator<char>(ifs)), std::istreambuf_iterator<char>());
        ifs.close();

        /* build request */
        reqFile.set_type(type);
        reqFile.set_stream(fileStream);

        /* write request to grpc stream */
        stream->Write(reqFile);
        LOG_INFO("send req by createRemoteFile():\n%s", reqFile.DebugString().c_str());

        /* read reply from grpc stream */
        stream->Read(&repFile);
        LOG_INFO("recv rep by createRemoteFile():\n%s", repFile.DebugString().c_str());
    }

    stream->WritesDone();
    status = stream->Finish();

    if (!status.ok())
        LOG_ERR("error calling storeRemoteFile()");
}
```

#### 2.1.2. getRemoteFile

获取文件从远端（双端流式RPC服务，可获取多个文件）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * read file(s) from remote
     *
     * REQ DATA FIELDS:     STFile->URL             NOT NULL
     *                      STFile->type
     *
     * REP DATA FIELDS:     STFile->URL
     *                      STFile->stream
     *                      STFile->error
     */

    rpc getRemoteFile(stream STFile) returns (stream STFile) {}
}
```

参考：

- [1.1.2. STFile](#112-stfile)

用法：

```cpp
#include "Base.h"
#include <fstream>
#include <grpc/grpc.h>
#include <grpcpp/channel.h>
#include <grpcpp/client_context.h>
#include <grpcpp/create_channel.h>
#include <grpcpp/security/credentials.h>

#include "STSgRPC.grpc.pb.h"

using namespace grpc;
using namespace srpc;

class STSRPCClient final {
public:
    STSRPCClient() = delete;

    ~STSRPCClient() noexcept = default;

    explicit STSRPCClient(const std::string &addr) : channel(CreateChannel(addr, InsecureChannelCredentials())), stub(STSgRPC::NewStub(channel)) {
        if (!channel || !stub)
            LOG_ERR("error creating channel or stub");
    }

    inline std::unique_ptr<srpc::STSgRPC::Stub> &getStub() { return stub; }

private:
    std::shared_ptr<grpc::Channel> channel;
    std::unique_ptr<srpc::STSgRPC::Stub> stub;
};

void getRemoteFileByRPC() {
    Status status;
    ClientContext ctx;

    STFile reqFile;
    STFile repFile;
    
    const std::string type = "xml";
    const std::string addr = "192.168.10.131:50051";
    const std::vector<std::string> fileURLs = {"http://192.168.10.24:9558/yrvjtxwqamodwpb1611799431954.xml"};

    STSRPCCLient rpcClient(addr);

    std::shared_ptr<ClientReaderWriter<STFile, STFile>> stream(rpcClient.getStub()->storeRemoteFile(&ctx));

    for (const auto & fileURL : fileURLs) {
        std::string filename = "tmp.xml";

        /* build request */
        reqFile.set_type(type);
        reqFile.set_url(fileURL);

        /* write request to grpc stream */
        stream->Write(reqFile);
        LOG_INFO("send req by getRemoteFileByRPC():\n%s", reqFile.DebugString().c_str());

        /* read reply from grpc stream */
        stream->Read(&repFile);
        LOG_INFO("recv rep by getRemoteFileByRPC():\n%s", repFile.DebugString().c_str());

        /* write binary file stream */
        ofstream ofs(filename, std::ios::out | std::ios::binary);
        ofs << repFile.stream();
        ofs.close();
    }

    stream->WritesDone();
    status = stream->Finish();

    if (!status.ok())
        LOG_ERR("error calling getRemoteFileByRPC()");
}
```

### 2.2. STPlan-related Interface

#### 2.2.1. getNewPlanID

获取新训练方案编号

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get new PLAN_ID
     *
     * REQ DATA FIELDS:
     *
     * REP DATA FIELDS:     STPlan->ID
     *                      STPlan->error
     */

    rpc getNewPlanID(STPlan) returns (STPlan) {}
}
```

参考：

- [1.2. STPlan](#12-stplan)

用法：

```cpp
#include "Base.h"
#include <grpc/grpc.h>
#include <grpcpp/channel.h>
#include <grpcpp/client_context.h>
#include <grpcpp/create_channel.h>
#include <grpcpp/security/credentials.h>

#include "STSgRPC.grpc.pb.h"

using namespace grpc;
using namespace srpc;

class STSRPCClient final {
public:
    STSRPCClient() = delete;

    ~STSRPCClient() noexcept = default;

    explicit STSRPCClient(const std::string &addr) : channel(CreateChannel(addr, InsecureChannelCredentials())), stub(STSgRPC::NewStub(channel)) {
        if (!channel || !stub)
            LOG_ERR("error creating channel or stub");
    }

    inline std::unique_ptr<srpc::STSgRPC::Stub> &getStub() { return stub; }

private:
    std::shared_ptr<grpc::Channel> channel;
    std::unique_ptr<srpc::STSgRPC::Stub> stub;
};

uint64_t getNewPlanIDByRPC() {
    ClientContext ctx;
    Status status;

    STPlan reqPlan;
    STPlan repPlan;

    STSRPCCLient rpcClient(addr);

    status = rpcClient.getStub()->getNewPlanID(&ctx, reqPlan, &repPlan);
    
    STS_LOG_INFO("send req by getNewPlanID()");
    STS_LOG_INFO("recv rep by getNewPlanID():\n%s", repPlan.DebugString().c_str());

    return repPlan.id();
}
```

#### 2.2.2. storePlan

存储（或更新）训练方案（双端流式RPC服务，可存储多个训练方案）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * create or update simulation training plan(s)
     *
     * REQ DATA FIELDS:     STPlan->ID              NOT NULL
     *                      STPlan->creatorID       NOT NULL
     *                      STPlan->name
     *                      STPlan->goal
     *                      STPlan->type            NOT NULL
     *                      STPlan->source          NOT NULL
     *                      STPlan->fileURL         NOT NULL
     *
     * REP DATA FIELDS:     STPlan->ID
     *                      STPlan->createTime
     *                      STPlan->error
     */

    rpc storePlan(stream STPlan) returns (stream STPlan) {}
}
```

参考：

- [1.2. STPlan](#12-stplan)

#### 2.2.3. getPlan

获取训练方案（双端流式RPC服务，可获取多个训练方案）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get simulation training plan(s)
     *
     * REQ DATA FIELDS:     STPlan->ID              NOT NULL
     *
     * REP DATA FIELDS:     STPlan->ID
     *                      STPlan->creatorID
     *                      STPlan->name
     *                      STPlan->goal
     *                      STPlan->type
     *                      STPlan->source
     *                      STPlan->fileURL
     *                      STPlan->createTime
     *                      STPlan->error
     */

    rpc getPlan(stream STPlan) returns (stream STPlan) {}
}
```

参考：

- [1.2. STPlan](#12-stplan)

#### 2.2.4. getAllPlan

获取全部训练方案（客户端流式RPC服务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get all the simulation training plan(s)
     *
     * REQ DATA FIELDS:
     *
     * REP DATA FIELDS:     STPlan->ID
     *                      STPlan->creatorID
     *                      STPlan->name
     *                      STPlan->goal
     *                      STPlan->type
     *                      STPlan->source
     *                      STPlan->fileURL
     *                      STPlan->createTime
     *                      STPlan->error
     */

    rpc getAllPlan(STPlan) returns (stream STPlan) {}
}
```

参考：

- [1.2. STPlan](#12-stplan)

#### 2.2.5 removePlan

移除训练方案（双端流式RPC服务，可移除多个训练方案）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * remove simulation training plan(s)
     *
     * REQ DATA FIELDS:     STPlan->ID              NOT NULL
     *
     * REP DATA FIELDS:     STPlan->error
     */

    rpc removePlan(stream STPlan) returns (stream STPlan) {}
}
```

参考：

- [1.2. STPlan](#12-stplan)

### 2.3. STEvalPlan-related Interface

#### 2.3.1. getNewEvalPlanID

获取新评估方案编号

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get new EVAL_PLAN_ID
     *
     * REQ DATA FIELDS:
     *
     * REP DATA FIELDS:     STEvalPlan->ID
     *                      STEvalPlan->error
     */

    rpc getNewEvalPlanID(STEvalPlan) returns (STEvalPlan) {}
}
```

参考：

- [1.3. STEvalPlan](#13-stevalplan)

#### 2.3.2. storeEvalPlan

存储（或更新）评估方案（双端流式RPC服务，可存储多个评估方案）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * create or update simulation training evaluation plan(s)
     *
     * REQ DATA FIELDS:     STEvalPlan->ID              NOT NULL
     *                      STEvalPlan->creatorID       NOT NULL
     *                      STEvalPlan->name
     *                      STEvalPlan->desc
     *                      STEvalPlan->source          NOT NULL
     *                      STEvalPlan->fileURL         NOT NULL
     *
     * REP DATA FIELDS:     STEvalPlan->ID
     *                      STEvalPlan->createTime
     *                      STEvalPlan->error
     */

    rpc storeEvalPlan(stream STEvalPlan) returns (stream STEvalPlan) {}
}
```

参考：

- [1.3. STEvalPlan](#13-stevalplan)

#### 2.3.3. getEvalPlan

获取评估方案（双端流式RPC服务，可获取多个评估方案）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get simulation training evaluation plan(s)
     *
     * REQ DATA FIELDS:     STEvalPlan->ID              NOT NULL
     *
     * REP DATA FIELDS:     STEvalPlan->ID
     *                      STEvalPlan->creatorID
     *                      STEvalPlan->name
     *                      STEvalPlan->desc
     *                      STEvalPlan->source
     *                      STEvalPlan->fileURL
     *                      STEvalPlan->createTime
     *                      STEvalPlan->error
     */

    rpc getEvalPlan(stream STEvalPlan) returns (stream STEvalPlan) {}
}
```

参考：

- [1.3. STEvalPlan](#13-stevalplan)

#### 2.3.4. getAllEvalPlan

获取全部评估方案（客户端流式RPC服务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get all the simulation training evaluation plan(s)
     *
     * REQ DATA FIELDS:
     *
     * REP DATA FIELDS:     STEvalPlan->ID
     *                      STEvalPlan->creatorID
     *                      STEvalPlan->name
     *                      STEvalPlan->desc
     *                      STEvalPlan->source
     *                      STEvalPlan->fileURL
     *                      STEvalPlan->createTime
     *                      STEvalPlan->error
     */

    rpc getAllEvalPlan(STEvalPlan) returns (stream STEvalPlan) {}
}
```

参考：

- [1.3. STEvalPlan](#13-stevalplan)

#### 2.3.5. removeEvalPlan

移除评估方案（双端流式RPC服务，可移除多个评估方案）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * remove simulation training evaluation plan(s)
     *
     * REQ DATA FIELDS:     STEvalPlan->ID              NOT NULL
     *
     * REP DATA FIELDS:     STEvalPlan->error
     */

    rpc removeEvalPlan(stream STEvalPlan) returns (stream STEvalPlan) {}
}
```

参考：

- [1.3. STEvalPlan](#13-stevalplan)

# 2.4. STTask-related Interface

#### 2.4.1. getNewTaskID

获取新模拟训练任务编号

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get new TASK_ID
     *
     * REQ DATA FIELDS:
     *
     * REP DATA FIELDS:     STTask->ID
     *                      STTask->error
     */

    rpc getNewTaskID(STTask) returns (STTask) {}
}
```

#### 2.4.2. storeTask

存储（或更新）模拟训练任务（双端流式RPC服务，可存储多个模拟训练任务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * create or update simulation training task(s)
     *
     * REQ DATA FIELDS:     STTask->ID                  NOT NULL
     *                      STTask->creatorID           NOT NULL
     *                      STTask->planID              NOT NULL
     *                      STTask->evalPlanID
     *                      STTask->name
     *                      STTask->maxDuration         NOT NULL
     *                      STTask->processFileURL
     *
     * REP DATA FIELDS:     STTask->ID
     *                      STTask->createTime
     *                      STTask->error
     */

    rpc storeTask(stream STTask) returns (stream STTask) {}
}
```

参考：

- [1.4. STTask](#14-sttask)

#### 2.4.3. getTask

获取模拟训练任务（双端流式RPC服务，可获取多个模拟训练任务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get simulation training task(s)
     *
     * REQ DATA FIELDS:     STTask->ID                  NOT NULL
     *
     * REP DATA FIELDS:     STTask->ID
     *                      STTask->creatorID
     *                      STTask->planID
     *                      STTask->evalPlanID
     *                      STTask->evalUserID
     *                      STTask->evalResult
     *                      STTask->name
     *                      STTask->createTime
     *                      STTask->startTime
     *                      STTask->endTime
     *                      STTask->maxDuration
     *                      STTask->processFileURL
     *                      STTask->error
     */

    rpc getTask(stream STTask) returns (stream STTask) {}
}
```

参考：

- [1.4. STTask](#14-sttask)

#### 2.4.4. getAllTask

获取全部模拟训练任务（客户端流式RPC服务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get all the simulation training task(s)
     *
     * REQ DATA FIELDS:
     *
     * REP DATA FIELDS:     STTask->ID
     *                      STTask->creatorID
     *                      STTask->planID
     *                      STTask->evalPlanID
     *                      STTask->evalUserID
     *                      STTask->evalResult
     *                      STTask->name
     *                      STTask->createTime
     *                      STTask->startTime
     *                      STTask->endTime
     *                      STTask->maxDuration
     *                      STTask->processFileURL
     *                      STTask->error
     */

    rpc getAllTask(STTask) returns (stream STTask) {}
}
```

参考：

- [1.4. STTask](#14-sttask)

#### 2.4.5. removeTask

移除模拟训练任务（双端流式RPC服务，可移除多个模拟训练任务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * remove simulation training task(s)
     *
     * REQ DATA FIELDS:     STTask->ID                  NOT NULL
     *
     * REP DATA FIELDS:     STTask->error
     */

    rpc removeTask(stream STTask) returns (stream STTask) {}
}
```

参考：

- [1.4. STTask](#14-sttask)

#### 2.4.6. startTask

启动模拟训练任务（双端流式RPC服务，可启动多个模拟训练任务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * start simulation training task(s)
     *
     * REQ DATA FIELDS:     STTask->ID                  NOT NULL
     *
     * REP DATA FIELDS:     STTask->ID
     *                      STTask->startTime
     *                      STTask->error
     */

    rpc startTask(stream STTask) returns (stream STTask) {}
}
```

参考：

- [1.4. STTask](#14-sttask)

#### 2.4.7. pauseTask

暂停模拟训练任务（双端流式RPC服务，可暂停多个模拟训练任务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * pause simulation training task(s)
     *
     * REQ DATA FIELDS:     STTask->ID                  NOT NULL
     *
     * REP DATA FIELDS:     STTask->ID
     *                      STTask->error
     */

    rpc pauseTask(stream STTask) returns (stream STTask) {}
}
```

参考：

- [1.4. STTask](#14-sttask)

#### 2.4.8. resumeTask

继续模拟训练任务（双端流式RPC服务，可继续多个模拟训练任务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * resume simulation training task(s)
     *
     * REQ DATA FIELDS:     STTask->ID                  NOT NULL
     *
     * REP DATA FIELDS:     STTask->ID
     *                      STTask->error
     */

    rpc resumeTask(stream STTask) returns (stream STTask) {}
}
```

参考：

- [1.4. STTask](#14-sttask)

#### 2.4.9. endTask

结束模拟训练任务（双端流式RPC服务，可结束多个模拟训练任务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * end simulation training task(s)
     *
     * REQ DATA FIELDS:     STTask->ID                  NOT NULL
     *
     * REP DATA FIELDS:     STTask->ID
     *                      STTask->endTime
     *                      STTask->error
     */

    rpc endTask(stream STTask) returns (stream STTask) {}
}
```

参考：

- [1.4. STTask](#14-sttask)

#### 2.4.10. evalTask

评估模拟训练任务（双端流式RPC服务，可评估多个模拟训练任务）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * evaluate simulation training task(s)
     *
     * REQ DATA FIELDS:     STTask->ID                  NOT NULL
     *                      STTask->evalPlanID          NOT NULL
     *
     * REP DATA FIELDS:     STTask->ID
     *                      STTask->evalResult
     *                      STTask->error
     */

    rpc evalTask(stream STTask) returns (stream STTask) {}
}
```

参考：

- [1.4. STTask](#14-sttask)

### 2.5. STSql-related Interface

#### 2.5.1. exeRemoteSql

**WARNING**: **Ask the developer how to use and use carefully**.

远程执行SQL命令（客户端流式RPC服务，可获取多个SQL执行结果）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * execute sql command by gRPC
     *
     * REQ DATA FIELDS:     STSql->sql                  NOT NULL
     *
     * REP DATA FIELDS:     STSql->task
     *                      STSql->plan
     *                      STSql->evalPlan
     *                      STSql->error
     */

    rpc exeRemoteSql(STSql) returns (stream STSql) {}
}
```

参考：

- [1.5. STSql](#15-stsql)

用法：

```cpp
#include "Base.h"
#include <grpc/grpc.h>
#include <grpcpp/channel.h>
#include <grpcpp/client_context.h>
#include <grpcpp/create_channel.h>
#include <grpcpp/security/credentials.h>

#include "STSgRPC.grpc.pb.h"

using namespace grpc;
using namespace srpc;

class STSRPCClient final {
public:
    STSRPCClient() = delete;

    ~STSRPCClient() noexcept = default;

    explicit STSRPCClient(const std::string &addr) : channel(CreateChannel(addr, InsecureChannelCredentials())), stub(STSgRPC::NewStub(channel)) {
        if (!channel || !stub)
            LOG_ERR("error creating channel or stub");
    }

    inline std::unique_ptr<srpc::STSgRPC::Stub> &getStub() { return stub; }

private:
    std::shared_ptr<grpc::Channel> channel;
    std::unique_ptr<srpc::STSgRPC::Stub> stub;
};

void exeRemoteSqlByRPC(const std::string &addr, const std::string &sql) {
    STSql reqSql;
    STSql repSql;
    Status status;
    ClientContext ctx;

    STSRPCCLient rpcClient(addr);

    /* build request */
    reqSql.set_sql(sql);

    /* call client-side streaming rpc method */
    std::unique_ptr<ClientReader<STSql>> reader(rpcClient.getStub()->exeRemoteSql(&ctx, reqSql));

    LOG_INFO("send req by exeRemoteSql():\n%s", reqSql.DebugString().c_str());

    /* read reply from stream */
    while (reader->Read(&repSql)) {
        LOG_INFO("recv rep by getAllPlan():\n%s", repSql.DebugString().c_str());

        // TODO: add code for processing reply
        //
        //
    }

    if (!status.ok())
        LOG_ERR("error calling exeRemoteSql()");
}
```

### 2.6. STDev-related Interface

#### 2.6.1. getAllDevInfo

获取所有装备信息（客户端流式RPC服务，可获取多个装备信息）

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get all the device info of post
     *
     * REQ DATA FIELDS:     STDev->postID               NOT NULL
     *
     * REP DATA FIELDS:     STDev->postID
     *                      STDev->devMsg
     *                      STDev->error
     *
     */

    rpc getAllDevInfo(STDev) returns (stream STDev) {}
}
```

参考：

- [1.6. STDev](#16-stdev)

### 2.7. STDevActList-related Interface

#### 2.7.1. getDevActList

获取装备动作清单

```proto
// STSgRPC.proto

syntax = "proto3";

package srpc;

service STSgRPC {

    /**
     * get list of device action
     *
     * REQ DATA FIELDS:
     *
     * REP DATA FIELDS:     STDevActList->radarActs
     *                      STDevActList->camera1Acts
     *                      STDevActList->camera2Acts
     *                      STDevActList->camera3Acts
     *                      STDevActList->vehicleActs
     *
     */

     rpc getDevActList(STDevActList) returns (STDevActList) {}
}
```

参考：

- [1.7. STDevActList](#17-stdevactlist)

---

***未完待续***

---

