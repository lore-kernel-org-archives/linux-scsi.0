From: "Ross Macintyre" <raz@macs.hw.ac.uk>
Subject: interpreting scsi errors (RAID)
Date: Mon, 9 Feb 2004 10:57:53 -0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2198.137.195.14.4.1076324273.squirrel@www.macs.hw.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from izanami.macs.hw.ac.uk ([137.195.13.6]:21963 "EHLO
	izanami.macs.hw.ac.uk") by vger.kernel.org with ESMTP
	id S264605AbUBIK5z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 05:57:55 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ian@eclipsecomputing.co.uk, cos@vger.kernel.org

I have seen this error twice now:

Adapter 1 Channel 1 Target 2: Sense Data: errCode=0x71  valBit=1 
segMent=0x00  SenseKey=4  ILI=0  EOM=0  FMRK=0  Address=0x00005A8E 
ASL=0xA  cmdSpec=0x0000  ASC=0x0C  ASCQ=0x00 FRUC Code + Sense Key
Specific=0x8001

I have an LSILogic Megaraid SCSI 320-1, running RAID level5, 4 disks, and
the OS is RedHat8.0.

What I would like, is to be able to understand these messages.
In particular I need to know if there is a hardware error which means that
I can contact the retailer, in confidence, and ask for a replacement, as
the disk is still under warranty.
Any pointers at FAQs or READMEs greatly appreciated,
Thanks in advance,

Ross

-- 
Ross Macintyre (raz@macs.hw.ac.uk)
