@message = private constant [6 x i8] c"Hello\00"

declare i32 @puts(ptr)

define i32 @main() {
entry:
  call i32 @puts(ptr @message)
  ret i32 0
}
