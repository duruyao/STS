# 模拟训练软件数据表

# Index

- [1. ST_PLAN_TB](#1-st_plan_tb)
- [2. ST_EVAL_PLAN_TB](#2-st_eval_plan_tb)
- [3. ST_TASK_TB](#3-st_task_tb)

## 1. ST_PLAN_TB

模拟训练**方案表**基本信息如下：

|  |  |
| :-: | :-: |
| **Table Name** | ST_PLAN_TB |
| **Primary Key** | / |
| **Table Constraints** | / |

模拟训练**方案表**字段如下：

| Key | Type | Decsription| Column Constraints | Optional Value | Unit of Measure |
| :-: | :-: | :-: | :-: | :-: | :-: |
| PLAN_ID | `BIGINT` | 训练方案编号 | NOT NULL UNIQUE | / | / |
| PLAN_CREATOR_ID | `VARCHAR(20)` | 创建者编号 | REFERENCES XXCC_USER_INFO (USER_ROW_ID) | / | / |
| PLAN_NAME | `VARCHAR(127)` | 训练方案名称 | DEFAULT 'NULL' | / | / |
| PLAN_GOAL | `VARCHAR(127)` | 训练方案目的描述 | DEFAULT 'NULL' | / | / |
| PLAN_TYPE | `VARCHAR(63)` | 训练方案类型 | NOT NULL |  `MULTI_POST_REAL_TARGET`: 多哨所真实目标<br>`SINGLE_POST_REAL_TARGET`: 单哨所真实目标<br>`SINGLE_POST_VIRTUAL_RAND_TARGET`: 单哨所虚拟随机目标<br>`SINGLE_POST_VIRTUAL_GENE_TARGET`: 单哨所虚拟生成目标 | / |
| PLAN_SOURCE | `VARCHAR(63)` | 训练方案来源 | NOT NULL | `CMD_CENTER_<id>`: 指挥中心编号<br>`POST_<id>`: 哨所编号 | / |
| PLAN_FILE_URL | `VARCHAR(127)` | 训练方案文件地址 | NOT NULL | / | / |
| PLAN_CREATE_TIME | `TIMESTAMP(3)` | 训练方案创建时间 | DEFAULT NOW() | / | / |

建表SQL如下：

```sql
CREATE TABLE ST_PLAN_TB (
    PLAN_ID BIGINT NOT NULL UNIQUE,
    PLAN_CREATOR_ID VARCHAR(20) REFERENCES XXCC_USER_INFO (USER_ROW_ID),
    PLAN_NAME VARCHAR(127) DEFAULT 'NULL',
    PLAN_GOAL VARCHAR(127) DEFAULT 'NULL',
    PLAN_TYPE VARCHAR(63) NOT NULL,
    PLAN_SOURCE VARCHAR(63) NOT NULL,
    PLAN_FILE_URL VARCHAR(127) NOT NULL,
    PLAN_CREATE_TIME TIMESTAMP(3) DEFAULT NOW()
)
```

## 2. ST_EVAL_PLAN_TB

模拟训练**评估方案表**基本信息如下：

|  |  |
| :-: | :-: |
| **Table Name** | ST_EVAL_PLAN_TB |
| **Primary Key** | / |
| **Table Constraints** | / |

模拟训练**评估方案表**字段如下：

| Key | Type | Decsription| Column Constraints | Optional Value | Unit of Measure |
| :-: | :-: | :-: | :-: | :-: | :-: |
| EVAL_PLAN_ID | `BIGINT` | 评估方案编号 | NOT NULL UNIQUE | / | / |
| EVAL_PLAN_CREATOR_ID | `VARCHAR(20)` | 创建者编号 | REFERENCES XXCC_USER_INFO (USER_ROW_ID) | / | / |
| EVAL_PLAN_NAME | `VARCHAR(127)` | 评估方案名称 | DEFAULT 'NULL' | / | / |
| EVAL_PLAN_DESC | `VARCHAR(127)` | 评估方案描述 | DEFAULT 'NULL' | / | / |
| EVAL_PLAN_SOURCE | `VARCHAR(63)` | 评估方案来源 | NOT NULL | `CMD_CENTER_<id>`: 指挥中心编号<br>`POST_<id>`: 哨所编号 | / |
| EVAL_PLAN_FILE_URL | `VARCHAR(127)` | 评估方案文件地址 | NOT NULL | / | / |
| EVAL_PLAN_CREATE_TIME | `TIMESTAMP(3)` | 评估方案创建时间 | DEFAULT NOW() | / | / |


建表SQL如下：

```sql
CREATE TABLE ST_EVAL_PLAN_TB (
    EVAL_PLAN_ID BIGINT NOT NULL UNIQUE,
    EVAL_PLAN_CREATOR_ID VARCHAR(20) REFERENCES XXCC_USER_INFO (USER_ROW_ID),
    EVAL_PLAN_NAME VARCHAR(127) DEFAULT 'NULL',
    EVAL_PLAN_DESC VARCHAR(127) DEFAULT 'NULL',
    EVAL_PLAN_SOURCE VARCHAR(63) NOT NULL,
    EVAL_PLAN_FILE_URL VARCHAR(127) NOT NULL,
    EVAL_PLAN_CREATE_TIME TIMESTAMP(3) DEFAULT NOW()
)
```

## 3. ST_TASK_TB

模拟训练**任务表**基本信息如下：

|  |  |
| :-: | :-: |
| **Table Name** | ST_TASK_TB |
| **Primary Key** | TASK_ID |
| **Table Constraints** | / |

模拟训练**任务表**字段如下：

| Key | Type | Decsription| Column Constraints | Optional Value | Unit of Measure |
| :-: | :-: | :-: | :-: | :-: | :-: |
| TASK_ID | `BIGINT` | 训练任务编号 | NOT NULL UNIQUE | / | / |
| TASK_CREATOR_ID | `VARCHAR(20)` | 训练任务创建者编号 | REFERENCES XXCC_USER_INFO (USER_ROW_ID) | / | / |
| PLAN_ID | `BIGINT` | 模拟训练方案编号 | REFERENCES ST_PLAN_TB (PLAN_ID) | / | / |
| EVAL_PLAN_ID | `BIGINT` | 训练任务评估方案编号 | DEFAULT 0 | / | / |
| EVAL_USER_ID | `VARCHAR(20)` | 训练任务评估者编号 | DEFAULT 'NULL' | / | / |
| EVAL_RESULT | `VARCHAR(1023)` | 训练任务评估结果 | DEFAULT 'NULL' | / | / |
| TASK_NAME | `VARCHAR(127)` | 训练任务名称 | DEFAULT 'NULL' | / | / |
| TASK_CREATE_TIME | `TIMESTAMP(3)` | 训练任务创建时间 | DEFAULT NOW() | / | / |
| TASK_START_TIME | `TIMESTAMP(3)` | 训练任务开始时间 | DEFAULT '1970-01-01 08:00:00.000' | / | / |
| TASK_END_TIME | `TIMESTAMP(3)` | 训练任务结束时间 | DEFAULT '1970-01-01 08:00:00.000' | / | / |
| TASK_MAX_DURATION | `BIGINT` | 训练任务预计最大时长 | NOT NULL<br>CHECK (TASK_MAX_DURATION > 0) | / | 1秒钟 |
| TASK_PROCESS_FILE_URL | `VARCHAR(127)` | 训练任务过程记录文件地址 | DEFAULT 'NULL' | / | / |

建表SQL如下：

```sql
CREATE TABLE ST_TASK_TB (
    TASK_ID BIGINT NOT NULL UNIQUE,
    TASK_CREATOR_ID VARCHAR(20) REFERENCES XXCC_USER_INFO (USER_ROW_ID),
    PLAN_ID BIGINT REFERENCES ST_PLAN_TB (PLAN_ID),
    EVAL_PLAN_ID BIGINT DEFAULT 0,
    EVAL_USER_ID VARCHAR(20) DEFAULT 'NULL',
    EVAL_RESULT VARCHAR(1023) DEFAULT 'NULL',
    TASK_NAME VARCHAR(127) DEFAULT 'NULL',
    TASK_CREATE_TIME TIMESTAMP(3) DEFAULT NOW(),
    TASK_START_TIME TIMESTAMP(3) DEFAULT '1970-01-01 08:00:00.000',
    TASK_END_TIME TIMESTAMP(3) DEFAULT '1970-01-01 08:00:00.000',
    TASK_MAX_DURATION BIGINT NOT NULL CHECK (TASK_MAX_DURATION > 0),
    TASK_PROCESS_FILE_URL VARCHAR(127) DEFAULT 'NULL'
)
```

---

***未完待续***

---