##### 背景

由于某些特殊场景下，在使用xxl-job任务调度的时候，可能没有办法到后台一个一个的手动创建，这时需要配合业务进行相关创建、启用、停止或者删除的操作，方便业务快速地与任务调度相结合，达到通过业务状态控制调度的逻辑。

## 相关代码 

### 响应参数 

1、通用响应参数

```go
package xxl_resp

type RespVO struct {
	Code    int    `json:"code"`
	Msg     string `json:"msg"`
	Content string `json:"content"`
}
```

2、分页查询响应参数 

```GO
package xxl

// 分页查询
type PageList struct {
	RecordsFiltered int            `json:"recordsFiltered"`
	Data            []PageListData `json:"data"`
	RecordsTotal    int            `json:"recordsTotal"`
}

// 业务数据
type PageListData struct {
	ID                    int    `json:"id"`
	JobGroup              int    `json:"jobGroup"`
	JobCron               string `json:"jobCron"`
	JobDesc               string `json:"jobDesc"`
	AddTime               int64  `json:"addTime"`
	UpdateTime            int64  `json:"updateTime"`
	Author                string `json:"author"`
	AlarmEmail            string `json:"alarmEmail"`
	ExecutorRouteStrategy string `json:"executorRouteStrategy"`
	ExecutorHandler       string `json:"executorHandler"`
	ExecutorParam         string `json:"executorParam"`
	ExecutorBlockStrategy string `json:"executorBlockStrategy"`
	ExecutorFailStrategy  string `json:"executorFailStrategy"`
	GlueType              string `json:"glueType"`
	GlueSource            string `json:"glueSource"`
	GlueRemark            string `json:"glueRemark"`
	GlueUpdatetime        int64  `json:"glueUpdatetime"`
	ChildJobID            string `json:"childJobId"`
	JobStatus             string `json:"jobStatus"`
}
```

### 请求参数

创建和修改任务

```GO
package xxl

// 新增/修改参数
type TaskVO struct {
	Id         string `json:"id"`
	JobDesc    string `json:"jobDesc"`
	JobCron    string `json:"jobCron"`
	GlueRemark string `json:"glueRemark"`
	GlueSource string `json:"glueSource"`
}
```

## 核心接口代码

