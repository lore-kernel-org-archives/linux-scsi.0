From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/10] mpt2sas : unique ioctl magic number
Date: Tue, 21 Apr 2009 15:37:20 -0600
Message-ID: <20090421213717.GB18563@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og61.obsmtp.com ([64.18.14.187]:50329 "EHLO
	chip3og61.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbZDUVfg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 17:35:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

The current magic number is shared with mptsas driver. This to be unique to
fix issues with register_ioctls32_conversion in older kernels.  We are making
this change across all versions of the sas2.0 drivers.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h	2009-03-16 08:52:29.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h	2009-04-09 16:31:35.000000000 -0600
@@ -50,7 +50,7 @@
 #endif
 
 #define MPT2SAS_DEV_NAME	"mpt2ctl"
-#define MPT2_MAGIC_NUMBER	'm'
+#define MPT2_MAGIC_NUMBER	'L'
 #define MPT2_IOCTL_DEFAULT_TIMEOUT (10) /* in seconds */
 
 /**
