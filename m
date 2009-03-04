From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 11/11] mpt2sas v00.100.11.11 : miscdevice
Date: Tue, 3 Mar 2009 22:19:46 -0700
Message-ID: <20090304051944.GA4281@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:46583 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZCDTAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 14:00:09 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n24J05aS006895
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 11:00:05 -0800 (PST)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n24J09AH017524
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 11:00:09 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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
