From: Rusty Trivial Russell <trivial@rustcorp.com.au>
Subject: [TRIVIAL] Re: Remove modules.txt drivers_scsi_aic7xxx_Kconfig.aic7xxx
Date: Thu, 11 Sep 2003 16:39:51 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030911064459.63E462C3DE@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:34237 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S266184AbTIKGo7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 02:44:59 -0400
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org
Cc: Justin Gibbs <gibbs@btc.adaptec.com>, linux-scsi@vger.kernel.org, axboe@suse.de

From:  Nicolas Kaiser <nikai@nikai.net>

  Cheers, n.

--- trivial-2.6.0-test5-bk1/drivers/scsi/aic7xxx/Kconfig.aic7xxx.orig	2003-09-11 16:25:30.000000000 +1000
+++ trivial-2.6.0-test5-bk1/drivers/scsi/aic7xxx/Kconfig.aic7xxx	2003-09-11 16:25:30.000000000 +1000
@@ -10,10 +10,8 @@
 	SCSI controllers (the 274x and 284x series).  For AAA and ARO based
 	configurations, only SCSI functionality is provided.
 
-	If you want to compile the driver as a module ( = code which can be
-	inserted in and removed from the running kernel whenever you want),
-	say M here and read <file:Documentation/modules.txt>.  The module
-	will be called aic7xxx.
+	To compile this driver as a module, say M here: the
+	module will be called aic7xxx.
 
 config AIC7XXX_CMDS_PER_DEVICE
 	int "Maximum number of TCQ commands per device"
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: Nicolas Kaiser <nikai@nikai.net>: Re: [PATCH] Remove modules.txt drivers_scsi_aic7xxx_Kconfig.aic7xxx
