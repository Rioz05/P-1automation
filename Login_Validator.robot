*** Settings ***
Library         RPA.Browser.Playwright
Resource        ./../robots/functions/CitrixLoginFunctions/FN_Login.resource
Resource        ./../robots/functions/CitrixLoginFunctions/FN_DatabaseAppSelection.resource
Resource        ./../robots/utils/UTIL_GlobalVariables.resource
Resource        ./../robots/_tests_/modules/common/util.resource
Resource        ./../robots/functions/Common/FN_MainMenuNavigate_v1.resource
Resource        ./../robots/functions/WorkflowConsoleFunctions/FN_ApplyPanelFilterWorkFlowConsole_v1.resource
Resource        ./../robots/init_fb_worker.robot
Resource        ./../robots/functions/ClinicalInputFunctions/FN_ApplyPanelFilterClinicalInput_v1.resource
Resource        ./../robots/functions/ClinicalInputFunctions/FN_ApplyPanelFilterClinicalInput_v1.resource
Resource        ./../robots/functions/FN_SelectFirstRecord.resource
Resource        ./../robots/functions/ClinicalInputFunctions/FN_NavigationFromClinicalInput.resource
Resource        ./../robots/functions/CoordinationNotesFunctions/FN_PerformActionInCoordinationNotesForScreen.resource
Resource        ./../robots/functions/CoordinationNotesFunctions/FN_AddOrEditCoordinationNote.resource
Resource        ./../robots/modules/screens/SCREEN_EditReferral.resource
Resource        functions/WorkflowConsoleFunctions/FN_ApplyGridFiltersInPatientRelatedTasks.resource
Resource        functions/WorkflowConsoleFunctions/FN_StageClearViaWorkflowConsole.resource
Resource        modules/screens/SCREEN_AddEditServiceLocation.resource
Resource        ../robots/Login_Validator.robot
Library         ../unit_test.py
Library         ../utils.py

Suite Setup     util.init


*** Variables ***
${panel_filter_object}                          Create Dictionary
...                                             clinicalInputSearchBy=${EMPTY}
...                                             clinicalInputSearchFor=${EMPTY}
...                                             clinicalInputEpisodeStatus=${EMPTY}
...                                             clinicalInputPatientStatus=${EMPTY}
${add_co_note_navigation}                       add_coordination_notes
${add_conote_navigation_in_addcontes_screen}    add
@{Note_type_list}                               485 REVIEW    5P CLINICIAN HANDOFF    BALA
&{ConotesObject}                                noteType=${Note_type_list}
${Patient Information Report}                   Patient Information Report
${new_folder}                                   exportgrid
${export_file_name}                             workflowGrid
${output_excel_filepath}=                       ${CURDIR}${/}Login_Validator_Output_Sheet.xlsx
@{ServiceListFormat}                            @{EMPTY}
@{EventListFormat}                              @{EMPTY}
@{StageListFormat}                              @{EMPTY}
@{BranchListInit}                               @{EMPTY}
@{ServiceListinit}                              @{EMPTY}
@{EventListInit}                                @{EMPTY}
@{StageListInit}                                @{EMPTY}
@{ReportListFormat}                             @{EMPTY}
@{init_branch}                                  @{EMPTY}
@{init_serviceline}                             @{EMPTY}
@{init_event}                                   @{EMPTY}
@{init_stage}                                   @{EMPTY}
@{Error_list}                                   @{EMPTY}
@{Failed_report_list}                           @{EMPTY}
&{Failed_filter_param}
...                                             Unavailable_ServiceLines=${ServiceListinit}
...                                             Unavailable_Branch=${BranchListInit}
...                                             Unavailable_Event=${EventListInit}
...                                             Unavailable_Stage=${StageListInit}
@{BranchListFormat}                             @{EMPTY}
@{NoteTypeListFormat}                           @{EMPTY}
&{output_response_dict}
...                                             LAUNCH URL=${EMPTY}
...                                             LOGIN HCHB=${EMPTY}
...                                             DETECT CITRIXPAGE OPEN=${EMPTY}
...                                             DATABASE OPEN=${EMPTY}
...                                             WORKFLOW CONSOLE NAVIGATION=${EMPTY}
...                                             SERVICE LINES=${EMPTY}
...                                             BRANCHES=${EMPTY}
...                                             EVENTS=${EMPTY}
...                                             STAGES=${EMPTY}
...                                             APPLY TASK IN GRIDFILTER=${EMPTY}
...                                             EXPORT GRID BUTTON ACTION=${EMPTY}
...                                             RECORDS=${EMPTY}
...                                             FIRSTRECORD CLICK=${EMPTY}
...                                             REPORTS=${EMPTY}
...                                             STAGECOMPLETE BUTTON=${EMPTY}
...                                             CLINICALINPUT CONSOLE NAVIGATION=${EMPTY}
...                                             CLINICALINPUT RECORDS=${EMPTY}
...                                             CLINICALINPUT SELECT FIRSTRECORD=${EMPTY}
...                                             MEDICARE RECORD INFO BUTTON=${EMPTY}
...                                             ADDCOORDINATION BUTTON=${EMPTY}
...                                             ADD BUTTON=${EMPTY}
...                                             NOTE TYPE=${EMPTY}
...                                             PATIENT INFORMATION BUTTON=${EMPTY}
...                                             PRINT PATIENT INFO BUTTON=${EMPTY}
...                                             INCLUDE COORDINATION NO BUTTON=${EMPTY}
...                                             PATIENT INFORMATION REPORT OPENED=${EMPTY}
...                                             MAINTAIN FACILITIES NAVIGATION=${EMPTY}
...                                             MAINTAIN PHYSICIANS NAVIGATION=${EMPTY}
@{main_list}                                    @{EMPTY}
@{Workflow_console_error_list}                  @{EMPTY}
@{clinical_input_error_list}                    @{EMPTY}
@{physicians_input_error_list}                  @{EMPTY}
@{facilities_input_error_list}                  @{EMPTY}


