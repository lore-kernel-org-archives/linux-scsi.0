From: jassduec@gmail.com
Subject: Problem with Adaptec 39320A Ultra320 SCSI adapter driver
Date: Thu, 10 Aug 2006 13:01:16 -0500
Message-ID: <3a1eedb70608101101g16527d76ka1d088930a39f365@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:60307 "EHLO
	wr-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1422671AbWHJSBS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 14:01:18 -0400
Received: by wr-out-0506.google.com with SMTP id 68so97011wra
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 11:01:17 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

I am running CentOS 4.3 with linux kernel 2.6.9-34.0.2.ELsmp. I am
using Adaptec 39320A Ultra320 SCSI adapter for connecting to 840 SATA
RAID Array from gateway. When the system boots, i am getting the
following errors. Though the kernel is able to identify the LUNs from
the array, i was wondering what is the cause of the error message. Any
reply in this regard would be highly appreciated.

Thanks in advance

########################Error Message########################


scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
        <Adaptec 39320A Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 50-66Mhz, 512 SCBs

(scsi2:A:4:0): Unexpected busfree in Message-out phase, 1 SCBs
aborted, PRGMCNT == 0x19a
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi2: Dumping Card State at program address 0x198 Mode 0x33
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
DFFSTAT[0x33] SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0]
LASTPHASE[0xa0] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0]
SEQINTCTL[0x0] SEQ_FLAGS[0x40] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x8] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]
SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 12 qinfifonext = 12
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
Total 0
Kernel Free SCB list: 3 2 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:

scsi2: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
scsi2: FIFO1 Free, LONGJMP == 0x8063, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi2: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi2: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]
CCSCBCTL[0x4]
scsi2: REG0 == 0x3, SINDEX = 0x107, DINDEX = 0xe1
scsi2: SCBPTR == 0x3, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff3b
CDB 3b a 0 0 0 0
STACK: 0x10c 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:4:0): 0 waiting
scsi2: Transmission error detected
LQISTAT1[0x0] LASTPHASE[0xe0] SCSISIGI[0x60] PERRDIAG[0xd1]
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi2: Dumping Card State at program address 0x198 Mode 0x11
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
DFFSTAT[0x19] SCSISIGI[0x74] SCSIPHASE[0x2] SCSIBUS[0x0]
LASTPHASE[0xe0] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0]
SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2]
SSTAT1[0x19] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 27 qinfifonext = 27
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x47]
Total 1
Kernel Free SCB list: 2 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:

scsi2: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
scsi2: FIFO1 Active, LONGJMP == 0x8063, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x88]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x4] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi2: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi2: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]
CCSCBCTL[0x4]
scsi2: REG0 == 0x3, SINDEX = 0x1ba, DINDEX = 0x1ba
scsi2: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xff3b
CDB 12 0 0 0 24 0
STACK: 0xc9 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:4:0): 0 waiting
scsi2:0:4:0: Attempting to abort cmd f7dadc80: 0x12 0x0 0x0 0x0 0x24 0x0
scsi2: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi2: Dumping Card State at program address 0x26 Mode 0x22
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
DFFSTAT[0x19] SCSISIGI[0x74] SCSIPHASE[0x2] SCSIBUS[0x0]
LASTPHASE[0x60] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0]
SEQINTCTL[0x0] SEQ_FLAGS[0x20] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x9] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 27 qinfifonext = 27
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x47]
Total 1
Kernel Free SCB list: 2 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:

scsi2: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
scsi2: FIFO1 Active, LONGJMP == 0x8063, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x80]
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0xc] SHADDR = 0x03bee80, SHCNT = 0x24
HADDR = 0x03bee80, HCNT = 0x24 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi2: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi2: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]
CCSCBCTL[0x4]
scsi2: REG0 == 0x3, SINDEX = 0x1ba, DINDEX = 0x1ba
scsi2: SCBPTR == 0xff03, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
CDB 3 1 0 0 0 0
STACK: 0x1f2 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:4:0): 0 waiting
scsi2:0:4:0: Device is active, asserting ATN
Recovery code sleeping
Recovery code awake
Timer Expired
Recovery code sleeping
Recovery code awake
Timer Expired
scsi2: Device reset returning 0x2003
Recovery SCB completes
Recovery SCB completes
  Vendor: Gateway   Model: 840 SATA RAID     Rev:
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi2:A:4:0: Tagged Queuing enabled.  Depth 4
SCSI device sdc: 1940115456 512-byte hdwr sectors (993339 MB)
SCSI device sdc: drive cache: write back
SCSI device sdc: 1940115456 512-byte hdwr sectors (993339 MB)
SCSI device sdc: drive cache: write back
 sdc: sdc1
Attached scsi disk sdc at scsi2, channel 0, id 4, lun 0
  Vendor: Gateway   Model: 840 SATA RAID     Rev:
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi2:A:4:1: Tagged Queuing enabled.  Depth 4
SCSI device sdd: 2424655872 512-byte hdwr sectors (1241424 MB)
SCSI device sdd: drive cache: write back
SCSI device sdd: 2424655872 512-byte hdwr sectors (1241424 MB)
SCSI device sdd: drive cache: write back
 sdd: sdd1
Attached scsi disk sdd at scsi2, channel 0, id 4, lun 1
  Vendor: Gateway   Model: 840 SATA RAID     Rev:
  Type:   Processor                          ANSI SCSI revision: 03
scsi2:A:4:2: Tagged Queuing enabled.  Depth 4
scsi3 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
        <Adaptec 39320A Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 50-66Mhz, 512 SCBs


########################################################################
