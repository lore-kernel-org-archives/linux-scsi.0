From: "Joe Wilhelmi" <joe@rtlogic.com>
Subject: Hang problem on Dell 1850 and 2850 using  Perc megaraid controller
Date: Mon, 6 Feb 2006 11:57:19 -0700
Message-ID: <00bc01c62b4f$2acebb40$2301a8c0@whitney>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eagle.rtlogic.com ([216.87.68.236]:62856 "EHLO rtlogic.com")
	by vger.kernel.org with ESMTP id S932185AbWBFS53 (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 13:57:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org

Friends of MegaRAID,

I have been noticing a hang problem on my 1850 and 2850 systems when
using the Perc4 controllers in a RAID 1 configuration using
LSI_COMMON_MOD_VERSION 2.20.2.6 on the linux 2.6.14 kernel.  I can
repeatedly reproduce the problem by copying about 580MB of data to the
disk from an NFS share. 

If I install my system in bios SCSI mode, which uses the LSI scsi
controller and fusion driver instead of MegaRAID, this issue goes away:
I can copy the 580MB of data without the hang.

Also, I attempted to produce the problem using a MegaRAID SCSI-320-2x
card with the same RAID 1 configuration with the same OS and version of
the driver.  The hang did not occur.

It seems that the issue is in some part of the MegaRAID driver that
deals specifically with the Perc cards in the 2850 and the 1850 and not
with the LSI MegaRAID cards.

I need to mention that the kernel has been built with MSI and ACPI
disabled because of issues with our e1000 ethernet adapter.  Because
ACPI was disabled, we also disabled hw_random.  Snare is also built in.


The following are the relevant firmware versions:
Dell 1850 Perc Controller: H418
Dell 2850 Perc Controller: H430
Lsi Ultra-320-2X:          H409

I appreciate any help or thoughts,

Regards,
Joe Wilhelmi
RTLogic


