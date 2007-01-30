From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 01/12] sas_ata: Require CONFIG_ATA in Kconfig
Date: Tue, 30 Jan 2007 01:18:33 -0800
Message-ID: <20070130091833.31530.25744.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38787 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965429AbXA3JQB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:01 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9FxHn005583
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:15:59 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9FxJH289994
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:15:59 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9FxZ5010266
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:15:59 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index aafdc92..b64e391 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -24,7 +24,7 @@ #
 
 config SCSI_SAS_LIBSAS
 	tristate "SAS Domain Transport Attributes"
-	depends on SCSI
+	depends on SCSI && ATA
 	select SCSI_SAS_ATTRS
 	help
 	  This provides transport specific helpers for SAS drivers which