*** Test Cases ***
login_validator_function
    [Documentation]    Login validation for Notification
    [Tags]    login_validation
    ${data}=    Evaluate    os.environ.get("data")
    ${dict}=    Evaluate    json.loads('''${data}''')    json
    ${servicelineNote}=    Set Variable    ${dict}[SERVICELINES]
    ${branchNote}=    Set Variable    ${dict}[BRANCH]
    ${eventNote}=    Set Variable    ${dict}[EVENT]
    ${stageNote}=    Set Variable    ${dict}[STAGE]
    ${ServivelineObject}=    Evaluate    '''${servicelineNote}'''.split(",")
    ${BranchObject}=    Evaluate    '''${branchNote}'''.split(",")
    ${EventObject}=    Evaluate    '''${eventNote}'''.split(",")
    ${StageObject}=    Evaluate    '''${stageNote}'''.split(",")
    ${grid_filter_params}=    Create Dictionary
    ...    task=${dict}[TASK]
    ${params}=    Create Dictionary
    ...    serviceLines=${ServivelineObject}
    ...    branches=${BranchObject}
    ...    events=${EventObject}
    ...    stages=${StageObject}

    ${reports}=    Set Variable    ${dict}[REPORTS]
    ${report_list}=    Evaluate    '''${reports}'''.split(",")
    OperatingSystem.Create Directory    ${FOLDER_DIRECTORY}/${new_folder}

    # TRY
    #     Log Message    <<< APP_URL : ${APP_URL} >>>
    #     New Browser    chromium    headless=False
    #     New Context    viewport={'width': 1920, 'height': 1080}    acceptDownloads=True
    #     New Page    ${APP_URL}
    #     Handle Future Dialogs    action=accept
    #     ${id}=    Get Page Ids    ACTIVE    ACTIVE    ACTIVE
    #     Switch Page    ${id}[0]    CURRENT
    #     Set To Dictionary    ${output_response_dict}    LAUNCH URL=Success
    # EXCEPT    AS    ${error_msg}
    #     Set To Dictionary    ${output_response_dict}    LAUNCH URL=Failed
    #     EX_Exception.ex-fail    ${LOGIN_PAGE_NOT_APPEARED}
    # END

    # Log Message    <--- FUNCTION : login HCHB function started --->    INFO
    # TRY
    #     ${is_logon_page}=    SCREEN_Logon.is-logon-page
    #     IF    $is_logon_page    SCREEN_Logon.click-logon-button
    #     TRY
    #         SCREEN_Login.axn-set-username    ${APP_USERNAME}
    #         SCREEN_Login.axn-set-password
    #         SCREEN_Login.axn-perform-Login
    #         Set To Dictionary    ${output_response_dict}    LOGIN HCHB=Success
    #     EXCEPT    AS    ${err_msg}
    #         IF    $err_msg == 'E5.SYSTEM.MODULE.E0020'
    #             EX_Exception.ex-fail    ${INVALID_CREDENTIALS}
    #         ELSE IF    $err_msg == 'E5.SYSTEM.MODULE.E0021'
    #             EX_Exception.ex-fail    ${DETECT_CITRIX_NOT_FOUND}
    #         END
    #         EX_Exception.ex-fail    ${err_msg}
    #     END
    # EXCEPT    AS    ${err_msg}
    #     Set To Dictionary    ${output_response_dict}    LOGIN HCHB=Failed
    #     TRY
    #         RPA.Browser.Playwright.Close Page
    #     EXCEPT    AS    ${error_message}
    #         Log Message    Error while closing the page is: ${error_message}    ERROR
    #     END
    #     IF    '${err_msg}' == 'INVALID_CREDENTIALS'
    #         EX_Exception.ex-fail    ${err_msg}
    #     ELSE IF    '${err_msg}' == 'DETECT_CITRIX_NOT_FOUND'
    #         EX_Exception.ex-fail    ${err_msg}
    #     END
    #     EX_Exception.ex-throw-module-system-exception-message    ${err_msg}
    # END

    # TRY
    #     SCREEN_DetectCitrix.axn-perform-detect-citrix
    #     SCREEN_DetectCitrix.axn-perform-citrix-popup
    #     Set To Dictionary    ${output_response_dict}    DETECT CITRIXPAGE OPEN=Success
    # EXCEPT    AS    ${err_msg}
    #     Set To Dictionary    ${output_response_dict}    DETECT CITRIXPAGE OPEN=Failed
    #     TRY
    #         FN_Logout.fn-hchb-logout
    #     EXCEPT    AS    ${err_msg}
    #         EX_Exception.ex-throw-module-system-exception-message    ${err_msg}
    #     END
    #     TRY
    #         RPA.Browser.Playwright.Close Page
    #     EXCEPT    AS    ${error_message}
    #         Log Message    Error while closing the page is: ${error_message}    ERROR
    #     END
    #     IF    $err_msg == 'E5.SYSTEM.MODULE.E0031'
    #         EX_Exception.ex-fail    ${DATABASE_PAGE_NOT_FOUND}
    #     ELSE
    #         EX_Exception.ex-fail    ${DETECT_CITRIX_NOT_FOUND}
    #     END
    # END

    # TRY
    #     FN_DatabaseAppSelection.fn-select-apps-into-hchb    ${HCHB_DATABASE_NAME}    ${HCHB_MAIN_WINDOW}
    #     Set To Dictionary    ${output_response_dict}    DATABASE OPEN=Success
    # EXCEPT    AS    ${err_msg}
    #     Set To Dictionary    ${output_response_dict}    DATABASE OPENED=Failed
    #     TRY
    #         FN_Logout.fn-hchb-logout
    #     EXCEPT    AS    ${err_msg}
    #         EX_Exception.ex-throw-module-system-exception-message    ${err_msg}
    #     END
    #     TRY
    #         RPA.Browser.Playwright.Close Page
    #     EXCEPT    AS    ${error_message}
    #         Log Message    Error while closing the page is: ${error_message}    ERROR
    #     END
    #     ${is_exists}=    Evaluate
    #     ...    $err_msg in ['E5.SYSTEM.MODULE.E0038', 'E5.SYSTEM.MODULE.E0039','E5.SYSTEM.MODULE.E0040','E5.SYSTEM.MODULE.E0041']
    #     IF    $is_exists
    #         EX_Exception.ex-fail    ${DATABASE_NOT_LISTED}
    #     ELSE IF    $err_msg == 'E5.SYSTEM.MODULE.E0177'
    #         EX_Exception.ex-fail    ${MAIN_MENU_PAGE_NOT_FOUND}
    #     ELSE
    #         EX_Exception.ex-fail    ${DATABASE_NOT_SELECTED}
    #     END
    # END
    ${Workflow_console_error_list}=    workflow-console-actions
    ...    ${params}
    ...    ${grid_filter_params}
    ...    ${report_list}
    ...    ${Failed_report_list}
    ...    ${Workflow_console_error_list}
    Log message    WORKFLOW ERROR LIST:${Workflow_console_error_list}
    # Login_Validator.clinical-input-actions    ${clinical_input_error_list}
    # Login_Validator.maintain-physicians-actions    ${physicians_input_error_list}
    # Login_Validator.maintain-facility-actions    ${facilities_input_error_list}

    ${window_list}=    Create List
    Close Citrix Window    ${window_list}    False
    Append To List    ${main_list}    ${output_response_dict}
    TRY
        FN_Logout.fn-hchb-logout
    EXCEPT    AS    ${err_msg}
        EX_Exception.ex-throw-module-system-exception-message    ${err_msg}
    END
    TRY
        RPA.Browser.Playwright.Close Page
    EXCEPT    AS    ${error_message}
        Log Message    Error while closing the page is: ${error_message}    ERROR
    END

    Log message    Main list:@{main_list}
    # Write List Of Dicts To Excel    ${main_list}    ${output_excel_filepath}

