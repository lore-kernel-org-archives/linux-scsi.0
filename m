From: "Michael P. Carel" <mikecarel@teamglac.com>
Subject: Address or Write Phase Parity Error in  Adaptec Ultra320(29320)
Date: Mon, 14 Apr 2003 09:59:14 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <005901c30229$735b8c00$8601a8c0@teamglac.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from team5.teamglac.com ([203.87.142.130]:34311 "HELO
	team5.teamglac.com") by vger.kernel.org with SMTP id S262711AbTDNBxu (for <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2003 21:53:50 -0400
Received: (from root@localhost)
	by team5.teamglac.com (8.9.3/8.9.3) id KAA19136
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2003 10:00:24 +0800
Received: from mike (team4.teamglac.com [203.87.142.132])
	by team5.teamglac.com (8.9.3/8.9.3) with SMTP id KAA19131
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2003 10:00:24 +0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm having problem with  my Adaptec Ultra320(29320) in RedHat Linux 7.3
with kernel 2.4.18-3 a Address or Write Phase Parity Error always display on
screen and if the system is idle for a long time, the server network
crushes. I've already used the driver revision 1.3.6 from the freeBSD
website.

Can anyone help me please...


Mike



Here's the sample log:

>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Apr  8 08:11:33 qa kernel: scsi0: Dumping Card State at program address 0xd
Mode 0x33
Apr  8 08:11:33 qa kernel: Card was paused
Apr  8 08:11:33 qa kernel: SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)
Apr  8 08:11:33 qa kernel: SEQINTCTL[0x0] SCSISIGI[0x0]:(P_DATAOUT)
SCSIPHASE[0x0]
Apr  8 08:11:33 qa kernel: SCSIBUS[0x0] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)
Apr  8 08:11:33 qa kernel: SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x0]
Apr  8 08:11:33 qa kernel: SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
Apr  8 08:11:33 qa kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0]
Apr  8 08:11:33 qa kernel: LQOSTAT1[0x0] LQOSTAT2[0x0]
Apr  8 08:11:33 qa kernel:
Apr  8 08:11:33 qa kernel: SCB Count = 4 LASTSCB 0x3 CURRSCB 0x3 NEXTSCB 0x0
Apr  8 08:11:33 qa kernel: qinstart = 15 qinfifonext = 15
Apr  8 08:11:33 qa kernel: QINFIFO:
Apr  8 08:11:33 qa kernel: WAITING_TID_QUEUES:
Apr  8 08:11:33 qa kernel: Pending list:
Apr  8 08:11:33 qa kernel: Kernel Free SCB list: 3 2 1 0
Apr  8 08:11:33 qa kernel: Sequencer Complete DMA-inprog list:
Apr  8 08:11:33 qa kernel: Sequencer Complete list:
Apr  8 08:11:33 qa kernel: Sequencer DMA-Up and Complete list:
Apr  8 08:11:33 qa kernel:
Apr  8 08:11:33 qa kernel: scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0,
LJSCB 0xff00
Apr  8 08:11:33 qa kernel:
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENS
AVEPTRS)
Apr  8 08:11:33 qa kernel: SEQINTSRC[0x0] DFCNTRL[0x0]
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Apr  8 08:11:33 qa kernel: SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0]
DFFSXFRCTL[0x0]
Apr  8 08:11:33 qa kernel: SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO)
SHADDR = 0x00, SHCNT = 0x0
Apr  8 08:11:33 qa kernel: HADDR = 0x00, HCNT =
0x0CCSGCTL[0x10]:(SG_CACHE_AVAIL)
Apr  8 08:11:33 qa kernel: scsi0: FIFO1 Free, LONGJMP == 0x80ff, SCB 0x0,
LJSCB 0xff00
Apr  8 08:11:33 qa kernel:
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENS
AVEPTRS)
Apr  8 08:11:33 qa kernel: SEQINTSRC[0x0] DFCNTRL[0x0]
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Apr  8 08:11:33 qa autofs: automount startup succeeded
Apr  8 08:11:33 qa kernel: SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0]
DFFSXFRCTL[0x0]
Apr  8 08:11:33 qa kernel: SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO)
SHADDR = 0x00, SHCNT = 0x0
Apr  8 08:11:33 qa kernel: HADDR = 0x00, HCNT =
0x0CCSGCTL[0x10]:(SG_CACHE_AVAIL)
Apr  8 08:11:33 qa kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Apr  8 08:11:33 qa sshd: Generating SSH1 RSA host key:
Apr  8 08:11:33 qa kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE
= 0x42
Apr  8 08:11:33 qa kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Apr  8 08:11:33 qa kernel: scsi0: REG0 == 0x214a, SINDEX = 0x133, DINDEX =
0x120
Apr  8 08:11:33 qa kernel: scsi0: SCBPTR == 0x3, SCB_NEXT == 0xffc0,
SCB_NEXT2 == 0xfffb
Apr  8 08:11:33 qa kernel: CDB 12 0 0 0 ff 0
Apr  8 08:11:33 qa kernel: STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x27 0x1
Apr  8 08:11:33 qa kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends
>>>>>>>>>>>>>>>>>>
Apr  8 08:11:33 qa kernel: scsi0: Address or Write Phase Parity Error
Detected in TARG.
Apr  8 08:11:33 qa kernel: scsi1: PCI error Interrupt

