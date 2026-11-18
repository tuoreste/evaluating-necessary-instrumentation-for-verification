#include "llvm/IR/Module.h" //entire compiled src files
#include "llvm/IR/PassManager.h" //core classes necessary to define and rn our custom passes
#include "llvm/Passes/PassBuilder.h" //allows us to hook our pass into LLVM's optimization pipeline so it runs at a specific stage
#include "llvm/Plugins/PassPlugin.h" // handles entry for opt and clang to load our plugin
#include "llvm/Support/raw_ostream.h" //lightweight print like errs, outs...

using namespace llvm;

// namespace to avoid linkage clash with other plugins
namespace {
    // our pass iniherits from PassInfoMixin for the methods that LLVM expects us to have
    // isRequired is allowing not be skipped even on a function that does not allow optimization
    struct RemoveCallbacksPass : PassInfoMixin<RemoveCallbacksPass> {
        static bool isRequired() {
            return true;
        }

        PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {
            errs() << "RemoveCallbacks: module " << M.getName() << "\n";

            return PreservedAnalyses::all();
        }
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