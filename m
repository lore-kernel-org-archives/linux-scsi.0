From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14159] AIC79xx is not working properly with an attached scsi
 tape since 2.6.29
Date: Fri, 11 Sep 2009 09:23:40 GMT
Message-ID: <200909110923.n8B9Nebn025085@demeter.kernel.org>
References: <bug-14159-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53138 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZIKJXh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 05:23:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8B9NeAs025087
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2009 09:23:40 GMT
In-Reply-To: <bug-14159-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14159


g.giorgetti@teamsystem.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Platform|All                         |i386




--- Comment #1 from g.giorgetti@teamsystem.com  2009-09-11 09:23:40 ---
Previous log for kernel 2.6.30 was missing characters because of a cut/paste
problem with text wrap, repasting :

Kernel 2.6.30

Aug  3 06:25:04 svil kernel: aic79xx 0000:41:01.0: PCI INT A -> GSI 19 (level,
low) -> IRQ 19
Aug  3 06:25:04 svil kernel: scsi5 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev
3.0
Aug  3 06:25:04 svil kernel:         <Adaptec 29320ALP PCIx Ultra320 SCSI
adapter>
Aug  3 06:25:04 svil kernel:         aic7901: Ultra320 Wide Channel A, SCSI
Id=7, PCI-X 101-133MHz, 512 SCBs
Aug  3 06:25:04 svil kernel: scsi 5:0:0:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:04 svil kernel: scsi 5:0:0:0: Command already completed
Aug  3 06:25:04 svil kernel: scsi 5:0:0:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:04 svil kernel: scsi 5:0:0:0: Command already completed
Aug  3 06:25:04 svil kernel: scsi 5:0:0:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:04 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:04 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:04 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:04 svil kernel: Recovery SCB completes
Aug  3 06:25:04 svil kernel: scsi 5:0:0:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:04 svil kernel: scsi 5:0:0:0: Command already completed
Aug  3 06:25:04 svil kernel: scsi 5:0:0:0: Device offlined - not ready after
error recovery
Aug  3 06:25:04 svil kernel: scsi 5:0:1:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:04 svil kernel: scsi 5:0:1:0: Command already completed
Aug  3 06:25:04 svil kernel: scsi 5:0:1:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:04 svil kernel: scsi 5:0:1:0: Command already completed
Aug  3 06:25:04 svil kernel: scsi 5:0:1:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:04 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:04 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:04 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:04 svil kernel: Recovery SCB completes
Aug  3 06:25:04 svil kernel: scsi 5:0:1:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:04 svil kernel: scsi 5:0:1:0: Command already completed
Aug  3 06:25:04 svil kernel: scsi 5:0:1:0: Device offlined - not ready after
error recovery
Aug  3 06:25:04 svil kernel: scsi 5:0:2:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:04 svil kernel: scsi 5:0:2:0: Command already completed
Aug  3 06:25:04 svil kernel: scsi 5:0:2:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:04 svil kernel: scsi 5:0:2:0: Command already completed
Aug  3 06:25:04 svil kernel: scsi 5:0:2:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:04 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:04 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:05 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:05 svil kernel: Recovery SCB completes
Aug  3 06:25:05 svil kernel: scsi 5:0:2:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:05 svil kernel: scsi 5:0:2:0: Command already completed
Aug  3 06:25:05 svil kernel: scsi 5:0:2:0: Device offlined - not ready after
error recovery
Aug  3 06:25:05 svil kernel: scsi 5:0:3:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:05 svil kernel: scsi5: At time of recovery, card was paused
Aug  3 06:25:05 svil kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins
<<<<<<<<<<<<<<<<<
Aug  3 06:25:05 svil kernel: scsi5: Dumping Card State at program address 0x127
Mode 0x11
Aug  3 06:25:05 svil kernel: Card was paused
Aug  3 06:25:05 svil kernel: INTSTAT[0x0] SELOID[0x3] SELID[0x0]
HS_MAILBOX[0x0]
Aug  3 06:25:05 svil kernel: INTCTL[0x0] SEQINTSTAT[0x0] SAVED_MODE[0x0]
DFFSTAT[0x19]
Aug  3 06:25:05 svil kernel: SCSISIGI[0xe6] SCSIPHASE[0x8] SCSIBUS[0x2]
LASTPHASE[0xe0]
Aug  3 06:25:05 svil kernel: SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0]
SEQINTCTL[0x0]
Aug  3 06:25:05 svil kernel: SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0]
Aug  3 06:25:05 svil kernel: KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00]
Aug  3 06:25:05 svil kernel: MK_MESSAGE_SCSIID[0xff] SSTAT0[0x2] SSTAT1[0x1]
Aug  3 06:25:05 svil kernel: SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xac]
Aug  3 06:25:05 svil kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0]
Aug  3 06:25:05 svil kernel: LQOSTAT1[0x0] LQOSTAT2[0x0]
Aug  3 06:25:05 svil kernel:
Aug  3 06:25:05 svil kernel: SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff
CURRSCB 0x3 NEXTSCB 0x0
Aug  3 06:25:05 svil kernel: qinstart = 13 qinfifonext = 13
Aug  3 06:25:05 svil kernel: QINFIFO:
Aug  3 06:25:05 svil kernel: WAITING_TID_QUEUES:
Aug  3 06:25:05 svil kernel: Pending list:
Aug  3 06:25:05 svil kernel:   3 FIFO_USE[0x0] SCB_CONTROL[0x40]
SCB_SCSIID[0x37]
Aug  3 06:25:05 svil kernel: Total 1
Aug  3 06:25:05 svil kernel: Kernel Free SCB list: 2 1 0
Aug  3 06:25:05 svil kernel: Sequencer Complete DMA-inprog list:
Aug  3 06:25:05 svil kernel: Sequencer Complete list:
Aug  3 06:25:05 svil kernel: Sequencer DMA-Up and Complete list:
Aug  3 06:25:05 svil kernel: Sequencer On QFreeze and Complete list:
Aug  3 06:25:05 svil kernel:
Aug  3 06:25:05 svil kernel:
Aug  3 06:25:05 svil kernel: scsi5: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
Aug  3 06:25:05 svil kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0]
DFSTATUS[0x89]
Aug  3 06:25:05 svil kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Aug  3 06:25:05 svil kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT =
0x0
Aug  3 06:25:05 svil kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Aug  3 06:25:05 svil kernel:
Aug  3 06:25:05 svil kernel: scsi5: FIFO1 Active, LONGJMP == 0x8063, SCB 0x3
Aug  3 06:25:05 svil kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4]
DFSTATUS[0x89]
Aug  3 06:25:05 svil kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Aug  3 06:25:05 svil kernel: SOFFCNT[0x0] MDFFSTAT[0x14] SHADDR = 0x06, SHCNT =
0x0
Aug  3 06:25:05 svil kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Aug  3 06:25:05 svil kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:05 svil kernel: scsi5: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE
= 0x52
Aug  3 06:25:05 svil kernel: scsi5: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Aug  3 06:25:05 svil kernel: scsi5: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
Aug  3 06:25:05 svil kernel: SIMODE0[0xc]
Aug  3 06:25:05 svil kernel: CCSCBCTL[0x4]
Aug  3 06:25:05 svil kernel: scsi5: REG0 == 0x3, SINDEX = 0x1e0, DINDEX = 0xe1
Aug  3 06:25:05 svil kernel: scsi5: SCBPTR == 0x3, SCB_NEXT == 0xffc0,
SCB_NEXT2 == 0xff65
Aug  3 06:25:05 svil kernel: CDB 12 0 0 0 24 0
Aug  3 06:25:05 svil kernel: STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:05 svil kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends
>>>>>>>>>>>>>>>>>>
Aug  3 06:25:05 svil kernel: scsi 5:0:3:0: Device is active, asserting ATN
Aug  3 06:25:05 svil kernel: scsi5: Recovery code sleeping
Aug  3 06:25:05 svil kernel: scsi5: Timer Expired (active 1)
Aug  3 06:25:05 svil kernel: Recovery code awake
Aug  3 06:25:05 svil kernel: scsi5: Command abort returning 0x2003
Aug  3 06:25:06 svil kernel: scsi 5:0:3:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:06 svil kernel: scsi5: Device reset timer expired (active 2)
Aug  3 06:25:06 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: scsi 5:0:3:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi5: At time of recovery, card was not paused
Aug  3 06:25:06 svil kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins
<<<<<<<<<<<<<<<<<
Aug  3 06:25:06 svil kernel: scsi5: Dumping Card State at program address 0x34
Mode 0x22
Aug  3 06:25:06 svil kernel: Card was paused
Aug  3 06:25:06 svil kernel: INTSTAT[0x0] SELOID[0x3] SELID[0x0]
HS_MAILBOX[0x0]
Aug  3 06:25:06 svil kernel: INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x0]
DFFSTAT[0x33]
Aug  3 06:25:06 svil kernel: SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0]
LASTPHASE[0x1]
Aug  3 06:25:06 svil kernel: SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0]
SEQINTCTL[0x0]
Aug  3 06:25:06 svil kernel: SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x1]
Aug  3 06:25:06 svil kernel: KERNEL_QFREEZE_COUNT[0x1] MK_MESSAGE_SCB[0xff00]
Aug  3 06:25:06 svil kernel: MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8]
Aug  3 06:25:06 svil kernel: SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xa4]
Aug  3 06:25:06 svil kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0]
Aug  3 06:25:06 svil kernel: LQOSTAT1[0x0] LQOSTAT2[0x0]
Aug  3 06:25:06 svil kernel:
Aug  3 06:25:06 svil kernel: SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff
CURRSCB 0x3 NEXTSCB 0x0
Aug  3 06:25:06 svil kernel: qinstart = 14 qinfifonext = 15
Aug  3 06:25:06 svil kernel: QINFIFO: 0x3
Aug  3 06:25:06 svil kernel: WAITING_TID_QUEUES:
Aug  3 06:25:06 svil kernel: Pending list:
Aug  3 06:25:06 svil kernel:   3 FIFO_USE[0x3] SCB_CONTROL[0x48]
SCB_SCSIID[0x37]
Aug  3 06:25:06 svil kernel: Total 1
Aug  3 06:25:06 svil kernel: Kernel Free SCB list: 2 1 0
Aug  3 06:25:06 svil kernel: Sequencer Complete DMA-inprog list:
Aug  3 06:25:06 svil kernel: Sequencer Complete list:
Aug  3 06:25:06 svil kernel: Sequencer DMA-Up and Complete list:
Aug  3 06:25:06 svil kernel: Sequencer On QFreeze and Complete list:
Aug  3 06:25:06 svil kernel:
Aug  3 06:25:06 svil kernel:
Aug  3 06:25:06 svil kernel: scsi5: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
Aug  3 06:25:06 svil kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0]
DFSTATUS[0x89]
Aug  3 06:25:06 svil kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Aug  3 06:25:06 svil kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT =
0x0
Aug  3 06:25:06 svil kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Aug  3 06:25:06 svil kernel:
Aug  3 06:25:06 svil kernel: scsi5: FIFO1 Free, LONGJMP == 0x8063, SCB 0x3
Aug  3 06:25:06 svil kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4]
DFSTATUS[0x89]
Aug  3 06:25:06 svil kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Aug  3 06:25:06 svil kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT =
0x0
Aug  3 06:25:06 svil kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Aug  3 06:25:06 svil kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi5: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE
= 0x52
Aug  3 06:25:06 svil kernel: scsi5: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Aug  3 06:25:06 svil kernel: scsi5: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
Aug  3 06:25:06 svil kernel: SIMODE0[0xc]
Aug  3 06:25:06 svil kernel: CCSCBCTL[0x0]
Aug  3 06:25:06 svil kernel: scsi5: REG0 == 0x3, SINDEX = 0x119, DINDEX = 0xe1
Aug  3 06:25:06 svil kernel: scsi5: SCBPTR == 0x3, SCB_NEXT == 0xff00,
SCB_NEXT2 == 0xffa4
Aug  3 06:25:06 svil kernel: CDB 0 0 0 0 0 0
Aug  3 06:25:06 svil kernel: STACK: 0x20 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends
>>>>>>>>>>>>>>>>>>
Aug  3 06:25:06 svil kernel: scsi5:0:3:0: Cmd aborted from QINFIFO
Aug  3 06:25:06 svil kernel: scsi 5:0:3:0: Device offlined - not ready after
error recovery
Aug  3 06:25:06 svil kernel: scsi 5:0:4:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:4:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:4:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:4:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:4:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:06 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:06 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: scsi 5:0:4:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:4:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:4:0: Device offlined - not ready after
error recovery
Aug  3 06:25:06 svil kernel: scsi 5:0:5:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:5:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:5:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:5:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:5:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:06 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:06 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: scsi 5:0:5:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:5:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:5:0: Device offlined - not ready after
error recovery
Aug  3 06:25:06 svil kernel: scsi 5:0:6:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:6:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:6:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:6:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:6:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:06 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:06 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: scsi 5:0:6:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:6:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:6:0: Device offlined - not ready after
error recovery
Aug  3 06:25:06 svil kernel: scsi 5:0:8:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:8:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:8:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:8:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:8:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:06 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:06 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: scsi 5:0:8:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:8:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:8:0: Device offlined - not ready after
error recovery
Aug  3 06:25:06 svil kernel: scsi 5:0:9:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:9:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:9:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:9:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:9:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:06 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:06 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: scsi 5:0:9:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:9:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:9:0: Device offlined - not ready after
error recovery
Aug  3 06:25:06 svil kernel: scsi 5:0:10:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:10:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:10:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:10:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:10:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:06 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:06 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: scsi 5:0:10:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:10:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:10:0: Device offlined - not ready after
error recovery
Aug  3 06:25:06 svil kernel: scsi 5:0:11:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:11:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:11:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:11:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:11:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:06 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:06 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: scsi 5:0:11:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:11:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:11:0: Device offlined - not ready after
error recovery
Aug  3 06:25:06 svil kernel: scsi 5:0:12:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:12:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:12:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:12:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:12:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:06 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:06 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: scsi 5:0:12:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:12:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:12:0: Device offlined - not ready after
error recovery
Aug  3 06:25:06 svil kernel: scsi 5:0:13:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:13:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:13:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:13:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:13:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:06 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:06 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:06 svil kernel: Recovery SCB completes
Aug  3 06:25:06 svil kernel: scsi 5:0:13:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:13:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:13:0: Device offlined - not ready after
error recovery
Aug  3 06:25:06 svil kernel: scsi 5:0:14:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:14:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:14:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:06 svil kernel: scsi 5:0:14:0: Command already completed
Aug  3 06:25:06 svil kernel: scsi 5:0:14:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:06 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:07 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:07 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:07 svil kernel: Recovery SCB completes
Aug  3 06:25:07 svil kernel: scsi 5:0:14:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:07 svil kernel: scsi 5:0:14:0: Command already completed
Aug  3 06:25:07 svil kernel: scsi 5:0:14:0: Device offlined - not ready after
error recovery
Aug  3 06:25:07 svil kernel: scsi 5:0:15:0: Attempting to queue an ABORT
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:07 svil kernel: scsi 5:0:15:0: Command already completed
Aug  3 06:25:07 svil kernel: scsi 5:0:15:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:07 svil kernel: scsi 5:0:15:0: Command already completed
Aug  3 06:25:07 svil kernel: scsi 5:0:15:0: Attempting to queue a TARGET RESET
message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
Aug  3 06:25:07 svil kernel: scsi5: Device reset code sleeping
Aug  3 06:25:07 svil kernel: scsi5: Device reset timer expired (active 1)
Aug  3 06:25:07 svil kernel: scsi5: Device reset returning 0x2003
Aug  3 06:25:07 svil kernel: Recovery SCB completes
Aug  3 06:25:07 svil kernel: scsi 5:0:15:0: Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Aug  3 06:25:07 svil kernel: scsi 5:0:15:0: Command already completed
Aug  3 06:25:07 svil kernel: scsi 5:0:15:0: Device offlined - not ready after
error recovery

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
