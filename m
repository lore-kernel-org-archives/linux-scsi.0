From: "J.C. Wren" <jcwren@jcwren.com>
Subject: re-onlining an offlined device
Date: Wed, 17 Mar 2004 21:07:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40590446.20409@jcwren.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imf18aec.mail.bellsouth.net ([205.152.59.66]:46490 "EHLO
	imf18aec.mail.bellsouth.net") by vger.kernel.org with ESMTP
	id S262311AbUCRCHD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 21:07:03 -0500
Received: from jcwren.com ([65.3.6.99]) by imf18aec.mail.bellsouth.net
          (InterMail vM.5.01.06.08 201-253-122-130-108-20031117) with ESMTP
          id <20040318020702.PSGY10536.imf18aec.mail.bellsouth.net@jcwren.com>
          for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2004 21:07:02 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

   I have an audio CD that I was ripping that confused cdparanoia/grip, 
resulting in a kernel message that the SCSI CD-ROM had been offlined.  
Is there any way to re-online the CD-ROM without rebooting? Most 
everything is compiled into the kernel, so unloading SCSI modules and 
reloading (if that'd solve the problem) currently is an option.  I spent 
a good while Googling, and came up with a supposed fix in 2.5.x (I'm 
running 2.6.3, with an Adaptec AHA-2940U/UW/D / AIC-7881U), but I see no 
user-land utilties for resetting the SCSI bus or a specific device.

    I'm subscribed to the linux-kernel list, but not linux-scsi, so 
please reply directly, if possible.

   --jc

scsi0:0:4:0: Attempting to queue an ABORT message
CDB: 0xd8 0x0 0x0 0x0 0x11 0x52 0x0 0x0 0x0 0xd 0x0 0x0
scsi0: At time of recovery, card was not paused
 >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State while idle, at SEQADDR 0x7
Card was paused
ACCUM = 0xfa, SINDEX = 0x47, DINDEX = 0x25, ARG_2 = 0xff
HCNT = 0x70 SCBPTR = 0x0
SCSISIGI[0x0] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0x1]:(P_BUSFREE)
SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) SBLKCTL[0x2]:(SELWIDE)
SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE) 
SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED)
SSTAT0[0x0] SSTAT1[0xa]:(PHASECHG|BUSFREE) SSTAT2[0x0]
SSTAT3[0x0] SIMODE0[0x0] SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
SXFRCTL0[0x80]:(DFON) DFCNTRL[0x0] DFSTATUS[0x21]:(FIFOEMP|FIFOQWDEMP)
STACK: 0x0 0x169 0x199 0x3
SCB count = 4
Kernel NEXTQSCB = 3
Card NEXTQSCB = 3
QINFIFO entries:
Waiting Queue entries:
Disconnected Queue entries: 0:2
QOUTFIFO entries:
Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
Sequencer SCB Info:
  0 SCB_CONTROL[0x44]:(DISCONNECTED|DISCENB) SCB_SCSIID[0x47]
SCB_LUN[0x0] SCB_TAG[0x2]
  1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
  2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
  3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
  4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
  5 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
  6 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
  7 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Pending list:
  2 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x47] SCB_LUN[0x0]
Kernel Free SCB list: 1 0
Untagged Q(4): 2
DevQ(0:4:0): 0 waiting
DevQ(0:5:0): 0 waiting
DevQ(0:6:0): 0 waiting

<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
(scsi0:A:4:0): Device is disconnected, re-queuing SCB
Recovery code sleeping
(scsi0:A:4:0): Abort Message Sent
Recovery code awake
Timer Expired
aic7xxx_abort returns 0x2003
scsi0:0:4:0: Attempting to queue a TARGET RESET message
CDB: 0xd8 0x0 0x0 0x0 0x11 0x52 0x0 0x0 0x0 0xd 0x0 0x0
aic7xxx_dev_reset returns 0x2003
Recovery SCB completes
scsi: Device offlined - not ready after error recovery: host 0 channel 0 
id 4 lun 0

