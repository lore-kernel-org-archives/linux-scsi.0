From: Matthew Schumacher <matt.s@aptalaska.net>
Subject: Megaraid module won't detect logical disks on a CERC ATA100/4ch
Date: Mon, 23 Jan 2006 11:27:56 -0900
Message-ID: <43D53C4C.2090002@aptalaska.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from larry.aptalaska.net ([64.186.96.3]:57741 "EHLO
	larry.aptalaska.net") by vger.kernel.org with ESMTP id S932472AbWAWU2D
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2006 15:28:03 -0500
Received: from [192.168.98.9] (rdbck-static-287.palmer.mtaonline.net [64.4.232.33])
	(authenticated bits=0)
	by larry.aptalaska.net (8.13.5/8.13.5) with ESMTP id k0NKRuZq002253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2006 11:27:57 -0900
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have had this problem for a while and it's still unresolved.

Linux fails to detect logical disks on any kernel past 2.4.27 which uses
the following driver:

Statistical Information for this controller
pend_cmds = 0
IO and error counters not compiled in driver.
root@jerry:/var/log# cat /proc/megaraid/hba0/config
v2.10.3 (Release Date: Thu Apr  8 16:16:05 EDT 2004)
CERC ATA100/4ch
Controller Type: 438/466/467/471/493/518/520/531/532
Controller Supports 40 Logical Drives
Controller capable of 64-bit memory addressing
Controller is not using 64-bit memory addressing
Base = f89c3000, Irq = 17, Initial Logical Drives = 1, Channels = 4
Version =6.62:1.03, DRAM = 16Mb
Controller Queue Depth = 254, Driver Queue Depth = 126
support_ext_cdb    = 1
support_random_del = 1
boot_ldrv_enabled  = 1
boot_ldrv          = 0
boot_pdrv_enabled  = 0
boot_pdrv_ch       = 0
boot_pdrv_tgt      = 0
quiescent          = 0
has_cluster        = 0

Module Parameters:
max_cmd_per_lun    = 63
max_sectors_per_io = 128

Every 2.4 kernel past 2.4.27 and every 2.6 kernel I have tried detect
the card, but not the disks.

Is this a known problem?  Any way around it?

schu
