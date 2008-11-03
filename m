From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 12/12] mpt2sas - miscdevice
Date: Mon, 3 Nov 2008 01:43:31 -0700
Message-ID: <20081103084328.GB3402@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40811 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYKCWhP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2008 17:37:15 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id mA3MW6Tw019699
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 14:32:06 -0800 (PST)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id mA3MbEoI008771
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 14:37:15 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adding mptsas support (pending approval from Torben Mathiasen).

Signed-off-by: Eric Moore <eric.moore@lsi.com>


--- a/include/linux/miscdevice.h	2008-11-03 11:38:20.000000000 -0700
+++ b/include/linux/miscdevice.h	2008-11-03 11:37:20.000000000 -0700
@@ -25,6 +25,7 @@
 #define MICROCODE_MINOR		184
 #define MWAVE_MINOR	219		/* ACP/Mwave Modem */
 #define MPT_MINOR	220
+#define MPT2SAS_MINOR	221
 #define MISC_DYNAMIC_MINOR 255
 
 #define TUN_MINOR	     200
