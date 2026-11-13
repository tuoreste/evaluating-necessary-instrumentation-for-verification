; loops
define i32 @main() {
    entry:
        br label %loop

    loop:
        %i = phi i32 [1, %entry], [%next_i, %body]
        %sum = phi i32 [0, %entry], [%next_sum, %body]

        %condition = icmp sle i32 %i, 4
        br i1 %condition, label %body, label %exit

    body:
        %next_sum = add i32 %sum, %i
        %next_i = add i32 %i, 1
        br label %loop
    
    exit:
        ret i32 %sum
}
