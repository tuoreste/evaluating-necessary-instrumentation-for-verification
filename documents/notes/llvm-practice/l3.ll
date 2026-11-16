define i32 @main() {
    ; how LLVM reads from and writes to memory.
    entry:
        %x = alloca i32, align 4
        %y = alloca i32, align 4

        store i32 15, ptr %x, align 4
        store i32 25, ptr %y, align 4

        %a = load i32, ptr %x, align 4
        %b = load i32, ptr %y, align 4

        %sum = add i32 %a, %b

        ret i32 %sum
}