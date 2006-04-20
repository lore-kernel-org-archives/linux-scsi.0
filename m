From: oscar <oscar@netpromote.hu>
Subject: Re: [Bugme-new] [Bug 6416] New: AIC79xx crashes with AHA39320 and
 6 LUNs on 1 ID
Date: Thu, 20 Apr 2006 13:03:48 +0200
Message-ID: <44476A94.5040406@netpromote.hu>
References: <200604200921.k3K9LJ2Y002500@fire-2.osdl.org> <20060420023611.21e22082.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.netpromote.hu ([82.141.187.134]:16818 "EHLO
	mail.netpromote.hu") by vger.kernel.org with ESMTP id S1750709AbWDTLED
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 07:04:03 -0400
In-Reply-To: <20060420023611.21e22082.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

Here is the resulting dump:

sd 8:0:0:1: Attempting to queue an ABORT message:CDB: 0x28 0x0 0x0 0x0
0x0 0x0 0x0 0x0 0x8 0x0
scsi8: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi8: Dumping Card State at program address 0x21 Mode 0x33
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0]
INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] SAVED_MODE[0x11]
DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE)
SCSISIGI[0x25]:(P_DATAOUT_DT|ACKI|BSYI) SCSIPHASE[0x0]
SCSIBUS[0x0] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)
SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)
SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x0]
SEQ_FLAGS2[0x4]:(SELECTOUT_QFROZEN)
QFREEZE_COUNT[0x5] KERNEL_QFREEZE_COUNT[0x5] MK_MESSAGE_SCB[0xff00]
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8]:(BUSFREE)
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]:(HIPERR|HIZERO)
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]:(PACKETIZED)
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0xe1]:(LQOSTOP0|LQOPKT)

SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0xff80
qinstart = 439 qinfifonext = 439
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
  2 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7]
Total 1
Kernel Free SCB list: 3 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi8: FIFO0 Free, LONGJMP == 0x8271, SCB 0x2
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)

SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)

scsi8: FIFO1 Free, LONGJMP == 0x8063, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)

SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)
LQIN: 0x8 0x0 0x0 0x2 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi8: LQISTATE = 0x1, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi8: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
scsi8: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0

SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
CCSCBCTL[0x4]:(CCSCBDIR)
scsi8: REG0 == 0x2, SINDEX = 0x102, DINDEX = 0x102
scsi8: SCBPTR == 0x2, SCB_NEXT == 0xff80, SCB_NEXT2 == 0xffd0
CDB 28 0 0 0 0 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
sd 8:0:0:1: BDR message in message buffer
scsi8: Recovery code sleeping
scsi8: Recovery code awake
scsi8: Timer Expired (active 1)
aic79xx_abort returns 0x2003
sd 8:0:0:1: Attempting to queue a TARGET RESET message:CDB: 0x28 0x0 0x0
0x0 0x0 0x0 0x0 0x0 0x8 0x0
aic79xx_dev_reset returns 0x2003
Recovery SCB completes
NMI Watchdog detected LOCKUP on CPU 0
CPU 0
Modules linked in: floppy aic79xx hw_random tg3 e100 dm_mod
Pid: 2851, comm: scsi_eh_8 Not tainted 2.6.16.9 #5
RIP: 0010:[<ffffffff803bfd89>] <ffffffff803bfd89>{_spin_lock_irqsave+121}
RSP: 0018:ffff81007c73fce8  EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff81007f689208 RCX: 0000000000000002
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff81007c73fcf8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff81007ce54000
R13: ffff81007c73fd58 R14: 000000000000000f R15: 0000000000000010
FS:  00002ac23ffe5640(0000) GS:ffffffff8051f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002b140fb00c80 CR3: 000000007d504000 CR4: 00000000000006e0
Process scsi_eh_8 (pid: 2851, threadinfo ffff81007c73e000, task
ffff81007f765080)
Stack: 0000000000000013 ffff81007ce54000 ffff81007c73fd28 ffffffff8805c843
       0000000000000010 0000000000000010 ffff81007ce57148 ffff81007ce54000
       ffff81007c73fdc8 ffffffff8804e9ac
Call Trace: <ffffffff8805c843>{:aic79xx:ahd_freeze_simq+35}
       <ffffffff8804e9ac>{:aic79xx:ahd_reset_channel+1308}
       <ffffffff8805a4f9>{:aic79xx:ahd_linux_bus_reset+121}
       <ffffffff80326075>{scsi_try_bus_reset+53}
<ffffffff80326233>{scsi_eh_bus_reset+115}
       <ffffffff80326716>{scsi_eh_ready_devs+70}
<ffffffff803268a5>{scsi_unjam_host+165}
       <ffffffff803268c0>{scsi_error_handler+0}
<ffffffff80326927>{scsi_error_handler+103}
       <ffffffff80144393>{kthread+147} <ffffffff8010bf7e>{child_rip+8}
       <ffffffff80144300>{kthread+0} <ffffffff8010bf76>{child_rip+0}

Code: 8b 73 04 85 f6 75 f1 eb 8d c7 43 04 00 00 00 00 48 8b 45 f0
console shuts up ...
 <0>Kernel panic - not syncing: Aiee, killing interrupt handler!
 
Andrew Morton wrote:
> Looks like we recurred onto a spinlock, but that driver is so obfuscated
> it's rather hard to tell which one.
>
> Can you please retest with CONFIG_DEBUG_SLAB=y, CONFIG_DEBUG_SPINLOCK=y,
> CONFIG_DEBUG_SPINLOCK_SLEEP=y, CONFIG_PREEMPT=y and any other CONFIG_DEBUG
> options which look useful?
>
>   

