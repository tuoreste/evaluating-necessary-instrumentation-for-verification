; ________________________________________________________
; LLVM    IR	                        Meaning	C++ operator
; ________________________________________________________
; eq	    Equal                       ==
; ne	    Not equal	                !=
; sgt	    Signed greater than	        >
; sge	    Signed greater or equal	    >=
; slt	    Signed less than	        <
; sle	    Signed less or equal	    <=
; ________________________________________________________
; LLVM also supports unsigned comparisons such as ugt and ult for negative numbers

define i32 @main () {
    entry:
        %value = alloca i32, align 4
        store i32 21, ptr %value, align 4
        %age = load i32, ptr %value, align 4

        %condition = icmp sge i32 %age, 18

        br i1 %condition, label %greater, label %otherwise

    greater:
        ret i32 100
    otherwise:
        ret i32 50
}