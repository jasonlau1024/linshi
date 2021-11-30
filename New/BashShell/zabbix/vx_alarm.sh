#!/usr/bin/env bash
#########################################################
# 功能  ：企业微信告警
# 系统  ：CentOS Linux release 7.9.2009
# 版本  ：1.0
# 作者  ：Jason Lau
#########################################################
CorpID="xx"	# 企业id
Secret="xx"	# SecretID
GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CorpID&corpsecret=$Secret"
Token=$(/usr/bin/curl -s -G $GURL |awk -F\": '{print $4}'|awk -F\" '{print $2}')
# echo $Token
PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$Token"

function body(){
        local int agentid=1000002		# 你的agentdid
        local UserID="@all"                 # 发送的用户ID
        local PartyID=1                  # 部门ID
        local Msg=$(echo "$@" | cut -d" " -f3-)	# 发送给所有人
        printf '{\n'
        printf '\t"touser": "'"$UserID"\"",\n"
        printf '\t"toparty": "'"$PartyID"\"",\n"
        printf '\t"msgtype": "text",\n'
        printf '\t"agentid": "'"$agentid"\"",\n"
        printf '\t"text": {\n'
        printf '\t\t"content": "'"$Msg"\""\n"
        printf '\t},\n'
        printf '\t"safe":"0"\n'
        printf '}\n'
}
/usr/bin/curl --data-ascii "$(body $1 $2 $3)" $PURL