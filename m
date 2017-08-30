From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [SCSI] esas2r: make default_sas_nvram const
Date: Wed, 30 Aug 2017 14:40:14 +0530
Message-ID: <1504084214-11762-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, linuxdrivers@attotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Make this const as it is never modified.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/scsi/esas2r/esas2r_flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index 7bd376d..f8414b5 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -54,7 +54,7 @@
 
 #define ESAS2R_FS_DRVR_VER 2
 
-static struct esas2r_sas_nvram default_sas_nvram = {
+static const struct esas2r_sas_nvram default_sas_nvram = {
 	{ 'E',	'S',  'A',  'S'			     }, /* signature          */
 	SASNVR_VERSION,                                 /* version            */
 	0,                                              /* checksum           */
-- 
1.9.1
