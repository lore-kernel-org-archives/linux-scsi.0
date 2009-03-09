From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 11/12] mpt2sas v00.100.11.15 : miscdevice
Date: Mon, 9 Mar 2009 01:27:49 -0600
Message-ID: <20090309072748.GL18720@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:57984 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZCIVH1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 17:07:27 -0400
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
