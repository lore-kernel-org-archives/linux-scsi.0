From: =?ISO-8859-2?Q?Martin_MOKREJ=A9?= <mmokrejs@ribosome.natur.cuni.cz>
Subject: scsi1:0:4:0: Attempting to queue an ABORT message
Date: Tue, 21 Jun 2005 20:16:47 +0200
Message-ID: <42B8598F.70203@ribosome.natur.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from r3az252.chello.upc.cz ([213.220.243.252]:16515 "EHLO
	aquarius.doma") by vger.kernel.org with ESMTP id S262128AbVFUSQu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 14:16:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
  I have asked on this list few weeks ago but received no answer at all. :(
Now I'm retrying again as I still have problems, at the moment with 2.4.31 kernel.
could someone explain me what is wrong? I get the messages when the machine boots
and only once I got it while running several weeks/months without reboot.
Thanks for help!
Martin

Jun 20 23:37:14 oxygen scsi1:0:4:0: Attempting to queue an ABORT message
Jun 20 23:37:14 oxygen CDB: 0x12 0x0 0x0 0x0 0x32 0x0
Jun 20 23:37:14 oxygen scsi1: At time of recovery, card was not paused
Jun 20 23:37:14 oxygen >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Jun 20 23:37:14 oxygen scsi1: Dumping Card State in Message-out phase, at SEQADDR 0x172
Jun 20 23:37:14 oxygen Card was paused
Jun 20 23:37:14 oxygen ACCUM = 0xa0, SINDEX = 0xc0, DINDEX = 0xe4, ARG_2 = 0x1
Jun 20 23:37:14 oxygen HCNT = 0x0 SCBPTR = 0x0
Jun 20 23:37:14 oxygen SCSIPHASE[0x10] SCSISIGI[0x86] ERROR[0x0] SCSIBUSL[0xc0] 
Jun 20 23:37:14 oxygen LASTPHASE[0xa0] SCSISEQ[0x12] SBLKCTL[0xa] SCSIRATE[0x93] 
Jun 20 23:37:14 oxygen SEQCTL[0x10] SEQ_FLAGS[0x40] SSTAT0[0x2] SSTAT1[0x11] 
Jun 20 23:37:14 oxygen SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
Jun 20 23:37:14 oxygen SXFRCTL0[0x88] DFCNTRL[0x0] DFSTATUS[0x89] 
Jun 20 23:37:14 oxygen STACK: 0xd9 0x0 0x16a 0x17f
Jun 20 23:37:14 oxygen SCB count = 6
Jun 20 23:37:14 oxygen Kernel NEXTQSCB = 5
Jun 20 23:37:14 oxygen Card NEXTQSCB = 5
Jun 20 23:37:14 oxygen QINFIFO entries: 
Jun 20 23:37:14 oxygen Waiting Queue entries: 
Jun 20 23:37:14 oxygen Disconnected Queue entries: 
Jun 20 23:37:14 oxygen QOUTFIFO entries: 
Jun 20 23:37:14 oxygen Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
Jun 20 23:37:14 oxygen Sequencer SCB Info: 
Jun 20 23:37:14 oxygen 0 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0x4] 
Jun 20 23:37:14 oxygen 1 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:14 oxygen Pending list: 
Jun 20 23:37:14 oxygen 4 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0] 
Jun 20 23:37:14 oxygen Kernel Free SCB list: 3 2 1 0 
Jun 20 23:37:14 oxygen Untagged Q(4): 4 
Jun 20 23:37:14 oxygen DevQ(0:4:0): 0 waiting
Jun 20 23:37:14 oxygen DevQ(0:6:0): 0 waiting
Jun 20 23:37:14 oxygen 
Jun 20 23:37:14 oxygen <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Jun 20 23:37:14 oxygen scsi1:0:4:0: Device is active, asserting ATN
Jun 20 23:37:14 oxygen Recovery code sleeping
Jun 20 23:37:14 oxygen Recovery SCB completes
Jun 20 23:37:14 oxygen Recovery code awake
Jun 20 23:37:14 oxygen aic7xxx_abort returns 0x2002
Jun 20 23:37:29 oxygen scsi1:0:6:0: Attempting to queue an ABORT message
Jun 20 23:37:29 oxygen CDB: 0x12 0x0 0x0 0x0 0x32 0x0
Jun 20 23:37:29 oxygen Infinite interrupt loop, INTSTAT = 0scsi1: At time of recovery, card was not paused
Jun 20 23:37:29 oxygen >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Jun 20 23:37:29 oxygen scsi1: Dumping Card State while idle, at SEQADDR 0x18
Jun 20 23:37:29 oxygen Card was paused
Jun 20 23:37:29 oxygen ACCUM = 0x4, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x1
Jun 20 23:37:29 oxygen HCNT = 0x0 SCBPTR = 0x0
Jun 20 23:37:29 oxygen SCSIPHASE[0x0] SCSISIGI[0x18] ERROR[0x0] SCSIBUSL[0x0] 
Jun 20 23:37:29 oxygen LASTPHASE[0x1] SCSISEQ[0x1a] SBLKCTL[0xa] SCSIRATE[0x0] 
Jun 20 23:37:29 oxygen SEQCTL[0x10] SEQ_FLAGS[0xc0] SSTAT0[0x10] SSTAT1[0x8] 
Jun 20 23:37:29 oxygen SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
Jun 20 23:37:29 oxygen SXFRCTL0[0x80] DFCNTRL[0x0] DFSTATUS[0x89] 
Jun 20 23:37:29 oxygen STACK: 0x0 0x16a 0x17f 0x17
Jun 20 23:37:29 oxygen SCB count = 6
Jun 20 23:37:29 oxygen Kernel NEXTQSCB = 3
Jun 20 23:37:29 oxygen Card NEXTQSCB = 3
Jun 20 23:37:29 oxygen QINFIFO entries: 
Jun 20 23:37:29 oxygen Waiting Queue entries: 0:4 
Jun 20 23:37:29 oxygen Disconnected Queue entries: 
Jun 20 23:37:29 oxygen QOUTFIFO entries: 
Jun 20 23:37:29 oxygen Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
Jun 20 23:37:29 oxygen Sequencer SCB Info: 
Jun 20 23:37:29 oxygen 0 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0x4] 
Jun 20 23:37:29 oxygen 1 SCB_CONTROL[0xc0] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:29 oxygen Pending list: 
Jun 20 23:37:29 oxygen 4 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] 
Jun 20 23:37:29 oxygen Kernel Free SCB list: 5 2 1 0 
Jun 20 23:37:29 oxygen Untagged Q(6): 4 
Jun 20 23:37:29 oxygen DevQ(0:4:0): 0 waiting
Jun 20 23:37:29 oxygen DevQ(0:6:0): 0 waiting
Jun 20 23:37:29 oxygen 
Jun 20 23:37:29 oxygen <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Jun 20 23:37:29 oxygen scsi1:0:6:0: Cmd aborted from QINFIFO
Jun 20 23:37:29 oxygen aic7xxx_abort returns 0x2002
Jun 20 23:37:39 oxygen scsi1:0:6:0: Attempting to queue an ABORT message
Jun 20 23:37:39 oxygen CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Jun 20 23:37:39 oxygen Infinite interrupt loop, INTSTAT = 0scsi1: At time of recovery, card was not paused
Jun 20 23:37:39 oxygen >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Jun 20 23:37:39 oxygen scsi1: Dumping Card State while idle, at SEQADDR 0x18
Jun 20 23:37:39 oxygen Card was paused
Jun 20 23:37:39 oxygen ACCUM = 0x4, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x1
Jun 20 23:37:39 oxygen HCNT = 0x0 SCBPTR = 0x0
Jun 20 23:37:39 oxygen SCSIPHASE[0x0] SCSISIGI[0x18] ERROR[0x0] SCSIBUSL[0x0] 
Jun 20 23:37:39 oxygen LASTPHASE[0x1] SCSISEQ[0x1a] SBLKCTL[0xa] SCSIRATE[0x0] 
Jun 20 23:37:39 oxygen SEQCTL[0x10] SEQ_FLAGS[0xc0] SSTAT0[0x10] SSTAT1[0x8] 
Jun 20 23:37:39 oxygen SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
Jun 20 23:37:39 oxygen SXFRCTL0[0x80] DFCNTRL[0x0] DFSTATUS[0x89] 
Jun 20 23:37:39 oxygen STACK: 0x0 0x16a 0x17f 0x17
Jun 20 23:37:39 oxygen SCB count = 6
Jun 20 23:37:39 oxygen Kernel NEXTQSCB = 4
Jun 20 23:37:39 oxygen Card NEXTQSCB = 3
Jun 20 23:37:39 oxygen QINFIFO entries: 3 
Jun 20 23:37:39 oxygen Waiting Queue entries: 
Jun 20 23:37:39 oxygen Disconnected Queue entries: 
Jun 20 23:37:39 oxygen QOUTFIFO entries: 
Jun 20 23:37:39 oxygen Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
Jun 20 23:37:39 oxygen Sequencer SCB Info: 
Jun 20 23:37:39 oxygen 0 SCB_CONTROL[0x0] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 1 SCB_CONTROL[0xc0] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:39 oxygen Pending list: 
Jun 20 23:37:39 oxygen 3 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] 
Jun 20 23:37:39 oxygen Kernel Free SCB list: 5 2 1 0 
Jun 20 23:37:39 oxygen Untagged Q(6): 3 
Jun 20 23:37:39 oxygen DevQ(0:4:0): 0 waiting
Jun 20 23:37:39 oxygen DevQ(0:6:0): 0 waiting
Jun 20 23:37:39 oxygen 
Jun 20 23:37:39 oxygen <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Jun 20 23:37:39 oxygen scsi1:0:6:0: Cmd aborted from QINFIFO
Jun 20 23:37:39 oxygen aic7xxx_abort returns 0x2002
Jun 20 23:37:39 oxygen scsi1:0:6:0: Attempting to queue a TARGET RESET message
Jun 20 23:37:39 oxygen CDB: 0x12 0x0 0x0 0x0 0x32 0x0
Jun 20 23:37:39 oxygen scsi1:0:6:0: Command not found
Jun 20 23:37:39 oxygen aic7xxx_dev_reset returns 0x2002
Jun 20 23:37:49 oxygen scsi1:0:6:0: Attempting to queue an ABORT message
Jun 20 23:37:49 oxygen CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Jun 20 23:37:49 oxygen Infinite interrupt loop, INTSTAT = 0scsi1: At time of recovery, card was not paused
Jun 20 23:37:49 oxygen >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Jun 20 23:37:49 oxygen scsi1: Dumping Card State while idle, at SEQADDR 0x18
Jun 20 23:37:49 oxygen Card was paused
Jun 20 23:37:49 oxygen ACCUM = 0x4, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x1
Jun 20 23:37:49 oxygen HCNT = 0x0 SCBPTR = 0x0
Jun 20 23:37:49 oxygen SCSIPHASE[0x0] SCSISIGI[0x18] ERROR[0x0] SCSIBUSL[0x0] 
Jun 20 23:37:49 oxygen LASTPHASE[0x1] SCSISEQ[0x1a] SBLKCTL[0xa] SCSIRATE[0x0] 
Jun 20 23:37:49 oxygen SEQCTL[0x10] SEQ_FLAGS[0xc0] SSTAT0[0x10] SSTAT1[0x8] 
Jun 20 23:37:49 oxygen SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
Jun 20 23:37:49 oxygen SXFRCTL0[0x80] DFCNTRL[0x0] DFSTATUS[0x89] 
Jun 20 23:37:49 oxygen STACK: 0x0 0x16a 0x17f 0x17
Jun 20 23:37:49 oxygen SCB count = 6
Jun 20 23:37:49 oxygen Kernel NEXTQSCB = 3
Jun 20 23:37:49 oxygen Card NEXTQSCB = 4
Jun 20 23:37:49 oxygen QINFIFO entries: 4 
Jun 20 23:37:49 oxygen Waiting Queue entries: 
Jun 20 23:37:49 oxygen Disconnected Queue entries: 
Jun 20 23:37:49 oxygen QOUTFIFO entries: 
Jun 20 23:37:49 oxygen Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 2
9 30 31 
Jun 20 23:37:49 oxygen Sequencer SCB Info: 
Jun 20 23:37:49 oxygen 0 SCB_CONTROL[0x0] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 1 SCB_CONTROL[0xc0] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Jun 20 23:37:49 oxygen Pending list: 
Jun 20 23:37:49 oxygen 4 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] 
Jun 20 23:37:49 oxygen Kernel Free SCB list: 5 2 1 0 
Jun 20 23:37:49 oxygen Untagged Q(6): 4 
Jun 20 23:37:49 oxygen DevQ(0:4:0): 0 waiting
Jun 20 23:37:49 oxygen DevQ(0:6:0): 0 waiting
Jun 20 23:37:49 oxygen 
Jun 20 23:37:49 oxygen <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Jun 20 23:37:49 oxygen scsi1:0:6:0: Cmd aborted from QINFIFO
Jun 20 23:37:49 oxygen aic7xxx_abort returns 0x2002



