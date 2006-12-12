From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: [Fwd: AIC79XX abort -- hardware fault?]
Date: Tue, 12 Dec 2006 08:18:16 -0800
Message-ID: <1165940296.3257.35.camel@home-desk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-JV0/7eeOSHhejDl517yg"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:47247 "EHLO iron2.pdx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbWLLQSS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Dec 2006 11:18:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-JV0/7eeOSHhejDl517yg
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Saw this over in linux-kernel last night and thought I would throw it
over here.

Sean

--=-JV0/7eeOSHhejDl517yg
Content-Disposition: inline
Content-Description: Forwarded message - AIC79XX abort -- hardware fault?
Content-Type: message/rfc822

Return-Path: 
	<linux-kernel-owner+sean.bruno=40dsl-only.net-S932070AbWLLGg4@vger.kernel.org>
Delivered-To: 16-sean.bruno@dsl-only.net
Received: (qmail 19220 invoked from network); 11 Dec 2006 22:37:25 -0800
Received: from mx2.pdx.net (HELO strontium.pdx.net) (69.64.224.82) by
	iron2.pdx.net with (AES256-SHA encrypted) SMTP; 11 Dec 2006 22:37:25 -0800
Received: from vger.kernel.org ([209.132.176.167]) by strontium.pdx.net
	with esmtp (Exim 4.50) id 1Gu1GR-0004mq-C0 for sean.bruno@dsl-only.net;
	Mon, 11 Dec 2006 22:37:26 -0800
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand id
	S932070AbWLLGg4 (ORCPT <rfc822;sean.bruno@dsl-only.net>); Tue, 12 Dec 2006
	01:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932071AbWLLGg4
	(ORCPT <rfc822;linux-kernel-outgoing>); Tue, 12 Dec 2006 01:36:56 -0500
Received: from 203-217-29-35.perm.iinet.net.au ([203.217.29.35]:34153 "EHLO
	anu.rimspace.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP id
	S932070AbWLLGgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>); Tue, 12 Dec
	2006 01:36:55 -0500
Received: by anu.rimspace.net (Postfix, from userid 10) id 64CA71920002;
	Tue, 12 Dec 2006 17:36:53 +1100 (EST)
Received: by enki.rimspace.net (Postfix, from userid 1000) id EFB3F46943C;
	Tue, 12 Dec 2006 17:36:46 +1100 (EST)
From: Daniel Pittman <daniel@rimspace.net>
To: linux-kernel@vger.kernel.org
Subject: AIC79XX abort -- hardware fault?
Date: Tue, 12 Dec 2006 17:36:46 +1100
Message-ID: <87ac1tfwn5.fsf@rimspace.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.5-b27 (fiddleheads,
	linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
X-Spam-Checker-Version: SpamAssassin 3.1.7-pdx (2006-10-05) on
	strontium.pdx.net
X-Spam-Status: No, hits=-2.6, required=7  tests=BAYES_00=-2.599,
	UPPERCASE_25_50=0  autolearn=no version=3.1.7
X-Spam-Level: --
Content-Transfer-Encoding: 7bit

G'day.  One of the machines I maintain is having real trouble with the
AIC79XX HBA or the tape drive attached to it.  I believe this is a
hardware fault, but I am not certain where the problem lies.

Normally I would blame the cable or, maybe, the tape drive, but the
early stage of the fault and the reported SCSI driver state make me
wonder if this is perhaps an HBA fault?

Regards,
        Daniel

scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320ALP Ultra320 SCSI adapter>
        aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs

 target0:0:0: asynchronous
scsi 0:0:0:0: Attempting to queue an ABORT message:CDB: 0x12 0x0 0x0 0x0 0x24 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x1b1 Mode 0x11
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0]
INTCTL[0x0] SEQINTSTAT[0x0] SAVED_MODE[0x0] DFFSTAT[0x19]
SCSISIGI[0xa4] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0xa0]
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0]
SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0]
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00]
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0]
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac]
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0]
LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 1 qinfifonext = 1
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x7]
Total 1
Kernel Free SCB list: 2 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]

scsi0: FIFO1 Active, LONGJMP == 0x8063, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x14] SHADDR = 0x06, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc]
CCSCBCTL[0x4]
scsi0: REG0 == 0x3, SINDEX = 0x1e0, DINDEX = 0xe1
scsi0: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xffed
CDB 12 0 0 0 24 0
STACK: 0x121 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi 0:0:0:0: Device is active, asserting ATN
scsi0: Recovery code sleeping
scsi0: Timer Expired (active 1)
Recovery code awake
scsi0: Command abort returning 0x2003
scsi 0:0:0:0: Attempting to queue a TARGET RESET message:CDB: 0x12 0x0 0x0 0x0 0x24 0x
0
scsi0: Device reset code sleeping
scsi0: Device reset timer expired (active 2)
scsi0: Device reset returning 0x2003
Recovery SCB completes
Recovery SCB completes
scsi 0:0:0:0: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x1b2 Mode 0x11
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0]
INTCTL[0x0] SEQINTSTAT[0x0] SAVED_MODE[0x0] DFFSTAT[0x19]
SCSISIGI[0xa4] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0xa0]
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0]
SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0]
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00]
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0]
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac]
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0]
LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 2 qinfifonext = 2
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x7]
Total 1
Kernel Free SCB list: 2 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]

scsi0: FIFO1 Active, LONGJMP == 0x8063, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x14] SHADDR = 0x06, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc]
CCSCBCTL[0x4]
scsi0: REG0 == 0x3, SINDEX = 0x1e0, DINDEX = 0xe1
scsi0: SCBPTR == 0x3, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xffed
CDB 0 0 0 0 0 0
STACK: 0x121 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi 0:0:0:0: Device is active, asserting ATN
scsi0: Recovery code sleeping
Recovery SCB completes
Recovery code awake
scsi 0:0:0:0: scsi: Device offlined - not ready after error recovery
scsi 0:0:0:0: rejecting I/O to offline device

-- 
Digital Infrastructure Solutions -- making IT simple, stable and secure
Phone: 0401 155 707        email: contact@digital-infrastructure.com.au
                 http://digital-infrastructure.com.au/
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

--=-JV0/7eeOSHhejDl517yg--

