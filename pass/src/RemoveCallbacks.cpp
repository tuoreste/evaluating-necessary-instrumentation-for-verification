#include "llvm/IR/Module.h" //entire compiled src files
#include "llvm/IR/PassManager.h" //core classes necessary to define and run our custom passes
#include "llvm/Passes/PassBuilder.h" //allows us to hook our pass into LLVM's optimization pipeline so it runs at a specific stage
#include "llvm/Plugins/PassPlugin.h" // handles entry for opt and clang to load our plugin
#include "llvm/Support/raw_ostream.h" //lightweight print like errs, outs...

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/MemoryBuffer.h"

#include "llvm/ADT/SmallVector.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"

#include "llvm/IR/Constants.h"
#include "llvm/IR/DebugLoc.h"

#include <vector>
#include <set>
#include <string>
#include <system_error>

using namespace llvm;

// namespace to avoid linkage clash with other plugins
namespace {
    // Register -list-out=<file> as an opt command-line option.
    // The pass uses this path to write the callback list in the agreed CSV format.
    static cl::opt<std::string> ListOut(
        "list-out",
        cl::desc("Write the memory callback list to a CSV file"),
        cl::value_desc("file"),
        cl::init("")
    );

    // Register -remove-ids=<file>: a text file with one callback ID per line
    // (IDs from the list of the same full.ll). These callbacks are deleted.
    static cl::opt<std::string> RemoveIds(
        "remove-ids",
        cl::desc("Remove the memory callbacks whose IDs are listed in this file"),
        cl::value_desc("file"),
        cl::init("")
    );

    // Read the remove file: one ID per line, empty lines are ignored.
    // Anything that is not a number stops opt with an error, so a broken file is never ignored.
    std::set<size_t> readRemoveIds(StringRef path) {
        auto buffer = MemoryBuffer::getFile(path, /*IsText=*/true);
        if (!buffer) {
            reportFatalUsageError("RemoveCallbacks: cannot open " + Twine(path) + ": " + buffer.getError().message());
        }

        std::set<size_t> ids;
        SmallVector<StringRef, 32> lines;
        (*buffer)->getBuffer().split(lines, '\n');

        for (size_t lineNumber = 0; lineNumber < lines.size(); ++lineNumber) {
            StringRef line = lines[lineNumber].trim();
            if (line.empty()) continue;

            size_t id;
            if (line.getAsInteger(10, id)) {
                reportFatalUsageError("RemoveCallbacks: " + Twine(path) + " line " + Twine(lineNumber + 1) +
                                      ": '" + line + "' is not a callback ID");
            }
            ids.insert(id);
        }
        return ids;
    }

    // our pass inherits from PassInfoMixin for the methods that LLVM expects us to have
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

            if (!ListOut.empty()) {
            std::error_code error;

            // Protection: Open the requested CSV as a text file and report any filesystem error
            // without attempting to write to an invalid stream. std::error_code error;
            raw_fd_ostream output(
                ListOut.getValue(),
                error,
                sys::fs::OF_Text
            );

            if (error) {
                reportFatalUsageError("RemoveCallbacks: cannot open " + Twine(ListOut.getValue()) + ": " + error.message());
            }

            output << "id,kind,function,line,static_flag\n";

            for (size_t id = 0; id < callbacks.size(); ++id) {
                CallInst *CI = callbacks[id];
                Function *callee = CI->getCalledFunction();

                StringRef kind = callee->getName() == "PPDCV_MemRCallback" ? "R" : "W";

                StringRef functionName = CI->getFunction()->getName();

                DebugLoc debugLocation = CI->getDebugLoc();
                unsigned sourceLine = debugLocation ? debugLocation.getLine() : 0;

                auto *flag = dyn_cast<ConstantInt>(CI->getArgOperand(0));
                unsigned staticFlag = flag && flag->isOne() ? 1 : 0;

                output << id << "," << kind << "," << functionName << "," << sourceLine << "," << staticFlag << "\n";
            }
            errs() << "RemoveCallbacks: wrote " << ListOut.getValue() << "\n";
            }

            // Remove mode: only now, after the loops above are finished, we erase instructions.
            // Erasing while looping over a basic block would break the loop.
            if (RemoveIds.empty()) {
                return PreservedAnalyses::all();
            }

            size_t removed = 0;
            for (size_t id : readRemoveIds(RemoveIds)) {
                if (id >= callbacks.size()) {
                    errs() << "RemoveCallbacks: warning: ID " << id << " does not exist (this IR has "
                           << callbacks.size() << " memory callbacks), skipped\n";
                    continue;
                }
                // The callbacks return void and nothing uses them, so they can be erased directly.
                callbacks[id]->eraseFromParent();
                ++removed;
            }

            errs() << "RemoveCallbacks: removed " << removed << " of " << callbacks.size() << " memory callbacks\n";

            // The IR changed, so analyses computed before this pass are no longer valid.
            return removed > 0 ? PreservedAnalyses::none() : PreservedAnalyses::all();
        }
    };
}

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return {
      LLVM_PLUGIN_API_VERSION,
      "RemoveCallbacks",
      "v0.2",
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