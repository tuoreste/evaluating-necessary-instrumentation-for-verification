#include "llvm/IR/Module.h" //entire compiled src files
#include "llvm/IR/PassManager.h" //core classes necessary to define and rn our custom passes
#include "llvm/Passes/PassBuilder.h" //allows us to hook our pass into LLVM's optimization pipeline so it runs at a specific stage
#include "llvm/Plugins/PassPlugin.h" // handles entry for opt and clang to load our plugin
#include "llvm/Support/raw_ostream.h" //lightweight print like errs, outs...

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"

#include <vector>

#include <string>
#include <system_error>

using namespace llvm;

// namespace to avoid linkage clash with other plugins
namespace {
    static cl::opt<std::string> ListOut(
        "list-out",
        cl::desc("Write the memory callback list to a CSV file"),
        cl::value_desc("file"),
        cl::init("")
    );

    // our pass iniherits from PassInfoMixin for the methods that LLVM expects us to have
    // isRequired is allowing not be skipped even on a function that does not allow optimization
    struct RemoveCallbacksPass : PassInfoMixin<RemoveCallbacksPass> {
        static bool isRequired() {
            return true;
        }

        PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {
            std::vector<CallInst *> callbacks;

            for (Function &F : M) {
                if (F.isDeclaration()) continue;

                for (BasicBlock &BB : F) {
                    for (Instruction &I : BB) {
                        auto *CI = dyn_cast<CallInst>(&I);
                        
                        if (!CI) continue;

                        Function *callee = CI->getCalledFunction();
                        
                        if (!callee) continue;

                        StringRef name = callee->getName();

                        if (name == "PPDCV_MemRCallback" || name == "PPDCV_MemWCallback") {
                            callbacks.push_back(CI);
                        }
                    }
                }
            }

            errs() << "RemoveCallbacks: found " << callbacks.size() << " memory callbacks\n";

            // Register -list-out=<file> as an opt command-line option.
            // The pass uses this path to write the callback list in the agreed CSV format.
            if (ListOut.empty()) {
                errs() << "RemoveCallbacks: no -list-out file provided\n";
                return PreservedAnalyses::all();
            }

            std::error_code error;

            // Protection: Open the requested CSV as a text file and report any filesystem error
            // without attempting to write to an invalid stream. std::error_code error;
            raw_fd_ostream output(
                ListOut.getValue(),
                error,
                sys::fs::OF_Text
            );

            if (error) {
                errs() << "RemoveCallbacks: cannot open " << ListOut.getValue() << ": " << error.message() << "\n";

                return PreservedAnalyses::all();
            }

            output << "id,kind,function,line,static_flag\n";
            errs() << "RemoveCallbacks: wrote " << ListOut.getValue() << "\n";

            return PreservedAnalyses::all();
        };
    };
}

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return {
      LLVM_PLUGIN_API_VERSION,
      "RemoveCallbacks",
      "v0.1",
      [](PassBuilder &PB) {
        PB.registerPipelineParsingCallback(
            [](StringRef Name, ModulePassManager &MPM, ArrayRef<PassBuilder::PipelineElement>) {
                if (Name == "removecallbacks") {
                    MPM.addPass(RemoveCallbacksPass());
                    return true;
                }
                
                return false;
            });
        },
    };
}