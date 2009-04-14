From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/13] mpt2sas: unique ioctl magic number
Date: Mon, 13 Apr 2009 22:27:20 -0600
Message-ID: <20090414042718.GB20124@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og57.obsmtp.com ([64.18.14.179]:35028 "EHLO
	chip3og57.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZDNSBj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 14:01:39 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EI1Rv8004251
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 11:01:27 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EI1VCo014528
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 11:01:31 -0700
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