Jun 20 23:34:47 oxygen Uniform Multi-Platform E-IDE driver Revision: 7.00beta4-2.4
Jun 20 23:34:47 oxygen ide: Assuming 66MHz system bus speed for PIO modes
Jun 20 23:34:47 oxygen ICH3: IDE controller at PCI slot 00:1f.1
Jun 20 23:34:47 oxygen PCI: Enabling device 00:1f.1 (0005 -> 0007)
Jun 20 23:34:47 oxygen ICH3: chipset revision 2
Jun 20 23:34:47 oxygen ICH3: not 100% native mode: will probe irqs later
Jun 20 23:34:47 oxygen ide0: BM-DMA at 0x03a0-0x03a7, BIOS settings: hda:pio, hdb:pio
Jun 20 23:34:47 oxygen ide1: BM-DMA at 0x03a8-0x03af, BIOS settings: hdc:DMA, hdd:pio
Jun 20 23:34:47 oxygen hdc: MATSHITADVD-ROM SR-8177, ATAPI CD/DVD-ROM drive
Jun 20 23:34:47 oxygen ide1 at 0x170-0x177,0x376 on irq 15
Jun 20 23:34:47 oxygen hdc: attached ide-cdrom driver.
Jun 20 23:34:47 oxygen hdc: ATAPI 24X DVD-ROM drive, 256kB Cache
Jun 20 23:34:47 oxygen Uniform CD-ROM driver Revision: 3.12
Jun 20 23:34:47 oxygen SCSI subsystem driver Revision: 1.00
Jun 20 23:34:47 oxygen GDT-HA: Storage RAID Controller Driver. Version: 3.04 
Jun 20 23:34:47 oxygen GDT-HA: Found 1 PCI Storage RAID Controllers
Jun 20 23:34:47 oxygen Configuring GDT-PCI HA at 4/8 IRQ 48
Jun 20 23:34:47 oxygen GDT-HA 0: Vendor: Intel Corporation                    Name: SRCZCR
Jun 20 23:34:47 oxygen scsi0 : SRCZCR
Jun 20 23:34:47 oxygen blk: queue f7798e18, I/O limit 4095Mb (mask 0xffffffff)
Jun 20 23:34:47 oxygen Vendor: Intel     Model: Host Drive  #00   Rev:     
Jun 20 23:34:47 oxygen Type:   Direct-Access                      ANSI SCSI revision: 02
Jun 20 23:34:47 oxygen blk: queue f7798c18, I/O limit 4095Mb (mask 0xffffffff)
Jun 20 23:34:47 oxygen Vendor: ESG-SHV   Model: SCA HSBP M16      Rev: 0.05
Jun 20 23:34:47 oxygen Type:   Processor                          ANSI SCSI revision: 02
Jun 20 23:34:47 oxygen blk: queue f7798a18, I/O limit 4095Mb (mask 0xffffffff)
Jun 20 23:34:47 oxygen Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Jun 20 23:34:47 oxygen SCSI device sda: 71601705 512-byte hdwr sectors (36660 MB)
Jun 20 23:34:47 oxygen Partition check:
Jun 20 23:34:47 oxygen /dev/scsi/host0/bus0/target0/lun0: p1 p2
[cut]
Jun 20 23:34:47 oxygen Setting Global Tags= 32
Jun 20 23:34:47 oxygen scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
Jun 20 23:34:47 oxygen <Adaptec 29160 Ultra160 SCSI adapter>
Jun 20 23:34:47 oxygen aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Jun 20 23:34:47 oxygen 
Jun 20 23:34:47 oxygen scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
Jun 20 23:34:47 oxygen <Adaptec 29160B Ultra160 SCSI adapter>
Jun 20 23:34:47 oxygen aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Jun 20 23:34:47 oxygen 
Jun 20 23:34:47 oxygen blk: queue f72bec18, I/O limit 524287Mb (mask 0x7fffffffff)
Jun 20 23:34:47 oxygen (scsi2:A:0): 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
Jun 20 23:34:47 oxygen (scsi1:A:4): 80.000MB/s transfers (40.000MHz, offset 62, 16bit)
Jun 20 23:34:47 oxygen (scsi1:A:6): 20.000MB/s transfers (10.000MHz, offset 15, 16bit)
Jun 20 23:34:47 oxygen Vendor: QUANTUM   Model: SuperDLT1         Rev: 4646
Jun 20 23:34:47 oxygen Type:   Sequential-Access                  ANSI SCSI revision: 02
Jun 20 23:34:47 oxygen blk: queue f72bea18, I/O limit 524287Mb (mask 0x7fffffffff)
Jun 20 23:34:47 oxygen Vendor: OVERLAND  Model: LXB               Rev: 0106
Jun 20 23:34:47 oxygen Type:   Medium Changer                     ANSI SCSI revision: 02
Jun 20 23:34:47 oxygen blk: queue f72be018, I/O limit 524287Mb (mask 0x7fffffffff)
Jun 20 23:34:47 oxygen Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
Jun 20 23:34:47 oxygen Type:   Direct-Access                      ANSI SCSI revision: 04
Jun 20 23:34:47 oxygen blk: queue f7024a18, I/O limit 524287Mb (mask 0x7fffffffff)
Jun 20 23:34:47 oxygen Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
Jun 20 23:34:47 oxygen Type:   Direct-Access                      ANSI SCSI revision: 04
Jun 20 23:34:47 oxygen blk: queue f7024618, I/O limit 524287Mb (mask 0x7fffffffff)
Jun 20 23:34:47 oxygen Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
Jun 20 23:34:47 oxygen Type:   Direct-Access                      ANSI SCSI revision: 04
Jun 20 23:34:47 oxygen blk: queue f700a618, I/O limit 524287Mb (mask 0x7fffffffff)
Jun 20 23:34:47 oxygen Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
Jun 20 23:34:47 oxygen Type:   Direct-Access                      ANSI SCSI revision: 04
Jun 20 23:34:47 oxygen blk: queue f700a418, I/O limit 524287Mb (mask 0x7fffffffff)
Jun 20 23:34:47 oxygen scsi2:A:0:0: Tagged Queuing enabled.  Depth 32
Jun 20 23:34:47 oxygen scsi2:A:0:1: Tagged Queuing enabled.  Depth 32
Jun 20 23:34:47 oxygen scsi2:A:0:2: Tagged Queuing enabled.  Depth 32
Jun 20 23:34:47 oxygen scsi2:A:0:3: Tagged Queuing enabled.  Depth 32
Jun 20 23:34:47 oxygen st: Version 20040102, bufsize 32768, max init. bufs 4, s/g segs 16
Jun 20 23:34:47 oxygen Attached scsi tape st0 at scsi1, channel 0, id 4, lun 0
Jun 20 23:34:47 oxygen Attached scsi disk sdb at scsi2, channel 0, id 0, lun 0
Jun 20 23:34:47 oxygen Attached scsi disk sdc at scsi2, channel 0, id 0, lun 1
Jun 20 23:34:47 oxygen Attached scsi disk sdd at scsi2, channel 0, id 0, lun 2
Jun 20 23:34:47 oxygen Attached scsi disk sde at scsi2, channel 0, id 0, lun 3
Jun 20 23:34:47 oxygen SCSI device sdb: 245760000 512-byte hdwr sectors (125829 MB)
Jun 20 23:34:47 oxygen /dev/scsi/host2/bus0/target0/lun0: p1
Jun 20 23:34:47 oxygen SCSI device sdc: 40989184 512-byte hdwr sectors (20986 MB)
Jun 20 23:34:47 oxygen /dev/scsi/host2/bus0/target0/lun1: p1
Jun 20 23:34:47 oxygen SCSI device sdd: 1638400000 512-byte hdwr sectors (838861 MB)
Jun 20 23:34:47 oxygen /dev/scsi/host2/bus0/target0/lun2: p1
Jun 20 23:34:47 oxygen SCSI device sde: 651395072 512-byte hdwr sectors (333514 MB)
Jun 20 23:34:47 oxygen /dev/scsi/host2/bus0/target0/lun3: p1