```GO
package xxl

import (
	"encoding/json"
	"fmt"
	"github.com/go-resty/resty/v2"
	log "github.com/sirupsen/logrus"
	"net/http"
	xxlReq "common/vo/request/xxl"
	xxlResp "common/vo/response/xxl"
	"strconv"
	"strings"
	"time"
)

const (
	contentType = "application/x-www-form-urlencoded"
	// xxl
	xxlUrl    = "https://xxl.xxx.com/xxl-job-admin"
	xxlLogin  = "login"
	xxlAdd    = "jobinfo/add"
	xxlUpdate = "jobinfo/update"
	xxlRemove = "jobinfo/remove"
	// 2.0 之后 start
	xxlStart = "jobinfo/resume"
	// 2.0 之后stop
	xxlStop        = "jobinfo/pause"
	xxlPageList    = "jobinfo/pageList"
	xxlGetJobCode  = "jobcode?jobId="
	xxlSaveJobCode = "jobcode/save"
	// 默认的组
	jobGroup = "43"
)

// 新增调度任务,返回任务的Id
func ListIdByJobDesc(taskVO xxlReq.TaskVO, start, length string) (bool, []xxlResp.PageListData) {
	// 登录
	cookies := login()
	if cookies == nil {
		return false, nil
	}
	// 查询任务
	resp, err := resty.New().SetTimeout(time.Duration(5)*time.Second).R().
		SetCookies(cookies).
		SetQueryParam("jobGroup", jobGroup).
		SetQueryParam("jobDesc", taskVO.JobDesc).
		SetQueryParam("start", start).
		SetQueryParam("length", length).
		Post(fmt.Sprintf("%s%s", xxlUrl, xxlPageList))
	if err != nil {
		log.Errorf("查询任务异常:%s", err)
		return false, nil
	}
	// 反序列化
	var pageList xxlResp.PageList
	err = json.Unmarshal(resp.Body(), &pageList)
	if err != nil || pageList.Data == nil || pageList.RecordsTotal == 0 {
		log.Errorf("查询任务异常:%s", err)
		return false, nil
	}
	return true, pageList.Data
}

// 新增调度任务,返回任务的Id
func Add(taskVO xxlReq.TaskVO) (bool, string) {
	// 登录
	cookies := login()
	if cookies == nil {
		return false, "登录失败，请重试"
	}
	// 新增任务
	request := getRequest(cookies, taskVO)
	resp, err := request.Post(fmt.Sprintf("%s%s", xxlUrl, xxlAdd))
	if err != nil {
		log.Errorf("新增异常:%s", err)
		return false, "添加任务异常"
	}
	// 反序列化
	var respVO xxlResp.RespVO
	err = json.Unmarshal(resp.Body(), &respVO)
	if err != nil {
		log.Errorf("新增异常:%s", err)
		return false, "添加任务异常"
	}
	if respVO.Code == 200 {
		// 2.0 之后 Content 返回的主键，之前的没有
		if respVO.Content == "" {
			// 获取主键
			ok, pageListData := ListIdByJobDesc(taskVO, "0", "1")
			if !ok {
				return false, "查询任务数据失败"
			}
			data := pageListData[0]
			return true, strconv.Itoa(data.ID)
		}
		return true, respVO.Content
	}
	return false, respVO.Msg
}

// 修改调度任务
func Modify(taskVO xxlReq.TaskVO) (bool, string) {
	// 登录
	cookies := login()
	if cookies == nil || len(cookies) == 0 {
		return false, "登录失败，请重试"
	}
	// 修改任务
	resp, err := getRequest(cookies, taskVO).Post(fmt.Sprintf("%s%s", xxlUrl, xxlUpdate))
	if err != nil {
		log.Errorf("修改任务异常:%s", err)
		return false, "修改任务异常"
	}
	// 反序列化
	var respVO xxlResp.RespVO
	err = json.Unmarshal(resp.Body(), &respVO)
	if err != nil {
		log.Errorf("修改任务异常:%s", err)
		return false, "修改任务异常"
	}
	return respVO.Code == 200, respVO.Msg
}

// 删除调度任务
func Delete(id string) (bool, string) {
	// 登录
	cookies := login()
	if cookies == nil {
		return false, "登录失败，请重试"
	}
	// 新增任务
	resp, err := resty.New().SetTimeout(time.Duration(5)*time.Second).
		R().
		SetCookies(cookies).
		SetHeader("Content-Type", contentType).
		SetQueryParam("id", id).
		Post(fmt.Sprintf("%s%s", xxlUrl, xxlRemove))
	if err != nil {
		log.Errorf("删除任务异常:%s", err)
		return false, "删除任务异常"
	}
	// 反序列化
	var respVO xxlResp.RespVO
	err = json.Unmarshal(resp.Body(), &respVO)
	if err != nil {
		log.Errorf("删除任务异常:%s", err)
		return false, "删除任务异常"
	}
	return respVO.Code == 200, respVO.Msg
}

// 启用度任务
func Enable(id string) (bool, string) {
	// 登录
	cookies := login()
	if cookies == nil {
		return false, "登录失败，请重试"
	}
	// 启动任务
	resp, err := resty.New().SetTimeout(time.Duration(5)*time.Second).
		R().
		SetCookies(cookies).
		SetHeader("Content-Type", contentType).
		SetQueryParam("id", id).
		Post(fmt.Sprintf("%s%s", xxlUrl, xxlStart))
	if err != nil {
		log.Errorf("启用任务异常:%s", err)
		return false, "启动任务异常"
	}
	// 反序列化
	var respVO xxlResp.RespVO
	err = json.Unmarshal(resp.Body(), &respVO)
	if err != nil {
		log.Errorf("启用任务异常:%s", err)
		return false, "启动任务异常"
	}
	return respVO.Code == 200, "启动成功"
}

// 禁用调度任务
func Disabled(id string) (bool, string) {
	// 登录
	cookies := login()
	if cookies == nil {
		return false, "登录失败，请重试"
	}
	// 禁用任务
	resp, err := resty.New().SetTimeout(time.Duration(5)*time.Second).
		R().
		SetCookies(cookies).
		SetHeader("Content-Type", contentType).
		SetQueryParam("id", id).
		Post(fmt.Sprintf("%s%s", xxlUrl, xxlStop))
	if err != nil {
		log.Errorf("禁用任务异常:%s", err)
		return false, "禁用任务异常"
	}
	// 反序列化
	var respVO xxlResp.RespVO
	err = json.Unmarshal(resp.Body(), &respVO)
	if err != nil {
		log.Errorf("禁用任务异常:%s", err)
		return false, "禁用任务异常"
	}
	return respVO.Code == 200, "禁用成功"
}

// Shell 调度脚本
func GetShell(jobId string) (bool, string) {
	// 登录
	cookies := login()
	if cookies == nil {
		return false, "登录失败，请重试"
	}
	// 获取脚本
	resp, err := resty.New().SetTimeout(time.Duration(5) * time.Second).
		R().
		SetCookies(cookies).
		Get(fmt.Sprintf("%s%s%s", xxlUrl, xxlGetJobCode, jobId))
	if err != nil {
		log.Errorf("获取脚本异常:%s", err)
		return false, "获取脚本异常"
	}
	// 获取内容
	body := string(resp.Body())

	return true, body

}

// Shell 调度脚本
func SaveShell(id, glueSource, glueRemark string) (bool, string) {
	// 登录
	cookies := login()
	if cookies == nil {
		return false, "登录失败，请重试"
	}
	// 保存脚本
	resp, err := resty.New().SetTimeout(time.Duration(5)*time.Second).
		R().
		SetCookies(cookies).
		SetHeader("Content-Type", contentType).
		SetQueryParam("id", id).
		SetQueryParam("glueSource", glueSource).
		SetQueryParam("glueRemark", glueRemark).
		Post(fmt.Sprintf("%s%s", xxlUrl, xxlSaveJobCode))
	if err != nil {
		log.Errorf("保存脚本异常:%s", err)
		return false, "保存脚本异常"
	}
	// 反序列化
	var respVO xxlResp.RespVO
	err = json.Unmarshal(resp.Body(), &respVO)
	if err != nil {
		log.Errorf("保存脚本异常:%s", err)
		return false, "保存脚本异常"
	}
	return respVO.Code == 200, respVO.Msg
}

// 登录xxl, 可以新增缓存
func login() []*http.Cookie {
	resp, err := resty.New().SetTimeout(time.Duration(5)*time.Second).
		R().
		SetHeader("Content-Type", contentType).
		SetQueryParam("userName", "devops").
		SetQueryParam("password", "devops00").
		Post(fmt.Sprintf("%s%s", xxlUrl, xxlLogin))
	if err != nil {
		log.Errorf("登录异常:%s", err)
		return nil
	}
	return resp.Cookies()
}

// 获取新增、修改请求的参数
func getRequest(cookies []*http.Cookie, taskVO xxlReq.TaskVO) *resty.Request {
	request := resty.New().SetTimeout(time.Duration(5)*time.Second).
		R().
		SetCookies(cookies).
		SetHeader("Content-Type", contentType).
		SetQueryParam("jobGroup", jobGroup).
		SetQueryParam("jobDesc", taskVO.JobDesc).
		SetQueryParam("executorRouteStrategy", "FIRST").
		SetQueryParam("cronGen_display", taskVO.JobCron).
		SetQueryParam("jobCron", taskVO.JobCron).
		SetQueryParam("glueType", "GLUE_SHELL").
		SetQueryParam("executorHandler", "").
		SetQueryParam("executorBlockStrategy", "SERIAL_EXECUTION").
		SetQueryParam("executorFailStrategy", "FAIL_ALARM").
		SetQueryParam("childJobId", "").
		SetQueryParam("executorTimeout", "0").
		SetQueryParam("executorFailRetryCount", "0").
		SetQueryParam("author", xxxx").
		SetQueryParam("alarmEmail", "xxx@xxx.com").
		SetQueryParam("executorParam", "").
		SetQueryParam("glueRemark", "GLUE代码").
		SetQueryParam("glueSource", taskVO.GlueSource)

	if len(strings.TrimSpace(taskVO.Id)) > 0 {
		request.SetQueryParam("id", taskVO.Id)
	}
	
	return request

}
```


