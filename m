From: domen@coderock.org
Subject: [patch 2/3] qla_os.c - vfree() checking cleanups
Date: Sun, 06 Mar 2005 23:27:59 +0100
Message-ID: <20050306222759.8A9C11EC90@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:431 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261539AbVCFW2K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:28:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, jlamanna@gmail.com



qla_os.c vfree() checking cleanups.

Signed-off by: James Lamanna <jlamanna@gmail.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/qla2xxx/qla_os.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~vfree-drivers_scsi_qla2xxx_qla_os drivers/scsi/qla2xxx/qla_os.c
--- kj/drivers/scsi/qla2xxx/qla_os.c~vfree-drivers_scsi_qla2xxx_qla_os	2005-03-05 16:10:37.000000000 +0100
+++ kj-domen/drivers/scsi/qla2xxx/qla_os.c	2005-03-05 16:10:37.000000000 +0100
@@ -3119,8 +3119,7 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	if (ha->fw_dump)
 		free_pages((unsigned long)ha->fw_dump, ha->fw_dump_order);
 
-	if (ha->fw_dump_buffer)
-		vfree(ha->fw_dump_buffer);
+	vfree(ha->fw_dump_buffer);
 
 	ha->fw_dump = NULL;
 	ha->fw_dump_reading = 0;
_