# lspci
0000:00:00.0 Host bridge: Intel Corporation E7501 Memory Controller Hub (rev 01)z
0000:00:00.1 Class ff00: Intel Corporation E7500/E7501 Host RASUM Controller (rev 01)
0000:00:03.0 PCI bridge: Intel Corporation E7500/E7501 Hub Interface C PCI-to-PCI Bridge (rev 01)
0000:00:03.1 Class ff00: Intel Corporation E7500/E7501 Hub Interface C RASUM Controller (rev 01)
0000:00:1d.0 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #1) (rev 02)
0000:00:1d.1 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #2) (rev 02)
0000:00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 42)
0000:00:1f.0 ISA bridge: Intel Corporation 82801CA LPC Interface Controller (rev 02)
0000:00:1f.1 IDE interface: Intel Corporation 82801CA Ultra ATA Storage Controller (rev 02)
0000:00:1f.3 SMBus: Intel Corporation 82801CA/CAM SMBus Controller (rev 02)
0000:01:0c.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
0000:02:1c.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04)
0000:02:1d.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 04)
0000:02:1e.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04)
0000:02:1f.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 04)
0000:03:07.0 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev 01)
0000:03:07.1 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev 01)
0000:03:08.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
0000:04:08.0 RAID bus controller: Intel Corporation RAID Controller
0000:04:09.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
#

The machine is dual-Xeon server with 6 GB RAM running linux-2.4.31.
