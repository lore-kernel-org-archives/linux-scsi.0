From: Primoz Kolaric <primoz.kolaric@cosylab.com>
Subject: scsi0: PCI error Interrupt with  Adaptec ASC-29320A
Date: Thu, 27 Mar 2008 12:06:44 +0100
Message-ID: <47EB7FC4.7080408@cosylab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.cosylab.com ([194.249.198.70]:43113 "EHLO mail.cosylab.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbYC0LcC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 07:32:02 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.cosylab.com (Postfix) with ESMTP id 09C975C44E4
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2008 12:06:42 +0100 (CET)
Received: from mail.cosylab.com ([127.0.0.1])
	by localhost (cosy.cosylab.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 3zYNYzCLl-aN for <linux-scsi@vger.kernel.org>;
	Thu, 27 Mar 2008 12:06:41 +0100 (CET)
Received: from [192.168.150.4] (valhalla.ptuj.org [90.157.141.36])
	by mail.cosylab.com (Postfix) with ESMTP id F26D05C44E1
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2008 12:06:40 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,


I have a strange problem with my SCSI subsystem. After a few days (7-10 
days) of normal work the linux kernel starts to report these messages:

Mar 20 08:19:53 xxxx kernel: scsi0: PCI error Interrupt
Mar 20 08:19:53 xxxx kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
Mar 20 08:19:53 xxxx kernel: scsi0: Dumping Card State at program 
address 0x1c8 Mode 0x11
Mar 20 08:19:53 xxxx kernel: Card was paused
Mar 20 08:19:53 xxxx kernel: INTSTAT[0x10]:(PCIINT) SELOID[0x3] SELID[0x30]
Mar 20 08:19:53 xxxx kernel: HS_MAILBOX[0x0] 
INTCTL[0xc0]:(SWTMINTEN|SWTMINTMASK)
Mar 20 08:19:53 xxxx kernel: SEQINTSTAT[0x10]:(SEQ_SWTMRTO) 
SAVED_MODE[0x11]
Mar 20 08:19:53 xxxx kernel: DFFSTAT[0x19]:(CURRFIFO_1|FIFO0FREE) 
SCSISIGI[0x26]:(P_DATAOUT_DT|REQI|BSYI)
Mar 20 08:19:53 xxxx kernel: SCSIPHASE[0x1]:(DATA_OUT_PHASE) 
SCSIBUS[0x0] LASTPHASE[0x20]:(P_DATAOUT_DT)
Mar 20 08:19:53 xxxx kernel: SCSISEQ0[0x0] 
SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)
Mar 20 08:19:53 xxxx kernel: SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20]:(DPHASE)
Mar 20 08:19:53 xxxx kernel: SEQ_FLAGS2[0x0] QFREEZE_COUNT[0x4] 
KERNEL_QFREEZE_COUNT[0x4]
Mar 20 08:19:53 xxxx kernel: MK_MESSAGE_SCB[0xff00] MK_MESSAGE_SCSIID[0xff]
Mar 20 08:19:53 xxxx kernel: SSTAT0[0x0] SSTAT1[0x9]:(REQINIT|BUSFREE) 
SSTAT2[0x0]
Mar 20 08:19:53 xxxx kernel: SSTAT3[0x0] PERRDIAG[0xc0]:(HIPERR|HIZERO) 
SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)
Mar 20 08:19:53 xxxx kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
LQOSTAT0[0x0]
Mar 20 08:19:53 xxxx kernel: LQOSTAT1[0x0] LQOSTAT2[0x0]
Mar 20 08:19:53 xxxx kernel:
Mar 20 08:19:53 xxxx kernel: SCB Count = 40 CMDS_PENDING = 1 LASTSCB 
0xffff CURRSCB 0x1e NEXTSCB 0x0
Mar 20 08:19:53 xxxx kernel: qinstart = 20712 qinfifonext = 20712
Mar 20 08:19:53 xxxx kernel: QINFIFO:
Mar 20 08:19:53 xxxx kernel: WAITING_TID_QUEUES:
Mar 20 08:19:53 xxxx kernel: Pending list:
Mar 20 08:19:53 xxxx kernel:  30 FIFO_USE[0x0] 
SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:53 xxxx kernel: Total 1
Mar 20 08:19:53 xxxx kernel: Kernel Free SCB list: 5 32 14 2 10 19 16 39 
3 25 8 33 23 26 29 28 27 11 1 6 12 9 21 13 15 31 17 34 18 4 35 7 0 20 38 
24 22 37 36
Mar 20 08:19:53 xxxx kernel: Sequencer Complete DMA-inprog list:
Mar 20 08:19:53 xxxx kernel: Sequencer Complete list:
Mar 20 08:19:53 xxxx kernel: Sequencer DMA-Up and Complete list:
Mar 20 08:19:53 xxxx kernel: Sequencer On QFreeze and Complete list:
Mar 20 08:19:53 xxxx kernel:
Mar 20 08:19:53 xxxx kernel:
Mar 20 08:19:53 xxxx kernel: scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
Mar 20 08:19:53 xxxx kernel: 
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 

