From: Ming Zhang <mingz@ele.uri.edu>
Subject: aic7xxx problem
Date: Fri, 06 Feb 2004 16:01:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076101318.2492.38.camel@dyn251.ele.uri.edu>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:16034 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S265604AbUBFVB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 16:01:56 -0500
Received: from localhost.localdomain (leviathan [131.128.51.64])
	by leviathan.ele.uri.edu (8.12.9/8.12.9) with ESMTP id i16L1rPf021397
	for <linux-scsi@vger.kernel.org>; Fri, 6 Feb 2004 16:01:53 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi, folks


I want to use the adaptec 39160 controller on my xscale board with new
linux 2.6.0 kernel, but no luck.

with new aic7xxx driver, it keeps printing for every operation on it.

Current sda: sense key No Sense
end_request: I/O error, dev sda, sector 110
Buffer I/O error on device sda, logical block 55
SCSI error : <0 0 1 0> return code = 0x8000002
Current sda: sense key No Sense
end_request: I/O error, dev sda, sector 112
Buffer I/O error on device sda, logical block 56
SCSI error : <0 0 1 0> return code = 0x8000002
Current sda: sense key No Sense
end_request: I/O error, dev sda, sector 114
Buffer I/O error on device sda, logical block 57
SCSI error : <0 0 1 0> return code = 0x8000002
Current sda: sense key No Sense
end_request: I/O error, dev sda, sector 116
Buffer I/O error on device sda, logical block 58
SCSI error : <0 0 1 0> return code = 0x8000002
Current sda: sense key No Sense
end_request: I/O error, dev sda, sector 118
Buffer I/O error on device sda, logical block 59
SCSI error : <0 0 1 0> return code = 0x8000002


with old deriver, it hangs when system boots after printing

scsi0) <Adaptec AIC-7899 Ultra 160/m SCSI host adapter> found at PCI
0/6/0
(scsi0) Wide Channel A, SCSI ID=5, 32/255 SCBs
(scsi0) Downloading sequencer code... 396 instructions downloaded
(scsi1) <Adaptec AIC-7899 Ultra 160/m SCSI host adapter> found at PCI
0/6/1
(scsi1) Wide Channel B, SCSI ID=5, 32/255 SCBs
(scsi1) Downloading sequencer code... 396 instructions downloaded
scsi0 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.6/5.2.0
       <Adaptec AIC-7899 Ultra 160/m SCSI host adapter>
Using anticipatory io scheduler
  Vendor: <4>(scsi0:-1:-1:-1) CMDCMPLT without command for SCB 0, SCB
flags 0x0,
 cmd 0x0
          Model:                   Rev:
  Type:   Direct-Access                      ANSI SCSI revision: 00
scsi1 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.6/5.2.0
       <Adaptec AIC-7899 Ultra 160/m SCSI host adapter>
(scsi1:0:0:-1) Unexpected busfree, LASTPHASE = 0x1, SEQADDR = 0x9
(scsi1:-1:-1:-1) aic7xxx_isr - referenced scb not valid during scsiint
0x7 scb(2
55)
      SIMODE0 0x0, SIMODE1 0xa4, SSTAT0 0x10, SEQADDR 0x3
(scsi1:0:0:-1) Unexpected busfree, LASTPHASE = 0x1, SEQADDR = 0x8
(scsi1:-1:-1:-1) aic7xxx_isr - referenced scb not valid during scsiint
0x7 scb(0
)
      SIMODE0 0x0, SIMODE1 0xa4, SSTAT0 0x10, SEQADDR 0x3


can anybody give me a clue? thx a lot.

Ming


