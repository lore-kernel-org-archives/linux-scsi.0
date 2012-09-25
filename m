From: <sreekanth.reddy@lsi.com>
Subject: [PATCH][SCSI] mpt3sas: linux/miscdevice.h
Date: Tue, 25 Sep 2012 11:10:53 +0530
Message-ID: <20120925054052.GA14017@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:47669 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab2IYFj0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2012 01:39:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

Adding support for MPT3SAS_MINOR(222)

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 0549d211..9c9ba04 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -34,6 +34,7 @@
 #define MWAVE_MINOR		219	/* ACP/Mwave Modem */
 #define MPT_MINOR		220
 #define MPT2SAS_MINOR		221
+#define MPT3SAS_MINOR		222
 #define UINPUT_MINOR		223
 #define HPET_MINOR		228
 #define FUSE_MINOR		229
