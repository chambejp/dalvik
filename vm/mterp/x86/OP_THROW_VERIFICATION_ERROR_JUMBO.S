%verify executed
    /*
     * Handle a jumbo throw-verification-error instruction.  This throws an
     * exception for an error discovered during verification.  The
     * exception is indicated by BBBB, with some detail provided by AAAAAAAA.
     */
    /* exop BBBB, ref@AAAAAAAA */
    movl     rSELF,%ecx
    movl     2(rPC),%eax                     # eax<- AAAAAAAA
    movl     offThread_method(%ecx),%ecx       # ecx<- self->method
    EXPORT_PC
    movl     %eax,OUT_ARG2(%esp)             # arg2<- AAAAAAAA
    movl     rINST,OUT_ARG1(%esp)            # arg1<- BBBB
    movl     %ecx,OUT_ARG0(%esp)             # arg0<- method
    call     dvmThrowVerificationError       # call(method, kind, ref)
    jmp      common_exceptionThrown          # handle exception
