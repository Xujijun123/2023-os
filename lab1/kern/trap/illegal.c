#include <stdio.h>

int main() {
    
    // 触发非法指令异常
    asm volatile (
        "li t0, 0xFFFFFFFF\n"  // 这是一个不存在的指令，将触发非法指令异常
        "mret\n"              // 切换回先前的模式，触发异常处理
    );

    // 这里的代码将不会执行，因为异常处理会跳转到相应的异常处理程序

    
    return 0;
}

