From: Tomer Barletz <barletz@gmail.com>
Subject: [PATCH] scsi/be2iscsi: Fix logical-not-parentheses compilation warning
Date: Mon,  3 Aug 2015 15:35:57 -0700
Message-ID: <1438641357-25588-1-git-send-email-barletz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomer Barletz <barletz@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This fixes the following warning seen with GCC v5.1:
warning: logical not is only applied to the left hand side of
comparison [-Wlogical-not-parentheses].

Signed-off-by: Tomer Barletz <barletz@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7a6dbfb..ff8d40e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3184,7 +3184,7 @@ be_sgl_create_contiguous(void *virtual_address,
 {
 	WARN_ON(!virtual_address);
 	WARN_ON(!physical_address);
-	WARN_ON(!length > 0);
+	WARN_ON(0 == length);
 	WARN_ON(!sgl);
 
 	sgl->va = virtual_address;
-- 
2.4.3
