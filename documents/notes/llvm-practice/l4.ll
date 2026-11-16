;  _______________________________________________________
; LLVM type	Meaning	Example             C++ equivalent
; ________________________________________________________
; i1          1-bit integer               bool
; i8          8-bit integer               char
; i16         16-bit integer              Often short
; i32         32-bit integer              Often int
; i64         64-bit integer              Often long long
; float	      32-bit floating point       float
; double	  64-bit floating point	      double
; ptr         Pointer to memory           int*, char*, etc.
; void        No return value             void
; ________________________________________________________
; LLVM integer types specify the bit width

define i32 @main() {
    entry:
        %values = alloca [4 x i32], align 4

        %p0 = getelementptr [4 x i32], ptr %values, i64 0, i64 0
        %p1 = getelementptr [4 x i32], ptr %values, i64 0, i64 1
        %p2 = getelementptr [4 x i32], ptr %values, i64 0, i64 2
        %p3 = getelementptr [4 x i32], ptr %values, i64 0, i64 3

        store i32 10, ptr %p0
        store i32 20, ptr %p1
        store i32 30, ptr %p2
        store i32 40, ptr %p3

        %a = load i32, ptr %p1
        %b = load i32, ptr %p2

        %sum = add i32 %a, %b

        ret i32 %sum
}
