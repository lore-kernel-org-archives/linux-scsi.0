From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 2/4] scsi: zalon: constify parisc_device_id
Date: Sat, 19 Aug 2017 23:24:21 +0530
Message-ID: <1503165261-31741-3-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503165261-31741-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503165261-31741-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, deller@gmx.de, gregkh@linuxfoundation.org, jslaby@suse.com
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

parisc_device_id are not supposed to change at runtime. All functions
working with parisc_device_id provided by <asm/parisc-device.h> work
with const parisc_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/zalon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index b2cf1fa..00c7c28 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -160,7 +160,7 @@ zalon_probe(struct parisc_device *dev)
 	return error;
 }
 
-static struct parisc_device_id zalon_tbl[] = {
+static const struct parisc_device_id zalon_tbl[] = {
 	{ HPHW_A_DMA, HVERSION_REV_ANY_ID, HVERSION_ANY_ID, 0x00089 }, 
 	{ 0, }
 };
-- 
2.7.4