Mar 20 08:19:53 xxxx kernel: SEQINTSRC[0x0] DFCNTRL[0x0] 
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Mar 20 08:19:53 xxxx kernel: SG_CACHE_SHADOW[0x2]:(LAST_SEG) 
SG_STATE[0x0] DFFSXFRCTL[0x0]
Mar 20 08:19:53 xxxx kernel: SOFFCNT[0x7f] 
MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
Mar 20 08:19:53 xxxx kernel: HADDR = 0x00, HCNT = 0x0 
CCSGCTL[0x88]:(CCSGENACK|CCSGDONE)
Mar 20 08:19:53 xxxx kernel:
Mar 20 08:19:53 xxxx kernel: scsi0: FIFO1 Active, LONGJMP == 0x1f1, SCB 0x1e
Mar 20 08:19:53 xxxx kernel: 
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 

Mar 20 08:19:53 xxxx kernel: SEQINTSRC[0x0] 
DFCNTRL[0x2c]:(DIRECTION|HDMAEN|SCSIEN)
Mar 20 08:19:53 xxxx kernel: 
DFSTATUS[0xc9]:(FIFOEMP|HDONE|PKT_PRELOAD_AVAIL|PRELOAD_AVAIL)
Mar 20 08:19:53 xxxx kernel: SG_CACHE_SHADOW[0xe0] 
SG_STATE[0x6]:(LOADING_NEEDED|FETCH_INPROG)
Mar 20 08:19:53 xxxx kernel: DFFSXFRCTL[0x0] SOFFCNT[0x7f] 
MDFFSTAT[0x4]:(DLZERO)
Mar 20 08:19:53 xxxx kernel: SHADDR = 0x024bc000, SHCNT = 0x0 HADDR = 
0x024bc000, HCNT = 0x0
Mar 20 08:19:53 xxxx kernel: 
CCSGCTL[0x9c]:(CCSGENACK|SG_CACHE_AVAIL|CCSGDONE|CCSGEN)
Mar 20 08:19:53 xxxx kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Mar 20 08:19:53 xxxx kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, 
OPTIONMODE = 0x52
Mar 20 08:19:53 xxxx kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Mar 20 08:19:53 xxxx kernel: scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
Mar 20 08:19:53 xxxx kernel:
Mar 20 08:19:53 xxxx kernel: SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
Mar 20 08:19:53 xxxx kernel: CCSCBCTL[0x4]:(CCSCBDIR)
Mar 20 08:19:53 xxxx kernel: scsi0: REG0 == 0x3, SINDEX = 0x1e0, DINDEX 
= 0xa9
Mar 20 08:19:53 xxxx kernel: scsi0: SCBPTR == 0x1e, SCB_NEXT == 0xffc0, 
SCB_NEXT2 == 0xfff4
Mar 20 08:19:53 xxxx kernel: CDB 0 c 0 0 e0 28
Mar 20 08:19:53 xxxx kernel: STACK: 0x20a 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Mar 20 08:19:53 xxxx kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
 >>>>>>>>>>>>>>>>>>