# ============= Helper Functions ============#


*** Keywords ***
workflow-console-actions
    [Documentation]    function performs to work on workflow console related validations
    [Tags]    robot:private
    [Arguments]
    ...    ${params}
    ...    ${report_list}
    ...    ${grid_filter_params}
    ...    ${Failed_report_list}
    ...    ${Workflow_console_error_list}

    ${servicelist}=    Set Variable    ${params}[serviceLines]
    ${branchlist}=    Set Variable    ${params}[branches]
    ${eventlist}=    Set Variable    ${params}[events]
    ${stagelist}=    Set Variable    ${params}[stages]
    TRY
        ${workflow_navigation_completed}=    Set Variable    ${True}
        FN_MainMenuNavigate_v1.fn-main-menu-navigate_v1    Patient_Related_Tasks
        Set To Dictionary    ${output_response_dict}    WORKFLOW CONSOLE NAVIGATION=Success
    EXCEPT    AS    ${err_msg}
        ${workflow_navigation_completed}=    Set Variable    ${False}
        RPA.Desktop.Press keys    esc
        Set To Dictionary    ${output_response_dict}    WORKFLOW CONSOLE NAVIGATION=Failed
        Append To List    ${Workflow_console_error_list}    ${PATIENT_RELATED_TASK_WORKFLOW_CONSOLE_NAVIGATION_FAILED}
    END
    IF    $workflow_navigation_completed
        ${Error_list}
        ...    ${Failed_filter_param}=
        ...    FN_ApplyPanelFilterWorkFlowConsole_v1.fn-workflowconsole-panel-filter-v1
        ...    ${params}
        ...    ${Error_list}
        ...    ${Failed_filter_param}
        Log Message    Failed Error list:${Error_list} : Not Avaliable Filter Object:${Failed_filter_param}
        ${failedServicelist}=    Set Variable    ${Failed_filter_param}[Unavailable_ServiceLines]
        ${failedbranchlist}=    Set Variable    ${Failed_filter_param}[Unavailable_Branch]
        ${failedeventlist}=    Set Variable    ${Failed_filter_param}[Unavailable_Event]
        ${failedstagelist}=    Set Variable    ${Failed_filter_param}[Unavailable_Stage]

        FOR    ${item}    IN    @{servicelist}
            ${branch_check}=    Evaluate    $item in ${failedServicelist}
            IF    $branch_check
                Append To List    ${ServiceListFormat}    ${Item} = NotAvailable
            ELSE
                Append To List    ${ServiceListFormat}    ${Item} = Available
            END
        END

        ${joinedService}=    Evaluate    "\\n".join(${ServiceListFormat})

        FOR    ${item}    IN    @{branchlist}
            ${branch_check}=    Evaluate    $item in ${failedbranchlist}
            IF    $branch_check
                Append To List    ${BranchListFormat}    ${Item} = Not Available
            ELSE
                Append To List    ${BranchListFormat}    ${Item} = Available
            END
        END

        ${joinedBranch}=    Evaluate    "\\n".join(${BranchListFormat})

        FOR    ${item}    IN    @{eventlist}
            ${event_check}=    Evaluate    $item in ${failedeventlist}
            IF    $event_check
                Append To List    ${EventListFormat}    ${Item} = Not Available
            ELSE
                Append To List    ${EventListFormat}    ${Item} = Available
            END
        END
        ${joinedEvent}=    Evaluate    "\\n".join(${EventListFormat})

        FOR    ${item}    IN    @{stagelist}
            ${stage_check}=    Evaluate    $item in ${failedstagelist}
            IF    $stage_check
                Append To List    ${StageListFormat}    ${Item} = Not Available
            ELSE
                Append To List    ${StageListFormat}    ${Item} = Available
            END
        END
        ${joinedStage}=    Evaluate    "\\n".join(${StageListFormat})
        Set To Dictionary
        ...    ${output_response_dict}
        ...    SERVICE LINES=${joinedService}
        ...    BRANCHES=${joinedBranch}
        ...    EVENTS=${joinedEvent}
        ...    STAGES=${joinedStage}
        FOR    ${error}    IN    @{Error_list}
            Append To List    ${Workflow_console_error_list}    ${error}
        END
        TRY
            FN_ApplyGridFiltersInPatientRelatedTasks.fn-apply-grid-filter-in-patient-related-tasks
            ...    ${grid_filter_params}
            Set To Dictionary    ${output_response_dict}    APPLY TASK IN GRIDFILTER=Success
        EXCEPT    AS    ${Err_msg}
            Set To Dictionary    ${output_response_dict}    APPLY TASK IN GRIDFILTER=Failed
            Append To List    ${Workflow_console_error_list}    ${FAILED_TO_UPDATE_TASK_IN_GRID_FILTER}
        END
        TRY
            TRY
                ${export_grid_failed}=    Set Variable    ${True}
                SCREEN_WorkFlowConsole.axn-export-grid
                ${current_date}=    DateTime.Get Current Date    UTC    result_format=%Y%m%d%H%M%S
                ${file_path}=    Set Variable
                ...    ${DOWNLOAD_PATH}\\${new_folder}\\${export_file_name}_${current_date}.xlsx
                ${output_file_path}=    SCREEN_WindowsPopup.axn-set-file-name    ${file_path}
                SCREEN_WindowsPopup.axn-click-export-grid-popup
                Set To Dictionary    ${output_response_dict}    EXPORT GRID BUTTON ACTION=Success
            EXCEPT    AS    ${err_msg}
                Set To Dictionary    ${output_response_dict}    EXPORT GRID BUTTON ACTION=Failed
                ${export_grid_failed}=    Set Variable    ${False}
                IF    '${err_msg}' == 'EXPORT_GRID_BUTTON_NOT_AVAILABLE'
                    EX_Exception.ex-fail    ${EXPORT_GRID_BUTTON_NOT_AVAILABLE}
                ELSE
                    EX_Exception.ex-fail    ${FAILED_TO_EXPORT_GRID_FILTER_PROCESS}
                END
            END
        EXCEPT    AS    ${Err_msg}
            Append To List    ${Workflow_console_error_list}    ${Err_msg}
        END

        IF    $export_grid_failed
            TRY
                TRY
                    RPA.Excel.Files.Open Workbook    ${output_file_path}
                    ${current_sheet}=    RPA.Excel.Files.Get Active Worksheet
                    ${sheet_data}=    Read Worksheet    ${current_sheet}    header=${True}
                    ${record_count}=    Get Length    ${sheet_data}
                    Set To Dictionary    ${output_response_dict}    RECORDS=Found

                    IF    ${record_count} == 0
                        Set To Dictionary    ${output_response_dict}    RECORDS=Not Found
                        EX_Exception.ex-fail    ${NO_RECORD_FOUND_IN_WORKFLOW_CONSOLE_WINDOW}
                    END
                    TRY
                        UTIL_FileHelper.util-delete-files-from-directory    ${output_file_path}
                    EXCEPT    AS    ${ERROR_MSG}
                        Log Message    delete file from directory ERROR:${ERROR_MSG}
                    END
                EXCEPT    AS    ${ERROR_MESSAGE}
                    TRY
                        UTIL_FileHelper.util-delete-files-from-directory    ${output_file_path}
                    EXCEPT    AS    ${ERROR_MSG}
                        Log Message    delete file from directory ERROR:${ERROR_MSG}
                    END
                    IF    '${ERROR_MESSAGE}' == 'NO_RECORD_FOUND_IN_WORKFLOW_CONSOLE_WINDOW'
                        EX_Exception.ex-fail    ${NO_RECORD_FOUND_IN_WORKFLOW_CONSOLE_WINDOW}
                    ELSE
                        EX_Exception.ex-fail    ${FAILED_TO_CHECK_NO_RECORD_VALIDATION}
                    END
                END
            EXCEPT    AS    ${Err_msg}
                Append To List    ${Workflow_console_error_list}    ${Err_msg}
            END
            ${no_record_check}=    Evaluate
            ...    'NO_RECORD_FOUND_IN_WORKFLOW_CONSOLE_WINDOW' in ${Workflow_console_error_list}
            IF    $no_record_check
                Set To Dictionary    ${output_response_dict}    FIRSTRECORD CLICK=Unable to Click
                Log Message    NO RECORDS FOUND
            ELSE
                TRY
                    TRY
                        ${check_report_validation}=    Set Variable    ${True}
                        SCREEN_WorkFlowConsole.axn-select-first-record    double_click
                        Set To Dictionary    ${output_response_dict}    FIRSTRECORD CLICK=Success
                    EXCEPT    AS    ${err_msg}
                        EX_Exception.ex-fail    ${FAILED_TO_CLICK_FIRST_RECORD}
                    END
                EXCEPT    AS    ${err_msg}
                    ${check_report_validation}=    Set Variable    ${False}
                    Set To Dictionary    ${output_response_dict}    FIRSTRECORD CLICK=Failed
                    Append To List    ${Workflow_console_error_list}    ${Err_msg}
                END
                IF    $check_report_validation
                    TRY
                        FOR    ${element}    IN    @{report_list}
                            TRY
                                Log Message    ${element}    INFO
                                FN_StageClearViaWorkflowConsole.select-report    ${element}
                            EXCEPT    AS    ${err_msg}
                                Append to List    ${Failed_report_list}    ${element}
                            END
                        END
                        Log Message    Failed report:${Failed_report_list}    INFO
                        FOR    ${item}    IN    @{report_list}
                            ${report_check}=    Evaluate    $item in ${Failed_report_list}
                            IF    $report_check
                                Append To List    ${ReportListFormat}    ${Item} = Report Not Available
                            ELSE
                                Append To List    ${ReportListFormat}    ${Item} = Report Available
                            END
                        END
                        ${joinedReport}=    Evaluate    "\\n".join(${ReportListFormat})
                        Set To Dictionary    ${output_response_dict}    REPORTS=${joinedReport}

                        ${is_stage_complete_button_available}=    FN_StageClearViaWorkflowConsole.stage-complete
                        ...    STAGE_COMPLETED
                        Log Message    Stage Complete button visible : ${is_stage_complete_button_available}
                        IF    $is_stage_complete_button_available == $True
                            Log Message    Stage Complete button Appeared
                            Set To Dictionary    ${output_response_dict}    STAGECOMPLETE BUTTON=Available
                        ELSE
                            Set To Dictionary    ${output_response_dict}    STAGECOMPLETE BUTTON=Not Available
                            EX_Exception.ex-fail    ${STAGE_COMPLETE_BUTTON_NOT_AVAILABLE}
                        END
                        ${window_list}=    Create List    Workflow    HCHB Main
                        Close Citrix Window    ${window_list}    False

                        Log Message    <--- FUNCTION : HCHB workflow stage complete function Ended --->    INFO
                    EXCEPT    AS    ${error_message}
                        ${window_list}=    Create List    Workflow    HCHB Main
                        Close Citrix Window    ${window_list}    False

                        Log Message    Exception : ${error_message}    ERROR
                        Append To List    ${Workflow_console_error_list}    ${error_message}
                    END
                ELSE
                    Log Message    UNABLE TO CHECK REPORT VALIDATION DUE TO UNSELECT RECORD
                END
            END
        ELSE
            Log Message    EXPORT GRID ACTION FAILED
        END
        Log Message    Error occurred in workflow console part : ${Workflow_console_error_list}

        ${window_list}=    Create List    HCHB Main
        Close Citrix Window    ${window_list}    False
    ELSE
        Log Message    PATIENT RELATED TASKS NAVIGATION FAILED
    END
    RETURN    ${Workflow_console_error_list}

