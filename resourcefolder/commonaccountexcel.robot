*** Settings ***
Library                   QWeb
Library                   QForce
Library                   String
Library                 ExcelLibrary
Library                 ../libraries/GitOperations.py


*** Variables ***
${username}               YOUR USERNAME HERE
${login_url}              https://YOURDOMAIN.my.salesforce.com          # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}               ${login_url}/lightning/page/home
${excel_worksheet}      ${CURDIR}/../data/products_worksheet (13).xlsx
${git_branch}           main

*** Keywords ***
Setup Browser
    Set Library Search Order                          QWeb                   QForce
    Open Browser          about:blank                 ${BROWSER}
    SetConfig             LineBreak                   ${EMPTY}               #\ue000
    SetConfig             DefaultTimeout              20s                    #sometimes salesforce is slow
    Evaluate            random.seed()    random    # initialize random generator

End suite
    Set Library Search Order                          QWeb                   QForce
    Close All Browsers


Login
    [Documentation]       Login to Salesforce instance
    Set Library Search Order                          QWeb                   QForce
    GoTo                  ${login_url}
    TypeText              Username                    ${username}             delay=1
    TypeText              Password                    ${password}
    ClickText             Log In


Home
    [Documentation]       Navigate to homepage, login if needed
    Set Library Search Order                          QWeb                   QForce
    GoTo                  ${home_url}
    ${login_status} =     IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If        ${login_status}             Login
    ClickText             Home
    VerifyTitle           Home | Salesforce
    