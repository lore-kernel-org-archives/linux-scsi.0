From: AlphaGJohn <jc-mailinglist@alphagconsulting.com>
Subject: LSI SAS 1068e RAID driver for Debian won't load
Date: Wed, 30 Apr 2008 14:39:42 -0700 (PDT)
Message-ID: <16992119.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:51752 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbYD3Vjn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2008 17:39:43 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1JrK1e-0002Lu-No
	for linux-scsi@vger.kernel.org; Wed, 30 Apr 2008 14:39:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi Folks,

Any suggestions on this one?

2.6.18-6-amd64 #1 SMP Sun Feb 10 17:50:19 UTC 2008 x86_64 GNU/Linux

Running on a Supermicro *H8DM3-2 motherboard (with on-board *LSI SAS1068E
Controller)

lspci reports the controller as:
02:00.0 SCSI storage controller: LSI Logic / Symbios Logic Unknown device
0059 (rev 04)

LSI provides a source tar ball (good for them!) and although the driver
source apparently compiled successfully, it would not load.

/var/log/kern.log says:
mptbase: no version for "struct_module" found: kernel tainted.
Fusion MPT base driver 4.00.21.00
Copyright (c) 1999-2007 LSI Corporation
mptsas: Unknown symbol scsi_is_sas_phy_local
mptsas: Unknown symbol scsi_is_sas_phy_local
Fusion MPT SPI Host driver 4.00.21.00
Fusion MPT misc device (ioctl) driver 4.00.21.00
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
mptsas: Unknown symbol scsi_is_sas_phy_local
mptctl: Deregistered /dev/mptctl @ (major,minor=10,220)

Any suggestions most appreciated.

(A side note: The mptsas driver supplied with the etch release loads fine,
but, apparently doesn't support the controller:
modinfo mptsas
suggests it does not support the model 0059. It lists 0050, 0054, 0056,
0058, & 0062. 
I have limited experience with this kind of thing, so I don't know what the
different "names" for the controller signifies--if anything.)

Thanks!

John

-- 
View this message in context: http://www.nabble.com/LSI-SAS-1068e-RAID-driver-for-Debian-won%27t-load-tp16992119p16992119.html
Sent from the linux-scsi mailing list archive at Nabble.com.

