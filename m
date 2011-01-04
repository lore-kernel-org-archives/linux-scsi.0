From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Subject: declare MODULE_FIRMWARE in libsas
Date: Tue, 04 Jan 2011 15:43:27 +0800
Message-ID: <4D22CF9F.1070005@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060503040604030409070102"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:53695 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1ADHoK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 02:44:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060503040604030409070102
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>

---
 sas_scsi_host.c |    1 +
 1 file changed, 1 insertion(+)



--------------060503040604030409070102
Content-Type: text/x-patch;
 name="declare-firmware-in-libsas.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="declare-firmware-in-libsas.patch"

diff -up linux-2.6/drivers/scsi/libsas/sas_scsi_host.c.origfw linux-2.6/drivers/scsi/libsas/sas_scsi_host.c
--- linux-2.6/drivers/scsi/libsas/sas_scsi_host.c.origfw	2011-01-04 14:11:18.000000000 +0800
+++ linux-2.6/drivers/scsi/libsas/sas_scsi_host.c	2011-01-04 14:11:35.000000000 +0800
@@ -1110,6 +1110,7 @@ out:
 	release_firmware(fw);
 	return res;
 }
+MODULE_FIRMWARE("sas_addr");
 EXPORT_SYMBOL_GPL(sas_request_addr);
 
 EXPORT_SYMBOL_GPL(sas_queuecommand);

--------------060503040604030409070102--
