From: jeff@AmeriCom.com
Subject: SCSI related kernel errors with 2.4
Date: 24 Feb 2003 20:47:53 -0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030224204753.13977.qmail@solo.americom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


We've been having crashes we think are related to the scsi driver, I have found other
people with the same problem by doing google searches. It happens to people burning
CD's, doing tape backups, and sometimes during normal operation. We never experienced
this problem with the 2.2 kernel. We tried updating the scsi driver to the latest
(6.2.28) and the only thing that changed is the error output is a little more
verbose. The tape drive and the hard drive are both on the same SCSI bus, let me know
and I can post full hardware specs. It seems when the machine is dead that the hard
disk is unaccessable, but I can ping the machine and do simple non-disk-accessing
tasks, its as if the scsi hard disk is offline.

Is anybody aware of this bug? Should I bare with it for a while, or downgrade to 2.2?

Feb 22 04:38:20 basement kernel: scsi0:0:4:0: Attempting to queue an ABORT message
Feb 22 04:38:20 basement kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins
<<<<<<<<<<<<<<<<<
Feb 22 04:38:20 basement kernel: scsi0: Dumping Card State in Command phase, at
SEQADDR 0x173
Feb 22 04:38:20 basement kernel: Card was paused
Feb 22 04:38:20 basement kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 = 0x0
Feb 22 04:38:20 basement kernel: HCNT = 0x0 SCBPTR = 0x1
Feb 22 04:38:20 basement kernel: SCSIPHASE[0x0] SCSISIGI[0x84]:(BSYI|CDI) ERROR[0x0]
Feb 22 04:38:20 basement kernel: SCSIBUSL[0xc0] LASTPHASE[0x80]:(CDI)
SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI)
Feb 22 04:38:20 basement kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB)
SCSIRATE[0x95]:(SINGLE_EDGE|WIDEXFER)
Feb 22 04:38:20 basement kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0]
SSTAT0[0x7]:(DMADONE|SPIORDY|SDONE)
Feb 22 04:38:20 basement kernel: SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0]
SIMODE0[0x8]:(ENSWRAP)
Feb 22 04:38:20 basement kernel: SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)
Feb 22 04:38:20 basement kernel: SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x4]:(DIRECTION)
Feb 22 04:38:20 basement kernel: DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Feb 22 04:38:20 basement kernel: STACK: 0x34 0x0 0x16b 0x180
Feb 22 04:38:20 basement kernel: SCB count = 4
Feb 22 04:38:20 basement kernel: Kernel NEXTQSCB = 1
Feb 22 04:38:20 basement kernel: Card NEXTQSCB = 1
Feb 22 04:38:20 basement kernel: QINFIFO entries:
Feb 22 04:38:20 basement kernel: Waiting Queue entries:
Feb 22 04:38:20 basement kernel: Disconnected Queue entries:
Feb 22 04:38:20 basement kernel: QOUTFIFO entries:
Feb 22 04:38:20 basement kernel: Sequencer Free SCB List: 0 2 3 4 5 6 7 8 9 10 11 12
13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Feb 22 04:38:20 basement kernel: Sequencer SCB Info:
Feb 22 04:38:20 basement kernel: 0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0xf7]:(TWIN_CHNLB|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0x0] SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 1 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x47]
SCB_LUN[0x0]
Feb 22 04:38:20 basement kernel: SCB_TAG[0x3]
Feb 22 04:38:20 basement kernel: 2 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 3 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 4 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 5 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 6 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 7 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 8 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 9 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 10 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 11 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 12 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 13 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 14 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 15 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 16 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 17 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 18 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 19 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 20 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 21 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 22 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 23 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 24 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 25 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 26 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 27 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 28 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 29 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 30 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: 31 SCB_CONTROL[0x0]
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Feb 22 04:38:20 basement kernel: SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Feb 22 04:38:20 basement kernel: Pending list:
Feb 22 04:38:20 basement kernel: 3 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x47]
SCB_LUN[0x0]
Feb 22 04:38:20 basement kernel: Kernel Free SCB list: 2 0
Feb 22 04:38:20 basement kernel: Untagged Q(4): 3
Feb 22 04:38:20 basement kernel: DevQ(0:4:0): 0 waiting
Feb 22 04:38:20 basement kernel: DevQ(0:15:0): 0 waiting
Feb 22 04:38:20 basement kernel:
Feb 22 04:38:20 basement kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends
>>>>>>>>>>>>>>>>>>
Feb 22 04:38:20 basement kernel: scsi0:0:4:0: Device is active, asserting ATN
Feb 22 04:38:20 basement kernel: Recovery code sleeping
Feb 22 04:38:25 basement kernel: Recovery code awake
Feb 22 04:38:25 basement kernel: Timer Expired
Feb 22 04:38:25 basement kernel: aic7xxx_abort returns 0x2003
Feb 22 04:38:25 basement kernel: scsi0:0:4:0: Attempting to queue a TARGET RESET message
Feb 22 04:38:25 basement kernel: aic7xxx_dev_reset returns 0x2003
Feb 22 04:38:25 basement kernel: Recovery SCB completes

Regards,

Jeffrey Moss
jeff@americom.com






