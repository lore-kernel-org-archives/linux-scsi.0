From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] scsi: aha1542: constify pnp_device_id
Date: Wed, 16 Aug 2017 10:29:24 +0530
Message-ID: <d2863c89b54410bbf26e455fac4d61fb63f8641c.1502859040.git.arvind.yadav.cs@gmail.com>
References: <60c34272432b3411cd5d55728c62481e133f32a6.1502859040.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <60c34272432b3411cd5d55728c62481e133f32a6.1502859040.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pnp_device_id are not supposed to change at runtime. All functions
working with pnp_device_id provided by <linux/pnp.h> work with
const pnp_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/aha1542.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index a23cc9a..1242179 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -986,7 +986,7 @@ static struct isa_driver aha1542_isa_driver = {
 static int isa_registered;
 
 #ifdef CONFIG_PNP
-static struct pnp_device_id aha1542_pnp_ids[] = {
+static const struct pnp_device_id aha1542_pnp_ids[] = {
 	{ .id = "ADP1542" },
 	{ .id = "" }
 };
-- 
2.7.4
