From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] scsi_dh_alua: fix build warning
Date: Fri, 11 Dec 2015 14:06:03 +0530
Message-ID: <1449822963-9054-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

We were getting build warning about unused variables "vpd_pg83" and "d"

Fixes: 83ea0e5e3501 ("scsi_dh_alua: use scsi_vpd_tpg_id()")
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
build warning with next-20151211 and build log is at:
https://travis-ci.org/sudipm-mukherjee/parport/jobs/96209206
---

 drivers/scsi/device_handler/scsi_dh_alua.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f100cbb..5a328bf 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -320,8 +320,6 @@ static int alua_check_tpgs(struct scsi_device *sdev)
  */
 static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	unsigned char *d;
-	unsigned char __rcu *vpd_pg83;
 	int rel_port = -1, group_id;
 
 	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
-- 
1.9.1
