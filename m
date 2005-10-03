From: dth@cistron.nl (Danny ter Haar)
Subject: 2.6.14-rc2-mm2 barfed as well, was:  2.6.14-rc2-git8 crashed with scsi error after 40 hours
Date: Mon, 3 Oct 2005 21:22:33 +0000 (UTC)
Message-ID: <dhs7ep$i4l$1@news.cistron.nl>
References: <dho4tc$ilc$1@news.cistron.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from news.cistron.nl ([62.216.30.38]:13252 "EHLO ncc1701.cistron.net")
	by vger.kernel.org with ESMTP id S964772AbVJCVWj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 17:22:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


2.6.14-rc2-mm2 just any other 2.6.1[34] kernel so far didn't get _my_
sign of aproval ;-)

reboot   system boot  2.6.14-rc2-mm2   Sun Oct  2 10:05 - crash (1+13:15)

----------
scsi0:0:0:0: Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0xdc 0x49 0xca 0x0 0x0 0x8 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x26 Mode 0x22
Card was paused
HS_MAILBOX[0x0] INTCTL[0xc0]:(SWTMINTEN|SWTMINTMASK)
SEQINTSTAT[0x10]:(SEQ_SWTMRTO) SAVED_MODE[0x11]
DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE)
SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] SCSIBUS[0x0]
LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) SCSISEQ0[0x0]
SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) SEQCTL0[0x0]
SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0]
LQOSTAT1[0x0] LQOSTAT2[0xe1]:(LQOSTOP0|LQOPKT)

SCB Count = 128 CMDS_PENDING = 32 LASTSCB 0x1a CURRSCB 0x1a NEXTSCB 0xff00
qinstart = 27585 qinfifonext = 27585
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
 36 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7]
 23 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7]
------------

Full crash, dmesg/config etc @ http://newsgate.newsserver.nl/kernel/2.6.14-rc2-mm2/

Now compiling 2.6.14-rc3-git3 ...

Danny

