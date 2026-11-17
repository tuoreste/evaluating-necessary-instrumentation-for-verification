; ModuleID = '/tmp/cover-ir-wy4oszh0/input.bc'
source_filename = "/workspace/tests/data-race-read/irecv-read-before-wait.buggy.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ContractValuePair = type { ptr, ptr }
%struct.ompi_predefined_request_t = type opaque
%struct.ompi_predefined_op_t = type opaque
%struct.ompi_predefined_communicator_t = type opaque
%struct.ompi_predefined_datatype_t = type opaque
%Tag_t = type { ptr, i32 }
%Reference_t = type { ptr, ptr }
%RWOp_t = type { i32, i32, i1 }
%MathExpr_t = type { i32, i1, i32, ptr }
%MemOpFunc_t = type { ptr, ptr, ptr }
%AllocOp_t = type { i32, i32, ptr, i32, ptr, i32 }
%ContractFormula_t = type { ptr, i32, i32, ptr, ptr }
%CallTagOp_t = type { ptr, ptr, i32 }
%ParamReq_t = type { i32, ptr, i1, i1 }
%ParamOp_t = type { i32, ptr, i32, i1 }
%CallParam_t = type { i32, i1, i32, i32 }
%ReleaseOp_t = type { ptr, i32, ptr, i32 }
%Contract_t = type { ptr, ptr, ptr, ptr }
%ContractDB_t = type { ptr, i32, %TagsMap_t, ptr, i32 }
%TagsMap_t = type { ptr, ptr, i32 }

