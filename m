From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: mpt3sas: fix spelling mistake "manufaucturing" -> "manufacturing"
Date: Wed, 28 Nov 2018 15:30:48 +0000
Message-ID: <20181128153048.13804-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in some description text, fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 8516713f980b..fb0a17252f86 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -119,7 +119,7 @@ _config_display_some_debug(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 		desc = "raid_volume";
 		break;
 	case MPI2_CONFIG_PAGETYPE_MANUFACTURING:
-		desc = "manufaucturing";
+		desc = "manufacturing";
 		break;
 	case MPI2_CONFIG_PAGETYPE_RAID_PHYSDISK:
 		desc = "physdisk";
-- 
2.19.1
