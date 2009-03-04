From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 10/11] mpt2sas v00.100.11.11 : miscdevice
Date: Tue, 3 Mar 2009 22:14:43 -0700
Message-ID: <20090304051440.GM4194@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:39716 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbZCDSzG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 13:55:06 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n24It2FU006204
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 10:55:02 -0800 (PST)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n24It6bN015871
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 10:55:06 -0800
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