@.str = private unnamed_addr constant [5 x i8] c"NULL\00", align 1, !dbg !0
@ContractValueInfo_0 = internal global %struct.ContractValuePair { ptr @.str, ptr null }, align 1, !dbg !7
@.str.1 = private unnamed_addr constant [11 x i8] c"MPI_BOTTOM\00", align 1, !dbg !34
@ContractValueInfo_1 = internal global %struct.ContractValuePair { ptr @.str.1, ptr null }, align 1, !dbg !39
@.str.2 = private unnamed_addr constant [14 x i8] c"MPI_PROC_NULL\00", align 1, !dbg !49
@ContractValueInfo_2 = internal global %struct.ContractValuePair { ptr @.str.2, ptr inttoptr (i64 -2 to ptr) }, align 1, !dbg !54
@.str.3 = private unnamed_addr constant [15 x i8] c"MPI_ANY_SOURCE\00", align 1, !dbg !56
@ContractValueInfo_3 = internal global %struct.ContractValuePair { ptr @.str.3, ptr inttoptr (i64 -1 to ptr) }, align 1, !dbg !61
@.str.4 = private unnamed_addr constant [12 x i8] c"MPI_ANY_TAG\00", align 1, !dbg !63
@ContractValueInfo_4 = internal global %struct.ContractValuePair { ptr @.str.4, ptr inttoptr (i64 -1 to ptr) }, align 1, !dbg !68
@.str.5 = private unnamed_addr constant [13 x i8] c"MPI_IN_PLACE\00", align 1, !dbg !70
@ContractValueInfo_5 = internal global %struct.ContractValuePair { ptr @.str.5, ptr inttoptr (i64 1 to ptr) }, align 1, !dbg !75
@.str.6 = private unnamed_addr constant [17 x i8] c"MPI_REQUEST_NULL\00", align 1, !dbg !77
@ompi_request_null = external global %struct.ompi_predefined_request_t, align 1
@ContractValueInfo_6 = internal global %struct.ContractValuePair { ptr @.str.6, ptr @ompi_request_null }, align 1, !dbg !82
@.str.7 = private unnamed_addr constant [12 x i8] c"MPI_OP_NULL\00", align 1, !dbg !84
@ompi_mpi_op_null = external global %struct.ompi_predefined_op_t, align 1
@ContractValueInfo_7 = internal global %struct.ContractValuePair { ptr @.str.7, ptr @ompi_mpi_op_null }, align 1, !dbg !86
@.str.8 = private unnamed_addr constant [14 x i8] c"MPI_COMM_NULL\00", align 1, !dbg !88
@ompi_mpi_comm_null = external global %struct.ompi_predefined_communicator_t, align 1
@ContractValueInfo_8 = internal global %struct.ContractValuePair { ptr @.str.8, ptr @ompi_mpi_comm_null }, align 1, !dbg !90
@.str.9 = private unnamed_addr constant [15 x i8] c"MPI_COMM_WORLD\00", align 1, !dbg !92
@ompi_mpi_comm_world = external global %struct.ompi_predefined_communicator_t, align 1
@ContractValueInfo_9 = internal global %struct.ContractValuePair { ptr @.str.9, ptr @ompi_mpi_comm_world }, align 1, !dbg !94
@.str.10 = private unnamed_addr constant [18 x i8] c"MPI_STATUS_IGNORE\00", align 1, !dbg !96
@ContractValueInfo_10 = internal global %struct.ContractValuePair { ptr @.str.10, ptr null }, align 1, !dbg !101
@.str.11 = private unnamed_addr constant [20 x i8] c"MPI_STATUSES_IGNORE\00", align 1, !dbg !103
@ContractValueInfo_11 = internal global %struct.ContractValuePair { ptr @.str.11, ptr null }, align 1, !dbg !108
@.str.12 = private unnamed_addr constant [18 x i8] c"MPI_DATATYPE_NULL\00", align 1, !dbg !110
@ompi_mpi_datatype_null = external global %struct.ompi_predefined_datatype_t, align 1
@ContractValueInfo_12 = internal global %struct.ContractValuePair { ptr @.str.12, ptr @ompi_mpi_datatype_null }, align 1, !dbg !112
@ompi_mpi_int = external global %struct.ompi_predefined_datatype_t, align 1
@.str.13 = private unnamed_addr constant [17 x i8] c"rank 1 read: %d\0A\00", align 1, !dbg !114
@.str.14 = private unnamed_addr constant [37 x i8] c"CONTRACT{POST { alloc!(0[1 _arg]) }}\00", section "llvm.metadata"
@.str.15 = private unnamed_addr constant [35 x i8] c"/opt/cover/include/mpi_contracts.h\00", section "llvm.metadata"
@.str.16 = private unnamed_addr constant [28 x i8] c"CONTRACT{POST { free!(0) }}\00", section "llvm.metadata"
@.str.17 = private unnamed_addr constant [39 x i8] c"CONTRACT{POST { alloc!(0[ 1 _arg ]) }}\00", section "llvm.metadata"
@.str.18 = private unnamed_addr constant [89 x i8] c"CONTRACT{POST { call_tag!(mpi_exit) MSG \22Missing Finalization call\22 } TAGS { mpi_init }}\00", section "llvm.metadata"
@.str.19 = private unnamed_addr constant [133 x i8] c"CONTRACT{PRE { call_tag!(mpi_init) MSG \22Missing Initialization call\22 } POST { call_tag!(mpi_exit) MSG \22Missing Finalization call\22 }}\00", section "llvm.metadata"
@.str.20 = private unnamed_addr constant [491 x i8] c"CONTRACT{PRE { call_tag!(mpi_init) MSG \22Missing Initialization call\22, param!(5:^=MPI_COMM_WORLD,!=NULL,!=MPI_COMM_NULL) MSG \22Communicator is invalid\22, param!(3:^=MPI_PROC_NULL,>=0) MSG \22Rank is invalid\22, param!(0:!=NULL,!=MPI_IN_PLACE,!=MPI_BOTTOM) MSG \22Parameter is null, MPI_IN_PLACE, or MPI_BOTTOM\22, alloc!(0) MSG \22Buffer is not allocated\22, param!(4:!=MPI_ANY_TAG,>=0) MSG \22Tag is invalid\22 } POST { call_tag!(mpi_exit) MSG \22Missing Finalization call\22 } TAGS { buf_read(0), type_use(2) }}\00", section "llvm.metadata"
@.str.21 = private unnamed_addr constant [1316 x i8] c"CONTRACT{PRE { call_tag!(mpi_init) MSG \22Missing Initialization call\22, param!(5:^=MPI_COMM_WORLD,!=NULL,!=MPI_COMM_NULL) MSG \22Communicator is invalid\22, param!(0:!=NULL,!=MPI_IN_PLACE,!=MPI_BOTTOM) MSG \22Parameter is null, MPI_IN_PLACE, or MPI_BOTTOM\22, alloc!(0) MSG \22Buffer is not allocated\22 } POST { call_tag!(mpi_exit) MSG \22Missing Finalization call\22, (no! (call_tag!(request_gen,$:6)) until! (call_tag!(req_complete,$:6)) | no! (call_tag!(request_gen,$:6)) until! (call_tag!(req_complete_noidx))) MSG \22Double Request Use\22, (call_tag!(req_complete,$:6) | call_tag!(req_complete_noidx)) MSG \22Request Leak\22, (no! (read!(*0)) until! (call_tag!(req_complete,$:6)) | no! (read!(*0)) until! (call_tag!(req_complete_noidx))) MSG \22Local Data Race - Local read\22, (no! (call_tag!(buf_read,$:0)) until! (call_tag!(req_complete,$:6)) | no! (call_tag!(buf_read,$:0)) until! (call_tag!(req_complete_noidx))) MSG \22Local Data Race - Local read by call\22, (no! (write!(*0)) until! (call_tag!(req_complete,$:6)) | no! (write!(*0)) until! (call_tag!(req_complete_noidx))) MSG \22Local Data Race - Local write\22, (no! (call_tag!(buf_write,$:0)) until! (call_tag!(req_complete,$:6)) | no! (call_tag!(buf_write,$:0)) until! (call_tag!(req_complete_noidx))) MSG \22Local Data Race - Local write by call\22 } TAGS { request_gen(6), buf_write(0) }}\00", section "llvm.metadata"
@.str.22 = private unnamed_addr constant [291 x i8] c"CONTRACT{PRE { call_tag!(mpi_init) MSG \22Missing Initialization call\22, call_tag!(request_gen,$:0) MSG \22Unmatched Wait\22, param!(1:^=MPI_STATUS_IGNORE,!=NULL,!=MPI_STATUSES_IGNORE) MSG \22Status is invalid\22 } POST { call_tag!(mpi_exit) MSG \22Missing Finalization call\22 } TAGS { req_complete(0) }}\00", section "llvm.metadata"
@.str.23 = private unnamed_addr constant [90 x i8] c"CONTRACT{PRE { call_tag!(mpi_init) MSG \22Missing Initialization call\22 } TAGS { mpi_exit }}\00", section "llvm.metadata"
@llvm.global.annotations = appending global [9 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @CoVer_AllocStack, ptr @.str.14, ptr @.str.15, i32 36, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @CoVer_FreeStack, ptr @.str.16, ptr @.str.15, i32 37, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @CoVer_RegisterGlobal, ptr @.str.17, ptr @.str.15, i32 39, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @MPI_Init, ptr @.str.18, ptr @.str.15, i32 2882, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @MPI_Comm_rank, ptr @.str.19, ptr @.str.15, i32 1130, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @MPI_Send, ptr @.str.20, ptr @.str.15, i32 4374, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @MPI_Irecv, ptr @.str.21, ptr @.str.15, i32 2946, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @MPI_Wait, ptr @.str.22, ptr @.str.15, i32 5347, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @MPI_Finalize, ptr @.str.23, ptr @.str.15, i32 2221, ptr null }], section "llvm.metadata"
@llvm.compiler.used = appending global [13 x ptr] [ptr @ContractValueInfo_0, ptr @ContractValueInfo_1, ptr @ContractValueInfo_2, ptr @ContractValueInfo_3, ptr @ContractValueInfo_4, ptr @ContractValueInfo_5, ptr @ContractValueInfo_6, ptr @ContractValueInfo_7, ptr @ContractValueInfo_8, ptr @ContractValueInfo_9, ptr @ContractValueInfo_10, ptr @ContractValueInfo_11, ptr @ContractValueInfo_12], section "llvm.metadata"
@CONTR_TAG_STR_mpi_init = global [9 x i8] c"mpi_init\00"
@CONTR_TAG_STR_buf_read = global [9 x i8] c"buf_read\00"
@CONTR_TAG_STR_type_use = global [9 x i8] c"type_use\00"
@CONTR_TAG_STR_request_gen = global [12 x i8] c"request_gen\00"
@CONTR_TAG_STR_buf_write = global [10 x i8] c"buf_write\00"
@CONTR_TAG_STR_req_complete = global [13 x i8] c"req_complete\00"
@CONTR_TAG_STR_mpi_exit = global [9 x i8] c"mpi_exit\00"
@CONTR_TAG_ARRAY_PTRS = global [7 x ptr] [ptr @MPI_Init, ptr @MPI_Send, ptr @MPI_Send, ptr @MPI_Irecv, ptr @MPI_Irecv, ptr @MPI_Wait, ptr @MPI_Finalize]
@CONTR_TAG_ARRAY_TAGS = global [7 x %Tag_t] [%Tag_t { ptr @CONTR_TAG_STR_mpi_init, i32 -1 }, %Tag_t { ptr @CONTR_TAG_STR_buf_read, i32 0 }, %Tag_t { ptr @CONTR_TAG_STR_type_use, i32 2 }, %Tag_t { ptr @CONTR_TAG_STR_request_gen, i32 6 }, %Tag_t { ptr @CONTR_TAG_STR_buf_write, i32 0 }, %Tag_t { ptr @CONTR_TAG_STR_req_complete, i32 0 }, %Tag_t { ptr @CONTR_TAG_STR_mpi_exit, i32 -1 }]
@"CONTR_ERROR_TYPE_Local Data Race - Local read" = global [29 x i8] c"Local Data Race - Local read\00"
@"CONTR_REFERENCE_/workspace/tests/data-race-read/irecv-read-before-wait.buggy.c:18" = global [66 x i8] c"/workspace/tests/data-race-read/irecv-read-before-wait.buggy.c:18\00"
@"CONTR_REFERENCE_/workspace/tests/data-race-read/irecv-read-before-wait.buggy.c:17" = global [66 x i8] c"/workspace/tests/data-race-read/irecv-read-before-wait.buggy.c:17\00"
@CONTR_LIST_REFERENCES = global [4 x %Reference_t] [%Reference_t { ptr @"CONTR_REFERENCE_/workspace/tests/data-race-read/irecv-read-before-wait.buggy.c:18", ptr @"CONTR_ERROR_TYPE_Local Data Race - Local read" }, %Reference_t { ptr @"CONTR_REFERENCE_/workspace/tests/data-race-read/irecv-read-before-wait.buggy.c:17", ptr @"CONTR_ERROR_TYPE_Local Data Race - Local read" }, %Reference_t { ptr @"CONTR_REFERENCE_/workspace/tests/data-race-read/irecv-read-before-wait.buggy.c:18", ptr @"CONTR_ERROR_TYPE_Local Data Race - Local read" }, %Reference_t { ptr @"CONTR_REFERENCE_/workspace/tests/data-race-read/irecv-read-before-wait.buggy.c:17", ptr @"CONTR_ERROR_TYPE_Local Data Race - Local read" }]
@CONTR_SCOPE_STR_ = global [11 x i8] c"Full Scope\00"
@"CONTR_MSG_alloc!(0[1_arg])" = global [17 x i8] c"alloc!(0[1_arg])\00"
@CONTR_RWOP_0 = global %RWOp_t zeroinitializer
@CONT_MATHEXPR_1 = global %MathExpr_t { i32 1, i1 true, i32 0, ptr null }
@CONTR_RWOP_2 = global %RWOp_t zeroinitializer
@CONTR_RWOP_3 = global %RWOp_t zeroinitializer
@CONT_MATHEXPR_4 = global %MathExpr_t { i32 1, i1 true, i32 0, ptr null }
@CONTR_ALLOCATOR_LIST = global [2 x %MemOpFunc_t] [%MemOpFunc_t { ptr @CoVer_AllocStack, ptr @CONTR_RWOP_0, ptr @CONT_MATHEXPR_1 }, %MemOpFunc_t { ptr @CoVer_RegisterGlobal, ptr @CONTR_RWOP_3, ptr @CONT_MATHEXPR_4 }]
@CONTR_DEALLOCATOR_LIST = global [1 x %MemOpFunc_t] [%MemOpFunc_t { ptr @CoVer_FreeStack, ptr @CONTR_RWOP_2, ptr null }]
@CONTR_ALLOCOP_5 = global %AllocOp_t { i32 0, i32 0, ptr @CONTR_ALLOCATOR_LIST, i32 2, ptr @CONTR_DEALLOCATOR_LIST, i32 1 }
@CONTR_SCOPECONDITIONS_6 = global [1 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 6, ptr @"CONTR_MSG_alloc!(0[1_arg])", ptr @CONTR_ALLOCOP_5 }]
@CONTR_SCOPE_7 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_6, i32 1, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_FUNC_STR_CoVer_AllocStack = global [17 x i8] c"CoVer_AllocStack\00"
@"CONTR_MSG_free!(0)" = global [9 x i8] c"free!(0)\00"
@UNKNOWN_8 = global ptr null
@CONTR_SCOPECONDITIONS_9 = global [1 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 7, ptr @"CONTR_MSG_free!(0)", ptr @UNKNOWN_8 }]
@CONTR_SCOPE_10 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_9, i32 1, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_FUNC_STR_CoVer_FreeStack = global [16 x i8] c"CoVer_FreeStack\00"
@CONTR_ALLOCOP_11 = global %AllocOp_t { i32 0, i32 0, ptr @CONTR_ALLOCATOR_LIST, i32 2, ptr @CONTR_DEALLOCATOR_LIST, i32 1 }
@CONTR_SCOPECONDITIONS_12 = global [1 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 6, ptr @"CONTR_MSG_alloc!(0[1_arg])", ptr @CONTR_ALLOCOP_11 }]
@CONTR_SCOPE_13 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_12, i32 1, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_FUNC_STR_CoVer_RegisterGlobal = global [21 x i8] c"CoVer_RegisterGlobal\00"
@"CONTR_MSG_Missing Finalization call" = global [26 x i8] c"Missing Finalization call\00"
@CONTR_CALLTAGOP_14 = global %CallTagOp_t { ptr @CONTR_TAG_STR_mpi_exit, ptr null, i32 0 }
@CONTR_SCOPECONDITIONS_15 = global [1 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Missing Finalization call", ptr @CONTR_CALLTAGOP_14 }]
@CONTR_SCOPE_16 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_15, i32 1, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_FUNC_STR_MPI_Init = global [9 x i8] c"MPI_Init\00"
@"CONTR_MSG_Missing Initialization call" = global [28 x i8] c"Missing Initialization call\00"
@CONTR_CALLTAGOP_17 = global %CallTagOp_t { ptr @CONTR_TAG_STR_mpi_init, ptr null, i32 0 }
@CONTR_SCOPECONDITIONS_18 = global [1 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Missing Initialization call", ptr @CONTR_CALLTAGOP_17 }]
@CONTR_SCOPE_19 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_18, i32 1, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_CALLTAGOP_20 = global %CallTagOp_t { ptr @CONTR_TAG_STR_mpi_exit, ptr null, i32 0 }
@CONTR_SCOPECONDITIONS_21 = global [1 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Missing Finalization call", ptr @CONTR_CALLTAGOP_20 }]
@CONTR_SCOPE_22 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_21, i32 1, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_FUNC_STR_MPI_Comm_rank = global [14 x i8] c"MPI_Comm_rank\00"
@CONTR_CALLTAGOP_23 = global %CallTagOp_t { ptr @CONTR_TAG_STR_mpi_init, ptr null, i32 0 }
@"CONTR_MSG_Communicator is invalid" = global [24 x i8] c"Communicator is invalid\00"
@CONTR_PARAM_REQS_24 = global [3 x %ParamReq_t] [%ParamReq_t { i32 5, ptr @ompi_mpi_comm_world, i1 false, i1 false }, %ParamReq_t zeroinitializer, %ParamReq_t { i32 0, ptr @ompi_mpi_comm_null, i1 false, i1 false }]
@CONTR_PARAMOP_25 = global %ParamOp_t { i32 5, ptr @CONTR_PARAM_REQS_24, i32 3, i1 false }
@"CONTR_MSG_Rank is invalid" = global [16 x i8] c"Rank is invalid\00"
@CONTR_PARAM_REQS_26 = global [2 x %ParamReq_t] [%ParamReq_t { i32 5, ptr inttoptr (i64 -2 to ptr), i1 false, i1 false }, %ParamReq_t { i32 2, ptr null, i1 false, i1 false }]
@CONTR_PARAMOP_27 = global %ParamOp_t { i32 3, ptr @CONTR_PARAM_REQS_26, i32 2, i1 false }
@"CONTR_MSG_Parameter is null, MPI_IN_PLACE, or MPI_BOTTOM" = global [47 x i8] c"Parameter is null, MPI_IN_PLACE, or MPI_BOTTOM\00"
@CONTR_PARAM_REQS_28 = global [3 x %ParamReq_t] [%ParamReq_t zeroinitializer, %ParamReq_t { i32 0, ptr inttoptr (i64 1 to ptr), i1 false, i1 false }, %ParamReq_t zeroinitializer]
@CONTR_PARAMOP_29 = global %ParamOp_t { i32 0, ptr @CONTR_PARAM_REQS_28, i32 3, i1 false }
@"CONTR_MSG_Buffer is not allocated" = global [24 x i8] c"Buffer is not allocated\00"
@CONTR_ALLOCOP_30 = global %AllocOp_t { i32 0, i32 0, ptr @CONTR_ALLOCATOR_LIST, i32 2, ptr @CONTR_DEALLOCATOR_LIST, i32 1 }
@"CONTR_MSG_Tag is invalid" = global [15 x i8] c"Tag is invalid\00"
@CONTR_PARAM_REQS_31 = global [2 x %ParamReq_t] [%ParamReq_t { i32 0, ptr inttoptr (i64 -1 to ptr), i1 false, i1 false }, %ParamReq_t { i32 2, ptr null, i1 false, i1 false }]
@CONTR_PARAMOP_32 = global %ParamOp_t { i32 4, ptr @CONTR_PARAM_REQS_31, i32 2, i1 false }
@CONTR_SCOPECONDITIONS_33 = global [6 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Missing Initialization call", ptr @CONTR_CALLTAGOP_23 }, %ContractFormula_t { ptr null, i32 0, i32 11, ptr @"CONTR_MSG_Communicator is invalid", ptr @CONTR_PARAMOP_25 }, %ContractFormula_t { ptr null, i32 0, i32 11, ptr @"CONTR_MSG_Rank is invalid", ptr @CONTR_PARAMOP_27 }, %ContractFormula_t { ptr null, i32 0, i32 11, ptr @"CONTR_MSG_Parameter is null, MPI_IN_PLACE, or MPI_BOTTOM", ptr @CONTR_PARAMOP_29 }, %ContractFormula_t { ptr null, i32 0, i32 6, ptr @"CONTR_MSG_Buffer is not allocated", ptr @CONTR_ALLOCOP_30 }, %ContractFormula_t { ptr null, i32 0, i32 11, ptr @"CONTR_MSG_Tag is invalid", ptr @CONTR_PARAMOP_32 }]
@CONTR_SCOPE_34 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_33, i32 6, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_CALLTAGOP_35 = global %CallTagOp_t { ptr @CONTR_TAG_STR_mpi_exit, ptr null, i32 0 }
@CONTR_SCOPECONDITIONS_36 = global [1 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Missing Finalization call", ptr @CONTR_CALLTAGOP_35 }]
@CONTR_SCOPE_37 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_36, i32 1, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_FUNC_STR_MPI_Send = global [9 x i8] c"MPI_Send\00"
@CONTR_CALLTAGOP_38 = global %CallTagOp_t { ptr @CONTR_TAG_STR_mpi_init, ptr null, i32 0 }
@CONTR_PARAM_REQS_39 = global [3 x %ParamReq_t] [%ParamReq_t { i32 5, ptr @ompi_mpi_comm_world, i1 false, i1 false }, %ParamReq_t zeroinitializer, %ParamReq_t { i32 0, ptr @ompi_mpi_comm_null, i1 false, i1 false }]
@CONTR_PARAMOP_40 = global %ParamOp_t { i32 5, ptr @CONTR_PARAM_REQS_39, i32 3, i1 false }
@CONTR_PARAM_REQS_41 = global [3 x %ParamReq_t] [%ParamReq_t zeroinitializer, %ParamReq_t { i32 0, ptr inttoptr (i64 1 to ptr), i1 false, i1 false }, %ParamReq_t zeroinitializer]
@CONTR_PARAMOP_42 = global %ParamOp_t { i32 0, ptr @CONTR_PARAM_REQS_41, i32 3, i1 false }
@CONTR_ALLOCOP_43 = global %AllocOp_t { i32 0, i32 0, ptr @CONTR_ALLOCATOR_LIST, i32 2, ptr @CONTR_DEALLOCATOR_LIST, i32 1 }
@CONTR_SCOPECONDITIONS_44 = global [4 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Missing Initialization call", ptr @CONTR_CALLTAGOP_38 }, %ContractFormula_t { ptr null, i32 0, i32 11, ptr @"CONTR_MSG_Communicator is invalid", ptr @CONTR_PARAMOP_40 }, %ContractFormula_t { ptr null, i32 0, i32 11, ptr @"CONTR_MSG_Parameter is null, MPI_IN_PLACE, or MPI_BOTTOM", ptr @CONTR_PARAMOP_42 }, %ContractFormula_t { ptr null, i32 0, i32 6, ptr @"CONTR_MSG_Buffer is not allocated", ptr @CONTR_ALLOCOP_43 }]
@CONTR_SCOPE_45 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_44, i32 4, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_CALLTAGOP_46 = global %CallTagOp_t { ptr @CONTR_TAG_STR_mpi_exit, ptr null, i32 0 }
@"CONTR_MSG_Double Request Use" = global [19 x i8] c"Double Request Use\00"
@"CONTR_MSG_no!(call_tag!(request_gen,$:6))until!(call_tag!(req_complete,$:6))" = global [67 x i8] c"no!(call_tag!(request_gen,$:6))until!(call_tag!(req_complete,$:6))\00"
@CONTR_PARAMLIST_47 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 6, i32 0 }]
@CONTR_CALLTAGOP_48 = global %CallTagOp_t { ptr @CONTR_TAG_STR_request_gen, ptr @CONTR_PARAMLIST_47, i32 1 }
@CONTR_PARAMLIST_49 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 6, i32 0 }]
@CONTR_CALLTAGOP_50 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete, ptr @CONTR_PARAMLIST_49, i32 1 }
@CONTR_RELEASE_51 = global %ReleaseOp_t { ptr @CONTR_CALLTAGOP_50, i32 9, ptr @CONTR_CALLTAGOP_48, i32 9 }
@"CONTR_MSG_no!(call_tag!(request_gen,$:6))until!(call_tag!(req_complete_noidx))" = global [69 x i8] c"no!(call_tag!(request_gen,$:6))until!(call_tag!(req_complete_noidx))\00"
@CONTR_PARAMLIST_52 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 6, i32 0 }]
@CONTR_CALLTAGOP_53 = global %CallTagOp_t { ptr @CONTR_TAG_STR_request_gen, ptr @CONTR_PARAMLIST_52, i32 1 }
@CONTR_TAG_STR_req_complete_noidx = global [19 x i8] c"req_complete_noidx\00"
@CONTR_CALLTAGOP_54 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete_noidx, ptr null, i32 0 }
@CONTR_RELEASE_55 = global %ReleaseOp_t { ptr @CONTR_CALLTAGOP_54, i32 9, ptr @CONTR_CALLTAGOP_53, i32 9 }
@CONTRACT_CHILDREN_56 = global [2 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 10, ptr @"CONTR_MSG_no!(call_tag!(request_gen,$:6))until!(call_tag!(req_complete,$:6))", ptr @CONTR_RELEASE_51 }, %ContractFormula_t { ptr null, i32 0, i32 10, ptr @"CONTR_MSG_no!(call_tag!(request_gen,$:6))until!(call_tag!(req_complete_noidx))", ptr @CONTR_RELEASE_55 }]
@"CONTR_MSG_Request Leak" = global [13 x i8] c"Request Leak\00"
@"CONTR_MSG_call_tag!(req_complete,$:6)" = global [28 x i8] c"call_tag!(req_complete,$:6)\00"
@CONTR_PARAMLIST_57 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 6, i32 0 }]
@CONTR_CALLTAGOP_58 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete, ptr @CONTR_PARAMLIST_57, i32 1 }
@"CONTR_MSG_call_tag!(req_complete_noidx)" = global [30 x i8] c"call_tag!(req_complete_noidx)\00"
@CONTR_CALLTAGOP_59 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete_noidx, ptr null, i32 0 }
@CONTRACT_CHILDREN_60 = global [2 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_call_tag!(req_complete,$:6)", ptr @CONTR_CALLTAGOP_58 }, %ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_call_tag!(req_complete_noidx)", ptr @CONTR_CALLTAGOP_59 }]
@"CONTR_MSG_Local Data Race - Local read" = global [29 x i8] c"Local Data Race - Local read\00"
@"CONTR_MSG_no!(read!(*0))until!(call_tag!(req_complete,$:6))" = global [50 x i8] c"no!(read!(*0))until!(call_tag!(req_complete,$:6))\00"
@CONTR_RWOP_61 = global %RWOp_t { i32 0, i32 1, i1 false }
@CONTR_PARAMLIST_62 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 6, i32 0 }]
@CONTR_CALLTAGOP_63 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete, ptr @CONTR_PARAMLIST_62, i32 1 }
@CONTR_RELEASE_64 = global %ReleaseOp_t { ptr @CONTR_CALLTAGOP_63, i32 9, ptr @CONTR_RWOP_61, i32 4 }
@"CONTR_MSG_no!(read!(*0))until!(call_tag!(req_complete_noidx))" = global [52 x i8] c"no!(read!(*0))until!(call_tag!(req_complete_noidx))\00"
@CONTR_RWOP_65 = global %RWOp_t { i32 0, i32 1, i1 false }
@CONTR_CALLTAGOP_66 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete_noidx, ptr null, i32 0 }
@CONTR_RELEASE_67 = global %ReleaseOp_t { ptr @CONTR_CALLTAGOP_66, i32 9, ptr @CONTR_RWOP_65, i32 4 }
@CONTRACT_CHILDREN_68 = global [2 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 10, ptr @"CONTR_MSG_no!(read!(*0))until!(call_tag!(req_complete,$:6))", ptr @CONTR_RELEASE_64 }, %ContractFormula_t { ptr null, i32 0, i32 10, ptr @"CONTR_MSG_no!(read!(*0))until!(call_tag!(req_complete_noidx))", ptr @CONTR_RELEASE_67 }]
@"CONTR_MSG_Local Data Race - Local read by call" = global [37 x i8] c"Local Data Race - Local read by call\00"
@"CONTR_MSG_no!(call_tag!(buf_read,$:0))until!(call_tag!(req_complete,$:6))" = global [64 x i8] c"no!(call_tag!(buf_read,$:0))until!(call_tag!(req_complete,$:6))\00"
@CONTR_PARAMLIST_69 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 0, i32 0 }]
@CONTR_CALLTAGOP_70 = global %CallTagOp_t { ptr @CONTR_TAG_STR_buf_read, ptr @CONTR_PARAMLIST_69, i32 1 }
@CONTR_PARAMLIST_71 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 6, i32 0 }]
@CONTR_CALLTAGOP_72 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete, ptr @CONTR_PARAMLIST_71, i32 1 }
@CONTR_RELEASE_73 = global %ReleaseOp_t { ptr @CONTR_CALLTAGOP_72, i32 9, ptr @CONTR_CALLTAGOP_70, i32 9 }
@"CONTR_MSG_no!(call_tag!(buf_read,$:0))until!(call_tag!(req_complete_noidx))" = global [66 x i8] c"no!(call_tag!(buf_read,$:0))until!(call_tag!(req_complete_noidx))\00"
@CONTR_PARAMLIST_74 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 0, i32 0 }]
@CONTR_CALLTAGOP_75 = global %CallTagOp_t { ptr @CONTR_TAG_STR_buf_read, ptr @CONTR_PARAMLIST_74, i32 1 }
@CONTR_CALLTAGOP_76 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete_noidx, ptr null, i32 0 }
@CONTR_RELEASE_77 = global %ReleaseOp_t { ptr @CONTR_CALLTAGOP_76, i32 9, ptr @CONTR_CALLTAGOP_75, i32 9 }
@CONTRACT_CHILDREN_78 = global [2 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 10, ptr @"CONTR_MSG_no!(call_tag!(buf_read,$:0))until!(call_tag!(req_complete,$:6))", ptr @CONTR_RELEASE_73 }, %ContractFormula_t { ptr null, i32 0, i32 10, ptr @"CONTR_MSG_no!(call_tag!(buf_read,$:0))until!(call_tag!(req_complete_noidx))", ptr @CONTR_RELEASE_77 }]
@"CONTR_MSG_Local Data Race - Local write" = global [30 x i8] c"Local Data Race - Local write\00"
@"CONTR_MSG_no!(write!(*0))until!(call_tag!(req_complete,$:6))" = global [51 x i8] c"no!(write!(*0))until!(call_tag!(req_complete,$:6))\00"
@CONTR_RWOP_79 = global %RWOp_t { i32 0, i32 1, i1 true }
@CONTR_PARAMLIST_80 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 6, i32 0 }]
@CONTR_CALLTAGOP_81 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete, ptr @CONTR_PARAMLIST_80, i32 1 }
@CONTR_RELEASE_82 = global %ReleaseOp_t { ptr @CONTR_CALLTAGOP_81, i32 9, ptr @CONTR_RWOP_79, i32 5 }
@"CONTR_MSG_no!(write!(*0))until!(call_tag!(req_complete_noidx))" = global [53 x i8] c"no!(write!(*0))until!(call_tag!(req_complete_noidx))\00"
@CONTR_RWOP_83 = global %RWOp_t { i32 0, i32 1, i1 true }
@CONTR_CALLTAGOP_84 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete_noidx, ptr null, i32 0 }
@CONTR_RELEASE_85 = global %ReleaseOp_t { ptr @CONTR_CALLTAGOP_84, i32 9, ptr @CONTR_RWOP_83, i32 5 }
@CONTRACT_CHILDREN_86 = global [2 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 10, ptr @"CONTR_MSG_no!(write!(*0))until!(call_tag!(req_complete,$:6))", ptr @CONTR_RELEASE_82 }, %ContractFormula_t { ptr null, i32 0, i32 10, ptr @"CONTR_MSG_no!(write!(*0))until!(call_tag!(req_complete_noidx))", ptr @CONTR_RELEASE_85 }]
@"CONTR_MSG_Local Data Race - Local write by call" = global [38 x i8] c"Local Data Race - Local write by call\00"
@"CONTR_MSG_no!(call_tag!(buf_write,$:0))until!(call_tag!(req_complete,$:6))" = global [65 x i8] c"no!(call_tag!(buf_write,$:0))until!(call_tag!(req_complete,$:6))\00"
@CONTR_PARAMLIST_87 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 0, i32 0 }]
@CONTR_CALLTAGOP_88 = global %CallTagOp_t { ptr @CONTR_TAG_STR_buf_write, ptr @CONTR_PARAMLIST_87, i32 1 }
@CONTR_PARAMLIST_89 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 6, i32 0 }]
@CONTR_CALLTAGOP_90 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete, ptr @CONTR_PARAMLIST_89, i32 1 }
@CONTR_RELEASE_91 = global %ReleaseOp_t { ptr @CONTR_CALLTAGOP_90, i32 9, ptr @CONTR_CALLTAGOP_88, i32 9 }
@"CONTR_MSG_no!(call_tag!(buf_write,$:0))until!(call_tag!(req_complete_noidx))" = global [67 x i8] c"no!(call_tag!(buf_write,$:0))until!(call_tag!(req_complete_noidx))\00"
@CONTR_PARAMLIST_92 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 0, i32 0 }]
@CONTR_CALLTAGOP_93 = global %CallTagOp_t { ptr @CONTR_TAG_STR_buf_write, ptr @CONTR_PARAMLIST_92, i32 1 }
@CONTR_CALLTAGOP_94 = global %CallTagOp_t { ptr @CONTR_TAG_STR_req_complete_noidx, ptr null, i32 0 }
@CONTR_RELEASE_95 = global %ReleaseOp_t { ptr @CONTR_CALLTAGOP_94, i32 9, ptr @CONTR_CALLTAGOP_93, i32 9 }
@CONTRACT_CHILDREN_96 = global [2 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 10, ptr @"CONTR_MSG_no!(call_tag!(buf_write,$:0))until!(call_tag!(req_complete,$:6))", ptr @CONTR_RELEASE_91 }, %ContractFormula_t { ptr null, i32 0, i32 10, ptr @"CONTR_MSG_no!(call_tag!(buf_write,$:0))until!(call_tag!(req_complete_noidx))", ptr @CONTR_RELEASE_95 }]
@CONTR_SCOPECONDITIONS_97 = global [7 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Missing Finalization call", ptr @CONTR_CALLTAGOP_46 }, %ContractFormula_t { ptr @CONTRACT_CHILDREN_56, i32 2, i32 1, ptr @"CONTR_MSG_Double Request Use", ptr null }, %ContractFormula_t { ptr @CONTRACT_CHILDREN_60, i32 2, i32 1, ptr @"CONTR_MSG_Request Leak", ptr null }, %ContractFormula_t { ptr @CONTRACT_CHILDREN_68, i32 2, i32 1, ptr @"CONTR_MSG_Local Data Race - Local read", ptr null }, %ContractFormula_t { ptr @CONTRACT_CHILDREN_78, i32 2, i32 1, ptr @"CONTR_MSG_Local Data Race - Local read by call", ptr null }, %ContractFormula_t { ptr @CONTRACT_CHILDREN_86, i32 2, i32 1, ptr @"CONTR_MSG_Local Data Race - Local write", ptr null }, %ContractFormula_t { ptr @CONTRACT_CHILDREN_96, i32 2, i32 1, ptr @"CONTR_MSG_Local Data Race - Local write by call", ptr null }]
@CONTR_SCOPE_98 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_97, i32 7, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_FUNC_STR_MPI_Irecv = global [10 x i8] c"MPI_Irecv\00"
@CONTR_CALLTAGOP_99 = global %CallTagOp_t { ptr @CONTR_TAG_STR_mpi_init, ptr null, i32 0 }
@"CONTR_MSG_Unmatched Wait" = global [15 x i8] c"Unmatched Wait\00"
@CONTR_PARAMLIST_100 = global [1 x %CallParam_t] [%CallParam_t { i32 -1, i1 true, i32 0, i32 0 }]
@CONTR_CALLTAGOP_101 = global %CallTagOp_t { ptr @CONTR_TAG_STR_request_gen, ptr @CONTR_PARAMLIST_100, i32 1 }
@"CONTR_MSG_Status is invalid" = global [18 x i8] c"Status is invalid\00"
@CONTR_PARAM_REQS_102 = global [3 x %ParamReq_t] [%ParamReq_t { i32 5, ptr null, i1 false, i1 false }, %ParamReq_t zeroinitializer, %ParamReq_t zeroinitializer]
@CONTR_PARAMOP_103 = global %ParamOp_t { i32 1, ptr @CONTR_PARAM_REQS_102, i32 3, i1 false }
@CONTR_SCOPECONDITIONS_104 = global [3 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Missing Initialization call", ptr @CONTR_CALLTAGOP_99 }, %ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Unmatched Wait", ptr @CONTR_CALLTAGOP_101 }, %ContractFormula_t { ptr null, i32 0, i32 11, ptr @"CONTR_MSG_Status is invalid", ptr @CONTR_PARAMOP_103 }]
@CONTR_SCOPE_105 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_104, i32 3, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_CALLTAGOP_106 = global %CallTagOp_t { ptr @CONTR_TAG_STR_mpi_exit, ptr null, i32 0 }
@CONTR_SCOPECONDITIONS_107 = global [1 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Missing Finalization call", ptr @CONTR_CALLTAGOP_106 }]
@CONTR_SCOPE_108 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_107, i32 1, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_FUNC_STR_MPI_Wait = global [9 x i8] c"MPI_Wait\00"
@CONTR_CALLTAGOP_109 = global %CallTagOp_t { ptr @CONTR_TAG_STR_mpi_init, ptr null, i32 0 }
@CONTR_SCOPECONDITIONS_110 = global [1 x %ContractFormula_t] [%ContractFormula_t { ptr null, i32 0, i32 9, ptr @"CONTR_MSG_Missing Initialization call", ptr @CONTR_CALLTAGOP_109 }]
@CONTR_SCOPE_111 = global %ContractFormula_t { ptr @CONTR_SCOPECONDITIONS_110, i32 1, i32 0, ptr @CONTR_SCOPE_STR_, ptr null }
@CONTR_FUNC_STR_MPI_Finalize = global [13 x i8] c"MPI_Finalize\00"
@CONTR_LIST_CONTRACTS = global [9 x %Contract_t] [%Contract_t { ptr null, ptr @CONTR_SCOPE_7, ptr @CoVer_AllocStack, ptr @CONTR_FUNC_STR_CoVer_AllocStack }, %Contract_t { ptr null, ptr @CONTR_SCOPE_10, ptr @CoVer_FreeStack, ptr @CONTR_FUNC_STR_CoVer_FreeStack }, %Contract_t { ptr null, ptr @CONTR_SCOPE_13, ptr @CoVer_RegisterGlobal, ptr @CONTR_FUNC_STR_CoVer_RegisterGlobal }, %Contract_t { ptr null, ptr @CONTR_SCOPE_16, ptr @MPI_Init, ptr @CONTR_FUNC_STR_MPI_Init }, %Contract_t { ptr @CONTR_SCOPE_19, ptr @CONTR_SCOPE_22, ptr @MPI_Comm_rank, ptr @CONTR_FUNC_STR_MPI_Comm_rank }, %Contract_t { ptr @CONTR_SCOPE_34, ptr @CONTR_SCOPE_37, ptr @MPI_Send, ptr @CONTR_FUNC_STR_MPI_Send }, %Contract_t { ptr @CONTR_SCOPE_45, ptr @CONTR_SCOPE_98, ptr @MPI_Irecv, ptr @CONTR_FUNC_STR_MPI_Irecv }, %Contract_t { ptr @CONTR_SCOPE_105, ptr @CONTR_SCOPE_108, ptr @MPI_Wait, ptr @CONTR_FUNC_STR_MPI_Wait }, %Contract_t { ptr @CONTR_SCOPE_111, ptr null, ptr @MPI_Finalize, ptr @CONTR_FUNC_STR_MPI_Finalize }]
@CONTR_DB = global %ContractDB_t { ptr @CONTR_LIST_CONTRACTS, i32 9, %TagsMap_t { ptr @CONTR_TAG_ARRAY_PTRS, ptr @CONTR_TAG_ARRAY_TAGS, i32 7 }, ptr @CONTR_LIST_REFERENCES, i32 4 }

; Function Attrs: nounwind uwtable
define i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !124 {
  %argv_ptr = alloca ptr, align 8
  %argc_ptr = alloca i32, align 4
  store i32 %0, ptr %argc_ptr, align 4
  store ptr %1, ptr %argv_ptr, align 8
  call void @PPDCV_Initialize(ptr %argc_ptr, ptr %argv_ptr, ptr @CONTR_DB)
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %base_ptr = call ptr @llvm.frameaddress.p0(i32 0)
  %stack_ptr = call ptr @llvm.stacksave.p0()
  %base_int = ptrtoint ptr %base_ptr to i64
  %stack_int = ptrtoint ptr %stack_ptr to i64
  %stack_size = sub i64 %base_int, %stack_int
  %8 = inttoptr i64 %stack_size to ptr
  %9 = call ptr (i1, ptr, i32, i32, ...) @PPDCV_FunctionCallback(i1 false, ptr @CoVer_AllocStack, i32 0, i32 2, i32 16448, ptr %stack_ptr, i32 16448, ptr %8)
  store i32 %0, ptr %3, align 4
    #dbg_declare(ptr %3, !130, !DIExpression(), !131)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !132, !DIExpression(), !133)
  %10 = call ptr (i1, ptr, i32, i32, ...) @PPDCV_FunctionCallback(i1 false, ptr @MPI_Init, i32 32, i32 2, i32 16448, ptr %3, i32 16448, ptr %4), !dbg !134
  %11 = ptrtoint ptr %10 to i32, !dbg !134
    #dbg_declare(ptr %5, !135, !DIExpression(), !136)
    #dbg_declare(ptr %6, !137, !DIExpression(), !138)
  store i32 0, ptr %6, align 4, !dbg !138
  %12 = call ptr (i1, ptr, i32, i32, ...) @PPDCV_FunctionCallback(i1 false, ptr @MPI_Comm_rank, i32 32, i32 2, i32 16448, ptr @ompi_mpi_comm_world, i32 16448, ptr %5), !dbg !139
  %13 = ptrtoint ptr %12 to i32, !dbg !139
  %14 = load i32, ptr %5, align 4, !dbg !140
  %15 = icmp eq i32 %14, 0, !dbg !142
  br i1 %15, label %16, label %22, !dbg !142

16:                                               ; preds = %2
  store i32 42, ptr %6, align 4, !dbg !143
  %17 = inttoptr i32 1 to ptr
  %18 = inttoptr i32 1 to ptr
  %19 = inttoptr i32 0 to ptr
  %20 = call ptr (i1, ptr, i32, i32, ...) @PPDCV_FunctionCallback(i1 false, ptr @MPI_Send, i32 32, i32 6, i32 16448, ptr %6, i32 8224, ptr %17, i32 16448, ptr @ompi_mpi_int, i32 8224, ptr %18, i32 8224, ptr %19, i32 16448, ptr @ompi_mpi_comm_world), !dbg !145
  %21 = ptrtoint ptr %20 to i32, !dbg !145
  br label %36, !dbg !146

22:                                               ; preds = %2
  %23 = load i32, ptr %5, align 4, !dbg !147
  %24 = icmp eq i32 %23, 1, !dbg !149
  br i1 %24, label %25, label %35, !dbg !149

25:                                               ; preds = %22
    #dbg_declare(ptr %7, !150, !DIExpression(), !155)
  %26 = inttoptr i32 1 to ptr
  %27 = inttoptr i32 0 to ptr
  %28 = inttoptr i32 0 to ptr
  %29 = call ptr (i1, ptr, i32, i32, ...) @PPDCV_FunctionCallback(i1 true, ptr @MPI_Irecv, i32 32, i32 7, i32 16448, ptr %6, i32 8224, ptr %26, i32 16448, ptr @ompi_mpi_int, i32 8224, ptr %27, i32 8224, ptr %28, i32 16448, ptr @ompi_mpi_comm_world, i32 16448, ptr %7), !dbg !156
  %30 = ptrtoint ptr %29 to i32, !dbg !156
  call void @PPDCV_MemRCallback(i1 true, ptr %6), !dbg !157
  %31 = load i32, ptr %6, align 4, !dbg !157
  %32 = call i32 (ptr, ...) @printf(ptr noundef @.str.13, i32 noundef %31), !dbg !158
  %33 = call ptr (i1, ptr, i32, i32, ...) @PPDCV_FunctionCallback(i1 false, ptr @MPI_Wait, i32 32, i32 2, i32 16448, ptr %7, i32 16448, ptr null), !dbg !159
  %34 = ptrtoint ptr %33 to i32, !dbg !159
  br label %35, !dbg !160

35:                                               ; preds = %25, %22
  br label %36

36:                                               ; preds = %35, %16
  %37 = call ptr (i1, ptr, i32, i32, ...) @PPDCV_FunctionCallback(i1 false, ptr @MPI_Finalize, i32 32, i32 0), !dbg !161
  %38 = ptrtoint ptr %37 to i32, !dbg !161
  %39 = call ptr (i1, ptr, i32, i32, ...) @PPDCV_FunctionCallback(i1 false, ptr @CoVer_FreeStack, i32 0, i32 1, i32 16448, ptr %stack_ptr), !dbg !162
  ret i32 0, !dbg !162
}

declare i32 @MPI_Init(ptr noundef, ptr noundef) #1

declare i32 @MPI_Comm_rank(ptr noundef, ptr noundef) #1

declare i32 @MPI_Send(ptr noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef, ptr noundef) #1

declare i32 @MPI_Irecv(ptr noundef, i32 noundef, ptr noundef, i32 noundef, i32 noundef, ptr noundef, ptr noundef) #1

declare i32 @printf(ptr noundef, ...) #1

declare i32 @MPI_Wait(ptr noundef, ptr noundef) #1

declare i32 @MPI_Finalize() #1

; Function Attrs: nocallback nounwind willreturn
declare !dbg !163 void @CoVer_AllocStack(ptr, i64) #2

; Function Attrs: nocallback nounwind willreturn
declare !dbg !168 void @CoVer_FreeStack(ptr) #2

; Function Attrs: nocallback nounwind willreturn
declare !dbg !171 void @CoVer_RegisterGlobal(ptr, i64) #2

; Function Attrs: nocallback nounwind willreturn
declare !dbg !172 i32 @CoVer_FPointerAllocate(ptr, i64, i32, ...) #2

; Function Attrs: nocallback nounwind willreturn
declare !dbg !176 i32 @CoVer_FPointerDeallocate(ptr, i1, ptr, ptr, i32) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare ptr @llvm.frameaddress.p0(i32 immarg) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare ptr @llvm.stacksave.p0() #4

; Function Attrs: nocallback nounwind willreturn
declare extern_weak ptr @PPDCV_FunctionCallback(i1, ptr, i32, i32, ...) #2

; Function Attrs: nocallback nounwind willreturn
declare extern_weak void @PPDCV_MemRCallback(i1, ptr) #2

; Function Attrs: nocallback nounwind willreturn
declare extern_weak void @PPDCV_MemWCallback(i1, ptr) #2

; Function Attrs: nocallback nounwind willreturn
declare extern_weak void @PPDCV_Initialize(ptr, ptr, ptr) #2

attributes #0 = { nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nounwind willreturn }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #4 = { nocallback nofree nosync nounwind willreturn }

!llvm.dbg.cu = !{!9}
!llvm.module.flags = !{!117, !118, !119, !120, !121, !122}
!llvm.ident = !{!123}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "/opt/cover/include/mpi_contracts.h", directory: "", checksumkind: CSK_MD5, checksum: "08913dc333b91cf984a3d7265c2b680c")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 5)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "ContractValueInfo_0", scope: !9, file: !2, line: 14, type: !41, isLocal: true, isDefinition: true)
!9 = distinct !DICompileUnit(language: DW_LANG_C11, file: !10, producer: "Ubuntu clang version 22.1.8 (++20260714015917+ca7933e47d3a-1~exp1~20260714135927.17)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !11, globals: !33, splitDebugInlining: false, nameTableKind: None)
!10 = !DIFile(filename: "/workspace/tests/data-race-read/irecv-read-before-wait.buggy.c", directory: "/workspace", checksumkind: CSK_MD5, checksum: "cef4bc4546ab457bc611c73ecc1b2bff")
!11 = !{!12, !13, !17, !20}
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Comm", file: !14, line: 468, baseType: !15)
!14 = !DIFile(filename: "/usr/include/mpi.h", directory: "", checksumkind: CSK_MD5, checksum: "b5e12a4bb1dbf2cbd955d4636e6e9b89")
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_communicator_t", file: !14, line: 468, flags: DIFlagFwdDecl)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Datatype", file: !14, line: 469, baseType: !18)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_datatype_t", file: !14, line: 469, flags: DIFlagFwdDecl)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Status", file: !14, line: 477, baseType: !22)
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_status_public_t", file: !14, line: 491, size: 192, elements: !23)
!23 = !{!24, !26, !27, !28, !29}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "MPI_SOURCE", scope: !22, file: !14, line: 494, baseType: !25, size: 32)
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "MPI_TAG", scope: !22, file: !14, line: 495, baseType: !25, size: 32, offset: 32)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "MPI_ERROR", scope: !22, file: !14, line: 496, baseType: !25, size: 32, offset: 64)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "_cancelled", scope: !22, file: !14, line: 501, baseType: !25, size: 32, offset: 96)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "_ucount", scope: !22, file: !14, line: 502, baseType: !30, size: 64, offset: 128)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !31, line: 18, baseType: !32)
!31 = !DIFile(filename: "/usr/lib/llvm-22/lib/clang/22/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!32 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!33 = !{!0, !7, !34, !39, !49, !54, !56, !61, !63, !68, !70, !75, !77, !82, !84, !86, !88, !90, !92, !94, !96, !101, !103, !108, !110, !112, !114}
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !2, line: 15, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 88, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 11)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(name: "ContractValueInfo_1", scope: !9, file: !2, line: 15, type: !41, isLocal: true, isDefinition: true)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "ContractValuePair_t", file: !42, line: 20, baseType: !43)
!42 = !DIFile(filename: "/opt/cover/include/Contracts.h", directory: "", checksumkind: CSK_MD5, checksum: "3bcacd0b1d56ffe2909ee08041374d19")
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ContractValuePair", file: !42, line: 17, size: 128, elements: !44)
!44 = !{!45, !48}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "name", scope: !43, file: !42, line: 18, baseType: !46, size: 64)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !43, file: !42, line: 19, baseType: !12, size: 64, offset: 64)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(scope: null, file: !2, line: 16, type: !51, isLocal: true, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 112, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 14)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "ContractValueInfo_2", scope: !9, file: !2, line: 16, type: !41, isLocal: true, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(scope: null, file: !2, line: 17, type: !58, isLocal: true, isDefinition: true)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 120, elements: !59)
!59 = !{!60}
!60 = !DISubrange(count: 15)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "ContractValueInfo_3", scope: !9, file: !2, line: 17, type: !41, isLocal: true, isDefinition: true)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !65, isLocal: true, isDefinition: true)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 96, elements: !66)
!66 = !{!67}
!67 = !DISubrange(count: 12)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "ContractValueInfo_4", scope: !9, file: !2, line: 18, type: !41, isLocal: true, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(scope: null, file: !2, line: 19, type: !72, isLocal: true, isDefinition: true)
!72 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 104, elements: !73)
!73 = !{!74}
!74 = !DISubrange(count: 13)
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression())
!76 = distinct !DIGlobalVariable(name: "ContractValueInfo_5", scope: !9, file: !2, line: 19, type: !41, isLocal: true, isDefinition: true)
!77 = !DIGlobalVariableExpression(var: !78, expr: !DIExpression())
!78 = distinct !DIGlobalVariable(scope: null, file: !2, line: 20, type: !79, isLocal: true, isDefinition: true)
!79 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !80)
!80 = !{!81}
!81 = !DISubrange(count: 17)
!82 = !DIGlobalVariableExpression(var: !83, expr: !DIExpression())
!83 = distinct !DIGlobalVariable(name: "ContractValueInfo_6", scope: !9, file: !2, line: 20, type: !41, isLocal: true, isDefinition: true)
!84 = !DIGlobalVariableExpression(var: !85, expr: !DIExpression())
!85 = distinct !DIGlobalVariable(scope: null, file: !2, line: 21, type: !65, isLocal: true, isDefinition: true)
!86 = !DIGlobalVariableExpression(var: !87, expr: !DIExpression())
!87 = distinct !DIGlobalVariable(name: "ContractValueInfo_7", scope: !9, file: !2, line: 21, type: !41, isLocal: true, isDefinition: true)
!88 = !DIGlobalVariableExpression(var: !89, expr: !DIExpression())
!89 = distinct !DIGlobalVariable(scope: null, file: !2, line: 22, type: !51, isLocal: true, isDefinition: true)
!90 = !DIGlobalVariableExpression(var: !91, expr: !DIExpression())
!91 = distinct !DIGlobalVariable(name: "ContractValueInfo_8", scope: !9, file: !2, line: 22, type: !41, isLocal: true, isDefinition: true)
!92 = !DIGlobalVariableExpression(var: !93, expr: !DIExpression())
!93 = distinct !DIGlobalVariable(scope: null, file: !2, line: 23, type: !58, isLocal: true, isDefinition: true)
!94 = !DIGlobalVariableExpression(var: !95, expr: !DIExpression())
!95 = distinct !DIGlobalVariable(name: "ContractValueInfo_9", scope: !9, file: !2, line: 23, type: !41, isLocal: true, isDefinition: true)
!96 = !DIGlobalVariableExpression(var: !97, expr: !DIExpression())
!97 = distinct !DIGlobalVariable(scope: null, file: !2, line: 24, type: !98, isLocal: true, isDefinition: true)
!98 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 144, elements: !99)
!99 = !{!100}
!100 = !DISubrange(count: 18)
!101 = !DIGlobalVariableExpression(var: !102, expr: !DIExpression())
!102 = distinct !DIGlobalVariable(name: "ContractValueInfo_10", scope: !9, file: !2, line: 24, type: !41, isLocal: true, isDefinition: true)
!103 = !DIGlobalVariableExpression(var: !104, expr: !DIExpression())
!104 = distinct !DIGlobalVariable(scope: null, file: !2, line: 25, type: !105, isLocal: true, isDefinition: true)
!105 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 160, elements: !106)
!106 = !{!107}
!107 = !DISubrange(count: 20)
!108 = !DIGlobalVariableExpression(var: !109, expr: !DIExpression())
!109 = distinct !DIGlobalVariable(name: "ContractValueInfo_11", scope: !9, file: !2, line: 25, type: !41, isLocal: true, isDefinition: true)
!110 = !DIGlobalVariableExpression(var: !111, expr: !DIExpression())
!111 = distinct !DIGlobalVariable(scope: null, file: !2, line: 26, type: !98, isLocal: true, isDefinition: true)
!112 = !DIGlobalVariableExpression(var: !113, expr: !DIExpression())
!113 = distinct !DIGlobalVariable(name: "ContractValueInfo_12", scope: !9, file: !2, line: 26, type: !41, isLocal: true, isDefinition: true)
!114 = !DIGlobalVariableExpression(var: !115, expr: !DIExpression())
!115 = distinct !DIGlobalVariable(scope: null, file: !116, line: 18, type: !79, isLocal: true, isDefinition: true)
!116 = !DIFile(filename: "tests/data-race-read/irecv-read-before-wait.buggy.c", directory: "/workspace", checksumkind: CSK_MD5, checksum: "cef4bc4546ab457bc611c73ecc1b2bff")
!117 = !{i32 7, !"Dwarf Version", i32 5}
!118 = !{i32 2, !"Debug Info Version", i32 3}
!119 = !{i32 1, !"wchar_size", i32 4}
!120 = !{i32 8, !"PIC Level", i32 2}
!121 = !{i32 7, !"uwtable", i32 2}
!122 = !{i32 7, !"frame-pointer", i32 2}
!123 = !{!"Ubuntu clang version 22.1.8 (++20260714015917+ca7933e47d3a-1~exp1~20260714135927.17)"}
!124 = distinct !DISubprogram(name: "main", scope: !116, file: !116, line: 7, type: !125, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !129)
!125 = !DISubroutineType(types: !126)
!126 = !{!25, !25, !127}
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!129 = !{}
!130 = !DILocalVariable(name: "argc", arg: 1, scope: !124, file: !116, line: 7, type: !25)
!131 = !DILocation(line: 7, column: 14, scope: !124)
!132 = !DILocalVariable(name: "argv", arg: 2, scope: !124, file: !116, line: 7, type: !127)
!133 = !DILocation(line: 7, column: 27, scope: !124)
!134 = !DILocation(line: 8, column: 5, scope: !124)
!135 = !DILocalVariable(name: "rank", scope: !124, file: !116, line: 9, type: !25)
!136 = !DILocation(line: 9, column: 9, scope: !124)
!137 = !DILocalVariable(name: "buf", scope: !124, file: !116, line: 9, type: !25)
!138 = !DILocation(line: 9, column: 15, scope: !124)
!139 = !DILocation(line: 10, column: 5, scope: !124)
!140 = !DILocation(line: 12, column: 9, scope: !141)
!141 = distinct !DILexicalBlock(scope: !124, file: !116, line: 12, column: 9)
!142 = !DILocation(line: 12, column: 14, scope: !141)
!143 = !DILocation(line: 13, column: 13, scope: !144)
!144 = distinct !DILexicalBlock(scope: !141, file: !116, line: 12, column: 20)
!145 = !DILocation(line: 14, column: 9, scope: !144)
!146 = !DILocation(line: 15, column: 5, scope: !144)
!147 = !DILocation(line: 15, column: 16, scope: !148)
!148 = distinct !DILexicalBlock(scope: !141, file: !116, line: 15, column: 16)
!149 = !DILocation(line: 15, column: 21, scope: !148)
!150 = !DILocalVariable(name: "req", scope: !151, file: !116, line: 16, type: !152)
!151 = distinct !DILexicalBlock(scope: !148, file: !116, line: 15, column: 27)
!152 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Request", file: !14, line: 475, baseType: !153)
!153 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !154, size: 64)
!154 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_request_t", file: !14, line: 475, flags: DIFlagFwdDecl)
!155 = !DILocation(line: 16, column: 21, scope: !151)
!156 = !DILocation(line: 17, column: 9, scope: !151)
!157 = !DILocation(line: 18, column: 37, scope: !151)
!158 = !DILocation(line: 18, column: 9, scope: !151)
!159 = !DILocation(line: 19, column: 9, scope: !151)
!160 = !DILocation(line: 20, column: 5, scope: !151)
!161 = !DILocation(line: 22, column: 5, scope: !124)
!162 = !DILocation(line: 23, column: 5, scope: !124)
!163 = !DISubprogram(name: "CoVer_AllocStack", linkageName: "CoVer_AllocStack", scope: null, file: !10, type: !164, spFlags: 0)
!164 = !DISubroutineType(types: !165)
!165 = !{null, !166, !167}
!166 = !DIBasicType(name: "void*", size: 64, encoding: DW_ATE_decimal_float)
!167 = !DIBasicType(name: "int64_t", size: 64, encoding: DW_ATE_signed)
!168 = !DISubprogram(name: "CoVer_FreeStack", linkageName: "CoVer_FreeStack", scope: null, file: !10, type: !169, spFlags: 0)
!169 = !DISubroutineType(types: !170)
!170 = !{null, !166}
!171 = !DISubprogram(name: "CoVer_RegisterGlobal", linkageName: "CoVer_RegisterGlobal", scope: null, file: !10, type: !164, spFlags: 0)
!172 = !DISubprogram(name: "CoVer_FPointerAllocate", linkageName: "CoVer_FPointerAllocate", scope: null, file: !10, type: !173, spFlags: 0)
!173 = !DISubroutineType(types: !174)
!174 = !{!175, !166, !167, !175}
!175 = !DIBasicType(name: "int32_t", size: 32, encoding: DW_ATE_signed)
!176 = !DISubprogram(name: "CoVer_FPointerDeallocate", linkageName: "CoVer_FPointerDeallocate", scope: null, file: !10, type: !177, spFlags: 0)
!177 = !DISubroutineType(types: !178)
!178 = !{!175, !166, !179, !166, !166, !175}
!179 = !DIBasicType(name: "bool", size: 1, encoding: DW_ATE_boolean)
