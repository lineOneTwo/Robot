*** Settings ***
Library     RequestsLibrary
Library     ExcellentLibrary

*** Test Cases ***
itemsList #post 循环获取主题code
    FOR  ${themeCode}   IN   005   010   015   020   025
        Open workbook   F:\\token.xlsx
        ${token}     Read from cell    B4
        ${headers}    create Dictionary    token=${token}
        create session    itemlist    http://121.30.189.198:14355    ${headers}
        ${data}    create Dictionary    pageNo=0    departmentId=0    themeType=1    pageSize=10    itemName=     themeCode=${themeCode}     itemTypeCode=
        ${resp}    post on session    itemlist    approval-project/itemsList/example/0/10    ${data}
        close_workbook    F:\\token.xlsx
        log    ${resp.status_code}
        log    ${resp.text}
        Should Be Equal As Strings    ${resp.status_code}    200
        Should Be Equal As Strings    ${resp.json()['message']}    request successful
    END

*** Keywords ***
Provided precondition
    Setup system under test