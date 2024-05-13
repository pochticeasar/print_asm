global print
section .text

print:
    push ebp
    push esi
    push ebx
    push edi

    ; mov eax, [esp + 20]
    ; mov ecx, [esp + 24]

    mov edx, [esp + 16 + 12]
    sub esp, 32
    xor esi, esi
    jmp check_minus

after_prefix:
    jmp loop_for_string

check_minus:
    cmp edx, '-'
    jne check_prefix
    mov eax, '-'
    inc edx
    jmp check_prefix

check_prefix:
    cmp edx, 0
    jne loop_for_string
    inc edx
    cmp edx, 'x'
    jne return_back
    inc edx
    jmp loop_for_string
    
return_back:
    dec edx
    dec edx
    jmp loop_for_string

loop_for_string:
    inc esi
    cmp edx, 0
    jbe end_loop
    cmp edx, 'a'
    jbe check_for_upper
    sub edx, 'a'
    shr esi, 3 
    shr dword [esp + esi], 4
    or [esp + esi], edx 
    inc edx
    jmp loop_for_string

check_for_upper:
    cmp edx, 'A'
    jbe check_for_digits
    sub edx, 'A'
    add edx, 10
    inc edx
    jmp loop_for_string

check_for_digits:
    sub edx, '0'
    inc edx
    jmp loop_for_string

end_loop:
    shr edx, 3
    cmp edx, 1
    je invert
    xor edx, edx
    xor esi, esi
    jmp convert

invert:
    not dword [esp]
    not dword [esp + 4]
    not dword [esp + 8]
    not dword [esp + 12]
    mov eax, [esp]
    adc dword [esp + 4], eax
    mov eax, [esp + 4]
    adc dword [esp + 8], eax
    mov eax, [esp + 8]
    adc dword [esp + 12], eax
    xor edx, edx
    xor esi, esi
    xor eax, eax
    jmp convert

convert:
    shld dword [esp], 1
    shld dword [esp + 4], 1
    shld dword [esp + 8], 1
    shld dword [esp + 12], 1
    ret