Mar 20 08:19:53 xxxx kernel: scsi0: Data Parity Error has been reported 
via PERR# in DFF1
Mar 20 08:19:53 xxxx kernel: scsi0: Split completion read data parity 
error in DFF1
Mar 20 08:19:53 xxxx kernel: scsi0: Signal System Error Detected in DFF1
Mar 20 08:19:53 xxxx kernel: scsi0: Address or Write Phase Parity Error 
Detected in DFF1.
Mar 20 08:19:59 xxxx kernel: scsi0: PCI error Interrupt
Mar 20 08:19:59 xxxx kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
Mar 20 08:19:59 xxxx kernel: scsi0: Dumping Card State at program 
address 0x32 Mode 0x33
Mar 20 08:19:59 xxxx kernel: Card was paused
Mar 20 08:19:59 xxxx kernel: INTSTAT[0x10]:(PCIINT) SELOID[0x3] SELID[0x30]
Mar 20 08:19:59 xxxx kernel: HS_MAILBOX[0x0] 
INTCTL[0xc0]:(SWTMINTEN|SWTMINTMASK)
Mar 20 08:19:59 xxxx kernel: SEQINTSTAT[0x10]:(SEQ_SWTMRTO) 
SAVED_MODE[0x11]
Mar 20 08:19:59 xxxx kernel: DFFSTAT[0x19]:(CURRFIFO_1|FIFO0FREE) 
SCSISIGI[0xe6]:(P_MESGIN|REQI|BSYI)
Mar 20 08:19:59 xxxx kernel: SCSIPHASE[0x8]:(MSG_IN_PHASE) SCSIBUS[0x2] 
LASTPHASE[0x20]:(P_DATAOUT_DT)
Mar 20 08:19:59 xxxx kernel: SCSISEQ0[0x40]:(ENSELO) 
SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)
Mar 20 08:19:59 xxxx kernel: SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20]:(DPHASE)
Mar 20 08:19:59 xxxx kernel: SEQ_FLAGS2[0x0] QFREEZE_COUNT[0x4] 
KERNEL_QFREEZE_COUNT[0x4]
Mar 20 08:19:59 xxxx kernel: MK_MESSAGE_SCB[0xff00] MK_MESSAGE_SCSIID[0xff]
Mar 20 08:19:59 xxxx kernel: SSTAT0[0x2]:(SPIORDY) 
SSTAT1[0x19]:(REQINIT|BUSFREE|PHASEMIS)
Mar 20 08:19:59 xxxx kernel: SSTAT2[0x0] SSTAT3[0x0] 
PERRDIAG[0xc0]:(HIPERR|HIZERO)
Mar 20 08:19:59 xxxx kernel: 
SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)
Mar 20 08:19:59 xxxx kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
LQOSTAT0[0x0]
Mar 20 08:19:59 xxxx kernel: LQOSTAT1[0x0] LQOSTAT2[0x0]
Mar 20 08:19:59 xxxx kernel:
Mar 20 08:19:59 xxxx kernel: SCB Count = 40 CMDS_PENDING = 17 LASTSCB 
0xffff CURRSCB 0x11 NEXTSCB 0x0
Mar 20 08:19:59 xxxx kernel: qinstart = 21076 qinfifonext = 21076
Mar 20 08:19:59 xxxx kernel: QINFIFO:
Mar 20 08:19:59 xxxx kernel: WAITING_TID_QUEUES:
Mar 20 08:19:59 xxxx kernel:        3 ( 0x11 0x1e )
Mar 20 08:19:59 xxxx kernel: Pending list:
Mar 20 08:19:59 xxxx kernel:  30 FIFO_USE[0x0] 
SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  17 FIFO_USE[0x0] 
SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  25 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:   3 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  31 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  26 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  29 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  13 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  32 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  34 FIFO_USE[0x0] 
SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  22 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:   6 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  20 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  35 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  10 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  28 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel:  33 FIFO_USE[0x0] 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB)
Mar 20 08:19:59 xxxx kernel: SCB_SCSIID[0x3f]:(OID)
Mar 20 08:19:59 xxxx kernel: Total 17
Mar 20 08:19:59 xxxx kernel: Kernel Free SCB list: 19 21 12 9 5 8 11 27 
1 39 16 24 14 38 2 4 0 18 7 15 23 37 36
Mar 20 08:19:59 xxxx kernel: Sequencer Complete DMA-inprog list:
Mar 20 08:19:59 xxxx kernel: Sequencer Complete list:
Mar 20 08:19:59 xxxx kernel: Sequencer DMA-Up and Complete list:
Mar 20 08:19:59 xxxx kernel: Sequencer On QFreeze and Complete list:
Mar 20 08:19:59 xxxx kernel:
Mar 20 08:19:59 xxxx kernel:
Mar 20 08:19:59 xxxx kernel: scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
Mar 20 08:19:59 xxxx kernel: 
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 

Mar 20 08:19:59 xxxx kernel: SEQINTSRC[0x0] DFCNTRL[0x0] 
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Mar 20 08:19:59 xxxx kernel: SG_CACHE_SHADOW[0x2]:(LAST_SEG) 
SG_STATE[0x0] DFFSXFRCTL[0x0]
Mar 20 08:19:59 xxxx kernel: SOFFCNT[0x0] 
MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
Mar 20 08:19:59 xxxx kernel: HADDR = 0x00, HCNT = 0x0 
CCSGCTL[0x10]:(SG_CACHE_AVAIL)
Mar 20 08:19:59 xxxx kernel:
Mar 20 08:19:59 xxxx kernel: scsi0: FIFO1 Active, LONGJMP == 0x81f1, SCB 
0x22
Mar 20 08:19:59 xxxx kernel: 
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 

