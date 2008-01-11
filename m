From: Linda Walsh <lkml@tlinx.org>
Subject: SCSI error: quetion on interpretation/meaning
Date: Thu, 10 Jan 2008 19:57:22 -0800
Message-ID: <4786E922.6040209@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([64.81.245.74]:58065 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbYAKD5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 22:57:22 -0500
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by ishtar.tlinx.org (8.13.3/8.12.10/SuSE Linux 0.7) with ESMTP id m0B3vMAj005205
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 19:57:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Got a weird error message (kernel dmesg output below).  Is it likely 
this type of error could be caused by a loose cable or connector?
Or is there something else at play here?
The card is a "Adaptec AHA-2940U2/U2W / 7890/7891" (talking to
the 1 SCSI disk, sda).

Earlier today, one of the scsi-based partitions went "offline" (these 
things seem to come in spurts)...

Thanks,
Linda


(kernel version=2.6.23.1-SMP)

scsi0: Unexpected busfree in Message-in phase
SEQADDR == 0x14a
sd 0:0:0:0: [sda] Attempting to queue an ABORT message
CDB: 0x2a 0x0 0x0 0xa 0x4b 0xea 0x0 0x0 0x10 0x0
scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State while idle, at SEQADDR 0x8
Card was paused
ACCUM = 0x0, SINDEX = 0x11, DINDEX = 0xe4, ARG_2 = 0x0
HCNT = 0x0 SCBPTR = 0x19
SCSISIGI[0x0] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0x1]:(P_BUSFREE)
SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) SBLKCTL[0xa]:(SELWIDE|SELBUSB)
SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE) 
SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED)
SSTAT0[0x0] SSTAT1[0xa]:(PHASECHG|BUSFREE) SSTAT2[0x0]
SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP) 
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
SXFRCTL0[0x80]:(DFON) DFCNTRL[0x0] 
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
STACK: 0x132 0x167 0x10d 0x3
SCB count = 28
Kernel NEXTQSCB = 26
Card NEXTQSCB = 26
QINFIFO entries:
Waiting Queue entries:
Disconnected Queue entries: 21:16
QOUTFIFO entries:
Sequencer Free SCB List: 25 17 24 22 18 19 23 15 20 3 13 6 1 14 11 9 16 
4 12 5 7 10 8 0 2 26 27 28
 29 30 31
Sequencer SCB Info:
  0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
  1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
  2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
  3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
  4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
  5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
  6 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
  7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
  8 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
  9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 10 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 11 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 13 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 14 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 15 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 16 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 17 SCB_CONTROL[0x80]:(TARGET_SCB) SCB_SCSIID[0x7] SCB_LUN[0x0]
SCB_TAG[0xff]
 18 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 19 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 20 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 21 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x10]
 22 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 23 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xff]
 24 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
 25 SCB_CONTROL[0x80]:(TARGET_SCB) SCB_SCSIID[0x7] SCB_LUN[0x0]
SCB_TAG[0xff]
 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Pending list:
 16 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7]
SCB_LUN[0x0]
Kernel Free SCB list: 17 25 21 20 11 23 27 18 19 22 7 14 10 15 13 9 12 2 
1 5 8 6 4 0 3 24

<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
(scsi0:A:0:0): Device is disconnected, re-queuing SCB
Recovery code sleeping
(scsi0:A:0:0): Abort Tag Message Sent
(scsi0:A:0:0): SCB 16 - Abort Tag Completed.
Recovery SCB completes
Recovery code awake
aic7xxx_abort returns 0x2002
