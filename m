From: Brian King <brking@us.ibm.com>
Subject: [PATCH 04/10] ipr: Set default ipr Kconfig values
Date: Tue, 21 Nov 2006 10:28:16 -0600
Message-ID: <200611211628.kALGSHTt003336@d01av01.pok.ibm.com>
References: <11641264771784-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54924 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1031135AbWKUQhd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 11:37:33 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALGaJXi003697
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:37:30 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALGSIns039792
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:19 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALGSHtT003397
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:18 -0500
In-Reply-To: <11641264771784-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Both SCSI_IPR_TRACE and SCSI_IPR_DUMP should be defaulted to
yes when SCSI_IPR is enabled.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/Kconfig |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/Kconfig~ipr_kconfig_defaults drivers/scsi/Kconfig
--- linux-2.6/drivers/scsi/Kconfig~ipr_kconfig_defaults	2006-11-09 17:11:58.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/Kconfig	2006-11-09 17:11:58.000000000 -0600
@@ -1026,6 +1026,7 @@ config SCSI_IPR
 config SCSI_IPR_TRACE
 	bool "enable driver internal trace"
 	depends on SCSI_IPR
+	default y
 	help
 	  If you say Y here, the driver will trace all commands issued
 	  to the adapter. Performance impact is minimal. Trace can be
@@ -1034,6 +1035,7 @@ config SCSI_IPR_TRACE
 config SCSI_IPR_DUMP
 	bool "enable adapter dump support"
 	depends on SCSI_IPR
+	default y
 	help
 	  If you say Y here, the driver will support adapter crash dump.
 	  If you enable this support, the iprdump daemon can be used
_
