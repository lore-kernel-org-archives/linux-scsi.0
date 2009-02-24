From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 11/11] mpt2sas: linux/miscdevice.h
Date: Tue, 24 Feb 2009 02:42:48 -0700
Message-ID: <20090224094246.GB11845@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:35361 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbZBXXYX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 18:24:23 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

linux/miscdevice.h

Adding suport for MPT2SAS_MINOR(221)

Signed-off-by: Eric Moore <eric.moore@lsi.com>
---

--- a/include/linux/miscdevice.h	2008-11-03 11:38:20.000000000 -0700
+++ b/include/linux/miscdevice.h	2008-11-03 11:37:20.000000000 -0700
@@ -25,6 +25,7 @@
 #define MICROCODE_MINOR		184
 #define MWAVE_MINOR	219		/* ACP/Mwave Modem */
 #define MPT_MINOR	220
+#define MPT2SAS_MINOR	221
 #define MISC_DYNAMIC_MINOR 255
 
 #define TUN_MINOR	     200
