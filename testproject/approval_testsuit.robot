*** Settings ***
Library           Selenium2Library
Library           RequestsLibrary
Library           collections
Library           OperatingSystem
Library           ExcellentLibrary
Library           HttpLibrary
Library           ExcelLibrary
Library           string

*** Variables ***
#${host}         121.30.189.198:14355 测试
${host}         121.30.189.198:5200
${server}          http://${host}/approval-project

*** Test Cases ***
index #获取token 获取json串的值
    create session    local    ${server}
    ${resp}    get on session    local    index
    log    ${resp.json()['data']['powerMenuList'][0]['menuName']}
    log    ${resp.json()['data']['token']}
    Should Be Equal As Strings    ${resp.status_code}    200
    open_workbook    F:\\token.xlsx
    write_to_cell    B4    ${resp.json()['data']['token']}
    save    F:\\token.xlsx
    Close Workbook    F:\\token.xlsx

theme1 #get 获取自然人下的所有主题
    sleep    1
    Open workbook    F:\\token.xlsx
    ${token}    Read from cell    B4
    ${headers}    create Dictionary    token=${token}
    create session    local    ${server}/theme    ${headers}
    ${resp}    GET On Session    local    1
    close_workbook    F:\\token.xlsx
    log    ${resp.status_code}
    log    ${resp.text}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()['message']}    request successful
    should be equal as numbers    ${resp.status_code}    200    #校验数值是否相等
    should be equal as integers    ${resp.status_code}    200    #校验数值是否为整数
    should exist    F:\\token.xlsx    #校验本地文件是否存在

theme2 #get 获取法人下的所有主题
    sleep    1
    Open workbook    F:\\token.xlsx
    ${token}    Read from cell    B4
    ${headers}    create Dictionary    token=${token}
    create session    local    ${server}/theme    ${headers}
    ${resp}    GET On Session    local    2
    close_workbook    F:\\token.xlsx
    log    ${resp.status_code}
    log    ${resp.text}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()['message']}    request successful

itemsList #post 循环获取主题code
    sleep    1
    FOR    ${themeCode}    IN    005    010    015    020    025
        Open workbook    F:\\token.xlsx
        ${token}    Read from cell    B4
        ${headers}    create Dictionary    token=${token}
        create session    itemlist    ${server}/itemsList/example    ${headers}
        ${data}    create Dictionary    pageNo=0    departmentId=0    themeType=1    pageSize=10    itemName=    themeCode=${themeCode}    itemTypeCode=
        ${resp}    post on session    itemlist    /0/10    ${data}
        close_workbook    F:\\token.xlsx
        log    ${resp.status_code}
        log    ${resp.text}
        Should Be Equal As Strings    ${resp.status_code}    200
        Should Be Equal As Strings    ${resp.json()['message']}    request successful
    END

search #搜索功能
    sleep    1
    Open workbook    F:\\token.xlsx
    ${token}    Read from cell    B4
    ${headers}    create Dictionary    token=${token}
    create session    search    ${server}    ${headers}
    ${data}    create Dictionary    pageNo=0    itemListName=注销    pageSize=10
    ${resp}    post on session    search    /itemsList/name/0/10    ${data}
    write_to_cell    B5    ${resp.json()['data']['resultList'][0]['itemsListId']}
    save    F:\\token.xlsx
    close_workbook    F:\\token.xlsx
    log    ${resp.status_code}
    log    ${resp.text}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()['message']}    request successful

info #详情
    sleep    1
    open workbook    F:\\token.xlsx
    ${token}    Read from cell    B4
    ${itemsListId}    Read from cell    B5
    ${headers}    create Dictionary    token=${token}
    create session    info    ${server}/itemsList    ${headers}
    ${resp}    get on session    info    info/${itemsListId}
    close_workbook    F:\\token.xlsx
    log    ${resp.status_code}
    log    ${resp.text}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()['message']}    request successful

questionnaire #问题列表
    sleep    1
    Open workbook    F:\\token.xlsx
    ${token}    Read from cell    B4
    ${itemsListId}    Read from cell    B5
    ${headers}    create Dictionary    token=${token}
    create session    question    ${server}    ${headers}
    ${data}    create Dictionary    itemsListId=${itemsListId}
    ${resp}    post on session    question    questionnaire/tree    ${data}
    close_workbook    F:\\token.xlsx
    log    ${resp.status_code}
    log    ${resp.text}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()['message']}    request successful

handleItemFlow #办理环节
    sleep    1
    Open workbook    F:\\token.xlsx
    ${token}    read from cell    B4
    ${itemsListId}    read from cell    B5
    ${headers}    create Dictionary    token=${token}
    create session    handleItemFlow    ${server}    ${headers}
    ${resp}    get on session    handleItemFlow    handleItemFlow/${itemsListId}
    close workbook    F:\\token.xlsx
    log    ${resp.status_code}
    log    ${resp.text}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()['message']}    request successful

legal #法律信息
    sleep    1
    Open workbook    F:\\token.xlsx
    ${token}    read from cell    B4
    ${itemsListId}    read from cell    B5
    ${headers}    create Dictionary    token=${token}
    create session    legal    ${server}    ${headers}
    ${resp}    get on session    legal    legal/${itemsListId}
    close workbook    F:\\token.xlsx
    log    ${resp.status_code}
    log    ${resp.text}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()['message']}    request successful

department #部门列表
    #    sleep    1
    Open workbook    F:\\token.xlsx
    ${token}    read from cell    B4
    ${headers}    create Dictionary    token=${token}
    create session    department    ${server}   ${headers}
    ${resp}    post on session    department    /department/tree
    close workbook    F:\\token.xlsx
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()['message']}    request successful
