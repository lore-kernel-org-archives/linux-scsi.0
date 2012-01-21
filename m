From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] mpt2sas : Fix typo in mpt2sas_config.c
Date: Sat, 21 Jan 2012 23:23:37 +0900
Message-ID: <1327155817-2620-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, standby24x7@gmail.com
List-Id: linux-scsi@vger.kernel.org

Correct spelling "mappping" to "mapping"
in drivers/scsi/mpt2sas/mpt2sas_config.c

Signed-off-by: Masanari Iida<standby24x7@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 36ea0b2..2b4d376 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -149,7 +149,7 @@ _config_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 			desc = "raid_config";
 			break;
 		case MPI2_CONFIG_EXTPAGETYPE_DRIVER_MAPPING:
-			desc = "driver_mappping";
+			desc = "driver_mapping";
 			break;
 		}
 		break;
-- 
1.7.6.5
