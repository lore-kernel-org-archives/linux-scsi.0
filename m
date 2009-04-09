From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/4] mpt2sas: unique ioctl magic number
Date: Thu, 9 Apr 2009 03:40:25 -0600
Message-ID: <20090409094023.GA7063@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og59.obsmtp.com ([64.18.14.183]:46396 "EHLO
	chip3og59.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937453AbZDIXjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 19:39:33 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n39NFOak027925
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2009 16:15:24 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n39NFGKZ029888
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2009 16:15:25 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The current magic number is shared with mptsas driver. This to be unique to
fix issues with register_ioctls32_conversion in older kernels.  We are making
this change across all versions of the sas2.0 drivers.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h	2009-04-09 16:45:18.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h	2009-04-09 16:45:31.000000000 -0600
@@ -50,7 +50,7 @@
 #endif
 
 #define MPT2SAS_DEV_NAME	"mpt2ctl"
-#define MPT2_MAGIC_NUMBER	'm'
+#define MPT2_MAGIC_NUMBER	'L'
 #define MPT2_IOCTL_DEFAULT_TIMEOUT (10) /* in seconds */
 
 /**
