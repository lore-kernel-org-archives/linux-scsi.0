From: Hans Forbrich <hforbric_linux1@telus.net>
Subject: Where do I send this bug report?
Date: Sun, 29 Feb 2004 14:48:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200402291448.12004.hforbric_linux1@telus.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound04.telus.net ([199.185.220.223]:42666 "EHLO
	priv-edtnes27.telusplanet.net") by vger.kernel.org with ESMTP
	id S262152AbUB2VsK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 16:48:10 -0500
Received: from linux.forbrichcomputing.ca ([161.184.143.77])
          by priv-edtnes27.telusplanet.net
          (InterMail vM.6.00.05.02 201-2115-109-103-20031105) with ESMTP
          id <20040229214809.HQHJ25097.priv-edtnes27.telusplanet.net@linux.forbrichcomputing.ca>
          for <linux-scsi@vger.kernel.org>; Sun, 29 Feb 2004 14:48:09 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi.  

I'm new to the mailing list, and to SCSI under Linux.  

I just added an Adaptec 29160 and a used Benchmark VS80/DLT1 (aka Quantum VS80 
& Dell PowerVault 110T) to my SuSE SLES8 machine.  On boot I get the message 
at the bottom (as well as other messages - don't want to clutter this list).  

Now I need advice where to send the bug report and what followup to consider.

TIA
/Hans

from DMESG ....

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.29
        <Adaptec 29160 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

blk: queue f7fbde14, I/O limit 4095Mb (mask 0xffffffff)
scsi0:A:3:0: DV failed to configure device.  Please file a bug report against 
this driver.
(scsi0:A:3): 20.000MB/s transfers (10.000MHz, offset 15, 16bit)
  Vendor: BNCHMARK  Model: DLT1              Rev: 391B
  Type:   Sequential-Access                  ANSI SCSI revision: 02
blk: queue f7fbda14, I/O limit 4095Mb (mask 0xffffffff)
