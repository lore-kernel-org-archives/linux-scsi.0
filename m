From: domen@coderock.org
Subject: [patch 1/1] qla_os.c - vfree() checking cleanups
Date: Mon, 20 Jun 2005 23:55:00 +0200
Message-ID: <20050620215459.933953000@nd47.coderock.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:53402 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262142AbVFTWCJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 18:02:09 -0400
Content-Disposition: inline; filename=vfree-drivers_scsi_qla2xxx_qla_os.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org

From: jlamanna@gmail.com



qla_os.c vfree() checking cleanups.

Signed-off by: James Lamanna <jlamanna@gmail.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---
 qla_os.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

Index: quilt/drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- quilt.orig/drivers/scsi/qla2xxx/qla_os.c
+++ quilt/drivers/scsi/qla2xxx/qla_os.c
@@ -1855,8 +1855,7 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	if (ha->fw_dump)
 		free_pages((unsigned long)ha->fw_dump, ha->fw_dump_order);
 
-	if (ha->fw_dump_buffer)
-		vfree(ha->fw_dump_buffer);
+	vfree(ha->fw_dump_buffer);
 
 	ha->fw_dump = NULL;
 	ha->fw_dump_reading = 0;

--
