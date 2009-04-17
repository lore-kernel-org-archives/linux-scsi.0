From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/14 - 2nd post] mpt2sas: unique ioctl magic number
Date: Fri, 17 Apr 2009 10:25:02 -0600
Message-ID: <20090417162501.GB7009@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og63.obsmtp.com ([64.18.14.203]:60888 "EHLO
	chip3og63.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761977AbZDQQX5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 12:23:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

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
