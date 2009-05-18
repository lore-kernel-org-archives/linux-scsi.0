From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH] mpt2sas: driver version incorrect for 2.6.30 kernel
Date: Mon, 18 May 2009 12:57:24 -0600
Message-ID: <20090518185722.GA26604@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:56978 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZERSvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2009 14:51:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Please consider for the 2.6.30 kernel.

The MPT2SAS_MAJOR_VERSION didn't get bumped from 00 to 01. The applications
will see it incorrectly as 00.100.02.00 driver instead of 01.100.02.00.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h	2009-05-18 12:05:21.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h	2009-05-18 12:05:21.000000000 -0600
@@ -69,7 +69,7 @@
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
 #define MPT2SAS_DRIVER_VERSION		"01.100.02.00"
-#define MPT2SAS_MAJOR_VERSION		00
+#define MPT2SAS_MAJOR_VERSION		01
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		02
 #define MPT2SAS_RELEASE_VERSION		00
