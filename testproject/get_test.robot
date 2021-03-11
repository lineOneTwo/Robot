*** Settings ***
Library     RequestsLibrary
Library     ExcellentLibrary

*** Test Cases ***
index #获取token
    create session    local    http://121.30.189.198:14355/approval-project
    ${resp}    get on session    local    index
    log    ${resp.json()['data']['powerMenuList'][0]['menuName']}
    log    ${resp.json()['data']['token']}
    Should Be Equal As Strings    ${resp.status_code}    200
    open_workbook     F:\\token.xlsx
    write_to_cell     B4    ${resp.json()['data']['token']}
    save  F:\\token.xlsx
    close_workbook    F:\\token.xlsx

*** Keywords ***
Provided precondition
    Setup system under test