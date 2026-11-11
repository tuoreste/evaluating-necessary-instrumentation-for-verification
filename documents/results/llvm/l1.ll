define i32 @main() {
    entry:
        %value = alloca i32, align 4
        store i32 100, ptr %value, align 4
        %result = load i32, ptr %value, align 4
        ret i32 %result    
}