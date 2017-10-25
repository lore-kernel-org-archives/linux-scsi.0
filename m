From: Jeffy Chen <jeffy.chen@rock-chips.com>
Subject: [PATCH] scsi: .gitignore: Add scsi_devinfo_tbl.c
Date: Wed, 25 Oct 2017 15:39:10 +0800
Message-ID: <20171025073910.1735-1-jeffy.chen@rock-chips.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, hare@suse.de, bart.vanassche@wdc.com, jthumshirn@suse.de, martin.petersen@oracle.com
Cc: Jeffy Chen <jeffy.chen@rock-chips.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Add generated scsi_devinfo_tbl.c into .gitignore.

Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
---

 drivers/scsi/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/.gitignore b/drivers/scsi/.gitignore
index c89ae9a04399..e2956741fbd1 100644
--- a/drivers/scsi/.gitignore
+++ b/drivers/scsi/.gitignore
@@ -1 +1,2 @@
 53c700_d.h
+scsi_devinfo_tbl.c
-- 
2.11.0
