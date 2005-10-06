From: dth@cistron.nl (Danny ter Haar)
Subject: report: 2.6.14-rc3-git3 crashed on usenet gateway after 58 hours
Date: Thu, 6 Oct 2005 08:27:39 +0000 (UTC)
Message-ID: <di2n5r$9bt$1@news.cistron.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ncc1701.cistron.net ([62.216.30.38]:59781 "EHLO
	ncc1701.cistron.net") by vger.kernel.org with ESMTP
	id S1750744AbVJFI1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Oct 2005 04:27:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Same thing als previous reports:
All 2.6.1[34] dont work stable of this machine (for me)
2.6.12-mm1 survives >> 3 weeks without problems.

Scsi driver is exactly the same as in 2.6.12-mm1, so i don't suspect the
scsi driver itself, but the acpi/irq routing that changed.

dmesg/config etc is @ http://newsgate.newsserver.nl/kernel/2.6.14-rc3-git3

This was part of the barf message before it rebooted
------------

scsi0: ILLEGAL_PHASE 0x80
(scsi0:A:1:0): Abort Message Sent
scsi0:0:1:0: Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0xe6 0xf4 0x4a 0x0 0x0 0x48 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x26 Mode 0x11
Card was paused
HS_MAILBOX[0x0] INTCTL[0xc0]:(SWTMINTEN|SWTMINTMASK)
SEQINTSTAT[0x10]:(SEQ_SWTMRTO) SAVED_MODE[0x11]
DFFSTAT[0x9]:(CURRFIFO_1) SCSISIGI[0x25]:(P_DATAOUT_DT|ACKI|BSYI)
SCSIPHASE[0x1]:(DATA_OUT_PHASE) SCSIBUS[0x0] LASTPHASE[0x20]:(P_DATAOUT_DT)
SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)
SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x20]:(DPHASE)
SEQ_FLAGS2[0x0] SSTAT0[0x0] SSTAT1[0x9]:(REQINIT|BUSFREE)
SSTAT2[0x0] SSTAT3[0x80] PERRDIAG[0x0] SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]:(PACKETIZED)
LQOSTAT0[0x0] LQOSTAT1[0x8]:(LQOSTOPI2) LQOSTAT2[0x21]:(LQOSTOP0)

SCB Count = 128 CMDS_PENDING = 96 LASTSCB 0x7a CURRSCB 0x10 NEXTSCB 0x2
qinstart = 24642 qinfifonext = 24642
QINFIFO:
WAITING_TID_QUEUES:
       0 ( 0x66 0x69 0x64 0x9 0x34 0x6c 0x46 0x7c 0x5f 0x21 0x62 0x3f 0x52 0x7d 0x39 0x17 0x15 0x41 0x8 0x4c 0x2e 0x44 0x6b 0x36 0x1b 0x54 0x6e 0x53 )
       3 ( 0x32 )
Pending list:
 50 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x37]

[SNIP]

Danny

