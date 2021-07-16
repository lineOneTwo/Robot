*** Settings ***
Documentation    Suite description

*** Test Cases ***
#baidu #UI自动化
#     [Tags]    UI
#     open browser    http://sqwytst.wt.com:14352/    chrome
#     input text    id=kw    robot接口测试用例编写
#     click button    id=su
#     close_browser
#For-Loop-Elements
   # 创建文件并保存数据
#    create_workbook    F:\\token.xlsx    overwrite_file_if_exists=${True}


*** Keywords ***
Provided precondition
    Setup system under test