Mar 20 08:19:59 xxxx kernel: SEQINTSRC[0x0] DFCNTRL[0xc]:(DIRECTION|HDMAEN)
Mar 20 08:19:59 xxxx kernel: 
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x1b]:(LAST_SEG_DONE|LAST_SEG)
Mar 20 08:19:59 xxxx kernel: SG_STATE[0x0] DFFSXFRCTL[0x0] SOFFCNT[0x0] 
MDFFSTAT[0x14]:(DLZERO|LASTSDONE)
Mar 20 08:19:59 xxxx kernel: SHADDR = 0x04870a000, SHCNT = 0x0 HADDR = 
0x04870a000, HCNT = 0x0
Mar 20 08:19:59 xxxx kernel: CCSGCTL[0x10]:(SG_CACHE_AVAIL)
Mar 20 08:19:59 xxxx kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Mar 20 08:19:59 xxxx kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, 
OPTIONMODE = 0x52
Mar 20 08:19:59 xxxx kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Mar 20 08:19:59 xxxx kernel: scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
Mar 20 08:19:59 xxxx kernel: SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
Mar 20 08:19:59 xxxx kernel: CCSCBCTL[0x0]
Mar 20 08:19:59 xxxx kernel: scsi0: REG0 == 0xffff, SINDEX = 0x11a, 
DINDEX = 0xa9
Mar 20 08:19:59 xxxx kernel: scsi0: SCBPTR == 0x22, SCB_NEXT == 0x20, 
SCB_NEXT2 == 0x20
Mar 20 08:19:59 xxxx kernel: CDB 2a 0 14 80 18 68
Mar 20 08:19:59 xxxx kernel: STACK: 0x20c 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Mar 20 08:19:59 xxxx kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
 >>>>>>>>>>>>>>>>>>
Mar 20 08:19:59 xxxx kernel: scsi0: Data Parity Error has been reported 
via PERR# in DFF1
Mar 20 08:19:59 xxxx kernel: scsi0: Split completion read data parity 
error in DFF1
Mar 20 08:19:59 xxxx kernel: scsi0: Signal System Error Detected in DFF1
Mar 20 08:19:59 xxxx kernel: scsi0: Address or Write Phase Parity Error 
Detected in DFF1.


After a few of those messages the file system gets corrupted and the 
partition is mounted read-only.


I already tried changing the scsi cables, terminators, running without 
terminators, changing the SCSI controler card (unfortunately i only had 
exactly same model) but nothing helps and i'm running out of ideas. I 
have two identical machines: same motherboard, same scsi controler 
connected to almost the same (difference is only in the number of hard 
disk bays) external RAID units and it happens on both of them. On one it 
happens regularly on the other it only happened twice in one year.

The same SCSI setup (same external raid and scsi controlers) was used 
before on different motherboard  and it worked ok, so i'm assuming that 
the problem isn't between the scsi controler and the external RAID.

I'm currently running debian 2.6.22-3-amd64 kernel. I also tried stock 
debian 2.6.18-5-amd64 kernel with the same results.


I also tried disabling the ACPI and the results were the same.

Any ideas/help would be very helpful.

Regards,

Primoz


HW data:

Motherboard: SuperMicro X7DBR-E
Processor:    Intel Xeon 5150
SCSI controler: Adaptec ASC-29320A
External RAID: InforTrend A08U-G1410

Some additional data:

Linux: Debian 4.0
Arch: x86_64


 lspci
00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller 
Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 2-3 (rev b1)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 4-5 (rev b1)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 6-7 (rev b1)
00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA 
Engine (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset Error 
Reporting Registers (rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset Error 
Reporting Registers (rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset Error 
Reporting Registers (rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI 
Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #3 (rev 09)
00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #4 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC 
Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller 
(rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus 
Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Upstream Port (rev 01)
01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to 
PCI-X Bridge (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E1 (rev 01)
02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E3 (rev 01)
04:00.0 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN 
Controller Copper (rev 01)
04:00.1 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN 
Controller Copper (rev 01)
05:01.0 SCSI storage controller: Adaptec ASC-29320A U320 (rev 10)
08:00.0 PCI bridge: Intel Corporation 6702PXH PCI Express-to-PCI Bridge 
A (rev 09)
0a:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

/proc/interrupts
           CPU0       CPU1      
  0:   76027268   76025263   IO-APIC-edge      timer
  1:       1011       1052   IO-APIC-edge      i8042
  4:      37108      37134   IO-APIC-edge      serial
  8:          0          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          2          1   IO-APIC-edge      i8042
 14:         19         18   IO-APIC-edge      ide0
 16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 24:    4391317    4392842   IO-APIC-fasteoi   aic79xx
1272:     245051     247594   PCI-MSI-edge      eth1
1273:   21405357   21403145   PCI-MSI-edge      eth0
NMI:          0          0
LOC:  152058048  152058024
ERR:          0

