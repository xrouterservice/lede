#!/bin/sh
#copyleft by xretia
#03-12: 更新请求验证机制
#03-11: 更新请求验证机制
#03-07: 解决路由器不支持纳秒随机数
#03-07: 解决提速成功但无效果，请手动删/tmp/xy_defuser
#03-05: 解决部分地区（如广东浙江）第二次使用出错
#03-04: 解决部分地区（如广东浙江）出错问题
#03-02: 修复 Padavan 等精简命令环境执行出错问题
#02-29: 第一版

#__终端彩色标记__
C_YELL="\033[33m"
C_REDD="\033[31m"
C_GREE="\033[32m"
C_BLUE="\033[34m"
C_END="\033[0m"

#__对于WebShell禁用彩色__
if [ "$TERM" = "linux" ]
then
    C_YELL=""
    C_REDD=""
    C_GREE=""
    C_BLUE=""
    C_END=""
fi

printf "$C_BLUE"
cat << EOF
                                                                            
             DD.  DDD                                                       
          : DDDD   DDDD        D                                            
        DD DDDDDD   DDDj       :D         DDDD                  DD          
      DD   DDDD     DDDD       GDDDD    D  i D      D            DDD        
     DD   DDDD     DDDDL       DDD     DfDDD D      DDDD    D D             
    jDD   DDDD    DDDDD     DDDDDD:D   DDDD  D,    DD DD    D    DD         
    DDD   DDDD  DDDDDD      Df ;DDDD   D DDD Df  iDDDDDD   DDD  DDD         
    DDDDDDDDDDDDDDDDD      ,D DDDDD    tDDD DDD  iDDD DD   D,D  DD,         
    jDDDDDDDDDDDDDD         LDDDDD       DDD DD  D DDDDD     D   jD         
     GDDDDDDDDDDD              jDD      DDD  DD   DDDD       D DDfD         
        DDDDD                   Di    :   .L.DD    DD   D   :f D DD         
          DDD:                  D       DG   DD    DDDDDD   D  D DD         
          DDDD   D              D            DD                             
          DDDD   D              D                                           
          DDDD  DD                                                          
           DDDD DD          D  D D DfD D j.   D D  D  D  D  D D D  D        
           DDDDDD           D  D D Df DDDDD   D D  D  D  D  D D ,LGD        
            DDDDt           :D D D Df  DD G   D DD DD DD :D .D   D D        
            .DDD                                                            
                                                                            
                                                                            
EOF
printf "$C_END"
printf "> $C_REDD恩山论坛 @dfc643 $C_GREE 3.12 $C_END\n"

#__初始化日志记录器__
logger "" > /dev/null 2>&1
LOGGER=$?
tylog() {
    if [ $LOGGER -eq 0 ]; then
        logger -t tyacc "[天翼加速] $1"
    fi
}

#__小翼管家默认参数__
printf "%s" "> 正在初始化小翼管家参数 ..."
#兼容Windows系统
if [ "$OS" = "Windows_NT" ]; then
    TEMP_PATH=$TEMP
else
    TEMP_PATH="/tmp"
fi
if [ -f ${TEMP_PATH}/xy_defuser ]; then
    XY_DEFUSER=`cat ${TEMP_PATH}/xy_defuser`
else
    XY_RAND=`awk -v min=100000000 -v max=999999999 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`
    XY_DEFUSER="20170100001${XY_RAND}"
    echo ${XY_DEFUSER} > ${TEMP_PATH}/xy_defuser
fi
XY_MAC="2020XYFREE"
printf  " $C_GREE%20s$C_END\n" "[ 成功 ]"

#__HTTP请求附加参数__
printf "%s" "> 正在初始化 HTTP 参数 ...  "
CURL_TIMEOUT=10
CURL_UA="CtClient;7.7.0;Android;10.0;Redmi Note 8"
printf  " $C_GREE%20s$C_END\n" "[ 成功 ]"

#__JSON解析__
json_paser() {
    local json=$2
    local key=$1
    local value=$(echo "${json}" | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'${key}'\042/){print $(i+1)}}}' | tr -d '"' | head -n1)
    echo ${value}
}

#__Cookie解析__
cookie_paser() {
    local header=$2
    local key=$1
    local value=$(cat ${header} | grep "${key}=[^ ]*;" | awk '{print $2}' | tail -n 1)
    echo ${value}
}

#__Header转Cookies__
header2cookie() {
    local header=$1
    echo $(cat ${header} | grep -io 'Set-Cookie: [^ ]*\=[^ "]*;' | sed 's/Set-Cookie: //ig' | sed ':a ; N;s/\n/ / ; t a ; ')
}

#__重新生成随机ID__
regen_userid() {
    rm -f ${TEMP_PATH}/xy_defuser
    tylog "重新生成随机ID"
}


