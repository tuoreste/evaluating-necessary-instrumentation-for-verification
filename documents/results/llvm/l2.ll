define i32 @main() {
    ; SSA => Static Single Assignment

    entry:
        %a = add i32 10, 5
        %b = mul i32 %a, 7
        %c = sub i32 %b, 5
        ret i32 %c
}
