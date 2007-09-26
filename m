From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] SCSI: export sas_hash_addr()
Date: Wed, 26 Sep 2007 03:35:57 -0400
Message-ID: <20070926073557.GA22773@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:44110 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbXIZHf6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 03:35:58 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

sas_hash_addr() is the spec-defined standard hashing function.  Make it
available to drivers that need it.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 9cd5abe..13c3d21 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -314,3 +314,4 @@ module_exit(sas_class_exit);
 
 EXPORT_SYMBOL_GPL(sas_register_ha);
 EXPORT_SYMBOL_GPL(sas_unregister_ha);
+EXPORT_SYMBOL_GPL(sas_hash_addr);
