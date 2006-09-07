From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix up SCSI netlink build
Date: Thu, 07 Sep 2006 15:14:46 -0500
Message-ID: <1157660086.3462.87.camel@mulgrave.il.steeleye.com>
References: <1157647439.3462.49.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:51889 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751387AbWIGUOr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 16:14:47 -0400
In-Reply-To: <1157647439.3462.49.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James.Smart@emulex.com

On Thu, 2006-09-07 at 11:43 -0500, James Bottomley wrote:
> The configuration change I introduced was overly optimistic.  We need to
> account for the fact that CONFIG_SCSI_NETLINK can be a module.

Someone with a large pointy stick explained that as CONFIG_NET is only
bool, that means CONFIG_SCSI_NETLINK can be as well, so this is the
revised fix.

James

Index: BUILD-2.6/drivers/scsi/Kconfig
===================================================================
--- BUILD-2.6.orig/drivers/scsi/Kconfig	2006-09-07 14:36:15.000000000 -0500
+++ BUILD-2.6/drivers/scsi/Kconfig	2006-09-07 14:36:18.000000000 -0500
@@ -28,7 +28,7 @@ config SCSI
 	  (the one containing the directory /) is located on a SCSI device.
 
 config SCSI_NETLINK
-	tristate
+	bool
 	default	n
 	select NET
 