#############
# 主程序区块
#############
#__获取查询授权__
printf "%s" "> 正在获取授权信息 ...      "
curl -D ${TEMP_PATH}/xy_checkhg -s -m ${CURL_TIMEOUT} -H "User-Agent: ${CURL_UA}" "http://ispeed.ebit.cn/xyfree2/index.jsp?userid=${XY_DEFUSER}&shopid=20002&cmpid=jt-kuandaitisu" > /dev/null 2>&1
XY_TOKEN_RET1=$?
XY_CHECKHG_COOKIE=$(header2cookie ${TEMP_PATH}/xy_checkhg)
XY_TOKEN_HTML2=$(curl -D ${TEMP_PATH}/xy_speedhg -s -m ${CURL_TIMEOUT} -H "User-Agent: ${CURL_UA}" "http://ispeed.ebit.cn/xyfree2/ts.jsp" -H "Cookie: xymac=${XY_MAC}; phone=${XY_DEFUSER}; ${XY_CHECKHG_COOKIE}" > ${TEMP_PATH}/xy_keypair)
XY_TOKEN_RET2=$?
XY_SPEEDHG_COOKIE=$(header2cookie ${TEMP_PATH}/xy_speedhg)
XY_SPEEDHG_KEY1=$(cat ${TEMP_PATH}/xy_keypair | grep keystr | grep -o "'\w\w[^']*'" | sed "s/'//g")
XY_SPEEDHG_KEY2=$(cat ${TEMP_PATH}/xy_keypair | grep encryptstt | grep -o "'\w\w[^']*'" | sed "s/'//g")
if [ $XY_TOKEN_RET1 -gt 0 ] || [ $XY_TOKEN_RET2 -gt 0 ]; then
    printf  " $C_REDD%20s$C_END\n" "[ 失败 ]"
    printf "> $C_REDD错误：连接服务器超时，请稍后重试！$C_END\n"
    tylog "错误：获取授权信息超时，请稍候重试！"
    exit $?
fi
printf  " $C_GREE%20s$C_END\n" "[ 成功 ]"
tylog "获取授权信息成功"


#__获取账户与IP信息__
TY_AREA_PARAM="xyspeedActivityHg"
getaccount() {
    printf "%s" "> 正在获取宽带套餐信息 ...  "
    XY_ACCOUNT_JSON=`curl -D ${TEMP_PATH}/xy_header -s -m ${CURL_TIMEOUT} -H "User-Agent: ${CURL_UA}" "http://ispeed.ebit.cn/xyface/${TY_AREA_PARAM}/isTs.jhtml?key1=${XY_SPEEDHG_KEY1}&key2=${XY_SPEEDHG_KEY2}" -H "Cookie: xymac=${XY_MAC}; phone=${XY_DEFUSER}; ${XY_CHECKHG_COOKIE}"`
    if [ $? -gt 0 ]; then
        printf  " $C_REDD%20s$C_END\n" "[ 失败 ]"
        printf "> $C_REDD错误：连接服务器超时，请稍后重试！$C_END\n"
        tylog "错误：连接服务器超时，请稍后重试！"
        exit $?
    fi
    printf  " $C_GREE%20s$C_END\n" "[ 成功 ]"
    tylog "获取宽带套餐信息成功"
}
getaccount
XY_ACCOUNT_COOKIE=$(header2cookie ${TEMP_PATH}/xy_header)


#__多地区尝试__
#__解决部分等地域无法正常使用__
XY_RETCODE=$(json_paser code ${XY_ACCOUNT_JSON})
if [ "$XY_RETCODE" != "" ] && [ $XY_RETCODE -eq 105 ]; then
    printf "%s" "> 检测到地区不匹配切换地区 ...  "
    printf  " $C_YELL%16s$C_END\n" "[ 切换 ]"
    tylog "检测到地区不匹配，切换地区重新尝试"
    TY_AREA_PARAM="xyspeedActivity"
    getaccount
fi
#广东地区Cookies
#xymac=2020XYFREE; useridFREE=201701000000********; phone=201701000000********; ip=***; province=gd; account=aabbccddee; dialacct=aabbccddee; basic_rate_up=20; basic_rate_down=100


#__解析返回信息__
printf "%s" "> 正在解析宽带套餐信息 ...  "
XY_USERID=$(json_paser dialAcct ${XY_ACCOUNT_JSON})
XY_IPADDR=$(json_paser ip ${XY_ACCOUNT_JSON})
XY_BRATE=$(json_paser basicRateDown ${XY_ACCOUNT_JSON})
XY_ACCOUNT_MSG=$(json_paser message ${XY_ACCOUNT_JSON})
if [ "${XY_USERID}" = "" ] || [ "${XY_BRATE}" = "" ]
then
    printf  " $C_REDD%20s$C_END\n" "[ 失败 ]"
    printf "> $C_REDD错误：${XY_ACCOUNT_MSG}，请重新执行脚本！或建议使用电信营业厅 APP 测试是否可正常加速，若依然不行建议咨询 10000 客服。$C_END\n"
    tylog "错误：解析宽带套餐失败"
    regen_userid
    exit
