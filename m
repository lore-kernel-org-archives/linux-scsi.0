From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 1/4] scsi: lasi700: constify parisc_device_id
Date: Sat, 19 Aug 2017 23:24:20 +0530
Message-ID: <1503165261-31741-2-git-send-email-arvind.yadav.cs@gmail.com>
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
 drivers/scsi/lasi700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index 5c4ded9..4e2b0e0 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -81,7 +81,7 @@ MODULE_LICENSE("GPL");
 #define LASI710_CLOCK	40
 #define LASI_SCSI_CORE_OFFSET 0x100
 
-static struct parisc_device_id lasi700_ids[] = {
+static const struct parisc_device_id lasi700_ids[] = {
 	LASI700_ID_TABLE,
 	LASI710_ID_TABLE,
 	{ 0 }
-- 
2.7.4
