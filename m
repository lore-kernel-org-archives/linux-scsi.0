From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 2/3] scsi: ibmvscsi: constify vio_device_id
Date: Thu, 17 Aug 2017 19:15:06 +0530
Message-ID: <1502977507-2954-2-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502977507-2954-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502977507-2954-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tyreld@linux.vnet.ibm.com, paulus@samba.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mpe@ellerman.id.au
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

vio_device_id are not supposed to change at runtime. All functions
working with vio_device_id provided by <asm/vio.h> work with
const vio_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index da22b36..7d156b161 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2330,7 +2330,7 @@ static int ibmvscsi_resume(struct device *dev)
  * ibmvscsi_device_table: Used by vio.c to match devices in the device tree we 
  * support.
  */
-static struct vio_device_id ibmvscsi_device_table[] = {
+static const struct vio_device_id ibmvscsi_device_table[] = {
 	{"vscsi", "IBM,v-scsi"},
 	{ "", "" }
 };
-- 
2.7.4