clinical-input-actions
    [Documentation]    function performs to worn on clinical input console related validations
    [Tags]    robot:private
    [Arguments]    ${clinical_input_error_list}

    TRY
        ${clinical_input_page_opened}=    Set Variable    ${True}
        FN_MainMenuNavigate_v1.fn-main-menu-navigate_v1    Clinical_Input_With_Expected_Window
        Set To Dictionary    ${output_response_dict}    CLINICALINPUT CONSOLE NAVIGATION=Success
    EXCEPT    AS    ${err_msg}
        ${clinical_input_page_opened}=    Set Variable    ${False}
        Set To Dictionary    ${output_response_dict}    CLINICALINPUT CONSOLE NAVIGATION=Failed
        Append To List    ${clinical_input_error_list}    ${CLINICAL_INPUT_WORKFLOW_CONSOLE_NAVIGATION_FAILED}
    END

    IF    $clinical_input_page_opened
        TRY
            ${filter_applied_completed}=    Set Variable    ${True}
            FN_ApplyPanelFilterClinicalInput_v1.fn-clinical-input-panel-filter-v1    ${panel_filter_object}
        EXCEPT    AS    ${err_msg}
            IF    '${err_msg}' == 'FAILED_TO_CLICK_LOAD_BUTTON_IN_CLINICAL_INPUT'
                ${filter_applied_completed}=    Set Variable    ${False}
                Append To List    ${clinical_input_error_list}    ${FAILED_TO_CLICK_LOAD_BUTTON_IN_CLINICAL_INPUT}
            ELSE IF    '${err_msg}' == 'FAILED_TO_CLICK_YES_BUTTON_CONTINUE_SEARCH_POPUP'
                ${filter_applied_completed}=    Set Variable    ${False}
                Append To List    ${clinical_input_error_list}    ${FAILED_TO_CLICK_YES_BUTTON_CONTINUE_SEARCH_POPUP}
            ELSE
                ${filter_applied_completed}=    Set Variable    ${False}
                Append To List    ${clinical_input_error_list}    ${err_msg}
            END
        END

        IF    $filter_applied_completed
            TRY
                Log Message    <---- Check record available or not ---->
                SCREEN_ClinicalInput.axn-check-no-record-image
                Set To Dictionary    ${output_response_dict}    CLINICALINPUT RECORDS=Record Found
            EXCEPT    AS    ${err_msg}
                IF    '${err_msg}' == 'NO_RECORD_AVAILABLE_IN_CLINICAL_INPUT'
                    Append To List    ${clinical_input_error_list}    ${err_msg}
                    Set To Dictionary    ${output_response_dict}    CLINICALINPUT RECORDS=No Record Found
                    Log Message    RECORDS    NOT AVAILABLE IN CLINICAL INPUT
                ELSE IF    '${err_msg}' == 'UNABLE_TO_CHECK_RECORD_LOADED_OR_NOT_IN_CLINICAL_INPUT'
                    Log Message    RECORDS    AVAILABLE IN CLINICAL INPUT
                ELSE
                    Append To List    ${clinical_input_error_list}    ${err_msg}
                END
            END
            ${no_record_check_clinical_input}=    Evaluate
            ...    'NO_RECORD_AVAILABLE_IN_CLINICAL_INPUT' in ${clinical_input_error_list}
            IF    $no_record_check_clinical_input
                Log Message    NO RECORD AVAILABLE IN CLINICAL INPUT
            ELSE
                TRY
                    ${is_select_first_record_completed}=    Set Variable    ${True}
                    UTIL_Common.util-get-current-window-title
                    SCREEN_ClinicalInput.validate-precondition
                    SCREEN_WorkFlowConsole.select-first-record-with-note-preview    left_click
                    Set To Dictionary    ${output_response_dict}    CLINICALINPUT SELECT FIRSTRECORD= Success
                EXCEPT    AS    ${err_msg}
                    Set To Dictionary    ${output_response_dict}    CLINICALINPUT SELECT FIRSTRECORD= Failed

                    IF    '${err_msg}' == 'UNABLE_TO_ACCESS_CLINICAL_INPUT_WINDOW'
                        ${is_select_first_record_completed}=    Set Variable    ${False}
                        Append To List    ${clinical_input_error_list}    ${UNABLE_TO_ACCESS_CLINICAL_INPUT_WINDOW}
                    ELSE
                        ${is_select_first_record_completed}=    Set Variable    ${False}
                        Append To List
                        ...    ${clinical_input_error_list}
                        ...    ${FAILED_TO_SELECT_FIRST_RECORD_IN_CLINICAL_INPUT}
                    END
                END
                IF    $is_select_first_record_completed
                    TRY
                        ${add_conotes_nav_completed}=    Set Variable    ${True}
                        FN_NavigationFromClinicalInput.fn-nav-in-clinical-input    ${add_co_note_navigation}
                        Set To Dictionary    ${output_response_dict}    MEDICARE RECORD INFO BUTTON= Found
                        Set To Dictionary    ${output_response_dict}    ADDCOORDINATION BUTTON= Found
                    EXCEPT    AS    ${err_msg}
                        ${add_conotes_nav_completed}=    Set Variable    ${False}
                        IF    '${err_msg}' == 'MEDICARE_RECORD_INFO_BUTTON_NOT_FOUND'
                            Set To Dictionary    ${output_response_dict}    MEDICARE RECORD INFO BUTTON= Not Found
                            Set To Dictionary    ${output_response_dict}    ADDCOORDINATION BUTTON= Not Found
                            Append To List    ${clinical_input_error_list}    ${MEDICARE_RECORD_INFO_BUTTON_NOT_FOUND}
                        ELSE IF    '${err_msg}' == 'ADD_COORDINATION_BUTTON_NOT_FOUND'
                            Set To Dictionary    ${output_response_dict}    MEDICARE RECORD INFO BUTTON= Found
                            Set To Dictionary    ${output_response_dict}    ADDCOORDINATION BUTTON= Not Found
                            Append To List    ${clinical_input_error_list}    ${ADD_COORDINATION_BUTTON_NOT_FOUND}
                        ELSE IF    '${err_msg}' == 'UNABLE_TO_ACCESS_EXPECTED_OUPUT_WINDOW'
                            Set To Dictionary    ${output_response_dict}    MEDICARE RECORD INFO BUTTON= Found
                            Set To Dictionary    ${output_response_dict}    ADDCOORDINATION BUTTON= Not Found
                            Append To List    ${clinical_input_error_list}    ${UNABLE_TO_ACCESS_EXPECTED_OUPUT_WINDOW}
                        ELSE
                            Set To Dictionary    ${output_response_dict}    MEDICARE RECORD INFO BUTTON= Not Found
                            Set To Dictionary    ${output_response_dict}    ADDCOORDINATION BUTTON= Not Found
                            Append To List    ${clinical_input_error_list}    ${err_msg}
                        END
                    END
                    IF    $add_conotes_nav_completed
                        ${Notetype_list}=    Set Variable    ${ConotesObject}[noteType]
                        ${failed_note_type_list}=    Create List

                        FOR    ${item}    IN    @{Notetype_list}
                            TRY
                                ${add_button_visible}=    Set Variable    ${True}
                                SCREEN_CoordinationNotesFor.axn-click-add
                                Set To Dictionary    ${output_response_dict}    ADD BUTTON= Found
                            EXCEPT    AS    ${err_msg}
                                ${add_button_visible}=    Set Variable    ${False}
                                IF    '${err_msg}' == 'UNABLE_TO_CLICK_ADD_BUTTON_COORDINATION_NOTES_FOR_SCREEN'
                                    Append To List    ${clinical_input_error_list}    ADD_BUTTON_NOT_FOUND
                                    Log Message    ADD_BUTTON_NOT_FOUND
                                ELSE
                                    Append To List    ${clinical_input_error_list}    ${err_msg}
                                END
                            END
                            IF    $add_button_visible
                                ${failed_note_type_list}=
                                ...    FN_AddOrEditCoordinationNote.fn-add-or-edit-coordination-note
                                ...    ${item}
                                ...    ${failed_note_type_list}
                                ${window_list}=    Create List    HCHB Main    Clinical Input    Coordination Notes for
                                Close Citrix Window    ${window_list}    False
                            ELSE
                                Set To Dictionary    ${output_response_dict}    ADD BUTTON=Not Found
                                Append To List    ${failed_note_type_list}    ${item}
                            END
                        END
                        FOR    ${item}    IN    @{Notetype_list}
                            ${noteType_check}=    Evaluate    $item in ${failed_note_type_list}
                            IF    $noteType_check
                                Append To List    ${NoteTypeListFormat}    ${Item} = NoteType Not Available
                            ELSE
                                Append To List    ${NoteTypeListFormat}    ${Item} = NoteType Available
                            END
                        END
                        ${joinedNoteType}=    Evaluate    "\\n".join(${NoteTypeListFormat})
                        Log Message    NotetYPE:${joinedNoteType}
                        Set To Dictionary    ${output_response_dict}    REPORTS=${joinedNoteType}

                        ${window_list}=    Create List    HCHB Main    Clinical Input
                        Close Citrix Window    ${window_list}    False
                    ELSE
                        TRY
                            RPA.Desktop.Press keys    esc
                            ${patient_information_tab_completed}=    Set Variable    ${True}
                            RPA.Desktop.Press keys    tab
                            RPA.Desktop.Press keys    tab
                            SCREEN_ClinicalInput.axn-click-patient-information
                            ...    medical_record_info
                            ...    patient_information
                            Set To Dictionary    ${output_response_dict}    MEDICARE RECORD INFO BUTTON= Found
                            Set To Dictionary    ${output_response_dict}    PATIENT INFORMATION BUTTON= Found
                        EXCEPT    AS    ${err_msg}
                            ${patient_information_tab_completed}=    Set Variable    ${False}
                            IF    '${err_msg}' == 'MEDICARE_RECORD_INFO_BUTTON_NOT_FOUND'
                                Set To Dictionary    ${output_response_dict}    MEDICARE RECORD INFO BUTTON= Not Found
                                Set To Dictionary    ${output_response_dict}    PATIENT INFORMATION BUTTON= Not Found
                                Append To List
                                ...    ${clinical_input_error_list}
                                ...    ${MEDICARE_RECORD_INFO_BUTTON_NOT_FOUND}
                                Log Message    MEDICARE_RECORD_INFO_BUTTON_NOT_FOUND
                            ELSE IF    '${err_msg}' == 'PATIENT_INFORMATION_BUTTON_NOT_FOUND'
                                Set To Dictionary    ${output_response_dict}    MEDICARE RECORD INFO BUTTON= Found
                                Set To Dictionary    ${output_response_dict}    PATIENT INFORMATION BUTTON= Not Found
                                Append To List
                                ...    ${clinical_input_error_list}
                                ...    ${PATIENT_INFORMATION_BUTTON_NOT_FOUND}
                                Log Message    PATIENT_INFORMATION_BUTTON_NOT_FOUND
                            ELSE
                                Set To Dictionary    ${output_response_dict}    MEDICARE RECORD INFO BUTTON= Not Found
                                Set To Dictionary    ${output_response_dict}    PATIENT INFORMATION BUTTON= Not Found
                                Append To List    ${clinical_input_error_list}    ${err_msg}
                            END
                        END
                        IF    $patient_information_tab_completed
                            TRY
                                ${print_patient_info_click_successfully}=    Set Variable    ${True}
                                RPA.Desktop.Press keys    tab
                                RPA.Desktop.Press keys    tab
                                SCREEN_EditReferral.axn-click-print-patient-info
                                Set To Dictionary    ${output_response_dict}    PRINT PATIENT INFO BUTTON= Found
                            EXCEPT    AS    ${err_msg}
                                ${print_patient_info_click_successfully}=    Set Variable    ${False}
                                Set To Dictionary    ${output_response_dict}    PRINT PATIENT INFO BUTTON= Not Found
                                IF    '${err_msg}' == 'PRINT_PATIENT_INFO_BUTTON_NOT_FOUND'
                                    Append To List
                                    ...    ${clinical_input_error_list}
                                    ...    ${PRINT_PATIENT_INFO_BUTTON_NOT_FOUND}
                                ELSE
                                    Append To List    ${clinical_input_error_list}    ${err_msg}
                                END
                            END
                            IF    $print_patient_info_click_successfully
                                TRY
                                    ${include_conotes_click_successfully}=    Set Variable    ${True}
                                    SCREEN_EditReferral.axn-click-include-coordination-notes-no
                                    Set To Dictionary
                                    ...    ${output_response_dict}
                                    ...    INCLUDE COORDINATION NO BUTTON= Found
                                EXCEPT    AS    ${err_msg}
                                    ${include_conotes_click_successfully}=    Set Variable    ${False}
                                    Set To Dictionary
                                    ...    ${output_response_dict}
                                    ...    INCLUDE COORDINATION NO BUTTON= Not Found

                                    IF    '${err_msg}' == 'INCLUDE_COORIDINATION_NOTES_NO_BUTTON_NOT_FOUND'
                                        Append To List
                                        ...    ${clinical_input_error_list}
                                        ...    ${INCLUDE_COORIDINATION_NOTES_NO_BUTTON_NOT_FOUND}
                                        Log Message    INCLUDE COORDINATION NO BUTTON NOT FOUND
                                    ELSE
                                        Append To List    ${clinical_input_error_list}    ${err_msg}
                                    END
                                END
                                IF    $include_conotes_click_successfully
                                    TRY
                                        TRY
                                            ${Patientinformation_window}=    Set Variable
                                            ...    ${locators}[e5][hchb][screens][edit_referral][patient_information_title]
                                            Wait Until Keyword Succeeds
                                            ...    ${GLOBAL_NETWORK_RETRY_COUNT}
                                            ...    ${GLOBAL_RETRY_TIMEOUT}
                                            ...    UTIL_Common.util-activate-window-until-success
                                            ...    ${Patientinformation_window}
                                        EXCEPT    AS    ${err_msg}
                                            EX_Exception.ex-fail    ${UNABLE_TO_OPEN_PATIENT_INFORMATION_REPORT_WINDOW}
                                        END
                                        ${window_list}=    Create List    HCHB Main    Edit Referral    Clinical Input
                                        Close Citrix Window    ${window_list}    False
                                        Set To Dictionary
                                        ...    ${output_response_dict}
                                        ...    PATIENT INFORMATION REPORT OPENED= Success
                                    EXCEPT    AS    ${err_msg}
                                        ${window_list}=    Create List    HCHB Main    Edit Referral    Clinical Input
                                        Close Citrix Window    ${window_list}    False
                                        Log Message    PATIENT INFORMATION REPORT OPENED_FAILED

                                        Set To Dictionary
                                        ...    ${output_response_dict}
                                        ...    PATIENT INFORMATION REPORT OPENED= Failed
                                    END
                                ELSE
                                    Log Message    INCLUDE COORDINATION NO BUTTON CLICK FAILED
                                END
                            ELSE
                                Log Message    PRINT_PATIENT_INFO_BUTTON_CLICK_FAILED
                            END
                        ELSE
                            Log Message    PATIENT INFORMATION NAVIGATION FAILED
                        END
                    END
                END
            ELSE
                Log Message    UNABLE TO SELECT FIRST RECORD
            END
        ELSE
            Log Message    CLINICAL INPUT PANEL FILTER APPLY FAILED
        END

        ${window_list}=    Create List    HCHB Main
        Close Citrix Window    ${window_list}    False
    END

