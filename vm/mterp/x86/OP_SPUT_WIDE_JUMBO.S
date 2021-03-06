%verify "executed"
%verify "field already resolved"
%verify "field not yet resolved"
%verify "field cannot be resolved"
    /*
     * Jumbo 64-bit SPUT handler.
     */
    /* sput-wide/jumbo vBBBB, field@AAAAAAAA */
    movl      rSELF,%ecx
    movl      offThread_methodClassDex(%ecx),%ecx  # ecx<- DvmDex
    movl      2(rPC),%eax                        # eax<- field ref AAAAAAAA
    movl      offDvmDex_pResFields(%ecx),%ecx    # ecx<- dvmDex->pResFields
    movl      (%ecx,%eax,4),%eax                 # eax<- resolved StaticField ptr
    testl     %eax,%eax                          # resolved entry null?
    je        .L${opcode}_resolve                # if not, make it so
.L${opcode}_finish:     # field ptr in eax
    GET_VREG_WORD %ecx rINST 0                  # ecx<- lsw
    GET_VREG_WORD rINST rINST 1                 # rINST<- msw
    movl      %ecx,offStaticField_value(%eax)
    FETCH_INST_OPCODE 4 %ecx
    movl      rINST,4+offStaticField_value(%eax)
    ADVANCE_PC 4
    GOTO_NEXT_R %ecx

    /*
     * Go resolve the field
     */
.L${opcode}_resolve:
    movl     rSELF,%ecx
    movl     2(rPC),%eax                        # eax<- field ref AAAAAAAA
    movl     offThread_method(%ecx),%ecx          # ecx<- current method
    EXPORT_PC                                   # could throw, need to export
    movl     offMethod_clazz(%ecx),%ecx         # ecx<- method->clazz
    movl     %eax,OUT_ARG1(%esp)
    movl     %ecx,OUT_ARG0(%esp)
    SPILL(rIBASE)
    call     dvmResolveStaticField              # eax<- resolved StaticField ptr
    UNSPILL(rIBASE)
    testl    %eax,%eax
    jne      .L${opcode}_finish                 # success, continue
    jmp      common_exceptionThrown             # no, handle exception
