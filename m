From: <sreekanth.reddy@lsi.com>
Subject: [RESEND][PATCH 20/20][SCSI] mpt3sas: Adding support for
 MPT3SAS_MINOR(222)
Date: Sat, 29 Sep 2012 19:51:33 +0530
Message-ID: <20120929142133.GA20854@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:45195 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab2I2UeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2012 16:34:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

Adding support for MPT3SAS_MINOR(222)

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
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