maintain-physicians-actions
    [Documentation]    function performs to worn on maintain physicians console related validations
    [Tags]    robot:private
    [Arguments]    ${physicians_input_error_list}
    TRY
        FN_MainMenuNavigate_v1.fn-main-menu-navigate_v1    Facilities

        TRY
            ${window_list}=    Create List    Facilities
            Close Citrix Window    ${window_list}    True
        EXCEPT    AS    ${err_msg}
            Log Message    Failed to close window
        END
        Set To Dictionary    ${output_response_dict}    MAINTAIN FACILITIES NAVIGATION=Success
    EXCEPT    AS    ${err_msg}
        RPA.Desktop.Press keys    esc
        RPA.Desktop.Press keys    esc
        Append To List    ${facilities_input_error_list}    ${MAINTAIN_FACILITIES_NAVIGATION_FAILED}
        Set To Dictionary    ${output_response_dict}    MAINTAIN FACILITIES NAVIGATION=Failed
    END
    # END

maintain-facility-actions
    [Documentation]    function performs to worn on maintain physicians console related validations
    [Tags]    robot:private
    [Arguments]    ${facilities_input_error_list}
    TRY
        FN_MainMenuNavigate_v1.fn-main-menu-navigate_v1    Physicians

        TRY
            ${window_list}=    Create List    Physicians
            Close Citrix Window    ${window_list}    True
        EXCEPT    AS    ${err_msg}
            Log Message    Failed to close window
        END
        Set To Dictionary    ${output_response_dict}    MAINTAIN PHYSICIANS NAVIGATION=Success
    EXCEPT    AS    ${err_msg}
        RPA.Desktop.Press keys    esc
        RPA.Desktop.Press keys    esc
        Append To List    ${physicians_input_error_list}    ${MAINTAIN_PHYSICIANS_NAVIGATION_FAILED}
        Set To Dictionary    ${output_response_dict}    MAINTAIN PHYSICIANS NAVIGATION=Failed
    END
    ${window_list}=    Create List    HCHB Main
    Close Citrix Window    ${window_list}    True