fi
printf  " $C_GREE%20s$C_END\n" "[ 成功 ]"
printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
printf " $C_GREE*$C_END 您的宽带账号：$C_BLUE${XY_USERID}$C_END\n"
printf " $C_GREE*$C_END 您的网络地址：$C_BLUE${XY_IPADDR}$C_END\n"
printf " $C_GREE*$C_END 您的签约速率：$C_BLUE${XY_BRATE} 兆$C_END\n"
printf "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
tylog "解析宽带套餐成功"


#__结果显示清理垃圾方法__
showclean() {
    #__清理临时文件__
    printf "%s" "> 正在清理临时文件 ...      "
    rm -f ${TEMP_PATH}/xy_header >/dev/null 2>&1
    rm -f ${TEMP_PATH}/xy_checkhg >/dev/null 2>&1
    rm -f ${TEMP_PATH}/xy_speedhg >/dev/null 2>&1
    rm -f ${TEMP_PATH}/xy_keypair >/dev/null 2>&1
    printf  " $C_GREE%20s$C_END\n" "[ 成功 ]"
    printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
    printf " $C_GREE*$C_END 宽带提速结果：$XY_TS_COLOR${XY_TS_MSG}$C_END\n"
    printf "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
    tylog "宽带提速结果：${XY_TS_MSG}"
}


#__判断是否正在提速__
#__部分地区如果正在提速再执行提速则会出错__
printf "%s" "> 判断是否正在提速 ...      "
XY_ISSPDUP_JSON=`curl -s -m ${CURL_TIMEOUT} -H "User-Agent: ${CURL_UA}" "http://ispeed.ebit.cn/xyface/${TY_AREA_PARAM}/isSpeedup.jhtml" -H "Cookie: xymac=${XY_MAC}; phone=${XY_DEFUSER}; ${XY_ACCOUNT_COOKIE} ${XY_CHECKHG_COOKIE}"`
if [ $? -gt 0 ]; then
    printf  " $C_REDD%20s$C_END\n" "[ 失败 ]"
    printf "> $C_REDD错误：连接服务器超时，请稍后重试！$C_END\n"
    tylog "错误：连接提速服务器超时"
    exit $?
fi
XY_ISSPDUP_CODE=$(json_paser state ${XY_ISSPDUP_JSON})
XY_ISSPDUP_MSG=$(json_paser message ${XY_ISSPDUP_JSON})
if [ $XY_ISSPDUP_CODE -eq 0 ]; then
    printf  " $C_GREE%20s$C_END\n" "[ 成功 ]"
    XY_TS_COLOR=$C_GREE
    XY_TS_MSG=$XY_ISSPDUP_MSG
    showclean
    tylog "当前已提过速无需再次提速"
    exit 0
elif [ $XY_ISSPDUP_CODE -eq -1 ]; then
    printf  " $C_GREE%20s$C_END\n" "[ 成功 ]"
else
    printf  " $C_REDD%20s$C_END\n" "[ 失败 ]"
    XY_TS_COLOR=$C_REDD
    XY_TS_MSG=$XY_ISSPDUP_MSG
    showclean
    tylog "错误：查询是否提速失败"
    exit -1
fi


#__执行提速__
XY_TRY_COUNT=1
speedup() {
    printf "%s" "> 正在尝试提速 ...          "
    XY_TS_JSON=`curl -s -m ${CURL_TIMEOUT} -H "User-Agent: ${CURL_UA}" "http://ispeed.ebit.cn/xyface/${TY_AREA_PARAM}/speedup.jhtml" -H "Cookie: xymac=${XY_MAC}; phone=${XY_DEFUSER}; ${XY_ACCOUNT_COOKIE} ${XY_CHECKHG_COOKIE} ${XY_SPEEDHG_COOKIE}"`
    if [ $? -gt 0 ]; then
        printf  " $C_REDD%20s$C_END\n" "[ 失败 ]"
        printf "> $C_REDD错误：连接服务器超时，请稍后重试！$C_END\n"
        tylog "错误：连接提速服务器超时"
        exit $?
    fi
    XY_TS_CODE=$(json_paser state ${XY_TS_JSON})
    XY_TS_MSG=$(json_paser message ${XY_TS_JSON})
    #__返回9999重试__
    if [ $XY_TS_CODE -eq 9999 ]; then
        printf  " $C_YELL%20s$C_END\n" "[ 重试 ]"
        XY_TRY_COUNT=`expr $XY_TRY_COUNT + 1`
        if [ $XY_TRY_COUNT -gt 5 ]; then
            printf "> $C_REDD错误：超过尝试次数！$C_END\n"
            tylog "错误：超过提速尝试次数"
            exit $XY_TRY_COUNT
        fi
        sleep 3
        speedup
    fi
}
speedup

#__显示提速结果__
#__其他大于0表成功__
if [ $XY_TS_CODE -eq 0 ] || [ $XY_TS_CODE -eq 1 ]; then
    XY_TS_COLOR=$C_GREE
    printf  " $C_GREE%20s$C_END\n" "[ 成功 ]"
else
    XY_TS_COLOR=$C_REDD
    printf  " $C_REDD%20s$C_END\n" "[ 失败 ]"
fi
showclean
