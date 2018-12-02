From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] scsi: csiostor: NULL check before some freeing functions
 is not needed.
Date: Sun, 02 Dec 2018 21:52:11 +0100
Message-ID: <1543760930051-584546236-8-diffsplit-thomas@m3y3r.de>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NULL check before some freeing functions is not needed.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -157,8 +157,7 @@ csio_dfs_create(struct csio_hw *hw)
 static int
 csio_dfs_destroy(struct csio_hw *hw)
 {
-	if (hw->debugfs_root)
-		debugfs_remove_recursive(hw->debugfs_root);
+	debugfs_remove_recursive(hw->debugfs_root);
 
 	return 0;
 }
